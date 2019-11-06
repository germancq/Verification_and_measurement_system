/**
 * @ Author: German Cano Quiveu, germancq
 * @ Create Time: 2019-10-14 15:44:01
 * @ Modified by: Your name
 * @ Modified time: 2019-10-14 16:26:35
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
logic [64:0] plaintext_i;
logic [127:0] hash_o;
logic end_signal_o;

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
    .plaintext_uut(plaintext_i),
    .hash_o_uut(hash_o),
    .end_signal_uut(end_signal_o),

    .debug(leds_o)
);

hirose_present_wrapper #(.DATA_WIDTH(64)) hash_impl(
    .clk(sys_clk_pad_i),
    .rst(rst_uut),
    .plaintext(plaintext_i),
    .c(64'h1234567812345678),
    .hash_output(hash_o),
    .end_signal(end_signal_o)
);

endmodule : top