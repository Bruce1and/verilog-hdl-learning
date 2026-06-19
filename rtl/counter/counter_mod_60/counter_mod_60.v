module	counter_mod_60	(
	
	input			clk_i,
	input			rst_n,
	output	reg	[3:0]	cnt_ten,
	output	reg	[2:0]	cnt_six

);
	
	wire		en_six;



	always	@(posedge clk_i or negedge rst_n)begin
		if(!rst_n)
			cnt_ten <= 4'b0;
		else if(cnt_ten	== 4'd9)
			cnt_ten	<= 4'b0;
		else
			cnt_ten	<= 4'b1 + cnt_ten;
		
	end
	
	
	always	@(posedge clk_i or negedge rst_n)begin
		if(!rst_n)
			en_six <= 1'b0;
		else if(cnt_ten ==4'd9)
			en_six <= 1'b1;
		else
			en_six <= 1'b0;
	end


	always	@(posedge clk_i or negedge rst_n)begin
		if(!rst_n)
			cnt_six	<=3'b0;
		else if(en_six == 1'b1)begin
			if(cnt_six == 3'd5)
				cnt_six	<= 3'b0;
			else
				cnt_six	<= 3'b1 + cnt_six;
		end
	end


endmodule
