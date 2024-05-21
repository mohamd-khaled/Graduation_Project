`timescale 1ns / 1ps

module Parity_Check_tb();

// Signal Declaration

localparam T = 20;
parameter DATA_width = 8;
parameter Prescale_width = 6;

reg [Prescale_width-1 : 0] edge_cnt;
reg [Prescale_width-1 : 0] Prescale;
reg [DATA_width-1 : 0] P_DATA;
reg sampled_bit;
reg par_chk_en;
reg reset_n;
reg PAR_TYP;
reg clk;

wire par_err;

// Instantiate UUT

Parity_Check #(.DATA_width (DATA_width), .Prescale_width (Prescale_width)) UUT
(
	.sampled_bit (sampled_bit),
	.par_chk_en  (par_chk_en),
	.Prescale  	 (Prescale),
	.edge_cnt	 (edge_cnt),
	.reset_n     (reset_n),
	.PAR_TYP     (PAR_TYP),
	.par_err     (par_err),
	.P_DATA      (P_DATA),
	.clk         (clk)	
);

// Clock Genetator (20 ns)

always 
	begin 
	
		clk = 1'b0;
		# (T/2);
		
		clk = 1'b1;
		# (T/2);
	
	end 

// Stimuli

initial
	begin
	
		sampled_bit = 1'b0;
		par_chk_en  = 1'b0;
		Prescale    = 8;
		reset_n     = 1'b0;
		PAR_TYP     = 1'b0;
		P_DATA      = 8'b 1011_0010;
		
		@(negedge clk);
		par_chk_en = 1'b1;
		reset_n    = 1'b1;
		
		#(Prescale * T)
		sampled_bit = 1'b1;
		
		#(Prescale * T)
		PAR_TYP = 1'b1;
		
		#(Prescale * 3*T)
		sampled_bit = 1'b0;
		
		#(Prescale * T)
		par_chk_en = 1'b0;
		
		#(Prescale * T)
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