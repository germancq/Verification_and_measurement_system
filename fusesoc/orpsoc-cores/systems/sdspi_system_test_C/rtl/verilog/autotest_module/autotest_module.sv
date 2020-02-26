/**
 * @Author: German Cano Quiveu <germancq>
 * @Date:   2019-03-01T15:43:26+01:00
 * @Email:  germancq@dte.us.es
 * @Filename: autotest_module.v
 * @Last modified by:   germancq
 * @Last modified time: 2019-03-05T13:36:26+01:00
 */



module autotest_module
(
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
    output uut_ctrl_mux,
    output uut_rst,
    output uut_start,
    output [31:0] uut_n_blocks,
    output [4:0] uut_sclk_speed,
    output [0:0] uut_cmd18,
    input uut_finish,

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


  logic [7:0] counter_o;
  counter #(.DATA_WIDTH(8)) div_clk_counter(
     .clk(clk),
     .rst(rst),
     .up(1'b1),
     .down(1'b0),
     .din({ 8 {1'b0} }),
     .dout(counter_o)
  );

  fsm_autotest fsm_isnt(
    .clk(clk),
    .clk_counter(counter_o[7]),
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
    .uut_ctrl_mux(uut_ctrl_mux),
    .uut_rst(uut_rst),
    .uut_start(uut_start),
    //uut paramters signals
    .uut_n_blocks(uut_n_blocks),
    .uut_sclk_speed(uut_sclk_speed),
    .uut_cmd18(uut_cmd18),
    //uut results signals
    .uut_finish(uut_finish),
    //debug
    .debug_signal(debug)
  );


  sdspihost sdspi_inst(
    .clk(clk),
    .clk_spi(clk_spi),
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

endmodule : autotest_module
