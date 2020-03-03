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

reg [1:0] curr_state, next_state;
reg [4:0] bit_counter, output_length, index;
reg [7:0] pixel_counter;
reg [31:0] so_buffer;

parameter WAIT = 2'b00;
parameter LOAD = 2'b01;
parameter SO_OUT = 2'b10;
parameter FILL_PIXEL = 2'b11;

parameter Bit_8 = 2'b00;
parameter Bit_16 = 2'b01;
parameter Bit_24 = 2'b10;
parameter Bit_32 = 2'b11;

always @(posedge clk) begin
	if(reset) begin
		so_valid <= 0;
		pixel_finish <= 0;
		pixel_wr <= 0;
		pixel_dataout <= 0;
		pixel_addr <= 0;

		pixel_counter <= 0;
		curr_state <= WAIT;
	end
	else begin
		curr_state <= next_state;
		case (curr_state)
			WAIT: begin
				so_valid <= 0;
			end
			LOAD: begin
				case (pi_length)
					Bit_8:  begin
						bit_counter <= 7;
						output_length <= 7;
						so_buffer <= (pi_low) ? pi_data[15:8] : pi_data[7:0];
					end
					Bit_16: begin
						bit_counter <= 15;
						output_length <= 15;
						so_buffer <= pi_data;
					end
					Bit_24: begin
						bit_counter <= 23;
						output_length <= 23;
						so_buffer <= (pi_fill) ? {pi_data, 8'b0} : {8'b0, pi_data};
					end
					Bit_32: begin
						bit_counter <= 31;
						output_length <= 31;
						so_buffer <= (pi_fill) ? {pi_data, 16'b0} : {16'b0, pi_data};
					end	 
				endcase
			end
			SO_OUT: begin
				so_valid <= 1;
				so_data <= so_buffer[index];
				pixel_addr <= pixel_counter;
				pixel_dataout <= (so_buffer[index] == 1) ? (pixel_dataout << 1) | 8'd1 : pixel_dataout << 1; 
				pixel_counter <= (bit_counter[2:0] == 0) ? pixel_counter + 1 : pixel_counter;
				pixel_wr <= (bit_counter[2:0] == 0) ? 1 : 0;
				bit_counter <= bit_counter - 1;
			end
			FILL_PIXEL: begin
				if(pixel_wr) begin
					pixel_wr <= 0;
					so_valid <= 0;
				end
				else begin
					pixel_dataout <= 0;
					pixel_wr <= 1;
					pixel_addr <= pixel_counter;
					pixel_counter <= pixel_counter + 1;
					if(pixel_counter == 0)
						pixel_finish <= 1;
				end
				
			end
		endcase
	end
end


always @(*) begin
	next_state = curr_state;
	index = 0;
	case(curr_state) 
		WAIT: 
			next_state = (load == 1) ? LOAD : WAIT;
		LOAD: 
			next_state = SO_OUT;	
		SO_OUT: begin
			if(bit_counter == 0)
				next_state = (pi_end) ? FILL_PIXEL : WAIT;
			else
				next_state = SO_OUT;
			index = (pi_msb) ? bit_counter : output_length - bit_counter;
		end
	endcase
end

endmodule
