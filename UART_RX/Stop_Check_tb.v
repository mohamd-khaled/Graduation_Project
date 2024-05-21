`timescale 1ns / 1ps

module Stop_Check_tb();

// Signal Declaration

localparam T = 20;
parameter Prescale_width = 6;

reg [Prescale_width-1 : 0] edge_cnt;
reg [Prescale_width-1 : 0] Prescale;
reg sampled_bit;
reg stp_chk_en;
reg reset_n;
reg clk;

wire stp_err;

// Instantiate UUT

Stop_Check #(.Prescale_width (Prescale_width)) UUT 
(
	.sampled_bit (sampled_bit),
	.stp_chk_en  (stp_chk_en),
	.Prescale  	 (Prescale),
	.edge_cnt	 (edge_cnt),
	.reset_n     (reset_n),
	.clk         (clk),
	
	.stp_err     (stp_err)
);

// Clock generator (20ns)

always
	begin
	
		clk = 1'b1;
		# (T/2);
		
		clk = 1'b0;
		# (T/2);
	
	end
	
// Stimuli

initial 
	begin
	
		reset_n 	   = 1'b0;
		Prescale	   = 8;
		stp_chk_en  = 1'b0;
		sampled_bit = 1'b1;
		
		#(T)
		reset_n = 1'b1;
		stp_chk_en = 1'b1;
		
		# (3 * T)
		sampled_bit = 1'b0;
		
		#(T)
		sampled_bit = 1'b1;
		
		#(T)
		stp_chk_en = 1'b0;
		
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





