
// Author: Nicholas Vigil 
// Seven Segment Decoder
//   Takes a 5 bit input and converts it into decimal. Then using a 7 segment
//   LED display, it will display the corresponding number 0-9.
//   If the binary number is above 9 (ie. 10-15) then the diplay will show a letter
//   'A-F' to represent the number.
//   Another thing to note, our seven segment display uses a 1 as off and 0 as on.
// Uses 10000 as a blank screen
module sevenSegDecoder (
  //inputs
  decoder_in,
  //outputs
  decoder_out);
  
  input [4:0] decoder_in;
  output [6:0] decoder_out;
  reg [6:0] decoder_out;

  always @ (decoder_in)
    begin
      case(decoder_in)
	//0
        4'b0000 :  decoder_out = 7'b1000000;

	//1
        4'b0001 :  decoder_out = 7'b1111001;

	//2
        4'b0010 :  decoder_out = 7'b0100100;

	//3
        4'b0011 :  decoder_out = 7'b0110000;

	//4
        4'b0100 :  decoder_out = 7'b0011001;

	//5
        4'b0101 :  decoder_out = 7'b0010010;

	//6   
        4'b0110 :  decoder_out = 7'b0000010;

	//7
        4'b0111 :  decoder_out = 7'b1111000;

	//8
        4'b1000 :  decoder_out = 7'b0000000;

	//9
        4'b1001 :  decoder_out = 7'b0011000;
		
	//10 = a
        4'b1010 :  decoder_out = 7'b0100000;
		
	//11 = b
        4'b1011 :  decoder_out = 7'b0000011;
		
	//12 = c
        4'b1100 :  decoder_out = 7'b0100111;
		
	//13 = d
        4'b1101 :  decoder_out = 7'b0100001;
		
	//14 = e
        4'b1110 :  decoder_out = 7'b0000110;
		
	//15 = f
        4'b1111 :  decoder_out = 7'b0001110;
        
        5'b10000 :  decoder_out = 7'b1111111;

	//set default
        default : decoder_out = 7'b1111111;
          
      endcase
    end
endmodule
        

