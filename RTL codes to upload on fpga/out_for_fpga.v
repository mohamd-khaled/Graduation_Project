module out (clk, in_bits, busy, frame_1, frame_2, frame_3,frame_4,frame_5);


input clk;
input in_bits;
input busy;

reg [54:0] data_out;

reg [54 : 0] temp = {55{1'b1}};
output reg [8:0] frame_1;
output reg [8:0] frame_2;
output reg [8:0] frame_3;
output reg [8:0] frame_4;
output reg [8:0] frame_5;

always @(posedge clk)
begin
    if(busy)
    begin
        temp <= temp >> 1'b1;
        temp[54] <= in_bits;
    end 
    else
    begin
        data_out <= temp;
    end

    frame_1 <= data_out[9:1];
    frame_2 <= data_out[20:12];
    frame_3 <= data_out[31:23];
    frame_4 <= data_out[42:34];
    frame_5 <= data_out[53:45];
end 

endmodule