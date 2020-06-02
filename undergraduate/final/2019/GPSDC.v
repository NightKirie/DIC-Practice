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

/* sin & cos ignore integer part, because a don't care about integer part */

/* 
    (8-bit, 16-bit) * (0-bit, 16-bit) => (8-bit, 32-bit)
    (0-bit, 32-bit) * (0-bit, 32-bit) => (0-bit, 64-bit)
 */
reg [63:0] sin_lat, sin_lon;  

/* 
    (16-bit, 32-bit) * (16-bit, 32-bit) => (32-bit, 64-bit)
    (32-bit, 64-bit) / (16-bit, 32-bit) => (64-bit, 64-bit) / (48-bit, 0-bit) 
 */ 
reg [64:0] cos_a, cos_b; 
reg [63:0] x0, y0, x1, y1;
reg [127:0] reg_128;
reg has_two_point, found_flag;
 
//parameter rad = 16'h477;
//parameter R = 24'd12756274;

parameter LOAD = 3'd0;
parameter FIND_COS = 3'd1;
parameter GET_COS = 3'd2;
parameter GET_SIN = 3'd3;
parameter GET_A = 3'd4;
parameter FIND_ASIN = 3'd5;
parameter GET_ASIN = 3'd6;
parameter GET_D = 3'd7;

always @(posedge clk, negedge reset_n) begin
    if(!reset_n) begin      
        COS_ADDR <= 0;
        ASIN_ADDR <= 0;

        has_two_point <= 0;
        found_flag <= 0;

        curr_state <= LOAD;
    end
    else begin
        curr_state <= next_state;
        case(curr_state)
            LOAD: begin
                Valid <= 0;
                if(DEN) begin                    
                    lat_a <= lat_b;
                    lon_a <= lon_b;
                    lat_b <= LAT_IN;
                    lon_b <= LON_IN; 
                    
                    cos_a <= cos_b;
                end
            end
            FIND_COS: begin
                if(!found_flag) begin
                    if(COS_DATA[87:64] > lat_b) begin
                        found_flag <= 1;

                        x1 <= COS_DATA[95:48];
                        y1 <= COS_DATA[47:0];
                    end
                    else begin
                        x0 <= COS_DATA[95:48];
                        y0 <= COS_DATA[47:0];
                    end
                end
                COS_ADDR <= COS_ADDR + 1;
            end
            GET_COS: begin
                COS_ADDR <= 0;
                found_flag <= 0;
                cos_b <= reg_128[63:0];
                has_two_point <= 1;
            end
            GET_A: begin
                a <= reg_128[63:0];
            end
            FIND_ASIN: begin
                 if(!found_flag) begin
                    if(ASIN_DATA[127:64] > a) begin
                        found_flag <= 1;

                        x1 <= ASIN_DATA[127:64];
                        y1 <= ASIN_DATA[63:0];
                    end
                    else begin
                        x0 <= ASIN_DATA[127:64];
                        y0 <= ASIN_DATA[63:0];
                    end
                end
                ASIN_ADDR <= ASIN_ADDR + 1;
            end
            GET_ASIN: begin
                ASIN_ADDR <= 0;
                found_flag <= 0;
            end
            GET_D: begin
                Valid <= 1;
                D <= reg_128[71:32];
            end
        endcase
    end
end

always @(*) begin
    case (curr_state)
        LOAD: begin
            next_state = (DEN) ? FIND_COS : LOAD;   
        end   
        FIND_COS: begin
            next_state = (found_flag) ? GET_COS : FIND_COS;
        end
        GET_COS: begin
            next_state = (has_two_point) ? GET_SIN : LOAD;
        end
        GET_SIN: begin
            next_state = GET_A;
        end
        GET_A: begin
            next_state = FIND_ASIN;
        end
        FIND_ASIN: begin
            next_state = (found_flag) ? GET_ASIN : FIND_ASIN;
        end
        GET_ASIN: begin
            next_state = GET_D;
        end
        GET_D: begin
            next_state = LOAD;
        end
    endcase
end

always @(curr_state) begin
    case(curr_state) 
        GET_COS: begin
            reg_128 = (y0 * (x1 - x0) + ({lat_b, 16'd0} - x0) * (y1 - y0));
            reg_128 = {reg_128, 32'd0} / (x1 - x0);     
        end
        GET_SIN: begin
            sin_lat = (lat_a > lat_b) ? (lat_a - lat_b) : (lat_b - lat_a);
            sin_lat = ((sin_lat + (sin_lat << 1)) + ((sin_lat << 2) + (sin_lat << 4))) + (((sin_lat << 5) + (sin_lat << 6)) + (sin_lat << 10));
            sin_lat = sin_lat >> 1;
            sin_lat = sin_lat[31:0] * sin_lat[31:0];

            sin_lon = (lon_a > lon_b) ? (lon_a - lon_b) : (lon_b - lon_a);
            sin_lon = ((sin_lon + (sin_lon << 1)) + ((sin_lon << 2) + (sin_lon << 4))) + (((sin_lon << 5) + (sin_lon << 6)) + (sin_lon << 10));
            sin_lon = sin_lon >> 1;
            sin_lon = sin_lon[31:0] * sin_lon[31:0];
        end
        GET_A: begin
            reg_128 = cos_a * cos_b;
            reg_128 = reg_128[127:64] * sin_lon[31:0];
            reg_128 = sin_lat[31:0] + reg_128[127:64];
        end
        GET_ASIN: begin
            reg_128 = y0 * (x1 - x0) + (a - x0) * (y1 - y0);
            reg_128 = reg_128 / (x1 - x0);
        end
        GET_D: begin
            reg_128 = (reg_128 << 23) + (reg_128 << 22) + (reg_128 << 17) + (reg_128 << 15) + (reg_128 << 13) + (reg_128 << 10) + (reg_128 << 8) + (reg_128 << 5) + (reg_128 << 4) + (reg_128 << 1);
        end
        default: begin
            reg_128 = 0;
            sin_lat = 0;
            sin_lon = 0;
        end
    endcase
end



endmodule
