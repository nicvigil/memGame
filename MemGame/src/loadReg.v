

module loadReg(Clk, Rst, loadPulse, numIn, numOut);

  input Clk, Rst, loadPulse;
  input [3:0] numIn;
  output reg[3:0] numOut;

  always @ (posedge Clk)
  begin
    if(Rst == 0)
    begin
      numOut <= 4'b0000;
    end

    else if(loadPulse == 1)
    begin
      numOut <= numIn;
    end
  end
endmodule