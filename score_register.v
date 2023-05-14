/**************************************
* Module: data_file
* Date:2018-04-29  
* Author: sladekm     
*
* Description: 
***************************************/
`include    "definitions.v"
module  score_register(
    input   [3:0]   address,
    output  [3:0]   data_out,
    output  [3:0]   level_out,    
    input   reset,
    input   clk_score,
    input   clk_lives   // Decreses number of lives
);

reg [3:0] data_o;
reg [3:0] level;
reg [4:0]   lives = 5'b11111;
assign data_out = data_o;
assign level_out = level;
wire[3:0] score0, score1;
wire [7:0] score;
assign score = {score1,score0};
  
always @(*)
begin
   case(address)
       0 : data_o = lives[4]?4'd14:4'd10;
       1 : data_o = lives[3]?4'd14:4'd10;
       2 : data_o = lives[2]?4'd14:4'd10;
       3 : data_o = lives[1]?4'd14:4'd10;
       4 : data_o = lives[0]?4'd14:4'd10;
       5 : data_o = 13;
       6 : data_o = level;
       7 : data_o = 12;
       8 : data_o = score1;
       9 : data_o = score0;
       default: data_o = 4'd10;
   endcase
end

always @(*) begin
    if (score <= 2)  level = 1;
    else if (score <= 4)  level = 2;
    else if (score <= 6)  level = 3;
    else if (score <= 8)  level = 4;
    else if (score <= 10) level = 5;
    else if (score <= 12) level = 6;
    else if (score <= 14) level = 7;
    else if (score <= 16) level = 8;
    else                  level = 9;
end

bcd_8bit_counter bcd_8bit_counter(
	.clk(clk_score),
	.reset(reset),
	.bcd1(score1),
	.bcd0(score0)
);
endmodule

