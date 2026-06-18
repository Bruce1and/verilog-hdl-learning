module led_breathe_top (
    input clK_i,
    input rst_n,
    output [7:0]led
);
    wire pwm;
    wire flag;

    pwm u_pwm(
        .clk_i(clk_i),
        .rst_n(rst_n),
        .flag(flag)
    );

    led u_led(
        .clk_i(clk_i),
        .rst_n(rst_n),
        .pwm(pwm),
        .flag(flag),
        .led(led)
    );

endmodule
