module vivado (
    input         clk_i,
    input         rst_,
    output [15:0] r_data;
);
    reg [8:0]  r_addr;
    reg [8:0]  w_addr;
    reg [15:0] w_date;
    reg        wea;

    always@(posedge clk_i or negedge rst_n) begin
        if(!rst_n)
            r_addr <= 9'b0;
        else if(|w_addr)
            r_addr <= r_addr + 1'b1;
        else
            r_addr <= 9'b0;
    end

    always@(posedge clk_i or negedge rst_n) begin
        if(!rst_n)
            wea <= 1'b0;
        else begin
            if(&w_addr)
                wea <= 1'b0;
            else
                wea <= 1'b1;
        end
    end

    always@(posedge clk_i or negedge rst_n) begin
        if(!rst_n) begin
            w_addr <= 9'b0;
            w_data <= 16'b0;
        end else begin
            if(wea == 1'b1) begin
                if(&w_addr) begin
                    w_addr <= w_addr;
                    w_data <= w_data;
                end else begin
                    w_addr <= w_addr + 16'b1;
                    w_date <= w_data + 16'b1;
                end
            end
        end
    end

    ram_ip ram_ip_inst(
        .clka(clk_i),
        .clkb(clk_i),
        .wea(wea),
        .addra(w_addra),
        .addrb(r_addra),
        .dina(w_data),
        .doutb(r_data)
    );

endmodule

