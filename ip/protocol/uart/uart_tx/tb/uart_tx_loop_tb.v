`timescale 1ns/1ps

module uart_tx_tb;

    reg clk_i;
    reg rst_n;

    reg tx_o;
    reg [7:0] tx_i;

    reg tx_start;
    reg busy_o;

    uart_tx u0_uart_tx(
        .clk_i(clk_i),
        .rst_n(rst_n),
        .tx_start(tx_start),
        .tx_o(tx_o),
        .tx_i(tx_i),
        .busy_o(busy_o)
    );

    localparam CLK_FREQ = 25_000_000;
    localparam BAUD = 115200;
    localparam BIT_T = CLK_FREQ / BAUD;

    task send_byte;
        input [7:0] data;
        integer i;
        begin
            @(negedge rx_i);

            #HALF_BIT_TIME;

            #BIT_TIME;

            for (i = 0; i < 8; i = i + 1) begin
                data[i] = tx_o;
                #BIT_TIME;
            end

            #BIT_TIME;

        end

    endtask

    initial begin
        clk_i = 1'b0;
        rst_n = 1'b0;
        tx_i = 8'd0;
        tx_o = 1'b1;

        #100 rst_n = 1'b1;

        #200;
        send_and_check(8'h55, "Text 0x55");

        #2000;
        send_and_check(8'h55, "Text 0x55");

        #2000;
        send_and_check(8'h55, "Text 0x55");

        #2000;
        send_and_check(8'h55, "Text 0x55");

        #2000 $finish;
    end

    integer test_pass, test_fail;
    initial begin
        test_pass = 0;
        test_fail = 0;
    end

    task send_and_check;
        input [7:0] send_data;
        input [8*10:1] test_name;
        reg [7:0] recv_data;
        begin
            tx_i = send_data;
            tx_start = 1;

            #40;
            tx_start = 0;

            @(negedge busy_o);

            receive_btye(recv_data);

            if (recv_data == send_data) begin
                $display ("[%0t] %s: PASS (sent %h, received %h)", $time, test_name, send_data, recv_data);
                test_pass = test_pass + 1;
            end else begin
                $display ("[%0t] %s: FAIL (sent %h. recevied %h)", $time, test_name, send_data, recv_data);
                test_fail = test_fail + 1;
            end
        end
    endtask

    final begin
        $display("==================================");
        $display("Total PASS: %0d, FAIL: %0d", test_pass, test_fail);
    end

    initial begin
        $dumpfile("sim/wave/uart_tx_wave.vcd");
        $dumpvars(0, uart_tx_tb);
    end
endmodule

