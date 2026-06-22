module light_ctrl (
    input clk_i,
    input rst_n,
    input timer_done,
    input sign_start,
    output reg sign_cycle,
    output reg [1:0] state
);

    localparam RED = 2'd0;
    localparam GREEN = 2'd1;
    localparam YELLOW = 2'd2;

    reg nearly_done;
    reg [1:0] next_state;

    always @(posedge clk_i or negedge rst_n) begin
        if (!rst_n) begin
            state <= RED;
        end else begin
            state <= next_state;
        end
    end

    always @(*) begin
        next_state = state;
        sign_cycle = 1'd0;

        case (state)
            RED : begin
                if (sign_start) begin
                    next_state = GREEN;
                end
            end

            GREEN : begin
                if (timer_done) begin
                    next_state = YELLOW;
                end
            end

            YELLOW : begin
                if (timer_done) begin
                    next_state = RED;
                    sign_cycle = 1'b1;
                end
            end
        endcase
    end

endmodule



