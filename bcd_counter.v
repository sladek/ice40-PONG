/*
 
 */

module bcd_counter (
		    input clock,reset,
		    output tc,
		    output [3:0] q
		    );

   reg [3:0] q = 0;
   reg 	     tc = 0;
   
 
  always @(posedge clock) begin
    if(reset) begin
       q <= 4'd0;
       tc <= 1'b0;
    end
    else begin
      q = q+1;
      if(q == 4'd10) begin
	 q <= 4'd0;
	 tc <= 1'b1;
      end
      else tc <= 1'b0;
    end
  end

endmodule // bcd_counter

