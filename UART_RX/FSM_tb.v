`timescale 1ns / 1ps

module FSM_tb();

// Parameters

localparam T = 20;
parameter Prescale_width = 6; 
parameter n_bits = 4;

// Inputs

reg [Prescale_width-1 : 0] edge_cnt;
reg [Prescale_width-1 : 0] Prescale;
reg [n_bits-1 : 0] bit_cnt;
reg strt_glitch;
reg par_err;
reg stp_err;
reg reset_n;
reg PAR_EN;
reg RX_IN;
reg clk;

// Outputs

wire dat_samp_en;
wire strt_chk_en;
wire par_chk_en;
wire data_valid;
wire stp_chk_en;
wire deser_en;
wire enable;

// Instantiate UUT

FSM #(.Prescale_width (Prescale_width), .n_bits (n_bits)) UUT
(
	.strt_glitch (strt_glitch),
	.edge_cnt	 (edge_cnt),
	.Prescale	 (Prescale),
	.bit_cnt 	 (bit_cnt),
	.par_err 	 (par_err),
	.stp_err 	 (stp_err),
	.reset_n		 (reset_n),
	.PAR_EN 		 (PAR_EN),
	.RX_IN 		 (RX_IN),
	.clk 			 (clk),
	
	.dat_samp_en (dat_samp_en),
	.strt_chk_en (strt_chk_en),
	.par_chk_en  (par_chk_en),
	.data_valid  (data_valid),
	.stp_chk_en  (stp_chk_en),
	.deser_en	 (deser_en),
	.enable 		 (enable)
);

// Clock Generator (20 ns)

always 
	begin
		
		clk = 1'b1;
		#(T/2);
		
		clk = 1'b0;
		#(T/2);
	
	end 

// Stimuli

initial
	begin
		
		Prescale    = 8; 

// Test Case 1: Valid data with no errors
		
		strt_glitch = 1'b0;
		par_err     = 1'b0;
		stp_err     = 1'b0;
		reset_n     = 1'b0;
		PAR_EN      = 1'b1;
		RX_IN       = 1'b0;
		
		@(negedge clk) reset_n = 1'b1;

		// Data 
		
		#(Prescale * T) RX_IN = 1'b1;	 
		
		#(Prescale * 3*T) RX_IN = 1'b0;
			
		#(Prescale * 2*T) RX_IN = 1'b1;
			
		#(Prescale * 2*T) RX_IN = 1'b0;
			
		#(Prescale * T) RX_IN = 1'b1;	 
		
		#(Prescale * 3*T);
		
/************************************************************/	
	
// Test Case 2: Invalid data with Start Glitch and Stop error

		PAR_EN  = 1'b0;
		RX_IN   = 1'b0;
		
		#(4 * T) RX_IN = 1'b1; strt_glitch = 1'b1;
		
		#(T) RX_IN = 1'b0;
		
		#(Prescale * T) strt_glitch = 1'b0;

		// Data 
		
		#(Prescale * T) RX_IN = 1'b1; 
		
		#(Prescale * 3*T) RX_IN = 1'b0;
			
		#(Prescale * 2*T) RX_IN = 1'b1;
			
		#(Prescale * 2*T) RX_IN = 1'b0; 
			
		#(4 * T) RX_IN = 1'b0; // Stop bit
		
		#(T) stp_err = 1'b1;
		
		#(Prescale * T) stp_err = 1'b0;

/************************************************************/		
	
// Test Case 3: Invalid data with Parity Error

		PAR_EN  = 1'b1;
		RX_IN   = 1'b0;
		
		// Data 

		#(Prescale * T) RX_IN = 1'b1;   
		
		#(Prescale * 3*T) RX_IN = 1'b0;
			
		#(Prescale * 2*T) RX_IN = 1'b1;
			
		#(Prescale * 2*T) RX_IN = 1'b0;
			
		#(Prescale * T) RX_IN = 1'b1;  
		
		#(T) par_err = 1'b1;

		#(Prescale * T) par_err = 1'b0;
		
		#(Prescale * T) RX_IN = 1'b0;
		
		
		#(Prescale * T)
		$stop;
	
	end 

/************************************************************/	

	// edge_bit Counter
	
	always @(posedge clk, negedge reset_n)
	begin
		
		if (~ reset_n)
			begin 
				edge_cnt = 'b0;
				bit_cnt = 'b0;
			end 
		
		else if (enable)
		
			if (edge_cnt != Prescale - 1)
				edge_cnt = edge_cnt + 1;
			
			else 
				begin
					edge_cnt = 'b0;
					bit_cnt = bit_cnt + 1;
				end
				
		else 
			begin 
				edge_cnt = 'b0;
				bit_cnt = 'b0;
			end 
	
	end 

endmodule
