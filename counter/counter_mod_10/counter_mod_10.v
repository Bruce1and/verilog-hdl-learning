module	counter_mod_10	(

	input			clk_i,
	input			rst_n,
	output	reg	[3:0]	cnt

);


	always	@(posedge	clk_i	or	negedge	rst_n)begin
		if(!rst_n)
			cnt	<=	4'b0;
		else if(clk_i	==	1'b1)begin
			if(cnt	==	4'b9)
				cnt	<=	4'b0;
			else
				cnt	<=	4'b1	+	cnt;
		end
	end

endmodule
