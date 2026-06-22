module traffic_ctrl_top (
    input clk_i,
    input rst_n,
    output [5:0] countdown1_o,
    output [5:0] countdown2_o
);

    wire timer_done1;
    wire timer_done2;
    wire [1:0] state1;
    wire [1:0] state2;

    wire call_b;
    wire call_a;

    wire cold_start = rst_n & ~rst_n_dly;
    reg rst_n_dly = 1'b0;

    always @(posedge clk_i) begin
            rst_n_dly <= rst_n;
    end

    wire start_a = cold_start | call_a;
    wire start_b = call_b;

    light_ctrl u0_light_ctrl(
        .clk_i(clk_i),
        .rst_n(rst_n),
        .timer_done(timer_done1),
        .sign_start(start_a),
        .sign_cycle(call_b),
        .state(state1)
    );

    light_ctrl u1_light_ctrl(
        .clk_i(clk_i),
        .rst_n(rst_n),
        .timer_done(timer_done2),
        .sign_start(start_b),
        .sign_cycle(call_a),
        .state(state2)
    );

    light_counter u2_light_counter(
        .clk_i(clk_i),
        .rst_n(rst_n),
        .state(state1),
        .timer_done(timer_done1),
        .countdown(countdown1_o)
    );

    light_counter u3_light_counter(
        .clk_i(clk_i),
        .rst_n(rst_n),
        .state(state2),
        .timer_done(timer_done2),
        .countdown(countdown2_o)
    );

endmodule
