module ate(clk,reset,pix_data,bin,threshold);
input clk;
input reset;
input [7:0] pix_data;
output bin;
output [7:0] threshold;
reg [7:0] threshold;
reg [7:0] threshold_temp;
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
	// Update input into buffer and clock 
	else begin
		count <= (count == 7'd63) ? 7'd0 : count + 7'd1;
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
	// If input > max, update max, if input < min, update min
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

// Count threshold at last input of each 8x8 matrix
always @(posedge clk or posedge reset) begin
  if (count == 7'd63 && !(block_count == 0 || block_count == 5 || block_count == 6 || block_count == 11 || block_count == 12 || block_count == 17 || block_count == 18 || block_count == 23)) begin
    if(pix_data > max) begin
      threshold_temp <= ((pix_data[0] == 1) ? pix_data >> 1 + 1 : pix_data >> 1) + ((min[0] == 1) ? min >> 1 + 1 : min >> 1);
    end
    else if(pix_data < min) begin
      threshold_temp <= ((max[0] == 1) ? max >> 1 + 1 : max >> 1) + ((pix_data[0] == 1) ? pix_data >> 1 + 1 : pix_data >> 1);
    end 
    else begin
      threshold_temp <= ((max[0] == 1) ? max >> 1 + 1 : max >> 1) + ((min[0] == 1) ? min >> 1 + 1 : min >> 1);
    end 
  end
  else begin
    threshold_temp <= 0;  
  end
end

// Count output
always @(posedge clk or posedge reset) begin
  if(!(block_count == 1 || block_count == 6 || block_count == 7 || block_count == 12 || block_count == 13 || block_count == 18 || block_count == 19 || block_count == 24)) begin
    if (count == 0) begin
      threshold <= threshold_temp;
      if(buffer[count] >= threshold_temp) begin
        bin <= 1;
      end 
      else begin
        bin <= 0;
      end
    end
    else begin
      if(buffer[count] >= threshold) begin
        bin <= 1;
      end 
      else begin
        bin <= 0;
      end
    end
  end
  else begin
    bin <= 0;
  end
end

endmodule