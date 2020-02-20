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
reg [3:0] curr_state;
reg [7:0] buffer [0:63];

parameter Input = 3'b000;

always@(posedge clk) begin
    if(reset) begin
        IROM_EN <= 0;
        IROM_A <= 0;
        busy <= 1;
        done <= 0;
        IRB_A <= 0;
        IRB_D <= 0;
        IRB_RW <= 1;
        
        curr_state <= Input;
    end
    else begin
        case(curr_state) 

        endcase
    end
end

always@(*) begin
    case(curr_state) 

    endcase
end

endmodule

