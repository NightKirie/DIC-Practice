`timescale 1ns/10ps

module  CONV(
	input clk,
	input reset,
	output reg busy,	
	input ready,	
			
	output reg [11:0] iaddr,
	input [19:0] idata,	
	
	output reg cwr,
	output reg [11:0] caddr_wr,
	output reg [19:0] cdata_wr,
	
	output reg crd,
	output reg [11:0] caddr_rd,
	input [19:0] cdata_rd,
	
	output reg [2:0] csel
);

reg [2:0] curr_state, next_state;
reg [3:0] counter;
reg [11:0] curr_addr;
reg signed [19:0] buffer [0:8], conv_block, conv_ker;
reg signed [39:0] conv_sum;

parameter NO_MEM_SEL = 3'b000;
parameter RW_LAYER0 = 3'b001;
parameter RW_LAYER1 = 3'b011;

parameter WAIT = 3'b000;
parameter LOAD = 3'b001;
parameter CONVOLUTION = 3'b010;
parameter RELU = 3'b011;
parameter MAXPOOL = 3'b100;

parameter signed ker0 = 20'h0A89E;
parameter signed ker1 = 20'h092D5;
parameter signed ker2 = 20'h06D43;
parameter signed ker3 = 20'h01004;
parameter signed ker4 = 20'hF8F71;
parameter signed ker5 = 20'hF6E54;
parameter signed ker6 = 20'hFA6D7;
parameter signed ker7 = 20'hFC834;
parameter signed ker8 = 20'hFAC19;

parameter signed bias = 40'h0013100000;

wire [39:0] conv_ans = conv_block * conv_ker;
wire [19:0] max_top = (buffer[0] > buffer[1]) ? buffer[0] : buffer[1];
wire [19:0] max_bottom = (buffer[2] > buffer[3]) ? buffer[2] : buffer[3];
wire [19:0] max_all = (max_top > max_bottom) ? max_top : max_bottom; 


always @(posedge clk) begin
	if(reset) begin
		busy <= 0;
		curr_addr <= 12'd0;
		caddr_wr <= 12'd0;
		caddr_rd <= 12'd0;
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
				cwr <= 0;
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
							if(curr_addr[11:6] == 6'd0) begin
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
							iaddr <= (curr_addr[11:6] == 6'd0) ? 12'd1 : curr_addr - 12'd63;
						end				 
					endcase
					counter <= (counter == 4'd8) ? 4'd0 : counter + 4'd1;
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

							iaddr <= (curr_addr[5:0] == 6'd63) ? iaddr : iaddr + 12'd1;
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
							if(curr_addr[11:6] == 6'd63 || curr_addr[5:0] == 6'd63) begin
								buffer[8] <= 20'd0;
								iaddr <= curr_addr - 12'd63;
							end
							else begin
								buffer[8] <= idata;
								iaddr <= (curr_addr[11:6] == 6'd0) ? curr_addr + 12'd1 : curr_addr - 12'd63;
							end
						end
					endcase
					counter <= (counter == 4'd3) ? 4'd0 : counter + 4'd1;
				end
			end
			CONVOLUTION: begin
				case (counter)
					4'd0: begin
						conv_block = buffer[0];
						conv_ker = ker0;
					end
					4'd1: begin
						conv_block = buffer[1];
						conv_ker = ker1;
					end
					4'd2: begin
						conv_block = buffer[2];
						conv_ker = ker2;
					end
					4'd3: begin
						conv_block = buffer[3];
						conv_ker = ker3;
					end
					4'd4: begin
						conv_block = buffer[4];
						conv_ker = ker4;
					end
					4'd5: begin
						conv_block = buffer[5];
						conv_ker = ker5;
					end
					4'd6: begin
						conv_block = buffer[6];
						conv_ker = ker6;
					end
					4'd7: begin
						conv_block = buffer[7];
						conv_ker = ker7;
					end
					4'd8: begin
						conv_block = buffer[8];
						conv_ker = ker8;
					end
				endcase
				counter <= (counter == 4'd9) ? 4'd0 : counter + 4'd1;
				conv_sum <= (counter == 4'd0) ? bias : conv_sum + conv_ans;
			end
			RELU: begin
				cwr <= 1;
				cdata_wr <= (conv_sum[39]) ? 20'd0 : ((conv_sum[15]) ? conv_sum[35:16] + 20'h00001 : conv_sum[35:16]);
				csel <= 3'b001;
				curr_addr <= curr_addr + 12'd1;
				caddr_wr <= curr_addr;
				if(curr_addr == 12'd4095) begin
					crd <= 1;
					csel <= 3'b001;
				end
			end
			MAXPOOL: begin
				case(counter) 
					4'd0, 4'd2: begin
						buffer[counter] <= cdata_rd;
						caddr_rd <= caddr_rd + 12'd1;
					end
					4'd1: begin
						buffer[1] <= cdata_rd;
						caddr_rd <= caddr_rd + 12'd63;
					end
					4'd3: begin
						buffer[3] <= cdata_rd;
					end
					// Output to layer 1
					4'd4: begin
						csel <= 3'b011;
						cwr <= 1;
						cdata_wr <= max_all;
						caddr_wr <= caddr_wr + 12'd1;
					end
					// Ready to get input from layer 0
					4'd5: begin
						csel <= 3'b001;
						cwr <= 0;
						caddr_rd <= (caddr_rd[5:0] == 6'd63) ? caddr_rd + 12'd1 : caddr_rd - 12'd63;
						busy <= (caddr_wr == 12'd1023) ? 0 : 1;
					end
				endcase
				counter <= (counter == 4'd5) ? 4'd0 : counter + 4'd1;
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
				next_state = (counter == 4'd8) ? CONVOLUTION: LOAD;
			else
				next_state = (counter == 4'd3) ? CONVOLUTION: LOAD;
		end
		CONVOLUTION: begin
			next_state = (counter == 4'd9) ? RELU: CONVOLUTION;
		end
		RELU: begin
			next_state = (curr_addr == 12'd4095) ? MAXPOOL : LOAD;
		end
		MAXPOOL: begin
			next_state = (caddr_wr == 12'd1023 && counter == 4'd5) ? WAIT : MAXPOOL;
		end
		default: begin
			next_state = WAIT;
		end
	endcase
end

endmodule




