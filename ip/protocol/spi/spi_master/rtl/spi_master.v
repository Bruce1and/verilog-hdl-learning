module spi_master (
    input clk_i,
    input rst_n,
    input miso_i,
    input start_i,
    input [7:0] tx_data_i,
    output reg sclk_o,
    output reg mosi_o,
    output reg cs_n_o,

    output reg rx_valid_o,
    output reg [7:0] rx_data_o,

    output reg tx_busy_o,
    output reg tx_done_o
);

    localparam IDLE = 2'd0;
    localparam START = 2'd1;
    localparam TRANS = 2'd2;
    localparam DONE = 2'd3;
    localparam SCK_DIV = 2;

    reg [1:0] state;
    reg [1:0] next_state;
    reg [15:0] sck_div_cnt;
    reg [3:0] bit_cnt;
    reg [7:0] rx_shift_reg;

    always @(posedge clk_i or negedge rst_n) begin
        if(!rst_n) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    always @(*) begin
        case (state)
            IDLE : begin
                if (start_i) begin
                    next_state = START;
                end else begin
                    next_state = IDLE;
                end
            end

            START : begin
                next_state = TRANS;
            end

            TRANS : begin
                if (bit_cnt == 4'd7) begin
                    next_state = DONE;
                end else begin
                    next_state = TRANS;
                end
            end

            DONE : begin
                next_state = IDLE;
            end

            default : begin
                next_state = IDLE;
            end
        endcase
    end

    always @(posedge clk_i or negedge rst_n) begin
        if (!rst_n) begin
            bit_cnt <= 4'd0;
            sck_div_cnt <= 16'd0;
        end else begin
            case (state)
                IDLE : begin
                    bit_cnt <= 4'd0;
                    sck_div_cnt <= 16'd0;
                end

                START : begin
                    bit_cnt <= 4'd0;
                    sck_div_cnt <= 16'd0;
                end

                TRANS : begin
                    if (sck_div_cnt == SCK_DIV - 1'b1) begin
                        sck_div_cnt <= 1'b0;
                        if (bit_cnt == 4'd7) begin
                            bit_cnt <= 4'd0;
                        end else begin
                            bit_cnt <= bit_cnt + 4'd1;
                        end
                    end else begin
                        sck_div_cnt <= sck_div_cnt + 16'b1;
                    end
                end

                DONE : begin
                    bit_cnt <= 4'd0;
                    sck_div_cnt <= 16'b0;
                end
            endcase
        end
    end

    always @(posedge clk_i or negedge rst_n) begin
        if (!rst_n) begin
            sclk_o <= 1'b0;
            mosi_o <= 1'b0;
            cs_n_o <= 1'b1;
            tx_busy_o <= 1'b0;
            tx_done_o <= 1'b0;
            rx_data_o <= 7'd0;
            rx_valid_o <= 1'b0;
        end else begin
            case (state)
                IDLE : begin
                    sclk_o <= 1'b0;
                    mosi_o <= 1'b0;
                    cs_n_o <= 1'b1;
                    tx_busy_o <= 1'b0;
                    tx_done_o <= 1'b0;
                    rx_data_o <= 7'd0;
                    rx_valid_o <= 1'b0;
                end

                START : begin
                    sclk_o <= 1'b0;
                    mosi_o <= tx_data_i[7];
                    cs_n_o <= 1'b0;
                    tx_busy_o <= 1'b1;
                    tx_done_o <= 1'b0;
                    rx_data_o <= 7'd0;
                    rx_valid_o <= 1'b0;
                end

                TRANS : begin
                    if (sck_div_cnt == SCK_DIV - 1'b1) begin
                        sclk_o <= ~sclk_o;
                        mosi_o <= tx_data_i[4'd7 - (bit_cnt + 4'd1)];
                        if (!sclk_o) begin                               // 当前 sclk_o 为低，即将翻转为高 → 上升沿
                            rx_shift_reg <= {rx_shift_reg[6:0], miso_i}; // 左移，新位放在最低位
                        end
                    end
                    cs_n_o <= 1'b0;
                    tx_busy_o <= 1'b1;
                    tx_done_o <= 1'b0;
                    rx_valid_o <= 1'b0;
                end

                DONE : begin
                    sclk_o <= 1'b0;
                    mosi_o <= 1'b0;
                    cs_n_o <= 1'b1;
                    tx_busy_o <= 1'b0;
                    tx_done_o <= 1'b1;
                    rx_data_o <= rx_shift_reg;
                    rx_valid_o <= 1'b1;
                end

            endcase
        end
    end


endmodule
