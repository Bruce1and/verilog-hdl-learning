`timescale 1ns / 1ps

module uart_tx_tb;

    reg clk;
    reg rst_n;
    reg [7:0] data_in;
    reg tx_start;
    wire tx_o;
    wire busy_o;

    // 例化你的发送器（参数必须和你的 RTL 一致）
    uart_tx u_tx(
        .clk_i(clk),
        .rst_n(rst_n),
        .tx_i(data_in),
        .tx_start(tx_start),
        .tx_o(tx_o),
        .busy_o(busy_o)
    );

    // 25MHz 时钟：周期 40ns，半周期 20ns
    always #20 clk = ~clk;

    initial begin
        // 初始化
        clk = 0;
        rst_n = 0;
        data_in = 8'd0;
        tx_start = 0;

        // 复位释放
        #100 rst_n = 1;

        // 等待稳定后，发送 0x55
        #200;
        data_in = 8'h55;    // 要发送的数据
        tx_start = 1;       // 拉高启动脉冲
        #40;                // 保持一个时钟周期
        tx_start = 0;       // 撤销启动脉冲

        // 等足够长时间，让发送完成，波形被记录
        #200000;
        $finish;
    end

    // 生成波形文件
    initial begin
        $dumpfile("sim/wave/uart_tx_wave.vcd");
        $dumpvars(0, uart_tx_tb);
    end

endmodule
