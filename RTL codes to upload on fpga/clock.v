`default_nettype none

module clock #(parameter div = 6)(clk,div_clk);
	 
	 input clk;
    output reg div_clk = 1'b0;
	 
	reg [7:0] counter = 0;
	
	always @(posedge clk)
	begin
		counter <= counter + 1'b1;
		if(counter == div)
		begin
			counter <= 0;
			div_clk = ~div_clk;
		end
	end
	
endmodule
