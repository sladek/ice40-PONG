/**************************************
* Module: osd_time_base
* Date:2018-04-28  
* Author: sladekm     
*
* Description: 
***************************************/
`include    "definitions.v"
module  osd_time_base(
    input   clk,
    input   start,
    input   enable,
    output  clk_out1,
    output  clk_out2
);

reg     [3:0]   pos_count = 4'b0;
 
always @(posedge clk) begin
    if (start) pos_count <= 0;
    else if(pos_count == `CHARACTER_SEGMENTS-1) pos_count <= 0;
    else pos_count <= pos_count +1;
end

assign clk_out1 = (pos_count == 1) & enable;
assign clk_out2 = (pos_count == 5) & enable;

endmodule

