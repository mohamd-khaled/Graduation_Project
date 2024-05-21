module tx_fsm_tb();

localparam T = 20;
localparam data_width = 8;

reg            clk;
reg            rst;
reg            data_valid;
reg            ser_done;
reg            par_en;

wire [1:0]    mux_sel;
wire          busy;
wire          ser_en;

tx_fsm #(.data_width(data_width)) tx_fsm_u(
    .clk(clk),
    .rst(rst),
    .data_valid(data_valid),
    .ser_done(ser_en),
    .par_en(par_en),

    .mux_sel(mux_sel),
    .busy(busy),
    .ser_en(ser_en)
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
    rst        = 1'b0;
    data_valid = 1'b0;
    ser_done   = 1'b0;
    par_en     = 1'b0;
	#(T)

    // case 2 : data valid is off
    rst        = 1'b1;
    data_valid = 1'b0;
    ser_done   = 1'b0;
    par_en     = 1'b0;
	#(T)
    
    // case 3 : serial done is off
    rst        = 1'b1;
    data_valid = 1'b1;
    ser_done   = 1'b0;
    par_en     = 1'b0;
	#(T)
    #(T)
    #(T)
    #(T)
    // case 4 : serial done is on without parity
    rst        = 1'b1;
    data_valid = 1'b1;
    ser_done   = 1'b1;
    par_en     = 1'b0;
	#(T)
    #(T)
    #(T)
    // case 5 : serial done is on with parity
    rst        = 1'b1;
    data_valid = 1'b1;
    ser_done   = 1'b1;
    par_en     = 1'b1;
	#(T);
end

endmodule