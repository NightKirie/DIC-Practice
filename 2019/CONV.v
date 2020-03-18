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
reg [3:0] count;
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
		iaddr <= 12'd0;
		crd <= 0;
		cwr <= 0;
		csel <= 3'b0;

		count <= 4'd0;

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
				buffer[iaddr] <= idata;
				iaddr <= iaddr + 12'd1;
				count <= (count == 4'd8) ? 0 : count+1;
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
			next_state = (count == 4'd8)  ? CONVO: LOAD;
		end

	endcase
end

endmodule




