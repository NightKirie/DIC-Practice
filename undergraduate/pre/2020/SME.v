module SME(clk,reset,chardata,isstring,ispattern,valid,match,match_index);

input clk;
input reset;
input [7:0] chardata;
input isstring;
input ispattern;

output reg match;
output reg [4:0] match_index;
output reg valid;

reg [7:0] string [0:31];
reg [7:0] pattern [0:7];
reg [5:0] string_length, string_counter;
reg [3:0] pattern_length, pattern_counter;
reg [2:0] curr_state, next_state;
reg [1:0] compare_mode;
reg begin_flag, end_flag;
reg [3:0] begin_dot, end_dot;
reg [2:0] dot_counter;

parameter INPUT = 3'd0;
parameter STORE_LENGTH = 3'd1; 
parameter COUNT_BEGIN_DOT = 3'd2;
parameter COUNT_END_DOT = 3'd3;
parameter COMPARE = 3'd4;
parameter OUTPUT = 3'd5;

parameter BEGIN_END = 2'd0;
parameter BEGIN = 2'd1;
parameter END = 2'd2;
parameter NONE = 2'd3;


always @(posedge clk) begin
    if(reset) begin
        match <= 0;
        match_index <= 5'd0;
        valid <= 0;

        string_length <= 6'd0;
        pattern_length <= 4'd0;
        string_counter <= 6'd0;
        pattern_counter <= 4'd0;
        begin_flag <= 0;
        end_flag <= 0;
        begin_dot <= 4'd0;
        end_dot <= 4'd0;
        dot_counter <= 3'd0;

        curr_state <= INPUT;
    end
    else begin
        curr_state <= next_state;
        case (curr_state)
            INPUT: begin
                match <= 0;
                match_index <= 5'd0;
                valid <= 0;
                
                if(isstring) begin
                    string[string_counter] <= chardata;
                    string_counter <= string_counter + 1;
                end
                else if(ispattern) begin
                    pattern[pattern_counter] <= chardata;
                    pattern_counter <= pattern_counter + 1;
                    case(chardata)
                        8'h24: end_flag <= 1;
                        8'h5E: begin_flag <= 1;
                    endcase
                end
            end
            STORE_LENGTH: begin
                if(begin_flag && end_flag) begin
                    pattern_length <= pattern_counter - 4'd1;
                    pattern_counter <= 1;
                    dot_counter <= 3'd1;
                    compare_mode <= BEGIN_END;
                end
                else if(begin_flag && !end_flag) begin
                    pattern_length <= pattern_counter;
                    pattern_counter <= 1;
                    dot_counter <= 3'd1;
                    compare_mode <= BEGIN;
                end
                else if(!begin_flag && end_flag) begin
                    pattern_length <= pattern_counter - 4'd1;
                    pattern_counter <= 0;
                    dot_counter <= 3'd0;
                    compare_mode <= END;
                end
                else begin
                    pattern_length <= pattern_counter;
                    pattern_counter <= 0;
                    dot_counter <= 3'd0;
                    compare_mode <= NONE;
                end
                string_length <= (string_counter == 6'd0) ? string_length : string_counter;
                string_counter <= 6'd0;
            end
            COUNT_BEGIN_DOT: begin
                if(pattern[dot_counter] == 8'h2E)
                    begin_dot <= begin_dot + 1;
                dot_counter <= (dot_counter == pattern_length - 1 || pattern[dot_counter] != 8'h2E) ? pattern_length - 1 : dot_counter + 1;
            end
            // COUNT_END_DOT: begin
            //     case (compare_mode)
            //         BEGIN_END, BEGIN: pattern_counter <= begin_dot+1;
            //         END, NONE: pattern_counter <= begin_dot;
            //     endcase
            // end
            COMPARE: begin
                case (compare_mode)
                    BEGIN_END: begin
                        if(string[string_counter] == pattern[pattern_counter] || pattern[pattern_counter] == 8'h2E) begin
                            
                            pattern_counter <= pattern_counter + 4'd1;
                            if(pattern_counter == pattern_length - 1 && string_counter - pattern_length + 1 >= 0) begin
                                
                                if((pattern_length == string_counter || string[string_counter - pattern_length + 1] == 8'h20) &&
                                   (string_counter == string_length - 1 || string[string_counter + 1] == 8'h20)) begin
                                    match_index <= string_counter - pattern_length + 2;
                                    match <= 1;   
                                end   
                                else begin
                                    pattern_counter <= begin_dot;
                                end
                            end                     
                        end
                        else begin
                            if(string[string_counter] == pattern[begin_dot+1])
                                pattern_counter <= begin_dot + 2;
                            else
                                pattern_counter <= begin_dot + 1;
                        end 
                        string_counter <= string_counter + 1;
                    end
                    BEGIN: begin
                        if(string[string_counter] == pattern[pattern_counter] || pattern[pattern_counter] == 8'h2E) begin
                            pattern_counter <= pattern_counter + 4'd1;
                            if(pattern_counter == pattern_length - 1 && string_counter - pattern_length + 1 >= 0) begin
                                if(string_counter - pattern_length == 0 || string[string_counter - pattern_length + 1] == 8'h20) begin
                                    match_index <= string_counter - pattern_length + 2;
                                    match <= 1;   
                                end 
                            end                     
                        end
                        else begin
                            if(string[string_counter] == pattern[begin_dot+1])
                                pattern_counter <= begin_dot + 2;
                            else
                                pattern_counter <= begin_dot + 1;
                        end 
                        string_counter <= string_counter + 1;
                    end
                    END: begin
                        if(string[string_counter] == pattern[pattern_counter] || pattern[pattern_counter] == 8'h2E) begin
                            pattern_counter <= pattern_counter + 4'd1;
                            if(pattern_counter == pattern_length - 1 && string_counter - pattern_length >= 0) begin
                                if(string_counter == string_length - 1 || string[string_counter + 1] == 8'h20) begin
                                    match_index <= string_counter - pattern_length + 1;
                                    match <= 1;   
                                end
                            end                     
                        end
                        else begin
                            if(string[string_counter] == pattern[begin_dot])
                                pattern_counter <= begin_dot + 1;
                            else
                                pattern_counter <= begin_dot;
                        end 
                        string_counter <= string_counter + 1;
                    end
                    NONE: begin
                        if(string[string_counter] == pattern[pattern_counter] || pattern[pattern_counter] == 8'h2E) begin
                            pattern_counter <= pattern_counter + 4'd1;
                            if(pattern_counter == pattern_length - 1 && string_counter - pattern_length + 1 >= 0) begin
                                match_index <= string_counter - pattern_length + 1;
                                match <= 1;
                            end                     
                        end
                        else begin
                            if(string[string_counter] == pattern[begin_dot])
                                pattern_counter <= begin_dot + 1;
                            else
                                pattern_counter <= begin_dot;
                        end 
                        string_counter <= string_counter + 1;
                    end
                    
                endcase
            end
            OUTPUT: begin
                valid <= 1;
                
                string_counter <= 6'd0;
                pattern_counter <= 4'd0;
                begin_flag <= 0;
                end_flag <= 0;
                begin_dot <= 4'd0;
                end_dot <= 4'd0;
            end
        endcase
    end
end

always @(*) begin
    case (curr_state)
        INPUT: begin
            next_state = (ispattern || isstring) ? INPUT : STORE_LENGTH;
        end
        STORE_LENGTH: begin
            next_state = COUNT_BEGIN_DOT;
        end
        COUNT_BEGIN_DOT: begin
            next_state = (dot_counter == pattern_length - 1 || pattern[dot_counter] != 8'h2E) ? COMPARE : COUNT_BEGIN_DOT;
        end
        // COUNT_END_DOT: begin
        //     next_state = COMPARE;
        // end
        COMPARE: begin
            next_state = (match || string_counter == string_length - 1) ? OUTPUT : COMPARE;
        end
        OUTPUT: begin
            next_state = INPUT;
        end
        default: 
            next_state = INPUT;
    endcase
end

endmodule
