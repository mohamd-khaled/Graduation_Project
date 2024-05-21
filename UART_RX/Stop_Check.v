module Stop_Check
	#(parameter Prescale_width = 6)
(
	input stp_chk_en,
	input sampled_bit,
	input clk, reset_n,
	input [Prescale_width-1 : 0] Prescale,
	input [Prescale_width-1 : 0] edge_cnt,
	
	output reg stp_err
);

reg stp_err_next;

//State register

always @(posedge clk, negedge reset_n)
	begin
	
		if (~ reset_n)
			stp_err <= 1'b0;
			
		else 
			stp_err <= stp_err_next;
			
	end

//Next State Logic	
		
always @(*)
	begin
	
		if (stp_chk_en)
		
			if (edge_cnt == Prescale >> 1)
				stp_err_next = ~sampled_bit; // If Sampled_bit = 0, This mean the frame is Corrupted
				
			else 
				stp_err_next = stp_err;
		
		else
			stp_err_next = 1'b0;
	
	end 

endmodule 