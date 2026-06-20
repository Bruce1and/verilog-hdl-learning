`timescale 1ns / 1ps
module switch (
    input clk_i,
    input rst_n,
    input clk1_i,
    input slk,
    input [7:0] seg_code_last,
    input [3:0] an_last,
    input [3:0] btn,
    output reg [3:0] an,
    output reg [7:0] seg_code
);

    reg [3:0] btn1;
    reg state;
    reg din_dly;
    reg din_dly2_n;

    wire din_dly_n;
    wire sign;

    reg [3:0] cnt1;
    reg [3:0] cnt2;
    reg [3:0] cnt3;
    reg [3:0] cnt4;
    reg [3:0] add_up;
    reg [1:0] state1;

    always @(posedge clk_i or negedge rst_n) begin
        if (!rst_n) begin
            btn1 <= 4'b0;
        end else begin
            btn1 <= btn;
        end
    end

    always @(posedge clk_i) begin
        case (btn1)

            4'd8 : begin
                if (an_last == 4'd1 & seg_code_last != 8'b01101111)
                    state <= btn1[3];
            end

            4'd4 : begin
                if (an_last == 4'd2 & seg_code_last != 8'b01101111)
                    state <= btn1[2];
            end

            4'd2 : begin
                if (an_last == 4'd1 & seg_code_last != 8'b01101111)
                    state <= btn1[1];
            end

            4'd1 : begin
                if (an_last == 4'd1 & seg_code_last != 8'b01101111)
                    state <= btn1[0];
            end

            default : state <= 'd0;

        endcase
    end

    assign din_dly_n = ~din_dly;
    assign sign = din_dly2_n & din_dly;

    always @(posedge clk_i) begin
        din_dly <= state;
        din_dly2_n <= din_dly_n;
    end

    always @(posedge clk_i or negedge rst_n) begin
        if (!rst_n) begin
            cnt1 <= 4'b0;
            cnt2 <= 4'b0;
            cnt3 <= 4'b0;
            cnt4 <= 4'b0;
            count_flag <= 1'b0;
        end else if (btn == 4'd8) begin
            if (sign == 1'd1) begin
                count_flag <= 1'b1;
                if (cnt1 == 4'd9) begin
                    cnt1 <= 4'd0;
                end else begin
                    cnt1 <= cnt1 + 1'b1;
                end
            end
        end else if (btn == 4'd4) begin
            if (sign == 1'd1) begin
                count_flag <= 1'b1;
                if (cnt2 == 4'd9) begin
                    cnt2 <= 4'd0;
                end else begin
                    cnt2 <= cnt2 + 1'b1;
                end
            end
        end else if (btn == 4'd2) begin
            if (sign == 1'd1) begin
                count_flag <= 1'b1;
                if (cnt3 == 4'd9) begin
                    cnt3 <= 4'd0;
                end else begin
                    cnt3 <= cnt3 + 1'b1;
                end
            end
        end else if (btn == 4'd1) begin
            if (sign == 1'd1) begin
                count_flag <= 1'b1;
                if (cnt4 == 4'd9) begin
                    cnt4 <= 4'd0;
                end else begin
                    cnt4 <= cnt4 + 1'b1;
                end
            end
        end else if (seg_code_last == 8'b01101111) begin
            count_flag <= 1'b0;
        end
    end

    always @(posedge sclk or negedge rst_n) begin
        if (!rst_n) begin
            state1 <= 4'b0;
        end else if (state1 == 2'b11) begin
            state1 <= 4'b0;
        end else begin
            state1 <= state1 + 1'b1;
        end
    end

    always @(state1) begin
        case (state1)
            2'b00 : an = 4'b0001;
            2'b01 : an = 4'b0010;
            2'b10 : an = 4'b0100;
            2'b11 : an = 4'b1001;
        endcase
    end

    always @(an or cnt1 or cnt2 or cnt3 or cnt4) begin
        case (an)
            4'b0001 : add_up = cnt1;
            4'b0010 : add_up = cnt2;
            4'b0100 : add_up = cnt3;
            4'b1000 : add_up = cnt4;
        endcase
    end

    always @(posedge clk_i or negedge rst_n) begin
        if (!rst_n) begin
            seg_code <= 8'b11111111;
        end else begin
            case (add_up)
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
                default : seg_code <= 8'b00111111;
            endcase
        end
    end
endmodule









