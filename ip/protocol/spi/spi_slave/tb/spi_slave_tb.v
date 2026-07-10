`timescale 1ns / 1ps

module spi_slave_tb;

    reg clk;
    reg rst_n;

    reg sclk;
    reg mosi;
    reg cs_n;

    reg tx_start;
    reg [7:0] tx_data;

    wire miso;
    wire tx_busy;
    wire tx_done;
    wire rx_valid;
    wire [7:0] rx_data;

    reg [7:0] send_data;
    reg [7:0] expected_data;
    integer test_pass, test_fail;

    spi_slave u_slave(
        .clk_i(clk),
        .rst_n(rst_n),
        .sclk_i(sclk),
        .mosi_i(mosi),
        .cs_n_i(cs_n),
        .tx_data_i(tx_data),
        .miso_o(miso),
        .tx_busy_o(tx_busy),
        .tx_done_o(tx_done),
        .rx_valid_o(rx_valid),
        .rx_data_o(rx_data)
    );

    always #10 clk = ~clk;

    task spi_send_byte;
        input [7:0] data;
        reg [7:0] shift_reg;
        integer i;

        begin
            shift_reg = data;

            cs_n = 1'b0;

            #20
            mosi = shift_reg[7];

            #20;

            for (i = 0; i < 8; i = i + 1) begin
                sclk = 1'b1; // 此处拉高sclk 从机检测到上升沿采样上面的mosi
                #20;
                sclk = 1'b0; // 此处拉低sclk 主机更新mosi
                shift_reg = shift_reg << 1;
                mosi = shift_reg[7];
                #20;
            end

            #20;
            cs_n = 1'b1;
            sclk = 1'b0;
            mosi = 1'b0;
        end
    endtask

    initial begin
        clk = 1'b0;
        rst_n = 1'b0;
        sclk = 1'b0;
        mosi = 1'b0;
        cs_n = 1'b1;
        tx_start = 1'b0;
        tx_data = 8'd0;
        send_data = 8'd0;
        test_pass = 0;
        test_fail = 0;

        #100 rst_n = 1'b1;

        #200;

        send_data = 8'h55;

        tx_data = 8'hAA;

        #20 tx_start = 0;

        #100;

        spi_send_byte(send_data);
        expected_data = send_data;
        if (rx_data == expected_data) begin
            $display("[%0t] Test 0x55: PASS (expected %h, got %h)", $time, expected_data, rx_data);
            test_pass = test_pass + 1;
        end else begin
            $display("[%0t] Test 0x55: FAIL (expected %h, got %h)", $time, expected_data, rx_data);
            test_fail = test_fail + 1;
        end

        #200;

        send_data = 8'hAA;

        tx_data = 8'h55;

        #20 tx_start = 0;

        #100;

        spi_send_byte(send_data);
        expected_data = send_data;
        if (rx_data == expected_data) begin
            $display("[%0t] Test 0x55: PASS (expected %h, got %h)", $time, expected_data, rx_data);
            test_pass = test_pass + 1;
        end else begin
            $display("[%0t] Test 0x55: FAIL (expected %h, got %h)", $time, expected_data, rx_data);
            test_fail = test_fail + 1;
        end

        #200;

        send_data = 8'hFF;

        tx_data = 8'hFF;

        #20 tx_start = 0;

        #100;

        spi_send_byte(send_data);
        expected_data = send_data;
        if (rx_data == expected_data) begin
            $display("[%0t] Test 0x55: PASS (expected %h, got %h)", $time, expected_data, rx_data);
            test_pass = test_pass + 1;
        end else begin
            $display("[%0t] Test 0x55: FAIL (expected %h, got %h)", $time, expected_data, rx_data);
            test_fail = test_fail + 1;
        end

        $display("==================================");
        $display("Total PASS: %0d, FAIL: %0d", test_pass, test_fail);
        #2000;
        $finish;
    end

    // ============ 波形文件生成 ============
    initial begin
        $dumpfile("sim/wave/spi_slave_tb.vcd");
        $dumpvars(0, spi_slave_tb);
    end

endmodule
