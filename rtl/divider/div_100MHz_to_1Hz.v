module	div_100MHz_to_1Hz (

	input		clk_i,
	input		rst_n,
	output		clk_o

);
	reg	[26:0]	cnt;	

	always	@( posedge clk_i or negedge rst_n )begin
		if(!rst_n)
			cnt <= 27'b0;
		else if(cnt == 27'd99999999)
			cnt <= 27'b0;
		else
			cnt <= cnt + 1'b1;
	end

	always	@(posedge clk_i or negedge rst_n)begin
		if(!rst_n)
			clk_o <= 1'b0;
		else if(cnt < 27'd50000000)
			clk_o <= 1'b0;
		else
			clk_o <= 1'b1;
	end

endmodule
