module delay_line_3stage (
	
	input		clk_i,
	input		data_i,
	output	reg	data_0

);


	reg	[2:0]	shift;


	always @(posedge clk)
		shift	<=	{shift[1:0], data_i};
		data_o	<=	shift[2];
	end


endmodule

