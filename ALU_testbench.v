module ALU_Testbench;

  // Parameters
  parameter N = 8;

  // Signals
  reg [N-1:0] A, B;
  reg [3:0] ALUOp;
  reg clk, rst, enable;
  wire [2*N-1:0] result;
  wire data_valid;

  // Instantiate the ALU
  ALU #(N) myALU (
    A,
    B,
    ALUOp, // 4-bit control for operation selection
    clk,         // Clock input
    rst,         // Reset input
    enable,
    result,
    data_valid // Output indicating valid data
);

  // Clock generation on negedge
  initial begin
    clk = 1'b1;
    forever #5 clk = ~clk;
  end

  // Test procedure on negedge of the clock
initial
begin
    // Initialize inputs
    rst = 1'b1;
    enable = 1'b0;
    A = 8'b11011010;
    B = 8'b00101011;
    ALUOp = 4'b0000; // Addition
    #1
    rst = 1'b0; // Active-low reset 
    enable = 1'b1;
    $display("Initial Inputs: A=%b, B=%b, ALUOp=%b, rst=%b  Result=%b, data_valid=%b, time=%t", A, B, ALUOp, rst, result, data_valid, $realtime);
    #9
    // Display initial inputs

    // Test different operations
    A = 8'b11011010; B = 8'b00101011; ALUOp = 4'b0000; // Addition
    #1
    $display("Initial Inputs: A=%b, B=%b, ALUOp=%b, rst=%b  Result=%b, data_valid=%b, time=%t", A, B, ALUOp, rst, result, data_valid, $realtime);
	  #19
     A = 8'b11011010; B = 8'b00101011; ALUOp = 4'b0001; // Subtraction
     #1
     $display("Initial Inputs: A=%b, B=%b, ALUOp=%b, rst=%b  Result=%b, data_valid=%b, time=%t", A, B, ALUOp, rst, result, data_valid, $realtime);
     A = 8'b0000100; B = 8'b1111000; ALUOp = 4'b0010;
     #1
     $display("Initial Inputs: A=%b, B=%b, ALUOp=%b, rst=%b  Result=%b, data_valid=%b, time=%t", A, B, ALUOp, rst, result, data_valid, $realtime);
     #19

    A = 8'b11011010; B = 8'b00101011; ALUOp = 4'b0011; // Division
    #1
    $display("Initial Inputs: A=%b, B=%b, ALUOp=%b, rst=%b  Result=%b, data_valid=%b, time=%t", A, B, ALUOp, rst, result, data_valid, $realtime);
    // Add more test cases as needed

    // Add some delay to observe the results in simulation
  end

endmodule

