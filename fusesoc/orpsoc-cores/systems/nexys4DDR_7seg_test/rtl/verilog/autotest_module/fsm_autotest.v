/**
 * @Author: German Cano Quiveu <germancq>
 * @Date:   2019-03-01T13:21:14+01:00
 * @Email:  germancq@dte.us.es
 * @Filename: fsm_autotest.v
 * @Last modified by:   germancq
 * @Last modified time: 2019-03-01T15:48:21+01:00
 */

 module fsm_autotest(
     input clk,
     input clk_counter,
     input rst,
     //sdspihost signals
     input spi_busy,
     output [31:0] spi_block_addr,
     input [7:0] spi_data_out,
     input [7:0] sw_in,
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

     //uut paramters signals

     //uut results signals

     //debug
     output [31:0] debug_signal
     );

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



///////////////timer//////////////////////
 //reg up_divclk_counter;
 wire [31:0] counter_divclk_o;

 //reg rst_divclk_counter;
 contador_up counter_divclk(
    .clk(clk_counter),
    .rst(reg_gl_clk_w),
    .up(1),
    .q(counter_divclk_o)
 );



 reg up_timer_counter;
 wire [31:0] counter_timer_o;
 reg rst_timer_counter;
 contador_up counter_timer(
    .clk(counter_divclk_o[5]),
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


 always @(*)
 begin
     next_state = current_state;

     up_block_counter = 0;
     rst_block_counter = 0;

     up_timer_counter = 0;
     rst_timer_counter = 0;

     up_bytes_counter = 0;
     rst_bytes_counter = 0;

     sel_mux_spi = 0;
     spi_r_block = 0;
     spi_r_byte = 0;
     spi_r_multi_block = 0;
     spi_rst = 0;
     spi_w_block = 0;
     spi_w_byte = 0;


     rst_nanofs = 0;

     start_boot_proccess = 0;
     rst_n_boot_proccess = 1;

     reg_signature_data_0_cl = 0;
     reg_signature_data_0_w = 0;
     reg_signature_data_1_cl = 0;
     reg_signature_data_1_w = 0;
     reg_signature_data_2_cl = 0;
     reg_signature_data_2_w = 0;
     reg_signature_data_3_cl = 0;
     reg_signature_data_3_w = 0;

     reg_global_clk_cl = 0;
     reg_global_clk_w = 0;

     reg_gl_clk_cl = 0;
     reg_gl_clk_w = 0;

     reg_ddr_clk_cl = 0;
     reg_ddr_clk_w = 0;

     reg_sclk_cl = 0;
     reg_sclk_w = 0;

     reg_cmd18_cl = 0;
     reg_cmd18_w = 0;


     reg_spi_data_cl = 0;
     reg_spi_data_w = 0;
     reg_spi_data_in = 8'hff;

     case(current_state)
         IDLE:
             begin
                 sel_mux_spi = 1;


                 rst_timer_counter = 1;
                 //rst_block_counter = 1;
                 rst_bytes_counter = 1;

                 rst_n_boot_proccess = 0;

                 reg_signature_data_0_cl = 1;
                 reg_signature_data_1_cl = 1;
                 reg_signature_data_2_cl = 1;
                 reg_signature_data_3_cl = 1;
                 reg_global_clk_cl = 1;
                 reg_ddr_clk_cl = 1;
                 reg_sclk_cl = 1;
                 reg_cmd18_cl = 1;
                 reg_gl_clk_cl = 1;

                 reg_spi_data_cl = 1;

                 next_state = BEGIN_READ_FROM_SD;
             end
         BEGIN_READ_FROM_SD:
             begin
                 sel_mux_spi = 1;
                 spi_rst = 1;
                 if(spi_busy == 1'b1)
                     next_state = WAIT_RST_SPI;
             end
         WAIT_RST_SPI:
             begin
                 sel_mux_spi = 1;
                 //if(counter_timer_o != 32'h0)
                   //  next_state = SEL_WRITE_SD_BLOCK;
                 if(spi_busy == 1'b0)
                     next_state = SEL_SD_BLOCK;

             end
         SEL_SD_BLOCK:
             begin
                 sel_mux_spi = 1;
                 spi_r_block = 1;
                 if(spi_busy == 1)
                     next_state = WAIT_BLOCK;
             end
         WAIT_BLOCK:
             begin
                 sel_mux_spi = 1;
 		        spi_r_block = 1;
 		        if(spi_busy == 1'b0)
                     next_state = READ_DATA;
             end
         READ_DATA:
             begin
                 sel_mux_spi = 1;
 		        spi_r_block = 1;

                 next_state = READ_BYTE;
 		        case(counter_bytes_o)
 		          32'h0:reg_signature_data_0_w = 1;
                   32'h1:reg_signature_data_1_w = 1;
                   32'h2:reg_signature_data_2_w = 1;
                   32'h3:reg_signature_data_3_w = 1;
                   32'h4:reg_global_clk_w = 1;
                   //32'h5:reg_ddr_clk_w = 1;
                   32'h5:reg_sclk_w = 1;
                   32'h6:reg_cmd18_w = 1;
                   default:
                     begin
                         reg_gl_clk_w = 1;
                         next_state = CHECK_SIGNATURE;
                     end
 		        endcase
             end
         READ_BYTE:
             begin
                 sel_mux_spi = 1;
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
                 sel_mux_spi = 1;
                 spi_r_block = 1;
                 if(spi_busy == 1'b0)
                 begin
                     next_state = READ_DATA;
                 end
             end
         CHECK_SIGNATURE:
             begin

               if(signature == 32'hAABBCCDD && counter_divclk_o > 8'h10)
               begin
                 next_state = START_TEST;
               end

               //else
                 //next_state = IDLE;
             end
          START_TEST:
             begin
               start_boot_proccess = 1;
               next_state = WAIT_UNTIL_END_TEST_OR_TIMEOUT;
             end
          WAIT_UNTIL_END_TEST_OR_TIMEOUT:
             begin
               start_boot_proccess = 1;
               up_timer_counter = 1;
               if(finish_boot_process)
                 next_state = END_TEST;
               else if(counter_timer_o >= 32'h6E00000)
                 next_state = END_TEST;

             end
          END_TEST:
             begin
               rst_n_boot_proccess = 0;
               rst_bytes_counter = 1;
               if(spi_busy == 1'b0)
                   next_state = SEL_WRITE_SD_BLOCK;
               //else
               //    next_state = BEGIN_READ_FROM_SD;

             end
          SEL_WRITE_SD_BLOCK:
             begin
                 //rst_n_boot_proccess = 1;
                 sel_mux_spi = 1;
                 spi_w_block = 1;
                 next_state = WAIT_W_BLOCK;
             end
          WAIT_W_BLOCK:
             begin
                 //rst_n_boot_proccess = 1;
                 sel_mux_spi = 1;
                 spi_w_block = 1;
                 if(spi_busy == 1'b0)
                     next_state = WRITE_DATA;
             end
          WRITE_DATA:
             begin
                 //rst_n_boot_proccess = 1;
                 sel_mux_spi = 1;
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
                   32'h4: reg_spi_data_in = reg_global_clk_o;
                   //32'h5: reg_spi_data_in = reg_ddr_clk_o;
                   32'h5: reg_spi_data_in = reg_sclk_o;
                   32'h6: reg_spi_data_in = reg_cmd18_o;
                   32'h7: reg_spi_data_in = counter_timer_o[31:24];
                   32'h8: reg_spi_data_in = counter_timer_o[23:16];
                   32'h9: reg_spi_data_in = counter_timer_o[15:8];
                   32'ha: reg_spi_data_in = counter_timer_o[7:0];
                   32'h203:
                     begin
                         reg_gl_clk_cl = 1;
                         next_state = UPDATE_BLOCK_COUNTER;
                         rst_bytes_counter = 1;
                     end
                   default:reg_spi_data_in = 8'h00;
                 endcase
             end
          WAIT_W_BYTE:
             begin
                 //rst_n_boot_proccess = 1;
                 sel_mux_spi = 1;
                 spi_w_block = 1;
                 if(spi_busy == 1'b0)
                 begin
                     up_bytes_counter = 1;
                     next_state = WRITE_DATA;
                 end
             end
          UPDATE_BLOCK_COUNTER:
             begin
                 sel_mux_spi = 1;
                 //
                 rst_nanofs = 1;
                 rst_timer_counter = 1;
                 up_bytes_counter = 1;
                 rst_n_boot_proccess = 0;

                 if(counter_timer_o == 32'h0 && counter_bytes_o > 32'hF0000)
                 begin
                     up_block_counter = 1;

                     next_state = IDLE;
                 end

             end

     endcase
 end

 always @(posedge clk)
 begin
     if(rst_n == 0)
         current_state <= IDLE;
     else
         current_state <= next_state;
 end



 endmodule
