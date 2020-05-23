module lcd_ctrl(clk, reset, datain, cmd, cmd_valid, dataout, output_valid, busy);

input           clk;
input           reset;
input   [7:0]   datain;
input   [2:0]   cmd;
input           cmd_valid;

output reg [7:0]   dataout;
output reg         output_valid;
output reg         busy;


reg [7:0] buffer[0:107];
reg [6:0] input_count;
reg [4:0] output_count; 
reg [4:0] origin_x, origin_y;
reg zoom_mode;  // 0 for Zoom In, 1 for Zoom Fit
integer i;

task start_input_task;
    begin
        busy <= 1;
        input_count <= 0;
        origin_x <= 6;
        origin_y <= 5;
    end
endtask

task start_output_task;
    begin
        busy <= 1;
        output_count <= 16;
    end
endtask

always@(posedge clk, posedge reset) begin
    // Handle reset
	if (reset) begin
        dataout <= 0;
        output_valid <= 0;
        busy <= 0;
        
        input_count <= 0;
        output_count <= 16;
        for(i = 0; i < 108; i = i+1)
            buffer[i] <= 0;
        origin_x <= 6;
        origin_y <= 5;
        zoom_mode <= 0;
    end
	// Handle command
    else if (cmd_valid && busy == 0) begin
        case (cmd) 
            /* Load Data */
            3'd0: begin
                start_input_task;
                start_output_task;
                zoom_mode <= 1;
            end
            /* Zoom In */
            3'd1: begin
                start_output_task;
                if(zoom_mode == 1) begin
                    origin_x <= 6;
                    origin_y <= 5;
                end
                else begin
                    origin_x <= origin_x;
                    origin_y <= origin_y;
                end
                zoom_mode <= 0;
            end
            /* Zomm Fit */
            3'd2: begin
                start_output_task;
                zoom_mode <= 1;
            end
            /* Shift Right */
            3'd3: begin
                if(zoom_mode == 0 && origin_x < 10)
                    origin_x <= origin_x + 1;
                else
                    origin_x <= origin_x;
                start_output_task;
            end
            /* Shift Left */
            3'd4: begin
                if(zoom_mode == 0 && origin_x > 2)
                    origin_x <= origin_x - 1;
                else
                    origin_x <= origin_x;
                start_output_task;
            end
            /* Shift Up */
            3'd5: begin
                if(zoom_mode == 0 && origin_y > 2)
                    origin_y <= origin_y - 1;
                else
                    origin_y <= origin_y;
                start_output_task;
            end
            /* Shift Down */
            3'd6: begin
                if(zoom_mode == 0 && origin_y < 7)
                    origin_y <= origin_y + 1; 
                else
                    origin_y <= origin_y;
                start_output_task;
            end
        endcase
    end
	// Reset output_valid & busy after output finish
	else if(output_count == 0) begin
		output_valid <= 0;
		busy <= 0;
	end
	// Handle input & output
    else begin
		// For input
		if (input_count < 108) begin
			buffer[input_count] <= datain;
			input_count <= input_count + 1;
		end
		// For output
		else if (output_count > 0) begin
			case(output_count)
				5'd1: begin
                    if (zoom_mode == 0)
                        dataout <= buffer[(origin_y + 1) * 12 + origin_x + 1];
                    else
                        dataout <= buffer[7'h5e];
				end
                5'd2: begin
                    if (zoom_mode == 0)
                        dataout <= buffer[(origin_y + 1) * 12 + origin_x];
                    else
                        dataout <= buffer[7'h5b];
				end
                5'd3: begin
                    if (zoom_mode == 0)
                        dataout <= buffer[(origin_y + 1) * 12 + origin_x - 1];
                    else
                        dataout <= buffer[7'h58];
				end
                5'd4: begin
                    if (zoom_mode == 0)
                        dataout <= buffer[(origin_y + 1) * 12 + origin_x - 2];
                    else
                        dataout <= buffer[7'h55];
				end
                5'd5: begin
                    if (zoom_mode == 0)
                        dataout <= buffer[origin_y * 12 + origin_x + 1];
                    else
                        dataout <= buffer[7'h46];
				end
                5'd6: begin
                    if (zoom_mode == 0)
                        dataout <= buffer[origin_y* 12 + origin_x];
                    else
                        dataout <= buffer[7'h43];
				end
                5'd7: begin
                    if (zoom_mode == 0)
                        dataout <= buffer[origin_y * 12 + origin_x - 1];
                    else
                        dataout <= buffer[7'h40];
				end
				5'd8: begin
                    if (zoom_mode == 0)
                        dataout <= buffer[origin_y * 12 + origin_x - 2];
                    else
                        dataout <= buffer[7'h3d];
				end
				5'd9: begin
                    if (zoom_mode == 0)
                        dataout <= buffer[(origin_y - 1) * 12 + origin_x + 1];
                    else
                        dataout <= buffer[7'h2e];
				end
				5'd10: begin
                    if (zoom_mode == 0)
                        dataout <= buffer[(origin_y - 1) * 12 + origin_x];
                    else
                        dataout <= buffer[7'h2b];
				end
				5'd11: begin
                    if (zoom_mode == 0)
                        dataout <= buffer[(origin_y - 1) * 12 + origin_x - 1];
                    else
                        dataout <= buffer[7'h28];
				end
				5'd12: begin
                    if (zoom_mode == 0)
                        dataout <= buffer[(origin_y - 1) * 12 + origin_x - 2];
                    else
                        dataout <= buffer[7'h25];
				end
				5'd13: begin
                    if (zoom_mode == 0)
                        dataout <= buffer[(origin_y - 2) * 12 + origin_x + 1];
                    else
                        dataout <= buffer[7'h16];
				end
				5'd14: begin
					if (zoom_mode == 0)
                        dataout <= buffer[(origin_y - 2) * 12 + origin_x];
                    else
                        dataout <= buffer[7'h13];
				end
				5'd15: begin
					if (zoom_mode == 0)
                        dataout <= buffer[(origin_y - 2) * 12 + origin_x - 1];
                    else
                        dataout <= buffer[7'h10];
				end
                5'd16: begin
                    if (zoom_mode == 0)
                        dataout <= buffer[(origin_y - 2) * 12 + origin_x - 2];
                    else
                        dataout <= buffer[7'hd];
				end
			endcase
			/* output code here */
			output_valid <= 1;
			output_count <= output_count - 1;
		end
    end
end


endmodule
