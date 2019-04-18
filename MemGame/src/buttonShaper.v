// button shaper modified to send pulse on release of button, not press
module buttonShaper(Clk, Rst, b_in, out);
   input Clk, Rst, b_in;
   output reg out;
   
   parameter S_Init = 0, S_Pulse = 1,
              S_Wait = 2;
    
	reg [1:0] State, StateNext;
	
	// Comb Logic
	always @ (State, b_in) begin
		case(State)
		
			S_Init: begin
				out <= 0;
				if (b_in == 0)
					StateNext <= S_Wait;
				else
					StateNext <= S_Init;
			end
			
      	S_Pulse: begin
				out <= 1;
				StateNext <= S_Init;
			end
			
			S_Wait: begin
				out <= 0;
				if (b_in == 1)
					StateNext <= S_Pulse;
				else
					StateNext <= S_Wait;
			end
		endcase
	end
	
	// StateReg
	always @ (posedge Clk) begin
		if (Rst == 0)
			State <= S_Init;
		else
			State <= StateNext;
	end
endmodule
