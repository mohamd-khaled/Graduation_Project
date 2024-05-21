module UART_TX #(parameter data_width = 8)
(clk ,rst ,par_typ,par_en,p_data,data_valid,tx_out,busy);

input                    clk;
input                    rst;
input                    par_typ;
input                    par_en;
input [data_width-1 : 0] p_data;
input                    data_valid;
output                   tx_out;
output                   busy;

wire        ser_done_wire;
wire [1:0]  mux_sel_wire;
wire        ser_en_wire;
wire        start_bit_wire = 0;  
wire        stop_bit_wire = 1;
wire        ser_data_wire;
wire        par_bit_wire;

tx_fsm #(.data_width(data_width))
tx_fsm_u(.clk(clk),
.rst(rst),
.data_valid(data_valid),
.ser_done(ser_done_wire),
.par_en(par_en),

.mux_sel(mux_sel_wire),
.busy(busy),
.ser_en(ser_en_wire));

tx_parity_calc #(.data_width(data_width))
tx_parity_calc_u(.clk(clk),
.rst(rst),
.Busy(busy),
.p_data(p_data),
.data_valid(data_valid),
.par_typ(par_typ),
.par_en(par_en),

.par_bit(par_bit_wire));

serailizer #(.data_width(data_width))
serailizer_u(.clk(clk),
.rst(rst),
.ser_en(ser_en_wire),
.data_valid(data_valid),
.busy(busy),
.p_data(p_data),

.ser_data(ser_data_wire),
.ser_done(ser_done_wire));

mux mux_u(.clk(clk),
.rst(rst),
.mux_sel(mux_sel_wire),
.start_bit(start_bit_wire),
.stop_bit(stop_bit_wire),
.ser_data(ser_data_wire),
.par_bit(par_bit_wire),

.tx_out(tx_out));

endmodule