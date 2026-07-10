module spi_slave (
    input clk_i,
    input rst_n,

    // 主机发送信号
    input sclk_i,
    input mosi_i,
    input cs_n_i,

    // 从机发送信号数据
    input [7:0] tx_data_i,

    // 从机发送spi数据
    output miso_o,
    output reg tx_busy_o,
    output reg tx_done_o,

    // 从机接收主机spi数据
    output reg rx_valid_o,
    output reg [7:0] rx_data_o
);

    // 状态定义
    localparam IDLE = 3'd0;
    localparam START = 3'd1;
    localparam TRANS = 3'd2;
    localparam DONE = 3'd3;

    // 寄存器定义
    // 状态寄存器定义
    reg [2:0] state;
    reg [2:0] next_state;

    // 数据寄存器定义
    reg [7:0] rx_shift_reg;
    reg [7:0] tx_shift_reg;

    reg [3:0] bit_cnt;

    assign miso_o = (!cs_n_i) ? tx_shift_reg[7] : 1'bz;

    reg sclk_div;
    wire sclk_rise = ~sclk_div & sclk_i;
    wire sclk_fall = sclk_div & ~sclk_i;

    reg cs_n_div;
    wire cs_fall = cs_n_div & ~cs_n_i;

    always @(posedge clk_i or negedge rst_n) begin
        if (!rst_n) begin
            cs_n_div <= 1'b0;
        end else begin
            cs_n_div <= cs_n_i;
        end
    end

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

            START : begin
                if (sclk_rise) begin
                    next_state = TRANS;
                end else begin
                    next_state = START;
                end
            end

            TRANS : begin
                if (cs_n_i) begin
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
    // model0 : 上升沿采样, 下降沿更新

    always @(posedge clk_i or negedge rst_n) begin
        if (!rst_n) begin
            bit_cnt <= 4'd0;
        end else begin
            case (state)
                TRANS : begin
                    if (sclk_fall) begin
                        bit_cnt <= bit_cnt + 4'd1;
                    end
                end

                START : begin
                    bit_cnt <= 4'd0;
                end
            endcase
        end
    end

    always @(posedge clk_i or negedge rst_n) begin
        if (!rst_n) begin
            rx_shift_reg <= 8'd0;
        end else begin
            case (state)
                START, TRANS : begin
                    if (sclk_rise) begin
                        rx_shift_reg <= {rx_shift_reg[6:0], mosi_i};
                    end
                end
            endcase
        end
    end

    always @(posedge clk_i or negedge rst_n) begin
        if (!rst_n) begin
            rx_data_o <= 8'd0;
            rx_valid_o <= 1'b0;
        end else begin
            case (state)
                IDLE : begin
                    rx_valid_o <= 1'b0;
                end

                DONE : begin
                    rx_data_o <= rx_shift_reg;
                    rx_valid_o <= 1'b1;
                end
            endcase
        end
    end

    always @(posedge clk_i or negedge rst_n) begin
        if (!rst_n) begin
            tx_shift_reg <= 8'd0;
        end else begin
            if (cs_fall) begin
                tx_shift_reg <= tx_data_i;
            end else if (state == TRANS && sclk_fall) begin
                tx_shift_reg <= {tx_shift_reg[6:0], 1'b0};
            end

        end
    end

    always @(posedge clk_i or negedge rst_n) begin
        if (!rst_n) begin
            tx_busy_o <= 1'b0;
            tx_done_o <= 1'b0;
        end else begin
            case (state)
                IDLE : begin
                    tx_done_o <= 1'b0;
                end

                START, TRANS : begin
                    tx_busy_o <= 1'b1;
                end

                DONE : begin
                    tx_done_o <= 1'b1;
                    tx_busy_o <= 1'b0;
                end
            endcase
        end
    end

    //always @(posedge clk_i or negedge rst_n) begin
    //    if (!rst_n) begin
    //        miso_reg <= 1'b0;
    //        miso_oe <= 1'b0;
    //    end else begin
    //        case (state)
    //            START : begin
    //                miso_reg <= tx_shift_reg[7];
    //            end
    //            TRANS : begin
    //                miso_reg <= tx_shift_reg[6];
    //                if (bit_cnt == 4'd8) begin
    //                    miso_oe <= 1'b0;
    //                end else begin
    //                    miso_oe <= 1'b1;
    //                end
    //            end
    //        endcase
    //    end
    //end
endmodule

    // always @(posedge clk_i or negedge rst_n) begin
    //     if (!rst_n) begin
    //         miso_o <= 1'b0;
    //         tx_done_o <= 1'b0;
    //         tx_busy_o <= 1'b1;
    //         rx_data_o <= 1'b0;
    //         rx_valid_o <= 1'b0;
    //         rx_shift_reg <= 1'b0;
    //         tx_shift_reg <= 1'b0;
    //         sclk_fall_cnt <= 1'b0;
    //     end else begin
    //         case (state)
    //             IDLE : begin
    //                 miso_o <= 1'b0;
    //                 tx_done_o <= 1'b0;
    //                 tx_busy_o <= 1'b1;
    //                 rx_data_o <= 1'b0;
    //                 rx_valid_o <= 1'b0;
    //                 rx_shift_reg <= 1'b0;
    //                 tx_shift_reg <= 1'b0;
    //                 sclk_fall_cnt <= 1'b0;
    //             end

    //             TRANS : begin
    //                 if (sclk_fall) begin
    //                     tx_shift_reg <= tx_data_i[4'd7 - sclk_fall_cnt];
    //                     sclk_fall_cnt <= sclk_fall_cnt + 4'd1;
    //                 end if (sclk_rise) begin
    //                     rx_shift_reg <= {rx_shift_reg[6:0], mosi_i};
    //                 end
    //                 tx_done_o <= 1'b0;
    //                 tx_busy_o <= 1'b0;
    //                 rx_data_o <= 1'b0;
    //                 rx_valid_o <= 1'b0;
    //             end
    //         endcase
    //     end
    // end

