module triangle (clk, reset, nt, xi, yi, busy, po, xo, yo);

input clk, reset, nt;
input [2:0] xi, yi;

output reg busy, po;
output reg [2:0] xo, yo;

reg [2:0] curr_state;
reg [2:0] x[0:2], y[0:2];
reg input_flag;

parameter Idle = 3'b000;
parameter Reset = 3'b001;
parameter Input = 3'b010;
parameter Calculate = 3'b011;
parameter Output = 3'b100;

integer i;



always@(posedge clk, posedge reset) begin
	if(reset) begin
		curr_state <= Reset;
	end
	else begin
		case(curr_state) 
			Idle: begin
				if (reset)
					curr_state <= Reset;
				else
					curr_state <= Idle;
			end
			Reset: begin
				if (nt)
					curr_state <= Input;
				else
					curr_state <= Idle;
			end
			Input: begin
				if (!input_flag) 
					curr_state <= Calculate;
				else
					curr_state <= Input;
			end
			Calculate: begin
				if (!calculate_flag)
					curr_state <= Output;
				else
					curr_state <= Calculate;
			end
			Output: begin
				if (!output_flag)
					curr_state <= Idle;
				else
					curr_state <= Output;
			end
			default: begin
				curr_state <= Idle;
			end
		endcase
	end
end


always@(*) begin
	case(curr_state) 
		Idle: begin
			
		end
		Reset: begin
			
		end
		Input: begin
			
		end
		Calculate: begin
			
		end
		Output: begin
			
		end
	endcase
end
                   

endmodule
