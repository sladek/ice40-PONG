/**************************************
* Module: bcd_8bit_counter
* Date:2018-04-29  
* Author: sladekm     
*
* Description: 
***************************************/
module  bcd_8bit_counter(
    input   clk,
    input   reset,
    output  [3:0] bcd0,
    output  [3:0] bcd1
);
   wire 	  tc;
   wire 	  tc1;
   
   bcd_counter c0(.clock(clk), .reset(reset),.tc(tc),.q(bcd0));
   bcd_counter c1(.clock(tc), .reset(reset), .tc(tc1),.q(bcd1));
   
endmodule

