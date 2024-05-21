`timescale 1ns/1ps

module TOP_tb_m ();

/////////////////////////////////////////////////////////
///////////////////// Parameters ////////////////////////
/////////////////////////////////////////////////////////

parameter DATA_WIDTH_TB  = 8  ;
parameter ADDR_WIDTH_TB  = 4  ;   
parameter alu_fun_width_TB = 4;
parameter memory_width_TB = 16; 
parameter Prescale_width_TB = 6;
parameter n_bits_TB = 4; 
parameter ratio_width_TB = 8;
parameter AFIFO_DEPTH_TB =8;
parameter REF_CLK_PER = 20 ;         // 50 MHz
parameter UART_CLK_PER = 271.267 ;   // 3.6864 MHz (115.2 * 32)

/////////////////////////////////////////////////////////
//////////////////// DUT Signals ////////////////////////
/////////////////////////////////////////////////////////

reg                                RST_N;
reg                                UART_CLK=1'b1;
reg                                REF_CLK=1'b1;
reg                                UART_RX_IN;
wire                               UART_TX_O;
//reg [DATA_WIDTH_TB-1:0] data_in;
//////////////////////////////////////////////////////// 
///////////////////// Clock Generator //////////////////
////////////////////////////////////////////////////////

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

initial
begin
    //data_in = 8'b10101010;
    RST_N = 0;
    UART_RX_IN = 1;
    UART_RX_IN = 1;
    #(4*(4330))

    //write op
    UART_RX_IN = 0;

    UART_RX_IN = 0;

    UART_RX_IN = 1;

    UART_RX_IN = 0;

    UART_RX_IN = 1;

    UART_RX_IN = 0;

    UART_RX_IN = 1;

    UART_RX_IN = 0;

    UART_RX_IN = 1;

    UART_RX_IN = 0;

    UART_RX_IN = 1;

    //address
    UART_RX_IN = 0;

    UART_RX_IN = 1;

    UART_RX_IN = 0;

    UART_RX_IN = 0;

    UART_RX_IN = 1;

    UART_RX_IN = 0;

    UART_RX_IN = 0;

    UART_RX_IN = 0;

    UART_RX_IN = 0;

    UART_RX_IN = 0;

    UART_RX_IN = 1;

    //data = 1010_0110
    UART_RX_IN = 0;

    UART_RX_IN = 0;

    UART_RX_IN = 1;

    UART_RX_IN = 1;

    UART_RX_IN = 0;

    UART_RX_IN = 0;

    UART_RX_IN = 1;

    UART_RX_IN = 0;

    UART_RX_IN = 1;

    UART_RX_IN = 0;

    UART_RX_IN = 1;

    //read op
    UART_RX_IN = 0;

    UART_RX_IN = 1;

    UART_RX_IN = 1;

    UART_RX_IN = 0;

    UART_RX_IN = 1;

    UART_RX_IN = 1;

    UART_RX_IN = 1;

    UART_RX_IN = 0;

    UART_RX_IN = 1;

    UART_RX_IN = 0;

    UART_RX_IN = 1;

    //addres
    UART_RX_IN = 0;

    UART_RX_IN = 1;

    UART_RX_IN = 0;

    UART_RX_IN = 0;

    UART_RX_IN = 1;

    UART_RX_IN = 0;

    UART_RX_IN = 0;

    UART_RX_IN = 0;

    UART_RX_IN = 0;

    UART_RX_IN = 0;

    UART_RX_IN = 1;

    //alu o
    UART_RX_IN = 0;
    UART_RX_IN = 0;
    UART_RX_IN = 0;
    UART_RX_IN = 1;
    UART_RX_IN = 1;
    UART_RX_IN = 0;
    UART_RX_IN = 0;
    UART_RX_IN = 1;
    UART_RX_IN = 1;
    UART_RX_IN = 0;
    UART_RX_IN = 1;

    //operant_A = 8'b0011_0101 = 8'h35 = d5
    UART_RX_IN = 0;
    UART_RX_IN = 1;
    UART_RX_IN = 0;
    UART_RX_IN = 1;
    UART_RX_IN = 0;
    UART_RX_IN = 1;
    UART_RX_IN = 1;
    UART_RX_IN = 0;
    UART_RX_IN = 0;
    UART_RX_IN = 0;
    UART_RX_IN = 1;

    //operant_B = 8'b1000_1000 = 8'h88 = d 13
    UART_RX_IN = 0;
    UART_RX_IN = 0;
    UART_RX_IN = 0;
    UART_RX_IN = 0;
    UART_RX_IN = 1;
    UART_RX_IN = 0;
    UART_RX_IN = 0;
    UART_RX_IN = 0;
    UART_RX_IN = 1;
    UART_RX_IN = 0;
    UART_RX_IN = 1;


    //alu op (mult) = 53 * 136 = 7208 = 16'b 0001_1100_0010_100
    UART_RX_IN = 0;
    UART_RX_IN = 0;
    UART_RX_IN = 1;
    UART_RX_IN = 0;
    UART_RX_IN = 0;
    UART_RX_IN = 0;
    UART_RX_IN = 1;
    UART_RX_IN = 0;
    UART_RX_IN = 0;
    UART_RX_IN = 0;
    UART_RX_IN = 1;


    //alu op with no operant
    UART_RX_IN = 0;
    UART_RX_IN = 1;
    UART_RX_IN = 0;
    UART_RX_IN = 1;
    UART_RX_IN = 1;
    UART_RX_IN = 1;
    UART_RX_IN = 0;
    UART_RX_IN = 1;
    UART_RX_IN = 1;
    UART_RX_IN = 0;
    UART_RX_IN = 1;

    //alu op (nand) = ~(b0011_0101 & 8'b1000_1000) = 8'b1111_111
    UART_RX_IN = 0;
    UART_RX_IN = 0;
    UART_RX_IN = 1;
    UART_RX_IN = 1;
    UART_RX_IN = 0;
    UART_RX_IN = 0;
    UART_RX_IN = 1;
    UART_RX_IN = 1;
    UART_RX_IN = 0;
    UART_RX_IN = 0;
    UART_RX_IN = 1;

end



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
.TX_OUT(UART_TX_O));


endmodule