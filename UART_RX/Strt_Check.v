module Strt_Check
	#(parameter Prescale_width = 6)
(
	input  strt_chk_en,
	input  sampled_bit,
	input  clk, reset_n,
	input [Prescale_width-1 : 0] Prescale,
	input [Prescale_width-1 : 0] edge_cnt,
	
	output reg strt_glitch
);

reg strt_glitch_next;

//State register

always @(posedge clk, negedge reset_n)
	begin
	
		if (~ reset_n)
			strt_glitch <= 1'b0;
			
		else 
			strt_glitch <= strt_glitch_next;
			
	end 

//Next State Logic

always @(*)
	begin
		
		if (strt_chk_en)   
			
			if (edge_cnt == Prescale >> 1)
				strt_glitch_next = sampled_bit; // If sampled_bit = 1, This means there is a glitch
			
			else
				strt_glitch_next = strt_glitch;
			
		else 
			strt_glitch_next = 1'b0;
			
		
	end 
	
endmodule 