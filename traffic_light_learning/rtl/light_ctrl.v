module light_ctrl (
    input clk_i,
    input rst_n,
    output [5:0] light_o
);

    localparam S1_RED = 3'd0;
    localparam S2_GREEN = 3'd1;
    localparam S3_YELLOW = 3'd2;

    reg [2:0] state;
    reg [2:0] next_state;
    reg [6:0] count_public;

    always @(posedge clk_i or negedge rst_n) begin
        if (!rst_n) begin
            state <= S1_RED;
        end else begin
            state <= next_state;
        end
    end

    always @(posedge clk_i or negedge rst_n) begin
        if (!rst_n) begin
            count_public <= 7'd0;
        end else if (count_public == 7'd99) begin
            count_public <= 7'd0;
        end else begin
            count_public <= count_public + 7'b1;
        end
    end

    assign next_state = (count_public == 7'b49) ? S2_GREEN : S1_RED;
    assign next_state = (count_public == 7'b94) ? S3_YELLOW : S2_GREEN;
    assign next_state = (count_public == 7'b99) ? S1_RED : S3_YELLOW;

    always @(posedge clk_i or negedge rst_n) begin
        if (!rst_n) begin
            light_o <= 6'd0;
        end else if (light_o == 6'd0) begin
            case (state)
                S1_RED : light_o <= 6'd49;
                S2_GREEN : light_o <= 6'd44;
                S3_YELLOW : light_o <= 6'd4;
                default : light_o <= 6'd49;
            endcase
        end else begin
            light_o <= light_o - 6'd1;
        end
    end

endmodule



