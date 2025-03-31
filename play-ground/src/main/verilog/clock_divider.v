module clock_divider #(
    parameter DIVISOR = 50000000
)(
    input clk,
    output reg clk_out
);
    reg [31:0] counter = 0;
    
    always @(posedge clk) begin
        counter <= counter + 1;
        if (counter >= DIVISOR/2) begin
            counter <= 0;
            clk_out <= ~clk_out;
        end
    end
endmodule
