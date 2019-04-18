module timerOneSecond(Clk, Rst, enable, pulseOut);
   input Clk, Rst, enable;
   output pulseOut;

   wire pulse1ms;

   timer100ms hunnitMsTimer(Clk, Rst, enable, pulse1ms);
   countTo10 ct10(Clk, Rst, pulse1ms, pulseOut);

endmodule
