module TOP_TB ();


///////////////////// Parameters 

parameter DATA_WIDTH_TB  = 8  ;
parameter ADDR_WIDTH_TB  = 4  ;   
parameter alu_fun_width_TB = 4;
parameter memory_width_TB = 16; 
parameter Prescale_width_TB = 6;
parameter n_bits_TB = 4; 
parameter ratio_width_TB = 8;
parameter AFIFO_DEPTH_TB = 8;
parameter REF_CLK_PER = 20 ;         // 50 MHz
parameter UART_CLK_PER = 271.267 ;   // 3.6864 MHz (115.2 * 32)  


//////////////////// DUT Signals

wire                      UART_TX_O;
wire                      busy;
wire                      data_valid_RX;

reg                       RST_N;
reg                       UART_CLK = 1'b1;
reg                       REF_CLK = 1'b1;
reg                       UART_RX_IN;
reg [DATA_WIDTH_TB-1 : 0] data_in;
reg [10 : 0]              data_out;
reg [10 : 0]              temp = 11'h7ff;
reg [7 : 0]               frame;
reg                       div_clk = 1'b0; 
reg [7 : 0]               counter = 0;

integer                   i = 0;



///////////////////// Clock Generator

// REF Clock Generator
always 
begin

    #(REF_CLK_PER/2) REF_CLK = ~REF_CLK ;
end

// UART RX Clock Generator
always 
begin
    #(UART_CLK_PER/2) UART_CLK = ~UART_CLK ;
end

//////// insert inputs

initial
begin
    data_in = 8'b1010_1010;
    RST_N = 0;
    UART_RX_IN = 1;
    #(2*(4330))

    RST_N = 1;
    UART_RX_IN = 1;
    #(4*(4330))

    //////////// write op
    UART_RX_IN = 0;
    #(2*(4330))

for (i=0; i<8; i=i+1)
begin
    UART_RX_IN = data_in[i];
    #(2*(4330));
end
    i=0;
    UART_RX_IN = 0;
    #(2*(4330))

    UART_RX_IN = 1;
    #(4*(4330));

    ////////////// address
    data_in = 8'b0000_1001;
    UART_RX_IN = 0;
    #(2*(4330))

    for (i=0; i<8; i=i+1)
begin
    UART_RX_IN = data_in[i];
    #(2*(4330));
end

    i=0;
    UART_RX_IN = 0;
    #(2*(4330))

    UART_RX_IN = 1;
    #(4*(4330));

    ////////////// data = 1010_0110
    data_in = 8'b1010_0110;
    UART_RX_IN = 0;
    #(2*(4330))

    for (i=0; i<8; i=i+1)
    begin
        UART_RX_IN = data_in[i];
        #(2*(4330));
    end
    
    i=0;
    UART_RX_IN = 0;
    #(2*(4330))

    UART_RX_IN = 1;
    #(4*(4330));

    /////////////// read op
    data_in = 8'b1011_1011;
    UART_RX_IN = 0;
    #(2*(4330))

    for (i=0; i<8; i=i+1)
    begin
        UART_RX_IN = data_in[i];
        #(2*(4330));
    end
    
    i=0;
    UART_RX_IN = 0;
    #(2*(4330))

    UART_RX_IN = 1;
    #(4*(4330));


    /////////////// address
    data_in = 8'b0000_1001;
    UART_RX_IN = 0;
    #(2*(4330))

    for (i=0; i<8; i=i+1)
    begin
        UART_RX_IN = data_in[i];
        #(2*(4330));
    end
    
    i=0;
    UART_RX_IN = 0;
    #(2*(4330))

    UART_RX_IN = 1;
    #(4*(4330));


    ////////////// alu op
    data_in = 8'b1100_1100;
    UART_RX_IN = 0;
    #(2*(4330))

    for (i=0; i<8; i=i+1)
    begin
        UART_RX_IN = data_in[i];
        #(2*(4330));
    end

    i = 0;
    UART_RX_IN = 0;
    #(2*(4330))

    RST_N = 1;
    UART_RX_IN = 1;
    #(4*(4330));

    ////////////// operant_A = 8'b0011_0101 = 8'h35 = d53
    data_in = 8'b0011_0101;
    UART_RX_IN = 0;
    #(2*(4330))

    for (i=0; i<8; i=i+1)
    begin
        UART_RX_IN = data_in[i];
        #(2*(4330));
    end

    i = 0;
    UART_RX_IN = 0;
    #(2*(4330))

    RST_N = 1;
    UART_RX_IN = 1;
    #(4*(4330));

    ///////////// operant_B = 8'b1000_1000 = 8'h88 = d 136
    data_in = 8'b1000_1000;
    UART_RX_IN = 0;
    #(2*(4330))

    for (i=0; i<8; i=i+1)
    begin
        UART_RX_IN = data_in[i];
        #(2*(4330));
    end

    i = 0;
    UART_RX_IN = 0;
    #(2*(4330))

    RST_N = 1;
    UART_RX_IN = 1;
    #(4*(4330));


    /////////////// alu op (mult) = 53 * 136 = 7208 = 1C28 = 16'b 0001_1100_0010_1000
    data_in = 8'b0010_0010;
    UART_RX_IN = 0;
    #(2*(4330))

    for (i=0; i<8; i=i+1)
    begin
        UART_RX_IN = data_in[i];
        #(2*(4330));
    end

    i = 0;
    UART_RX_IN = 0;
    #(2*(4330))

    RST_N = 1;
    UART_RX_IN = 1;
    #(4*(4330));

    //////////////// alu op with no operants
    data_in = 8'b1101_1101;
    UART_RX_IN = 0;
    #(2*(4330))

    for (i=0; i<8; i=i+1)
    begin
        UART_RX_IN = data_in[i];
        #(2*(4330));
    end

    i = 0;
    UART_RX_IN = 0;
    #(2*(4330))

    RST_N = 1;
    UART_RX_IN = 1;
    #(4*(4330));

    /////////////////// alu op (XOR) = (b0011_0101 ^ 8'b1000_1000) = 8'b1011_1101 = 8'h bd
    data_in = 8'b1000_1000;
    UART_RX_IN = 0;
    #(2*(4330))

    for (i=0; i<8; i=i+1)
    begin
        UART_RX_IN = data_in[i];
        #(2*(4330));
    end

    i = 0;
    UART_RX_IN = 0;
    #(2*(4330))

    RST_N = 1;
    UART_RX_IN = 1;
    #(4*(4330));


    //////////////////// alu op
    data_in = 8'b1100_1100;
    UART_RX_IN = 0;
    #(2*(4330))

    for (i=0; i<8; i=i+1)
    begin
        UART_RX_IN = data_in[i];
        #(2*(4330));
    end

    i = 0;
    UART_RX_IN = 0;
    #(2*(4330))

    RST_N = 1;
    UART_RX_IN = 1;
    #(4*(4330));

    /////////////////// operant_A = 8'b1011_0100 = 8'hB4 = d180
    data_in = 8'b1011_0100;
    UART_RX_IN = 0;
    #(2*(4330))

    for (i=0; i<8; i=i+1)
    begin
        UART_RX_IN = data_in[i];
        #(2*(4330));
    end

    i = 0;
    UART_RX_IN = 0;
    #(2*(4330))

    RST_N = 1;
    UART_RX_IN = 1;
    #(4*(4330));

    ///////////////// operant_B = 8'b1100_1000 = 8'hC8 = d200
    data_in = 8'b1100_1000;
    UART_RX_IN = 0;
    #(2*(4330))

    for (i=0; i<8; i=i+1)
    begin
        UART_RX_IN = data_in[i];
        #(2*(4330));
    end

    i = 0;
    UART_RX_IN = 1;
    #(2*(4330))

    RST_N = 1;
    UART_RX_IN = 1;
    #(4*(4330));


    //////////////////// alu op (add) = 180 * 200 = 380 = 16'b0000_0001_0111_1100 = 16'h 01_7c
    data_in = 8'b0000_0000;
    UART_RX_IN = 0;
    #(2*(4330))

    for (i=0; i<8; i=i+1)
    begin
        UART_RX_IN = data_in[i];
        #(2*(4330));
    end

    i = 0;
    UART_RX_IN = 0;
    #(2*(4330))

    RST_N = 1;
    UART_RX_IN = 1;
    #(4*(4330));

    ////////////////////// alu op with no operants
    data_in = 8'b1101_1101;
    UART_RX_IN = 0;
    #(2*(4330))

    for (i=0; i<8; i=i+1)
    begin
        UART_RX_IN = data_in[i];
        #(2*(4330));
    end

    i = 0;
    UART_RX_IN = 0;
    #(2*(4330))

    RST_N = 1;
    UART_RX_IN = 1;
    #(4*(4330));

    /////////////////// alu op (nand) with error
    data_in = 8'b0110_0110;
    UART_RX_IN = 0;
    #(2*(4330))

    for (i=0; i<8; i=i+1)
    begin
        UART_RX_IN = data_in[i];
        #(2*(4330));
    end

    i = 1;
    UART_RX_IN = 1;
    #(2*(4330))

    RST_N = 1;
    UART_RX_IN = 1;
    #(30*(4330));

    ///////////////// alu op (nand) = ~(b1011_0100 & b1100_1000) = 16'b1111_1111_0111_1111 = 16'hff_7f
    data_in = 8'b0110_0110;
    UART_RX_IN = 0;
    #(2*(4330))

    for (i=0; i<8; i=i+1)
    begin
        UART_RX_IN = data_in[i];
        #(2*(4330));
    end

    i = 1;
    UART_RX_IN = 0;
    #(2*(4330))

    RST_N = 1;
    UART_RX_IN = 1;
    #(4*(4330));

    /////////////////////// alu op with no operants
    data_in = 8'b1101_1101;
    UART_RX_IN = 0;
    #(2*(4330))

    for (i=0; i<8; i=i+1)
    begin
        UART_RX_IN = data_in[i];
        #(2*(4330));
    end

    i = 0;
    UART_RX_IN = 0;
    #(2*(4330))

    RST_N = 1;
    UART_RX_IN = 1;
    #(4*(4330));

    /////////////////////// alu op (shift right) = 8'b1011_0100 >> 1 = 16'b0000_0000_0101_1010 = 16'h00_5a
    data_in = 8'b1101_1101;
    UART_RX_IN = 0;
    #(2*(4330))

    for (i=0; i<8; i=i+1)
    begin
        UART_RX_IN = data_in[i];
        #(2*(4330));
    end

    i = 1;
    UART_RX_IN = 0;
    #(2*(4330))

    RST_N = 1;
    UART_RX_IN = 1;
    #(4*(4330));

end


//////////////////// generater clock used to monitor output
always @(posedge UART_CLK)
begin
    counter <= counter + 1'b1;
    if(counter == 15)
    begin
        counter <= 0;
        div_clk = ~div_clk;
    end
end

/////////////////////// deserilize output and show the data
always @(posedge div_clk)
begin
    if(busy)
    begin
        temp <= temp >> 1'b1;
        temp[10] <= UART_TX_O;
    end 
    else
    begin
        data_out <= temp;
    end

    frame <= data_out[8:1];
end 

/////////////////// top module instance
top #( .data_width(DATA_WIDTH_TB), .address_width(ADDR_WIDTH_TB), 
.alu_fun_width(alu_fun_width_TB) , 
.memory_width(memory_width_TB) , 
.Prescale_width(Prescale_width_TB) , 
.n_bits(n_bits_TB) ,  
.ratio_width(ratio_width_TB) , 
.AFIFO_DEPTH(AFIFO_DEPTH_TB) )
DUT (.REF_CLK(REF_CLK),
.UART_CLK(UART_CLK),
.RST(RST_N),
.RX_IN(UART_RX_IN),
.TX_OUT(UART_TX_O),
.busy(busy),
.data_valid_RX(data_valid_RX));


endmodule