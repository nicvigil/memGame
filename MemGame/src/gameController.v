module gameController(
  // inputs
  Clk, Rst, gameButton_in, randNum, p_button, p_input, pulse1sTimer,
  //outputs                
  p1_numOut, enableTimer, points, level, num2display, r_LED, g_LED);
                  
  input Clk, Rst, gameButton_in, p_button, pulse1sTimer;
  input [3:0] randNum, p_input;
  
  output reg enableTimer;
  output [4:0] num2display, points, level, p1_numOut;
  reg [4:0] num2display, points, level, p1_numOut;
  output [17:0] r_LED;
  reg [17:0] r_LED;
  output [3:0] g_LED;
  reg [3:0] g_LED;
  
  reg [3:0] State, inputCt, prevNum;
  reg [63:0] verify, p_seq; // 64 bits to hold 16 - 4 bit numbers.
  reg [31:0] stage1, stage2, stage3, stage4; // these will hold our "random" sequences
  // 64bit random = 
  // 01110000100111010100101001011110 
  // 01101111001100100001100011001011
  
  parameter S_Init = 0, S_GetNum = 1, S_Shift = 2, S_Stage1 = 3, S_Generate = 4, S_WaitForPush = 5, S_Mod = 6, 
            S_InputSeq = 7, S_Verify= 8, S_Add = 9;
  
  always @ (posedge Clk)
  begin 
    if (Rst == 0) begin
      p1_numOut <= 5'b10000; // this sequence is a completely blank display
        stage1 <= 32'b01110001100111010100101001011110;
		  stage2 <= 32'b01101111001100101001100011001011;
		  stage3 <= 32'b10101001010010110111000010011110;
		  stage4 <= 32'b01100100001100011001001101111011;
      r_LED <= 18'b010101010101010101;
      g_LED <= 4'b0000;
      num2display <= 5'b10000; // digit of the sequence that is displayed
      level <= 1;
      inputCt <= 1; // inputCt keeps track of how many digits are in the sequence
      prevNum <= 0; 
      verify <= 0; // the RNG sequence 
      p_seq <= 0; // the player sequence that is input
      points <= 0; // keeps track of user points
      enableTimer <= 0; // goes to the 1 second timer
      State <= S_Init;
    end
    else begin
      case(State)
      
        S_Init:  begin
            stage1 <= 32'b01110010100111010100101001011110;
		      stage2 <= 32'b01101111001100100001100011001011;
		      stage3 <= 32'b10101001010010110111000010011110;
		      stage4 <= 32'b01100100001100011001001101111011;
          
          p_seq <= 0; 
          verify <= 0;
			 if(points < 15) begin
            level <= points + 1; // the level indicates the number of digits in the sequence
          end                   // the level will be 1 more than the number of points
			 else
			   level <= 15;
          // if(points < 2)
            // level <= 2;
          // else if(points < 4)
            // level <= 6;
          // else if(points < 9)
            // level <= 8;
          // else if(points < 13)
            // level <= 12;  
          // else
            // level <= 15;
          inputCt <= level; // we want the inputCt to be the same as the level (level = # digits in sequence)
          // **** State Change Condition ****
          if(gameButton_in == 1) begin // begins once button is pressed.
            State <= S_GetNum;
          end
        end
        
        S_GetNum: begin // waits for RNG module to generate a number
          if(randNum != 0)
            State <= S_Shift;
        end
        
        S_Shift: begin // uses the randNum to then shift our premade sequences making them more random
			    stage1 <= (stage1 >> (randNum*10));
			    stage2 <= stage2 >> (randNum*4);
			    stage3 <= stage3 >> (randNum*4);
			    stage4 <= stage4 >> (randNum*8);
          r_LED <= 18'b000000000000000000;
			    g_LED <= 4'b0000; // clear red and green LEDS
          verify <= 0;
          enableTimer <= 1; // enable the 1 second timer
          State <= S_Stage1;
        end
        
        S_Stage1: begin
          prevNum <= num2display;
          if(inputCt == 0)begin
            State <= S_WaitForPush;
          end
          else if(pulse1sTimer == 1) begin // Every second, the timer sends a pulse which triggers the next digit
            r_LED <= (r_LED * 2) + 1; // Fills Red LED to indicate # of digits
			      if(stage1 == 0) begin  // Next portion of code replaces the RNG seq
              if(stage2 != 0)begin // if we reach 0.
                stage1 <= stage2;
                stage2 <= 0;
              end
              else if(stage3 != 0)begin
                stage1 <= stage3;
                stage3 <= 0;
              end
              else if(stage4 != 0)begin
                stage1 <= stage4;
                stage4 <= 0;
              end
            end 
            // **** State Change Condition ****
            State <= S_Mod;
          end
			  end
        
        S_Mod: begin // state seperated as to not cause issues with the blocking statements
          num2display <= stage1 % 16; // %16 gives us a number between 0 - 15
          // **** State Change Condition ****
          State <= S_Generate;
        end
        

        S_Generate: begin
          if(num2display == prevNum) // try to not have duplicate numbers in a sequence
            num2display <= num2display + level;
          else if(num2display == 0) // try to not have 0s in the sequence
            num2display <= ((points * level * inputCt) % 15) + 1;
				  stage1 <= (stage1 >> ((randNum%3)+1));
          inputCt <= inputCt - 1;
          // **** State Change Condition ****
          State <= S_Add;
        end
        
        S_Add: begin // again, stages broken up to avoid timing errors
          verify <= (verify * 16) + num2display; // shifts sequence over 4 bits by multiplying by 16 and then adds to the sequence
          // **** State Change Condition ****
          State <= S_Stage1;
        end
        
        
        S_WaitForPush: begin // State originally used a push button to change from this state
          if(pulse1sTimer == 1) begin
            num2display <= 5'b10000; // hide the sequence display once full sequence is shown
            g_LED <= 4'b0001; 
            inputCt <= level; // reset inputCt to track the # of digits the player has input
            p1_numOut <= p_input;
            // **** State Change Condition ****
            State <= S_InputSeq; 
          end
        end 
        
        S_InputSeq: begin
		      p1_numOut <= p_input; // allows the input from the switches to be displayed 
          enableTimer <= 0; // turns off the 1 second timer
          // **** State Change Condition ****
          if(inputCt == 0) // if we have input the correct # of digits move to verify state
            State <= S_Verify;
          else if(p_button == 1) begin
            if(g_LED == 4'b1111) // resets green leds to 0001
              g_LED <= 4'b0001;
            else
              g_LED <= (g_LED * 2) + 1; // i use green LEDs to indicate how many digits the player has input
            p_seq <= (p_seq * 16) + p_input; // builds the player sequence the same as RNG sequence
            inputCt <= inputCt - 1;
          end
        end
        
        S_Verify: begin
          p1_numOut <= 5'b10000; // hides the input from the switches
          if(p_seq == verify) begin  // if correct set all Green LEDs on and add a point
				    g_LED <= 4'b1111;
				    r_LED <= 18'b000000000000000000;
            points <= points + 1;
            // **** State Change Condition ****
            State <= S_Init;
          end
          else begin  // if incorrect set all RED LEDs on and subtract a point 
				    g_LED <= 4'b0000; 
				    r_LED <= 18'b111111111111111111;
				    points <= points - 1;
            // **** State Change Condition ****
            State <= S_Init;
          end
            
        end  
          
        
        default: begin
          State <= S_Init;
        end
      endcase
    end 
  end
endmodule