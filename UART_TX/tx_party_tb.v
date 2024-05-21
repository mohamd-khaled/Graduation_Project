module parity_calc_tb ();

localparam T = 20;
localparam data_width = 8;

reg                  clk;
reg                  rst;
reg [data_width-1:0] p_data;
reg                  data_valid;
reg                  par_typ;

wire                 par_bit;

tx_parity_calc #(.data_width(data_width)) tx_parity_calc_u(
    .clk(clk),
    .rst(rst),
    .p_data(p_data),
    .data_valid(data_valid),
    .par_typ(par_typ),

    .par_bit(par_bit)
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
    p_data     = 8'b10101001;
    data_valid = 1'b0;
    par_typ    = 1'b0;
    #(T);

    //case 2 : reset is off with valid data = 0
    rst        = 1'b1;
    p_data     = 8'b10101001;
    data_valid = 1'b0;
    par_typ    = 1'b0;
    #(T);
    
    //case 3 : even parity with data have even number of 1s
    rst        = 1'b1;
    p_data     = 8'b10101001;
    data_valid = 1'b1;
    par_typ    = 1'b0;
    #(T);
    
    //case 4 : even parity with data have odd number of 1s
    rst        = 1'b1;
    p_data     = 8'b10101101;
    data_valid = 1'b1;
    par_typ    = 1'b0;
    #(T);

    //case 5 : odd parity with data have odd number of 1s
    rst        = 1'b1;
    p_data     = 8'b10101101;
    data_valid = 1'b1;
    par_typ    = 1'b1;
    #(T);

    //case 6 : odd parity with data have even number of 1s
    rst        = 1'b1;
    p_data     = 8'b10101001;
    data_valid = 1'b1;
    par_typ    = 1'b1;
    #(T);
    
end

endmodule