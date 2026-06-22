`timescale  1ns/1ns
module traffic_ctrl_top_tb;

    //reg data_i;
    reg clk_i;
    reg rst_n;

    wire [5:0] countdown1_o;
    wire [5:0] countdown2_o;

    traffic_ctrl_top u0 (
        .clk_i(clk_i),
        .rst_n(rst_n),
        .countdown1_o(countdown1_o),
        .countdown2_o(countdown2_o)
    );



    initial begin
        clk_i       =   1'b0;
        rst_n       =   1'b1;
        #1 rst_n = 1'b0;
        #1 rst_n = 1'b1;
    end

    always  begin
        #5  clk_i   =   ~clk_i;
    end

    initial begin
        $dumpfile("wave/traffic_ctrl_top_wave.vcd");
        $dumpvars(0,traffic_ctrl_top_tb);
        #10000;
        $finish;
    end


endmodule
