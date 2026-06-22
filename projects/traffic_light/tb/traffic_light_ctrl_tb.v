`timescale  1ns/1ps
module light_ctrl_tb;

    //reg data_i;
    reg clk_i;
    reg rst_n;
    wire yellow_o;
    wire green_o;
    wire red_o;
    wire time_done;
    wire sign_start;
    wire sign_cycle;

    light_ctrl u0 (
        .clk_i(clk_i),
        .rst_n(rst_n),
        .yellow_o(yellow_o),
        .green_o(green_o),
        .red_o(red_o),
        .time_done(time_done),
        .sign_start(sign_start),
        .sign_cycle(sign_cycle)
    );



    initial begin
        clk_i       =   1'b0;
        rst_n       =   1'b1;
        #80 rst_n   =   1'b0;
        #20 rst_n   =   1'b1;
    end

    always  begin
        #5  clk_i   =   ~clk_i;
    end

    initial begin
        $dumpfile("wave/light_ctrl_wave.vcd");
        $dumpvars(0,light_ctrl_tb);
        #10000;
        $finish;
    end


endmodule
