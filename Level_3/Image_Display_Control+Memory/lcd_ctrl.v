module LCD_CTRL(clk, reset, IROM_Q, cmd, cmd_valid, IROM_EN, IROM_A, IRB_RW, IRB_D, IRB_A, busy, done);

input clk;
input reset;
input [7:0] IROM_Q;
input [2:0] cmd;
input cmd_valid;

output reg IROM_EN; // 0 for start to read, 1 for close IROM
output reg [5:0] IROM_A;
output reg IRB_RW;  // 0 for start to write, 1 for close IRB(?)
output reg [7:0] IRB_D;
output reg [5:0] IRB_A;
output reg busy;    // 1 for controller is executing current command, 0 for system to input the command, default is 1 when reseted
output reg done;    // 1 for controller finished writing to IRB

reg [2:0] curr_x, curr_y;
reg [3:0] curr_state, next_state;
reg [5:0] IROM_A_pre, IRB_A_post;
reg [7:0] buffer [0:63];
reg [9:0] avg;

parameter Input = 3'b000;
parameter Command = 3'b001;
parameter Output = 3'b010;

parameter Write = 3'b000;
parameter Shift_Up = 3'b001;
parameter Shift_Down = 3'b010;
parameter Shift_Left = 3'b011;
parameter Shift_Right = 3'b100;
parameter Average = 3'b101;
parameter Mirror_X = 3'b110;
parameter Mirror_Y = 3'b111;

always@(posedge clk) begin
    if(reset) begin
        busy <= 1;
        IROM_A <= 0;
        IROM_EN <= 0;
        
        done <= 0;
        IRB_A <= 0;
        IRB_D <= 0;
        IRB_RW <= 1;
        
        IROM_A_pre <= 0;
        IRB_A_post <= 0;

        curr_state <= Input;
    end
    else begin
        curr_state <= next_state;
        case(curr_state) 
            Input: begin
                curr_x <= 4;
                curr_y <= 4;
                buffer[IROM_A_pre] <= IROM_Q; 
                IROM_A_pre <= IROM_A; 

                IROM_A <= (IROM_A == 63) ? 0 : IROM_A + 1;
                
                IROM_EN <= (IROM_A_pre == 63) ? 1 : 0;
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
                        Average: begin
                            buffer[(curr_y - 1) * 8 + curr_x - 1] <= avg;
                            buffer[(curr_y - 1) * 8 + curr_x] <= avg;
                            buffer[curr_y * 8 + curr_x - 1] <= avg;
                            buffer[curr_y * 8 + curr_x] <= avg;
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
                IRB_D <= buffer[IRB_A_post];
                IRB_A <= IRB_A_post;
                IRB_A_post <= (IRB_A_post == 63) ? 0 : IRB_A_post + 1;
            
                IRB_RW <= (IRB_A == 63) ? 1 : 0;
                busy <= (IRB_A == 63) ? 0 : 1;
                done <= (IRB_A == 63) ? 1 : 0;
            end
        endcase
    end
end

always@(*) begin
    case(curr_state) 
        Input: begin
            next_state <= (IROM_A_pre == 63) ? Command : Input;
        end
        Command: begin
            case(cmd) 
                Write: 
                    next_state = Output;
                Average:
                    avg = ((buffer[(curr_y - 1) * 8 + curr_x - 1] + buffer[(curr_y - 1) * 8 + curr_x]) + 
                           (buffer[curr_y * 8 + curr_x - 1] + buffer[curr_y * 8 + curr_x])) >> 2;
                default:
                    avg = avg;
            endcase
        end


    endcase
    

end

endmodule
