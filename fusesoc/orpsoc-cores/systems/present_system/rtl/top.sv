/**
 * @ Author: German Cano Quiveu, germancq
 * @ Create Time: 2019-10-01 16:32:35
 * @ Modified by: Your name
 * @ Modified time: 2019-10-08 12:00:54
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
logic [63:0] block_i;
logic [79:0] key;
logic enc_dec;
logic end_key_generation;
logic [63:0] block_o;
logic end_dec;
logic end_enc;


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
    .end_key_signal_uut(end_key_generation),
    .end_dec_uut(end_dec),
    .end_enc_uut(end_enc),
    .debug(leds_o)
);

present present_impl(
    .clk(sys_clk_pad_i),
    .rst(rst_uut),
    .enc_dec(enc_dec),
    .key(key),
    .block_i(block_i),
    .end_key_generation(end_key_generation),
    .block_o(block_o),
    .end_dec(end_dec),
    .end_enc(end_enc)
);

endmodule : top