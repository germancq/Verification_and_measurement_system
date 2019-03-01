//
// Wishbone wrapper for RGB LED controller
//
// Copyright (C) 2015 Andrzej <ndrwrdck@gmail.com>
//
// Redistribution and use in source and non-source forms, with or without
// modification, are permitted provided that the following conditions are met:
//    * Redistributions of source code must retain the above copyright
//      notice, this list of conditions and the following disclaimer.
//    * Redistributions in non-source form must reproduce the above copyright
//      notice, this list of conditions and the following disclaimer in the
//      documentation and/or other materials provided with the distribution.
//
// THIS WORK IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
// THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
// PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
// CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
// EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
// PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
// LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
// ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
// WORK, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

// Register map (assuming 32b access):
// 00 [0]                 - Enable LED controller
// 04 [15:0]              - Clock divider for multiplexing.
//                          To obtain a flashing rate further divide by 256 (for PWM)
// 08 [3*depth-1:2*depth] - First diode, red component
//    [2*depth-1:  depth] - First diode, green component
//    [  depth-1:      0] - First diode, blue component
// 0c [3*depth-1:2*depth] - Second diode, red component
//    [2*depth-1:  depth] - Second diode, green component
//    [  depth-1:      0] - Second diode, blue component
// ...
//
// E#xample of instantiation:
//   wb_rgb_led
//     #(
//       .n_leds     (2),
//       .depth      (8),
//       .dw         (24),
//       .aw         (2),
//`ifdef SIM
//       .def_clk_div(4) // speed up simulation time
//`else
//       .def_clk_div(128)
//`endif
//       )
//   rgb_leds
//     (
//      .wb_clk_i       (wb_clk),
//      .wb_rst_i       (wb_rst),
//      .async_rst_i    (async_rst),
//      // Wishbone slave interface
//      .wb_adr_i       (wb_m2s_rgb_led_adr[3:2]),
//      .wb_dat_i       (wb_m2s_rgb_led_dat),
//      .wb_sel_i       (wb_m2s_rgb_led_sel),
//      .wb_we_i        (wb_m2s_rgb_led_we),
//      .wb_cyc_i       (wb_m2s_rgb_led_cyc),
//      .wb_stb_i       (wb_m2s_rgb_led_stb),
//      .wb_cti_i       (wb_m2s_rgb_led_cti),
//      .wb_bte_i       (wb_m2s_rgb_led_bte),
//      .wb_dat_o       (wb_s2m_rgb_led_dat),
//      .wb_ack_o       (wb_s2m_rgb_led_ack),
//      .wb_err_o       (wb_s2m_rgb_led_err),
//      .wb_rty_o       (wb_s2m_rgb_led_rty),
//      // LED driver
//      .rgb_led_o      ({led_rgb2_red_o, led_rgb2_green_o, led_rgb2_blue_o,
//                        led_rgb1_red_o, led_rgb1_green_o, led_rgb1_blue_o})
//      );




module wb_rgb_led
  #(
    parameter def_clk_div = 1024,
    parameter n_leds      =    2,
    parameter depth       =    8,
    parameter dw          =   24, // >= 3*depth
    parameter aw          =    3  // up to 6 LEDs (2^3-2)
    )
   (
    input                  wb_clk_i,
    input                  wb_rst_i,
    input                  async_rst_i,

    // Wishbone Interface
    input  [aw-1:0]        wb_adr_i,
    input  [dw-1:0]        wb_dat_i,
    input  [3:0]           wb_sel_i,
    input                  wb_we_i,
    input                  wb_cyc_i,
    input                  wb_stb_i,
    input  [2:0]           wb_cti_i,
    input  [1:0]           wb_bte_i,
    output reg [dw-1:0]    wb_dat_o,
    output reg             wb_ack_o,
    output                 wb_err_o,
    output                 wb_rty_o,

    // LED driver
    output [n_leds*3-1:0]  rgb_led_o
    );

   // address decoder
   reg [2**aw-1:0]  sel;
   integer          i;
   always @(*)
     begin
        sel = {2**aw{1'b0}};
        for (i = 0; i < 2**aw; i = i + 1)
          if (wb_adr_i == i)
            sel[i] = 1'b1;
     end

   // enable register
   reg enable_reg;
   always @(posedge wb_clk_i or posedge async_rst_i)
     if (async_rst_i)
       enable_reg <= 1'b0;
     else if (wb_rst_i)
       enable_reg <= 1'b0;
     else if (wb_cyc_i & wb_stb_i & wb_we_i & sel[0])
       enable_reg <= wb_dat_i[0];

   // clock divider register
   reg [15:0] clk_div_reg;
   always @(posedge wb_clk_i or posedge async_rst_i)
     if (async_rst_i)
       clk_div_reg <= def_clk_div;
     else if (wb_rst_i)
       clk_div_reg <= def_clk_div;
     else if (wb_cyc_i & wb_stb_i & wb_we_i & sel[1])
       clk_div_reg <= wb_dat_i[15:0];

   // RGB value register
   reg [n_leds*3*depth-1:0] rgb_reg;
   always @(posedge wb_clk_i or posedge async_rst_i)
     if (async_rst_i)
       rgb_reg <= {3*depth{1'b0}};
     else if (wb_rst_i)
       rgb_reg <= {3*depth{1'b0}};
     else if (wb_cyc_i & wb_stb_i & wb_we_i)
       for (i = 0; i < n_leds; i = i + 1)
         if (sel[i+2])
           rgb_reg[3*depth*(i+1)-1 -: 3*depth] <= wb_dat_i[3*depth-1:0];

   // read back register values
   always @(posedge wb_clk_i)
     if (wb_rst_i)
       wb_dat_o <= 32'b0;
     else if (wb_cyc_i)
       begin
          wb_dat_o <= 0;
          if (sel[0]) wb_dat_o[0]            <= enable_reg;
          if (sel[1]) wb_dat_o[15:0]         <= clk_div_reg;
          for (i = 0; i < n_leds; i = i + 1)
            if (sel[i+2])
              wb_dat_o[3*depth-1:0] <= rgb_reg[3*depth*(i+1)-1 -: 3*depth];
       end

   // Ack generation
   always @(posedge wb_clk_i)
     if (wb_rst_i)
       wb_ack_o <= 0;
     else if (wb_ack_o)
       wb_ack_o <= 0;
     else if (wb_cyc_i & wb_stb_i & !wb_ack_o)
       wb_ack_o <= 1;

   assign wb_err_o = 0;
   assign wb_rty_o = 0;

   // instantiate the controller
   wire sync;
   rgb_led #(.depth(depth)) ctrl
     (
      .clk_i          (wb_clk_i),
      .rst_i          (wb_rst_i),
      .async_rst_i    (async_rst_i),
      // config registers
      .enable_i       (enable_reg),
      .clk_div_i      (clk_div_reg),
      .rgb_i          (rgb_reg),
      // display i/f
      .rgb_led_o      (rgb_led_o)
      );

endmodule
