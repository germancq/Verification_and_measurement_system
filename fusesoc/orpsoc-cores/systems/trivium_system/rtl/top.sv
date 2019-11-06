/**
 * @ Author: German Cano Quiveu, germancq
 * @ Create Time: 2019-10-01 16:23:01
 * @ Modified by: Your name
 * @ Modified time: 2019-10-09 13:25:48
 * @ Description:
 */

module top(
    input sys_clk_pad_i,
    input rst,

    output cs,
    output sclk,
    output mosi,
    input miso,
    output SD_RESET,
    output SD_DAT_1,
    output SD_DAT_2,

    output [15:0] leds_o
);

logic [79:0] key;
logic [79:0] iv;
logic rst_uut;
logic end_uut;
logic [63:0] block_o_uut;


autotest_module autotest_impl(
    .clk(sys_clk_pad_i),
    .rst(rst),

    .cs(cs),
    .sclk(sclk),
    .mosi(mosi),
    .miso(miso),
    .SD_RESET(SD_RESET),
    .SD_DAT_1(SD_DAT_1),
    .SD_DAT_2(SD_DAT_2),

    .rst_uut(rst_uut),
    .iv_uut(iv),
    .key_uut(key),
    .end_uut(end_uut),
    .block_o_uut(block_o_uut),
    

    .debug(leds_o)
);


trivium_wrapper #(.DATA_WIDTH(64)) trivium_wrapper_impl(
    .clk(sys_clk_pad_i),
    .rst(rst_uut),
    .key(key),
    .iv(iv),
    .end_block(end_uut),
    .block_o(block_o_uut)
);

endmodule : top