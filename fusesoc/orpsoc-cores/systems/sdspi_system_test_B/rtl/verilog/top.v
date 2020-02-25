/**
 * @Author: German Cano Quiveu <germancq>
 * @Date:   2019-03-01T13:04:23+01:00
 * @Email:  germancq@dte.us.es
 * @Filename: top.v
 * @Last modified by:   germancq
 * @Last modified time: 2019-03-30T19:54:22+01:00
 */
module top(
  input sys_clk_pad_i,
  input center_button,

  input [15:0] switch_i,
  output [15:0] leds_o,

  output [6:0] seg,
  output [7:0] AN,

  output cs,
  output sclk,
  output mosi,
  input miso,
  output SD_RESET,
  output SD_DAT_1,
  output SD_DAT_2
);


  wire [31:0] debug_data;
  display display_inst(
    .clk(sys_clk_pad_i),
    .rst(center_button),
    .div_value(32'd18),
    .din(debug_data),
    .an(AN),
    .seg(seg)
  );


  assign SD_RESET = 1'b0;
  assign SD_DAT_1 = 1'b1;
  assign SD_DAT_2 = 1'b1;


  wire cs_autotest;
  wire sclk_autotest;
  wire mosi_autotest;
  wire SD_RESET_autotest;
  wire SD_DAT_1_autotest;
  wire SD_DAT_2_autotest;

  wire sdspi_ctrl_mux;
  wire sdspi_rst;
  wire sdspi_start;
  wire [31:0] sdspi_n_blocks;
  wire [4:0] sdspi_sclk_speed;
  wire sdspi_cmd18;
  wire sdspi_finish;

  autotest_module autotest_inst(
    .clk(sys_clk_pad_i),
    .rst(center_button),

    .cs(cs_autotest),
    .sclk(sclk_autotest),
    .mosi(mosi_autotest),
    .miso(miso),
    .SD_RESET(SD_RESET_autotest),
    .SD_DAT_1(SD_DAT_1_autotest),
    .SD_DAT_2(SD_DAT_2_autotest),

    .sdspi_ctrl_mux(sdspi_ctrl_mux),
    .sdspi_rst(sdspi_rst),
    .sdspi_start(sdspi_start),
    //uut paramters signals
    .sdspi_n_blocks(sdspi_n_blocks),
    .sdspi_sclk_speed(sdspi_sclk_speed),
    .sdspi_cmd18(sdspi_cmd18),
    //uut results signals
    .sdspi_finish(sdspi_finish),

    .debug(debug_data)

  );

  wire cs_uut;
  wire sclk_uut;
  wire mosi_uut;
  wire SD_RESET_uut;
  wire SD_DAT_1_uut;
  wire SD_DAT_2_uut;

  sdspi_system sdspi_sys_inst(
    .clk(sys_clk_pad_i),
    .rst(sdspi_rst),

    .start(sdspi_start),
    .finish(sdspi_finish),


    .n_blocks(sdspi_n_blocks),
    .cmd18(sdspi_cmd18),
    .sclk_speed(sdspi_sclk_speed),

    .sclk(sclk_uut),
    .cs(cs_uut),
    .mosi(mosi_uut),
    .miso(miso),

    .SD_RESET(SD_RESET_uut),
    .SD_DAT_1(SD_DAT_1_uut),
    .SD_DAT_2(SD_DAT_2_uut)
  );


  generic_mux #(.DATA_WIDTH(1)) mux_sclk(
    .a(sclk_autotest),
   	.b(sclk_uut),
   	.c(sclk),
   	.ctl(sdspi_ctrl_mux)
  );
  generic_mux #(.DATA_WIDTH(1)) mux_mosi(
    .a(mosi_autotest),
   	.b(mosi_uut),
   	.c(mosi),
   	.ctl(sdspi_ctrl_mux)
  );
  generic_mux #(.DATA_WIDTH(1)) mux_cs(
    .a(cs_autotest),
   	.b(cs_uut),
   	.c(cs),
   	.ctl(sdspi_ctrl_mux)
  );

endmodule
