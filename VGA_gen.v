/**************************************
* Module: VGA_gen
* Date:2018-02-24  
* Author: Olimex     
*
* Description: 
***************************************/
`default_nettype none
`include "definitions.v"

module  VGA_gen(
		vga_clock,
		vga_hs,
		vga_vs,
		vga_x,
		vga_y,
		dsp_en,
		end_of_frame
		);

   input               vga_clock;          // Oscillator input 100Mhz
   output              vga_hs;             // H-sync pulse 
   output              vga_vs;             // V-sync pulse
   output [9:0]        vga_x;              // VGA X position
   output [9:0]        vga_y;              // VGA X position
   output              dsp_en;             // Display enabled. Check later if needed....
   output              end_of_frame;       // Generated at the end of each frame  

   parameter           h_pulse  = `H_PULSE;  // H-SYNC pulse width 96 * 40 ns (25 Mhz) = 3.84 uS
   parameter   [9:0]   h_pixels = `H_PIXELS; // H-PIX Number of pixels horisontally
   parameter           h_pol    = `H_POL;    // H-SYNC polarity
   parameter   [9:0]   h_frame  = `H_FRAME;  // 800 = 96 (H-SYNC) + 48 (H-BP) + 640 (H-PIX) + 16 (H-FP)
   parameter           v_pulse  = `V_PULSE;  // V-SYNC pulse width
   parameter   [9:0]   v_pixels = `V_PIXELS; // V-PIX Number of pixels vertically
   parameter           v_fp     = `V_FP;     // V-FP front porch pulse width
   parameter           v_pol    = `V_POL;    // V-SYNC polarity
   parameter   [9:0]   v_frame  = `V_FRAME;  // 525 = 2 (V-SYNC) + 33 (V-BP) + 480 (V-PIX) + 10 (V-FP)

   assign  vga_hs       = vga_hs_r;
   assign  vga_vs       = vga_vs_r;
   assign  vga_x        = c_col;            // assign horisontal 
   assign  vga_y        = c_row;            // and vertical outputs   
   assign  dsp_en       = disp_en & ~rst;   // Display enabled only when reset = 0
   assign  end_of_frame = eof_r;

   reg                 vga_hs_r;        // H-SYNC register
   reg                 vga_vs_r;        // V-SYNC register
   reg [7:0] 	       timer_t = 8'b0;  // 8 bit timer with 0 initialization
   reg                 rst = 0;  
   reg [9:0] 	       c_col = 10'b0;   //complete frame register column
   reg [9:0] 	       c_row = 10'b0;   //complete frame register row
   reg [9:0] 	       c_hor;           //visible frame register horisontally
   reg [9:0] 	       c_ver;           //visible  frame register vertically
   reg 		       disp_en = 0;                 //display enable flag
   reg 		       eof_r = 0;

   always @ (posedge vga_clock) begin        //25Mhz clock
      if(timer_t > 250) begin             // generate 10 uS rst signal 
         rst <= 0;
      end
      else begin
         rst <= 1;                       //while in rst display is disabled
         timer_t <= timer_t + 1;
         disp_en <= 0;           
      end
      if(rst == 1) begin                  //while rst is high init counters
         c_hor <= 0;
         c_ver <= 0;
         vga_hs_r <= 1;
         vga_vs_r <= 0;
         c_row <= 0;
         c_col <= 0;
      end
      else begin                          // update current beam position
         if(c_hor < h_frame - 1) begin
            c_hor <= c_hor + 1;
         end
         else begin
            c_hor <= 0;
            if(c_ver < v_frame - 1) begin
               c_ver <= c_ver + 1;
            end
            else begin
               c_ver <= 0;
            end
         end
      end
      if(c_hor < h_pixels + `H_FP + 1 || c_hor > h_pixels + `H_FP + h_pulse) begin  // H-SYNC generator
         vga_hs_r <= ~h_pol;
      end
      else begin
         vga_hs_r <= h_pol;
      end
      if(c_ver < v_pixels + v_fp || c_ver > v_pixels + v_fp + v_pulse) begin      //V-SYNC generator
         vga_vs_r <= ~v_pol;
      end
      else begin
         vga_vs_r <= v_pol;
      end
      if(c_hor < h_pixels) begin      //c_col and c_row counters are updated only in the visible time-frame
         c_col <= c_hor;
      end
      if(c_ver < v_pixels) begin
         c_row <= c_ver;
      end
      if(c_hor < h_pixels && c_ver < v_pixels) begin      //VGA color signals are enabled only in the visible time frame
         disp_en <= 1;
      end
      else begin
         disp_en <= 0;
         c_col <= 0; // reset also column an row counters
         c_row <= 0; 
      end
      eof_r <= (vga_y == `V_PIXELS-1) & (vga_x == `H_PIXELS - 1);
   end
endmodule
