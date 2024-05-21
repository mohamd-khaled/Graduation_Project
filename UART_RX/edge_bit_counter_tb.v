`timescale 1ns / 1ps

module edge_bit_counter_tb();

// Signal Declaration

localparam T = 20;
parameter Prescale_width = 6;

reg [Prescale_width-1 : 0] Prescale;
reg reset_n;
reg enable;
reg clk;

wire [Prescale_width-1 : 0] edge_cnt;
wire [3:0] bit_cnt;

// Instantiate UUT

edge_bit_counter #(.Prescale_width(Prescale_width)) UUT
(
	.Prescale (Prescale),
	.reset_n (reset_n),
	.enable (enable),
	.clk (clk),
	
	.edge_cnt (edge_cnt),
	.bit_cnt (bit_cnt)
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
	
		Prescale = 8;
		reset_n = 1'b0;
		enable = 1'b0;
		
		#15
		reset_n = 1'b1;
		
		#(T)
		enable = 1'b1;
		
		repeat(20) @(negedge clk);
		$stop;
		
	end	
	
endmodule
