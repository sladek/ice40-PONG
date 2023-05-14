/**************************************
* Module: PONG
* Date:2018-02-24  
* Author: sladekm     
*
* Description: 
***************************************/
`default_nettype none
`include    "definitions.v"

module  pong(
	     input 	  vga_clock, //25MHz
	     input 	  reset_n, 
	     input 	  dsp_en,
	     input 	  end_of_frame,
	     input 	  osd,
	     input 	  button_left,
	     input 	  button_right,
	     input 	  clk_ball,
	     input 	  clk_paddle,
	     output 	  led1,
	     output 	  led2,
	     output [2:0] vga_r,
	     output [2:0] vga_g,
	     output [2:0] vga_b,
	     input  [9:0] vga_x,
	     input  [9:0] vga_y,
	     output [7:0] events
);
  
   reg [9:0]	  ball_x; // Initial x position of the ball;           
   reg [9:0] 	  ball_y; // Initial y position of the ball;
   reg [9:0] 	  paddle_position; // = `H_PIXELS/2 - `PADDLE_WIDTH/2;

   reg [8:0] 	  vga_color_r;    // VGA color register {[2:0]red,[2:0]green,[2:0]blue}
   reg 		  run=0;   // If run==1 game runs.

   wire 	  increment_score = events[0];
   wire 	  decrement_lives = events[1];
   wire 	  displ_en = dsp_en;
   wire 	  button_pressed = button_left ^ button_right;
   wire 	  up_down = button_right; 

   // Indicates that vga_x or vga_y is in the border region so color for border will be used
   wire 	  border = (vga_y == `TOP_BORDER || vga_x == `LEFT_BORDER || vga_y == `BOTTOM_BORDER || vga_x == `RIGHT_BORDER);
   // VGA points to paddle so paddle color is used. For the simplicity - paddle 0,0 position is top left corner
   wire 	  paddle = (vga_x >= paddle_position) && (vga_x < paddle_position + `PADDLE_WIDTH) && (vga_y >= `PADDLE_TOP_Y) && (vga_y < `PADDLE_TOP_Y + `PADDLE_HEIGHT);
   wire 	  collision = collision_left | collision_right | collision_top | collision_bottom;
   wire 	  increment_ball_position = run?clk_ball:0;
   wire 	  increment_paddle_position = clk_paddle;// = increment_counter[4];
   wire 	  ball_on_paddle_side = (ball_y + `BALL_SIZE >= `PADDLE_TOP_Y) && (ball_y < `PADDLE_TOP_Y + `PADDLE_HEIGHT);
   wire 	  ball_in_paddle_x_position = (ball_x + `BALL_SIZE) >= paddle_position & ball_x < (paddle_position + `PADDLE_WIDTH);
   wire 	  increment_score = collision_paddle_top; // Increments score counter in OSD module
   wire 	  decrement_lives = collision_bottom;
   // for the simplicity - ball 0,0 position is top left corner
   wire 	  ball = (vga_x >= ball_x) && (vga_x < ball_x + `BALL_SIZE) && (vga_y >= ball_y) && (vga_y < ball_y + `BALL_SIZE);

   // Collision flags.   
   wire 	  collision_top = (ball_y == `TOP_BORDER);
   wire 	  collision_bottom = (ball_y == `BOTTOM_BORDER || ((ball_y == `PADDLE_TOP_Y + `PADDLE_HEIGHT) & ball_in_paddle_x_position));
   wire 	  collision_left = ((ball_x == `LEFT_BORDER) || ((ball_x + `BALL_SIZE == paddle_position) && ball_on_paddle_side));
   wire 	  collision_right = ((ball_x + `BALL_SIZE) == `RIGHT_BORDER || ((ball_x == paddle_position+`PADDLE_WIDTH) && ball_on_paddle_side)); 
   wire 	  collision_paddle_top  = ((ball_y + `BALL_SIZE) == `PADDLE_TOP_Y) &  ball_in_paddle_x_position;
   // Ball movement
   reg 		  ball_x_direction;
   reg 		  ball_y_direction;
   reg 		  fail;
   // reg 	      collision_paddle_top;
   // reg 		  reset_collision = 0; 

   assign  vga_r = vga_color_r[8:6];      //assign the output signals for VGA to the VGA registers
   assign  vga_g = vga_color_r[5:3];
   assign  vga_b = vga_color_r[2:0];

   always @(posedge collision, negedge run) begin
      if (!run) begin
	 ball_x_direction <= 0;
	 ball_y_direction <= 0;
      end
      else begin
	 if(collision_right || collision_left) ball_x_direction <= ~ball_x_direction; 
	 if(collision_paddle_top) ball_y_direction <= ~ball_y_direction;
      end
   end
   
   // Initial position. 
   //  - Starts game only if button is pressed
   //  - Stops game if there is a fail (collision)
   always @(posedge vga_clock) begin
      if(fail) run <= 0;
      if(button_pressed) begin
	 run <= 1;
      end
      // Draw everything
      if(displ_en) begin
	 if(border) vga_color_r <= `COLOR_BORDER;
	 else if(ball) vga_color_r <= `COLOR_BALL;
	 else if(paddle) vga_color_r <= `COLOR_PADDLE;
	 else if(osd) vga_color_r <= `COLOR_WHITE;
	 else vga_color_r <= `COLOR_BLACK;
      end
      else vga_color_r <= `COLOR_BLACK;
      // End draw
   end

   // collision calculation
   /*
    always @(posedge vga_clock) begin
    if(end_of_frame) reset_collision <= 1;
    else reset_collision <= 0;
    end
    */
   
   // Detect fail. Fail is detected only if there is bottom collision.
   always @(posedge collision_bottom) begin
      if(paddle) fail<=0;
      else begin
         fail <=1;
      end 
   end

      
   // Move the ball based on direction flags
   always @(negedge clk_ball, negedge run) begin
      if(!run) begin
         ball_x <= `H_PIXELS/2 -`BALL_SIZE/2; // Initial x position of the ball
         ball_y <= `V_PIXELS/2 -`BALL_SIZE/2; // Initial y position of the ball
      end
      else begin
         if(!(collision_left & collision_right)) begin       // if collision on one of X-sides, don't move in the X direction
	    ball_x <= ball_x + (ball_x_direction ? -1 : 1);
         end
         if(!(collision_top & collision_bottom)) begin       // if collision on one of Y-sides, don't move in the Y direction
            ball_y <= ball_y + (ball_y_direction ? -1 : 1);
         end
      end
   end

 
   always @(posedge increment_paddle_position, negedge reset_n, posedge fail) begin
      if(!reset_n) begin 
	 paddle_position <= `H_PIXELS/2 - `PADDLE_WIDTH/2;
      end
      else if(fail) begin 
	 paddle_position <= `H_PIXELS/2 - `PADDLE_WIDTH/2;
      end
      else if(button_pressed) begin
	 if(up_down == 1) begin 
            if(paddle_position != `MAX_PADDLE_X) paddle_position <= paddle_position+1;
	 end
	 else begin
            if(paddle_position != `MIN_PADDLE_X) paddle_position <= paddle_position-1;
	 end
      end
   end
 
   // State machine
   localparam 
     STATE_Init = 2'b00,
     STATE_Idle = 2'b01,
     STATE_Run  = 2'b10,
     STATE_GameOver = 2'b11;

   reg [1:0] current_state;
   reg [1:0] next_state;

   always @(posedge vga_clock) begin
      if(!reset_n) current_state <= STATE_Init;
      else current_state <= next_state;
   end	     

   always @(*) begin
      next_state <= current_state;
      case (current_state)
	STATE_Init: begin
	   next_state <= STATE_Idle;
	end
	STATE_Idle: begin
	   if(button_pressed) next_state <= STATE_Run;
	end
	STATE_Run: begin
	   if (collision) next_state <= STATE_Idle;
      endcase // case (current_state)
   end // always @ (*)
   
	
   
   assign {led2, led1} = {vga_clock, button_pressed};

endmodule

