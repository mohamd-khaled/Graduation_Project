`timescale 1ns / 1ps

module UART_RX_tb();

// Signal Declaration

//Parameters

localparam T = 20;
parameter Prescale_width = 6;
parameter DATA_width = 8;
parameter n_bits = 4;

//Inputs 

reg [Prescale_width-1 : 0] Prescale;
reg reset_n;
reg PAR_TYP;
reg PAR_EN;
reg RX_IN;
reg clk;

// Outputs

wire [DATA_width-1 : 0] P_DATA;
wire data_valid;

// Instantiate UUT 

UART_RX #(.Prescale_width (Prescale_width), .DATA_width (DATA_width), .n_bits(n_bits)) UUT
(
	.Prescale (Prescale),
	.reset_n  (reset_n),
	.PAR_TYP  (PAR_TYP),
	.PAR_EN   (PAR_EN),
	.RX_IN 	 (RX_IN),
	.clk		 (clk),
	
	.data_valid (data_valid),
	.P_DATA 		(P_DATA)
);

// Clock Generator (20 ns)

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
	
		Prescale = 8;
		reset_n 	= 1'b0;
		PAR_TYP  = 1'b0; // Even Parity 
		PAR_EN 	= 1'b1;
		RX_IN    = 1'b0; // Start bit 
		
		@(negedge clk)
		reset_n = 1'b1;		
		

// Test Case 1: Parity is enabled &  Parity type is Even
		
		// Data = "0100-1101"
		
		#(Prescale * T) RX_IN = 1'b1; // LSB
		
		#(Prescale * T) RX_IN = 1'b0;
		
		#(Prescale * T) RX_IN = 1'b1;
		
		#(Prescale * 2*T) RX_IN = 1'b0;

		#(Prescale * 2*T) RX_IN = 1'b1;
		
		#(Prescale * T) RX_IN = 1'b0; // MSB
		
		#(Prescale * T) RX_IN = 1'b0; // Parity bit

		#(Prescale * T) RX_IN = 1'b1; // Stop bit	

		
/**********************************************************/	
	
// Test Case 2: Parity is enabled &  Parity type is Odd
		
		#(Prescale * T) PAR_TYP  = 1'b1; // Odd Parity
		
		#(Prescale * T) RX_IN = 1'b0; // Start bit 
		
		// Data = "0101-1001"
		
		#(Prescale * T) RX_IN = 1'b1; // LSB
		
		#(Prescale * T) RX_IN = 1'b0;
		
		#(Prescale * 2*T) RX_IN = 1'b1;
		
		#(Prescale * 2*T) RX_IN = 1'b0;

		#(Prescale * T) RX_IN = 1'b1;
		
		#(Prescale * T) RX_IN = 1'b0; // MSB
		
		#(Prescale * T) RX_IN = 1'b1; // Parity bit

		#(Prescale * T) RX_IN = 1'b1; // Stop bit
		
				
/**********************************************************/

// Test Case 3: Parity is not enabled 

		#(Prescale * 2*T) PAR_EN 	= 1'b0;
		
		#(Prescale * T) RX_IN = 1'b0;  // Start bit 
		
		// Data = "1001-0010"
		
		#(Prescale * T) RX_IN = 1'b0;	 // LSB
		
		#(Prescale * T) RX_IN = 1'b1;
		
		#(Prescale * T) RX_IN = 1'b0;
		
		#(Prescale * 2*T) RX_IN = 1'b1;

		#(Prescale * T) RX_IN = 1'b0;
		
		#(Prescale * 2*T) RX_IN = 1'b1; // MSB

		#(Prescale * T) RX_IN = 1'b1;  // Stop bit 
		
		
/**********************************************************/	

// Test Case 4: Invalid data with Start Glitch & Stop error
		
		#(Prescale * T) RX_IN = 1'b0;
		
		#(5 * T) RX_IN = 1'b1; // Glitch
		
		#(T) RX_IN = 1'b0;
		
		// Data = "0110-0111"
		
		#(Prescale * 2*T) RX_IN = 1'b1;  // LSB
		
		#(Prescale * 3*T) RX_IN = 1'b0;
			
		#(Prescale * 2*T) RX_IN = 1'b1;
			
		#(Prescale * 2*T) RX_IN = 1'b0; // MSB
			
		#(Prescale * T) RX_IN = 1'b0;	 // Stop bit 
		
		
/**********************************************************/	

// Test Case 5: Invalid data with Parity Error
		
		#(Prescale * T) PAR_EN 	= 1'b1; PAR_TYP  = 1'b0; // Even Parity 
		
		// Data = "1001-0010"
		
		#(Prescale * T) RX_IN = 1'b0;   // LSB
		
		#(Prescale * T) RX_IN = 1'b1;
		
		#(Prescale * T) RX_IN = 1'b0;
		
		#(Prescale * 2*T) RX_IN = 1'b1;

		#(Prescale * T) RX_IN = 1'b0;
		
		#(Prescale * 2*T) RX_IN = 1'b1; // MSB
		
		#(Prescale * T) RX_IN = 1'b0;  // Parity bit 

		#(50) RX_IN = 1'b1; 				// Idle State

		
		
		#(Prescale * T)
		$stop;
	
	end 

endmodule 