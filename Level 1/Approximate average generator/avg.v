module avg(din, reset, clk, ready, dout);
input reset, clk;
input [15:0] din;
output reg ready;
output reg [15:0] dout;

reg [15:0] buffer[11:0];
reg [3:0] count;

reg [15:0] avg;
reg [15:0] diff[11:0];
integer i;

always @(posedge clk, posedge reset) begin
    if (reset) begin
        count <= 0;
        ready <= 0;
        for(i = 0; i < 12; i = i+1) 
            buffer[i] <= 0;    
    end
    // Prevent latch
    else begin
        if (count == 11) begin
            ready <= 1;
            count <= count;
        end
        else begin
            ready <= 0;
            count <= count + 1;
        end

        for(i = 0; i < 12 - 1; i = i+1) 
            buffer[i + 1] <= buffer[i];

        buffer[0] <= din;

        if(((diff[0] <= diff[1] && diff[0] <= diff[2]) && (diff[0] <= diff[3] && diff[0] <= diff[4])) && 
           ((diff[0] <= diff[5] && diff[0] <= diff[6]) && (diff[0] <= diff[7] && diff[0] <= diff[8])) && 
           ((diff[0] <= diff[9] && diff[0] <= diff[10]) && diff[0] <= diff[11])) begin
            if(diff[0] == diff[1] && buffer[0] > buffer[1])
                dout <= buffer[1];
            else if(diff[0] == diff[2] && buffer[0] > buffer[2])
                dout <= buffer[2];
            else if(diff[0] == diff[3] && buffer[0] > buffer[3])
                dout <= buffer[3];
            else if(diff[0] == diff[4] && buffer[0] > buffer[4])
                dout <= buffer[4];
            else if(diff[0] == diff[5] && buffer[0] > buffer[5])
                dout <= buffer[5];
            else if(diff[0] == diff[6] && buffer[0] > buffer[6])
                dout <= buffer[6];
            else if(diff[0] == diff[7] && buffer[0] > buffer[7])
                dout <= buffer[7];
            else if(diff[0] == diff[8] && buffer[0] > buffer[8])
                dout <= buffer[8];
            else if(diff[0] == diff[9] && buffer[0] > buffer[9])
                dout <= buffer[9];
            else if(diff[0] == diff[10] && buffer[0] > buffer[10])
                dout <= buffer[10];
            else if(diff[0] == diff[11] && buffer[0] > buffer[11])
                dout <= buffer[11];
            else
                dout <= buffer[0];
        end
        else if(((diff[1] <= diff[0] && diff[1] <= diff[2]) && (diff[1] <= diff[3] && diff[1] <= diff[4])) && 
           ((diff[1] <= diff[5] && diff[1] <= diff[6]) && (diff[1] <= diff[7] && diff[1] <= diff[8])) && 
           ((diff[1] <= diff[9] && diff[1] <= diff[10]) && diff[1] <= diff[11])) begin
            if(diff[1] == diff[0] && buffer[1] > buffer[0])
                dout <= buffer[0];
            else if(diff[1] == diff[2] && buffer[1] > buffer[2])
                dout <= buffer[2];
            else if(diff[1] == diff[3] && buffer[1] > buffer[3])
                dout <= buffer[3];
            else if(diff[1] == diff[4] && buffer[1] > buffer[4])
                dout <= buffer[4];
            else if(diff[1] == diff[5] && buffer[1] > buffer[5])
                dout <= buffer[5];
            else if(diff[1] == diff[6] && buffer[1] > buffer[6])
                dout <= buffer[6];
            else if(diff[1] == diff[7] && buffer[1] > buffer[7])
                dout <= buffer[7];
            else if(diff[1] == diff[8] && buffer[1] > buffer[8])
                dout <= buffer[8];
            else if(diff[1] == diff[9] && buffer[1] > buffer[9])
                dout <= buffer[9];
            else if(diff[1] == diff[10] && buffer[1] > buffer[10])
                dout <= buffer[10];
            else if(diff[1] == diff[11] && buffer[1] > buffer[11])
                dout <= buffer[11];
            else
                dout <= buffer[1];
        end
        else if(((diff[2] <= diff[0] && diff[2] <= diff[1]) && (diff[2] <= diff[3] && diff[2] <= diff[4])) && 
           ((diff[2] <= diff[5] && diff[2] <= diff[6]) && (diff[2] <= diff[7] && diff[2] <= diff[8])) && 
           ((diff[2] <= diff[9] && diff[2] <= diff[10]) && diff[2] <= diff[11])) begin
            if(diff[2] == diff[0] && buffer[2] > buffer[0])
                dout <= buffer[0];
            else if(diff[2] == diff[1] && buffer[2] > buffer[1])
                dout <= buffer[1];
            else if(diff[2] == diff[3] && buffer[2] > buffer[3])
                dout <= buffer[3];
            else if(diff[2] == diff[4] && buffer[2] > buffer[4])
                dout <= buffer[4];
            else if(diff[2] == diff[5] && buffer[2] > buffer[5])
                dout <= buffer[5];
            else if(diff[2] == diff[6] && buffer[2] > buffer[6])
                dout <= buffer[6];
            else if(diff[2] == diff[7] && buffer[2] > buffer[7])
                dout <= buffer[7];
            else if(diff[2] == diff[8] && buffer[2] > buffer[8])
                dout <= buffer[8];
            else if(diff[2] == diff[9] && buffer[2] > buffer[9])
                dout <= buffer[9];
            else if(diff[2] == diff[10] && buffer[2] > buffer[10])
                dout <= buffer[10];
            else if(diff[2] == diff[11] && buffer[2] > buffer[11])
                dout <= buffer[11];
            else
                dout <= buffer[2];
        end
        else if(((diff[3] <= diff[0] && diff[3] <= diff[1]) && (diff[3] <= diff[2] && diff[3] <= diff[4])) && 
           ((diff[3] <= diff[5] && diff[3] <= diff[6]) && (diff[3] <= diff[7] && diff[3] <= diff[8])) && 
           ((diff[3] <= diff[9] && diff[3] <= diff[10]) && diff[3] <= diff[11])) begin
            if(diff[3] == diff[1] && buffer[3] > buffer[1])
                dout <= buffer[0];
            else if(diff[3] == diff[2] && buffer[3] > buffer[2])
                dout <= buffer[1];
            else if(diff[3] == diff[0] && buffer[3] > buffer[0])
                dout <= buffer[2];
            else if(diff[3] == diff[4] && buffer[3] > buffer[4])
                dout <= buffer[4];
            else if(diff[3] == diff[5] && buffer[3] > buffer[5])
                dout <= buffer[5];
            else if(diff[3] == diff[6] && buffer[3] > buffer[6])
                dout <= buffer[6];
            else if(diff[3] == diff[7] && buffer[3] > buffer[7])
                dout <= buffer[7];
            else if(diff[3] == diff[8] && buffer[3] > buffer[8])
                dout <= buffer[8];
            else if(diff[3] == diff[9] && buffer[3] > buffer[9])
                dout <= buffer[9];
            else if(diff[3] == diff[10] && buffer[3] > buffer[10])
                dout <= buffer[10];
            else if(diff[3] == diff[11] && buffer[3] > buffer[11])
                dout <= buffer[11];
            else
                dout <= buffer[3];
        end
        else if(((diff[4] <= diff[1] && diff[4] <= diff[2]) && (diff[4] <= diff[3] && diff[4] <= diff[0])) && 
           ((diff[4] <= diff[5] && diff[4] <= diff[6]) && (diff[4] <= diff[7] && diff[4] <= diff[8])) && 
           ((diff[4] <= diff[9] && diff[4] <= diff[10]) && diff[4] <= diff[11])) begin
            if(diff[4] == diff[1] && buffer[4] > buffer[1])
                dout <= buffer[1];
            else if(diff[4] == diff[2] && buffer[4] > buffer[2])
                dout <= buffer[2];
            else if(diff[4] == diff[3] && buffer[4] > buffer[3])
                dout <= buffer[3];
            else if(diff[4] == diff[0] && buffer[4] > buffer[0])
                dout <= buffer[0];
            else if(diff[4] == diff[5] && buffer[4] > buffer[5])
                dout <= buffer[5];
            else if(diff[4] == diff[6] && buffer[4] > buffer[6])
                dout <= buffer[6];
            else if(diff[4] == diff[7] && buffer[4] > buffer[7])
                dout <= buffer[7];
            else if(diff[4] == diff[8] && buffer[4] > buffer[8])
                dout <= buffer[8];
            else if(diff[4] == diff[9] && buffer[4] > buffer[9])
                dout <= buffer[9];
            else if(diff[4] == diff[10] && buffer[4] > buffer[10])
                dout <= buffer[10];
            else if(diff[4] == diff[11] && buffer[4] > buffer[11])
                dout <= buffer[11];
            else
                dout <= buffer[4];
        end
        else if(((diff[5] <= diff[1] && diff[5] <= diff[2]) && (diff[5] <= diff[3] && diff[5] <= diff[4])) && 
           ((diff[5] <= diff[0] && diff[5] <= diff[6]) && (diff[5] <= diff[7] && diff[5] <= diff[8])) && 
           ((diff[5] <= diff[9] && diff[5] <= diff[10]) && diff[5] <= diff[11])) begin
            if(diff[5] == diff[1] && buffer[5] > buffer[1])
                dout <= buffer[1];
            else if(diff[5] == diff[2] && buffer[5] > buffer[2])
                dout <= buffer[2];
            else if(diff[5] == diff[3] && buffer[5] > buffer[3])
                dout <= buffer[3];
            else if(diff[5] == diff[4] && buffer[5] > buffer[4])
                dout <= buffer[4];
            else if(diff[5] == diff[0] && buffer[5] > buffer[0])
                dout <= buffer[0];
            else if(diff[5] == diff[6] && buffer[5] > buffer[6])
                dout <= buffer[6];
            else if(diff[5] == diff[7] && buffer[5] > buffer[7])
                dout <= buffer[7];
            else if(diff[5] == diff[8] && buffer[5] > buffer[8])
                dout <= buffer[8];
            else if(diff[5] == diff[9] && buffer[5] > buffer[9])
                dout <= buffer[9];
            else if(diff[5] == diff[10] && buffer[5] > buffer[10])
                dout <= buffer[10];
            else if(diff[5] == diff[11] && buffer[5] > buffer[11])
                dout <= buffer[11];
            else
                dout <= buffer[5];
        end
        else if(((diff[6] <= diff[1] && diff[6] <= diff[2]) && (diff[6] <= diff[3] && diff[6] <= diff[4])) && 
           ((diff[6] <= diff[5] && diff[6] <= diff[0]) && (diff[6] <= diff[7] && diff[6] <= diff[8])) && 
           ((diff[6] <= diff[9] && diff[6] <= diff[10]) && diff[6] <= diff[11])) begin
            if(diff[6] == diff[1] && buffer[6] > buffer[1])
                dout <= buffer[1];
            else if(diff[6] == diff[2] && buffer[6] > buffer[2])
                dout <= buffer[2];
            else if(diff[6] == diff[3] && buffer[6] > buffer[3])
                dout <= buffer[3];
            else if(diff[6] == diff[4] && buffer[6] > buffer[4])
                dout <= buffer[4];
            else if(diff[6] == diff[5] && buffer[6] > buffer[5])
                dout <= buffer[5];
            else if(diff[6] == diff[0] && buffer[6] > buffer[0])
                dout <= buffer[0];
            else if(diff[6] == diff[7] && buffer[6] > buffer[7])
                dout <= buffer[7];
            else if(diff[6] == diff[8] && buffer[6] > buffer[8])
                dout <= buffer[8];
            else if(diff[6] == diff[9] && buffer[6] > buffer[9])
                dout <= buffer[9];
            else if(diff[6] == diff[10] && buffer[6] > buffer[10])
                dout <= buffer[10];
            else if(diff[6] == diff[11] && buffer[6] > buffer[11])
                dout <= buffer[11];
            else
                dout <= buffer[6];
        end
        else if(((diff[7] <= diff[1] && diff[7] <= diff[2]) && (diff[7] <= diff[3] && diff[7] <= diff[4])) && 
           ((diff[7] <= diff[5] && diff[7] <= diff[6]) && (diff[7] <= diff[0] && diff[7] <= diff[8])) && 
           ((diff[7] <= diff[9] && diff[7] <= diff[10]) && diff[7] <= diff[11])) begin
            if(diff[7] == diff[1] && buffer[7] > buffer[1])
                dout <= buffer[1];
            else if(diff[7] == diff[2] && buffer[7] > buffer[2])
                dout <= buffer[2];
            else if(diff[7] == diff[3] && buffer[7] > buffer[3])
                dout <= buffer[3];
            else if(diff[7] == diff[4] && buffer[7] > buffer[4])
                dout <= buffer[4];
            else if(diff[7] == diff[5] && buffer[7] > buffer[5])
                dout <= buffer[5];
            else if(diff[7] == diff[6] && buffer[7] > buffer[6])
                dout <= buffer[6];
            else if(diff[7] == diff[0] && buffer[7] > buffer[0])
                dout <= buffer[0];
            else if(diff[7] == diff[8] && buffer[7] > buffer[8])
                dout <= buffer[8];
            else if(diff[7] == diff[9] && buffer[7] > buffer[9])
                dout <= buffer[9];
            else if(diff[7] == diff[10] && buffer[7] > buffer[10])
                dout <= buffer[10];
            else if(diff[7] == diff[11] && buffer[7] > buffer[11])
                dout <= buffer[11];
            else
                dout <= buffer[7];
        end
        else if(((diff[8] <= diff[1] && diff[8] <= diff[2]) && (diff[8] <= diff[3] && diff[8] <= diff[4])) && 
           ((diff[8] <= diff[5] && diff[8] <= diff[6]) && (diff[8] <= diff[7] && diff[8] <= diff[0])) && 
           ((diff[8] <= diff[9] && diff[8] <= diff[10]) && diff[8] <= diff[11])) begin
            if(diff[8] == diff[1] && buffer[8] > buffer[1])
                dout <= buffer[1];
            else if(diff[8] == diff[2] && buffer[8] > buffer[2])
                dout <= buffer[2];
            else if(diff[8] == diff[3] && buffer[8] > buffer[3])
                dout <= buffer[3];
            else if(diff[8] == diff[4] && buffer[8] > buffer[4])
                dout <= buffer[4];
            else if(diff[8] == diff[5] && buffer[8] > buffer[5])
                dout <= buffer[5];
            else if(diff[8] == diff[6] && buffer[8] > buffer[6])
                dout <= buffer[6];
            else if(diff[8] == diff[7] && buffer[8] > buffer[7])
                dout <= buffer[7];
            else if(diff[8] == diff[0] && buffer[8] > buffer[0])
                dout <= buffer[0];
            else if(diff[8] == diff[9] && buffer[8] > buffer[9])
                dout <= buffer[9];
            else if(diff[8] == diff[10] && buffer[8] > buffer[10])
                dout <= buffer[10];
            else if(diff[8] == diff[11] && buffer[8] > buffer[11])
                dout <= buffer[11];
            else
                dout <= buffer[8];
        end
        else if(((diff[9] <= diff[1] && diff[9] <= diff[2]) && (diff[9] <= diff[3] && diff[9] <= diff[4])) && 
           ((diff[9] <= diff[5] && diff[9] <= diff[6]) && (diff[9] <= diff[7] && diff[9] <= diff[8])) && 
           ((diff[9] <= diff[0] && diff[9] <= diff[10]) && diff[9] <= diff[11])) begin
            if(diff[9] == diff[1] && buffer[9] > buffer[1])
                dout <= buffer[1];
            else if(diff[9] == diff[2] && buffer[9] > buffer[2])
                dout <= buffer[2];
            else if(diff[9] == diff[3] && buffer[9] > buffer[3])
                dout <= buffer[3];
            else if(diff[9] == diff[4] && buffer[9] > buffer[4])
                dout <= buffer[4];
            else if(diff[9] == diff[5] && buffer[9] > buffer[5])
                dout <= buffer[5];
            else if(diff[9] == diff[6] && buffer[9] > buffer[6])
                dout <= buffer[6];
            else if(diff[9] == diff[7] && buffer[9] > buffer[7])
                dout <= buffer[7];
            else if(diff[9] == diff[8] && buffer[9] > buffer[8])
                dout <= buffer[8];
            else if(diff[9] == diff[0] && buffer[9] > buffer[0])
                dout <= buffer[0];
            else if(diff[9] == diff[10] && buffer[9] > buffer[10])
                dout <= buffer[10];
            else if(diff[9] == diff[11] && buffer[9] > buffer[11])
                dout <= buffer[11];
            else
                dout <= buffer[9];
        end
        else if(((diff[10] <= diff[1] && diff[10] <= diff[2]) && (diff[10] <= diff[3] && diff[10] <= diff[4])) && 
           ((diff[10] <= diff[5] && diff[10] <= diff[6]) && (diff[10] <= diff[7] && diff[10] <= diff[8])) && 
           ((diff[10] <= diff[9] && diff[10] <= diff[0]) && diff[10] <= diff[11])) begin
            if(diff[10] == diff[1] && buffer[10] > buffer[1])
                dout <= buffer[1];
            else if(diff[10] == diff[2] && buffer[10] > buffer[2])
                dout <= buffer[2];
            else if(diff[10] == diff[3] && buffer[10] > buffer[3])
                dout <= buffer[3];
            else if(diff[10] == diff[4] && buffer[10] > buffer[4])
                dout <= buffer[4];
            else if(diff[10] == diff[5] && buffer[10] > buffer[5])
                dout <= buffer[5];
            else if(diff[10] == diff[6] && buffer[10] > buffer[6])
                dout <= buffer[6];
            else if(diff[10] == diff[7] && buffer[10] > buffer[7])
                dout <= buffer[7];
            else if(diff[10] == diff[8] && buffer[10] > buffer[8])
                dout <= buffer[8];
            else if(diff[10] == diff[9] && buffer[10] > buffer[9])
                dout <= buffer[9];
            else if(diff[10] == diff[0] && buffer[10] > buffer[0])
                dout <= buffer[0];
            else if(diff[10] == diff[11] && buffer[10] > buffer[11])
                dout <= buffer[11];
            else
                dout <= buffer[10];
        end
        else if(((diff[11] <= diff[1] && diff[11] <= diff[2]) && (diff[11] <= diff[3] && diff[11] <= diff[4])) && 
           ((diff[11] <= diff[5] && diff[11] <= diff[6]) && (diff[11] <= diff[7] && diff[11] <= diff[8])) && 
           ((diff[11] <= diff[9] && diff[11] <= diff[10]) && diff[11] <= diff[0])) begin
            if(diff[11] == diff[1] && buffer[11] > buffer[1])
                dout <= buffer[1];
            else if(diff[11] == diff[2] && buffer[11] > buffer[2])
                dout <= buffer[2];
            else if(diff[11] == diff[3] && buffer[11] > buffer[3])
                dout <= buffer[3];
            else if(diff[11] == diff[4] && buffer[11] > buffer[4])
                dout <= buffer[4];
            else if(diff[11] == diff[5] && buffer[11] > buffer[5])
                dout <= buffer[5];
            else if(diff[11] == diff[6] && buffer[11] > buffer[6])
                dout <= buffer[6];
            else if(diff[11] == diff[7] && buffer[11] > buffer[7])
                dout <= buffer[7];
            else if(diff[11] == diff[8] && buffer[11] > buffer[8])
                dout <= buffer[8];
            else if(diff[11] == diff[9] && buffer[11] > buffer[9])
                dout <= buffer[9];
            else if(diff[11] == diff[10] && buffer[11] > buffer[10])
                dout <= buffer[10];
            else if(diff[11] == diff[0] && buffer[11] > buffer[0])
                dout <= buffer[0];
            else
                dout <= buffer[11];
        end
    end

end

always@(*) begin
    // Get avg
    avg = (((buffer[0] + buffer[1]) + (buffer[2] + buffer[3])) + 
               ((buffer[4] + buffer[5]) + (buffer[6] + buffer[7])) + 
               ((buffer[8] + buffer[9]) + (buffer[10] + buffer[11]))) / 12;
    // Calculate diff
    for (i = 0; i < 12; i = i+1) 
        diff[i] = (buffer[i] > avg) ? buffer[i] - avg : avg - buffer[i];

end


endmodule
