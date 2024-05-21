module SYNC #(parameter WIDTH=3) (input clk, rst_n, input [WIDTH-1:0] d_in, output reg [WIDTH-1:0] d_out);
  reg [WIDTH-1:0] med;

  always@(posedge clk) begin
    if(!rst_n) begin
      med <= 0;
      d_out <= 0;
    end

    else begin
      med <= d_in;
      d_out <= med;
    end
  end
endmodule
