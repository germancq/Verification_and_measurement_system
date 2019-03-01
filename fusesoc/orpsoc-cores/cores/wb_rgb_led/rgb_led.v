//
// RGB LED controller
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

module rgb_led
  #(
    parameter n_leds      = 2,
    parameter depth       = 8
    )
   (
    input                        clk_i,
    input                        rst_i,
    input                        async_rst_i,

    // config registers
    input                        enable_i,
    input  [15:0]                clk_div_i,
    input  [n_leds*3*depth-1:0]  rgb_i,

    // LED driver
    output [n_leds*3-1:0]        rgb_led_o
    );

   // time-base strobe generator
   reg [15:0] cnt_strobe_reg;
   wire strobe = (cnt_strobe_reg == 16'b0);

   always @(posedge clk_i or posedge async_rst_i)
     if (async_rst_i)
       cnt_strobe_reg <= 16'b0;
     else if (rst_i | ~enable_i)
       cnt_strobe_reg <= 16'b0;
     else if (strobe)
       cnt_strobe_reg <= clk_div_i;
     else
       cnt_strobe_reg <= cnt_strobe_reg - 16'd1;

   // led strobe generator
   reg [depth-1:0] cnt_strobe_led_reg;
   always @(posedge clk_i or posedge async_rst_i)
     if (async_rst_i)
       cnt_strobe_led_reg <= ({depth{1'b0}});
     else if (rst_i | ~enable_i)
       cnt_strobe_led_reg <= ({depth{1'b0}});
     else if (strobe)
       cnt_strobe_led_reg <= cnt_strobe_led_reg - 1;

   // rgb_led_reg (pwm control)
   reg     [n_leds*3*depth-1:0] rgb_led_reg;
   integer                      led;
   integer                      color;
   always @(posedge clk_i or posedge async_rst_i)
     if (async_rst_i)
       rgb_led_reg <= ({n_leds*3{1'b0}});
     else if (rst_i | ~enable_i)
       rgb_led_reg <= ({n_leds*3{1'b0}});
     else if (strobe)
       for (led = 0; led < n_leds; led = led + 1)
         for (color = 0; color < 3; color = color + 1)
           rgb_led_reg[3*led+color] <= (cnt_strobe_led_reg < rgb_i[depth*(3*led+color+1)-1 -: depth]);

   // output rgb_led_o
   assign rgb_led_o = rgb_led_reg;

endmodule
