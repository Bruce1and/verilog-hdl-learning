module countdown (
    input clk_i,
    input rst_n,
    input cnt_start,
    input reg [7:0] seg_code,
    output cnt_down_over
);

    parameter T1S = 27'd100000000;
    reg [26:0] cnt;
    reg cnt_sig;
    reg [3:0] cnt_down;

    always@(posedge clk_n or negedge rst_n)begin
        if(!rst_n)
            cnt <= 27'd0;
        else if(cnt == T1S)
            cnt <= 27'd0;
        else if(cnt_sig == 1'b1)
            cnt <= cnt + 1'b1;
        else
            cnt <= 27'b0;
    end

    always@(posedge clk_i or negedge rst_n)begin
        if(!rst_n)begin
            cnt_down <= 4'd9;
            cnt_sig <= 1'b0;
        end else if (cnt_start && !cnt_sig)begin
            cnt_sig <= 1'b1;
        end else if (cnt_down == 4'hf)begin
            cnt_down <= 4'd9;
            cnt_sig <= 1'b0;
        end else if (cnt == T1S)begin
            cnt_down <= cnt_down - 1'b1;
        end else begin
        end
    end

        always @ ( posedge clk_i or negedge rst_n)begin
            if(!rst_n)begin
                seg_code <= 8'b11111111;
            end else begin
                case(cnt_down)
                    4'd0 : seg_code <= 8'b00111111;
                    4'd1 : seg_code <= 8'b00000110;
                    4'd2 : seg_code <= 8'b01011011;
                    4'd3 : seg_code <= 8'b01001111;
                    4'd4 : seg_code <= 8'b01100110;
                    4'd5 : seg_code <= 8'b01101101;
                    4'd6 : seg_code <= 8'b01111101;
                    4'd7 : seg_code <= 8'b00000111;
                    4'd8 : seg_code <= 8'b01111111;
                    4'd9 : seg_code <= 8'b01101111;
                    default: seg_code <= 8'b11111111;
                endcase
            end
        end

        assign cnt_down_over = &seg_code;

endmodule
