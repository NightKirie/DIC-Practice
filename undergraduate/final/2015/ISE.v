`timescale 1ns/10ps
module ISE( clk, reset, image_in_index, pixel_in, busy, out_valid, color_index, image_out_index);
input           clk;
input           reset;
input   [4:0]   image_in_index;
input   [23:0]  pixel_in;   // R - 23:16, G - 15:8, B - 7:0 
output reg         busy;
output reg         out_valid;
output reg [1:0]   color_index;
output reg [4:0]   image_out_index;

reg [2:0] curr_state, next_state;
reg [13:0] red_count, green_count, blue_count;  // for each image temporary store color count
reg [21:0] red_amount, green_amount, blue_amount;   // for each image temporary store color amount
reg [1:0] color_index_list [0:31];
reg [4:0] image_out_index_list[0:31];



parameter R1 = 23, R2 = 16;
parameter G1 = 15, G2 = 8;
parameter B1 = 7, B2 = 0;

parameter LOAD = 3'd0;

always @(posedge clk, posedge reset) begin
    if(reset) begin
        busy <= 0;
        out_valid <= 0;
        
        curr_state <= LOAD;
    end
    else begin
        curr_state <= next_state;
        case (curr_state)
            LOAD: begin
                
            end
        endcase
    end
end

always @(*) begin
    case (curr_state)
        LOAD: begin
            
        end
    endcase
end

always @(*) begin
    case (curr_state)
        LOAD: begin
            red_count = (pixel_in[R1:R2] >= pixel_in[G1:G2] && pixel_in[R1:R2] >= pixel_in[B1:B2]) ? red_count + 1 : red_count;
            green_count = (pixel_in[G1:G2] >= pixel_in[B1:B2] && pixel_in[G1:G2] > pixel_in[R1:R2]) ? green_count + 1 : green_count;
            blue_count = (pixel_in[B1:B2] > pixel_in[R1:R2] && pixel_in[B1:B2] > pixel_in[G1:G2]) ? blue_count + 1 : blue_count;
        end
    endcase
end

endmodule
