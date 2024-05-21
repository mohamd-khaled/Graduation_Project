module UART_RX
	#(parameter Prescale_width = 6, DATA_width = 8, n_bits = 4)
(
	input [Prescale_width-1 : 0] Prescale,
	input clk, reset_n,
	input PAR_TYP,
	input PAR_EN,
	input RX_IN,
	
	output [DATA_width-1 : 0] P_DATA,
	output data_valid
);

wire [Prescale_width-1 : 0] edge_cnt;
wire [n_bits-1 : 0] bit_cnt;
wire sampled_bit;
wire dat_samp_en;
wire strt_glitch;
wire strt_chk_en;
wire stp_chk_en;
wire par_chk_en;
wire deser_en;
wire stp_err;
wire par_err;
wire enable;

FSM #(.Prescale_width (Prescale_width), .n_bits (n_bits)) UUT1
(
	// Inputs
	
	.strt_glitch (strt_glitch),
	.edge_cnt    (edge_cnt),
	.Prescale    (Prescale),
	.bit_cnt     (bit_cnt),
	.reset_n     (reset_n),
	.par_err     (par_err),
	.stp_err     (stp_err),
	.PAR_EN      (PAR_EN),
	.RX_IN       (RX_IN),
	.clk         (clk),
	
	// Outputs
	
	.dat_samp_en (dat_samp_en),
	.strt_chk_en (strt_chk_en),
	.par_chk_en  (par_chk_en),
	.stp_chk_en  (stp_chk_en),
	.data_valid  (data_valid),
	.deser_en    (deser_en),
	.enable      (enable)
);


data_sampling #(.Prescale_width (Prescale_width)) UUT2
(
	// Inputs
	
	.dat_samp_en (dat_samp_en),
	.Prescale    (Prescale),
	.edge_cnt 	 (edge_cnt),
	.reset_n 	 (reset_n),
	.RX_IN 		 (RX_IN),
	.clk 			 (clk),
	
	// Output
	
	.sampled_bit(sampled_bit)
);


edge_bit_counter #(.Prescale_width (Prescale_width), .n_bits (n_bits)) UUT3
(
	// Inputs
	
	.Prescale (Prescale),
	.reset_n  (reset_n),
	.enable   (enable),
	.clk 		 (clk),
	
	// Outputs
	
	.edge_cnt (edge_cnt),
	.bit_cnt  (bit_cnt)
);


deserializer #(.DATA_width (DATA_width), .Prescale_width (Prescale_width)) UUT4
(
	// Inputs 
	
	.sampled_bit (sampled_bit),
	.deser_en	 (deser_en),
	.Prescale 	 (Prescale),
	.edge_cnt	 (edge_cnt),
	.reset_n 	 (reset_n),
	.clk 			 (clk),
	
	// Output
	
	.P_DATA (P_DATA)
	
);


Parity_Check #(.DATA_width (DATA_width), .Prescale_width (Prescale_width)) UUT5
(	
	// Inputs 

	.sampled_bit (sampled_bit),
	.par_chk_en  (par_chk_en),
	.Prescale  	 (Prescale),
	.edge_cnt	 (edge_cnt),
	.reset_n 	 (reset_n),
	.PAR_TYP 	 (PAR_TYP),
	.P_DATA 		 (P_DATA),
	.clk 			 (clk),
	
	// Output
	
	.par_err (par_err)
);


Stop_Check #(.Prescale_width (Prescale_width)) UUT6
(
	// Inputs
	
	.sampled_bit (sampled_bit),
	.stp_chk_en  (stp_chk_en),
	.Prescale  	 (Prescale),
	.edge_cnt	 (edge_cnt),
	.reset_n 	 (reset_n),
	.clk 			 (clk),
	
	// Output
	
	.stp_err (stp_err)
);


Strt_Check #(.Prescale_width (Prescale_width)) UUT7
(
	// Inputs
	
	.sampled_bit (sampled_bit),
	.strt_chk_en (strt_chk_en),
	.Prescale  	 (Prescale),
	.edge_cnt	 (edge_cnt),
	.reset_n 	 (reset_n),
	.clk 			 (clk),
	
	// Output
	
	.strt_glitch (strt_glitch)
);

endmodule
