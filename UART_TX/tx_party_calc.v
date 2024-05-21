module tx_parity_calc #(parameter data_width = 8)
(clk,rst,Busy,p_data,data_valid,par_typ,par_en,par_bit);

input                  clk;
input                  rst;
input [data_width-1:0] p_data;
input                  data_valid;
input                  par_typ;
input                  par_en;
input                  Busy;

output reg             par_bit;

reg  [data_width-1:0]   data_reg;

//isolate input 
always @ (posedge clk or negedge rst)
 begin
  if(!rst)
   begin
    data_reg <= 'b0 ;
   end
  else if(data_valid && !Busy)
   begin
    data_reg <= p_data ;
   end 
 end
 

always @ (posedge clk or negedge rst)
begin
    if(!rst)
    begin
        par_bit <= 'b0 ;
    end
    else
    begin
        if (par_en)
        begin
            case(par_typ)
                1'b0 : 
                begin                 
                    par_bit <= ^data_reg  ;     // Even Parity
                end
                1'b1 : 
                begin
                    par_bit <= ~^data_reg ;     // Odd Parity
                end		
            endcase       	 
        end
    end
end 



endmodule