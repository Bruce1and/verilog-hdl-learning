module uart_rx (
    input clk_i,
    input rst_n,
    input rx_i,
    output reg [7:0] data_o,
    output reg valid_o
);

    localparam IDLE = 1'b0;
    localparam RECEIVE = 1'b1;

    reg state;
    reg next_state;
    reg [3:0] data_cnt;


    parameter CLK_FREQ = 25000000;
    parameter BAUD = 115200;
    parameter ACC_W = 16;
    parameter ACC_INC = (BAUD << ACC_W) /CLK_FREQ;
    // ACC_INC = ((BAUD << (ACC_W - 4)) + (CLK_FREQ >> 5))/(CLK_FREQ >> 4);

    reg [ACC_W : 0] acc;

    always @(posedge clk_i or negedge rst_n) begin
        if (!rx_i || rx_i) begin
            acc <= 0;
        end else begin
            acc <= acc[ACC_W - 1 : 0] + ACC_INC;
        end
    end

    wire baud_tick = acc[ACC_W];

    always @(posedge clk_i or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end











    always @(posedge clk_i or negedge rst_n) begin
        if (!rst_n) begin
            data_o <= 8'd0;
            valid_o <= 1'd0;
        end else begin
            case (state)
                IDLE : begin
                    data_o <= 8'd0;
                    valid_o <= 1'd0;
                end

                RECEIVE : begin
                    data_o <= rx_i;
                    valid_o <= 1'd1;
                end
            endcase
        end
    end

endmodule

