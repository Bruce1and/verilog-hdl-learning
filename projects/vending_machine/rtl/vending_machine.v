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

    localparam IDLE = 2'd0;
    localparam DISPENSE = 2'd1;
    localparam CANCEL = 2'd2;

    localparam AMOUNT_MAX = 4'd10;
    localparam PAY_TIME = 4'd3;

    reg pay_time_done;
    reg pay_time_done_dly;
    wire pay_time_rise;
    wire pay_time_fall;

    reg [3:0] pay_time_counter;
    reg [3:0] pay_time;
    reg [1:0] state;
    reg [1:0] next_state;

    reg [3:0] amount_o_dly;
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
            pay_time_counter <= 4'd0;
            pay_time_done <= 1'd0;
        end else if (!coin_i) begin
            if (pay_time_counter == PAY_TIME - 4'd1) begin
                pay_time_counter <= 4'd0;
                pay_time_done <= 1'd1;
            end else begin
                pay_time_counter <= pay_time_counter + 4'd1;
            end
        end else begin
            pay_time_counter <= 4'd0;
            pay_time_done <= 1'd0;
        end
    end



































    always @(posedge clk_i) begin
        pay_time_done_dly <= pay_time_done;
    end

    assign pay_time_rise = pay_time_done & ~pay_time_done_dly;
    assign pay_time_fall = ~pay_time_done & pay_time_done_dly;

    always @(posedge clk_i or negedge rst_n) begin
        if (!rst_n) begin
            amount_o <= 4'd0;
        end else if (!pay_time_done) begin
            if (coin_i) begin
                if (amount_o == AMOUNT_MAX) begin
                    amount_o <= amount_o;
                end else begin
                    amount_o <= amount_o + coin_i;
                end
            end
        end else begin
            amount_o <= coin_i;
        end
    end



    always @(posedge clk_i) begin
        amount_o_dly <= amount_o;
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
            dispense_o <= 1'd0;
            change_o <= 4'd0;
            refund_o <= 4'd0;
        end
    end

    always @(*) begin
        case (state)
            IDLE : begin
                if (pay_time_done) begin
                    dispense_o = 1'd0;
                    if (!cancel_i) begin
                        if (amount_o >= product_price) begin
                            next_state = DISPENSE;
                        end else begin
                            next_state = IDLE;
                        end
                    end else begin
                        next_state = CANCEL;
                    end
                end
            end

            DISPENSE : begin
                dispense_o = 1'd1;
                if (!cancel_i) begin
                    change_o = amount_o_dly - product_price;
                    next_state = IDLE;
                end else begin
                    next_state = CANCEL;
                end
            end

            CANCEL : begin
                dispense_o = 1'd0;
                refund_o = amount_o_dly;
                next_state = IDLE;
                amount_o = 4'd0;
            end

            default : begin
                next_state = IDLE;
            end
        endcase
    end
endmodule

