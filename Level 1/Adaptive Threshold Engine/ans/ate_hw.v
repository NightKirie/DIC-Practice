module ate(clk,reset,pix_data,bin,threshold);
input clk;
input reset;
input [7:0] pix_data;
output bin;
output [7:0] threshold;
reg [7:0] threshold;
reg bin;

reg [7:0] buffer [63:0];

reg [5:0] count;
reg [7:0] min;
reg [7:0] max;
reg [2:0] block_count;
integer i;

//buffer controll
always @(posedge clk or posedge reset) begin
	if (reset) begin
		// reset
		count <= 6'd0;
		block_count <= 5'd0;
		for(i=0;i<64;i=i+1)
			buffer[i] <= 8'd0;
	end
	else begin
		count <= count + 6'd1;
		if ( count == 6'd63) begin
			if (block_count == 3'd6) 
				block_count <= 3'd1;
			else
				block_count <= block_count + 3'd1; 
		end
		buffer[count] <= pix_data;
	end
end

//min max find
always @(posedge clk or posedge reset) begin
	if (reset) begin
		// reset
		min <= 8'd255;
		max <= 8'd0;
	end
	else begin
		if(count == 6'd0) begin
			max <= pix_data;
			min <= pix_data;
		end
		else begin
			if(pix_data > max) max <= pix_data;
			if(pix_data < min) min <= pix_data;
		end
	end
end

always @ (posedge clk or posedge reset ) begin
	if (reset) begin
		bin <= 1'd0;
		threshold <= 8'd0;
	end
	else begin
		if (count == 6'd0) begin
			if ( block_count == 3'd1 || block_count == 3'd6)
				threshold <= 8'd0;
			else
				threshold <= ({1'b0,max}+{1'b0,min}+9'd1)>>1;
		end
		else begin
			threshold <= threshold;
		end
		if (block_count == 3'd1 || block_count == 3'd6) begin
			bin <= 0;
		end
		else begin
			if (count == 6'd0) begin
				if(buffer[count] >= (({1'b0,max}+{1'b0,min}+9'd1)>>1))
					bin <= 1'b1;
				else 
					bin <= 1'b0;
			end
			else begin
				if ( buffer[count] >= threshold )
					bin <= 1'b1;
				else
					bin <= 1'b0;
			end
		end
	end
end

endmodule