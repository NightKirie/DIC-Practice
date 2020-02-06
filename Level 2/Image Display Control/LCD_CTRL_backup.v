module LCD_CTRL(clk, reset, cmd, cmd_valid, IROM_Q, IROM_rd, IROM_A, IRAM_valid, IRAM_D, IRAM_A, busy, done);
input clk;
input reset;
input [3:0] cmd;
input cmd_valid;
input [7:0] IROM_Q;

output reg IROM_rd;
output reg [5:0] IROM_A;
output reg IRAM_valid;
output reg [7:0] IRAM_D;
output reg [5:0] IRAM_A;
output reg busy;
output reg done;

reg [7:0] buffer[63:0];
// reg [6:0] input_count;
// reg [2:0] output_count;
reg [2:0] origin_x, origin_y;
reg [7:0] max;
reg [7:0] min;
reg [7:0] avg;
reg [7:0] temp1, temp2;
integer i;

/* Handle reset */
always @(posedge clk, posedge reset) begin
    if(reset) begin
        IROM_rd <= 1;
        IROM_A <= 0;
        IRAM_valid <= 0;
        IRAM_D <= 0;
        IRAM_A <= 64;
        busy <= 1;
        done <= 0;

        for(i = 0; i < 64; i = i+1)
            buffer[i] <= 0; 
        origin_x <= 4;
        origin_y <= 4;
    end
    else begin
        IROM_rd <= IROM_rd;
        IROM_A <= IROM_A;
        IRAM_valid <= IRAM_valid;
        IRAM_D <= IRAM_D;
        IRAM_A <= IRAM_A;
        busy <= busy;
        done <= done;

        for(i = 0; i < 64; i = i+1)
            buffer[i] <= buffer[i]; 
        origin_x <= origin_x;
        origin_y <= origin_y;
    end

end

// Handle input
always @(negedge clk) begin
    if(busy && IROM_rd && IROM_A < 63) begin
        buffer[IROM_A] <= IROM_Q;
    end
    else if (busy && IROM_rd && IROM_A == 63) begin
        buffer[IROM_A] <= IROM_Q;
        IROM_rd <= 0;
    end
    else begin
        IROM_A <= 0;
    end
end

// Handle Output
always @(posedge clk) begin
    if(busy && IRAM_A < 64)
end


// Handle Command
always @(*) begin
    if(cmd_valid && !busy) begin
        case(cmd) 
            /* Write */
            4'b0000: begin
            end
            /* Shift Up */
            4'b0001: begin
                if(origin_y > 1)
                    origin_y = origin_y - 1;
                else
                    origin_y = origin_y;
            end
            /* Shift Down */
            4'b0010: begin
                if(origin_y < 7)
                    origin_y = origin_y + 1;
                else
                    origin_y = origin_y;
            end
            /* Shift Left */
            4'b0011: begin
                if(origin_x > 1)
                    origin_x = origin_x + 1;
                else
                    origin_x = origin_x;
            end
            /* Shift Right */
            4'b0100: begin
                if(origin_x < 7)
                    origin_x = origin_x - 1;
                else
                    origin_x = origin_x;
            end
            /* Max */
            4'b0101: begin
                temp1 = (buffer[(origin_y - 1) * 8 + origin_x - 1] > buffer[(origin_y - 1) * 8 + origin_x]) ? buffer[(origin_y - 1) * 8 + origin_x - 1] : buffer[(origin_y - 1) * 8 + origin_x];
                temp2 = (buffer[origin_y * 8 + origin_x - 1] > buffer[origin_y * 8 + origin_x]) ? buffer[(origin_y - 1) * 8 + origin_x - 1] : buffer[origin_y * 8 + origin_x];
                max = (temp1 > temp2) ? temp1 : temp2;
                buffer[(origin_y - 1) * 8 + origin_x - 1] = max;
                buffer[(origin_y - 1) * 8 + origin_x] = max;
                buffer[origin_y * 8 + origin_x - 1] = max;
                buffer[origin_y * 8 + origin_x] = max;
            end
            /* Min */
            4'b0110: begin
                temp1 = (buffer[(origin_y - 1) * 8 + origin_x - 1] < buffer[(origin_y - 1) * 8 + origin_x]) ? buffer[(origin_y - 1) * 8 + origin_x - 1] : buffer[(origin_y - 1) * 8 + origin_x];
                temp2 = (buffer[origin_y * 8 + origin_x - 1] < buffer[origin_y * 8 + origin_x]) ? buffer[(origin_y - 1) * 8 + origin_x - 1] : buffer[origin_y * 8 + origin_x];
                min = (temp1 < temp2) ? temp1 : temp2;
                buffer[(origin_y - 1) * 8 + origin_x - 1] = min;
                buffer[(origin_y - 1) * 8 + origin_x] = min;
                buffer[origin_y * 8 + origin_x - 1] = min;
                buffer[origin_y * 8 + origin_x] = min;
            end
            /* Average */
            4'b0111: begin
                avg = ((buffer[(origin_y - 1) * 8 + origin_x - 1] + buffer[(origin_y - 1) * 8 + origin_x]) + 
                       (buffer[origin_y * 8 + origin_x - 1] + buffer[origin_y * 8 + origin_x])) << 2;
                buffer[(origin_y - 1) * 8 + origin_x - 1] = avg;
                buffer[(origin_y - 1) * 8 + origin_x] = avg;
                buffer[origin_y * 8 + origin_x - 1] = avg;
                buffer[origin_y * 8 + origin_x] = avg;
            end
            /* Counterclockwise Rotation */
            4'b1000: begin
                temp1 = buffer[(origin_y - 1) * 8 + origin_x - 1];
                buffer[(origin_y - 1) * 8 + origin_x - 1] = buffer[(origin_y - 1) * 8 + origin_x];
                buffer[(origin_y - 1) * 8 + origin_x] = buffer[origin_y * 8 + origin_x];
                buffer[origin_y * 8 + origin_x] = buffer[origin_y * 8 + origin_x - 1];
                buffer[origin_y * 8 + origin_x - 1] = temp1;
            end
            /* Clockwise Rotation */
            4'b1001: begin
                temp1 = buffer[(origin_y - 1) * 8 + origin_x - 1];
                buffer[(origin_y - 1) * 8 + origin_x - 1] = buffer[origin_y * 8 + origin_x - 1];
                buffer[origin_y * 8 + origin_x - 1] = buffer[origin_y * 8 + origin_x];
                buffer[origin_y * 8 + origin_x] = buffer[(origin_y - 1) * 8 + origin_x];
                buffer[(origin_y - 1) * 8 + origin_x] = temp1;
            end
            /* Mirror X */
            4'b1010: begin
                temp1 = buffer[(origin_y - 1) * 8 + origin_x - 1];
                temp2 = buffer[(origin_y - 1) * 8 + origin_x];
                buffer[(origin_y - 1) * 8 + origin_x - 1] = buffer[origin_y * 8 + origin_x - 1];
                buffer[(origin_y - 1) * 8 + origin_x] = buffer[origin_y * 8 + origin_x];
                buffer[origin_y * 8 + origin_x - 1] = temp1;
                buffer[origin_y * 8 + origin_x] = temp2; 
            end
            /* Mirror Y */
            4'b1011: begin
                temp1 = buffer[(origin_y - 1) * 8 + origin_x - 1];
                temp2 = buffer[origin_y * 8 + origin_x - 1];
                buffer[(origin_y - 1) * 8 + origin_x - 1] = buffer[(origin_y - 1) * 8 + origin_x];
                buffer[origin_y * 8 + origin_x - 1] = buffer[origin_y * 8 + origin_x];
                buffer[(origin_y - 1) * 8 + origin_x] = temp1;
                buffer[origin_y * 8 + origin_x] = temp2;
            end
        endcase
    end
end


endmodule



