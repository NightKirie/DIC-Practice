module TPA(clk, reset_n, 
	   SCL, SDA, 
	   cfg_req, cfg_rdy, cfg_cmd, cfg_addr, cfg_wdata, cfg_rdata);
input 		clk; 
input 		reset_n;
// Two-Wire Protocol slave interface 
input 		SCL;  
inout		SDA;

// Register Protocal Master interface 
input		cfg_req;
output	reg	cfg_rdy;
input		cfg_cmd;
input	[7:0]	cfg_addr;
input	[15:0]	cfg_wdata;
output	reg [15:0]  cfg_rdata;

reg	[15:0] Register_Spaces [0:255];
reg [2:0] curr_state, next_state;
reg [3:0] counter;
reg [7:0] twp_addr;
reg [14:0] twp_data;
reg tar, sda_value;

parameter TWP_WAIT = 3'd0;
parameter TWP_CMD = 3'd1;
parameter TWP_WRITE_ADDR = 3'd2;
parameter TWP_WRITE_DATA = 3'd3;
parameter TWP_READ_ADDR = 3'd4;
parameter TWP_READ_SET_TAR = 3'd5;
parameter TWP_READ_DATA = 3'd6;
parameter TWP_READ_ZERO_TAR = 3'd7;

assign SDA = (tar == 0) ? 1'bz : sda_value;

reg rim_master;

always @(*) begin
	case (curr_state)
		TWP_CMD: begin
			rim_master = (cfg_req) ? ((SDA) ? 0 : 1) : 1;
		end
		default: begin
			rim_master = rim_master;
		end
	endcase
end

always @(posedge clk, negedge reset_n) begin
	if (!reset_n) begin
		cfg_rdy <= 0;
		cfg_rdata <= 0;
		
		tar <= 0;
		sda_value <= 0;

		curr_state <= TWP_WAIT;
	end
	else begin
		/* RIM */
		if(cfg_req) begin
			cfg_rdy <= 1;
			if(cfg_cmd) begin
				Register_Spaces[cfg_addr] <= cfg_wdata;
			end
			else begin
				cfg_rdata <= Register_Spaces[cfg_addr];		
			end
		end
		else begin
			cfg_rdy <= 0;
		end

		/* TWP */
		curr_state <= next_state;
		case (curr_state)
			TWP_WAIT: begin
				counter <= 0;
				tar <= 0;
			end
			/* 8 cycle for read address from SDA in LSB */
			TWP_WRITE_ADDR: begin
				twp_addr[counter] <= SDA;
				counter <= (counter == 4'd7) ? 0 : counter + 1;
			end
			/* 16 cycle for read data from SDA in LSB */
			TWP_WRITE_DATA: begin
				twp_data[counter] <= SDA;
				Register_Spaces[twp_addr] <= (counter == 4'd15 && rim_master) ? {SDA, twp_data} : Register_Spaces[twp_addr];
				counter <= counter + 1;
			end
			/* 8 cycle for read address from SDA in LSB */
			TWP_READ_ADDR: begin
				twp_addr[counter] <= SDA;
				counter <= (counter == 5'd7) ? 0 : counter + 1;
			end
			/* 3 cycle for set tar */
			TWP_READ_SET_TAR: begin
				case (counter) 
					4'd0: begin
						counter <= 1;
					end
					4'd1: begin
						tar <= 1;
						sda_value <= 1;
						counter <= 2;
					end
					4'd2: begin
						sda_value <= 0;
						counter <= 0;
					end
				endcase
			end
			/* 16 cycle for read data from SDA in LSB */
			TWP_READ_DATA: begin
				sda_value <= Register_Spaces[twp_addr][counter];
				cfg_rdata[counter] <= Register_Spaces[twp_addr][counter];
				counter <= counter + 1;
			end
			/* 2 cycle for zero tar */
			TWP_READ_ZERO_TAR: begin
				if(counter == 0) begin
					sda_value <= 1;
					counter <= 1;
				end
				else begin
					tar <= 0;
				end
			end
		endcase 
	end
end

always @(*) begin
	case (curr_state) 
		TWP_WAIT: begin
			next_state = (SDA == 0) ? TWP_CMD : TWP_WAIT;
		end
		TWP_CMD: begin
			next_state = (SDA == 0) ? TWP_READ_ADDR: TWP_WRITE_ADDR;
		end
		TWP_WRITE_ADDR: begin
			next_state = (counter == 4'd7) ? TWP_WRITE_DATA : TWP_WRITE_ADDR;
		end
		TWP_WRITE_DATA: begin
			next_state = (counter == 4'd15) ? TWP_WAIT : TWP_WRITE_DATA;
		end
		TWP_READ_ADDR: begin
			next_state = (counter == 5'd7) ? TWP_READ_SET_TAR : TWP_READ_ADDR;
		end
		TWP_READ_SET_TAR: begin
			next_state = (counter == 5'd2) ? TWP_READ_DATA : TWP_READ_SET_TAR;
		end
		TWP_READ_DATA: begin
			next_state = (counter == 5'd15) ? TWP_READ_ZERO_TAR : TWP_READ_DATA;
		end
		TWP_READ_ZERO_TAR: begin
			next_state = (counter == 5'd1) ? TWP_WAIT : TWP_READ_ZERO_TAR;
		end
	endcase
end

endmodule
