module RPH #(parameter PTR_WIDTH=3) (
  input read_clock, read_reset, read_en,
  input [PTR_WIDTH-1:0] g_wptr_sync,
  output reg [PTR_WIDTH-1:0] b_rptr,
  output reg [PTR_WIDTH-1:0] g_rptr,
  output reg empty
);

  wire [PTR_WIDTH-1:0] b_rptr_next;
  wire [PTR_WIDTH-1:0] g_rptr_next;

  assign b_rptr_next = b_rptr+(read_en & !empty);
  assign g_rptr_next = (b_rptr_next >>1)^b_rptr_next;
  assign rempty = (g_wptr_sync == g_rptr_next);
  
  always@(posedge read_clock or negedge read_reset) begin
    if(!read_reset) begin
      b_rptr <= 0;
      g_rptr <= 0;
    end
    else begin
      b_rptr <= b_rptr_next;
      g_rptr <= g_rptr_next;
    end
  end
  
  always@(posedge read_clock or negedge read_reset) begin
    if(!read_reset) empty <= 1;
    else        empty <= rempty;
  end
endmodule