module light_counter (
    input clk_i,
    input rst_n,
    input [1:0] state,
    output reg timer_done,
    output reg [5:0] countdown
);

    reg [5:0] target_time;

    localparam TIME_RED = 6'd49;
    localparam TIME_GREEN = 6'd44;
    localparam TIME_YELLOW = 6'd5;

    always @(*) begin
        case (state)
            2'd0 : target_time = TIME_RED;
            2'd1 : target_time = TIME_GREEN;
            2'd2 : target_time = TIME_YELLOW;
            default : target_time = TIME_RED;
        endcase
    end

    always @(posedge clk_i or negedge rst_n) begin
        if (!rst_n) begin
            countdown <= 6'd0;
            timer_done <= 1'd0;
        end else begin
            if (countdown == 6'd0) begin
                timer_done <= 1'd1;
                countdown <= target_time;
            end else begin
                timer_done <= 1'd0;
                countdown <= countdown - 1'b1;
            end
        end
    end

endmodule


