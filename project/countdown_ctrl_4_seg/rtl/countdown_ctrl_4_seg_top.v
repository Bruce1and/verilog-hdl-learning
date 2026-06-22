module countdown_4_control_top (
    input clk;
    input rst;
    input [3:0] btn_pin;
    input [3:0] sw_pin;
    output [3:0] seg_cs_pin;
    output [7:0] seg_data_0_pin;
    output [3:0] an;
    output [7:0] seg_data_1_pin
);

    wire [3:0]state;
    wire cnt_down_over;
    wire cnt_start;

    push u0(
        .clk(clk),
        .rst(rst),
        .btn(btn_pin),
        .state(state)
    );

    cnt_down u1(
        .clk(clk),
        .rst(rst),
        .cnt_start(cnt_start),
        .seg_code(seg_data_0_pin),
        .cnt_down_over(cnt_down_over)
    );

    show u2(.clk(clk),
        .rst(rst),
        .state(state),
        .cnt_down_over(cnt_down_over),
        .an(seg_cs_pin),
        .cnt_start(cnt_start)
    );

    wire sclk;
    wire clk1;
    wire [3:0]switch;

    divide_100MHz u3(
        .clk(clk),
        .scan(sclk),
        .reset(rst),
        .clk1(clk1)
    );

    switch u4(
        .clk(clk),
        .clk1(clk1),
        .sclk(sclk),
        .rstn(rst),
        .btn(sw_pin),
        .an(an),
        .an_last(seg_cs_pin),
        .seg_code(seg_data_1_pin),
        .seg_code_last(seg_data_0_pin)
    );

endmodule
