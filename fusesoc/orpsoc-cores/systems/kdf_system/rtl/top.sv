/**
 * @ Author: German Cano Quiveu, germancq
 * @ Create Time: 2019-10-18 11:46:34
 * @ Modified by: Your name
 * @ Modified time: 2019-10-18 15:27:52
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
logic [63:0] salt_uut;
logic [31:0] count_uut;
logic [31:0] password_uut;
logic end_signal_uut;
logic [127:0] key_derivated_uut;


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
    .salt_uut(salt_uut),
    .count_uut(count_uut),
    .password_uut(password_uut),

    .key_derivated_uut(key_derivated_uut),
    .end_signal_uut(end_signal_uut),

    .debug(leds_o)
);


KDF kdf_impl(
    .clk(sys_clk_pad_i),
    .rst(rst_uut),
    .salt(salt_uut),
    .count(count_uut),
    .user_password(password_uut),
    .end_signal(end_signal_uut),
    .key_derivated(key_derivated_uut)
);

endmodule : top