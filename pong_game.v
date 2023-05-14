/**************************************
* Module: pong_game
* Date:2018-02-25  
* Author: sladekm     
*
* Description: 
***************************************/
module  pong_game(
		  CLK100MHz,
		  vga_r,
		  vga_g,
		  vga_b,
		  vga_hs,
		  vga_vs,
		  BUT1,   // Button left
		  BUT2,   // Button right
		  LED1,
		  LED2
		  );
   input   CLK100MHz;
   output [2:0] vga_r; // RED output
   output [2:0] vga_g; // GREEN output
   output [2:0] vga_b; // BLUE output
   output 	vga_hs;     // Horisontal sync signal
   output 	vga_vs;     // Vertical sync signal
   input 	BUT1;
   input 	BUT2;
   output 	LED1;
   output 	LED2;

   wire reset_n;   
   wire [9:0] vga_x;
   wire [9:0] vga_y;
   wire       displ_en;   // Display enabled. During this period it is possible to draw on the screen
   wire       button_right_s, button_left_s;
   wire       osd_o;
   wire       end_of_frame;
   wire [7:0] events;
   wire       clk_ball, clk_paddle, vga_clock, clk_button;
   wire [3:0] level;

//   assign LED1 = reset_n;
//   assign LED2 = vga_clock;
      
   button    button_right(.clk_100MHz(CLK100MHz),.button(~BUT2),.button_status(button_right_s));
   button    button_left(.clk_100MHz(CLK100MHz),.button(~BUT1),.button_status(button_left_s));

   VGA_gen   vga(.vga_clock(vga_clock), .vga_hs(vga_hs), .vga_vs(vga_vs), .vga_x(vga_x), .vga_y(vga_y), .dsp_en(displ_en), .end_of_frame(end_of_frame));

   pong      pong(.vga_clock(vga_clock), .reset_n(reset_n), .dsp_en(displ_en), .end_of_frame(end_of_frame), .vga_r(vga_r), .vga_g(vga_g), .vga_b(vga_b), .vga_x(vga_x), .vga_y(vga_y), .osd(osd_o), .button_left(button_left_s), .button_right(button_right_s), .led1(LED1), .led2(LED2), .events(events), .clk_ball(clk_ball), .clk_paddle(clk_paddle));

//   pong      pong(.vga_clock(vga_clock), .reset_n(reset_n), .dsp_en(displ_en), .end_of_frame(end_of_frame), .vga_r(vga_r), .vga_g(vga_g), .vga_b(vga_b), .vga_x(vga_x), .vga_y(vga_y), .osd(osd_o), .button_left(button_left_s), .button_right(button_right_s), .events(events), .clk_ball(clk_ball), .clk_paddle(clk_paddle));

   osd       osd(.clk(vga_clock),.reset_n(reset_n),.vga_x(vga_x), .vga_y(vga_y), .dsp_en(displ_en), .events(events), .osd(osd_o), .level_out(level));
   clock_generator clock_generator(.clk(CLK100MHz),.level(level), .clk_vga(vga_clock), .clk_ball(clk_ball),.clk_paddle(clk_paddle),.clk_button(clk_button), .reset_n(reset_n));  
   reset_gen rst_gen(.clk(CLK100MHz), .reset_n(reset_n));
   
endmodule

