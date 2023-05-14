/**************************************
 * Module: reset_gen
 * Date: 2023-31-03
 * Author: sladekm
 * 
 * Description:
 *   Generates positive reset signal
 * ************************************/


module reset_gen(
		 input 	clk,
		 output reset_n
);

reg [3:0] rst_cnt = 0;
wire reset_n = rst_cnt[3];

   
always @(posedge clk)
if( !reset_n )
    rst_cnt <= rst_cnt + 1;

   endmodule
