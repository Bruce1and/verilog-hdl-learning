module	pwm	(
		
		input		clk_i,
		input		rst_n,
		output		pwm,
		output		flag
		
);
	

		reg	[6:0]	cnt_2us;
		reg	[9:0]	cnt_2ms;
		reg	[9:0]	cnt_2s;


		parameter	cnt_2us_max	= 99;
		parameter	cnt_2ms_max	= 999;
		parameter	cnt_2s_max	= 999;


		always @( posedge clk_i or negedge rst_n )begin
				if(!rst_n)
						cnt_2us <= 7'b0;
				else if(cnt_2us == cnt_2us_max)
						cnt_2us <= 7'b0;
				else
						cnt_2us <= cnt_2us + 1'b1;
		end

		always @( posedge clk_i or negedge rst_n )begin
				if(!rst_n)
						cnt_2ms <= 10'b0;
				else if(cnt_2us == cnt_2us_max)begin
						if(cnt_2ms == cnt_2ms_max)
							cnt_2ms <= 10'b0;
						else
							cnt_2ms <= cnt_2ms + 1'b1;
				end
		end

		always @( posedge clk_i or negedge rst_n )begin
				if(!rst_n)
						cnt_2s <= 10'b0;
				else if(cnt_2ms == cnt_2ms_max && cnt_2us == cnt_2us_max)begin
						if(cnt_2s == cnt_2s_max)
							cnt_2s <= 10'b0;
					else
							cnt_2s <= cnt_2s + 1'b1;
				end
		end

		always @( posedge clk_i or negedge rst_n )begin
				if(!rst_n)
						flag <= 1'b0;
				else if(cnt_2ms == cnt_2ms_max && cnt_2us == cnt_2us_max && cnt_2s == cnt_2s_max)
						flag <=	~flag;
		end

		always @( posedge clk_i or negedge rst_n )begin
				if(!rst_n)
						pwm <= 1'b0;
				else if(cnt_2ms <= cnt_2s && flag == 1'b0)
						pwm <= 1'b1;
				else if(cnt_2ms >= cnt_2s && flag == 1'b1)
						pwm <= 1'b1;
				else
						pwm <= 1'b0;
		end

	
endmodule
