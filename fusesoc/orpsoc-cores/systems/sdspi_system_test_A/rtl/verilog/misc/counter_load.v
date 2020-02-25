/**
 * @Author: German Cano Quiveu <germancq>
 * @Date:   2019-03-06T17:51:06+01:00
 * @Email:  germancq@dte.us.es
 * @Filename: counter_load.v
 * @Last modified by:   germancq
 * @Last modified time: 2019-03-06T17:52:57+01:00
 */
 module counter_load(
 	input clk,
 	input cl,
  input up,
  input w,
  input [31:0] d,
 	output reg [31:0] q
     );

  always @(posedge clk)
 	begin
   	if (cl == 1)
   		q<=0;
   	else if(w == 1)
      q<=d;
    else
   		if(up == 1)
   			q<=q+1;
 	end


 endmodule
