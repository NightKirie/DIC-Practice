module SET ( clk , rst, en, central, radius, mode, busy, valid, candidate );

input clk, rst;
input en;
input [23:0] central;
input [11:0] radius;
input [1:0] mode;

output reg busy;
output reg valid;
output reg [7:0] candidate;

reg [2:0] curr_state, next_state;
reg [3:0] x1, y1, x2, y2, r1, r2, curr_x, curr_y;
reg [7:0] r1_sqr, r2_sqr, dist_a, dist_b;
reg [7:0] curr_candidate;


parameter Input = 3'b000;
parameter Cal_Radius = 3'b001;
parameter Cal_Distance = 3'b010;
parameter Compare = 3'b011;
parameter Output = 3'b100;

integer i, j;

always@(posedge clk) begin
    if(rst) begin
        busy <= 0;

        curr_state <= Input;   
    end 
    else begin
        curr_state <= next_state;

        case (curr_state)
            Input: begin
                if (en) begin
                    x1 <= central[23:20];
                    y1 <= central[19:16];
                    x2 <= central[15:12];
                    y2 <= central[11:8];
                    curr_x <= 1;
                    curr_y <= 1;
                    r1 <= radius[11:8];
                    r2 <= radius[7:4];

                    candidate <= 0;
                    valid <= 0;
                    busy <= 1;
                    curr_state <= Cal_Radius;
                end
            end
            Cal_Radius: begin
                case (mode)
                    2'b00: begin
                        r1_sqr <= r1 * r1; 
                    end 
                    2'b01, 2'b10: begin
                        r1_sqr <= r1 * r1;
                        r2_sqr <= r2 * r2;
                    end
                    default: begin
                        r1_sqr <= r1_sqr;
                        r2_sqr <= r2_sqr;
                    end 
                endcase
            end
            Cal_Distance: begin
                case (mode)
                    2'b00: begin
                        dist_a <= (curr_x - x1) ** 2 + (curr_y - y1) ** 2;
                    end
                    2'b01, 2'b10: begin
                        dist_a <= (curr_x - x1) ** 2 + (curr_y - y1) ** 2;
                        dist_b <= (curr_x - x2) ** 2 + (curr_y - y2) ** 2;
                    end
                    default: begin
                        dist_a <= dist_a;
                        dist_b <= dist_b;
                    end 
                endcase
                curr_x <= (curr_x == 8) ? 1 : curr_x + 1;
                curr_y <= (curr_x == 8) ? curr_y + 1 : curr_y;
            end
            Compare: begin
                case (mode)
                    2'b00: 
                        candidate <= (dist_a <= r1_sqr) ? candidate + 1 : candidate;
                    2'b01: 
                        candidate <= (dist_a <= r1_sqr && dist_b <= r2_sqr) ? candidate + 1 : candidate;
                    2'b10: 
                        candidate <= ((dist_a <= r1_sqr) ^ (dist_b <= r2_sqr)) ? candidate + 1 : candidate;
                    default: 
                        candidate <= candidate;
                endcase
            end
            Output: begin
                valid <= 1;
                busy <= 0;
            end
            default: begin
                busy <= 0;
            end
        endcase
    end
end

always @(*) begin
    case (curr_state)
        Cal_Radius: 
            next_state = Cal_Distance;
        Cal_Distance: 
            next_state = (curr_x == 1 && curr_y == 9) ? Output : Compare;
        Compare: 
            next_state = Cal_Distance;
        Output:
            next_state = Input;
        default: 
            next_state = Input;
    endcase
end



endmodule
