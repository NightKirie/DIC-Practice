module huffman(clk, reset, gray_valid, gray_data, CNT_valid, CNT1, CNT2, CNT3, CNT4, CNT5, CNT6,
    code_valid, HC1, HC2, HC3, HC4, HC5, HC6, M1, M2, M3, M4, M5, M6);

input clk;
input reset;
input gray_valid;
input [7:0] gray_data;
output reg CNT_valid;
output reg [7:0] CNT1, CNT2, CNT3, CNT4, CNT5, CNT6;    // store the number of A1 ~ A6 
output reg code_valid;      
output reg [7:0] HC1, HC2, HC3, HC4, HC5, HC6;
output reg [7:0] M1, M2, M3, M4, M5, M6;


reg [2:0] curr_state, next_state;
reg [6:0] counter;
reg [2:0] sorted_index [0:5];

parameter LOAD = 3'd0;
parameter CAL_HUFFMAN = 3'd1;

always @(posedge clk ) begin
    if(reset) begin
        CNT1 <= 0;
        CNT2 <= 0;
        CNT3 <= 0;
        CNT4 <= 0;
        CNT5 <= 0;
        CNT6 <= 0;
        counter <= 0;

        curr_state <= LOAD;
    end
    else begin
        curr_state <= next_state;
        case (curr_state)
            LOAD: begin
                if(gray_valid) begin
                    case(gray_data) 
                        8'd1: CNT1 <= CNT1 + 1;
                        8'd2: CNT2 <= CNT2 + 1;
                        8'd3: CNT3 <= CNT3 + 1;
                        8'd4: CNT4 <= CNT4 + 1;
                        8'd5: CNT5 <= CNT5 + 1;
                        8'd6: CNT6 <= CNT6 + 1; 
                    endcase
                    counter <= counter + 1;
                end
            end 
            CAL_HUFFMAN: begin
            end
        endcase
    end
end

always @(*) begin
    case (curr_state)
        LOAD: begin
            next_state = (counter == 7'd99) ? CAL_HUFFMAN : LOAD;
        end 
    endcase
end

endmodule

