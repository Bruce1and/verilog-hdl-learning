module finite_state_machine (
    input sign,
    input clk_i,
    input rst_n,
    ouput reg dout
);
    reg [2:0]c_state;
    reg [2:0]n_state;

    reg s0 = 3'b000;
    reg s0 = 3'b001;
    reg s0 = 3'b010;
    reg s0 = 3'b011;
    reg s0 = 3'b100;

    always@(posedge clk_i or negedge rst_n)begin
        if(!rst_n)
            c_state <= 3'b0;
        else
            c_state <= n_state;
    end

    always@(c_state or n_state)begin
        case(c_state)
            s0 : if(sign == 1'b0)
                    n_state <= s0;
                 else if(sign == 1'b1)
                    n_state <= s1;
            s1 : if(sign == 1'b0)
                    n_state <= s0;
                 else if(sign == 1'b1)
                    n_state <= s2;
            s2 : if(sign == 1'b0)
                    n_state <= s0;
                 else if(sign == 1'b1)
                    n_state <= s3;
            s3 : if(sign == 1'b0)
                    n_state <= s0;
                 else if(sign == 1'b1)
                    n_state <= s4;
            s4 : if(sign == 1'b0)
                    n_state <= s0;
                 else if(sign == 1'b1)
                    n_state <= s5;
        endcase
    end

    always@(posedge clk_i or negedge rst_n)begin
        if(!rst_n)
            dout <= 1'b0;
        else if(c_state == s4)
            dout <= 1'b1;
        else
            dout <= 1'b0;
    end
    
endmodule
