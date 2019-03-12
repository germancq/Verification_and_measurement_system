/**
 * @Author: German Cano Quiveu <germancq>
 * @Date:   2019-03-01T13:21:14+01:00
 * @Email:  germancq@dte.us.es
 * @Filename: fsm_autotest.v
 * @Last modified by:   germancq
 * @Last modified time: 2019-03-08T12:26:55+01:00
 */

 module fsm_autotest(
     input clk,
     input clk_counter,
     input rst,
     //sdspihost signals
     input spi_busy,
     output [31:0] spi_block_addr,
     input [7:0] spi_data_out,
     output reg spi_r_block,
     output reg spi_r_byte,
     output reg spi_r_multi_block,
     output reg spi_rst,
     input spi_err,
     output [7:0] spi_data_in,
     output reg spi_w_block,
     output reg spi_w_byte,
     input spi_crc_err,
     //uut ctrl signals
     output reg display_rst,
     //uut paramters signals
     output [31:0] display_din,
     //uut results signals
     input [7:0] display_an,
     input [6:0] display_seg,
     //debug
     output [31:0] debug_signal
     );

assign debug_signal = current_state;

 /////registro SPI ///////////////////
 reg reg_spi_data_cl;
 reg reg_spi_data_w;
 reg [7:0] reg_spi_data_in;
 registro reg_spi_data(
 	.clk(clk),
 	.cl(reg_spi_data_cl),
 	.w(reg_spi_data_w),
 	.din(reg_spi_data_in),
 	.dout(spi_data_in)
 );

 //////////signature registers///////////////////////
 wire [31:0] signature;
 wire [7:0] signature_data_0,signature_data_1,signature_data_2,signature_data_3;
 assign signature = {signature_data_0,signature_data_1,signature_data_2,signature_data_3};
 reg reg_signature_data_0_cl;
 reg reg_signature_data_0_w;
 registro reg_signature_0(
 	.clk(clk),
 	.cl(reg_signature_data_0_cl),
 	.w(reg_signature_data_0_w),
 	.din(spi_data_out),
 	.dout(signature_data_0)
 );
 reg reg_signature_data_1_cl;
 reg reg_signature_data_1_w;
 registro reg_signature_1(
 	.clk(clk),
 	.cl(reg_signature_data_1_cl),
 	.w(reg_signature_data_1_w),
 	.din(spi_data_out),
 	.dout(signature_data_1)
 );
 reg reg_signature_data_2_cl;
 reg reg_signature_data_2_w;
 registro reg_signature_2(
 	.clk(clk),
 	.cl(reg_signature_data_2_cl),
 	.w(reg_signature_data_2_w),
 	.din(spi_data_out),
 	.dout(signature_data_2)
 );
 reg reg_signature_data_3_cl;
 reg reg_signature_data_3_w;
 registro reg_signature_3(
 	.clk(clk),
 	.cl(reg_signature_data_3_cl),
 	.w(reg_signature_data_3_w),
 	.din(spi_data_out),
 	.dout(signature_data_3)
 );

///////////////////////////////////////////////////////////////////

//////////uut specific registers///////////////////////
  /////////////data_in////////////////
  wire [7:0] din_0,din_1,din_2,din_3;
  assign display_din = {din_0,din_1,din_2,din_3};
  reg reg_din_0_cl;
  reg reg_din_0_w;
  registro reg_din_0(
  	.clk(clk),
  	.cl(reg_din_0_cl),
  	.w(reg_din_0_w),
  	.din(spi_data_out),
  	.dout(din_0)
  );
  reg reg_din_1_cl;
  reg reg_din_1_w;
  registro reg_din_1(
  	.clk(clk),
  	.cl(reg_din_1_cl),
  	.w(reg_din_1_w),
  	.din(spi_data_out),
  	.dout(din_1)
  );
  reg reg_din_2_cl;
  reg reg_din_2_w;
  registro reg_din_2(
  	.clk(clk),
  	.cl(reg_din_2_cl),
  	.w(reg_din_2_w),
  	.din(spi_data_out),
  	.dout(din_2)
  );
  reg reg_din_3_cl;
  reg reg_din_3_w;
  registro reg_din_3(
  	.clk(clk),
  	.cl(reg_din_3_cl),
  	.w(reg_din_3_w),
  	.din(spi_data_out),
  	.dout(din_3)
  );
  //////////////seg_outputs////////////
  wire[7:0] seg_o_0;
  reg reg_seg_0_cl;
  reg reg_seg_0_w;
  registro reg_seg_0(
  	.clk(clk),
  	.cl(reg_seg_0_cl),
  	.w(~display_an[0]),
  	.din(display_seg),
  	.dout(seg_o_0)
  );
  wire[7:0] seg_o_1;
  reg reg_seg_1_cl;
  reg reg_seg_1_w;
  registro reg_seg_1(
  	.clk(clk),
  	.cl(reg_seg_1_cl),
  	.w(~display_an[1]),
  	.din(display_seg),
  	.dout(seg_o_1)
  );
  wire[7:0] seg_o_2;
  reg reg_seg_2_cl;
  reg reg_seg_2_w;
  registro reg_seg_2(
  	.clk(clk),
  	.cl(reg_seg_2_cl),
  	.w(~display_an[2]),
  	.din(display_seg),
  	.dout(seg_o_2)
  );
  wire[7:0] seg_o_3;
  reg reg_seg_3_cl;
  reg reg_seg_3_w;
  registro reg_seg_3(
  	.clk(clk),
  	.cl(reg_seg_3_cl),
  	.w(~display_an[3]),
  	.din(display_seg),
  	.dout(seg_o_3)
  );
  wire[7:0] seg_o_4;
  reg reg_seg_4_cl;
  reg reg_seg_4_w;
  registro reg_seg_4(
  	.clk(clk),
  	.cl(reg_seg_4_cl),
  	.w(~display_an[4]),
  	.din(display_seg),
  	.dout(seg_o_4)
  );
  wire[7:0] seg_o_5;
  reg reg_seg_5_cl;
  reg reg_seg_5_w;
  registro reg_seg_5(
  	.clk(clk),
  	.cl(reg_seg_5_cl),
  	.w(~display_an[5]),
  	.din(display_seg),
  	.dout(seg_o_5)
  );
  wire[7:0] seg_o_6;
  reg reg_seg_6_cl;
  reg reg_seg_6_w;
  registro reg_seg_6(
  	.clk(clk),
  	.cl(reg_seg_6_cl),
  	.w(~display_an[6]),
  	.din(display_seg),
  	.dout(seg_o_6)
  );
  wire[7:0] seg_o_7;
  reg reg_seg_7_cl;
  reg reg_seg_7_w;
  registro reg_seg_7(
  	.clk(clk),
  	.cl(reg_seg_7_cl),
  	.w(~display_an[7]),
  	.din(display_seg),
  	.dout(seg_o_7)
  );

///////////////timer//////////////////////
 reg up_timer_counter;
 wire [31:0] counter_timer_o;
 reg rst_timer_counter;
 contador_up counter_timer(
    .clk(clk_counter),
    .rst(rst_timer_counter),
    .up(up_timer_counter),
    .q(counter_timer_o)
 );

 ///////////////block_counter////////////////
 reg up_block_counter;
 wire [31:0] counter_block_o;
 reg rst_block_counter;
 assign spi_block_addr = counter_block_o + 32'h0x00100000;
 contador_up counter_block(
    .clk(clk),
    .rst(rst_block_counter),
    .up(up_block_counter),
    .q(counter_block_o)
 );

 ////////////bytes counter ////////////////////

 reg up_bytes_counter;
 wire [31:0] counter_bytes_o;
 reg rst_bytes_counter;
 contador_up counter_bytes(
    .clk(clk),
    .rst(rst_bytes_counter),
    .up(up_bytes_counter),
    .q(counter_bytes_o)
 );



 ///////////////states/////////////////////
 reg [4:0] current_state;
 reg [4:0] next_state;

 parameter IDLE = 5'h0;
 parameter BEGIN_READ_FROM_SD = 5'h1;
 parameter WAIT_RST_SPI = 5'h2;
 parameter SEL_SD_BLOCK = 5'h3;
 parameter WAIT_BLOCK = 5'h4;
 parameter READ_DATA = 5'h5;
 parameter WAIT_BYTE = 5'h6;
 parameter READ_BYTE = 5'h7;
 parameter CHECK_SIGNATURE = 5'h8;
 parameter START_TEST = 5'h9;
 parameter WAIT_UNTIL_END_TEST_OR_TIMEOUT = 5'hA;
 parameter END_TEST = 5'hB;
 parameter SEL_WRITE_SD_BLOCK = 5'hC;
 parameter WAIT_W_BLOCK = 5'hD;
 parameter WRITE_DATA = 5'hE;
 parameter WAIT_W_BYTE = 5'hF;
 parameter UPDATE_BLOCK_COUNTER = 5'h10;
 parameter END_FSM = 5'h11;


 always @(*)
 begin
     next_state = current_state;

     up_block_counter = 0;
     rst_block_counter = 0;

     up_timer_counter = 0;
     rst_timer_counter = 0;

     up_bytes_counter = 0;
     rst_bytes_counter = 0;


     spi_r_block = 0;
     spi_r_byte = 0;
     spi_r_multi_block = 0;
     spi_rst = 0;
     spi_w_block = 0;
     spi_w_byte = 0;


     display_rst = 0;

     reg_signature_data_0_cl = 0;
     reg_signature_data_0_w = 0;
     reg_signature_data_1_cl = 0;
     reg_signature_data_1_w = 0;
     reg_signature_data_2_cl = 0;
     reg_signature_data_2_w = 0;
     reg_signature_data_3_cl = 0;
     reg_signature_data_3_w = 0;

     reg_din_0_cl = 0;
     reg_din_0_w = 0;
     reg_din_1_cl = 0;
     reg_din_1_w = 0;
     reg_din_2_cl = 0;
     reg_din_2_w = 0;
     reg_din_3_cl = 0;
     reg_din_3_w = 0;


     reg_seg_0_cl = 0;
     reg_seg_0_w = 0;
     reg_seg_1_cl = 0;
     reg_seg_1_w = 0;
     reg_seg_2_cl = 0;
     reg_seg_2_w = 0;
     reg_seg_3_cl = 0;
     reg_seg_3_w = 0;
     reg_seg_4_cl = 0;
     reg_seg_4_w = 0;
     reg_seg_5_cl = 0;
     reg_seg_5_w = 0;
     reg_seg_6_cl = 0;
     reg_seg_6_w = 0;
     reg_seg_7_cl = 0;
     reg_seg_7_w = 0;


     reg_spi_data_cl = 0;
     reg_spi_data_w = 0;
     reg_spi_data_in = 8'hff;

     case(current_state)
         IDLE:
             begin

                 rst_timer_counter = 1;
                 //rst_block_counter = 1;
                 rst_bytes_counter = 1;

                 display_rst = 1;

                 reg_signature_data_0_cl = 1;
                 reg_signature_data_1_cl = 1;
                 reg_signature_data_2_cl = 1;
                 reg_signature_data_3_cl = 1;

                 reg_din_0_cl = 1;
                 reg_din_1_cl = 1;
                 reg_din_2_cl = 1;
                 reg_din_3_cl = 1;

                 reg_seg_0_cl = 1;
                 reg_seg_1_cl = 1;
                 reg_seg_2_cl = 1;
                 reg_seg_3_cl = 1;
                 reg_seg_4_cl = 1;
                 reg_seg_5_cl = 1;
                 reg_seg_6_cl = 1;
                 reg_seg_7_cl = 1;

                 reg_spi_data_cl = 1;

                 next_state = BEGIN_READ_FROM_SD;
             end
         BEGIN_READ_FROM_SD:
             begin
                 display_rst = 1;
                 spi_rst = 1;
                 if(spi_busy == 1'b1)
                     next_state = WAIT_RST_SPI;
             end
         WAIT_RST_SPI:
             begin
                 display_rst = 1;
                 if(spi_busy == 1'b0)
                     next_state = SEL_SD_BLOCK;

             end
         SEL_SD_BLOCK:
             begin
                 display_rst = 1;
                 spi_r_block = 1;
                 if(spi_busy == 1)
                     next_state = WAIT_BLOCK;
             end
         WAIT_BLOCK:
             begin
                 display_rst = 1;
     		         spi_r_block = 1;
     		         if(spi_busy == 1'b0)
                         next_state = READ_DATA;
             end
         READ_DATA:
             begin
                 display_rst = 1;
 		             spi_r_block = 1;

                 next_state = READ_BYTE;
 		              case(counter_bytes_o)
 		               32'h0:reg_signature_data_0_w = 1;
                   32'h1:reg_signature_data_1_w = 1;
                   32'h2:reg_signature_data_2_w = 1;
                   32'h3:reg_signature_data_3_w = 1;
                   32'h4:reg_din_0_w = 1;
                   32'h5:reg_din_1_w = 1;
                   32'h6:reg_din_2_w = 1;
                   32'h7:reg_din_3_w = 1;
                   default:
                     begin
                         next_state = CHECK_SIGNATURE;
                     end
 		        endcase
             end
         READ_BYTE:
             begin
                 display_rst = 1;
                 spi_r_block = 1;
                 spi_r_byte = 1;

                 if(spi_busy == 1)
                 begin
                     next_state = WAIT_BYTE;
                     up_bytes_counter = 1;
                 end

             end
         WAIT_BYTE:
             begin
                 display_rst = 1;
                 spi_r_block = 1;
                 if(spi_busy == 1'b0)
                 begin
                     next_state = READ_DATA;
                 end
             end
         CHECK_SIGNATURE:
             begin
               display_rst = 1;
               if(signature == 32'hAABBCCDD)
               begin
                 next_state = START_TEST;
               end
               else
                 next_state = END_FSM;
             end
          START_TEST:
             begin
               next_state = WAIT_UNTIL_END_TEST_OR_TIMEOUT;
             end
          WAIT_UNTIL_END_TEST_OR_TIMEOUT:
             begin
               up_timer_counter = 1;
               if(display_an[7]==0)
                 next_state = END_TEST;
               else if(counter_timer_o >= 32'h6E00000)
                 next_state = END_TEST;

             end
          END_TEST:
             begin

               rst_bytes_counter = 1;
               if(spi_busy == 1'b0)
                   next_state = SEL_WRITE_SD_BLOCK;


             end
          SEL_WRITE_SD_BLOCK:
             begin
                 spi_w_block = 1;
                 next_state = WAIT_W_BLOCK;
             end
          WAIT_W_BLOCK:
             begin
                 spi_w_block = 1;
                 if(spi_busy == 1'b0)
                     next_state = WRITE_DATA;
             end
          WRITE_DATA:
             begin
                 spi_w_block = 1;
                 spi_w_byte = 1;
                 reg_spi_data_w = 1;
                 if(spi_busy == 1'b1)
                     next_state = WAIT_W_BYTE;

                 case(counter_bytes_o)
                   32'h0: reg_spi_data_in = signature_data_0;
                   32'h1: reg_spi_data_in = signature_data_1;
                   32'h2: reg_spi_data_in = signature_data_2;
                   32'h3: reg_spi_data_in = signature_data_3;
                   32'h4: reg_spi_data_in = din_0;
                   32'h5: reg_spi_data_in = din_1;
                   32'h6: reg_spi_data_in = din_2;
                   32'h7: reg_spi_data_in = din_3;
                   32'h8: reg_spi_data_in = seg_o_0;
                   32'h9: reg_spi_data_in = seg_o_1;
                   32'ha: reg_spi_data_in = seg_o_2;
                   32'hb: reg_spi_data_in = seg_o_3;
                   32'hc: reg_spi_data_in = seg_o_4;
                   32'hd: reg_spi_data_in = seg_o_5;
                   32'he: reg_spi_data_in = seg_o_6;
                   32'hf: reg_spi_data_in = seg_o_7;
                   32'h203:
                     begin
                         next_state = UPDATE_BLOCK_COUNTER;
                         rst_bytes_counter = 1;
                     end
                   default:reg_spi_data_in = 8'h00;
                 endcase
             end
          WAIT_W_BYTE:
             begin
                 spi_w_block = 1;
                 if(spi_busy == 1'b0)
                 begin
                     up_bytes_counter = 1;
                     next_state = WRITE_DATA;
                 end
             end
          UPDATE_BLOCK_COUNTER:
             begin

                 display_rst = 1;
                 rst_timer_counter = 1;
                 up_bytes_counter = 1;

                 if(counter_timer_o == 32'h0 && counter_bytes_o > 32'hF0000)
                 begin
                     up_block_counter = 1;
                     next_state = IDLE;
                 end

             end
          END_FSM:
            begin
            end
     endcase
 end

 always @(posedge clk)
 begin
     if(rst == 1)
         current_state <= IDLE;
     else
         current_state <= next_state;
 end



 endmodule
