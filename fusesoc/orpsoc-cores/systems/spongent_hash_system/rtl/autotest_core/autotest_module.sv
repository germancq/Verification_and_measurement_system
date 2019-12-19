/**
 * @Author: German Cano Quiveu <germancq>
 * @Date:   2019-03-01T15:43:26+01:00
 * @Email:  germancq@dte.us.es
 * @Filename: autotest_module.v
 * @Last modified by:   germancq
 * @Last modified time: 2019-03-05T13:36:26+01:00
 */

import configuration::*;

module autotest_module(
    input clk,
    input rst,

    output cs,
    output sclk,
    output mosi,
    input miso,

    /*UUT signals*/
    output rst_cut,
    input end_cut,
    output [DATA_WIDTH-1:0] input_to_cut,
    input [N-1:0] output_from_cut,
    output [31:0] debug
  );

  logic spi_busy;
  logic [31:0] spi_block_addr;
  logic [7:0] spi_data_out;
  logic spi_r_block;
  logic spi_r_multi_block;
  logic spi_r_byte;
  logic spi_err;
  logic spi_rst;
  logic [7:0] spi_data_in;
  logic spi_w_block;
  logic spi_w_byte;
  logic spi_crc_err;


  logic [31:0] contador_o;
  counter #(.DATA_WIDTH(32)) div_clk_counter(
     .clk(clk),
     .rst(rst),
     .up(1'b1),
     .down(1'b0),
     .din(32'h0),
     .dout(contador_o)
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
    //cut signals
    .rst_cut(rst_cut),
    .end_cut(end_cut),
    .input_to_cut(input_to_cut),
    .output_from_cut(output_from_cut),
    
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
