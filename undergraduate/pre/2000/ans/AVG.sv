module AVG(din, reset, clk, ready, dout);

input             clk, reset;
input      [15:0] din;
output reg        ready;
output reg [15:0] dout;

// ==========================================
//  Enter your design below
// ==========================================

reg  [15:0] buffer[11:0];
wire [33:0] avg;
assign avg = ((((buffer[ 0] + buffer[ 1]) + (buffer[ 2] + buffer[ 3])) +
               ((buffer[ 4] + buffer[ 5]) + (buffer[ 6] + buffer[ 7])) +
               ((buffer[ 8] + buffer[ 9]) + (buffer[10] + buffer[11]))) * 21845) >> 18;

wire [31:0] diff [11:0];
assign diff[ 0] = avg >= buffer[ 0] ? avg - buffer[ 0] : buffer[ 0] - avg;
assign diff[ 1] = avg >= buffer[ 1] ? avg - buffer[ 1] : buffer[ 1] - avg;
assign diff[ 2] = avg >= buffer[ 2] ? avg - buffer[ 2] : buffer[ 2] - avg;
assign diff[ 3] = avg >= buffer[ 3] ? avg - buffer[ 3] : buffer[ 3] - avg;
assign diff[ 4] = avg >= buffer[ 4] ? avg - buffer[ 4] : buffer[ 4] - avg;
assign diff[ 5] = avg >= buffer[ 5] ? avg - buffer[ 5] : buffer[ 5] - avg;
assign diff[ 6] = avg >= buffer[ 6] ? avg - buffer[ 6] : buffer[ 6] - avg;
assign diff[ 7] = avg >= buffer[ 7] ? avg - buffer[ 7] : buffer[ 7] - avg;
assign diff[ 8] = avg >= buffer[ 8] ? avg - buffer[ 8] : buffer[ 8] - avg;
assign diff[ 9] = avg >= buffer[ 9] ? avg - buffer[ 9] : buffer[ 9] - avg;
assign diff[10] = avg >= buffer[10] ? avg - buffer[10] : buffer[10] - avg;
assign diff[11] = avg >= buffer[11] ? avg - buffer[11] : buffer[11] - avg;

integer i;
reg [ 3:0] delay_count;

always_ff @(posedge clk, posedge reset) begin
    if (reset) begin
        ready <= 0;
        for (i = 0; i < 12; i = i + 1)
            buffer[i] <= 0;

        delay_count <= 0;
    end else begin
        if (delay_count == 11) begin
            ready <= 1;
            delay_count <= delay_count;
        end else begin
            ready <= 0;
            delay_count <= delay_count + 1;
        end

        for (i = 0; i < 12 - 1; i = i + 1)
            buffer[i + 1] <= buffer[i];
        buffer[0] <= din;

        if (((diff[ 0] <= diff[ 1] && diff[ 0] <= diff[ 2]) && (diff[ 0] <= diff[ 3] && diff[ 0] <= diff[ 4])) &&
            ((diff[ 0] <= diff[ 5] && diff[ 0] <= diff[ 6]) && (diff[ 0] <= diff[ 7] && diff[ 0] <= diff[ 8])) &&
            ((diff[ 0] <= diff[ 9] && diff[ 0] <= diff[10]) &&  diff[ 0] <= diff[11]))
            dout <= buffer[ 0];
        else if (((diff[ 1] <= diff[ 0] && diff[ 1] <= diff[ 2]) && (diff[ 1] <= diff[ 3] && diff[ 1] <= diff[ 4])) &&
                 ((diff[ 1] <= diff[ 5] && diff[ 1] <= diff[ 6]) && (diff[ 1] <= diff[ 7] && diff[ 1] <= diff[ 8])) &&
                 ((diff[ 1] <= diff[ 9] && diff[ 1] <= diff[10]) &&  diff[ 1] <= diff[11]))
            dout <= buffer[ 1];
        else if (((diff[ 2] <= diff[ 0] && diff[ 2] <= diff[ 1]) && (diff[ 2] <= diff[ 3] && diff[ 2] <= diff[ 4])) &&
                 ((diff[ 2] <= diff[ 5] && diff[ 2] <= diff[ 6]) && (diff[ 2] <= diff[ 7] && diff[ 2] <= diff[ 8])) &&
                 ((diff[ 2] <= diff[ 9] && diff[ 2] <= diff[10]) &&  diff[ 2] <= diff[11]))
            dout <= buffer[ 2];
        else if (((diff[ 3] <= diff[ 0] && diff[ 3] <= diff[ 1]) && (diff[ 3] <= diff[ 2] && diff[ 3] <= diff[ 4])) &&
                 ((diff[ 3] <= diff[ 5] && diff[ 3] <= diff[ 6]) && (diff[ 3] <= diff[ 7] && diff[ 3] <= diff[ 8])) &&
                 ((diff[ 3] <= diff[ 9] && diff[ 3] <= diff[10]) &&  diff[ 3] <= diff[11]))
            dout <= buffer[ 3];
        else if (((diff[ 4] <= diff[ 0] && diff[ 4] <= diff[ 1]) && (diff[ 4] <= diff[ 2] && diff[ 4] <= diff[ 3])) &&
                 ((diff[ 4] <= diff[ 5] && diff[ 4] <= diff[ 6]) && (diff[ 4] <= diff[ 7] && diff[ 4] <= diff[ 8])) &&
                 ((diff[ 4] <= diff[ 9] && diff[ 4] <= diff[10]) &&  diff[ 4] <= diff[11]))
            dout <= buffer[ 4];
        else if (((diff[ 5] <= diff[ 0] && diff[ 5] <= diff[ 1]) &&( diff[ 5] <= diff[ 2] && diff[ 5] <= diff[ 3])) &&
                 ((diff[ 5] <= diff[ 4] && diff[ 5] <= diff[ 6]) && (diff[ 5] <= diff[ 7] && diff[ 5] <= diff[ 8])) &&
                 ((diff[ 5] <= diff[ 9] && diff[ 5] <= diff[10]) &&  diff[ 5] <= diff[11]))
            dout <= buffer[ 5];
        else if (((diff[ 6] <= diff[ 0] && diff[ 6] <= diff[ 1]) && (diff[ 6] <= diff[ 2] && diff[ 6] <= diff[ 3])) &&
                 ((diff[ 6] <= diff[ 4] && diff[ 6] <= diff[ 5]) && (diff[ 6] <= diff[ 7] && diff[ 6] <= diff[ 8])) &&
                 ((diff[ 6] <= diff[ 9] && diff[ 6] <= diff[10]) &&  diff[ 6] <= diff[11]))
            dout <= buffer[ 6];
        else if (((diff[ 7] <= diff[ 0] && diff[ 7] <= diff[ 1]) && (diff[ 7] <= diff[ 2] && diff[ 7] <= diff[ 3])) &&
                 ((diff[ 7] <= diff[ 4] && diff[ 7] <= diff[ 5]) && (diff[ 7] <= diff[ 6] && diff[ 7] <= diff[ 8])) &&
                 ((diff[ 7] <= diff[ 9] && diff[ 7] <= diff[10]) &&  diff[ 7] <= diff[11]))
            dout <= buffer[ 7];
        else if (((diff[ 8] <= diff[ 0] && diff[ 8] <= diff[ 1]) && (diff[ 8] <= diff[ 2] && diff[ 8] <= diff[ 3])) &&
                 ((diff[ 8] <= diff[ 4] && diff[ 8] <= diff[ 5]) && (diff[ 8] <= diff[ 6] && diff[ 8] <= diff[ 7])) &&
                 ((diff[ 8] <= diff[ 9] && diff[ 8] <= diff[10]) &&  diff[ 8] <= diff[11]))
            dout <= buffer[ 8];
        else if (((diff[ 9] <= diff[ 0] && diff[ 9] <= diff[ 1]) && (diff[ 9] <= diff[ 2] && diff[ 9] <= diff[ 3])) &&
                 ((diff[ 9] <= diff[ 4] && diff[ 9] <= diff[ 5]) && (diff[ 9] <= diff[ 6] && diff[ 9] <= diff[ 7])) &&
                 ((diff[ 9] <= diff[ 8] && diff[ 9] <= diff[10]) &&  diff[ 9] <= diff[11]))
            dout <= buffer[ 9];
        else if (((diff[10] <= diff[ 0] && diff[10] <= diff[ 1]) && (diff[10] <= diff[ 2] && diff[10] <= diff[ 3])) &&
                 ((diff[10] <= diff[ 4] && diff[10] <= diff[ 5]) && (diff[10] <= diff[ 6] && diff[10] <= diff[ 7])) &&
                 ((diff[10] <= diff[ 8] && diff[10] <= diff[ 9]) &&  diff[10] <= diff[11]))
            dout <= buffer[10];
        else
            dout <= buffer[11];
    end
end

endmodule
