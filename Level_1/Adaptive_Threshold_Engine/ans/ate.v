module ate(clk,reset,pix_data,bin,threshold);
input clk;
input reset;
input [7:0] pix_data;
output bin;
output [7:0] threshold;
reg [7:0] threshold;
reg bin;

reg [7:0] buffer [63:0];

reg [6:0] count;
reg [7:0] min;
reg [7:0] max;
reg [4:0] block_count;
integer i;

//buffer controll
always @(posedge clk or posedge reset) begin
	if (reset) begin
		// reset
		count <= 7'd0;
		block_count <= 5'd0;
		for(i=0;i<64;i=i+1)
			buffer[i] <= 8'd0;
	end
	else begin
		count <= (count == 7'd63) ? 6'd0 : count + 6'd1;
		block_count <= (count == 7'd63) ? block_count + 5'd1 : block_count;
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
		if(count == 7'd0) begin
			max <= pix_data;
			min <= pix_data;
		end
		else begin
			if(pix_data > max) max <= pix_data;
			if(pix_data < min) min <= pix_data;
		end
	end
end

//output controll
always @(posedge clk or posedge reset) begin
	if (reset) begin
		// reset
		threshold <= 8'd255;
		bin <= 1'b0;
	end
	else begin
		if(count == 7'd0) begin
			if(block_count == 5'd1 || block_count == 5'd6 || block_count == 5'd7 || block_count == 5'd12 || block_count == 5'd13 || block_count == 5'd18 || block_count == 5'd19 || block_count == 5'd24) begin
				threshold <= 8'd0;
			end
			else threshold <= ({1'b0,max}+{1'b0,min}+9'd1)>>1;
		end

		if(block_count == 5'd1 || block_count == 5'd6 || block_count == 5'd7 || block_count == 5'd12 || block_count == 5'd13 || block_count == 5'd18 || block_count == 5'd19 || block_count == 5'd24) begin
			bin <= 1'b0;
		end
		else if(count == 8'd0)begin
			if(buffer[count] >= (({1'b0,max}+{1'b0,min}+9'd1)>>1)) bin <= 1'b1;
			else bin <= 1'b0;
		end
		else if(buffer[count] >= threshold) bin <= 1'b1;
		else bin <= 1'b0;
	end
end
endmodule
