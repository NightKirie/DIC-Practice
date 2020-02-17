module SET ( clk , rst, en, central, radius, mode, busy, valid, candidate );

input clk, rst;
input en;
input [23:0] central;
input [11:0] radius;
input [1:0] mode;

output reg busy;
output reg valid;
output reg [7:0] candidate;

reg [1:0] curr_state, curr_mode;
reg [3:0] x1, y1, x2, y2;
reg [7:0] r1_sqr, r2_sqr, dist_a, dist_b;
reg [7:0] curr_candidate;
parameter Input = 2'b00;
parameter Output = 2'b01;

integer i, j;

always@(posedge clk) begin
    if(rst) begin
        busy <= 0;
        valid <= 0;
        candidate <= 0;

        curr_mode <= 0;

        curr_state <= Input;   
    end 
    else begin
        case (curr_state)
            Input: begin
                if (en) begin
                    x1 <= central[23:20];
                    y1 <= central[19:16];
                    x2 <= central[15:12];
                    y2 <= central[11:8];
                    r1_sqr <= radius[11:8] ** 2;
                    r2_sqr <= radius[7:4] ** 2;
                    curr_mode <= mode;
                    busy <= 1;

                    curr_state <= Output;
                end
            end
            Output: begin
                candidate <= curr_candidate;
                valid <= 1;
                busy <= 0;

                curr_state <= Input;
            end
            default: begin
                busy <= 0;
            end
        endcase
    end
end

always @(*) begin
    case (curr_state) 
        Output: begin
            case(mode)
                /* A */
                2'b00: begin
                    for (i = 1; i < 9; i = i+1)
                        for (j = 1; j < 9; j = j+1) begin
                            dist_a = (i - x1) ** 2 + (j - y1) ** 2;
                            dist_b = 0;
                            if ((dist_a <= r1_sqr) ^ (dist_b <= r2_sqr)) begin
                                curr_candidate = curr_candidate + 1;
                            end
                            else begin
                                curr_candidate = curr_candidate;
                            end 
                        end
                end
                /* A and B */
                2'b01: begin
                    for (i = 1; i < 9; i = i+1)
                        for (j = 1; j < 9; j = j+1) begin
                            dist_a = (i - x1) ** 2 + (j - y1) ** 2;
                            dist_b = (i - x2) ** 2 + (j - y2) ** 2;
                            if ((dist_a <= r1_sqr) ^ (dist_b <= r2_sqr)) begin
                                curr_candidate = curr_candidate + 1;
                            end
                            else begin
                                curr_candidate = curr_candidate;
                            end 
                        end
                end
                /* A xor B */
                2'b10: begin
                    for (i = 1; i < 9; i = i+1)
                        for (j = 1; j < 9; j = j+1) begin
                            dist_a = (i - x1) ** 2 + (j - y1) ** 2;
                            dist_b = (i - x2) ** 2 + (j - y2) ** 2;
                            if ((dist_a <= r1_sqr) ^ (dist_b <= r2_sqr)) begin
                                curr_candidate = curr_candidate + 1;
                            end
                            else begin
                                curr_candidate = curr_candidate;
                            end
                        end
                end
                default: begin
                    dist_a = 0;
                    dist_b = 0;
                    curr_candidate = 0;
                end
            endcase
        end
        default: begin
            dist_a = 0;
            dist_b = 0;
            curr_candidate = 0;
        end
    endcase
end



endmodule
