module serailizer #(parameter data_width = 8)
(clk,rst,ser_en,data_valid,busy,p_data,ser_data,ser_done);

input                    clk;
input                    rst;
input                    ser_en;
input                    data_valid;
input                    busy;
input [data_width-1 : 0] p_data;

output                   ser_data;
output                   ser_done; 

reg [(3 - 1):0] counter = {3{1'b0}};
reg [data_width-1 : 0]           data_reg;


always @ (posedge clk or negedge rst)
begin
  if(!rst)
   begin
    data_reg <= 'b0 ;
   end
  else if(data_valid && !busy)
   begin
    data_reg <= p_data ;
   end	
  else if(ser_en)
   begin
    data_reg <= data_reg >> 1 ;         // shift register
   end
end
 

always @ (posedge clk or negedge rst)
begin
  if(!rst)
   begin
    counter <= 'b0 ;
   end
  else
   begin
    if (ser_en)
	 begin
        counter <= counter + 'b1 ;		 
	 end
	else 
	 begin
        counter <= 'b0 ;		 
	 end	
   end
end 

assign ser_done = (counter == 'b111) ? 1'b1 : 1'b0 ;

assign ser_data = data_reg[0] ;


endmodule