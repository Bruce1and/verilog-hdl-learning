module light_ctrl (
    input clk_i,
    input rst_n,
    input green_start,
    output reg [1:0] state,
    output reg [5:0] RED,
    output reg [5:0] GREEN,
    output reg [5:0] YELLOW
);

    localparam RED = 2'd0;
    localparam GREEN = 2'd1;
    localparam YELLOW = 2'd2;

    localparam TIME_RED = 6'd50;
    localparam TIME_GREEN = 6'd45;
    localparam TIME_YELLOW = 6'd5;

    reg nearly_done;
    reg [1:0] next_state;
    reg [6:0] count_public;

    always @(posedge clk_i or negedge rst_n) begin
        if (!rst_n) begin
            state <= RED;
        end else begin
            state <= next_state;
        end
    end

    always @(posedge clk_i or negedge rst_n) begin
        if (!rst_n) begin
            count_public <= 7'd0;
        end else if (count_public == TIME_RED + TIME_GREEN + TIME_YELLOW) begin
            count_public <= count_public + 7'b1;
        end
    end

    always @(*) begin
        case (state)
            RED : begin
                if (green_start) begin
                    next_state = (count_public == TIME_RED) ? GREEN : RED;
            end

            GREEN : begin
                next_state = (count_public == TIME_RED + TIME_GREEN) ? YELLOW : GREEN;
            end

            YELLOW : begin
                next_state = (count_public == TIME_RED + TIME_GREEN + TIME_YELLOW) ? RED : YELLOW;
            end

            default: next_state = RED;

        endcase
    end

endmodule



