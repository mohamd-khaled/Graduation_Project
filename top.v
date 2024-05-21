module top #(parameter data_width = 8, address_width = 4, alu_fun_width = 4, memory_width = 16, Prescale_width = 6, n_bits = 4,  ratio_width = 8, AFIFO_DEPTH=8)
(REF_CLK,UART_CLK,RST,RX_IN,TX_OUT,busy,data_valid_RX);

input REF_CLK;
input UART_CLK;
input RST;
input RX_IN;

output TX_OUT;
output busy;
output                        data_valid_RX; //(out data valid from rx/in to data_sync)

//signals
wire                        rst_sync_sys; //rst for system
wire                        rst_sync_uart; //rst for uart

wire  [data_width-1:0]      div_ratio_rx; // divide ratio for RX to get RX_clk
wire                        RX_CLK; 
wire                        TX_CLK;
wire                        gated_clk; //(clk out from clk gate / in to alu)
wire                        ff_full; //Full flag from FIFO (out from fifo/input to sys con)
wire                        rd_valid; //read data from RF is valid (out from RF/ in to sys con)
wire                        out_valid; //out data from ALU is valid (out from ALU/ in to sys con)
wire                        rx_d_valid; // Input Data from RX through data sync is valid (out from data sync/ in to sys con)
wire  [data_width-1 :0]     rd_data; //read data from RF (out from RF/ in to sys con)
wire  [data_width-1 :0]     p_data; // Input Data from RX through data sync (out from data sync/ in to sys con)
wire  [15:0]                alu_out; //out data from ALU (out from ALU/ in to sys con)
wire  [alu_fun_width-1 :0]  alu_fun; //alu function (in to ALU/ out from sys con)
wire  [address_width-1 :0]  address; //address in which the data will be written in RF (in to RF/ out from sys con)
wire  [data_width-1 :0]     wr_data; //data which will be written in RF (in to RF/ out from sys con)
wire  [data_width-1 :0]     fifo_p_data; //data which will be written in fifo (in to fifo/ out from sys con)
wire                        fifo_p_valid; //data which will be written in fifo is valid (in to fifo/ out from sys con)
wire                        alu_en; //alu enable (in to ALU/ out from sys con)
wire                        clk_en; //clk enable for clk gate (in to clk_gate/ out from sys con)
wire                        wr_en; //write enable in RF (in to RF/ out from sys con)
wire                        rd_en; //read enable from RF (in to RF/ out from sys con)
wire                        clk_div_en; //clk dvivder enable (in to clk_div/ out from sys con)

wire  [data_width-1 : 0]    operant_A; //out from RF has value for alu enable (out from RF/in to alu) 
wire  [data_width-1 : 0]    operant_B; //out from RF has value for alu enable (out from RF/in to alu) 
wire  [data_width-1 : 0]    UART_conf; //uart_rx configrations ([0] parity enable/[1]parity type/[2:7]prescale to determine DIV_ratio for rx)(out from RF/in to RX) 
wire  [data_width-1 : 0]    DIV_ratio; //uart_tx configrations divide ratio (out from RF/in to clk_div)

wire [data_width-1 : 0]     P_DATA_RX; //(out data from rx/in to data_sync)

//wire                        busy; //out signal show that tx is operating and used to generate pulse by pulse gen to increament address in fifo (out from TX/in to pulse gen)
wire                        rd_inc; //out signal from pulse gen to increament address in fifo (out from pulse gen/in to fifo)

wire [data_width-1 : 0]     tx_p_data; //data out from fifo to TX to be send
wire                        ff_empty; //

//Reset synchronizers
//domain 1
rst_sync rst_sync_u1(
    .clk(REF_CLK),
    .rst(RST),
    
    .sync_rst(rst_sync_sys)
);

//domain 2
rst_sync rst_sync_u2(
    .clk(UART_CLK),
    .rst(RST),
    
    .sync_rst(rst_sync_uart)
);

//prescale 
prescale_mux #(.data_width(data_width))
prescale_mux_u(
    .prescale(UART_conf[7:2]) , 
    .div_ratio_rx(div_ratio_rx)
);

//TX and RX CLk
clock_divider #(.ratio_width(ratio_width))
clk_div_rx(
    .i_ref_clk(UART_CLK),
    .i_rst(rst_sync_uart),
    .i_clk_en(clk_div_en),
    .i_div_ratio(div_ratio_rx),
    
    .o_div_clk(RX_CLK)
);
 
clock_divider #(.ratio_width(ratio_width))
clk_div_tx(
    .i_ref_clk(UART_CLK),
    .i_rst(rst_sync_uart),
    .i_clk_en(clk_div_en),
    .i_div_ratio(DIV_ratio),
    
    .o_div_clk(TX_CLK)
);

//system controller
sys_ctrl sys_ctrl_u(
    .i_clk(REF_CLK),           // Input System Clock
    .i_arst_n(rst_sync_sys),        // Input Async Active Low Reset
    .i_ff_full(ff_full),       // Input Full flag from FIFO
    .i_rd_valid(rd_valid),      // Input Data ready from RF
    .i_out_valid(out_valid),     // Input Data ready from ALU
    .i_rx_d_valid(rx_d_valid),    // Input Data ready from RX Master
    .i_rd_data(rd_data),       // Input data from the RF
    .i_p_data(p_data),        // Input data from the RX Master
    .i_alu_out(alu_out),       // Input data from the ALU
//------------------------------------------------------------------------
    .o_alu_fun(alu_fun),       // Output ALU function to ALU
    .o_address(address),       // Output Address to RF
    .o_wr_data(wr_data),       // Output Data to be written to RF
    .o_tx_p_data(fifo_p_data),     // Output Data to be written in FIFO
    .o_tx_p_valid(fifo_p_valid),    // Output Valid data flag to fifo, *winc*
    .o_alu_en(alu_en),        // Output ALU Enable
    .o_clk_en(clk_en),        // Output Gated clock enable
    .o_wr_en(wr_en),         // Output RF Write enable
    .o_rd_en(rd_en),         // Output RF Read enable
    .o_clk_div_en(clk_div_en)     // Output UART clock divider enable
);

//register file
regfile_block #(.data_width(data_width), .address_width(address_width), .memory_width(memory_width))
regfile_u(   
    //inputs of RF
    .clk(REF_CLK),
    .WrEn(wr_en),
    .RdEn(rd_en),
    .RST(rst_sync_sys),
    .Address(address),
    .WrData(wr_data),

    //outouts of RF
    .RdData(rd_data),
    .RdData_Valid(rd_valid),
    .REG0(operant_A),
    .REG1(operant_B),
    .REG2(UART_conf),
    .REG3(DIV_ratio)
);

//RX
UART_RX #(.Prescale_width(Prescale_width),.DATA_width(data_width),.n_bits(n_bits))
UART_RX_u(
    //inputs of RX
	.Prescale(UART_conf[7:2]),
	.clk(RX_CLK), 
    .reset_n(rst_sync_uart),
	.PAR_TYP(UART_conf[1]),
	.PAR_EN(UART_conf[0]),
	.RX_IN(RX_IN),
	
    //outputs of RX
	.P_DATA(P_DATA_RX),
	.data_valid(data_valid_RX)
);

//data syncronizer 
DATA_SYNC # (.NUM_STAGES (2) , .BUS_WIDTH(data_width)) 
data_sync_u (
    .CLK(REF_CLK),
    .RST(rst_sync_sys),
    .unsync_bus(P_DATA_RX),
    .bus_enable(data_valid_RX),

    .sync_bus(p_data),
    .enable_pulse_d(rx_d_valid)
);

//clk gating
clk_gate clg_gate_u(
    .clk(REF_CLK),
    .clk_en(clk_en),

    .gated_clk(gated_clk)
);

//alu
ALU #(.N(data_width))
ALU_u(
    .A(operant_A),
    .B(operant_B),
    .ALUOp(alu_fun),
    .clk(gated_clk),         
    .rst(rst_sync_sys),         
    .enable(alu_en),
    
    .result(alu_out),
    .data_valid(out_valid)
);

//pulse generation
pulse_gen pulse_gen_u(
    .clk(TX_CLK),
    .rst(rst_sync_uart),
    .lvl_sig(busy),
    .pulse_sig(rd_inc)
);

//AFIFO
AFIFO #(.DEPTH(AFIFO_DEPTH), .DATA_WIDTH(data_width)) 
AFIFO_U(
  .wclk(REF_CLK), 
  .write_reset(rst_sync_sys),
  .read_clock(TX_CLK),
  .read_reset(rst_sync_uart),
  .write_en(fifo_p_valid), 
  .read_en(rd_inc),
  .write_data(fifo_p_data),

  .read_data(tx_p_data),
  .full(ff_full), 
  .empty(ff_empty)
);

//tx
UART_TX #(.data_width(data_width))
uart_tx_u(
    .clk(TX_CLK),
    .rst(rst_sync_uart),
    .par_typ(UART_conf[1]),
    .par_en(UART_conf[0]),
    .p_data(tx_p_data),
    .data_valid(~ff_empty),

    .tx_out(TX_OUT),
    .busy(busy)
);

endmodule