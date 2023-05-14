/*
 Test bench
*/

`timescale 1ns/1ns

module _generator_tb();
   reg clr_n, clk;
   wire [3:0] level;
   wire       clk_ball, clk_paddle;
   
   
   VGA_gen dut(.CLK100MHz(clk));

   initial begin
      $dumpfile ("VGA_gen.vcd");
      $dumpvars;
   end
   
   initial begin
      clk = 0;
      forever #10 clk = ~clk;
   end
   initial begin
      clr_n = 0;
      #20;
      clr_n = 1;
   end
   initial begin
      #5000000;
      $finish;
   end
   
endmodule // bcd_8bit_counter_old_tb


   
   
