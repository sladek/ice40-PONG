/*
 Test bench
*/

`timescale 1ns/10ps

module bcd_counter_tb();
   reg clr, clk;
   wire  tc;
   wire [3:0] q;
   
   bcd_counter dut(clr, clk,tc, q);

   initial begin
      $dumpfile ("bcd_counter.vcd");
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
   
endmodule // bcd_counter_tb


   
   
