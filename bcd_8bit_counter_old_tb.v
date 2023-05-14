/*
 Test bench
*/

`timescale 1ns/10ps

module bcd_8bit_counter_old_tb();
   reg clr, clk;
   wire  tc;
   wire [3:0] q0;
   wire [3:0] q1;
   
   bcd_8bit_counter_old dut(clk, clr, q0, q1);

   initial begin
      $dumpfile ("bcd_8bit_counter.vcd");
      $dumpvars;
   end
   
   initial begin
      clk = 0;
      forever #5 clk = ~clk;
   end
   initial begin
      clr = 1;
      #20;
      clr = 0;
   end
   initial begin
      #500;
      $finish;
   end
   
endmodule // bcd_8bit_counter_tb


   
   
