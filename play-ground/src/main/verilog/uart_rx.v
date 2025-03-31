module uart_rx (
    input wire clk,
    input wire rst,
    input wire rx,
    output reg [7:0] data,
    output reg valid
);

parameter BAUD_RATE = 9600;
parameter CLK_FREQ = 27000000;  // 27 MHz
parameter SAMPLE_TICKS = CLK_FREQ / BAUD_RATE;

reg [15:0] counter = 0;
reg [3:0] bit_index = 0;
reg [7:0] shift_reg = 0;
reg receiving = 0;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        counter <= 0;
        bit_index <= 0;
        receiving <= 0;
        valid <= 0;
    end else if (!rx && !receiving) begin
        receiving <= 1;
        counter <= SAMPLE_TICKS / 2;
    end else if (receiving) begin
        counter <= counter - 1;
        if (counter == 0) begin
            counter <= SAMPLE_TICKS;
            shift_reg <= {rx, shift_reg[7:1]};
            bit_index <= bit_index + 1;
            if (bit_index == 8) begin
                receiving <= 0;
                valid <= 1;
                data <= shift_reg;
            end
        end
    end
end

endmodule
