/**
 * @ Author: German Cano Quiveu, germancq
 * @ Create Time: 2019-11-05 15:47:48
 * @ Modified by: Your name
 * @ Modified time: 2019-11-05 15:51:35
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

logic rst_uut;
logic [127:0] block_i;
logic [127:0] key;
logic enc_dec;
logic [127:0] block_o;
logic end_signal;


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

    /*UUT signals*/
    .rst_uut(rst_uut),
    .block_i_uut(block_i),
    .key_uut(key),
    .encdec_uut(enc_dec),
    .block_o_uut(block_o),
    .end_signal_uut(end_signal),
    
    .debug(leds_o)
);

twofish twofish_impl(
    .clk(sys_clk_pad_i),
    .rst(rst_uut),
    .enc_dec(enc_dec),
    .key(key),
    .text_input(block_i),
    .text_output(block_o),
    .end_signal(end_signal)
);

endmodule : top