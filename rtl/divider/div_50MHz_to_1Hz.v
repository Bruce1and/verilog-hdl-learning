module 	div_50MHz_to_1Hz (
	
	input			clk_i,
	input			rst_n,
	output	reg	[25:0]	cnt,
	output	reg		clk_o

);


	always	@( posedge clk_i or negedge rst_n )begin
		if(!rst_n)
			cnt <= 26'b0;
		else if(cnt ==  26'd49999999)
			cnt <= 26'b0;
		else
			cnt <= cnt + 26'b1;
	end


	always	@( posedge clk_i or negedge rst_n )begin
		if(!rst_n)
			clk_o <= 1'b0;
		else if(cnt < 26'd25000000)
			clk_o <= 1'b0;
		else
			clk_o <= 1'b1;
	end

endmodule
