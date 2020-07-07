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

reg [3:0] curr_state, next_state;
reg [3:0] counter;
reg [11:0] curr_addr;
reg signed [19:0] buffer_0[0:8], buffer_1[0:8], conv_block, conv_ker;
reg signed [39:0] conv_sum;

parameter WAIT = 4'd0;
parameter LOAD = 4'd1;
parameter NO_REUSE = 4'd2;
parameter REUSE = 4'd3;
parameter CONVOLUTION_0 = 4'd4;
parameter RELU_0 = 4'd5;
parameter CONVOLUTION_1 = 4'd6;
parameter RELU_1 = 4'd7;
parameter PRE_MAXPOOL = 4'd8;
parameter MAXPOOL_0 = 4'd9;
parameter MAXPOOL_1 = 4'd10;
parameter FLATTEN = 4'd11;

parameter signed ker0_0 = 20'h0A89E;
parameter signed ker0_1 = 20'h092D5;
parameter signed ker0_2 = 20'h06D43;
parameter signed ker0_3 = 20'h01004;
parameter signed ker0_4 = 20'hF8F71;
parameter signed ker0_5 = 20'hF6E54;
parameter signed ker0_6 = 20'hFA6D7;
parameter signed ker0_7 = 20'hFC834;
parameter signed ker0_8 = 20'hFAC19;

parameter signed ker1_0 = 20'hFDB55;
parameter signed ker1_1 = 20'h02992;
parameter signed ker1_2 = 20'hFC994;
parameter signed ker1_3 = 20'h050FD;
parameter signed ker1_4 = 20'h02F20;
parameter signed ker1_5 = 20'h0202D;
parameter signed ker1_6 = 20'h03BD7;
parameter signed ker1_7 = 20'hFD369;
parameter signed ker1_8 = 20'h05E68;

parameter signed bias_0 = 40'h0013100000;
parameter signed bias_1 = 40'hFF72950000;

wire [39:0] conv_ans = conv_block * conv_ker;
wire [19:0] max_top = (buffer_0[0] > buffer_0[1]) ? buffer_0[0] : buffer_0[1];
wire [19:0] max_bottom = (buffer_0[2] > buffer_0[3]) ? buffer_0[2] : buffer_0[3];
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
			end
			NO_REUSE: begin
				case (counter)
					4'd0, 4'd3, 4'd6: begin
						buffer_0[counter] <= 20'd0;
						buffer_1[counter] <= 20'd0;
					end 
					4'd1: begin
						if(curr_addr[11:6] == 6'd0) begin
							buffer_0[1] <= 20'd0;
							buffer_1[1] <= 20'd0;
						end
						else begin
							buffer_0[1] <= idata;
							buffer_1[1] <= idata;
							iaddr <= iaddr + 12'd1;
						end
					end
					4'd2: begin
						if(curr_addr[11:6] == 6'd0) begin
							buffer_0[2] <= 20'd0;
							buffer_1[2] <= 20'd0;
						end
						else begin
							buffer_0[2] <= idata;
							buffer_1[2] <= idata;
							iaddr <= iaddr + 12'd63;
						end
					end
					4'd4: begin
						buffer_0[4] <= idata;
						buffer_1[4] <= idata;
						iaddr <= iaddr + 12'd1;
					end
					4'd5: begin
						buffer_0[5] <= idata;
						buffer_1[5] <= idata;
						iaddr <= (curr_addr[11:6] == 6'd63) ? iaddr : iaddr + 12'd63;
					end
					4'd7: begin
						if(curr_addr[11:6] == 6'd63) begin
							buffer_0[7] <= 20'd0;
							buffer_1[7] <= 20'd0;
						end
						else begin
							buffer_0[7] <= idata;
							buffer_1[7] <= idata;
							iaddr <= iaddr + 12'd1;
						end
					end
					4'd8: begin
						// if(curr_addr[11:6] == 6'd63) begin
						// 	buffer_0[8] <= 20'd0;
						// 	buffer_1[8] <= idata;
						// end
						// else begin
						// 	buffer_0[8] <= 20'd0;
						// 	buffer_1[8] <= idata;
						// end
						buffer_0[8] <= (curr_addr[11:6] == 6'd63) ? 20'd0 : idata;
						buffer_1[8] <= (curr_addr[11:6] == 6'd63) ? 20'd0 : idata;
						iaddr <= (curr_addr[11:6] == 6'd0) ? 12'd1 : curr_addr - 12'd63;
					end				 
				endcase
				counter <= (counter == 4'd8) ? 4'd0 : counter + 4'd1;
				
			end
			REUSE: begin
				case(counter)
					4'd0: begin
						buffer_0[0] <= buffer_0[1];
						buffer_0[1] <= buffer_0[2];
						buffer_0[3] <= buffer_0[4];
						buffer_0[4] <= buffer_0[5];
						buffer_0[6] <= buffer_0[7];
						buffer_0[7] <= buffer_0[8];

						buffer_1[0] <= buffer_1[1];
						buffer_1[1] <= buffer_1[2];
						buffer_1[3] <= buffer_1[4];
						buffer_1[4] <= buffer_1[5];
						buffer_1[6] <= buffer_1[7];
						buffer_1[7] <= buffer_1[8];

						iaddr <= (curr_addr[5:0] == 6'd63) ? iaddr : iaddr + 12'd1;
					end
					4'd1: begin
						if(curr_addr[11:6] == 6'd0) begin
							buffer_0[2] <= 20'd0;
							buffer_1[2] <= 20'd0;
						end
						else begin
							buffer_0[2] <= (curr_addr[5:0] == 6'd63) ? 20'd0 : idata;
							buffer_1[2] <= (curr_addr[5:0] == 6'd63) ? 20'd0 : idata;
							iaddr <= iaddr + 12'd64;
						end
					end
					4'd2: begin
						if(curr_addr[5:0] == 6'd63) begin
							buffer_0[5] <= 20'd0;
							buffer_1[5] <= 20'd0;
						end
						else begin
							buffer_0[5] <= idata;
							buffer_1[5] <= idata;
							iaddr <= (curr_addr[11:6] == 6'd63) ? iaddr : iaddr + 12'd64;
						end
					end
					4'd3: begin
						if(curr_addr[11:6] == 6'd63 || curr_addr[5:0] == 6'd63) begin
							buffer_0[8] <= 20'd0;
							buffer_1[8] <= 20'd0;
							iaddr <= curr_addr - 12'd63;
						end
						else begin
							buffer_0[8] <= idata;
							buffer_1[8] <= idata;
							iaddr <= (curr_addr[11:6] == 6'd0) ? curr_addr + 12'd1 : curr_addr - 12'd63;
						end
					end
				endcase
				counter <= (counter == 4'd3) ? 4'd0 : counter + 4'd1;
			end
			CONVOLUTION_0: begin
				case (counter)
					4'd0: begin
						cwr <= 0;
						conv_block <= buffer_0[0];
						conv_ker <= ker0_0;
					end
					4'd1: begin
						conv_block <= buffer_0[1];
						conv_ker <= ker0_1;
					end
					4'd2: begin
						conv_block <= buffer_0[2];
						conv_ker <= ker0_2;
					end
					4'd3: begin
						conv_block <= buffer_0[3];
						conv_ker <= ker0_3;
					end
					4'd4: begin
						conv_block <= buffer_0[4];
						conv_ker <= ker0_4;
					end
					4'd5: begin
						conv_block <= buffer_0[5];
						conv_ker <= ker0_5;
					end
					4'd6: begin
						conv_block <= buffer_0[6];
						conv_ker <= ker0_6;
					end
					4'd7: begin
						conv_block <= buffer_0[7];
						conv_ker <= ker0_7;
					end
					4'd8: begin
						conv_block <= buffer_0[8];
						conv_ker <= ker0_8;
					end
				endcase
				
				counter <= (counter == 4'd9) ? 4'd0 : counter + 4'd1;
				conv_sum <= (counter == 4'd0) ? bias_0 : conv_sum + conv_ans;
			end
			RELU_0: begin
				cwr <= 1;
				cdata_wr <= (conv_sum[39]) ? 20'd0 : ((conv_sum[15]) ? conv_sum[35:16] + 20'h00001 : conv_sum[35:16]);
				csel <= 3'b001;
				caddr_wr <= curr_addr;
			end
			CONVOLUTION_1: begin
				case (counter)
					4'd0: begin
						cwr <= 0;
						conv_block <= buffer_1[0];
						conv_ker <= ker1_0;
					end
					4'd1: begin
						conv_block <= buffer_1[1];
						conv_ker <= ker1_1;
					end
					4'd2: begin
						conv_block <= buffer_1[2];
						conv_ker <= ker1_2;
					end
					4'd3: begin
						conv_block <= buffer_1[3];
						conv_ker <= ker1_3;
					end
					4'd4: begin
						conv_block <= buffer_1[4];
						conv_ker <= ker1_4;
					end
					4'd5: begin
						conv_block <= buffer_1[5];
						conv_ker <= ker1_5;
					end
					4'd6: begin
						conv_block <= buffer_1[6];
						conv_ker <= ker1_6;
					end
					4'd7: begin
						conv_block <= buffer_1[7];
						conv_ker <= ker1_7;
					end
					4'd8: begin
						conv_block <= buffer_1[8];
						conv_ker <= ker1_8;
					end
				endcase
				counter <= (counter == 4'd9) ? 4'd0 : counter + 4'd1;
				conv_sum <= (counter == 4'd0) ? bias_1 : conv_sum + conv_ans;
			end
			RELU_1: begin
				cwr <= 1;
				cdata_wr <= (conv_sum[39]) ? 20'd0 : ((conv_sum[15]) ? conv_sum[35:16] + 20'h00001 : conv_sum[35:16]);
				csel <= 3'b010;
				curr_addr <= curr_addr + 12'd1;
				if(curr_addr == 12'd4095) begin
					crd <= 1;
				end
			end
			PRE_MAXPOOL: begin
				cwr <= 0;
				caddr_wr <= 0;
				csel <= 3'b001;
			end
			MAXPOOL_0: begin
				case(counter[2:0]) 
					4'd0: begin
						buffer_0[0] <= cdata_rd;
						caddr_rd <= caddr_rd + 12'd1;
						buffer_0[6] <= caddr_rd;
					end
					4'd1: begin
						buffer_0[1] <= cdata_rd;
						caddr_rd <= caddr_rd + 12'd63;
					end
					4'd2: begin
						buffer_0[2] <= cdata_rd;
						caddr_rd <= caddr_rd + 12'd1;
					end
					4'd3: begin
						buffer_0[3] <= cdata_rd;
					end
					// Output to layer 1_0
					4'd4: begin
						csel <= 3'b011;
						cwr <= 1;
						cdata_wr <= max_all;
						buffer_0[4] <= max_all;
					end
					4'd5: begin
						csel <= 3'b010;
						cwr <= 0;
						caddr_rd <= buffer_0[6];
					end
				endcase
				counter[2:0] <= (counter[2:0] == 3'd5) ? 3'd0 : counter + 3'd1;
			end
			MAXPOOL_1: begin
				case(counter[2:0]) 
					4'd0, 4'd2: begin
						buffer_0[counter] <= cdata_rd;
						caddr_rd <= caddr_rd + 12'd1;
					end
					4'd1: begin
						buffer_0[1] <= cdata_rd;
						caddr_rd <= caddr_rd + 12'd63;
					end
					4'd3: begin
						buffer_0[3] <= cdata_rd;
					end
					// Output to layer 1_1
					4'd4: begin
						csel <= 3'b100;
						cwr <= 1;
						cdata_wr <= max_all;
						buffer_0[5] <= max_all;
						caddr_rd <= (caddr_rd[5:0] == 6'd63) ? caddr_rd + 12'd1 : caddr_rd - 12'd63; // Count for next maxpool
					end
				endcase
				counter[2:0] <= (counter[2:0] == 3'd4) ? 3'd0 : counter + 3'd1;
			end
			FLATTEN: begin
				case(counter[1:0])
					4'd0: begin
						csel <= 3'b101;
						caddr_wr <= caddr_wr << 1;
						cdata_wr <= buffer_0[4];
					end
					4'd1: begin
						caddr_wr <= caddr_wr + 12'd1;
						cdata_wr <= buffer_0[5];
					end
					4'd2: begin
						cwr <= 0;
						csel <= 3'b001;
						caddr_wr <= (caddr_wr >> 1) + 12'd1;
						busy <= (caddr_wr == 12'd2047) ? 0 : 1;
					end
				endcase
				counter <= (counter[1:0] == 2'd2) ? 2'd0 : counter + 2'd1;
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
			next_state = (curr_addr[5:0] == 6'd0) ? NO_REUSE : REUSE;
		end
		NO_REUSE: begin
			next_state = (counter == 4'd8) ? CONVOLUTION_0: NO_REUSE;
		end
		REUSE: begin
			next_state = (counter == 4'd3) ? CONVOLUTION_0: REUSE;
		end
		// LOAD: begin
		// 	if(curr_addr[5:0] == 6'd0)
		// 		next_state = (counter == 4'd8) ? CONVOLUTION_0: LOAD;
		// 	else
		// 		next_state = (counter == 4'd3) ? CONVOLUTION_0: LOAD;
		// end
		CONVOLUTION_0: begin
			next_state = (counter == 4'd9) ? RELU_0: CONVOLUTION_0;
		end
		RELU_0: begin
			next_state = CONVOLUTION_1;
		end
		CONVOLUTION_1: begin
			next_state = (counter == 4'd9) ? RELU_1: CONVOLUTION_1;
		end
		RELU_1: begin
			next_state = (curr_addr == 12'd4095) ? PRE_MAXPOOL : LOAD;
		end
		PRE_MAXPOOL: begin
			next_state = MAXPOOL_0;
		end
		MAXPOOL_0: begin
			next_state = (counter == 4'd5) ? MAXPOOL_1 : MAXPOOL_0;
		end
		MAXPOOL_1: begin
			next_state = (counter == 4'd4) ? FLATTEN : MAXPOOL_1;
		end
		FLATTEN: begin
			next_state = (caddr_wr == 12'd2047) ? WAIT : (counter == 4'd2) ? MAXPOOL_0 : FLATTEN;
		end
		default: begin
			next_state = WAIT;
		end
	endcase
end

endmodule




