/**
 * @Author: German Cano Quiveu <germancq>
 * @Date:   2019-03-01T13:04:23+01:00
 * @Email:  germancq@dte.us.es
 * @Filename: top.v
 * @Last modified by:   germancq
 * @Last modified time: 2019-03-01T15:42:46+01:00
 */
module top(
  input sys_clk_pad_i,
  input center_button,
  input [15:0] switch_i,
  output [6:0] seg,
  output [7:0] AN
);


  display display_inst(
    .clk(sys_clk_pad_i),
    .rst(center_button),
    .div_value(32'd18),
    .din({switch_i,switch_i}),
    .an(AN),
    .seg(seg)
  );

endmodule
