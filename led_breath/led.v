module led (
    input clk_i,
    input rst_n,
    input flag,
    input pwm,
    output reg [7:0] led
);

    reg [3:0] cnt;
    reg pwm_r;
    wire top_wire;

    always @(posedge clk_i or negedge rst_n)begin
        if(!rst_n)
            pwm_r <= 1'b0;
        else
            pwm_r <= flag;
    end

    assign top_flag = (flag != pwm_r) ? 1'b1 : 1'b0;

    always @(posedge clk_i or negedge rst_n)begin
        if(!rst_n)
            cnt <= 4'b0;
        else if(top_flag == 1'b1)
            cnt <= cnt + 1'b1;
    end

    always @(posedge clk_i or negedge rst_n)begin
        if(!rst_n)
            led <= 8'b00000000;
        else
            case(cnt)
                4'd0,4'd1 : led <= {7'b0000000,pwm};
                4'd2,4'd3 : led <= {6'b000000,pwm,1'b0};
                4'd4,4'd5 : led <= {5'b00000,pwm,2'b00};
                4'd6,4'd7 : led <= {4'b0000,pwm,3'b000};
                4'd8,4'd9 : led <= {3'b000,pwm,4'b0000};
                4'd10,4'd11 : led <= {2'b00,pwm,5'b00000};
                4'd12,4'd13 : led <= {1'b0,pwm,6'b000000};
                4'd14,4'd15 : led <= {pwm,7'b0000000};
            endcase
    end

endmodule
