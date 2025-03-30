module led_controller(
    input clk,
    output reg [5:0] led
);
    always @(posedge clk) begin
        led <= led + 1;
    end
endmodule
