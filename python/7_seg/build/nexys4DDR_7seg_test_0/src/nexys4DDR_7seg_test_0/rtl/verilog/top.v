/**
 * @Author: German Cano Quiveu <germancq>
 * @Date:   2019-03-01T13:04:23+01:00
 * @Email:  germancq@dte.us.es
 * @Filename: top.v
 * @Last modified by:   germancq
 * @Last modified time: 2019-03-05T13:40:48+01:00
 */
module top(
  input sys_clk_pad_i,
  input center_button,

  input [15:0] switch_i,
  output [15:0] leds_o,

  output cs,
  output sclk,
  output mosi,
  input miso,
  output SD_RESET,
  output SD_DAT_1,
  output SD_DAT_2,

  output [6:0] seg,
  output [7:0] AN
);

  wire display_rst;
  wire [31:0] display_din;
  autotest_module autotest_inst(
    .clk(sys_clk_pad_i),
    .rst(center_button),

    .cs(cs),
    .sclk(sclk),
    .mosi(mosi),
    .miso(miso),
    .SD_RESET(SD_RESET),
    .SD_DAT_1(SD_DAT_1),
    .SD_DAT_2(SD_DAT_2),

    .display_rst(display_rst),
    .display_din(display_din),
    .display_an(AN),
    .display_seg(seg),
    .debug({16'h0000,leds_o})

  );

  display display_inst(
    .clk(sys_clk_pad_i),
    .rst(display_rst),
    .div_value(32'd18),
    .din(display_din & 32'hFFFFFFFE),
    .an(AN),
    .seg(seg)
  );

endmodule
