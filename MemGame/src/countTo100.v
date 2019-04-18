// This module counts to 100. It has a Clock and a Reset
//  inputs: Clk, Rst, pulseIn
//  outputs: pulseOut
// The pulseIn is the number being counted.
// At every Clock cycle, the module checks if the pulseIn
// is also 1. Once the count gets to 100, this module sends
// a 1 as pulseOut for one clock cycle.

module countTo100(Clk, Rst, pulseIn, pulseOut);
   input Clk, Rst, pulseIn;
   output reg pulseOut;
   reg [6:0] count;

   always @ (posedge Clk)
   begin
      if (Rst == 0)
      begin
        count <= 1;
        pulseOut <= 0;
      end
		
		else if (pulseIn == 1)
		begin
			if(count == 100)
			begin
				pulseOut <= 1;
				count <= 1;
			end
			
			else if(count < 100)
				count <= count + 1;
		end
		//else statement ensures that pulseOut is only 1 for single cycle
		else
			pulseOut <= 0;
	end
endmodule