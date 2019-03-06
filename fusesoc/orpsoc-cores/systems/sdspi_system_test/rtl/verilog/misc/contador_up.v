/**
 * @Author: German Cano Quiveu <germancq>
 * @Date:   2019-03-01T13:27:48+01:00
 * @Email:  germancq@dte.us.es
 * @Filename: contador_up.v
 * @Last modified by:   germancq
 * @Last modified time: 2019-03-01T13:27:54+01:00
 */
 module contador_up(
 	input clk,
 	input rst,
    input up,
 	output reg [31:0] q
     );

  always @(posedge clk)
 	begin
 	if (rst == 1)
 		q<=0;
 	else
 		if(up == 1)
 			q<=q+1;
 	end


 endmodule
