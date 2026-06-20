module light_ctrl (
    input clk_i,
    input rst_n,
    input Y1,
    input btn,
    input [5:0] count,
    output reg [2:0] light1,
    output reg [2:0] light2
);

    reg [2:0] state;
    reg [2:0] next_state;

    localparam S1_ROAD1_GREEN = 3'd1;
    localparam S2_ROAD1_YELLOW = 3'd2;
    localparam S3_ROAD2_GREEN = 3'd3;
    localparam S4_ROAD2_YELLOW = 3'd4;
    localparam S5_ALL_RED = 3'd5;

    localparam LIGHT_GREEN = 3'd1;
    localparam LIGHT_YELLOW = 3'd2;
    localparam LIGHT_RED = 3'd4;

    always @(posedge clk_i or negedge rst_n) begin
        if (!rst_n) begin
            state <= S5_ALL_RED;
        end else begin
            state <= next_state;
        end
    end

    always @(*) begin
        case (state)
            S1_ROAD1_GREEN : begin
                if (Y1) begin
                    next_state = S2_ROAD1_YELLOW;
                end else begin
                    next_state = S1_ROAD1_GREEN;
                end
            end

            S1_ROAD1_YELLOW : begin
                if (count == 6'd1) begin
                    next_state = S3_ROAD2_GREEN;
                end else begin
                    next_state = S1_ROAD1_YELLOW;
                end
            end

            S3_ROAD2_GREEN : begin
                if (Y1) begin
                    next_state = S4_ROAD2_YELLOW;
                end else begin
                    next_state = S3_ROAD2_GREEN;
                end
            end

            S4_ROAD2_YELLOW : begin
                if (count == 6'd1) begin
                    next_state = S1_ROAD1_GREEN;
                end else begin
                    next_state = S4_ROAD2_YELLOW;
                end
            end

            S5_ALL_RED : begin
                next_state = S1_ROAD1_GREEN;
            end

            default : next_state = S5_ALL_RED;
            
        endcase
    end

    always @(posedge clk_i or negedge rst_n) begin
        if (!rst_n) begin
            state <= 3'b0;
        end else if (btn == 1'b1) begin
            light1 <= 3'd4;
            light2 <= 3'd4;
        end else begin
            case (state)
                S1 : begin
                    light1 <= 3'd1;
                    light2 <= 3'd4;
                    if (Y1) begin
                        state <= S2;
                    end else begin
                        state <= S1;
                    end
                end


