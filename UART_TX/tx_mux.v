module mux(clk,rst,mux_sel,start_bit,stop_bit,ser_data,par_bit,tx_out);

input       clk;
input       rst;
input [1:0] mux_sel;
input       start_bit;
input       stop_bit;
input       ser_data;
input       par_bit;
output reg  tx_out;

localparam [1:0] start_bit_sel = 2'b00;
localparam [1:0] ser_data_sel  = 2'b01;
localparam [1:0] par_bit_sel   = 2'b10;
localparam [1:0] stop_bit_sel  = 2'b11;

always @(posedge clk, negedge rst)
begin
    if(~rst)
    begin
        tx_out <= 1'b1;
    end
    else
    begin
       case(mux_sel)    
         start_bit_sel : tx_out <= start_bit;
         ser_data_sel  : tx_out <= ser_data;
         par_bit_sel   : tx_out <= par_bit;
         stop_bit_sel  : tx_out <= stop_bit;
       endcase
    end
end


endmodule