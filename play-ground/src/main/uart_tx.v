module uart_tx (
    input wire clk,
    input wire rst,
    input wire [7:0] data,
    input wire send,
    output reg tx,
    output reg busy
);

parameter BAUD_RATE = 9600;
parameter CLK_FREQ = 27000000;  // 27 MHz
parameter SAMPLE_TICKS = CLK_FREQ / BAUD_RATE;

reg [15:0] counter = 0;
reg [3:0] bit_index = 0;
reg [9:0] shift_reg = 10'b1111111111; // Start bit + 8 data bits + Stop bit

always @(posedge clk or posedge rst) begin
    if (rst) begin
        busy <= 0;
        counter <= 0;
        bit_index <= 0;
        tx <= 1;
    end else if (send && !busy) begin
        shift_reg <= {1'b1, data, 1'b0}; // Stop bit, Data, Start bit
        busy <= 1;
        bit_index <= 0;
        counter <= SAMPLE_TICKS;
    end else if (busy) begin
        counter <= counter - 1;
        if (counter == 0) begin
            counter <= SAMPLE_TICKS;
            tx <= shift_reg[0];
            shift_reg <= {1'b1, shift_reg[9:1]};
            bit_index <= bit_index + 1;
            if (bit_index == 10) busy <= 0;
        end
    end
end

endmodule
