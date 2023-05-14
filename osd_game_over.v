/**************************************
* Module: osd
* Date:2018-04-21  
* Author: sladekm     
*
* Description: 
***************************************/
`default_nettype none
`include    "definitions.v"

module  osd(
input           clk,
input   [9:0]   vga_x,
input   [9:0]   vga_y,
input           dsp_en,
input   [7:0]   events,
output  [3:0]   level_out,
output          osd
);

`define GAME_OVER_POSITION_X  10'd233 // X position of the Game over text
`define GAME_OVER_POSITION_Y  10'd64  // y position of the Game over text
`define CHAR_LINE_DIVIDER `CHARACTER_LINE_SIZE-1 //height of the character segment
   
wire            increment_score, decrement_lives;
assign          increment_score = events[0];
assign          decrement_lives = events[1];

reg     [2:0]   char_line_address = 0;      // Character line address
reg             clock_divider = 0;

wire            shift_clock = clock_divider;

wire        show_line_start = (vga_y == `GAME_OVER_POSITION_Y) & (vga_x == `GAME_OVER_POSITION_X) ;
wire        show_line = (vga_y >= `GAME_OVER_POSITION_Y) & (vga_y < `GAME_OVER_POSITION_Y + `CHARACTER_SIZE);

reg     [3:0]   next_char_addr = 0;
reg     [9:0]   character_offset = 0;

wire    [3:0]   score_reg_data;     // data from score register
wire    [7:0]   char_mem_address = {score_reg_data,3'd0};
wire    [7:0]   char_mem_data;

// This signal starts osd time base
wire            osd_start = (show_line) & (vga_x >= `GAME_OVER_POSITION_X && vga_x <= `GAME_OVER_POSITION_X + 1);
// During this signal characters are enabled to be shown on screen
wire            buffer_enabled = (vga_x >= `GAME_OVER_POSITION_X) & (vga_x < `GAME_OVER_POSITION_X + `CHAR_BUF_SIZE * 16);
// Loads next segment to shift register 
wire            load_seg;
wire            increment_addr;

// Incrementing adress in character buffer

always @(posedge (increment_addr),posedge osd_start)begin
    if(osd_start) next_char_addr <= 0;
    else next_char_addr <= next_char_addr+1;
end

// Incrementing a pointer to character buffer
always @(posedge load_seg) begin
    if(character_offset == `CHAR_BUF_SIZE-1) character_offset <= 0;
    else character_offset <= character_offset + 1;
end

reg     [1:0] char_line_counter_r = 0;
wire    char_line_counter_clk = char_line_counter_r[1];

// Counting lines for every segment of the character. Every line from character table is repeated `CHARACTER_LINE_SIZE times

always @(posedge dsp_en, posedge show_line_start) begin
    if(show_line_start) char_line_counter_r <= `CHAR_LINE_DIVIDER;
    else if(char_line_counter_r == `CHAR_LINE_DIVIDER) char_line_counter_r <= 0;
    else char_line_counter_r <= char_line_counter_r + 2'b01;
end

// Counter of lines on character memory. It addresses one line of the character in memory.
always  @(posedge char_line_counter_clk, posedge show_line_start) begin
    if(show_line_start == 1) char_line_address <= 0;
    else char_line_address <= char_line_address + 1;
end

always @(posedge clk) begin
    clock_divider <= ~clock_divider;
end

character_memory character_memory(
    .address(char_mem_address + char_line_address),
    .data(char_mem_data)
);

shift_register shift_register(
    .clk(shift_clock),
    .load(load_seg),
    .data_in(char_mem_data),
    .data_out(osd)
);

osd_time_base osd_time_base(
    .clk(shift_clock),
    .start(osd_start),
    .enable(buffer_enabled & show_line),
    .clk_out1(load_seg),
    .clk_out2(increment_addr)
);

score_register score_register(
    .address(next_char_addr),
    .data_out(score_reg_data),
    .level_out(level_out),
    .reset(0),
    .clk_score(increment_score),
    .clk_lives(decrement_lives)
);

endmodule

