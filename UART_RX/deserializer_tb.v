`timescale 1ns / 1ps

module deserializer_tb();

// Signal Declaration

localparam T = 20;
parameter DATA_width = 8;
parameter Prescale_width = 6;

reg [Prescale_width-1 : 0] edge_cnt;
reg [Prescale_width-1 : 0] Prescale;
reg sampled_bit;
reg deser_en;
reg reset_n;
reg clk;

wire [DATA_width-1 : 0] P_DATA;

// Instantiate UUT

deserializer #(.DATA_width (DATA_width), .Prescale_width (Prescale_width)) UUT
(
	.sampled_bit (sampled_bit),
	.deser_en 	 (deser_en),
	.Prescale  	 (Prescale),
	.edge_cnt	 (edge_cnt),
	.reset_n  	 (reset_n),
	.clk 		 	 (clk),
	
	.P_DATA (P_DATA)
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
	
		sampled_bit = 1'b0; 
		deser_en 	= 1'b0;
		Prescale	   = 8;
		reset_n	   = 1'b0;
			
		#15
		reset_n = 1'b1;
		
		// Data = "01001101"
		
		#(T)
		deser_en = 1'b1;
      sampled_bit = 1'b1; // LSB
		
		#(Prescale * T)
		sampled_bit = 1'b0;
		
		#(Prescale * T)
		sampled_bit = 1'b1;
		
		#(Prescale * 2*T)
		sampled_bit = 1'b0;

		#(Prescale * 2*T)
		sampled_bit = 1'b1;
		
		#(Prescale * T)
		sampled_bit = 1'b0; // MSB
		
		#(Prescale * T)
		deser_en = 1'b0;
		
		#(Prescale * 2*T);
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