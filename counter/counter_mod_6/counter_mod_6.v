module	counter_mod_6	(
	
	input			clk_i,
	input			rst_n,
	output	reg	[2:0]	cnt

);


	always 	@(posedge	clk_i	or	negedge	rst_n)begin
		if(rst_n	==	1'b0)
			cnt	<=	3'b0;
		else if(clk_i	==	1'b1)begin
			if(cnt	==	3'd5)
				cnt	<=	3'b0;
			else
				cnt	<=	cnt	+	1'b1;
		end
	end

endmodule
