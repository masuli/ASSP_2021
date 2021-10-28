// one-shot address generator. does not start over after end
// unless a reset is performed

module addr_gen (clk, ack, rstx, addr);

	parameter cntr_limit = 0;

	input clk;
	input ack;
	input rstx;
	output [13:0] addr;
			
	reg [13:0] counter;
	reg [7:0] statusreg;
	assign addr = counter;
			
	always @(posedge clk or negedge rstx)
	begin
		if(rstx == 0)
		begin
			counter = 0;
			statusreg <= 1;
		end
		else if(ack == 1 && statusreg == 1)
		begin
			counter <= counter + 1;

			if (counter == cntr_limit)
			begin
				statusreg <= 0;
			end	
		end
	end

endmodule 