module ALU #(parameter N=8)(
    input [N-1:0] A,
    input [N-1:0] B,
    input [3:0] ALUOp, // 4-bit control for operation selection
    input clk,         // Clock input
    input rst,         // Reset input
    input enable,
    output [2*N-1:0] result,
    output reg data_valid // Output indicating valid data
);

// Register for storing the ALU result
reg [2*N-1:0] result_reg;

always @(posedge clk or negedge rst)
begin
    if (~rst) begin
        // Reset the ALU state on the falling edge of the reset signal
        result_reg <= {N{1'b0}}; // Initialize result_reg to N bits of 0
        data_valid <= 1'b0;
    end
    else begin
        if(enable == 1)
        begin
            // ALU operations
            case(ALUOp)
                4'b0000: // Addition
                begin
                    result_reg <= A + B;
                    data_valid <= 1'b1;
                end  
                
                4'b0001:  // Subtraction
                begin
                    result_reg <= A - B;
                    data_valid <= 1'b1;  
                end

                4'b0010:// Multiplication
                begin
                    result_reg <= A * B;  
                    data_valid <= 1'b1; 
                end
                
                /*4'b0011:  // Division
                begin
                    result_reg <= A / B;
                    data_valid <= 1'b1; 
                end*/

                
                4'b0100:  // Bitwise AND
                begin
                    result_reg <= A & B;
                    data_valid <= 1'b1; 
                end
                
                
                4'b0101:  // Bitwise OR
                begin
                    result_reg <= A | B;
                    data_valid <= 1'b1; 
                end

                
                4'b0110: // NAND
                begin
                    result_reg <= ~(A & B);
                    data_valid <= 1'b1; 
                end

                
                4'b0111: // NOR
                begin
                    result_reg <= ~(A | B);
                    data_valid <= 1'b1; 
                end 

                
                4'b1000:  // Bitwise XOR
                begin
                    result_reg <= A ^ B;
                    data_valid <= 1'b1; 
                end
            
                4'b1001:  // XNOR
                begin
                    result_reg <= ~(A ^ B);
                    data_valid <= 1'b1; 
                end

                
                4'b1010: // CMP (Set if equal)
                begin
                    result_reg <= (A == B) ? 1'b1 : 1'b0;
                    data_valid <= 1'b1; 
                end 
                
                4'b1011:  // CMP (Set if A > B)
                begin
                    result_reg <= (A > B) ? 1'b1 : 1'b0;
                    data_valid <= 1'b1; 
                end 
                
                4'b1100: // Left shift
                begin
                    result_reg <= (A << 1);  
                    data_valid <= 1'b1; 
                end 
                
                4'b1101: // Right shift (logical)
                begin
                    result_reg <= (A >> 1); 
                    data_valid <= 1'b1; 
                end 

                default: begin
                    result_reg <= {N{1'b0}}; // Default case (zero output)
                    data_valid <= 1'b0;
                end
            endcase
        end
        
        else
        begin
            data_valid <= 1'b0;  
        end
    end
end

// Output assignment
assign result = result_reg;

endmodule

