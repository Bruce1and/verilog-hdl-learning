module div_100MHz_to_1Hz (
    input clk_i,
    input rst_n,
    output clk_o
);
    reg [26:0] cnt;

    always @(posedge clk_i or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 27'b0;
        end else if(cnt == 27'd99999999) begin
            cnt <= 27'b0;
        end else
            cnt <= cnt + 1'b1;
        end
    end

    always @(posedge clk_i or negedge rst_n) begin
        if (!rst_n) begin
            clk_o <= 1'b0;
        end else if(cnt < 27'd50000000) begin
            clk_o <= 1'b0;
        end else
            clk_o <= 1'b1;
        end
    end

endmodule
