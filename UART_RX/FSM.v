module FSM 
	#(parameter Prescale_width = 6, n_bits = 4)
(
	input [Prescale_width-1 : 0] edge_cnt,
	input [Prescale_width-1 : 0] Prescale,
	input [n_bits-1 : 0] bit_cnt,
	input clk, reset_n,
	input strt_glitch,
	input par_err,
	input stp_err,
	input PAR_EN,
	input RX_IN,
	
	output dat_samp_en,
	output strt_chk_en,
	output par_chk_en,
	output stp_chk_en,
	output data_valid,
	output deser_en,		
	output enable
);

reg [2:0] state_reg, state_next;

localparam Idle   = 0;
localparam Start  = 1;
localparam Data   = 2;
localparam Parity = 3;
localparam Stop   = 4;
localparam Valid  = 5;

// State register

always @(posedge clk, negedge reset_n)
	begin
	
		if (~ reset_n)	
			state_reg   <= Idle;

		else 
			state_reg <= state_next;
		
	end 

// Next State Logic
	
always @(*)
	begin
	
		case (state_reg)
		
			Idle: if (RX_IN == 0)
						state_next = Start;
					else 
						state_next = Idle;

			Start: if (bit_cnt == 0 & edge_cnt == Prescale-1) 

						if (strt_glitch)
							state_next = Idle;
						else
							state_next = Data; 
							
					 else
						state_next = Start;
						
				
					
			Data: if (bit_cnt == 8 & edge_cnt == Prescale-1)
							
						if (PAR_EN == 1)
							state_next = Parity;
						else
							state_next = Stop;
								
					 else
						state_next = Data;	
				
			Parity: if (bit_cnt == 9 & edge_cnt == Prescale-1)

						if(par_err)
							state_next = Idle;
						else
							state_next = Stop;
					
					 else
						state_next = Parity;
			
				
				
			Stop: if (((PAR_EN == 1'b1 & bit_cnt == 10 ) | (PAR_EN == 1'b0 & bit_cnt == 9)) & (edge_cnt == Prescale-1)) 

						if (stp_err)
							state_next = Idle;
						else
							state_next = Valid;
					else
						state_next = Stop;
					
			Valid: if (RX_IN == 0)
						state_next = Start;
					else
						state_next = Idle;		
					
			default:	state_next = Idle;

		endcase
	
	end 
	
// Outputs

assign dat_samp_en = (state_reg == Start) | (state_reg == Data) | (state_reg == Parity) | (state_reg == Stop);
assign strt_chk_en = (state_reg == Start);
assign par_chk_en  = (state_reg == Parity);
assign stp_chk_en  = (state_reg == Stop);
assign data_valid  = (state_reg == Valid);
assign deser_en    = (state_reg == Data);
assign enable      = (state_reg == Start) | (state_reg == Data) | (state_reg == Parity) | (state_reg == Stop);

endmodule 