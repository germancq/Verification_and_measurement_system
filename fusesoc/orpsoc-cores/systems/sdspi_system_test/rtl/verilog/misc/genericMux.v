/**
 * @Author: German Cano Quiveu <germancq>
 * @Date:   2019-03-01T13:26:53+01:00
 * @Email:  germancq@dte.us.es
 * @Filename: genericMux.v
 * @Last modified by:   germancq
 * @Last modified time: 2019-03-01T13:27:02+01:00
 */

 module generic_mux #(parameter DATA_WIDTH=32)
 (
 	input [DATA_WIDTH-1:0] a,
 	input [DATA_WIDTH-1:0] b,
 	output reg [DATA_WIDTH-1:0] c,
 	input ctl);

 always @(*)
 begin
 	if (ctl)
 		c = b;
 	else
 		c = a;
 end

 //assign c = ctl ? a : b; only wires can be assigned in that way

 endmodule
