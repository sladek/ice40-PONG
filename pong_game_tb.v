/**************************************
* Module: VGA_gen_tb
* Date:2018-02-24  
* Author: sladekm     
*
* Description: 
***************************************/
`timescale 1ns/1ns
module  VGA_gen_tb;

wire        vga_hs;
wire        vga_vs;

wire [2:0]  vga_r;
wire [2:0]  vga_g;
wire [2:0]  vga_b;
wire [9:0]  vga_x;
wire [9:0]  vga_y;
//wire        dsp_en;
//wire        vga_clock;
wire        led1, led2;
wire        but1, but2;
wire        osd_o;
wire        end_of_frame;

  parameter REPEAT = 2500000;
  reg clk = 1'b0;
  reg button = 0;

  initial  begin
     $dumpfile ("pong.vcd"); 
     $dumpvars; 
  end 

  initial begin
    clk = 1'b0;
    repeat(REPEAT) begin
        #5 clk = ~clk;
        #5 clk = ~clk;
    end
  end

  initial begin
      #16000 button = 1'b1;
      #1000 button = 1'b0;
  end

pong_game pong_game(
	.CLK100MHz(clk),
	.vga_r(vga_r),
	.vga_g(vga_g),
	.vga_b(vga_b),
	.vga_hs(vga_hs),
	.vga_vs(vga_vs),
	.BUT1(but1),
	.BUT2(but2),
	.LED1(led1),
	.LED2(led2)
);
endmodule

