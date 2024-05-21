module test;
//output
wire RdData_Valid;
wire [7:0] RdData; //output data which is readed from adress 0or 1 or 2 or 3
wire [7:0] REG0;
wire [7:0] REG1;
wire [7:0] REG2;
wire [7:0] REG3;
//input
reg clk,WrEn,RdEn,RST; // one bit(wire)
reg [3:0]Address;
reg [7:0] WrData;
initial
begin
$monitor($time,,,,"RdData_Valid= %b   RdData=%b    REG0=%b   REG1=%b   REG2=%b   REG0=3=%b  ",RdData_Valid,RdData,REG0,REG1,REG2,REG3);
#0
clk=0;
WrEn=0;
RdEn=0;
RST=1;
#1 
WrEn=1;
#2
Address=5;
#2
WrData=5;
#2
RdEn=1;
WrEn=0;
#2   //t=9
Address=5;
#2  //t=11
RdEn=0;
RST=0;
#2  //t=13
RST=1;
RdEn=1;
#2   //t=15
Address=3;
#2 //t=17
RdEn=1;
#2  //t=19
Address=0;
#2  //t=21
RdEn=0;
WrEn=1;
#2  //t=23
Address=11;
#2  //t=25
WrData=7;
#2  //t=27
WrEn=0;
RdEn=1;
#2  //t=29
Address=10;
end

always
begin
#1 clk=~clk;
end
regfile_block RF(clk,WrEn,RdEn,RST,Address,WrData,RdData,RdData_Valid,REG0,REG1,REG2,REG3);
endmodule