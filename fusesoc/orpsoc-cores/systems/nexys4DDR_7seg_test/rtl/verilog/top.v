/**
 * @Author: German Cano Quiveu <germancq>
 * @Date:   2019-03-01T13:04:23+01:00
 * @Email:  germancq@dte.us.es
 * @Filename: top.v
 * @Last modified by:   germancq
 * @Last modified time: 2019-03-01T15:42:46+01:00
 */
module top(

);


  display display_inst(
    .clk(clk),
    .rst(rst),
    .div_value(32'd19),
    .din(),
    .an(an),
    .seg(seg)
  );

endmodule
