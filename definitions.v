/**************************************
* Module: definitions
* Date:2018-02-24  
* Author: sladekm     
*
* Description: 
***************************************/
`define H_PULSE     96      // H-SYNC pulse width 96 * 40 ns (25 Mhz) = 3.84 uS
`define H_BP        48      // H-BP back porch pulse width
`define H_PIXELS    640     // H-PIX Number of pixels horisontally
`define H_FP        16      // H-FP front porch pulse width
`define H_POL       1'b0    // H-SYNC polarity
`define H_FRAME     800     // 800 = 96 (H-SYNC) + 48 (H-BP) + 640 (H-PIX) + 16 (H-FP)

`define V_PULSE     2       // V-SYNC pulse width
`define V_BP        33      // V-BP back porch pulse width
`define V_PIXELS    480     // V-PIX Number of pixels vertically
`define V_FP        10      // V-FP front porch pulse width
`define V_POL       1'b1    // V-SYNC polarity
`define V_FRAME     525     // 525 = 2 (V-SYNC) + 33 (V-BP) + 480 (V-PIX) + 10 (V-FP)

`define LEFT_BORDER     0
`define RIGHT_BORDER    `H_PIXELS - 1
`define TOP_BORDER      0
`define BOTTOM_BORDER   `V_PIXELS - 1

`define COLOR_BORDER    {3'd7,3'd0,3'd0} // Border color
`define COLOR_BLACK     {3'd0,3'd0,3'd0} // Black color   
`define COLOR_BALL      {3'd0,3'd0,3'd7} // Ball color
`define COLOR_PADDLE    {3'd0,3'd7,3'd0} // Paddle color
`define COLOR_WHITE     {3'd7,3'd7,3'd7} // Osd color

`define BALL_SIZE       16   // Size of the ball. Both x and y are the same

`define PADDLE_WIDTH    64      // Paddle width
`define PADDLE_HEIGHT   12      // Paddle height
`define PADDLE_TOP_Y    460     // Initial y position of top side of a paddle
`define MAX_PADDLE_X  `H_PIXELS - `PADDLE_WIDTH-3
`define MIN_PADDLE_X  2

`define CHARACTER_SIZE      24       // Total number of horizontal lines per character
`define CHARACTER_SEGMENTS  8       // Number of horizontal segment per character
`define CHARACTER_LINE_SIZE 3       // Number of horizontal lines per one charcter segment line
`define CHAR_BUF_SIZE       10       // Size of the character buffer

