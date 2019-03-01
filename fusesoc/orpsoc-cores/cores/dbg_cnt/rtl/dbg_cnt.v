//
// Counters for real-time system performance issues debugging
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

// Register map (32b access):
// 00 [1]          - IRQ mask. 1 - IRQ enabled.
//    [0]          - Enable display controller.
// 04 [2]          - Write 1 to clear counters.
//    [1]          - Write 1 to latch counter values.
//    [0]          - Write 1 to clear IRQ flag.
// 08 [31:0]       - Current clock cycle counter value
// 0c [31:0]       - Latched (requires 04|=2) clock cycle counter value
// 10 [31:0]       - Latched counter #0 value
// 14 [31:0]       - Latched counter #1 value
// ...
//
// Example of instantiation:
//
//   wire [15:0] dbg_cnt_0_strobe =
//               {
//                14'b0,
//                wb_m2s_ddr2_cyc & ~wb_m2s_ddr2_we & wb_s2m_ddr2_ack,
//                wb_m2s_ddr2_cyc &  wb_m2s_ddr2_we & wb_s2m_ddr2_ack
//                };
//
//   dbg_cnt #
//     (
//      .n_counters (16)
//      )
//   dbg_cnt_0
//     (
//      .wb_clk_i             (wb_clk),
//      .wb_rst_i             (wb_rst),
//      .async_rst_i          (async_rst),
//      .wb_dat_i             (wb_m2s_dbg_cnt_dat),
//      .wb_adr_i             (wb_m2s_dbg_cnt_adr[6:2]),
//      .wb_sel_i             (wb_m2s_dbg_cnt_sel),
//      .wb_we_i              (wb_m2s_dbg_cnt_we),
//      .wb_cyc_i             (wb_m2s_dbg_cnt_cyc),
//      .wb_stb_i             (wb_m2s_dbg_cnt_stb),
//      .wb_dat_o             (wb_s2m_dbg_cnt_dat),
//      .wb_ack_o             (wb_s2m_dbg_cnt_ack),
//      .wb_err_o             (wb_s2m_dbg_cnt_err),
//      .wb_rty_o             (wb_s2m_dbg_cnt_rty),
//      .cnt_strobe_i         (dbg_cnt_0_strobe),
//      .irq_o                (dbg_cnt_0_irq)
//      );

module dbg_cnt #
  (
   parameter n_counters  = 16, // number of counters to implement = n_counters + 1
   parameter aw          =  5  // WB address bus width
   )
   (
    input                   wb_clk_i,
    input                   wb_rst_i,
    input                   async_rst_i,

    // Counter inputs
    input  [n_counters-1:0] cnt_strobe_i,

    // Wishbone Interface
    input  [aw-1:0]         wb_adr_i,
    input  [31:0]           wb_dat_i,
    input  [3:0]            wb_sel_i,
    input                   wb_we_i,
    input                   wb_cyc_i,
    input                   wb_stb_i,
    input  [2:0]            wb_cti_i,
    input  [1:0]            wb_bte_i,
    output reg [31:0]       wb_dat_o,
    output reg              wb_ack_o,
    output                  wb_err_o,
    output                  wb_rty_o,

    // clock cycle counter overflow
    output                  irq_o
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
   reg enable_r;
   always @(posedge wb_clk_i or posedge async_rst_i)
     if (async_rst_i)
       enable_r <= 1'b0;
     else if (wb_rst_i)
       enable_r <= 1'b0;
     else if (wb_cyc_i & wb_stb_i & wb_we_i & sel[0])
       enable_r <= wb_dat_i[0];

   // mask IRQ register
   reg IRQ_mask_r;
   always @(posedge wb_clk_i or posedge async_rst_i)
     if (async_rst_i)
       IRQ_mask_r <= 1'b0;
     else if (wb_rst_i)
       IRQ_mask_r <= 1'b0;
     else if (wb_cyc_i & wb_stb_i & wb_we_i & sel[0])
       IRQ_mask_r <= wb_dat_i[1];

   wire overflow;

   // IRQ flag
   // write '1' to clear it
   reg IRQ_flag_r;
   always @(posedge wb_clk_i or posedge async_rst_i)
     if (async_rst_i)
       IRQ_flag_r <= 1'b0;
     else if (wb_rst_i)
       IRQ_flag_r <= 1'b0;
     else if (wb_cyc_i & wb_stb_i & wb_we_i & wb_ack_o & sel[1] & wb_dat_i[0])
       IRQ_flag_r <= 1'b0;
     else if (overflow)
       IRQ_flag_r <= 1'b1;

   assign irq_o = IRQ_flag_r & IRQ_mask_r;

   // write '1' to latch all counters
   reg cnt_latch_r;
   always @(posedge wb_clk_i or posedge async_rst_i)
     if (async_rst_i)
       cnt_latch_r <= 1'b0;
     else if (wb_rst_i)
       cnt_latch_r <= 1'b0;
     else if (wb_cyc_i & wb_stb_i & wb_we_i & wb_ack_o & sel[1] & wb_dat_i[1])
       cnt_latch_r <= 1'b1;
     else
       cnt_latch_r <= 1'b0;

   // write '1' to restart all counters
   reg cnt_clear_r;
   always @(posedge wb_clk_i or posedge async_rst_i)
     if (async_rst_i)
       cnt_clear_r <= 1'b0;
     else if (wb_rst_i)
       cnt_clear_r <= 1'b0;
     else if (wb_cyc_i & wb_stb_i & wb_we_i & wb_ack_o & sel[1] & wb_dat_i[2])
       cnt_clear_r <= 1'b1;
     else
       cnt_clear_r <= 1'b0;

   // counters
   reg [31:0] counter0_r;
   always @(posedge wb_clk_i or posedge async_rst_i)
     if (async_rst_i)
       counter0_r <= 0;
     else if (wb_rst_i | cnt_clear_r)
       counter0_r <= 0;
     else if (enable_r)
       counter0_r <= counter0_r + 1;

   assign overflow = (counter0_r == 32'hffffffff);

   reg [31:0] counters_r [0:n_counters-1];
   genvar x;
   generate
      for (x = 0; x < n_counters; x = x + 1)
        begin : counters_gen
           always @(posedge wb_clk_i or posedge async_rst_i)
             if (async_rst_i)
               counters_r[x] <= 0;
             else if (wb_rst_i | cnt_clear_r)
               counters_r[x] <= 0;
             else if (enable_r & cnt_strobe_i[x])
               counters_r[x] <= counters_r[x] + 1;
        end
   endgenerate

   // counter latches
   reg [31:0] counter0_latched_r;
   always @(posedge wb_clk_i)
     if (enable_r & cnt_latch_r)
       counter0_latched_r <= counter0_r;

   reg [31:0] counters_latched_r [0:n_counters-1];
   genvar y;
   generate
      for (y = 0; y < n_counters; y = y + 1)
        begin : counters_latched_gen
           always @(posedge wb_clk_i)
             if (enable_r & cnt_latch_r)
               counters_latched_r[y] <= counters_r[y];
        end
   endgenerate

   // read back register values
   integer j;
   reg [31:0] wb_dat_tmp;
   always @(posedge wb_clk_i)
     if (wb_rst_i)
       wb_dat_o <= 32'b0;
     else if (wb_cyc_i)
       begin
          wb_dat_tmp = 0;
          if (sel[0]) wb_dat_tmp[1:0]  = {IRQ_mask_r, enable_r};
          if (sel[1]) wb_dat_tmp[0]    = IRQ_flag_r;
          if (sel[2]) wb_dat_tmp       = counter0_r;
          if (sel[3]) wb_dat_tmp       = counter0_latched_r;
          for (j = 0; j < n_counters; j = j + 1)
            if (sel[j+4])
              wb_dat_tmp = counters_latched_r[j];
          wb_dat_o <= wb_dat_tmp;
       end

   // Ack generation
   always @(posedge wb_clk_i)
     if (wb_rst_i)
       wb_ack_o <= 0;
     else if (wb_ack_o)
       wb_ack_o <= 0;
     else if (wb_cyc_i & wb_stb_i & !wb_ack_o)
       wb_ack_o <= 1;

endmodule // dbg_cnt
