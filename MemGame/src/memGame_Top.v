module memGame_Top(Clk, Rst, game_b, p1_b, p1_inputNum, seqDisp, p1Disp, pointDisp, r_LED, g_LED);

 
  input Clk, Rst, 
        game_b, // button used to generate the random sequence
        p1_b; // button the player uses to enter their sequence
  input [3:0] p1_inputNum; // switches the player uses 
  output [17:0] r_LED; // addresses all the red LEDs as single number
  output [3:0] g_LED; // outer 4 green LEDS above the buttons
  output [6:0] seqDisp, // displays the rand sequence on sevSeg Display
               p1Disp, // displays the players input on sevSeg Display
               pointDisp; // displays the current users points
  wire game_b_shaped, // signal for game button after it has been passed through the button shaper
       p1__shaped,  // signal for player's button after it has been passed through the button shaper
       enable, // enable signal for the timer, used to display each digit of random sequence for 1 second
       timerPulse; // output from 1s timer which tells the controller to display the next digit 
  wire [3:0] randNum; // output from the RNG which is used to randomize the sequence that is generated
  wire [4:0] num2display, // the digit from the random sequence that is currently being displayed
             points, // points the player has
             level, // level = points + 1 :: level not used currently 
             p1_numOut; // input from the players switches after it has been passed through game controller 
  
  //level not used
  
  buttonShaper simon_button(Clk, Rst, game_b, game_b_shaped);
  buttonShaper p1_button(Clk, Rst, p1_b, p1__shaped);
 
  rng generateSeed(Clk, Rst, game_b, randNum);
  // gameController(Clk, Rst, gameButton_in, randNum, p_button, p_input, pulseTimer,
  //                  p1_numOut, enableTimer, points, level, num2display, r_LED, g_LED);
  gameController controller(
    //inputs
    Clk, Rst, game_b_shaped, randNum, p1__shaped, p1_inputNum, timerPulse,
    //outputs
    p1_numOut, enable, points, level, num2display, r_LED, g_LED);
    
  timerOneSecond timerSequence(Clk, Rst, enable, timerPulse);
  
  sevenSegDecoder disp_Sequence(num2display,seqDisp);
  sevenSegDecoder disp_p1(p1_numOut,p1Disp);
  sevenSegDecoder disp_points(points,pointDisp);
  
endmodule