/**
 * @Author: German Cano Quiveu <germancq>
 * @Date:   2019-03-01T15:43:26+01:00
 * @Email:  germancq@dte.us.es
 * @Filename: autotest_module.v
 * @Last modified by:   germancq
 * @Last modified time: 2019-03-06T19:42:33+01:00
 */
module autotest_module(
    input clk,
    input rst,

    output cs,
    output sclk,
    output mosi,
    input miso,
    output SD_RESET,
    output SD_DAT_1,
    output SD_DAT_2,

    //uut ctrl signals
    output sdspi_ctrl_mux,
    output sdspi_rst,
    output sdspi_start,
    //uut paramters signals
    output [31:0] sdspi_n_blocks,
    output [4:0] sdspi_sclk_speed,
    output sdspi_cmd18,
    //uut results signals
    input sdspi_finish,

    output [31:0] debug
  );

  wire spi_busy;
  wire [31:0] spi_block_addr;
  wire [7:0] spi_data_out;
  wire spi_r_block;
  wire spi_r_multi_block;
  wire spi_r_byte;
  wire spi_err;
  wire spi_rst;
  wire [7:0] spi_data_in;
  wire spi_w_block;
  wire spi_w_byte;
  wire spi_crc_err;


  wire [31:0] contador_o;
  contador_up div_clk_counter(
     .clk(clk),
     .rst(rst),
     .up(1'b1),
     .q(contador_o)
  );

  fsm_autotest fsm_isnt(
    .clk(clk),
    .clk_counter(contador_o[7]),
    .rst(rst),
    //sdspihost signals
    .spi_busy(spi_busy),
    .spi_block_addr(spi_block_addr),
    .spi_data_out(spi_data_out),
    .spi_r_block(spi_r_block),
    .spi_r_byte(spi_r_byte),
    .spi_r_multi_block(spi_r_multi_block),
    .spi_rst(spi_rst),
    .spi_err(spi_err),
    .spi_data_in(spi_data_in),
    .spi_w_block(spi_w_block),
    .spi_w_byte(spi_w_byte),
    .spi_crc_err(spi_crc_err),
    //uut ctrl signals
    .sdspi_ctrl_mux(sdspi_ctrl_mux),
    .sdspi_start(sdspi_start),
    .sdspi_rst(sdspi_rst),
    //uut paramters signals
    .sdspi_n_blocks(sdspi_n_blocks),
    .sdspi_sclk_speed(sdspi_sclk_speed),
    .sdspi_cmd18(sdspi_cmd18),
    //uut results signals
    .sdspi_finish(sdspi_finish),
    //debug
    .debug_signal(debug)
  );


  sdspihost sdspi_inst(
    .clk(clk),
    .reset(spi_rst),
    .busy(spi_busy),
    .err(spi_err),
    .crc_err(spi_crc_err),

    .r_block(spi_r_block),
    .r_multi_block(spi_r_multi_block),
    .r_byte(spi_r_byte),
    .w_block(spi_w_block),
    .w_byte(spi_w_byte),
    .block_addr(spi_block_addr),
    .data_out(spi_data_out),
    .data_in(spi_data_in),


    //SPI interface
    .miso(miso),
    .mosi(mosi),
    .sclk(sclk),
    .ss(cs),
    ////
    .sclk_speed(4'h7),
    .debug()
  );

endmodule
