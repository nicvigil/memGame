module timer100ms(Clk, Rst, enable, pulseOut);
   input Clk, Rst, enable;
   output pulseOut;

   wire pulse1ms;

   oneMS oneMsTimer(Clk, Rst, enable, pulse1ms);
   countTo100 ct100(Clk, Rst, pulse1ms, pulseOut);

endmodule
