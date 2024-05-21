module UART_TX_TB ();

localparam T = 20;
localparam data_width = 8;

reg                    clk;
reg                    rst;
reg                    par_typ;
reg                    par_en;
reg [data_width-1 : 0] p_data;
reg                    data_valid;

wire                   tx_out;
wire                   busy;

UART_TX #(.data_width(data_width)) UART_TX_u(
    .clk(clk),
    .rst(rst),
    .par_typ(par_typ),
    .par_en(par_en),
    .p_data(p_data),
    .data_valid(data_valid),

    .tx_out(tx_out),
    .busy(busy)
);

always
begin
    clk = 1'b1;
    #(T/2);

    clk = 1'b0;
    #(T/2);
end

initial 
begin
    // case 1 : reset is on
    rst = 1'b0;
    par_typ = 1'b0;
    par_en = 1'b1;
    p_data = 8'b10101001;
    data_valid = 1'b0;
    #(T)

    // case 2 : data valid is low
    rst = 1'b1;
    par_typ = 1'b0;
    par_en = 1'b1;
    p_data = 8'b10101001;
    data_valid = 1'b0;
    #(T)
    
    // case 3 : data out with parity on and even parity (data have even number of ones (parity_bit = 0))
    rst = 1'b1;
    par_typ = 1'b0;
    par_en = 1'b1;
    p_data = 8'b10101001;
    data_valid = 1'b1;
    #(12*T);
    
    // case 4 : data out with parity on and even parity (data have odd number of ones (parity_bit = 1))
    rst = 1'b1;
    par_typ = 1'b0;
    par_en = 1'b1;
    p_data = 8'b10111100;
    data_valid = 1'b1;
    #(12*T);
    
    // case 5 : data out with parity on and odd parity (data have even number of ones (parity_bit = 1))
    rst = 1'b1;
    par_typ = 1'b1;
    par_en = 1'b1;
    p_data = 8'b10101001;
    data_valid = 1'b1;
    #(12*T);
    
    // case 6 : data out with parity on and odd parity (data have odd number of ones (parity_bit = 0))
    rst = 1'b1;
    par_typ = 1'b1;
    par_en = 1'b1;
    p_data = 8'b10111100;
    data_valid = 1'b1;
    #(12*T);
    
    // case 7 : data out with parity off
    rst = 1'b1;
    par_typ = 1'b0;
    par_en = 1'b0;
    p_data = 8'b10101001;
    data_valid = 1'b1;
    #(12*T);
    
end

endmodule