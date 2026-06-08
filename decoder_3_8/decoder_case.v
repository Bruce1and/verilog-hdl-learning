module	decoder_case(
	
	input		[2:0]date_i,
	output	reg	[7:0]onehot_o

);


always@(*)
begin
	case(date_i)
		3'b000:	onehot_o	=	8'b00000001;
		3'b001:	onehot_o	=	8'b00000010;
		3'b010: onehot_o	=	8'b00000100;
		3'b011: onehot_o	=	8'b00001000;
		3'b100:	onehot_o	=	8'b00010000;
		3'b101: onehot_o	=	8'b00100000;
		3'b110: onehot_o	=	8'b01000000;
		3'b111: onehot_o	=	8'b10000000;
	endcase
end


endmodule
