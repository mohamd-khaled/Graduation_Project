module prescale_mux #(parameter data_width = 8)
(prescale , div_ratio_rx);

input [5:0] prescale;

output reg [data_width-1:0] div_ratio_rx;

always @(*)
  begin
	case(prescale) 
        6'b100000 : 
        begin
            div_ratio_rx = 'd1 ;
        end

        6'b010000 : 
        begin
            div_ratio_rx = 'd2 ;
        end	
        6'b001000 : 
        begin
            div_ratio_rx = 'd4 ;
        end	
        6'b000100 :
        begin
            div_ratio_rx = 'd8 ;
        end

        default :
        begin
            div_ratio_rx = 'd1 ;
        end					
	endcase
  end	
  

endmodule