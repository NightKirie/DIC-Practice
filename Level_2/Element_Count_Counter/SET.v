module SET ( clk , rst, en, central, radius, mode, busy, valid, candidate );

input clk, rst;
input en;
input [23:0] central;
input [11:0] radius;
input [1:0] mode;

output reg busy;
output reg valid;
output reg [7:0] candidate;

reg [1:0] curr_state, next_state;
reg [3:0] x1, y1, x2, y2, r1, r2, curr_x, curr_y;

wire [3:0] diff_x1, diff_y1, diff_x2, diff_y2;
wire [7:0] r1_sqr, r2_sqr, diff_x1_sqr, diff_y1_sqr, diff_x2_sqr, diff_y2_sqr, dist_a, dist_b;

assign diff_x1 = (curr_x > x1) ? curr_x - x1 : x1 - curr_x;
assign diff_y1 = (curr_y > y1) ? curr_y - y1 : y1 - curr_y;
assign diff_x2 = (curr_x > x2) ? curr_x - x2 : x2 - curr_x;
assign diff_y2 = (curr_y > y2) ? curr_y - y2 : y2 - curr_y;

assign diff_x1_sqr = diff_x1 * diff_x1;
assign diff_y1_sqr = diff_y1 * diff_y1;
assign diff_x2_sqr = diff_x2 * diff_x2;
assign diff_y2_sqr = diff_y2 * diff_y2;

assign r1_sqr = r1 * r1; 
assign r2_sqr = r2 * r2;

parameter WAIT = 2'b00;
parameter INPUT = 2'b01;
parameter COMPARE = 2'b10;
parameter OUTPUT = 2'b11;

always@(posedge clk) begin
    if(rst) begin
        busy <= 0;
        curr_state <= WAIT;   
    end 
    else begin
        curr_state <= next_state;
        case (curr_state)
            WAIT: begin
                curr_x <= 1;
                curr_y <= 1;
                candidate <= 0;
                valid <= 0;
            end
            INPUT: begin
                x1 <= central[23:20];
                y1 <= central[19:16];
                x2 <= central[15:12];
                y2 <= central[11:8];
                r1 <= radius[11:8];
                r2 <= radius[7:4];
                busy <= 1;
            end
            COMPARE: begin
                case (mode)
                    2'b00: 
                        candidate <= ((diff_x1_sqr + diff_y1_sqr) <= r1_sqr) ? candidate + 1 : candidate;
                    2'b01: 
                        candidate <= ((diff_x1_sqr + diff_y1_sqr) <= r1_sqr && (diff_x2_sqr + diff_y2_sqr) <= r2_sqr) ? candidate + 1 : candidate;
                    2'b10: 
                        candidate <= (((diff_x1_sqr + diff_y1_sqr) <= r1_sqr) ^ ((diff_x2_sqr + diff_y2_sqr) <= r2_sqr)) ? candidate + 1 : candidate;
                endcase
                curr_x <= (curr_x == 8) ? 1 : curr_x + 1;
                curr_y <= (curr_x == 8) ? curr_y + 1 : curr_y;
            end
            OUTPUT: begin
                valid <= 1;
                busy <= 0;
            end
        endcase
    end
end

always @(*) begin
    case (curr_state)
        WAIT: 
            next_state = (en) ? INPUT : WAIT; 
        INPUT: 
            next_state = COMPARE;
        COMPARE: 
            next_state = (curr_x == 8 && curr_y == 8) ? OUTPUT : COMPARE;
        OUTPUT:
            next_state = WAIT;
    endcase
end



endmodule
