`timescale 1ns / 1ps

module data_sampling_tb();

//Signal Declaration

localparam T = 20;
parameter Prescale_width = 6;

reg [Prescale_width-1 : 0] Prescale;
reg [Prescale_width-1 : 0] edge_cnt;
reg dat_samp_en;
reg reset_n;
reg RX_IN;
reg clk;
	
wire sampled_bit;

// Instantiate UUT

data_sampling #(.Prescale_width(Prescale_width)) UUT
(
	.dat_samp_en (dat_samp_en),
	.Prescale 	 (Prescale),
	.edge_cnt 	 (edge_cnt),
	.reset_n 	 (reset_n),
	.RX_IN		 (RX_IN),
	.clk 			 (clk),
	
	.sampled_bit (sampled_bit)
);

// Clock Generator (20ns)

always 
	begin
	
		clk = 1'b1;
		# (T/2);
		
		clk = 1'b0;
		#(T/2);
		
	end 
	
// Stimuli

initial
	begin
		
		dat_samp_en = 1'b0;
		reset_n 		= 1'b0;
		Prescale	   = 8;
		RX_IN 		= 1'b0;
			
		@(negedge clk)
		reset_n = 1'b1;
		dat_samp_en = 1'b1;
		
		#(Prescale * T)
		RX_IN = 1'b1;
		
		#(Prescale * T)
		RX_IN = 1'b0;
		
		#(2*T);
		$stop;
	
	end 
	
// Edge Counter

always @(posedge clk, negedge reset_n)
	begin
		
		if (~ reset_n)
			edge_cnt = 'b0;
		
		else if (edge_cnt != Prescale - 1)
			edge_cnt = edge_cnt + 1;
		
		else 
			edge_cnt = 'b0;
	
	end 
	
endmodule 