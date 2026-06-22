module	mux_4_1_case (

	input		data0_i;
	input		data1_i;
	input		data2_i;
	input		data3_i;
	input	[1:0]	sel_i;
	output	reg	data_o;

);


	always @(*) begin
		case(sel_i)
			2'b00 : data_o = data0_i;
			2'b01 : data_o = data1_i;
			2'b10 : data_o = data2_i;
			2'b11 : data_o = data3_i;
		endcase
	end


endmodule
