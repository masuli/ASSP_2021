module start_trigger (clk, in, rstx, out);

		input clk;
		input in;
		input rstx;
		output out;
				
		reg out_reg;
		assign out = out_reg;
				
      always @(posedge clk or negedge rstx)
      begin
				if(rstx == 0)
				begin
					out_reg <= 1;
				end
				else if(in == 1)
				begin
					out_reg <= 0;
				end
      end

endmodule 