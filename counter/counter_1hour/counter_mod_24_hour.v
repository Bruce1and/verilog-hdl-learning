module counter_mod_24_hour (
    	
	input		clk_i,
    	input        	rst_n,
	input		rst_sync,
	input		en_hour,
    	output reg [3:0]units,   // 个位 0~9
    	output reg [1:0]tens     // 十位 0~2

);
	always @(posedge clk_i or negedge rst_n) begin
    		if (!rst_n || rst_sync) begin
        		units <= 4'd0;
        		tens  <= 2'd0;
		end
	   	else if (tens == 2'd2 && units == 4'd3) begin  // 数值23
	   		units <= 4'd0;
	   		tens  <= 2'd0;
		end
		else if	(en_hour) begin
	   		if (units== 4'd9) begin
	   			units <= 4'd0;
	   			tens  <= tens + 1'b1;
			end
	   		else begin
	  			units <= units+ 1'b1;
   			end
		end
	end

endmodule
