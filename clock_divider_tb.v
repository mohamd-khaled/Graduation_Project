module clock_divider_tb();

localparam T = 20;
localparam ratio_width = 8;

reg                     i_ref_clk;
reg                     i_rst;
reg                     i_clk_en;
reg [ratio_width-1 : 0] i_div_ratio;

wire o_div_clk;

clock_divider #(.ratio_width(ratio_width)) clock_divider_u (
    .i_ref_clk(i_ref_clk),
    .i_rst(i_rst),
    .i_clk_en(i_clk_en),
    .i_div_ratio(i_div_ratio),

    .o_div_clk(o_div_clk)
);


always
begin
    i_ref_clk = 1'b1;
    #(T/2);

    i_ref_clk = 1'b0;
    #(T/2);
end

initial 
begin
    // case 1 : reset is on
    i_rst = 0;
    i_clk_en = 0;
    i_div_ratio = 8'b00000110; 
    #(T)

    // case 2 : clk enable is off
    i_rst = 1;
    i_clk_en = 0;
    i_div_ratio = 8'b00000110; 
    #(T)

    // case 3 : div ratio = 0
    i_rst = 1;
    i_clk_en = 1;
    i_div_ratio = 8'b00000000; 
    #(T)

    // case 4 : div ratio = 1
    i_rst = 1;
    i_clk_en = 1;
    i_div_ratio = 8'b00000001; 
    #(2*T)

    //case 5 : reset and even div ratio = 2
    i_rst = 0;
    i_clk_en = 1;
    i_div_ratio = 8'b00000001; 
    #(2*T)

    i_rst = 1;
    i_clk_en = 1;
    i_div_ratio = 8'b0000010; 
    #(4*T)

    //case 6 : reset and even div ratio = 4
    i_rst = 0;
    i_clk_en = 1;
    i_div_ratio = 8'b00000110; 
    #(2*T)

    i_rst = 1;
    i_clk_en = 1;
    i_div_ratio = 8'b00000100; 
    #(4*T);

    //case 7 : reset and even div ratio = 8
    i_rst = 0;
    i_clk_en = 1;
    i_div_ratio = 8'b00000110; 
    #(2*T)

    i_rst = 1;
    i_clk_en = 1;
    i_div_ratio = 8'b00001000; 
    #(8*T);

    //case 8 : reset and odd div ratio = 5
    i_rst = 0;
    i_clk_en = 1;
    i_div_ratio = 8'b00000110; 
    #(2*T)

    i_rst = 1;
    i_clk_en = 1;
    i_div_ratio = 8'b00000101; 
    #(8*T);
    $finish;
end

endmodule
