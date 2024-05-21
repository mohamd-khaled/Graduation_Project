module WPH #(parameter PTR_WIDTH=3) (
  input wclk, write_reset, write_en,
  input [PTR_WIDTH-1:0] g_rptr_sync,
  output reg [PTR_WIDTH-1:0] b_wptr,
  output reg [PTR_WIDTH-1:0] g_wptr,
  output reg full
);

  wire [PTR_WIDTH-1:0] b_wptr_next;
  wire [PTR_WIDTH-1:0] g_wptr_next;
   
  wire wfull;
  
  assign b_wptr_next = b_wptr+(write_en & !full);
  assign g_wptr_next = (b_wptr_next >>1)^b_wptr_next;

  always@(posedge wclk or negedge write_reset) begin
    if(!write_reset) begin
      b_wptr <= 0;
      g_wptr <= 0;
    end
    else begin
      b_wptr <= b_wptr_next;
      g_wptr <= g_wptr_next; 
    end
  end
  
  always@(posedge wclk or negedge write_reset) begin
    if(!write_reset) full <= 0;
    else        full <= wfull;
  end

  assign wfull = (g_wptr_next == {~g_rptr_sync[PTR_WIDTH-1:PTR_WIDTH-2], g_rptr_sync[PTR_WIDTH-3:0]});

endmodule
