module decoder_assign (

	input	[2:0]	data_1,
	output	[7:0]	onehot_o

);


	assign	onehot_o = 8'b1	<< data_i;


endmodule
