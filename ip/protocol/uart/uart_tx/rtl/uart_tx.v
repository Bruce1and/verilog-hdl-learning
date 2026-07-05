module uart_tx (
    input clk_i,
    input rst_n,
    input tx_start,
    input [7:0] tx_i,
    output reg tx_o,
    output reg busy_o
);

    localparam CLK_FREQ = 25_000_000;
    localparam BAUD = 115200;
    localparam BIT_T = CLK_FREQ / BAUD;

    localparam IDLE = 3'd0;
    localparam START = 3'd1;
    localparam DATA = 3'd2;
    localparam STOP = 3'd3;

    reg [2:0] state;
    reg [2:0] next_state;

    reg [15:0] baud_cnt;
    reg [3:0] data_cnt;

    wire baud_full = (baud_cnt == BIT_T - 16'd1);
    wire data_full = (data_cnt == 4'd7);

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
                if (tx_start) begin
                    next_state = START;
                end else begin
                    next_state = IDLE;
                end
            end

            START : begin
                if (baud_full) begin
                    next_state = DATA;
                end else begin
                    next_state = START;
                end
            end

            DATA : begin
                if (baud_full && data_full) begin
                    next_state = STOP;
                end else begin
                    next_state = DATA;
                end
            end

            STOP : begin
                if (baud_full) begin
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
            data_cnt <= 4'd0;
            baud_cnt <= 16'd0;
        end else begin
            case (state)
                START, STOP : begin
                    if (baud_full) begin
                        baud_cnt <= 16'd0;
                    end else begin
                        baud_cnt <= baud_cnt + 16'd1;
                    end
                end

                DATA : begin
                    if (baud_full && data_full) begin
                        baud_cnt <= 16'd0;
                        data_cnt <= 4'd0;
                    end else if (baud_full) begin
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
            tx_o <= 1'd0;
            busy_o <= 1'd0;
        end else begin
            case (state)
                IDLE : begin
                    tx_o <= 1'b1;
                    busy_o <= 1'b0;
                end

                START : begin
                    tx_o <= 1'b0;
                    busy_o <= 1'b0;
                end

                DATA : begin
                    busy_o <= 1'b1;
                    if (baud_full && data_full) begin
                        tx_o <= 1'b1;
                    end else if (baud_full) begin
                        tx_o <= tx_i[data_cnt];
                    end
                end

                STOP : begin
                    tx_o <= 1'b1;
                    busy_o <= 1'b0;
                end
            endcase
        end
    end
endmodule
