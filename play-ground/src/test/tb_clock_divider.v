`timescale 1ns/1ps

module tb_clock_divider;

reg clk;
reg rst;
wire slow_clk;

clock_divider #(.DIV_FACTOR(10)) uut (
    .clk(clk),
    .rst(rst),
    .slow_clk(slow_clk)
);

// Generate a clock (100 MHz)
always #5 clk = ~clk;

initial begin
    $dumpfile("tb_clock_divider.vcd");
    $dumpvars(0, tb_clock_divider);

    clk = 0;
    rst = 1;
    #20 rst = 0;

    #1000;
    $finish;
end

endmodule
