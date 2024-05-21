
module clock_divider #(parameter ratio_width = 8)
(i_ref_clk,i_rst,i_clk_en,i_div_ratio,o_div_clk);
 
input                     i_ref_clk;
input                     i_rst;
input                     i_clk_en;
input [ratio_width-1 : 0] i_div_ratio;
output                    o_div_clk;


reg  [ratio_width-2 : 0]  counter;
wire [ratio_width-2 : 0]  zero_to_one_flip ;
wire [ratio_width-2 : 0]  one_to_zero_flip ;                                                       
reg                       div_clk;
reg                       odd_edge_tog ;
wire                      clk_en;
wire                      odd_checker;



always @(posedge i_ref_clk or negedge i_rst)               
begin
    if(!i_rst)
    begin
        counter <= 0;
        div_clk <= 0;
        odd_edge_tog <= 1;
    end
    else if(clk_en) 
    begin
      if(!odd_checker && (counter == zero_to_one_flip))              
      begin
        counter <= 0;
        div_clk <= ~div_clk;
      end
      else if((odd_checker && (counter == zero_to_one_flip) && odd_edge_tog ) || (odd_checker && (counter == one_to_zero_flip) && !odd_edge_tog ))  // odd edge flip condition
      begin  
        counter <= 0;
        div_clk <= ~div_clk;
        odd_edge_tog <= ~odd_edge_tog;
      end
      else
        counter <= counter + 1'b1;
    end
end



assign odd_checker = i_div_ratio[0] ;
assign zero_to_one_flip = ((i_div_ratio >> 1) - 1 );
assign one_to_zero_flip = (i_div_ratio >> 1);

assign clk_en = i_clk_en & !(i_div_ratio == 1'b0)  & !(i_div_ratio == 1'b1);      
assign o_div_clk = clk_en ? div_clk : i_ref_clk;


endmodule