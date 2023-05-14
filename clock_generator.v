/**************************************
* Module: clock_generator
* Date:2018-05-03  
* Author: sladekm     
*
* Description: 
***************************************/
module  clock_generator(
			input 	    clk, // 100MHz
			input 	    reset_n,
			input [3:0] level,
			output 	    clk_vga,
			output 	    clk_ball,
			output 	    clk_paddle,
			output 	    clk_button, // About 24kHz for debouncing 
);

`define INIT_BALL_DIVIDER 8'd128
`define INIT_PADDLE_DIVIDER 8'd128

   reg [18:0] increment_counter; // Counter used for specifying of ball and paddle speed.
   reg [7:0]  ball_speed_divider; // = `INIT_BALL_DIVIDER;
   reg [7:0]  paddle_speed_divider; // = `INIT_PADDLE_DIVIDER;
 
//   wire clk_ball   = (increment_counter & {ball_speed_divider,8'b0}) == {ball_speed_divider,8'b0};
//   wire clk_paddle = (increment_counter & {paddle_speed_divider,8'b0}) == {paddle_speed_divider,8'b0};
   wire clk_ball   = increment_counter[18];
   wire clk_paddle = increment_counter[17];
   wire clk_button = increment_counter[9];
   wire clk_vga    = increment_counter[1];
     
   /*
   always  @(posedge clk) begin
      case(level)    // default level = 1
	1: begin
           ball_speed_divider <= `INIT_BALL_DIVIDER;
           paddle_speed_divider <= `INIT_PADDLE_DIVIDER;
	end
	2: begin
           ball_speed_divider <= 64;
           paddle_speed_divider <= 32;
        end
	3: begin
           ball_speed_divider <= 60;
           paddle_speed_divider <= 30;
        end
	4: begin
           ball_speed_divider <= 50;
           paddle_speed_divider <= 25;
        end
	5: begin
           ball_speed_divider <= 40;
           paddle_speed_divider <= 20;
        end
	default: begin
           ball_speed_divider <= `INIT_BALL_DIVIDER;
           paddle_speed_divider <= `INIT_PADDLE_DIVIDER;
        end
      endcase
   end
   */
   
   always @(posedge clk) begin 
      if (!reset_n) increment_counter <= 0;
      else increment_counter <= increment_counter + 1;
   end
   
endmodule

