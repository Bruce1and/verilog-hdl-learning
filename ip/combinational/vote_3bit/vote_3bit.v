module	vote_3bit (

	input	[1:0]	date0_i,
	input	[1:0]	date1_i,
	input	[1:0]	date2_i,
	output	reg	date_o
);


	always	@(*)begin
		if(a+b+c >= 2'd2)
			data_o = 1'b1;
		else
			data_o = 1'b0;
	end

//	always	@(*)begin 
//		data_o = (data1_i&data2_i)|(data1_i&data3_i)|(data3_i&data2_i)
//	end
	
//	assign	data_o = (data1_i+data2_i+data3_i >= 2'd2)? 1'b1 : 1'd0;

endmodule
