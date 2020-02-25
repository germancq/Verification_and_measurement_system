/**
 * @Author: German Cano Quiveu <germancq>
 * @Date:   2019-03-01T13:28:21+01:00
 * @Email:  germancq@dte.us.es
 * @Filename: registro_desp.v
 * @Last modified by:   germancq
 * @Last modified time: 2019-03-01T13:28:30+01:00
 */
 module registro_desp(
 	input clk,
 	input cl,
 	input w,
 	input [WIDTH - 1:0] din,
  input shr,
  input shl,
  input shift_bit,
 	output reg [WIDTH - 1:0] dout
     );

     parameter WIDTH = 8;

  reg r_din[WIDTH-1:0];

 	always @(posedge clk)
 	begin
 		if (cl == 1)
 			dout<=0;
 		else if (w==1)
 			dout<=din;
    else if (shr == 1)
      dout <= {shift_bit,dout[7:1]};
    else if (shl == 1)
      dout <= {dout[6:0],shift_bit};
 		else
 			dout<=dout;
 	end
 endmodule
