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


reg [7:0] curr_state;
reg [7:0] next_state;
reg [7:0] buffer[0:63];
reg [6:0] IRAM_A_temp;
reg [2:0] origin_x, origin_y;
reg [7:0] max;
reg [7:0] min;
reg [9:0] avg;
reg [7:0] temp1, temp2;

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
parameter Load = 4'b1100;
parameter Reset = 4'b1101;
parameter Idle = 4'b1110;

integer i;

always@(posedge clk, posedge reset) begin
    if(reset)
        curr_state <= Reset;
    else begin
        curr_state <= next_state;
        case(curr_state)
            Write: begin
                IRAM_D <= buffer[IRAM_A_temp];
                if(IRAM_A_temp == 64) begin
                    IRAM_A_temp <= 0;
                    IRAM_A <= 0;
                    busy <= 0;
                    IRAM_valid <= 0;
                    done <= 1;
                end
                else begin
                    IRAM_A <= IRAM_A_temp;
                    IRAM_A_temp <= IRAM_A_temp + 1;
                    busy <= 1;
                    IRAM_valid <= 1;
                end
                
            end
            Load: begin
                if(IROM_rd) begin
                    buffer[IROM_A] <= IROM_Q;
                    if(IROM_A == 63 && IROM_rd) begin
                        IROM_rd <= 0;
                        busy <= 0;
                        IROM_A <= 0;
                        next_state <= Idle;
                    end
                    else begin
                        IROM_A <= IROM_A + 1; 
                        busy <= 1;
                    end
                end
            end
            default: busy <= busy;
        endcase
    end
end

always@(cmd, next_state) begin
    case(cmd)
        Write: begin
            if(cmd_valid && !busy) 
                next_state = Write;
            else
                next_state = next_state;
        end
        Shift_Up: begin
            if(cmd_valid && !busy) 
                next_state = Shift_Up;
            else
                next_state = next_state;
        end
        Shift_Down: begin
            if(cmd_valid && !busy) 
                next_state = Shift_Down;
            else
                next_state = next_state;
        end
        Shift_Left: begin
            if(cmd_valid && !busy) 
                next_state = Shift_Left;
            else
                next_state = next_state;
        end
        Shift_Right: begin
            if(cmd_valid && !busy) 
                next_state = Shift_Right;
            else
                next_state = next_state;
        end
        Max: begin
            if(cmd_valid && !busy) 
                next_state = Max;
            else
                next_state = next_state;
        end
        Min: begin
            if(cmd_valid && !busy) 
                next_state = Min;
            else
                next_state = next_state;
        end
        Average: begin
            if(cmd_valid && !busy) 
                next_state = Average;
            else
                next_state = next_state;
        end
        Counterclockwise: begin
            if(cmd_valid && !busy) 
                next_state = Counterclockwise;
            else
                next_state = next_state;
        end
        Clockwise: begin
            if(cmd_valid && !busy) 
                next_state = Clockwise;
            else
                next_state = next_state;
        end
        Mirror_X: begin
            if(cmd_valid && !busy) 
                next_state = Mirror_X;
            else
                next_state = next_state;
        end
        Mirror_Y: begin
            if(cmd_valid && !busy) 
                next_state = Mirror_Y;
            else
                next_state = next_state;
        end
        Load: begin
            if(cmd_valid && !busy) 
                next_state = Load;
            else
                next_state = next_state;
        end
        default: next_state = next_state;
    endcase
end



always@(curr_state) begin
    case(curr_state)
        Shift_Up: begin
            if(origin_y > 1)
                origin_y = origin_y - 1;
            else
                origin_y = origin_y;
            curr_state = Idle;
        end
        Shift_Down: begin
            if(origin_y < 7)
                origin_y = origin_y + 1;
            else
                origin_y = origin_y;
            curr_state = Idle;
        end
        Shift_Left: begin
            if(origin_x > 1)
                origin_x = origin_x - 1;
            else
                origin_x = origin_x; 
            curr_state = Idle;
        end
        Shift_Right: begin
            if(origin_x < 7)
                origin_x = origin_x + 1;
            else
                origin_x = origin_x;
            curr_state = Idle;
            next_state = Idle;
        end
        Max: begin
            temp1 = (buffer[(origin_y - 1) * 8 + origin_x - 1] > buffer[(origin_y - 1) * 8 + origin_x]) ? buffer[(origin_y - 1) * 8 + origin_x - 1] : buffer[(origin_y - 1) * 8 + origin_x];
            temp2 = (buffer[origin_y * 8 + origin_x - 1] > buffer[origin_y * 8 + origin_x]) ? buffer[origin_y * 8 + origin_x - 1] : buffer[origin_y * 8 + origin_x];
            max = (temp1 > temp2) ? temp1 : temp2;
            buffer[(origin_y - 1) * 8 + origin_x - 1] = max;
            buffer[(origin_y - 1) * 8 + origin_x] = max;
            buffer[origin_y * 8 + origin_x - 1] = max;
            buffer[origin_y * 8 + origin_x] = max;
            curr_state = Idle;
        end
        Min: begin
            temp1 = (buffer[(origin_y - 1) * 8 + origin_x - 1] < buffer[(origin_y - 1) * 8 + origin_x]) ? buffer[(origin_y - 1) * 8 + origin_x - 1] : buffer[(origin_y - 1) * 8 + origin_x];
            temp2 = (buffer[origin_y * 8 + origin_x - 1] < buffer[origin_y * 8 + origin_x]) ? buffer[origin_y * 8 + origin_x - 1] : buffer[origin_y * 8 + origin_x];
            min = (temp1 < temp2) ? temp1 : temp2;
            buffer[(origin_y - 1) * 8 + origin_x - 1] = min;
            buffer[(origin_y - 1) * 8 + origin_x] = min;
            buffer[origin_y * 8 + origin_x - 1] = min;
            buffer[origin_y * 8 + origin_x] = min;
            curr_state = Idle;
        end
        Average: begin
            avg = ((buffer[(origin_y - 1) * 8 + origin_x - 1] + buffer[(origin_y - 1) * 8 + origin_x]) + 
                   (buffer[origin_y * 8 + origin_x - 1] + buffer[origin_y * 8 + origin_x])) >> 2;
            buffer[(origin_y - 1) * 8 + origin_x - 1] = avg;
            buffer[(origin_y - 1) * 8 + origin_x] = avg;
            buffer[origin_y * 8 + origin_x - 1] = avg;
            buffer[origin_y * 8 + origin_x] = avg;
            curr_state = Idle;
        end
        Counterclockwise: begin
            temp1 = buffer[(origin_y - 1) * 8 + origin_x - 1];
            buffer[(origin_y - 1) * 8 + origin_x - 1] = buffer[(origin_y - 1) * 8 + origin_x];
            buffer[(origin_y - 1) * 8 + origin_x] = buffer[origin_y * 8 + origin_x];
            buffer[origin_y * 8 + origin_x] = buffer[origin_y * 8 + origin_x - 1];
            buffer[origin_y * 8 + origin_x - 1] = temp1;
            curr_state = Idle;
        end
        Clockwise: begin
            temp1 = buffer[(origin_y - 1) * 8 + origin_x - 1];
            buffer[(origin_y - 1) * 8 + origin_x - 1] = buffer[origin_y * 8 + origin_x - 1];
            buffer[origin_y * 8 + origin_x - 1] = buffer[origin_y * 8 + origin_x];
            buffer[origin_y * 8 + origin_x] = buffer[(origin_y - 1) * 8 + origin_x];
            buffer[(origin_y - 1) * 8 + origin_x] = temp1;
            curr_state = Idle;
        end
        Mirror_X: begin
            temp1 = buffer[(origin_y - 1) * 8 + origin_x - 1];
            temp2 = buffer[(origin_y - 1) * 8 + origin_x];
            buffer[(origin_y - 1) * 8 + origin_x - 1] = buffer[origin_y * 8 + origin_x - 1];
            buffer[(origin_y - 1) * 8 + origin_x] = buffer[origin_y * 8 + origin_x];
            buffer[origin_y * 8 + origin_x - 1] = temp1;
            buffer[origin_y * 8 + origin_x] = temp2; 
            curr_state = Idle;
        end
        Mirror_Y: begin
            temp1 = buffer[(origin_y - 1) * 8 + origin_x - 1];
            temp2 = buffer[origin_y * 8 + origin_x - 1];
            buffer[(origin_y - 1) * 8 + origin_x - 1] = buffer[(origin_y - 1) * 8 + origin_x];
            buffer[origin_y * 8 + origin_x - 1] = buffer[origin_y * 8 + origin_x];
            buffer[(origin_y - 1) * 8 + origin_x] = temp1;
            buffer[origin_y * 8 + origin_x] = temp2;
            curr_state = Idle;
        end
        Reset: begin
            IROM_rd = 1;
            IROM_A = 0;
            IRAM_valid = 0;
            IRAM_D = 0;
            IRAM_A = 64;
            busy = 1;
            done = 0;

            for(i = 0; i < 64; i = i+1)
                buffer[i] = 0; 
            origin_x = 4;
            origin_y = 4;
            IRAM_A_temp = 0;

            next_state = Load;
        end
        Idle: curr_state = Idle;
        default: curr_state = curr_state;
    endcase
end



endmodule



