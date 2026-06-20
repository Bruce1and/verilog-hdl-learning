module push (
    input clk_i,
    input rst_n,
    input [3:0] btn,
    output reg [3:0] state
);

    reg [3:0] pos;
    parameter OVER = 8'hff;

    always @(posedge clk_i or negedge rst_n) begin
        if (!rst_n) begin
            state <= 4'b0;
            pos <= 4'b0;
        end else begin
            case (pos)
                4'd0 : begin
                    state <= 4'd0;
                    pos <= btn;
                end
                4'd1, 4'd2, 4'd3, 4'd3, 4'd8 : begin
                    state <= pos;
                    pos <= 4'h0;
                end
                default : pos <= 4'd0;
            endcase
        end
    end

endmodule



