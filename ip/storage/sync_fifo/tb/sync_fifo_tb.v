`timescale 1ns / 1ps

module sync_fifo_tb;
    reg clk;
    reg rst_n;

    reg wr_en;
    reg [DATA_WIDTH - 1 : 0]wr_data;

    reg rd_en;
    wire [DATA_WIDTH - 1 : 0]rd_data;

    wire empty;
    wire full;

    parameter DATA_WIDTH = 8;
    parameter FIFO_DEPTH = 16;

    localparam ADDR_WIDTH = $clog2(FIFO_DEPTH);
    localparam CNT_WIDTH = $clog2(FIFO_DEPTH + 1);

    sync_fifo u_fifo(
        .clk_i(clk),
        .rst_n(rst_n),
        .wr_en_i(wr_en),
        .wr_data_i(wr_data),
        .rd_en_i(rd_en),
        .rd_data_o(rd_data),
        .empty_o(empty),
        .full_o(full)
    );

    always #10 clk = ~clk;


    // 由于fifo的采样是posedge clk_i, 所以让negedge clk作为输入
    task fifo_write;
        input [DATA_WIDTH - 1 : 0]data;
        begin
            @(negedge clk) begin
                wr_data <= data;
                wr_en <= 1;
            end

            @(negedge clk) begin
                wr_en <= 0;
            end
        end
    endtask

    task fifo_read;
        begin
            @(negedge clk)
            rd_en <= 1;

            @(posedge clk)
            $display("read = %h", rd_data);

            @(negedge clk)
            rd_en <= 0;
        end
    endtask

    initial begin
        clk = 0;
        rst_n = 0;
        wr_en = 0;
        wr_data = 0;
        rd_en = 0;

        #100 rst_n = 1;

        #20;

        // write only
        repeat(16) fifo_write($random);
        #20;

        // read only
        repeat(16) fifo_read;
        #20;

        // concurrent read and write
        // when empty
        fork
            fifo_write($random);
            fifo_read;
        join
        #20

        // when full
        repeat(16) fifo_write($random);
        fork
            fifo_read;
            fifo_write($random);
        join


        #100;

        $finish;
    end

    initial begin
        $dumpfile("sim/wave/sync_fifo_tb.vcd");
        $dumpvars(0, sync_fifo_tb);
    end

endmodule
