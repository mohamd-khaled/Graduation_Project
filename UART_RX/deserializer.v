module deserializer
	#(parameter DATA_width = 8, Prescale_width = 6)
(
	input deser_en,
	input sampled_bit,
	input clk, reset_n,
	input [Prescale_width-1 : 0] Prescale,
	input [Prescale_width-1 : 0] edge_cnt,
	
	output reg [DATA_width-1 : 0] P_DATA
);

reg [DATA_width-1 : 0] P_DATA_next;
reg [DATA_width-1 : 0] bit_n_reg, bit_n_next; // Keep track of the number of data bits recieved

//State register

always @(posedge clk, negedge reset_n)
	begin
	
		if (~ reset_n)
			begin
				P_DATA <= 'b0;
				bit_n_reg <= 'b0;
		   end
			
		else 
			begin
				P_DATA <= P_DATA_next;
				bit_n_reg <= bit_n_next;
			end 
		
	end 
	
//Next State Logic

always @(*)
	begin
		P_DATA_next = P_DATA;
		bit_n_next = bit_n_reg;
		
		if (deser_en & (bit_n_reg != DATA_width) & (edge_cnt == Prescale >> 1))
			begin
			
				P_DATA_next [bit_n_next] = sampled_bit;
				bit_n_next = bit_n_next + 1;
				
			end

		
		else if (bit_n_reg == DATA_width)
		
			bit_n_next = 'b0;
			
		else 
			P_DATA_next = P_DATA;
	
	end 
	
endmodule 