/*
 Test bench
*/

`timescale 1ns/10ps

module clock_generator_tb();
   reg clr_n, clk;
   wire [3:0] level;
   wire       clk_ball, clk_paddle;
   
   
   clock_generator dut(.clk(clk), .level(4'b0001), .clk_ball(clk_ball), .clk_paddle(clk_paddle), .reset_n(clr_n));

   initial begin
      $dumpfile ("clock_generator.vcd");
      $dumpvars;
   end
   
   initial begin
      clk = 0;
      forever #5 clk = ~clk;
   end
   initial begin
      clr_n = 0;
      #20;
      clr_n = 1;
   end
   initial begin
      #500000;
      $finish;
   end
   
endmodule // bcd_8bit_counter_old_tb


   
   
