module pulse_gen(clk,rst,lvl_sig,pulse_sig);

input  clk;
input  rst;
input  lvl_sig;
output pulse_sig;

reg              rcv_flop  , 
                 pls_flop  ;
					 
					 
always @(posedge clk or negedge rst)
 begin
  if(!rst)      // active low
   begin
    rcv_flop <= 1'b0 ;
    pls_flop <= 1'b0 ;	
   end
  else
   begin
    rcv_flop <= lvl_sig;   
    pls_flop <= rcv_flop;
   end  
 end
 
//----------------- pulse generator --------------------

assign pulse_sig = rcv_flop && !pls_flop ;

endmodule