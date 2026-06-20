module	seven_seg_dynamic_driver (

	input			clk_i,
	input			rst_n,
	input		[3:0]	date_a_i,
	input		[3:0]	date_b_i,
	input		[3:0]	date_c_i,
	input		[3:0]	date_d_i,
	output	reg	[3:0]	scan_o,
	output	reg	[7:0]	seg_o

);

	
	reg	[1:0]	scan_state;
	reg	[3:0]	sel_date;

	always @(posedge clk_i or negedge rst_n)begin
		if(!rst_n)
			scan_state <= 2'b0;
		else if(scan_state == 2'b11)
			scan_state <= 2'b0;
		else
			scan_state <= scan_state + 2'b1;
	end


	always @(scan_state)begin
		case(scan_state)
			2'b00 : scan_o = 4'b0001;
			2'b01 : scan_o = 4'b0010;
			2'b10 : scan_o = 4'b0100;
			2'b11 : scan_o = 4'b1000;
		endcase
	end
		
	
	always @(scan_o)begin
		case(scan_o)
			4'b0001 : sel_date = date_a_i;
			4'b0010 : sel_date = date_b_i;
			4'b0100 : sel_date = date_c_i;
			4'b1000 : sel_date = date_d_i;
	
	always @(sel_date)begin
		case(sel_date)
			4'b0000 : seg_o = 8'b00111111;
			4'b0001 : seg_o = 8'b00000110;
			4'b0010 : seg_o = 8'b01011011;
			4'b0011 : seg_o = 8'b01001111;
			4'b0100 : seg_o = 8'b01100110;
			4'b0101 : seg_o = 8'b01101101;
			4'b0110 : seg_o = 8'b01111100;
			4'b0111 : seg_o = 8'b10000111;
			4'b1000 : seg_o = 8'b01111111;
			4'b1001 : seg_o = 8'b01100111;
			default : seg_o = 8'b00000000;
		endcase
	end

endmodule
