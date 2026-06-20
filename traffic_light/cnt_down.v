module cnt_down_traffic (
    input clk_i,
    input rst_n,
    input btn,
    output reg [5:0] count1,
    output reg [5:0] count2,
    output reg Y1
);

    localparam RED = 2'd0;
    localparam GREEN = 2'd1;
    localparam YELLOW = 2'd2;

    reg [1:0] state;
    reg [1:0] next_state;
    reg [5:0] timer;

    always @(posedge clk_i or negedge rst_n) begin
        if (!rst_n) begin
            state <= RED;
        end else begin
            state <= next_state;
        end
    end

    always @(posedge clk_i or negedge rst_n) begin
        if (!rst_n) begin
            timer <= 6'd49;
        end else if (timer == 6'd0) begin
            case (next_state)
                RED : timer <= 6'd49;
                GREEN : timer <= 6'd44;
                YELLOW : timer <= 6'd4;
                default : timer <= 6'd49;
            endcase
        end else begin
            timer <= timer - 1'b1;
        end
    end

    wire time_end = (timer == 6'd0);

    always @(*) begin
        case (state)
            RED : next_state = time_end ? GREEN : RED;
            GREEN : next_state = time_end ? YELLOW : GREEN;
            YELLOW : next_state = time_end ? REG : YELLOW;
            default : next_state = RED;
        endcase
    end

    always @(posedge clk_i or negedge rst_n) begin
        if (!rst_n) begin
            count1 <= 6'd0;
        end else if (count1 == 6'b0) begin
            count1 <= timer + 6'b1;
        end else begin
            count1 <= 6'd0;
        end
    end

    always @(posedge clk_i or negedge rst_n) begin
        if (!rst_n) begin
            count2 <= 6'd0;
        end else if (state == GREEN) begin
            count2 <= timer + 6'd1;
        end else if (state == YELLOW) begin
            count2 <= timer + 6'd1;
        end else begin
            count2 <= 6'd0;
        end
    end

    always @(posedge clk_i or negedge rst_n) begin
        if (!rst_n) begin
            Y1 <= 1'b0;
        end else if(state == RED && count1 >= 6'd4 && count1 <= 6'd8) begin
            Y1 <= 1'b1;
        end else begin
            Y1 <= 1'b0;
        end
    end

endmodule


