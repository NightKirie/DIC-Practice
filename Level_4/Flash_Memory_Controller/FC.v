`timescale 1ns/100ps
module FC(clk, rst, cmd, done, M_RW, M_A, M_D, F_IO, F_CLE, F_ALE, F_REN, F_WEN, F_RB);

input clk;
input rst;
/***
    read(1)/write(0)[32]
    flash memory address[31:14]
    internal memory address[13:7]
    read/write length[6:0]
  ***/
input [32:0] cmd;   
input F_RB;             // 0 for flash memory is busy

output reg done;        // 1 for accepting cmd, 0 for busy r/w flash memmory
output reg M_RW;        // 1 for read internal memory, 0 for write interal memory
output reg [6:0] M_A;   // address for internal memory
output reg F_CLE;       // 1 for F_IO being seen as "command", flash memory read the command when F_WEN is at posedge
output reg F_ALE;       // 1 for F_IO being seen as "address", flash memory read the address when F_WEN is at posedge
output reg F_REN;       // continuous reading, data will appear at F_IO after (F_REN's negedge time + tREA), also forward address of flash memory with 1
output reg F_WEN;       // posedge for flash memory to read when F_IO is "command", "address", "data in", 1 for F_IO is "data out"

inout [7:0] M_D;        // internal memory input/output
inout [7:0] F_IO;       // flash memory input/output

reg rw_bit;
reg [17:0] flash_mem_addr;
reg [6:0] internal_mem_addr;
reg [6:0] rw_length;

parameter COMMAND = 3'b000;

always @(posedge clk) begin
    if (rst) begin
        done <= 0;
    end
    else begin
        
    end
end

always @(*) begin
  
end

endmodule