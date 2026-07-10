`timescale 1ns / 1ps

module uart_rx_tb;

    reg clk;
    reg rst_n;
    reg rx;
    wire [7:0] data;
    wire valid;

    // 例化你的 UART 接收器
    uart_rx uut (
        .clk_i(clk),
        .rst_n(rst_n),
        .rx_i(rx),
        .data_o(data),
        .valid_o(valid)
    );

    // 25MHz 时钟：周期 40ns（半周期 20ns）
    always #20 clk = ~clk;

    // UART 位时间：25MHz / 115200 ≈ 217 个时钟 = 8680 ns
    localparam BIT_TIME = 8680;

    // 主测试：一步一步发数据
    initial begin
        clk   = 0;
        rst_n = 0;
        rx    = 1;        // 空闲状态为高

        // 复位
        #100 rst_n = 1;

        // ===== 发送第 1 个字节：0x55 (01010101, LSB 先发) =====
        #200;
        rx = 0;  #BIT_TIME;    // 起始位
        rx = 1;  #BIT_TIME;    // bit0 (LSB)
        rx = 0;  #BIT_TIME;    // bit1
        rx = 1;  #BIT_TIME;    // bit2
        rx = 0;  #BIT_TIME;    // bit3
        rx = 1;  #BIT_TIME;    // bit4
        rx = 0;  #BIT_TIME;    // bit5
        rx = 1;  #BIT_TIME;    // bit6
        rx = 0;  #BIT_TIME;    // bit7 (MSB)
        rx = 1;  #BIT_TIME;    // 停止位

        // ===== 发送第 2 个字节：0xAA (10101010) =====
        #500;
        rx = 0;  #BIT_TIME;
        rx = 0;  #BIT_TIME;    // bit0 = 0
        rx = 1;  #BIT_TIME;
        rx = 0;  #BIT_TIME;
        rx = 1;  #BIT_TIME;
        rx = 0;  #BIT_TIME;
        rx = 1;  #BIT_TIME;
        rx = 0;  #BIT_TIME;
        rx = 1;  #BIT_TIME;    // bit7 = 1
        rx = 1;  #BIT_TIME;

        // 等一会儿看结果
        #2000;
        $finish;
    end

    // 接收完成时打印结果
    always @(posedge clk) begin
        if (valid)
            $display("Received: %h (binary %b)", data, data);
    end

    // 波形保存
    initial begin
        $dumpfile("sim/wave/uart_rx_wave.vcd");
        $dumpvars(0, uart_rx_tb);
    end

endmodule
