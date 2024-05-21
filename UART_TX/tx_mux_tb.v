module mux_tb();

localparam T = 20;
localparam data_width = 8;

reg       clk;
reg       rst;
reg [1:0] mux_sel;
reg       start_bit;
reg       stop_bit;
reg       ser_data;
reg       par_bit;

wire      tx_out;

mux mux_u(
    .clk(clk),
    .rst(rst),
    .mux_sel(mux_sel),
    .start_bit(start_bit),
    .stop_bit(stop_bit),
    .ser_data(ser_data),
    .par_bit(par_bit),

    .tx_out(tx_out)
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
    rst      = 1'b0;
    mux_sel  = 2'b00;
    start_bit = 1'b0;
    stop_bit = 1'b1;
    ser_data = 1'b0;
    par_bit  = 1'b0;
    #(T);

    // case 2 : reset is off and start sending start bit
    rst      = 1'b1;
    mux_sel  = 2'b00;
    start_bit = 1'b0;
    stop_bit = 1'b1;
    ser_data = 1'b0;
    par_bit  = 1'b0;
    #(T);

    // case 3 : sending data
    // 1-bit
    rst      = 1'b1;
    mux_sel  = 2'b01;
    start_bit = 1'b0;
    stop_bit = 1'b1;
    ser_data = 1'b1;
    par_bit  = 1'b0;
    #(T);

    // 2-bit
    rst      = 1'b1;
    mux_sel  = 2'b01;
    start_bit = 1'b0;
    stop_bit = 1'b1;
    ser_data = 1'b0;
    par_bit  = 1'b0;
    #(T);

    // 3-bit
    rst      = 1'b1;
    mux_sel  = 2'b01;
    start_bit = 1'b0;
    stop_bit = 1'b1;
    ser_data = 1'b1;
    par_bit  = 1'b0;
    #(T);

    // 4-bit
    rst      = 1'b1;
    mux_sel  = 2'b01;
    start_bit = 1'b0;
    stop_bit = 1'b1;
    ser_data = 1'b0;
    par_bit  = 1'b0;
    #(T);

    // 5-bit
    rst      = 1'b1;
    mux_sel  = 2'b01;
    start_bit = 1'b0;
    stop_bit = 1'b1;
    ser_data = 1'b1;
    par_bit  = 1'b0;
    #(T);

    // 6-bit
    rst      = 1'b1;
    mux_sel  = 2'b01;
    start_bit = 1'b0;
    stop_bit = 1'b1;
    ser_data = 1'b0;
    par_bit  = 1'b0;
    #(T);

    // 7-bit
    rst      = 1'b1;
    mux_sel  = 2'b01;
    start_bit = 1'b0;
    stop_bit = 1'b1;
    ser_data = 1'b0;
    par_bit  = 1'b0;
    #(T);

    // 8-bit
    rst      = 1'b1;
    mux_sel  = 2'b01;
    start_bit = 1'b0;
    stop_bit = 1'b1;
    ser_data = 1'b1;
    par_bit  = 1'b0;
    #(T); 

    // case 3 : sending parity bit
    rst      = 1'b1;
    mux_sel  = 2'b10;
    start_bit = 1'b0;
    stop_bit = 1'b1;
    ser_data = 1'b0;
    par_bit  = 1'b0;
    #(T);

    // case 4 : sending stop bit
    rst      = 1'b1;
    mux_sel  = 2'b11;
    start_bit = 1'b0;
    stop_bit = 1'b1;
    ser_data = 1'b0;
    par_bit  = 1'b0;
    #(T);

end

endmodule