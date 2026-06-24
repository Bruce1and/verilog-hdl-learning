`timescale  1ns/1ns
module vending_machine_tb;

    //reg data_i;
    reg clk_i;
    reg rst_n;

    reg [3:0] coin_i;
    reg cancel_i;

    wire dispense_o;

    reg [3:0] sel_product;
    wire [3:0] change_o;
    wire [3:0] refund_o;
    wire [3:0] amount_o;

    localparam PRODUCT_PRICE = 4'd5;

    vending_machine u0_vending_machine(
        .clk_i(clk_i),
        .rst_n(rst_n),
        .coin_i(coin_i),
        .cancel_i(cancel_i),
        .sel_product(sel_product),
        .change_o(change_o),
        .refund_o(refund_o),
        .amount_o(amount_o)
    );

    initial begin
        clk_i = 1'b0;
        rst_n = 1'b1;

        #1 rst_n = 1'b0;
        #1 rst_n = 1'b1;

        coin_i = 4'd0;
        cancel_i = 1'd0;
        sel_product = 4'd1;

        #4 coin_i = 4'd0;
        #4 coin_i = 4'd0;
        #4 coin_i = 4'd0;
        #4 coin_i = 4'd0;
        #4 coin_i = 4'd1;
        #4 coin_i = 4'd0;
        #4 coin_i = 4'd2;
        #4 coin_i = 4'd0;
        #4 coin_i = 4'd1;
        #4 coin_i = 4'd0;

        
        #6 coin_i = 4'd1;
        #6 coin_i = 4'd0;
        #6 coin_i = 4'd1;
        #6 coin_i = 4'd0;


        #4 coin_i = 4'd1;
        #4 coin_i = 4'd0;

        #8 coin_i = 4'd1;
        #4 coin_i = 4'd0;

        #12 coin_i = 4'd1;
        #4 coin_i = 4'd0;

        #4 coin_i = 4'd1;
        #4 coin_i = 4'd0;
        #4 coin_i = 4'd1;
        #4 coin_i = 4'd0;


        #12 coin_i = 4'd5;
        #4 coin_i = 4'd0;

    end
    //每#4是一个时钟周期，#2是半个，所以要求优先考虑#4
    always begin
        #2  clk_i   =   ~clk_i;
    end

    always @(*) begin
        if (coin_i == 4'd5) begin
            cancel_i = 1'd1;
        end else begin
            cancel_i = 1'd0;
        end
    end

    initial begin
        $dumpfile("sim/wave/vending_machine_wave.vcd");
        $dumpvars(0,vending_machine_tb);
        #10000;
        $finish;
    end


endmodule
