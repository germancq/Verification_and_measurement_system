/**
 * @ Author: German Cano Quiveu, germancq
 * @ Create Time: 2019-12-19 13:20:38
 * @ Modified by: Your name
 * @ Modified time: 2019-12-20 19:47:30
 * @ Description:
 */


import configuration::*;

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

    output [6:0] seg,
    output [7:0] AN
);

    

    assign SD_RESET = 1'b0;
    assign SD_DAT_1 = 1'b1;
    assign SD_DAT_2 = 1'b1;

    logic spongent_rst;
    logic [DATA_WIDTH-1:0] spongent_msg;
    logic [N-1:0] spongent_hash;
    logic spongent_end_hash;

    logic [31:0] debug;

    spongent #(
        .N(N),
        .c(c),
        .r(r),
        .R(R),
        .lCounter_initial_state(lCounter_initial_state),
        .lCounter_feedback_coeff(lCounter_feedback_coeff),
        .DATA_WIDTH(DATA_WIDTH)
    )(
        .clk(sys_clk_pad_i),
        .rst(spongent_rst),

        .msg(spongent_msg),
        .hash(spongent_hash),
        .end_hash(spongent_end_hash)
    );


    autotest_module autotest_impl(
        .clk(sys_clk_pad_i),
        .rst(rst),

        .cs(cs),
        .sclk(sclk),
        .mosi(mosi),
        .miso(miso),

        .rst_cut(spongent_rst),
        .end_cut(spongent_end_hash),
        .input_to_cut(spongent_msg),
        .output_from_cut(spongent_hash),

        .debug(debug)
    );



    display #(.N(32)) display_inst(
        .clk(sys_clk_pad_i),
        .rst(rst),
        .div_value(32'h12),
        .din(debug),
        .an(AN),
        .seg(seg)
    );

    

endmodule : top