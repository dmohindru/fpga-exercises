module top(
    input clk,
    output [5:0] led
);
    wire clk_div;
    wire [5:0] led_out;
    
    clock_divider #(25_000_000) clkDiv (clk, clk_div);
    led_controller ledCtrl (clk_div, led_out);

    assign led = ~led_out;
endmodule
