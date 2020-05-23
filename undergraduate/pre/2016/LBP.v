
`timescale 1ns/10ps
module LBP ( clk, reset, gray_addr, gray_req, gray_ready, gray_data, lbp_addr, lbp_valid, lbp_data, finish);
input  clk;
input  reset;
input  gray_ready;
input  [7:0] gray_data;

output reg [13:0] gray_addr;
output reg gray_req;
output reg [13:0] lbp_addr;
output reg lbp_valid;
output reg [7:0] lbp_data;
output reg finish;
//====================================================================

reg curr_state, next_state;
reg [3:0] counter;
reg [7:0] buffer [0:8];
reg [13:0] curr_addr;

parameter LOAD = 0;
parameter OUTPUT = 1;

always @(posedge clk) begin
    if(reset) begin
        curr_addr <= 14'd129;
        counter <= 4'd0;
        gray_req <= 0;
        lbp_valid <= 0;
        finish <= 0;
        curr_state <= LOAD;
    end
    else begin
        curr_state <= next_state;
        case (curr_state)
            LOAD: begin
                if(gray_ready) begin
                    lbp_valid <= 0;
                    if(curr_addr[6:0] == 7'd1) begin
                        case(counter) 
                            4'd0: begin
                                gray_addr <= curr_addr - 14'd129;
                                gray_req <= 1;
                            end
                            4'd1, 4'd2, 4'd4, 4'd5, 4'd7, 4'd8: begin
                                gray_addr <= gray_addr + 14'd1;
                                gray_req <= 1;
                                buffer[counter-1] <= gray_data;
                            end
                            4'd3, 4'd6: begin
                                gray_addr <= gray_addr + 14'd126;
                                gray_req <= 1;
                                buffer[counter-1] <= gray_data;
                            end
                            4'd9: begin
                                gray_req <= 0;
                                buffer[counter-1] <= gray_data;
                            end        
                        endcase
                        counter <= (counter == 9) ? 0 : counter + 1;
                    end
                    else begin
                        case(counter) 
                            4'd0: begin
                                buffer[0] <= buffer[1];
                                buffer[1] <= buffer[2];
                                buffer[3] <= buffer[4];
                                buffer[4] <= buffer[5];
                                buffer[6] <= buffer[7];
                                buffer[7] <= buffer[8];

                                gray_addr <= curr_addr - 14'd127;
                                gray_req <= 1;
                            end
                            4'd1: begin
                                buffer[2] <= gray_data;
                                gray_addr <= gray_addr + 14'd128;
                                gray_req <= 1;
                            end
                            4'd2: begin
                                buffer[5] <= gray_data;
                                gray_addr <= gray_addr + 14'd128;
                                gray_req <= 1;
                            end
                            4'd3: begin
                                buffer[8] <= gray_data;
                                gray_req <= 0;
                            end   
                        endcase
                        counter <= (counter == 3) ? 0 : counter + 1;     
                    end
                end
            end  
            OUTPUT: begin
                lbp_data <= ((((buffer[0] >= buffer[4]) ? 1 : 0) + ((buffer[1] >= buffer[4]) ? 2 : 0)) + (((buffer[2] >= buffer[4]) ? 4 : 0) + ((buffer[3] >= buffer[4]) ? 8 : 0))) +
                             ((((buffer[5] >= buffer[4]) ? 16 : 0) + ((buffer[6] >= buffer[4]) ? 32 : 0)) + (((buffer[7] >= buffer[4]) ? 64 : 0) + ((buffer[8] >= buffer[4]) ? 128 : 0)));
                lbp_addr <= curr_addr;
                lbp_valid <= 1;
                finish <= (curr_addr == 14'd16254) ? 1 : 0;
                curr_addr <= (curr_addr[6:0] == 7'd126) ? curr_addr + 3 : curr_addr + 1;
            end
        endcase
    end
end

always @(*) begin
    case (curr_state)
        LOAD: 
            if(curr_addr[6:0] == 7'd1)
                next_state = (counter == 9) ? OUTPUT : LOAD;
            else
                next_state = (counter == 3) ? OUTPUT : LOAD;
        OUTPUT: 
            next_state = LOAD;
    endcase
end




//====================================================================
endmodule
