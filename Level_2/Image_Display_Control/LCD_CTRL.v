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

reg [2:0] curr_x, curr_y;
reg [1:0] curr_state, next_state;
reg [5:0] IROM_A_pre, IRAM_A_post;
reg [7:0] buffer [0:63], max, min, temp1, temp2;
reg [9:0] avg;

parameter Write = 4'b0000;
parameter Shift_Up = 4'b0001;
parameter Shift_Down = 4'b0010;
parameter Shift_Left = 4'b0011;
parameter Shift_Right = 4'b0100;
parameter Max = 4'b0101;
parameter Min = 4'b0110;
parameter Average = 4'b0111;
parameter Counterclockwise = 4'b1000;
parameter Clockwise = 4'b1001;
parameter Mirror_X = 4'b1010;
parameter Mirror_Y = 4'b1011;

parameter Input = 2'b00;
parameter Command = 2'b01;
parameter Output = 2'b10;

always@(posedge clk) begin
    if(reset) begin
        busy <= 1;
        IROM_A <= 0;
        IROM_rd <= 1;
        
        done <= 0;
        IRAM_A <= 0;
        IRAM_D <= 0;
        IRAM_valid <= 0;
        
        IROM_A_pre <= 0;
        IRAM_A_post <= 0;

        curr_state <= Input;
    end
    else begin
        curr_state <= next_state;
        case(curr_state) 
            Input: begin
                curr_x <= 4;
                curr_y <= 4;
                buffer[IROM_A] <= IROM_Q; 
                IROM_A_pre <= IROM_A;

                IROM_A <= (IROM_A == 63) ? 0 : IROM_A + 1;
                
                IROM_rd <= (IROM_A_pre == 63) ? 0 : 1;
                busy <= (IROM_A_pre == 63) ? 0 : 1;
            end
            Command: begin
                if(cmd_valid) begin
                    case (cmd)
                        Shift_Up: 
                            curr_y <= (curr_y == 1) ? curr_y : curr_y - 1;
                        Shift_Down:
                            curr_y <= (curr_y == 7) ? curr_y : curr_y + 1;
                        Shift_Left:
                            curr_x <= (curr_x == 1) ? curr_x : curr_x - 1;
                        Shift_Right:
                            curr_x <= (curr_x == 7) ? curr_x : curr_x + 1;
                        Max: begin
                            buffer[(curr_y - 1) * 8 + curr_x - 1] <= max;
                            buffer[(curr_y - 1) * 8 + curr_x] <= max;
                            buffer[curr_y * 8 + curr_x - 1] <= max;
                            buffer[curr_y * 8 + curr_x] <= max;
                        end
                        Min: begin
                            buffer[(curr_y - 1) * 8 + curr_x - 1] <= min;
                            buffer[(curr_y - 1) * 8 + curr_x] <= min;
                            buffer[curr_y * 8 + curr_x - 1] <= min;
                            buffer[curr_y * 8 + curr_x] <= min;
                        end
                        Average: begin
                            buffer[(curr_y - 1) * 8 + curr_x - 1] <= avg;
                            buffer[(curr_y - 1) * 8 + curr_x] <= avg;
                            buffer[curr_y * 8 + curr_x - 1] <= avg;
                            buffer[curr_y * 8 + curr_x] <= avg;
                        end
                        Counterclockwise: begin
                            buffer[(curr_y - 1) * 8 + curr_x - 1] <= buffer[(curr_y - 1) * 8 + curr_x];
                            buffer[(curr_y - 1) * 8 + curr_x] <= buffer[curr_y * 8 + curr_x];
                            buffer[curr_y * 8 + curr_x] <= buffer[curr_y * 8 + curr_x - 1];
                            buffer[curr_y * 8 + curr_x - 1] <= buffer[(curr_y - 1) * 8 + curr_x - 1];
                        end
                        Clockwise: begin
                            buffer[(curr_y - 1) * 8 + curr_x - 1] <= buffer[curr_y * 8 + curr_x - 1];
                            buffer[curr_y * 8 + curr_x - 1] <= buffer[curr_y * 8 + curr_x];
                            buffer[curr_y * 8 + curr_x] <= buffer[(curr_y - 1) * 8 + curr_x];
                            buffer[(curr_y - 1) * 8 + curr_x] <= buffer[(curr_y - 1) * 8 + curr_x - 1];
                        end
                        Mirror_X: begin
                            buffer[(curr_y - 1) * 8 + curr_x - 1] <= buffer[curr_y * 8 + curr_x - 1];
                            buffer[curr_y * 8 + curr_x - 1] <= buffer[(curr_y - 1) * 8 + curr_x - 1];
                            buffer[(curr_y - 1) * 8 + curr_x] <= buffer[curr_y * 8 + curr_x];
                            buffer[curr_y * 8 + curr_x] <= buffer[(curr_y - 1) * 8 + curr_x];
                        end
                        Mirror_Y: begin
                            buffer[(curr_y - 1) * 8 + curr_x - 1] <= buffer[(curr_y - 1) * 8 + curr_x];
                            buffer[(curr_y - 1) * 8 + curr_x] <= buffer[(curr_y - 1) * 8 + curr_x - 1];
                            buffer[curr_y * 8 + curr_x - 1] <= buffer[curr_y * 8 + curr_x];
                            buffer[curr_y * 8 + curr_x] <= buffer[curr_y * 8 + curr_x - 1];
                        end
                    endcase
                end 
            end
            Output: begin
                IRAM_D <= buffer[IRAM_A_post];
                IRAM_A <= IRAM_A_post;
                IRAM_A_post <= (IRAM_A_post == 63) ? 0 : IRAM_A_post + 1;
            
                IRAM_valid <= (IRAM_A == 63) ? 0 : 1;
                busy <= (IRAM_A == 63) ? 0 : 1;
                done <= (IRAM_A == 63) ? 1 : 0;
            end
        endcase
    end
end

always@(*) begin
    next_state = curr_state;
    avg = 0;
    max = 0;
    min = 0;
    case(curr_state)         
        Input: begin
            next_state = (IROM_A_pre == 63) ? Command : Input;
        end
        Command: begin
            case(cmd) 
                Write: begin
                    next_state = Output;
                    avg = 0;
                end 
                Average: begin
                    avg = ((buffer[(curr_y - 1) * 8 + curr_x - 1] + buffer[(curr_y - 1) * 8 + curr_x]) + 
                           (buffer[curr_y * 8 + curr_x - 1] + buffer[curr_y * 8 + curr_x])) >> 2;
                end 
                Max: begin
                    temp1 = (buffer[(curr_y - 1) * 8 + curr_x - 1] > buffer[(curr_y - 1) * 8 + curr_x]) ? buffer[(curr_y - 1) * 8 + curr_x - 1] : buffer[(curr_y - 1) * 8 + curr_x];
                    temp2 = (buffer[curr_y * 8 + curr_x - 1] > buffer[curr_y * 8 + curr_x]) ? buffer[curr_y * 8 + curr_x - 1] : buffer[curr_y * 8 + curr_x];
                    max = (temp1 > temp2) ? temp1 : temp2;
                end
                Min: begin
                    temp1 = (buffer[(curr_y - 1) * 8 + curr_x - 1] < buffer[(curr_y - 1) * 8 + curr_x]) ? buffer[(curr_y - 1) * 8 + curr_x - 1] : buffer[(curr_y - 1) * 8 + curr_x];
                    temp2 = (buffer[curr_y * 8 + curr_x - 1] < buffer[curr_y * 8 + curr_x]) ? buffer[curr_y * 8 + curr_x - 1] : buffer[curr_y * 8 + curr_x];
                    min = (temp1 < temp2) ? temp1 : temp2;
                end
            endcase
        end
    endcase
end

endmodule



