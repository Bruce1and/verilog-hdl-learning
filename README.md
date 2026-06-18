# VerilogHDL Beginning codes
## About
This is a simple IP database of mine, which I will continue to update in the future.
## Start
### Install
Install iverilog using a package manager  
Windows  
``winget install Icarus.Verilog``  
Debain  
``sudo apt install iverilog gtkwave``  
Add these codes to your testbench file  
````
initial begin
    $dumpfile("wave.vcd");
    $dumpvars(0,testbench);
    #10000;
    $finish;
end
````
run these commend in your shell  

``iverilog -o output_file testbench.v you_module.v``

``vvp output_file``

``gtkwave wave.vcd``

## Testing
### Testbench
This is a simple testbench file
````testbench
`timescale  1ns/1ps
module  testbensh;
    
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
