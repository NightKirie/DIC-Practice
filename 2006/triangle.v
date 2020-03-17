module triangle (clk, reset, nt, xi, yi, busy, po, xo, yo);

input clk, reset, nt;
input [2:0] xi, yi;

output reg busy, po;
output reg [2:0] xo, yo;

reg curr_state, input_flag;
reg [2:0] buffer_x[0:2], buffer_y[0:2];
reg [1:0] input_count;
reg [2:0] curr_x, curr_y;
reg signed [7:0] slope, a, b;

parameter Input = 1'b0;
parameter Output = 1'b1;

integer i;

always@(posedge clk, posedge reset) begin
	if(reset) begin
		busy <= 0;
		po <= 0;
		xo <= 0;
		yo <= 0;

		for(i = 0; i < 3; i = i+1) begin
			buffer_x[i] <= 0;
			buffer_y[i] <= 0;
		end
		input_count <= 0;

		curr_state <= Input;
	end
	else begin
		case(curr_state) 
			Input: begin
				po <= 0;
				busy <= 0;
				if(nt || input_flag) begin
					buffer_x[input_count] <= xi;
					buffer_y[input_count] <= yi;
					case(input_count) 
						2'd0: begin
							input_count <= input_count + 1;
							busy <= 0;	
							input_flag <= 1;
						end
						2'd1: begin
							input_count <= input_count + 1;
							busy <= 1;
							input_flag <= 1;
						end
						2'd2: begin
							input_count <= 0;
							busy <= 1;
							input_flag <= 0;
							curr_x <= buffer_x[0];
							curr_y <= buffer_y[0];
							curr_state <= Output;
							
						end
					endcase
				end
			end
			Output: begin
				/* if (curr_x, curr_y) = (x3, y3) */
				if(curr_x == buffer_x[2] && curr_y == buffer_y[2]) begin
					xo <= curr_x;
					yo <= curr_y;
					po <= 1;
					
					curr_state <= Input;
				end
				else begin
					/* This point is at right side of the slope, move up to next point */
					if(slope > 0) begin
						po <= 0;
						curr_x <= buffer_x[2];
						curr_y <= curr_y + 1;
					end 
					/* This point is inside the triangle, move right to next point */
					else begin
						po <= 1;
						xo <= curr_x;
						yo <= curr_y;
						/* If this point is on the line, move up to next point */
						if(slope == 0) begin
							curr_x <= buffer_x[2];
							curr_y <= curr_y + 1;
						end
						/* Else move right to next point */
						else
							curr_x <= curr_x + 1;
					end
				end
			end
		endcase
	end
end

always@(*) begin
	case(curr_state) 	
		Output: begin
			slope = (curr_x - buffer_x[1]) * (buffer_y[2] - buffer_y[1]) - (curr_y - buffer_y[1]) * (buffer_x[2] - buffer_x[1]);
			a = (curr_x - buffer_x[1]) * (buffer_y[2] - buffer_y[1]);
			b = (curr_y - buffer_y[1]) * (buffer_x[2] - buffer_x[1]);
		end
		default: begin
			slope = 0;
		end
	endcase
end
                   

endmodule
