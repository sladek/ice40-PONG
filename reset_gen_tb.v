/*
 Test bench - RESET
 */
`timescale 1ns/1ns

module reset_gen_tb();

   wire rst;
   reg 	clk; // clk should be reset on power up 
   
   reset_gen dut(.clk(clk), .rst_p(rst));
   
   initial begin
      $dumpfile ("reset_gen.vcd");
      $dumpvars;
   end
   initial begin
      clk = 0;
      forever #5 clk = ~clk;
   end
   initial begin
      #500;
      $finish;
   end

endmodule // reset_gen_tb
  
