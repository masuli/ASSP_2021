module checksum (rstx, clk, dv, data, status, sum);

	parameter cntr_limit = 0;

	input dv;
	input clk;
	input rstx;
	input [7:0] data;
	output [7:0] status;
	output [23:0] sum;
			
	reg [15:0] counter;
	reg [7:0] statusreg;
	reg [23:0] accumulator;
			
	assign status = statusreg;
	assign sum = accumulator;

	always @(posedge clk or negedge rstx)
	begin
		if(rstx == 0)
		begin
			counter <= 0;
			statusreg <= 1;
			accumulator <= 0;
		end
		else
		begin
			if(dv == 1)
			begin
				accumulator <= accumulator + data;
				counter <= counter + 1;
			end

			if(counter == cntr_limit)
			begin
				statusreg <= 0;
			end
		end
	end

endmodule 