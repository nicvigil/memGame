
module oneMS(Clk, Rst, enable, pulseOut);

   input Clk, Rst, enable;
   output reg pulseOut;

   reg[15:0] count;

   always @ (posedge Clk)
   begin
      if ( (Rst == 0) || (enable != 1) )
         begin
         count <= 1;
         pulseOut <= 0;
         end
      else if(count < 50000)
         begin
         count <= count + 1;
         pulseOut <= 0;
         end
      else if(count >= 50000)
         begin
         pulseOut <= 1;
         count <= 1;
         end
   end
endmodule
          
   