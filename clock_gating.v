module clk_gate (clk,clk_en,gated_clk);

input  clk;
input  clk_en;
output gated_clk;

reg ff_clk_en;

always @(clk, clk_en)
begin
      ff_clk_en <= clk_en;
   if(~clk)
      ff_clk_en <= clk_en;  
end


assign gated_clk = clk & ff_clk_en;


endmodule