module	counter_mod_60_min (
	
	input			clk_i,
	input			rst_n,
	input			rst_sync,
	input			en_min,
	output			en_hour,
	output	reg	[3:0]	cnt_ten,
	output	reg	[2:0]	cnt_six
);
	

	reg	en_six;
	assign	en_hour=(cnt_ten==4'd9 && cnt_six==3'd5);


	always	@(posedge clk_i or negedge rst_n)begin
		if(!rst_n)
			cnt_ten <= 4'b0;
		else if(rst_sync)
			cnt_ten <= 4'b0;
		else if(en_min)begin
			if(cnt_ten == 4'd9)
				cnt_ten	<= 4'b0;
			else
				cnt_ten	<= 4'b1 + cnt_ten;
		end
	end
	
	
	always	@(posedge clk_i or negedge rst_n)begin
		if(!rst_n)
			en_six <= 1'b0;
		else if(rst_sync)
			en_six <= 1'b0;
		else
			en_six <= (cnt_ten== 4'd9);

	end


	always	@(posedge clk_i or negedge rst_n)begin
		if(!rst_n)
			cnt_six<=3'b0;
		else if(rst_sync)
			cnt_six<=3'b0;
		else if(en_six == 1'b1)begin
			if(cnt_six == 3'd5)
				cnt_six	<= 3'b0;
			else
				cnt_six	<= 3'b1 + cnt_six;
		end
	end


endmodule
