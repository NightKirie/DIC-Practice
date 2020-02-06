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
reg [7:0] buffer[63:0];
// reg [6:0] input_count;
// reg [2:0] output_count;
reg [2:0] origin_x, origin_y;
reg [7:0] max;
reg [7:0] min;
reg [7:0] avg;
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
        curr_state = IDLE;
    else
        curr_state = next_state;
end

always@(*) begin
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
                next_state = Average;
            else
                next_state = next_state;
        end
        Clockwise: begin
            if(cmd_valid && !busy) 
                next_state = Average;
            else
                next_state = next_state;
        end
        Mirror_X: begin
            if(cmd_valid && !busy) 
                next_state = Average;
            else
                next_state = next_state;
        end
        Mirror_Y: begin
            if(cmd_valid && !busy) 
                next_state = Average;
            else
                next_state = next_state;
        end
    endcase
end

always@(*) begin
    case(curr_state)
        Write: begin

        end
        Shift_Up: begin

        end
        Shift_Down: begin

        end
        Shift_Left: begin
            
        end
        Shift_Right: begin
            
        end
        Max: begin
            
        end
        Min: begin
            
        end
        Average: begin
            
        end
        Counterclockwise: begin
            
        end
        Clockwise: begin
            
        end
        Mirror_X: begin
        
        end
        Mirror_Y: begin
            
        end
        Load: begin
            
        end
        Reset: begin
            
        end
        Idle: begin
            
        end
    endcase
end



endmodule



