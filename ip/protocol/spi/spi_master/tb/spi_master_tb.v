`timescale 1ns / 1ps

module spi_master_tb;
    reg clk_i;
    reg rst_n;
    reg start_i;
    reg miso_i;
    reg [7:0] tx_data_i;
    wire sclk_o;
    wire mosi_o;
    wire cs_n_o;
    wire busy_o;
    wire done_o;
    wire valid_o;
    wire [7:0] rx_data_o;

    spi_master u0_spi_master(
        .clk_i(clk_i),
        .rst_n(rst_n),
        .start_i(start_i),
        .miso_i(miso_i),
        .tx_data_i(tx_data_i),
        .sclk_o(sclk_o),
        .mosi_o(mosi_o),
        .cs_n_o(cs_n_o),
        .tx_busy_o(busy_o),
        .tx_done_o(done_o),
        .rx_valid_o(rx_valid_o),
        .rx_data_o(rx_data_o)
    );

    always #10 clk_i = ~clk_i;

    initial begin
        clk_i = 1'b0;
        rst_n = 1'b0;
        start_i = 1'b0;
        tx_data_i = 8'd0;

        #100 rst_n = 1'b1;

        #200

        start_i = 1'b1;

        @(posedge clk_i);
        tx_data_i = 8'h55;       // 先把数据放好
        start_i = 1;          // 给一个脉冲
        @(posedge clk_i);
        start_i = 0;
        wait(done_o == 1);
        #100;

        @(posedge clk_i);
        tx_data_i = 8'hAA;
        start_i = 1;
        @(posedge clk_i);
        start_i = 0;
        wait(done_o == 1);
        #100;

        // ---- 发送第三个字节：0xFF ----
        @(posedge clk_i);
        tx_data_i = 8'hFF;
        start_i = 1;
        @(posedge clk_i);
        start_i = 0;
        wait(done_o == 1);
        #200;

        #2000;
        $finish;
    end

    initial begin
        $dumpfile("sim/wave/spi_master_wave.vcd");
        $dumpvars(0, spi_master_tb);
    end

endmodule
