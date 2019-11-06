/**
 * @Author: German Cano Quiveu <germancq>
 * @Date:   2019-03-01T13:23:45+01:00
 * @Email:  germancq@dte.us.es
 * @Filename: sdspihost.v
 * @Last modified by:   germancq
 * @Last modified time: 2019-03-06T13:43:01+01:00
 */

 module sdspihost(
   input clk,
   input clk_spi,
   input reset,
   output reg busy,
   output reg err,
   output crc_err,

   input r_block,
   input r_multi_block,
   input r_byte,
   input w_block,
   input w_byte,
   input [31:0] block_addr,
   output [7:0] data_out,
   input [7:0] data_in,


   //SPI interface
   input miso,
   output mosi,
   output sclk,
   output ss,
   ////
   input [4:0] sclk_speed,

   output SD_RESET,
   output SD_DAT_1,
   output SD_DAT_2,
   output[31:0] debug
 );

 assign SD_RESET = 1'b0;
 assign SD_DAT_1 = 1'b1;
 assign SD_DAT_2 = 1'b1;




 //spi_master inteface
 wire[7:0] spi_in; // output from MUX
 //reg[7:0] spi_out;
 wire cs_spi;
 wire busy_spi;
 reg switch_sclk;
 wire w_data;

 spi_master spi_module(
   .clk(clk),
   .clk_spi(clk_spi),
   .ss_in(cs_spi),
   .w_data(w_data),
   .data_in(spi_in),
   .data_out(data_out),

   .w_conf(switch_sclk),
   .busy(busy_spi),

   ////spi signals
   .miso(miso),
   .mosi(mosi),
   .ss(ss),
   .sclk(sclk),
   .debug()
 );

 //sdcmd interface
 wire[7:0] spi_in_cmd_out;
 wire cs_cmd_spi;
 wire w_sdcmd_spi_data;
 reg w_cmd;
 wire sdcmd_busy;
 wire [39:0] response;
 wire [47:0] command;
 reg rst_sdcmd;
 sdcmd sdcmd_module(
   .clk(clk),
   .reset(rst_sdcmd),
   .w_cmd(w_cmd),
   .command(command),
   .response(response),
   .busy(sdcmd_busy),

   .spi_out_sdcmd_in(data_out),
   .spi_in_sdcmd_out(spi_in_cmd_out),
   .spi_busy(busy_spi),
   .w_spi_data(w_sdcmd_spi_data),
   .cs_spi(cs_cmd_spi),
   .debug()
 );

 reg spi_input_mux_ctl;
 reg[7:0] spi_in_internal_signal;
 generic_mux #(.DATA_WIDTH(8)) spi_input_mux(
   .a(spi_in_internal_signal_o),
   .b(spi_in_cmd_out),
   .c(spi_in),
   .ctl(spi_input_mux_ctl)
 );

 reg spi_cs_mux_ctl;
 reg cs_internal_signal;
 generic_mux #(.DATA_WIDTH(1)) spi_cs_mux(
   .a(cs_internal_signal),
   .b(cs_cmd_spi),
   .c(cs_spi),
   .ctl(spi_cs_mux_ctl)
 );

 reg spi_wdata_mux_ctl;
 reg w_data_internal;
 generic_mux #(.DATA_WIDTH(1)) spi_wdata_mux(
   .a(w_data_internal),
   .b(w_sdcmd_spi_data),
   .c(w_data),
   .ctl(spi_wdata_mux_ctl)
 );

 ////////////////////////////////

 wire [7:0] spi_in_internal_signal_o;
 reg spi_in_internal_signal_cl;
 reg spi_in_internal_signal_w;
 registro reg_spi_internal(
 	.clk(clk),
 	.cl(spi_in_internal_signal_cl),
 	.w(spi_in_internal_signal_w),
 	.din(spi_in_internal_signal),
 	.dout(spi_in_internal_signal_o)
 );

 //command register

 assign command = {command_5_o,command_4_o,command_3_o,command_2_o,command_1_o,command_0_o};

 wire [7:0] command_0_o;
 reg command_0_cl;
 reg command_0_w;
 reg [7:0] command_0_in;
 registro r_command_0(
 	.clk(clk),
 	.cl(command_0_cl),
 	.w(command_0_w),
 	.din(command_0_in),
 	.dout(command_0_o)
 );
 wire [7:0] command_1_o;
 reg command_1_cl;
 reg command_1_w;
 reg [7:0] command_1_in;
 registro r_command_1(
 	.clk(clk),
 	.cl(command_1_cl),
 	.w(command_1_w),
 	.din(command_1_in),
 	.dout(command_1_o)
 );
 wire [7:0] command_2_o;
 reg command_2_cl;
 reg command_2_w;
 reg [7:0] command_2_in;
 registro r_command_2(
 	.clk(clk),
 	.cl(command_2_cl),
 	.w(command_2_w),
 	.din(command_2_in),
 	.dout(command_2_o)
 );
 wire [7:0] command_3_o;
 reg command_3_cl;
 reg command_3_w;
 reg [7:0] command_3_in;
 registro r_command_3(
 	.clk(clk),
 	.cl(command_3_cl),
 	.w(command_3_w),
 	.din(command_3_in),
 	.dout(command_3_o)
 );
 wire [7:0] command_4_o;
 reg command_4_cl;
 reg command_4_w;
 reg [7:0] command_4_in;
 registro r_command_4(
 	.clk(clk),
 	.cl(command_4_cl),
 	.w(command_4_w),
 	.din(command_4_in),
 	.dout(command_4_o)
 );
 wire [7:0] command_5_o;
 reg command_5_cl;
 reg command_5_w;
 reg [7:0] command_5_in;
 registro r_command_5(
 	.clk(clk),
 	.cl(command_5_cl),
 	.w(command_5_w),
 	.din(command_5_in),
 	.dout(command_5_o)
 );


 reg up_counter;
 wire [31:0] counter_o;
 reg rst_counter;
 contador_up counter_wait(
    .clk(clk),
    .rst(rst_counter),
    .up(up_counter),
    .q(counter_o)
 );

 reg up_sclk_counter;
 wire [31:0] counter_sclk_o;
 reg rst_sclk_counter;
 contador_up counter_sclk(
    .clk(sclk),
    .rst(rst_sclk_counter),
    .up(up_sclk_counter),
    .q(counter_sclk_o)
 );


 reg r_block_prev;
 reg r_multi_block_prev;

 //21 estados
 reg[4:0] current_state;
 reg[4:0] next_state;

 wire [7:0] reg_state_prev;
 reg r_state_prev_cl;
 reg r_state_prev_w;
 registro r_state_prev_0(
     .clk(clk),
     .cl(r_state_prev_cl),
     .w(r_state_prev_w),
     .din({3'b000,current_state}),
     .dout(reg_state_prev)
 );

 reg crc_err_w;
 reg crc_err_cl;
 registro #(.WIDTH(1)) crc_err_reg(
     .clk(clk),
     .cl(crc_err_cl),
     .w(crc_err_w),
     .din(data_out[1]),
     .dout(crc_err)
 );

 wire [15:0] crc16;
 assign crc16 = 16'h7fa1;

 parameter INIT_0 = 5'h0;
 parameter WAIT_250_ms = 5'h1;
 parameter WAIT_74_CYC = 5'h2;
 parameter CMD0_0 = 5'h3;
 parameter CMD0_1 = 5'h4;
 parameter CMD8_0 = 5'h5;
 parameter CMD8_1 = 5'h6;
 parameter CMD55_0 = 5'h7;
 parameter CMD55_1 = 5'h8;
 parameter ACMD41_0 = 5'h9;
 parameter ACMD41_1 = 5'hA;
 parameter IDLE = 5'hB;
 parameter WAIT_BEFORE_READ = 5'hC;
 parameter CMD17_0 = 5'hD;
 parameter CMD17_1 = 5'hE;
 parameter CMD18_0 = 5'hF;
 parameter CMD18_1 = 5'h10;
 parameter CMD24_0 = 5'h11;
 parameter CMD24_1 = 5'h12;
 parameter CMD12_0 = 5'h13;
 parameter CMD12_1 =  5'h14;
 parameter WRITE_FE_TOKEN = 5'h15;
 parameter WAIT_FOR_BYTE_TO_WRITE = 5'h16;
 parameter WRITE_BYTE = 5'h17;
 parameter WAIT_WRITE_BLOCK_RSP = 5'h18;
 parameter WAIT_FE_TOKEN = 5'h19;
 parameter WAIT_BYTE = 5'h1A;
 parameter BYTE_READY = 5'h1B;
 parameter ABORT_READ = 5'h1C;
 parameter WAIT_CMD_RSP = 5'h1D;
 parameter WAIT_SPI = 5'h1E;
 parameter ERROR = 5'h1F;

 /*
   States of SD
     1) Power up
       - usaremos tambien identification clock rate , sclk_div rango[7-9] [390 KHz - 97.65 KHz]
       - wait 250 ms, a 50MHz(20ns) son 12500 ciclos, 0x30D4, a 100Mhz son 25000 ciclos, 0x61A8
       - wait max (74 ciclos SD clk , 1 ms), esos 74 ciclos con mosi = '1'
     2) Identification Mode (Idle State + Ready State + Identification State)
       - During the card identification process,
         the card shall operate in the SD clock frequency
         of the identification clock rate (100-400)KHz
       - CMD 0
       - CMD 8
       - CMD55+ACMD41 (bucle)
     3) data-transfer Mode
       - Ponemos la frecuencia 6.25-12.5 MHz
       - CMD 17 , read single block
 */

 always @ ( * )
 begin
     next_state = current_state;


     busy = 1;
     err = 0;

     rst_sdcmd = 0;
     w_cmd = 0;

     spi_input_mux_ctl = 0;
     spi_in_internal_signal = 8'hff;

     spi_cs_mux_ctl = 0;
     cs_internal_signal = 0;

     spi_wdata_mux_ctl = 0;
     w_data_internal = 0;

     switch_sclk = 0;

     r_state_prev_cl = 0;
     r_state_prev_w = 0;

     rst_counter = 0;
     up_counter = 0;

     rst_sclk_counter = 0;
     up_sclk_counter = 0;


     command_0_cl = 0;
     command_0_w = 0;
     command_0_in = 8'hFF;
     command_1_cl = 0;
     command_1_w = 0;
     command_1_in = 8'hFF;
     command_2_cl = 0;
     command_2_w = 0;
     command_2_in = 8'hFF;
     command_3_cl = 0;
     command_3_w = 0;
     command_3_in = 8'hFF;
     command_4_cl = 0;
     command_4_w = 0;
     command_4_in = 8'hFF;
     command_5_cl = 0;
     command_5_w = 0;
     command_5_in = 8'hFF;

     crc_err_w = 0;
     crc_err_cl = 0;

     spi_in_internal_signal_w = 0;
     spi_in_internal_signal_cl = 0;

     case(current_state)
       INIT_0:
         begin

           rst_sdcmd = 1;
           cs_internal_signal = 1;

           command_0_cl = 1;
           command_1_cl = 1;
           command_2_cl = 1;
           command_3_cl = 1;
           command_4_cl = 1;
           command_5_cl = 1;

           r_state_prev_cl = 1;

           rst_sclk_counter = 1;
           rst_counter = 1;

           spi_in_internal_signal = {3'h7,5'hB};
           switch_sclk = 1;

           spi_in_internal_signal_w = 1;

           next_state = WAIT_250_ms;


         end
       WAIT_250_ms:
         begin
           cs_internal_signal = 1;
           //spi_in_internal_signal = {3'h7,5'hB};
           up_counter = 1;


           if(counter_o == 32'd25000000)
           begin
             next_state = WAIT_74_CYC;
             rst_counter = 1;
           end
         end
       WAIT_74_CYC:
         begin
           r_state_prev_w = 1;
           spi_in_internal_signal = 8'hFF;
           spi_in_internal_signal_w = 1;
           up_counter = 1;
           w_data_internal = 1;
           next_state = WAIT_SPI;
           if(counter_o == 32'd16)
           begin
             cs_internal_signal = 0;
             next_state = CMD0_0;
           end
         end
       CMD0_0:
         begin

           spi_input_mux_ctl = 1;
           spi_cs_mux_ctl = 1;
           spi_wdata_mux_ctl = 1;
           rst_counter = 1;
           r_state_prev_w = 1;

           command_5_w = 1;
           command_5_in = {1'b0,1'b1,6'h0};
           command_4_w = 1;
           command_4_in = 8'h00;
           command_3_w = 1;
           command_3_in = 8'h00;
           command_2_w = 1;
           command_2_in = 8'h00;
           command_1_w = 1;
           command_1_in = 8'h00;
           command_0_w = 1;
           command_0_in = 8'h95;
           //command = {1'b0,1'b1,6'h0,32'h0,8'h95};
           w_cmd = 1'b1;

           if(sdcmd_busy == 1)
             next_state = WAIT_CMD_RSP;

         end
       CMD0_1:
         begin
           spi_input_mux_ctl = 1;
           spi_cs_mux_ctl = 1;
           spi_wdata_mux_ctl = 1;

           if(response[39:32] == 8'h1)
             next_state = CMD8_0;
           else
             next_state = ERROR;

         end
       CMD8_0:
         begin
           spi_input_mux_ctl = 1;
           spi_cs_mux_ctl = 1;
           spi_wdata_mux_ctl = 1;
           r_state_prev_w = 1;
           command_5_w = 1;
           command_5_in = {1'b0,1'b1,6'h8};
           command_4_w = 1;
           command_4_in = 8'h00;
           command_3_w = 1;
           command_3_in = 8'h00;
           command_2_w = 1;
           command_2_in = 8'h01;
           command_1_w = 1;
           command_1_in = 8'hAA;
           command_0_w = 1;
           command_0_in = 8'h87;
           //command = {1'b0,1'b1,6'h8,32'h1AA,8'h87};
           w_cmd = 1'b1;
           if(sdcmd_busy == 1)
             next_state = WAIT_CMD_RSP;
         end
       CMD8_1:
         begin
           spi_input_mux_ctl = 1;
           spi_cs_mux_ctl = 1;
           spi_wdata_mux_ctl = 1;

           if(response[39:32] == 8'h1) //&& response[7:0] == 8'hAA)
             next_state = CMD55_0;
           else
             next_state = ERROR;

         end
       CMD55_0:
         begin
           spi_input_mux_ctl = 1;
           spi_cs_mux_ctl = 1;
           spi_wdata_mux_ctl = 1;
           r_state_prev_w = 1;

           command_5_w = 1;
           command_5_in = {1'b0,1'b1,6'h37};
           command_4_w = 1;
           command_4_in = 8'h00;
           command_3_w = 1;
           command_3_in = 8'h00;
           command_2_w = 1;
           command_2_in = 8'h00;
           command_1_w = 1;
           command_1_in = 8'h00;
           command_0_w = 1;
           command_0_in = 8'h01;
           //command = {1'b0,1'b1,6'h37,32'h0,8'h1};
           w_cmd = 1;
           if(sdcmd_busy == 1)
             next_state = WAIT_CMD_RSP;
         end
       CMD55_1:
         begin
           spi_input_mux_ctl = 1;
           spi_cs_mux_ctl = 1;
           spi_wdata_mux_ctl = 1;
           if(response[39:32] == 8'h1)
             next_state = ACMD41_0;
           else
             next_state = ERROR;
         end
       ACMD41_0:
         begin
           spi_input_mux_ctl = 1;
           spi_cs_mux_ctl = 1;
           spi_wdata_mux_ctl = 1;
           r_state_prev_w = 1;

           command_5_w = 1;
           command_5_in = {1'b0,1'b1,6'h29};
           command_4_w = 1;
           command_4_in = 8'h40;
           command_3_w = 1;
           command_3_in = 8'h00;
           command_2_w = 1;
           command_2_in = 8'h00;
           command_1_w = 1;
           command_1_in = 8'h00;
           command_0_w = 1;
           command_0_in = 8'h01;
           //command = {1'b0,1'b1,6'h29,32'h0,8'h1};
           w_cmd = 1;
           if(sdcmd_busy == 1)
             next_state = WAIT_CMD_RSP;
         end
       ACMD41_1:
         begin
           spi_input_mux_ctl = 1;
           spi_cs_mux_ctl = 1;
           spi_wdata_mux_ctl = 1;
           up_counter = 1;
           if(response[39:32] == 8'h0)
           begin
             spi_in_internal_signal = {3'h4,sclk_speed};
             spi_in_internal_signal_w = 1;
             switch_sclk = 1;
             next_state = IDLE;
           end
           else
             if(counter_o == 32'hFF)
               next_state = ERROR;
             else
               next_state = CMD55_0;
         end
       IDLE:
         begin
           spi_in_internal_signal = {3'h4,sclk_speed};
           busy = 0;
           rst_counter = 1;

           if(r_block == 1)
             next_state = WAIT_BEFORE_READ;
           else if(r_multi_block == 1)
             next_state = WAIT_BEFORE_READ;
           else if(w_block == 1)
           begin
             next_state = WAIT_BEFORE_READ;
             crc_err_cl = 1;
           end
         end
       WAIT_BEFORE_READ:
         begin
             r_state_prev_w = 1;
             spi_in_internal_signal = 8'hFF;
             spi_in_internal_signal_w = 1;
             up_counter = 1;
             w_data_internal = 1;
             next_state = WAIT_SPI;

              //spi_in_internal_signal = {3'h7,5'h0};
              //rst_counter = 1;


             if(counter_o == 32'd16)
             begin
              if(r_block == 1)
                next_state = CMD17_0;
              else if(r_multi_block == 1)
                next_state = CMD18_0;
               else if(w_block == 1)
                 next_state = CMD24_0;
              end
         end
       CMD17_0:
         begin
           spi_input_mux_ctl = 1;
           spi_cs_mux_ctl = 1;
           spi_wdata_mux_ctl = 1;
           r_state_prev_w = 1;

           command_5_w = 1;
           command_5_in = {1'b0,1'b1,6'h11};
           command_4_w = 1;
           command_4_in = block_addr[31:24];
           command_3_w = 1;
           command_3_in = block_addr[23:16];
           command_2_w = 1;
           command_2_in = block_addr[15:8];
           command_1_w = 1;
           command_1_in = block_addr[7:0];
           command_0_w = 1;
           command_0_in = 8'h01;
           //command = {1'b0,1'b1,6'h11,block_addr,8'h1};

           w_cmd = 1;
           if(sdcmd_busy == 1)
             next_state = WAIT_CMD_RSP;
         end
       CMD17_1:
         begin
           spi_input_mux_ctl = 1;
           spi_cs_mux_ctl = 1;
           spi_wdata_mux_ctl = 1;

           if(response[39:32] != 8'h0)
             next_state = ERROR;
           else
             next_state = WAIT_FE_TOKEN;

         end
       CMD18_0:
         begin
           spi_input_mux_ctl = 1;
           spi_cs_mux_ctl = 1;
           spi_wdata_mux_ctl = 1;
           r_state_prev_w = 1;

           command_5_w = 1;
           command_5_in = {1'b0,1'b1,6'h12};
           command_4_w = 1;
           command_4_in = block_addr[31:24];
           command_3_w = 1;
           command_3_in = block_addr[23:16];
           command_2_w = 1;
           command_2_in = block_addr[15:8];
           command_1_w = 1;
           command_1_in = block_addr[7:0];
           command_0_w = 1;
           command_0_in = 8'h01;
           //command = {1'b0,1'b1,6'h11,block_addr,8'h1};

           w_cmd = 1;
           if(sdcmd_busy == 1)
             next_state = WAIT_CMD_RSP;
         end
       CMD18_1:
         begin
           spi_input_mux_ctl = 1;
           spi_cs_mux_ctl = 1;
           spi_wdata_mux_ctl = 1;

           if(response[39:32] != 8'h0)
             next_state = ERROR;
           else
             next_state = WAIT_FE_TOKEN;
         end
       CMD24_0:
         begin
           spi_input_mux_ctl = 1;
           spi_cs_mux_ctl = 1;
           spi_wdata_mux_ctl = 1;
           r_state_prev_w = 1;

           command_5_w = 1;
           command_5_in = {1'b0,1'b1,6'h18};
           command_4_w = 1;
           command_4_in = block_addr[31:24];
           command_3_w = 1;
           command_3_in = block_addr[23:16];
           command_2_w = 1;
           command_2_in = block_addr[15:8];
           command_1_w = 1;
           command_1_in = block_addr[7:0];
           command_0_w = 1;
           command_0_in = 8'h01;


           w_cmd = 1;
           if(sdcmd_busy == 1)
             next_state = WAIT_CMD_RSP;

         end
       CMD24_1:
         begin
           spi_input_mux_ctl = 1;
           spi_cs_mux_ctl = 1;
           spi_wdata_mux_ctl = 1;

           if(response[39:32] != 8'h0)
             next_state = CMD24_1;//ERROR;
           else
             next_state = WRITE_FE_TOKEN;

         end
       CMD12_0:
         begin
           spi_input_mux_ctl = 1;
           spi_cs_mux_ctl = 1;
           spi_wdata_mux_ctl = 1;
           r_state_prev_w = 1;

           command_5_w = 1;
           command_5_in = {1'b0,1'b1,6'hC};
           command_4_w = 1;
           command_4_in = 8'h0;
           command_3_w = 1;
           command_3_in = 8'h0;
           command_2_w = 1;
           command_2_in = 8'h0;
           command_1_w = 1;
           command_1_in = 8'h0;
           command_0_w = 1;
           command_0_in = 8'h01;
           //command = {1'b0,1'b1,6'h11,block_addr,8'h1};

           w_cmd = 1;

           if(sdcmd_busy == 1)
             next_state = WAIT_CMD_RSP;

         end
       CMD12_1:
         begin
           spi_input_mux_ctl = 1;
           spi_cs_mux_ctl = 1;
           spi_wdata_mux_ctl = 1;

           if(response[39:32] != 8'h0)
             next_state = ERROR;
           else
             next_state = IDLE;
         end
       WRITE_FE_TOKEN:
         begin

           spi_in_internal_signal = 8'hFE;
           spi_in_internal_signal_w = 1;
           w_data_internal = 1;
           rst_counter = 1;
           r_state_prev_w = 1;

           if(busy_spi == 1)
               next_state = WAIT_SPI;
           //next_state = WAIT_SPI;

         end
       WAIT_FOR_BYTE_TO_WRITE:
         begin
           busy = 0;
           //spi_in_internal_signal = 8'hDD;
           if(counter_o == 32'h202)
           begin
             next_state = WAIT_WRITE_BLOCK_RSP;
           end
           else if(w_byte == 1)
             begin
               next_state = WRITE_BYTE;
               up_counter = 1;
             end
         end
       WAIT_WRITE_BLOCK_RSP:
         begin
           spi_in_internal_signal = 8'hFF;
           spi_in_internal_signal_w = 1;
           w_data_internal = 1;
           r_state_prev_w = 1;
           next_state = WAIT_SPI;
           if(data_out != 8'hFF)
             begin
               crc_err_w = 1;
               //next_state = WAIT_WRITE_BLOCK_RSP;
               w_data_internal = 0;
               next_state = IDLE;
             end
         end
       WRITE_BYTE:
         begin
           spi_in_internal_signal = data_in;
           w_data_internal = 1;
           spi_in_internal_signal_w = 1;
           if(counter_o == 32'h201)
             spi_in_internal_signal = crc16[15:8];
           else if(counter_o == 32'h202)
             spi_in_internal_signal = crc16[7:0];

           r_state_prev_w = 1;
           if(busy_spi == 1)
             next_state = WAIT_SPI;
         end
       WAIT_FE_TOKEN:
         begin
           spi_in_internal_signal = 8'hFF;
           spi_in_internal_signal_w = 1;
           //up_counter = 1;
           w_data_internal = 1;
           r_state_prev_w = 1;
           rst_counter = 1;
           next_state = WAIT_SPI;
           if(data_out == 8'hFE)
             next_state = WAIT_BYTE;
         end
       WAIT_BYTE:
         begin

           spi_in_internal_signal = 8'hFF;
           spi_in_internal_signal_w = 1;
           w_data_internal = 1;
           r_state_prev_w = 1;
           next_state = WAIT_SPI;
           up_counter = 1;


         end
       BYTE_READY:
         begin
           busy = 0;

           if(r_block == 0 && r_block_prev == 1)
             next_state = ABORT_READ;
           else if(r_multi_block == 0 && r_multi_block_prev == 1)
             next_state = CMD12_0;
           else if(r_multi_block == 1 && counter_o > 32'h200)
             begin
               busy = 1;
               if(counter_o == 32'h204)
               begin
                 next_state = WAIT_FE_TOKEN;
                 rst_counter = 1;
               end

               next_state = WAIT_BYTE;
             end
           else if(r_byte == 1)
             next_state = WAIT_BYTE;
         end
       ABORT_READ:
         begin
           spi_in_internal_signal = 8'hFF;
           spi_in_internal_signal_w = 1;
           w_data_internal = 1;
           r_state_prev_w = 1;
           next_state = WAIT_SPI;
           up_counter = 1;
           //user_byte 0 => counter = 1 -> 512 bytes + 2 crc = 0-513 => 1-514

           if(counter_o == 32'h203) // 512 bytes user_data + 2 bytes de CRC
             begin
               next_state = IDLE;
             end

         end
       WAIT_CMD_RSP:
         begin
           spi_input_mux_ctl = 1;
           spi_cs_mux_ctl = 1;
           spi_wdata_mux_ctl = 1;
           if(sdcmd_busy == 0)
             next_state = reg_state_prev + 1;
         end
       WAIT_SPI:
         begin

           if(busy_spi == 0)
           begin
             next_state = reg_state_prev;
             if(reg_state_prev == WAIT_BYTE)
               next_state = BYTE_READY;
             else if(reg_state_prev == WRITE_BYTE)
               next_state = WAIT_FOR_BYTE_TO_WRITE;
             else if(reg_state_prev == WRITE_FE_TOKEN)
               next_state = WAIT_FOR_BYTE_TO_WRITE;
           end
         end
       ERROR:
         begin
            // spi_in_internal_signal = 8'hAB;
           err = 1;
         end
     endcase
 end


 always @ ( posedge clk )
 begin
   if(reset)
     current_state <= INIT_0;
   else
     begin
       current_state <= next_state;
       r_block_prev <= r_block;
       r_multi_block_prev <= r_multi_block;
     end
 end

 assign debug = {counter_o[7:0],spi_in,data_out,3'b000,current_state};

 endmodule
