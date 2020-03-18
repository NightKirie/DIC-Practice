`timescale 1ns/10ps

module  CONV(
	input clk,
	input reset,
	input ready,	
	input [19:0] idata,	
	input [19:0] cdata_rd,

	output reg busy,	
	output reg [11:0] iaddr,
	output reg cwr,
	output reg [11:0] caddr_wr,
	output reg [19:0] cdata_wr,
	output reg crd,
	output reg [11:0] caddr_rd,
	output reg [2:0] csel
);

reg [2:0] curr_state, next_state;
reg [3:0] counter;
reg [11:0] curr_addr;
reg [19:0] buffer [0:8];

parameter NO_MEM_SEL = 3'b000;
parameter RW_LAYER0 = 3'b001;
parameter RW_LAYER1 = 3'b011;

parameter WAIT = 3'b000;
parameter LOAD = 3'b001;
parameter CONVO = 3'b010;
parameter RELU = 3'b011;
parameter MAXPOOL = 3'b100;

parameter ker0 = 20'h0A98E;
parameter ker1 = 20'h092D5;
parameter ker2 = 20'h06D43;
parameter ker3 = 20'h01004;
parameter ker4 = 20'hF8F71;
parameter ker5 = 20'hF6E54;
parameter ker6 = 20'hFA6D7;
parameter ker7 = 20'hFC834;
parameter ker8 = 20'hFAC19;


always @(posedge clk) begin
	if(reset) begin
		busy <= 0;
		curr_addr <= 12'd0;
		iaddr <= 12'd0;
		crd <= 0;
		cwr <= 0;
		csel <= 3'b0;

		counter <= 4'd0;

		curr_state <= WAIT;
	end
	else begin
		curr_state <= next_state;
		case (curr_state)
			WAIT: begin
				if(ready) begin
					busy <= 1;
				end
			end
			LOAD: begin
				// Can't reuse 
				if(curr_addr[5:0] == 6'd0) begin
					case (counter)
						4'd0, 4'd3, 4'd6: begin
							buffer[counter] <= 20'd0;
						end 
						4'd1: begin
							if(curr_addr[11:6] == 6'd0) begin
								buffer[1] <= 20'd0;
							end
							else begin
								buffer[1] <= idata;
								iaddr <= iaddr + 12'd1;
							end
						end
						4'd2: begin
							if(iaddr[11:6] == 6'd0) begin
								buffer[2] <= 20'd0;
							end
							else begin
								buffer[2] <= idata;
								iaddr <= iaddr + 12'd63;
							end
						end
						4'd4: begin
							buffer[4] <= idata;
							iaddr <= iaddr + 12'd1;
						end
						4'd5: begin
							buffer[5] <= idata;
							iaddr <= (curr_addr[11:6] == 6'd63) ? iaddr : iaddr + 12'd63;
						end
						4'd7: begin
							if(curr_addr[11:6] == 6'd63) begin
								buffer[7] <= 20'd0;
							end
							else begin
								buffer[7] <= idata;
								iaddr <= iaddr + 12'd1;
							end
						end
						4'd8: begin
							buffer[8] <= (curr_addr[11:6] == 6'd63) ? 20'd0 : idata;
							curr_addr <= curr_addr + 12'd1;
						end					 
					endcase
					counter <= (counter == 4'd8) ? 4'd0 : counter + 1;
				end
				// Can reuse
				else begin
					case(counter)
						4'd0: begin
							buffer[0] <= buffer[1];
							buffer[1] <= buffer[2];
							buffer[3] <= buffer[4];
							buffer[4] <= buffer[5];
							buffer[6] <= buffer[7];
							buffer[7] <= buffer[8];

							iaddr <= (curr_addr[5:0] == 6'd63) ? curr_addr : curr_addr + 12'd1;
						end
						4'd1: begin
							if(curr_addr[11:6] == 6'd0) begin
								buffer[2] <= 20'd0;
							end
							else begin
								buffer[2] <= (curr_addr[5:0] == 6'd63) ? 20'd0 : idata;
								iaddr <= iaddr + 12'd64;
							end
						end
						4'd2: begin
							if(curr_addr[5:0] == 6'd63) begin
								buffer[5] <= 20'd0;
							end
							else begin
								buffer[5] <= idata;
								iaddr <= (curr_addr[11:6] == 6'd63) ? iaddr : iaddr + 12'd64;
							end
						end
						4'd3: begin
							if(curr_addr[11:6] == 6'd0) begin
								buffer[7] <= 20'd0;
							end
							else if(curr_addr[5:0] == 6'd63) begin
								buffer[7] <= 20'd0;
								iaddr <= curr_addr - 12'd63;
							end
							else begin
								buffer[7] <= idata;
								iaddr <= curr_addr - 12'd64;
							end
						end
					endcase
					counter <= (counter == 4'd3) ? 4'd0 : counter + 1;
				end
			end
		endcase
	end
end

always @(*) begin
	case (curr_state)
		WAIT: begin
			next_state = (ready) ? LOAD : WAIT;
		end
		LOAD: begin
			if(curr_addr[5:0] == 6'd0)
				next_state = (counter == 4'd8) ? CONVO: LOAD;
			else
				next_state = (counter == 4'd2) ? CONVO: LOAD;
		end
		CONVO: next_state = LOAD;
	endcase
end

endmodule




