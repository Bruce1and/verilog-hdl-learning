module uart_rx (
    input clk_i,
    input rst_n,
    input rx_i,
    output reg [7:0] data_o,
    output reg valid_o
);
    localparam CLK_FREQ = 25_000_000;
    localparam BAUD = 115200;

    localparam IDLE = 3'd0;
    localparam START = 3'd1;
    localparam DATA = 3'd2;
    localparam STOP = 3'd3;

    reg [2:0] state;
    reg [2:0] next_state;
    reg [3:0] data_cnt;
    reg [15:0] baud_cnt;

    wire [15:0] bit_t = CLK_FREQ / BAUD;

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
                next_state = (!rx_i) ? START : IDLE;
            end

            START : begin
                if (baud_cnt == bit_t - 16'd1) begin
                    next_state = DATA;
                end else begin
                    next_state = START;
                end
            end

            DATA : begin
                if (baud_cnt == bit_t - 16'd1 && data_cnt == 4'd7) begin
                    next_state = STOP;
                end else begin
                    next_state = DATA;
                end
            end

            STOP : begin
                if (baud_cnt == bit_t - 16'd1) begin
                    next_state = IDLE;
                end else begin
                    next_state = STOP;
                end
            end

            default : begin
                next_state = IDLE;
            end
        endcase
    end

    always @(posedge clk_i or negedge rst_n) begin
        if (!rst_n) begin
            baud_cnt <= 16'd0;
            data_cnt <= 4'd0;
        end else begin
            case (state)
                IDLE : begin
                    baud_cnt <= 16'd0;
                    data_cnt <= 4'd0;
                end

                START, STOP : begin
                    if (baud_cnt == bit_t - 16'd1) begin
                        baud_cnt <= 16'd0;
                    end else begin
                        baud_cnt <= baud_cnt + 16'd1;
                    end
                end

                DATA : begin
                    if (data_cnt == 4'd7 && baud_cnt == bit_t - 16'd1) begin
                        data_cnt <= 4'd0;
                        baud_cnt <= 4'd0;
                    end else if (baud_cnt == bit_t - 16'd1) begin
                        data_cnt <= data_cnt + 4'd1;
                        baud_cnt <= 16'd0;
                    end else begin
                        baud_cnt <= baud_cnt + 16'd1;
                    end
                end

            endcase
        end
    end

    always @(posedge clk_i or negedge rst_n) begin
        if (!rst_n) begin
            data_o <= 8'd0;
            valid_o <= 1'd0;
        end else begin
            case (state)
                DATA : begin
                    if (baud_cnt == (bit_t >> 1) - 16'd1) begin
                        data_o <= {rx_i, data_o[7:1]};
                    end
                end

                STOP : begin
                    valid_o <= 1'd1;
                end

                default : begin
                    data_o <= 8'd0;
                    valid_o <= 1'd0;
                end
            endcase
        end
    end


//    always @(posedge clk_i or negedge rst_n) begin
//        if (!rst_n) begin
//            state <= IDLE;
//            baud_cnt <= 16'd0;
//            data_cnt <= 4'd0;
//        end else begin
//            case (state)
//                IDLE : begin
//                    if (!rx_i) begin
//                        state <= START;
//                    end
//                end
//
//                START : begin
//                    if (baud_cnt == bit_t - 16'd1) begin
//                        state <= DATA;
//                        baud_cnt <= 16'd0;
//                    end else begin
//                        baud_cnt <= baud_cnt + 16'd1;
//                    end
//                end
//
//                DATA : begin
//                    if (data_cnt == 4'd7 && baud_cnt == bit_t - 16'd1) begin
//                        data_cnt <= 4'd0;
//                        baud_cnt <= 16'd0;
//                        state <= IDLE;
//                    end else if (baud_cnt == bit_t - 16'd1) begin
//                        data_cnt <= data_cnt + 4'd1;
//                        baud_cnt <= 16'd0;
//                    end else begin
//                        baud_cnt <= baud_cnt + 16'd1;
//                    end
//                end
//
//                default : state = IDLE;
//            endcase
//        end
//    end

endmodule


