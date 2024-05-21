module mem_clk(clk,rst_mem,data_out);

input clk;
input rst_mem;
output data_out;

wire div_clk;

clock #(.div(223)) c1 (
    .clk(clk),
    .div_clk(div_clk)
);

rom r1(
    .clk(div_clk),
    .rst_mem(rst_mem), 
    .data_out(data_out)
);


endmodule