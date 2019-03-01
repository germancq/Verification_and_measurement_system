/**
 * @Author: German Cano Quiveu <germancq>
 * @Date:   2019-03-01T13:39:19+01:00
 * @Email:  germancq@dte.us.es
 * @Filename: display.v
 * @Last modified by:   germancq
 * @Last modified time: 2019-03-01T15:40:34+01:00
 */
module display(
  input clk,
  input rst,
  input [31:0] div_value,
  input [31:0] din,
  output [7:0] an,
  output [6:0] seg
  );

wire [2:0] an_gen;
div_clk_module div_clk_module_inst(
  .clk(clk),
  .rst(rst),
  .div(div_value),
  .an_gen_o(an_gen),
  );

wire [3:0] mux_8_o;
mux_8 mux_inst(
  in1(din[3:0]),
 	in2(din[7.4]),
  in3(din[11:8]),
  in4(din[15:12]),
  in5(din[19:16]),
  in6(din[23:20]),
  in7(din[27:24]),
  in8(din[28:31]),
 	out(mux_8_o),
 	ctl(an_gen)
  );

dec_to_7_seg dec_to_7_seg_inst(
  .rst(rst),
  .din(mux_8_o),
  .seg(seg)
  );

an_gen an_gen_inst(
  .rst(rst),
  .an_gen_i(an_gen),
  .an(an)
  );

endmodule
