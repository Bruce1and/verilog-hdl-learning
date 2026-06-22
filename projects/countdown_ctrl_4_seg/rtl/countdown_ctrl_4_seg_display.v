module show (
    input clk_i,
    input rst_n,
    input [3:0] state,
    input cnt_down_over,
    output reg [3:0] an,
    output cnt_start
);
    
    reg [3:0] pos;

    assign cnt_start = |state;

    always @(posedge clk_i or negedge rst_n) begin
        if(!rst_n) begin
            pos <= 4'b0;
            an <= 4'hf;
        end else begin
            case (pos)
                4'd0 : begin
                    an <= 4'hf;
                    pos <= state;
                end

                4'd1, 4'd2, 4'd4, 4'd8 : begin
                    if (cnt_down_over)begin
                        pos <= 4'd0;
                    end else begin
                        an <= pos;
                    end
                end

                default : pos <= 4'd0;
            endcase
        end
    end

endmodule




