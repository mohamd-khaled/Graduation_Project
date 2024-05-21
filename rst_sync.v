module rst_sync (clk,rst,sync_rst);

input      clk;
input      rst;
output reg sync_rst;

always @(posedge clk, negedge rst)
begin
   if(~rst)
   begin
      sync_rst <= 1'b0;
   end
   else
   begin
      sync_rst <= 1'b1;            
   end
end

endmodule
