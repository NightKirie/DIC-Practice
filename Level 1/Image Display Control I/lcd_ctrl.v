module lcd_ctrl(clk, reset, datain, cmd, cmd_valid, dataout, output_valid, busy);

input           clk;
input           reset;
input   [7:0]   datain;
input   [2:0]   cmd;
input           cmd_valid;

output reg [7:0]   dataout;
output reg         output_valid;
output reg         busy;


reg [7:0] buffer[35:0];
reg [5:0] input_count;
reg [3:0] output_count; 
reg [2:0] origin_x, origin_y;
reg [31:0] clk_count;
integer i;

task start_input_task;
    begin
        busy <= 1;
        input_count <= 0;
        origin_x <= 2;
        origin_y <= 2;
    end
endtask

task start_output_task;
    begin
        busy <= 1;
        output_count <= 9;
    end
endtask

always@(posedge clk, posedge reset) begin
    if (reset) begin
        dataout <= 0;
        output_valid <= 0;
        busy <= 0;
        
        input_count <= 36;
        output_count <= 9;
        for(i = 0; i < 36; i = i+1)
            buffer[i] <= 0;
        origin_x <= 2;
        origin_y <= 2;
        clk_count <= 1;
    end
    else if (cmd_valid && busy == 0 && cmd >= 0 && cmd < 6) begin
        case (cmd) 
            /* Reflash */
            3'd0: begin
                start_output_task;
            end
            /* Load Data */
            3'd1: begin
                start_input_task;
                start_output_task;
            end
            /* Shift Right */
            3'd2: begin
                if (origin_x < 3)
                    origin_x = origin_x + 1;
                else
                    origin_x = origin_x;
                start_output_task;
            end
            /* Shift Left */
            3'd3: begin
                if (origin_x > 0)
                    origin_x = origin_x - 1;
                else
                    origin_x = origin_x;
                start_output_task;
            end
            /* Shift Up */
            3'd4: begin
                if (origin_y > 0)
                    origin_y = origin_y - 1;
                else
                    origin_y = origin_y;
                start_output_task;
            end
            /* Shift Down */
            3'd5: begin
                if (origin_y < 3)
                    origin_y = origin_y + 1;
                else
                    origin_y = origin_y;
                start_output_task;
            end
        endcase
    end
    else begin
		// For input
		if (input_count < 36) begin
			buffer[input_count] <= datain;
			input_count <= input_count + 1;
		end
		// For output
		else if (output_count >= 0) begin
			case(output_count)
				4'd1: begin
					dataout <= buffer[6 * (origin_y + 2) + origin_x + 2];
				end
				4'd2: begin
					dataout <= buffer[6 * (origin_y + 2) + origin_x + 1];
				end
				4'd3: begin
					dataout <= buffer[6 * (origin_y + 2) + origin_x];
				end
				4'd4: begin
					dataout <= buffer[6 * (origin_y + 1) + origin_x + 2];
				end
				4'd5: begin
					dataout <= buffer[6 * (origin_y + 1) + origin_x + 1];
				end
				4'd6: begin
					dataout <= buffer[6 * (origin_y + 1) + origin_x];
				end
				4'd7: begin
					dataout <= buffer[6 * origin_y + origin_x + 2];
				end
				4'd8: begin
					dataout <= buffer[6 * origin_y + origin_x + 1];
				end
				4'd9: begin
					dataout <= buffer[6 * origin_y + origin_x];
				end
			endcase
			/* output code here */
			output_valid <= 1;
			output_count <= output_count - 1;
			if (output_count == 0) begin  
				output_valid <= 0;
				busy <= 0;
			end
		end
    end
end


endmodule
