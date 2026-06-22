module pwm_generation #(
    parameter BREATHE_TIME = 'd7 - 'd1
)(
    input clk_i,
    input rst_n,
    output reg led,
    output reg breathe_type,
    output reg [7:0]dout
);
    reg [7:0]cnt0;
    reg [7:0]cnt1;

    always@(posedge clk_i or negedge rst_n)begin
        if(!rst_n)
            cnt0 <= 'd0;
        else if(cnt0 == BREATHE_TIME)
            cnt0 <= 'd0;
        else
            cnt0 <= cnt0 + 'd1;
    end

    always@(posedge clk_i or negedge rst_n)begin
        if(!rst_n)
            cnt1 <= 'd0;
        else if(cnt0 == BREATHE_TIME)begin
            if(!breathe_type)
                cnt1 <= 'd1 + cnt1;
            else
                cnt1 <= cnt - 'd1;
    end

    always@(posedge clk_i or negedge rst_n)begin
        if(!rst_n)
            breathe_type <= 'd0;
        else if(cnt1 == BREATHE_TIME)
            breathe_type <= 'd1;
        else if(cnt1 == 'd0)
            breathe_type <= 'd0;
    end

    assign led = (cnt0 >= cnt1);

    always@(posedge clk_i or negedge rst_n)begin
        if(!rst_n)
            dout <= 'b0;
        else if(dout == 'd7)
            dout <= 'b0;
        else
            dout <= dout + 'b1;
    end


endmodule

