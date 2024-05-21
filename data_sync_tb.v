module tb_DataSynchronization;

  localparam data_width = 8;

  reg clk_in;      
  reg rst_in;        
  reg bus_enable; 
  reg [data_width-1:0] data_in;  

  wire enable_out;    
  wire [data_width-1:0] data_out; 

  // Instantiate the DataSynchronization 
  DataSynchronization #(.data_width(data_width)) 
  data_sync_u(
    .clk_in(clk_in),        
    .rst_in(rst_in),        
    .bus_enable(bus_enable), 
    .data_in(data_in),  
  
    .enable_out(enable_out),    
    .data_out(data_out)   
  );

  // Clock generation
  initial begin
    clk_in = 1;
    forever #5 clk_in = ~clk_in;
  end

  // Test stimulus
  initial begin
    // Apply reset inputs
    rst_in = 1'b0;
    bus_enable = 1'b0;
    #10 

  
    // Deassert reset
    rst_in = 1'b1;
    bus_enable = 1'b0;
    #10

    // Allow some time for synchronization
    rst_in = 1'b1;
    bus_enable = 1'b1;
    data_in = 8'b10101010;
    #10

    // monitor outputs
    $display("Time=%0t, enable_out=%b, data_out=%b", $time, enable_out, data_out);

    // Run simulation for more time
    #100;
    
    // Apply input data 2
     bus_enable = 1'b0;
     #10 bus_enable = 1'b1;
     data_in = 8'b01010101;

    // monitor outputs
    $display("Time=%0t, enable_out=%b, data_out=%b", $time, enable_out, data_out);

    // Run simulation for more time
    #100;

    // Apply input data 3
    bus_enable = 1'b0;
    #10 bus_enable = 1'b1;
    data_in = 8'b11001100;

    // monitor outputs
    $display("Time=%0t, enable_out=%b, data_out=%b", $time, enable_out, data_out);

    // Run simulation for more time
    #100;

    // Stop simulation
    #1000 $stop;
  end

endmodule
