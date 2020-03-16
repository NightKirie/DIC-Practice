module FAS(
       clk, 
       rst, 
       data_valid, 
       data, 
       fft_d0,fft_d1,fft_d2,fft_d3,fft_d4,fft_d5,fft_d6,fft_d7,
       fft_d8,fft_d9,fft_d10,fft_d11,fft_d12,fft_d13,fft_d14,fft_d15,
       fft_valid,
       done,
       freq
       );
       
input	clk;
input	rst;
input	data_valid;
input signed [15:0] data;

output reg [31:0] fft_d0,fft_d1,fft_d2,fft_d3,fft_d4,fft_d5,fft_d6,fft_d7, 
              fft_d8,fft_d9,fft_d10,fft_d11,fft_d12,fft_d13,fft_d14,fft_d15;
output reg fft_valid;
output reg done;                      
output reg [3:0] freq;

reg [2:0] curr_state, next_state;
reg [3:0] counter;
reg signed [15:0] buffer [0:15];

parameter w0_r = 32’h00010000, w0_i = 32’h00000000;
parameter w1_r = 32’h0000EC83, w1_i = 32’hFFFF9E09;
parameter w2_r = 32’h0000B504, w2_i = 32’hFFFF4AFC;
parameter w3_r = 32’h000061F7, w3_i = 32’hFFFF137D;
parameter w4_r = 32’h00000000, w4_i = 32’hFFFF0000;
parameter w5_r = 32’hFFFF9E09, w5_i = 32’hFFFF137D;
parameter w6_r = 32’hFFFF4AFC, w6_i = 32’hFFFF4AFC;
parameter w7_r = 32’hFFFF137D, w7_i = 32’hFFFF9E09;


parameter LOAD = 3'b000;
parameter CAL_FFT = 3'b001;

always @(posedge clk ) begin
	if(rst) begin
		done <= 0; 
		fft_valid <= 0;
		freq <= 0;
		
		counter <= 0;

		curr_state <= LOAD;
	end
	else begin
		curr_state <= next_state;
		case (curr_state)
			LOAD: begin
				done <= 0;
				if(data_valid) begin
					buffer[counter] <= data;
					counter <= (counter == 4'd15) ? 0 : counter + 1;
				end
			end 
			CAL_FFT: begin
				done <= 1;
			end
			//default: 
		endcase
	end
end

always @(*) begin
	case (curr_state)
		LOAD: begin
			next_state = (counter == 4'd15) ? CAL_FFT : LOAD;
		end 
		CAL_FFT: begin
			next_state = LOAD;
		end
		//default: 
	endcase 
end

endmodule

module bfly2_4(x,y,wr,wi,x0r,x0i,x1r,x1i);

input signed [8:0]x,y;
input signed [8:0]wr,wi;

output[8:0]x0r,x0i,x1r,x1i;

wire [17:0]p1,p2;

assign p1=wr*y;
assign p2=wi*y;
assign x0r=x+p1[8:0];
assign x0i=p2[8:0];
assign x1r=x-p1[8:0];
assign x1i=-p2[8:0];

endmodule

module bfly4_4(xr,xi,yr,yi,wr,wi,x0r,x0i,x1r,x1i);

input signed [8:0]xr,xi,yr,yi;
input signed [8:0]wr,wi;

output [8:0]x0r,x0i,x1r,x1i;

wire [17:0]p1,p2,p3,p4;

assign p1=wr*yr;
assign p2=wi*yi;
assign p3=wr*yi;
assign p4=wi*yr;
assign x0r=xr+p1[17:8]-p2[17:8];
assign x0i=xi+p3[17:8]+p4[17:8];
assign x1r=xr-p1[17:8]+p2[17:8];
assign x1i=xi-p3[17:8]-p4[17:8];

endmodule
