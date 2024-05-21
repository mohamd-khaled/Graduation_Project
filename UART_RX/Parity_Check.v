module Parity_Check
	#(parameter DATA_width = 8, Prescale_width = 6)
(
	input PAR_TYP,
	input par_chk_en,
	input sampled_bit,
	input clk, reset_n,
	input [DATA_width-1 : 0] P_DATA,
	input [Prescale_width-1 : 0] Prescale,
	input [Prescale_width-1 : 0] edge_cnt,
	
	output reg par_err
);

reg par_err_next;

//State register

always @(posedge clk, negedge reset_n)
	begin
	
		if (~ reset_n)
			par_err <= 1'b0;
			
		else 
			par_err <= par_err_next;
			
	end

//Next State Logic
	
always @(*)
	begin			
		
		if (par_chk_en)
		
			if (edge_cnt == Prescale >> 1)
				begin 
				
					case (PAR_TYP)
						
						// Even Parity
						1'b0: 
							if (^P_DATA == sampled_bit) //If number of 1s is Even, sampled_bit = 0,  xored Data = 0
								par_err_next <= 1'b0;    // If number of 1s is Odd, sampled_bit = 1, xored Data = 1 
							
							else
								par_err_next <= 1'b1;
								
						// Odd Parity		
						1'b1:
							if (^P_DATA == ~sampled_bit) //If number of 1s is Odd, sampled_bit = 0, xored Data = 1 
								par_err_next <= 1'b0;     // If number of 1s is Even, sampled_bit = 1, xored Data = 0
							
							else
								par_err_next <= 1'b1;		
					endcase
					
				end 
				
			else 
				par_err_next <= par_err; 
			
		else 
			par_err_next <= 1'b0;
		
	end 
	
endmodule 