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
reg [63:0] sin_lat, cos_a, sin_lon, cos_b;
reg [6:0] counter = 3'd0;
reg [47:0] x0_a, y0_a, x1_a, y1_a, x0_b, y0_b, x1_b, y1_b;
reg found_flag_a, found_flag_b;

// wire [23:0] diff_lat = (lat_a > lat_b) ? lat_a - lat_b : lat_b - lat_a;
// wire [23:0] diff_lon = (lon_a > lon_b) ? lon_a - lon_b : lon_b - lon_a;
 
parameter rad = 16'h477;
parameter R = 24'd12756274;

//parameter IDLE = 3'd0;
parameter LOAD_1 = 3'd0;
parameter LOAD_2 = 3'd1;
parameter GET_SIN = 3'd2;
parameter GET_COS = 3'd3;
parameter GET_A = 3'd4;

always @(posedge clk, negedge reset_n) begin
    if(!reset_n) begin      
        COS_ADDR <= 0;
        ASIN_ADDR <= 0;

        found_flag_a <= 0;
        found_flag_b <= 0;

        curr_state <= LOAD_1;
    end
    else begin
        curr_state <= next_state;
        case(curr_state)
            LOAD_1: begin
                if(DEN) begin
                    lat_a <= LAT_IN;
                    lon_a <= LON_IN; 
                end
            end
            LOAD_2: begin
                if(DEN) begin
                    lat_b <= LAT_IN;
                    lon_b <= LON_IN; 
                end
            end
            GET_COS: begin
                if(!found_flag_a) begin
                    if(COS_DATA[87:64] > lat_a) begin
                        found_flag_a <= 1;
                        x1_a <= COS_DATA[95:48];
                        y1_a <= COS_DATA[47:0];
                    end
                    else begin
                        x0_a <= COS_DATA[95:48];
                        y0_a <= COS_DATA[47:0];
                    end
                end
                if(!found_flag_b) begin
                    if(COS_DATA[87:64] > lat_b) begin
                        found_flag_b <= 1;
                        x1_b <= COS_DATA[95:48];
                        y1_b <= COS_DATA[47:0];
                    end
                    else begin
                        x0_b <= COS_DATA[95:48];
                        y0_b <= COS_DATA[47:0];
                    end
                end
                
                COS_ADDR <= COS_ADDR + 1;
            end
            // default: begin
            //     Valid <= 0;
            // end
        endcase
    end
end

always @(*) begin
    case (curr_state)
        // IDLE: begin
        //     next_state = (DEN) ? LOAD_1 : IDLE;
        // end
        LOAD_1: begin
            next_state = (DEN) ? LOAD_2 : LOAD_1;   
        end
        LOAD_2: begin
            next_state = (DEN) ? GET_SIN : LOAD_2;  
        end
        GET_SIN: begin
            next_state = GET_COS;
        end
        GET_COS: begin
            next_state = (found_flag_a && found_flag_b) ? GET_A : GET_COS;
        end
        GET_A: begin
        
        end
        default: begin
            next_state = next_state;
        end
    endcase
end

always @(curr_state) begin
    case(curr_state) 
        GET_SIN: begin
            sin_lat = (lat_a > lat_b) ? lat_a - lat_b : lat_b - lat_a;
            
            sin_lat = ((sin_lat + (sin_lat << 1)) + ((sin_lat << 2) + (sin_lat << 4))) + (((sin_lat << 5) + (sin_lat << 6)) + (sin_lat << 10));
            sin_lat = sin_lat >> 1;
            sin_lat = sin_lat[31:0] * sin_lat[31:0];

            sin_lon = (lon_a > lon_b) ? lon_a - lon_b : lon_b - lon_a;
            
            sin_lon = ((sin_lon + (sin_lon << 1)) + ((sin_lon << 2) + (sin_lon << 4))) + (((sin_lon << 5) + (sin_lon << 6)) + (sin_lon << 10));
            sin_lon = sin_lon >> 1;
            sin_lon = sin_lon[31:0] * sin_lon[31:0];
        end
        GET_A: begin
            cos_a = (y0_a * (x1_a - x0_a) + (lat_a - x0_a) * (y1_a - y0_a)) / (x1_a - x0_a);
            cos_b = (y0_b * (x1_b - x0_b) + (lat_b - x0_b) * (y1_b - y0_b)) / (x1_b - x0_b);
            a = sin_lat + cos_a * cos_b * sin_lon;
        end
        default: begin
            lat_a = lat_a;
            lon_a = lon_a;
            lat_b = lat_b;
            lon_b = lon_b;
            sin_lat = sin_lat;
            sin_lon = sin_lon;
            cos_a = cos_a;
            cos_b = cos_b;
            a = a;
        end
    endcase
end



endmodule
