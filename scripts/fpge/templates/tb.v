/*
testbench: {{module_name}}_tb
Module under test: 
Description: 

Author: 
Date: {{today}}
Version: 

Updata history:

*/

`timescale 1ns / 1ps
module {{module_name}}_tb;
    reg clk;
    reg rst_n;

    {{module_name}} u_{{module_name}}(
        .clk_i(clk),
        .rst_n(rst_n)
    );

    always #10 clk = ~clk;

    initial begin
        clk = 0;
        rst_n = 0;

        #100 rst_n = 1;

        #20;
        #100;
        $finish;
    end

    initial begin
        $dumpfile("sim/wave/{{module_name}}_tb.vcd");
        $dumpvars(0, {{module_name}}_tb);
    end

endmodule
