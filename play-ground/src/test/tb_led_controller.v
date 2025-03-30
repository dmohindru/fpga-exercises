`timescale 1ns/1ps
module tb_led_controller();
    reg clk = 0;
    wire [5:0] led;
    
    led_controller uut (clk, led);
    
    always #5 clk = ~clk;  // 10ns clock cycle
    
    initial begin
        $dumpfile("tb_led_controller.vcd");
        $dumpvars(0, tb_led_controller);
        
        #200 $finish;  // Run for 200 time units
    end
endmodule
