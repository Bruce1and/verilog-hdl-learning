module negedge_detector (
    
	input 		clk, 
    	input		din,
    	output 		dout
);
   	
	reg din_dly;
    	
	always @(posedge clk) din_dly <= din;
    	assign dout = ~din & din_dly;  


endmodule
