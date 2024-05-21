module data_sampling 
	#(parameter Prescale_width = 6)
(
	input [Prescale_width-1 : 0] Prescale,
	input [Prescale_width-1 : 0] edge_cnt,
	input clk, reset_n,
	input dat_samp_en,
	input RX_IN, 

	
	output reg sampled_bit

);

reg sampled_bit_next;

// State register

always @(posedge clk, negedge reset_n)
	begin
	
		if (~ reset_n)
			sampled_bit <= 1'b0;
			
		else
			sampled_bit <= sampled_bit_next;

	end
	
// Next State Logic

always @(*)
	begin
		sampled_bit_next = sampled_bit;
	
		if (dat_samp_en && edge_cnt == (Prescale >> 1) - 1) // Samling at the middle
			sampled_bit_next = RX_IN;
	
		else 
			sampled_bit_next = 1'b0;
	
	
	end 
	
	
	
endmodule 