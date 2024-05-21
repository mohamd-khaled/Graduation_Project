`timescale 1ns / 1ps

module Strt_Check_tb();

// Signal declaration

localparam T = 20;
parameter Prescale_width = 6;

reg [Prescale_width-1 : 0] edge_cnt;
reg [Prescale_width-1 : 0] Prescale;
reg strt_chk_en;
reg sampled_bit;
reg reset_n;
reg clk;

wire strt_glitch;

// Instantiate UUT

Strt_Check #(.Prescale_width (Prescale_width)) UUt 
(
	.strt_chk_en (strt_chk_en),
	.sampled_bit (sampled_bit),
	.Prescale  	 (Prescale),
	.edge_cnt	 (edge_cnt),
	.reset_n 	 (reset_n),
	.clk 			 (clk),
	
	.strt_glitch (strt_glitch)
);

// Clock generator (20 ns)

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
	
		reset_n 		= 1'b0;
		Prescale	   = 8;
		strt_chk_en = 1'b0;
		sampled_bit = 1'b0;
		
		#(T)
		reset_n = 1'b1;
		strt_chk_en = 1'b1;
		
		# (3 * T)
		sampled_bit = 1'b1;
		
		#(T)
		sampled_bit = 1'b0;
		
		#(T)
		strt_chk_en = 1'b0;
		
		#(3 * T)
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



