module spi_slave (
    input clk_i,
    input rst_n,
    input sclk_i,
    input mosi_i,
    input cs_n_i,
    input tx_start_i,
    input [7:0] tx_data_i,
    output reg miso_o,
    output reg tx_busy_o,
    output reg tx_done_o,
    output reg rx_valid_o,
    output reg [7:0] rx_data_o
);

    localparam IDLE = 2'd0;
    localparam START = 2'd1;
    localparam TRANS = 2'd2;
    localparam DONE = 2'd3;

    reg [1:0] state;
    reg [1:0] next_state;

    reg [7:0] rx_shift_reg;
    reg tx_shift_reg;

    reg sclk_div;

    reg [3:0] sclk_rise_cnt;
    reg [3:0] sclk_fall_cnt;

    assign sclk_rise = ~sclk_div & sclk_i;
    assign sclk_fall = sclk_div & ~sclk_i;

    always @(posedge clk_i or negedge rst_n) begin
        if (!rst_n) begin
            sclk_div <= 1'b0;
        end else begin
            sclk_div <= sclk_i;
        end
    end

    always @(posedge clk_i or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    always @(*) begin
        case (state)
            IDLE : begin
                if (!cs_n_i) begin
                    next_state = START;
                end else begin
                    next_state = IDLE;
                end
            end

            TRANS : begin
                if (cs_n_i) begin
                    next_state = IDLE;
                end else begin
                    next_state = TRANS;
                end
            end

            default : begin
                next_state = IDLE;
            end
        endcase
    end

    always @(posedge clk_i or negedge rst_n) begin
        if (!rst_n) begin
            miso_o <= 1'b0;
            tx_done_o <= 1'b0;
            tx_busy_o <= 1'b1;
            rx_data_o <= 1'b0;
            rx_valid_o <= 1'b0;
        end else begin
            case (state)
                IDLE : begin
                    miso_o <= 1'b0;
                    tx_done_o <= 1'b0;
                    tx_busy_o <= 1'b1;
                    rx_data_o <= 1'b0;
                    rx_valid_o <= 1'b0;
                end

                TRANS : begin
                    if (sclk_fall) begin
                        tx_shift_reg <= tx_data_i[4'd7 - sclk_fall_cnt];
                        sclk_fall_cnt <= sclk_fall_cnt + 4'd1;
                    end if (sclk_rias) begin
                        rx_shift_reg <= {rx_shift_reg[6:0], mosi_i};
                    end
                    tx_done_o <= 1'b0;
                    tx_busy_o <= 1'b0;
                    rx_data_o <= 1'b0;
                    rx_valid_o <= 1'b0;
                end
            endcase
        end
    end

endmodule
