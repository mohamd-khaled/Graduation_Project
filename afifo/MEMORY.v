module MEMORY #(parameter DEPTH=8, DATA_WIDTH=8, PTR_WIDTH=3) (
  input wclk, write_en, read_clock,
  input [PTR_WIDTH-1:0] b_wptr, b_rptr,
  input [DATA_WIDTH-1:0] write_data,
  input full, empty,
  output reg [DATA_WIDTH-1:0] read_data
);

  reg [DATA_WIDTH-1:0] fifo[0:DEPTH-1];
  
  always@(posedge wclk) begin
    if(write_en & !full) begin
      fifo[b_wptr[PTR_WIDTH-1:0]] <= write_data;
    end
  end
  
  always@(posedge read_clock) begin
    if(!empty) begin
      read_data <= fifo[b_rptr[PTR_WIDTH-1:0]];
    end
  end
  
  
endmodule
