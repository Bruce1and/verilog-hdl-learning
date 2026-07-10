module baud_generator (
    input clk_i,
    input rst_i,
    output baudtick,
    output acc
);

    parameter CLK_FREQ = 25000000;
    parameter BAUD = 115200;
    parameter ACC_W = 16;
    parameter ACC_INC = (BAUD << ACC_W) /CLK_FREQ;
    // ACC_INC = ((BAUD << (ACC_W - 4)) + (CLK_FREQ >> 5))/(CLK_FREQ >> 4);

    reg [ACC_W : 0] acc;

    always @(posedge clk_i or negedge rst_n) begin
        if (!rst_n) begin
            acc <= 'd0;
        end else begin
            acc <= acc[ACC_W - 1 : 0] + ACC_INC;
        end
    end

    wire baudtick = acc[ACC_W];

endmodule
