module edge_bit_counter
	#(parameter Prescale_width = 6, n_bits = 4)
(
	input [Prescale_width-1 : 0] Prescale,
	input clk, reset_n,
	input enable,
	
	output reg [Prescale_width-1 : 0] edge_cnt,
	output reg [n_bits-1 : 0] bit_cnt
);


reg [Prescale_width-1 : 0] edge_cnt_next;
reg [n_bits-1 : 0] bit_cnt_next;

//State register

always @(posedge clk, negedge reset_n)
	begin
	
		if (~reset_n)
			begin			
				edge_cnt <= 'b0;
				bit_cnt <= 'b0;				
			end
			
		else 
			begin
				edge_cnt <= edge_cnt_next;
				bit_cnt <= bit_cnt_next;
			end
	
	end 
	
//Next State Logic

always @(*)
	begin
		edge_cnt_next = edge_cnt;
		bit_cnt_next = bit_cnt;
	
		if (enable)
			
			if (edge_cnt != Prescale - 1)
				edge_cnt_next = edge_cnt_next + 1'b1;
				
			else
				begin 
					edge_cnt_next = 'b0;
					bit_cnt_next = bit_cnt_next + 1'b1; 
				end 
		
		else 
			begin 
				edge_cnt_next = 'b0;
				bit_cnt_next = 'b0;
			end 
	
	end 	

endmodule 