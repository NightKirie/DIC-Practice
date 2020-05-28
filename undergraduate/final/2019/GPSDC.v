`timescale 1ns/10ps
module GPSDC(clk, reset_n, DEN, LON_IN, LAT_IN, COS_ADDR, COS_DATA, ASIN_ADDR, ASIN_DATA, Valid, a, D);
input              clk;
input              reset_n;
input              DEN;
input      [23:0]  LON_IN;
input      [23:0]  LAT_IN;
input      [95:0]  COS_DATA;
output  reg   [6:0]   COS_ADDR;
input      [127:0] ASIN_DATA;
output  reg   [5:0]   ASIN_ADDR;
output  reg           Valid = 0;
output  reg   [39:0]  D;
output  reg   [63:0]  a;

reg [2:0] curr_state, next_state;
reg [23:0] lat_a, lon_a, lat_b, lon_b;
reg [63:0] lat_sin, lon_sin;
reg [2:0] counter = 3'd0;

// wire [23:0] diff_lat = (lat_a > lat_b) ? lat_a - lat_b : lat_b - lat_a;
// wire [23:0] diff_lon = (lon_a > lon_b) ? lon_a - lon_b : lon_b - lon_a;
 
parameter rad = 16'h477;
parameter R = 24'd12756274;

parameter LOAD_1 = 3'd0;
parameter LOAD_2 = 3'd1;
parameter GET_SIN = 3'd2;
parameter IDLE = 3'd3;


always @(posedge clk, negedge reset_n) begin
    if(!reset_n)begin        
        curr_state <= IDLE;
    end
    else begin
        curr_state <= next_state;
        // case(curr_state)
        //     LOAD_1: begin
        //         if(DEN) begin
        //             lat_a <= LAT_IN;
        //             lon_a <= LON_IN; 
        //         end
        //     end
        //     LOAD_2: begin
        //         if(DEN) begin
        //             lat_b <= LAT_IN;
        //             lon_b <= LON_IN; 
        //         end
        //     end
        //     default: begin
        //         Valid <= 0;
        //     end
        // endcase
    end
end

always @(*) begin
    case (curr_state)
        IDLE: begin
            next_state = (DEN) ? LOAD_1 : IDLE;
        end
        LOAD_1: begin
            next_state = (DEN) ? LOAD_2 : LOAD_1;   
        end
        LOAD_2: begin
            next_state = GET_SIN;  
        end
        GET_SIN: begin
            next_state = (counter == 3) ? LOAD_2 : GET_SIN;
        end
        default: begin
            next_state = next_state;
        end
    endcase
end

always @(curr_state) begin
    case(curr_state) 
        LOAD_1: begin
            lat_a = (DEN) ? LAT_IN : lat_a;
            lon_a = (DEN) ? LON_IN : lat_a;
        end
        LOAD_2: begin
            lat_b = (DEN) ? LAT_IN : lat_b;
            lon_b = (DEN) ? LON_IN : lon_b;
        end
        GET_SIN: begin
            lat_sin = (lat_a > lat_b) ? lat_a - lat_b : lat_b - lat_a;
            
            lat_sin = ((lat_sin + (lat_sin << 1)) + ((lat_sin << 2) + (lat_sin << 4))) + (((lat_sin << 5) + (lat_sin << 6)) + (lat_sin << 10));
            lat_sin = lat_sin >> 1;
            lat_sin = lat_sin[31:0] * lat_sin[31:0];

            lon_sin = (lon_a > lon_b) ? lon_a - lon_b : lon_b - lon_a;
            
            lon_sin = ((lon_sin + (lon_sin << 1)) + ((lon_sin << 2) + (lon_sin << 4))) + (((lon_sin << 5) + (lon_sin << 6)) + (lon_sin << 10));
            lon_sin = lon_sin >> 1;
            lon_sin = lon_sin[31:0] * lon_sin[31:0];
        end
        default: begin
            lat_a = lat_a;
            lon_a = lon_a;
            lat_b = lat_b;
            lon_b = lon_b;
            lat_sin = lat_sin;
            lon_sin = lon_sin;
        end
    endcase
end



endmodule
