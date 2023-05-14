/**************************************
* Module: button
* Date:2018-03-04  
* Author: sladekm     
*
* Description: 
***************************************/
module  button(
input   clk_100MHz,    // Expects 100MHz clock for calculated timing
input   button,
output  button_status
);

reg button_s;   // register to keep button output state
reg button_r;   // register to keep button current state
reg [14:0]  debounce_cnt=0;    // 15 bit counter for button 1 debounce
reg [9:0]  clk_div = 0;        // 10 bit counter clk_div[9] gives about 24kHz

wire        clk_24kHz = clk_div[9];
   
assign  button_status = button_s;

always @ (posedge clk_100MHz) begin  //on each positive edge of 100Mhz clock increment clk_div
    clk_div <= clk_div + 1'b1;
end

always @ (posedge clk_24kHz) begin          //on each positive edge of 24414Hz clock
    debounce_cnt <= debounce_cnt + 15'd1;   // increase debounce counter    
    if(button_r ^ ~button) begin
        debounce_cnt <= 15'b0;              // button status changed reset debounce counter
        button_r <= ~button;
    end
    if(debounce_cnt == 15'd2442) begin      //when 0.1s pass
        button_s <= button_r;               //capture button 1 state to button_1_s
        debounce_cnt <= 15'b0;              // button status changed reset debounce counter
    end
end

endmodule

