// This module uses the counter module and a button to generate a 
//   random number. Because a user cannot control how long a button
//   is pressed on the single cycle level we use this to enable the
//   the counter to get a number from 0-15;
// The button is inverted because on the FPGA board it uses an 
//   active low
module rng(Clk, Rst, button, numOut);
	input Clk, Rst, button;
	output [3:0] numOut;
	wire[3:0] numOut;
	wire B_inverted;

	assign B_inverted = ~button;
	counter countRNG(Clk, Rst, B_inverted, numOut);

endmodule
	
