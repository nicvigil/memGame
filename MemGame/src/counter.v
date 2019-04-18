// The counter module uses a start bit to count
// from 0-15. If the start bit is 1 then the count
// variable increments by 1.
// If the reset is hit then count is set to 0.
module counter(Clk, Rst, start, count);
	input Clk, Rst, start;
	output reg [3:0] count;

	always @ (posedge Clk)
	begin
    // if reset is hit set count to 0
		if(Rst == 0)
			count <= 0;
    // if start is 1 then increment count by 1
		else if(start == 1)
		begin
			if (count > 15)
				count<=1;
			count <= count + 1;
		end
	end
endmodule
