module regfile_block #(parameter data_width = 8, parameter address_width = 4, parameter memory_width = 16)
(clk,WrEn,RdEn,RST,Address,WrData,RdData,RdData_Valid,REG0,REG1,REG2,REG3);

//inputs
input wire  clk;
input wire  WrEn;
input wire  RdEn;
input wire  RST;
input wire [address_width-1 : 0] Address;
input wire [data_width-1 : 0] WrData;

//outputs
output reg  RdData_Valid;
output reg  [data_width-1 : 0] RdData; 
output wire [data_width-1 : 0] REG0;
output wire [data_width-1 : 0] REG1;
output wire [data_width-1 : 0] REG2;
output wire [data_width-1 : 0] REG3;

// saved bits in reg 2 and reg3
reg [data_width-1 : 0] memory [memory_width-1 : 0];

reg [4:0]i=0;

always @(posedge clk, negedge RST)
begin
    if(~RST)
    begin
        memory[0] <= 'b0;
        memory[1] <= 'b0;
        memory[2] <= 8'b10000001;
        memory[3] <= 8'b00100000;
        RdData_Valid <= 1'b0;
        RdData <= 'b0;
        for(i=4;i<16;i=i+1)
        begin
        memory[i] <= 0;
        end
    end
    else
    begin
        if(WrEn && !RdEn)
        begin
            begin
                memory[Address]<= WrData;
            end

            RdData_Valid <= 1'b0;
        end

        else if(RdEn && !WrEn)
        begin
                RdData_Valid<=1;
                RdData<=memory[Address];
        end

        else
        begin
            RdData_Valid <= 1'b0;
        end
    end
end


assign REG0 = memory[0] ;
assign REG1 = memory[1] ;
assign REG2 = memory[2] ;
assign REG3 = memory[3] ;


endmodule