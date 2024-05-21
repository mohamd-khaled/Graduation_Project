
module AFIFO #(parameter DEPTH=8, DATA_WIDTH=8) (
  input wclk, write_reset,
  input read_clock, read_reset,
  input write_en, read_en,
  input [DATA_WIDTH-1:0] write_data,
  output [DATA_WIDTH-1:0] read_data,
  output full, empty
);
  
  localparam PTR_WIDTH = 3;
 
  wire [PTR_WIDTH-1:0] g_wptr_sync, g_rptr_sync;
  wire [PTR_WIDTH-1:0] b_wptr, b_rptr;
  wire [PTR_WIDTH-1:0] g_wptr, g_rptr;


  SYNC #(PTR_WIDTH) sync_wptr (read_clock, read_reset, g_wptr, g_wptr_sync); 
  SYNC #(PTR_WIDTH) sync_rptr (wclk, write_reset, g_rptr, g_rptr_sync); 
  
  WPH #(PTR_WIDTH) wptr_h(wclk, write_reset, write_en,g_rptr_sync,b_wptr,g_wptr,full);
  RPH #(PTR_WIDTH) rptr_h(read_clock, read_reset, read_en,g_wptr_sync,b_rptr,g_rptr,empty);
  MEMORY fifom(wclk, write_en, read_clock,b_wptr, b_rptr, write_data,full,empty, read_data);

endmodule
