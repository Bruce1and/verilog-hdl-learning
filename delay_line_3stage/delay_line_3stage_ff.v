module	delay_line_3stage_ff (

	input		clk_i,
	input		data_i,
	output	reg	data_o

);


	reg	stage1,stage2;


	always	@(posedge clk_i) begin
		stage1 <= data_i;
		stage2 <= stage1;
		data_o <= stage2;
	end


endmodule
