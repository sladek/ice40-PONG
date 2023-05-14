/**************************************
* Module: shift_register
* Date:2018-04-21  
* Author: sladekm     
*
* Description: 
***************************************/
module  shift_register #(parameter DATA_WIDTH = 8) (
input   clk,
input   load,
input   [DATA_WIDTH-1:0]  data_in,
output  data_out
);

reg [DATA_WIDTH-1:0]    tmp = 0; // Temporary register
always @(posedge clk) begin 
    if (load) tmp <= data_in; 
    else begin
        tmp <= {tmp[DATA_WIDTH-2:0], 1'b0};
    end 
end 
assign data_out = tmp[DATA_WIDTH-1]; 

endmodule

