module FIFOtest;

  parameter DATA_WIDTH = 8;

  wire [DATA_WIDTH-1:0] read_data;
  wire full;
  wire empty;
  reg [DATA_WIDTH-1:0] write_data;
  reg write_en, wclk, write_reset;
  reg read_en, read_clock, read_reset;
  reg [DATA_WIDTH-1:0] wdata_q[$], wdata;

  AFIFO as_fifo (wclk, write_reset,read_clock, read_reset,write_en,read_en,write_data,read_data,full,empty);

  always #10ns wclk = ~wclk;
  always #35ns read_clock = ~read_clock;
  
  initial begin
    wclk = 1'b0; write_reset = 1'b0;
    write_en = 1'b0;
    write_data = 0;
    
    repeat(10) @(posedge wclk);
    write_reset = 1'b1;

    repeat(2) begin
      for (int i=0; i<30; i++) begin
        @(posedge wclk iff !full);
        write_en = (i%2 == 0)? 1'b1 : 1'b0;
        if (write_en) begin
          write_data = $urandom;
          wdata_q.push_back(write_data);
        end
      end
      #50;
    end
  end

  initial begin
    read_clock = 1'b0; read_reset = 1'b0;
    read_en = 1'b0;

    repeat(20) @(posedge read_clock);
    read_reset = 1'b1;

    repeat(2) begin
      for (int i=0; i<30; i++) begin
        @(posedge read_clock iff !empty);
        read_en = (i%2 == 0)? 1'b1 : 1'b0;
        if (~read_en) begin
          wdata = wdata_q.pop_front();
	  #10ns;
          if(read_data !== wdata) $error("Time = %0t: Comparison Failed: expected wr_data = %h, rd_data = %h", $time, wdata, read_data);
          else $display("Time = %0t: Comparison Passed: wr_data = %h and rd_data = %h",$time, wdata, read_data);
        end
      end
      #50;
    end

    $finish;
  end
  
  initial begin 
    $dumpfile("dump.vcd"); $dumpvars;
  end
endmodule

