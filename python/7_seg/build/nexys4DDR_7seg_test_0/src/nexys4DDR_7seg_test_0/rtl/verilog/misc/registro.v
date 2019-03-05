/**
 * @Author: German Cano Quiveu <germancq>
 * @Date:   2019-03-01T13:27:19+01:00
 * @Email:  germancq@dte.us.es
 * @Filename: registro.v
 * @Last modified by:   germancq
 * @Last modified time: 2019-03-01T13:27:36+01:00
 */

 module registro(
 	input clk,
 	input cl,
 	input w,
 	input [WIDTH - 1:0] din,
 	output reg [WIDTH - 1:0] dout
     );

     parameter WIDTH = 8;

 	always @(posedge clk)
 	begin
 		if (cl == 1)
 			dout<=0;
 		else if (w==1)
 			dout<=din;
 		else
 			dout<=dout;
 	end
 endmodule
