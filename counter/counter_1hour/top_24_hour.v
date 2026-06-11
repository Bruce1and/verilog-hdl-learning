module	top_24_hour (
	
	input			clk_i,
	input			rst_n,
	output	reg	[3:0]	sec_ten,
	output	reg	[2:0]	sec_six,
	output	reg	[3:0]	min_ten,
	output	reg	[2:0]	min_six,
	output	reg	[2:0]	hour_fiv,
	output	reg	[1:0]	hour_two

);


	wire	rst_sync;
	wire	en_min;
	wire	en_hour;

	counter_mod_60_sec u_sec (
		.clk_i(clk_i),
		.rst_n(rst_n),
		.rst_sync(rst_sync),
		.en_min(en_min),
		.cnt_ten(sec_ten),
		.cnt_six(sec_six)
	
	);


	counter_mod_60_min u_min (
		.clk_i(clk_i),
		.rst_n(rst_n),
		.rst_sync(rst_sync),
		.en_min(en_min),
		.en_hour(en_hour),
		.cnt_ten(min_ten),
		.cnt_six(min_six)

	);

	counter_mod_24_hour u_hour (
		.clk_i(clk_i),
		.rst_n(rst_n),
		.rst_sync(rst_sync),
		.en_hourn(en_hour),
		.units(hour_fiv),
		.tens(hour_two)
	
	);

endmodule

