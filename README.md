## VerilogHDL Beginning codes collection
### About
I am complete beginner when it comes to programming.This is just a record of my learning process with Verilog HDL.You can find the code you need in the table of contents.
### Start
Install Icarus Verilog:

windows

``winget install Icarus.Verilog``

debain

``sudo apt install iverilog gtkwave``

add these codes into your testbench file

``initial begin
    $dumpfile("wave.vcd");
    $dumpvars(0,testbench);
    #10000;
    $finish;
end``

run these commend in your shell

``iverilog -o output_file testbench.v you_module.v``

``vvp output_file``

``gtkwave wave.vcd``


### Testbench
This is a simple testbench file
````testbench
`timescale  1ns/1ps
module  module_name;
    
    reg     data_1;            
    reg     clk_i;
    reg     rst_n;
    wire    data_0;
        
    top u0(
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
    
endmodule

````
