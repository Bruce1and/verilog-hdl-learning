module vending_machine (
    input clk_i,
    input rst_n,
    input cancel_i,
    input [3:0] coin_i,
    input [3:0] sel_product,
    output reg dispense_o,
    output reg [3:0] change_o,
    output reg [3:0] refund_o,
    output reg [3:0] amount_o
);

    // define state
    localparam IDLE = 2'd0;
    localparam DISPENSE = 2'd1;
    localparam CANCEL = 2'd2;

    // 
    localparam AMOUNT_MAX = 4'd10;
    localparam PAY_TIME = 4'd3;

    reg pay_time_done;
    reg [3:0] pay_time_cnt;

    reg [1:0] state;
    reg [1:0] next_state;

    reg [3:0] amount_cnt;
    reg [3:0] product_price;

    always @(*) begin
        case (sel_product)
            4'b0001 : product_price = 4'd5;
            4'b0010 : product_price = 4'd4;
            4'b0100 : product_price = 4'd2;
            default : product_price = 4'd5;
        endcase
    end

    always @(posedge clk_i or negedge rst_n) begin
        if (!rst_n) begin
            pay_time_cnt <= 4'd0;
            pay_time_done <= 1'd0;
        end else if (!coin_i) begin
            if (pay_time_cnt == PAY_TIME - 4'd1) begin
                pay_time_cnt <= 4'd0;
                pay_time_done <= 1'd1;
            end else begin
                pay_time_cnt <= pay_time_cnt + 4'd1;
            end
        end else begin
            pay_time_cnt <= 4'd0;
            pay_time_done <= 1'd0;
        end
    end

    always @(posedge clk_i or negedge rst_n) begin
        if (!rst_n) begin
            amount_cnt <= 4'd0;
        end else if (!pay_time_done) begin
            if (coin_i) begin
                if (amount_cnt == AMOUNT_MAX) begin
                    amount_cnt <= amount_cnt;
                end else begin
                    amount_cnt <= amount_cnt + coin_i;
                end
            end
        end else begin
            amount_cnt <= coin_i;
        end
    end

    always @(posedge clk_i) begin
        amount_o <= amount_cnt;
    end

    always @(posedge clk_i or negedge rst_n) begin
        if (!rst_n) begin
            dispense_o <= 1'd0;
            change_o <= 4'd0;
        end else if (pay_time_done && amount_cnt >= product_price) begin
            dispense_o <= 1'd1;
            change_o <= amount_cnt - product_price;
        end else begin
            dispense_o <= 1'd0;
            change_o <= 4'd0;
        end
    end

    always @(posedge clk_i or negedge rst_n) begin
        if (!rst_n) begin
            state <= 1'b0;
        end else begin
            state <= next_state;
        end
    end

    always @(posedge clk_i or negedge rst_n) begin
        if (!rst_n) begin
            refund_o <= 4'd0;
            next_state <= IDLE;
        end else begin
            case (next_state)
                IDLE : begin
                    refund_o <= 4'd0;
                    if (!cancel_i) begin
                        if (amount_cnt >= product_price && pay_time_done) begin
                            next_state <= DISPENSE;
                        end else if (amount_cnt && pay_time_done) begin
                            next_state <= CANCEL;
                        end else begin
                            next_state <= IDLE;
                        end
                    end else begin
                        next_state <= CANCEL;
                    end
                end

                DISPENSE : begin
                    if (!cancel_i) begin
                        next_state <= IDLE;
                    end else begin
                        next_state <= CANCEL;
                    end
                end

                CANCEL : begin
                    amount_o <= 1'd0;
                    refund_o <= amount_cnt;
                    next_state <= IDLE;
                end

                default : begin
                    next_state <= IDLE;
                end
            endcase
        end
    end
endmodule

