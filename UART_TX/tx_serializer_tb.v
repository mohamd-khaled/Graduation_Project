module serailizer_tb();

localparam T = 20;
localparam data_width = 8;

reg                    clk;
reg                    rst;
reg                    ser_en;
reg                    data_valid;
reg                    busy;
reg [data_width-1 : 0] p_data;

wire                   ser_data;
wire                   ser_done; 

serailizer #(.data_width(data_width)) serailizer_u(
    .clk(clk),
    .rst(rst),
    .ser_en(ser_en),
    .data_valid(data_valid),
    .busy(busy),
    .p_data(p_data),

    .ser_data(ser_data),
    .ser_done(ser_done)
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
    ser_en     = 1'b0;
    data_valid = 1'b0;
    busy       = 1'b0;
    p_data     = 8'b10101001;
    #(T);

    // case 2 : serial enable is off (IDLE state)
    rst        = 1'b1;
    ser_en     = 1'b0;
    data_valid = 1'b0;
    busy       = 1'b0;
    p_data     = 8'b10101001;
    #(T);

    // case 3 : data vaild is high (at idle state the next state will be calculated then ser_en and busy will be high)
    rst        = 1'b1;
    ser_en     = 1'b0;
    data_valid = 1'b1;
    busy       = 1'b0;
    p_data     = 8'b10101001;
    #(T); 

    // case 4 : serialize will start and busy data is high (at starting bit and data bit sending state)
    rst        = 1'b1;
    ser_en     = 1'b1;
    data_valid = 1'b1;
    busy       = 1'b1;
    p_data     = 8'b10101001;
    #(T);
 
end




endmodule