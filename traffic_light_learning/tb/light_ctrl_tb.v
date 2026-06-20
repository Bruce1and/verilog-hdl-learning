`timescale  1ns/1ps
module light_ctrl_tb;

    //reg data_i;
    reg clk_i;
    reg rst_n;
    wire [5:0] data_o;

    light_ctrl u0(
        .clk_i(clk_i),
        .rst_n(rst_n),
        .data_i(data_i),
        .data_0(data_0),
    );



    intial  begin
        clk_i       =   1'b0;
        rst_n       =   1'b1;
        #80 rst_n   =   1'b0;
        #20 rst_n   =   1'b1;
    end

    always  begin
        #5  clk_i   =   ~clk_i;
    end

    initial begin
        $dumpfile("light_ctrl_wave.vcd");
        $dumpvars(0,light_ctrl_tb);
        #1000;
        $finish;
    end


endmodule
