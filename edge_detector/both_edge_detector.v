module	both_edge_detector (
    	
	input clk_i,
    	input din_i,
   	output pulse_o

);
    	reg din_dly;
    

    	always @(posedge clk_i) din_dly <= din_i;
    

    	assign pulse_o = din_i ^ din_dly;


endmodule
