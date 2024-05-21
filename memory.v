module rom (clk,rst_mem, data_out);
input clk;
input rst_mem;
output reg data_out;
reg data_in [60:0];
reg [6:0] address=0;


always @ (posedge clk, negedge rst_mem)
begin
    if(~rst_mem)
    begin
        data_out = 'b1;
    end
    else
    begin
        data_out = data_in[address];
        address = address +1;
    end
end

initial
begin
    data_in [0] = 0;
    data_in [1] = 0;
    data_in [2] = 1;
    data_in [3] = 0;
    data_in [4] = 1;
    data_in [5] = 0;
    data_in [6] = 1;
    data_in [7] = 0;
    data_in [8] = 1;
    data_in [9] = 0;
    data_in [10] = 1;
    data_in [11] = 1;

    data_in [12] = 0;
    data_in [13] = 1;
    data_in [14] = 0;
    data_in [15] = 0;
    data_in [16] = 1;
    data_in [17] = 0;
    data_in [18] = 0;
    data_in [19] = 0;
    data_in [20] = 0;
    data_in [21] = 0;
    data_in [22] = 1;
    data_in [23] = 1;

    data_in [24] = 0;
    data_in [25] = 0;
    data_in [26] = 1;
    data_in [27] = 1;
    data_in [28] = 0;
    data_in [29] = 0;
    data_in [30] = 1;
    data_in [31] = 0;
    data_in [32] = 1;
    data_in [33] = 0;
    data_in [34] = 1;
    data_in [35] = 1;

    data_in [36] = 0;
    data_in [37] = 1;
    data_in [38] = 1;
    data_in [39] = 0;
    data_in [40] = 1;
    data_in [41] = 1;
    data_in [42] = 1;
    data_in [43] = 0;
    data_in [44] = 1;
    data_in [45] = 0;
    data_in [46] = 1;
    data_in [47] = 1;

    data_in [48] = 0;
    data_in [49] = 1;
    data_in [50] = 0;
    data_in [51] = 0;
    data_in [52] = 1;
    data_in [53] = 0;
    data_in [54] = 0;
    data_in [55] = 0;
    data_in [56] = 0;
    data_in [57] = 0;
    data_in [58] = 1;
    data_in [59] = 1;
end




endmodule