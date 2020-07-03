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
reg [3:0] x_a, y_a, x_b, y_b, x_c, y_c;
reg [3:0] r_a, r_b, r_c;
reg [3:0] curr_x, curr_y;

wire [3:0] diff_x_a, diff_y_a, diff_x_b, diff_y_b, diff_x_c, diff_y_c;
wire [7:0] r_a_sqr, r_b_sqr, r_c_sqr;
wire [7:0] diff_x_a_sqr, diff_y_a_sqr, diff_x_b_sqr, diff_y_b_sqr, diff_x_c_sqr, diff_y_c_sqr;
wire [7:0] dist_a, dist_b, dist_c;
wire A, B, C;

assign diff_x_a = (curr_x > x_a) ? curr_x - x_a : x_a - curr_x;
assign diff_y_a = (curr_y > y_a) ? curr_y - y_a : y_a - curr_y;
assign diff_x_b = (curr_x > x_b) ? curr_x - x_b : x_b - curr_x;
assign diff_y_b = (curr_y > y_b) ? curr_y - y_b : y_b - curr_y;
assign diff_x_c = (curr_x > x_c) ? curr_x - x_c : x_c - curr_x;
assign diff_y_c = (curr_y > y_c) ? curr_y - y_c : y_c - curr_y;

assign diff_x_a_sqr = diff_x_a * diff_x_a;
assign diff_y_a_sqr = diff_y_a * diff_y_a;
assign diff_x_b_sqr = diff_x_b * diff_x_b;
assign diff_y_b_sqr = diff_y_b * diff_y_b;
assign diff_x_c_sqr = diff_x_c * diff_x_c;
assign diff_y_c_sqr = diff_y_c * diff_y_c;

assign r_a_sqr = r_a * r_a; 
assign r_b_sqr = r_b * r_b;
assign r_c_sqr = r_c * r_c;

assign A = (diff_x_a_sqr + diff_y_a_sqr) <= r_a_sqr;
assign B = (diff_x_b_sqr + diff_y_b_sqr) <= r_b_sqr;
assign C = (diff_x_c_sqr + diff_y_c_sqr) <= r_c_sqr;


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
                x_a <= central[23:20];
                y_a <= central[19:16];
                x_b <= central[15:12];
                y_b <= central[11:8];
                x_c <= central[7:4];
                y_c <= central[3:0];
                r_a <= radius[11:8];
                r_b <= radius[7:4];
                r_c <= radius[3:0];
                busy <= 1;
            end
            COMPARE: begin
                case (mode)
                    2'b00: // A
                        candidate <= (A) ? candidate + 1 : candidate;
                    2'b01: // A & B
                        candidate <= (A & B) ? candidate + 1 : candidate;
                    2'b10: // A ^ B
                        candidate <= (A ^ B) ? candidate + 1 : candidate;
                    2'b11: // A & B + B & C + A & C - A & B & C
                        candidate <= ((~A & B & C) | (A & ~B & C) | (A & B & ~C)) ? candidate + 1 : candidate;
                endcase
                curr_x <= (curr_x[3]) ? 1 : curr_x + 1;
                curr_y <= (curr_x[3]) ? curr_y + 1 : curr_y;
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
            next_state = (curr_x[3] & curr_y[3]) ? OUTPUT : COMPARE;
        OUTPUT:
            next_state = WAIT;
    endcase
end



endmodule
