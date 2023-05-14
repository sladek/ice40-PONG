/*
 Test bench
*/

`timescale 1ns/10ps

module osd_time_base_tb();
   reg clk;
   reg start = 1'b1;
   
   
   osd_time_base dut(.clk(clk), .start(start), .enable(1'b1), .clk_out1(clk1), .clk_out2(clk2));

   initial begin
      $dumpfile ("osd_time_base.vcd");
      $dumpvars;
   end
   initial begin
      clk = 0;
      forever #5 clk = ~clk;
   end
   initial begin
      #10;
      start = 1'b0;
   end	
   initial begin
      #500;
      $finish;
   end
   
endmodule // osd_time_base_tb


   
   
