module fiforeader (clk, data, q, ack, dv, notfull, rstx);

	input clk;
	input rstx;

	input [7:0] data;
	input notfull;
	output ack;

	output [7:0] q;
	output dv;

	reg [7:0] q_reg;
	reg dv_reg;
	reg ack_reg;
	reg delay1_reg;
	reg delay2_reg;

	assign q = q_reg;
	assign dv = dv_reg;
	assign ack = ack_reg;

	always @(posedge clk or negedge rstx)
	begin
	
		if(rstx == 0)
		begin
			q_reg <= 0;
			dv_reg <= 0;
			ack_reg <= 0;
			delay1_reg <= 0;
			delay2_reg <= 0;
		end
		else
		begin
			q_reg <= 0;
			dv_reg <= 0;
			ack_reg <= 0;

			if(delay2_reg == 0)
			begin
				if(delay1_reg == 0)
				begin
					if(notfull == 1)
					begin
						q_reg <= data;
						dv_reg <= 1;
						ack_reg <= 1;
						delay1_reg <= 1;
						delay2_reg <= 1;
					end
				end
				else	
				begin
					delay1_reg <= 0;
				end
			end
			else	
			begin
				delay2_reg <= 0;
			end
			
		end
	end

endmodule 

