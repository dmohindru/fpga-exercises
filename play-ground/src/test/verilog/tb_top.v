`timescale 1ns/1ps

module tb_top;

reg clk;
reg rst;
reg rx;
wire [5:0] led;

// Instantiate DUT (Device Under Test)
top uut (
    .clk(clk),
    .rx(rx),
    .led(led)
);

// Clock Generation (50 MHz)
always #10 clk = ~clk;

initial begin
    $dumpfile("tb_top.vcd");
    $dumpvars(0, tb_top);
    
    clk = 0;
    rst = 1;
    rx = 1;
    
    #50 rst = 0;

    // Send some UART data
    #500 rx = 0;  // Start bit
    #104160 rx = 1; // Data bit 0
    #104160 rx = 0; // Data bit 1
    #104160 rx = 1; // Data bit 2
    #104160 rx = 0; // Data bit 3
    #104160 rx = 1; // Data bit 4
    #104160 rx = 0; // Data bit 5
    #104160 rx = 1; // Data bit 6
    #104160 rx = 0; // Data bit 7
    #104160 rx = 1; // Stop bit

    #500;
    $finish;
end

endmodule
