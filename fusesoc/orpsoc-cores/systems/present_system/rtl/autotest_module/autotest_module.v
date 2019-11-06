/**
 * @Author: German Cano Quiveu <germancq>
 * @Date:   2019-03-01T15:43:26+01:00
 * @Email:  germancq@dte.us.es
 * @Filename: autotest_module.v
 * @Last modified by:   germancq
 * @Last modified time: 2019-03-05T13:36:26+01:00
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

    /*UUT signals*/
    output rst_uut,
    output [63:0] block_i_uut,
    output [79:0] key_uut,
    output encdec_uut,
    input [63:0] block_o_uut,
    input  end_key_signal_uut,
    input end_dec_uut,
    input end_enc_uut,
    output [15:0] debug
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
    .clk_counter(contador_o[17]),
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
    .rst_uut(rst_uut),
    //uut paramters signals
    .block_i_uut(block_i_uut),
    .key_uut(key_uut),
    .encdec_uut(encdec_uut),
    //uut results signals
    .block_o_uut(block_o_uut),
    .end_key_signal_uut(end_key_signal_uut),
    .end_enc_uut(end_enc_uut),
    .end_dec_uut(end_dec_uut),
    //debug
    .debug_signal(debug)
  );


  sdspihost sdspi_inst(
    .clk(clk),
    .clk_spi(clk),
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

    .SD_RESET(SD_RESET),
    .SD_DAT_1(SD_DAT_1),
    .SD_DAT_2(SD_DAT_2),
    .debug()
  );

endmodule
