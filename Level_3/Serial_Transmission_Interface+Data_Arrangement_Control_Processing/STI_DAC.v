module STI_DAC(clk ,reset, load, pi_data, pi_length, pi_fill, pi_msb, pi_low, pi_end,
	       so_data, so_valid,
	       pixel_finish, pixel_dataout, pixel_addr,
	       pixel_wr);

input clk, reset;
input load, pi_msb, pi_low, pi_end; 
input [15:0] pi_data;
input [1:0]	pi_length;
input pi_fill;

output reg so_data, so_valid;
output reg pixel_finish, pixel_wr;
output reg [7:0] pixel_addr;
output reg [7:0] pixel_dataout;

reg [2:0] curr_state, next_state;
reg [7:0] buffer [0:256];

parameter LOAD = 3'b000;
parameter PIXEL_MEM = 3'b001;


parameter Bit_8 = 2'b00;
parameter Bit_16 = 2'b01;
parameter Bit_24 = 2'b10;
parameter Bit_32 = 2'b11;

always @(posedge clk) begin
	if(reset) begin
		so_valid <= 0;
		pixel_finish <= 0;
		pixel_wr <= 0;
	end
	else begin
		curr_state <= next_state;
		case (curr_state)
			LOAD: 
				if(load) begin
					case (pi_length)
						Bit_8:  begin
							
						end
						Bit_16: begin
							
						end
						Bit_24: begin
							
						end
						Bit_32: begin
							
						end	 
					endcase
				end
			default: 
		endcase
	end
end


always @(*) begin
	case(curr_state) 
		default: 
			next_state = (load == 1) ? LOAD : curr_state;	
	endcase
end

endmodule
