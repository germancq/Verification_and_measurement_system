/**
 * @Author: German Cano Quiveu <germancq>
 * @Date:   2019-03-01T13:21:14+01:00
 * @Email:  germancq@dte.us.es
 * @Filename: fsm_autotest.v
 * @Last modified by:   germancq
 * @Last modified time: 2019-04-05T13:26:09+02:00
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
     output reg rst_uut,
     //uut paramters signals
     output [63:0] block_i_uut,
     output [79:0] key_uut,
     output encdec_uut,
     //uut results signals
     input [63:0] block_o_uut,
     input  end_key_signal_uut,
     input end_dec_uut,
     input end_enc_uut,
     //debug
     output [31:0] debug_signal
     );

assign debug_signal = {counter_block_o[7:0],3'h0,current_state};

genvar i;

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
 reg [0:0] reg_signature_cl[3:0];
 reg [0:0] reg_signature_w[3:0];
 generate
    for (i=0;i<4;i=i+1) begin
        registro reg_signature_i(
            .clk(clk),
            .cl(reg_signature_cl[i]),
            .w(reg_signature_w[i]),
            .din(spi_data_out),
            .dout(signature[(i<<3)+1:(i<<3)])
        );
    end
 endgenerate
 /*
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
    */
 //////////iteration register///////////////////////
 reg reg_iteration_cl;
 reg reg_iteration_w;
 wire [7:0] reg_iteration_o;
 registro reg_iteration(
 	.clk(clk),
 	.cl(reg_iteration_cl),
 	.w(reg_iteration_w),
 	.din(spi_data_out),
 	.dout(reg_iteration_o)
 );


///////////////////////////////////////////////////////////////////

//////////uut specific registers///////////////////////
  /////////////block_i_uut////////////////
  
  
  reg [0:0] reg_block_i_uut_cl[7:0];
  reg [0:0] reg_block_i_uut_w[7:0];
  generate
    for (i=0;i<8;i=i+1) begin
            registro reg_block_i_uut_i(
                .clk(clk),
                .cl(reg_block_i_uut_cl[i]),
                .w(reg_block_i_uut_w[i]),
                .din(spi_data_out),
                .dout(block_i_uut[(i<<3)+1:(i<<3)])
            );
    end
  endgenerate
  /*
  wire [7:0] block_i_0,
             block_i_1,
             block_i_2,
             block_i_3,
             block_i_4,
             block_i_5,
             block_i_6,
             block_i_7;
  
  assign block_i_uut = {block_i_0,block_i_1,block_i_2,block_i_3,block_i_4,block_i_5,block_i_6,block_i_7};

  reg reg_block_i_0_cl;
  reg reg_block_i_0_w;
  registro reg_din_0(
  	.clk(clk),
  	.cl(reg_block_i_0_cl),
  	.w(reg_block_i_0_w),
  	.din(spi_data_out),
  	.dout(block_i_0)
  );
  reg reg_block_i_1_cl;
  reg reg_block_i_1_w;
  registro reg_din_1(
  	.clk(clk),
  	.cl(reg_block_i_1_cl),
  	.w(reg_block_i_1_w),
  	.din(spi_data_out),
  	.dout(block_i_1)
  );
  reg reg_block_i_2_cl;
  reg reg_block_i_2_w;
  registro reg_din_2(
  	.clk(clk),
  	.cl(reg_block_i_2_cl),
  	.w(reg_block_i_2_w),
  	.din(spi_data_out),
  	.dout(block_i_2)
  );
  reg reg_block_i_3_cl;
  reg reg_block_i_3_w;
  registro reg_din_3(
  	.clk(clk),
  	.cl(reg_block_i_3_cl),
  	.w(reg_block_i_3_w),
  	.din(spi_data_out),
  	.dout(block_i_3)
  );
  reg reg_block_i_4_cl;
  reg reg_block_i_4_w;
  registro reg_din_4(
  	.clk(clk),
  	.cl(reg_block_i_4_cl),
  	.w(reg_block_i_4_w),
  	.din(spi_data_out),
  	.dout(block_i_4)
  );
  reg reg_block_i_5_cl;
  reg reg_block_i_5_w;
  registro reg_din_5(
  	.clk(clk),
  	.cl(reg_block_i_5_cl),
  	.w(reg_block_i_5_w),
  	.din(spi_data_out),
  	.dout(block_i_5)
  );
  reg reg_block_i_6_cl;
  reg reg_block_i_6_w;
  registro reg_din_6(
  	.clk(clk),
  	.cl(reg_block_i_6_cl),
  	.w(reg_block_i_6_w),
  	.din(spi_data_out),
  	.dout(block_i_6)
  );
  reg reg_block_i_7_cl;
  reg reg_block_i_7_w;
  registro reg_din_7(
  	.clk(clk),
  	.cl(reg_block_i_7_cl),
  	.w(reg_block_i_7_w),
  	.din(spi_data_out),
  	.dout(block_i_7)
  );
  */
  /////////////key_uut////////////////

  reg [0:0] reg_key_uut_cl[9:0];
  reg [0:0] reg_key_uut_w[9:0];
  generate
    for (i=0;i<10;i=i+1) begin
            registro reg_key_uut_i(
                .clk(clk),
                .cl(reg_key_uut_cl[i]),
                .w(reg_key_uut_w[i]),
                .din(spi_data_out),
                .dout(key_uut[(i<<3)+1:(i<<3)])
            );
    end
  endgenerate  

  /*
  wire [7:0] key_uut_0,
             key_uut_1,
             key_uut_2,
             key_uut_3,
             key_uut_4,
             key_uut_5,
             key_uut_6,
             key_uut_7,
             key_uut_8,
             key_uut_9;
  
  assign key_uut = {key_uut_0,key_uut_1,key_uut_2,key_uut_3,key_uut_4,key_uut_5,key_uut_6,key_uut_7,key_uut_8,key_uut_9};

  reg reg_key_uut_0_cl;
  reg reg_key_uut_0_w;
  registro reg_key_uut_0(
  	.clk(clk),
  	.cl(reg_key_uut_0_cl),
  	.w(reg_key_uut_0_w),
  	.din(spi_data_out),
  	.dout(key_uut_0)
  );
  reg reg_key_uut_1_cl;
  reg reg_key_uut_1_w;
  registro reg_key_uut_1(
  	.clk(clk),
  	.cl(reg_key_uut_1_cl),
  	.w(reg_key_uut_1_w),
  	.din(spi_data_out),
  	.dout(key_uut_1)
  );
  reg reg_key_uut_2_cl;
  reg reg_key_uut_2_w;
  registro reg_key_uut_2(
  	.clk(clk),
  	.cl(reg_key_uut_2_cl),
  	.w(reg_key_uut_2_w),
  	.din(spi_data_out),
  	.dout(key_uut_2)
  );
  reg reg_key_uut_3_cl;
  reg reg_key_uut_3_w;
  registro reg_key_uut_3(
  	.clk(clk),
  	.cl(reg_key_uut_3_cl),
  	.w(reg_key_uut_3_w),
  	.din(spi_data_out),
  	.dout(key_uut_3)
  );
  reg reg_key_uut_4_cl;
  reg reg_key_uut_4_w;
  registro reg_key_uut_4(
  	.clk(clk),
  	.cl(reg_key_uut_4_cl),
  	.w(reg_key_uut_4_w),
  	.din(spi_data_out),
  	.dout(key_uut_4)
  );
  reg reg_key_uut_5_cl;
  reg reg_key_uut_5_w;
  registro reg_key_uut_5(
  	.clk(clk),
  	.cl(reg_key_uut_5_cl),
  	.w(reg_key_uut_5_w),
  	.din(spi_data_out),
  	.dout(key_uut_5)
  );
  reg reg_key_uut_6_cl;
  reg reg_key_uut_6_w;
  registro reg_key_uut_6(
  	.clk(clk),
  	.cl(reg_key_uut_6_cl),
  	.w(reg_key_uut_6_w),
  	.din(spi_data_out),
  	.dout(key_uut_6)
  );
  reg reg_key_uut_7_cl;
  reg reg_key_uut_7_w;
  registro reg_key_uut_7(
  	.clk(clk),
  	.cl(reg_key_uut_7_cl),
  	.w(reg_key_uut_7_w),
  	.din(spi_data_out),
  	.dout(key_uut_7)
  );
  reg reg_key_uut_8_cl;
  reg reg_key_uut_8_w;
  registro reg_key_uut_8(
  	.clk(clk),
  	.cl(reg_key_uut_8_cl),
  	.w(reg_key_uut_8_w),
  	.din(spi_data_out),
  	.dout(key_uut_8)
  );
  reg reg_key_uut_9_cl;
  reg reg_key_uut_9_w;
  registro reg_key_uut_9(
  	.clk(clk),
  	.cl(reg_key_uut_9_cl),
  	.w(reg_key_uut_9_w),
  	.din(spi_data_out),
  	.dout(key_uut_9)
  );
  */
  //////////////encdec_uut////////////
  //wire[7:0] encdec_uut_o;
  reg reg_encdec_uut_o_cl;
  reg reg_encdec_uut_o_w;
  registro reg_encdec_uut_o_0(
  	.clk(clk),
  	.cl(reg_encdec_uut_o_cl),
  	.w(reg_encdec_uut_o_w),
  	.din(spi_data_out),
  	.dout(encdec_uut)
  );

  //////////////block_o_uut////////////
  wire[63:0] block_o_uut_o;
  reg reg_block_o_uut_o_cl;
  reg reg_block_o_uut_o_w;
  registro #(.WIDTH(64))reg_output_from_UUT_2_o_0(
  	.clk(clk),
  	.cl(reg_block_o_uut_o_cl),
  	.w(reg_block_o_uut_o_w),
  	.din(block_o_uut),
  	.dout(block_o_uut_o)
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


 ///////////////iter_counter////////////////
 reg up_iter_counter;
 wire [31:0] counter_iter_o;
 reg rst_iter_counter;
 wire [31:0] base_iter;
 assign base_iter = ((counter_iter_o + 2) << 3);
 contador_up counter_iter_block(
    .clk(clk),
    .rst(rst_iter_counter),
    .up(up_iter_counter),
    .q(counter_iter_o)
 );


 ///////////////memory////////////////
 reg memory_inst_write;
 wire [7:0] memory_inst_o;

 memory_bank memory_inst(
    .clk(clk),
    .addr(counter_bytes_o),
    .write(memory_inst_write),
    .data_in(spi_data_out),
    .data_out(memory_inst_o)
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

     up_iter_counter = 0;
     rst_iter_counter = 0;


     spi_r_block = 0;
     spi_r_byte = 0;
     spi_r_multi_block = 0;
     spi_rst = 0;
     spi_w_block = 0;
     spi_w_byte = 0;

     memory_inst_write = 0;


     rst_uut = 0;

     reg_signature_cl[0] = 0;
     reg_signature_w[0] = 0;
     reg_signature_cl[1] = 0;
     reg_signature_w[1] = 0;
     reg_signature_cl[2] = 0;
     reg_signature_w[2] = 0;
     reg_signature_cl[3] = 0;
     reg_signature_w[3] = 0;

     reg_iteration_cl = 0;
     reg_iteration_w = 0;

     reg_block_i_uut_cl[0] = 0;
     reg_block_i_uut_w[0] = 0;
     reg_block_i_uut_cl[1] = 0;
     reg_block_i_uut_w[1] = 0;
     reg_block_i_uut_cl[2] = 0;
     reg_block_i_uut_w[2] = 0;
     reg_block_i_uut_cl[3] = 0;
     reg_block_i_uut_w[3] = 0;
     reg_block_i_uut_cl[4] = 0;
     reg_block_i_uut_w[4] = 0;
     reg_block_i_uut_cl[5] = 0;
     reg_block_i_uut_w[5] = 0;
     reg_block_i_uut_cl[6] = 0;
     reg_block_i_uut_w[6] = 0;
     reg_block_i_uut_cl[7] = 0;
     reg_block_i_uut_w[7] = 0;
     

     reg_key_uut_cl[0] = 0;
     reg_key_uut_w[0] = 0;
     reg_key_uut_cl[1] = 0;
     reg_key_uut_w[1] = 0;
     reg_key_uut_cl[2] = 0;
     reg_key_uut_w[2] = 0;
     reg_key_uut_cl[3] = 0;
     reg_key_uut_w[3] = 0;
     reg_key_uut_cl[4] = 0;
     reg_key_uut_w[4] = 0;
     reg_key_uut_cl[5] = 0;
     reg_key_uut_w[5] = 0;
     reg_key_uut_cl[6] = 0;
     reg_key_uut_w[6] = 0;
     reg_key_uut_cl[7] = 0;
     reg_key_uut_w[7] = 0;
     reg_key_uut_cl[8] = 0;
     reg_key_uut_w[8] = 0;
     reg_key_uut_cl[9] = 0;
     reg_key_uut_w[9] = 0;
     

     reg_encdec_uut_o_cl = 0;
     reg_encdec_uut_o_w = 0;
     

     reg_block_o_uut_o_cl = 0;
     reg_block_o_uut_o_w = 0;


     reg_spi_data_cl = 0;
     reg_spi_data_w = 0;
     reg_spi_data_in = 8'hff;

     case(current_state)
         IDLE:
             begin

                 rst_timer_counter = 1;
                 rst_iter_counter = 1;
                 rst_bytes_counter = 1;

                 rst_uut = 1;

                 reg_signature_cl[0] = 1;
                 reg_signature_cl[1] = 1;
                 reg_signature_cl[2] = 1;
                 reg_signature_cl[3] = 1;

                 reg_iteration_cl = 1;

                 reg_block_i_uut_cl[0] = 1;
                 reg_block_i_uut_cl[1] = 1;
                 reg_block_i_uut_cl[2] = 1;
                 reg_block_i_uut_cl[3] = 1;
                 reg_block_i_uut_cl[4] = 1;
                 reg_block_i_uut_cl[5] = 1;
                 reg_block_i_uut_cl[6] = 1;
                 reg_block_i_uut_cl[7] = 1;

                 reg_key_uut_cl[0] = 1;
                 reg_key_uut_cl[1] = 1;
                 reg_key_uut_cl[2] = 1;
                 reg_key_uut_cl[3] = 1;
                 reg_key_uut_cl[4] = 1;
                 reg_key_uut_cl[5] = 1;
                 reg_key_uut_cl[6] = 1;
                 reg_key_uut_cl[7] = 1;
                 reg_key_uut_cl[8] = 1;
                 reg_key_uut_cl[9] = 1;

                 reg_encdec_uut_o_cl = 1;


                 reg_block_o_uut_o_cl = 1;
                 

                 reg_spi_data_cl = 1;

                 next_state = BEGIN_READ_FROM_SD;
             end
         BEGIN_READ_FROM_SD:
             begin
                 rst_uut = 1;
                 spi_rst = 1;
                 if(spi_busy == 1'b1)
                     next_state = WAIT_RST_SPI;
             end
         WAIT_RST_SPI:
             begin
                 rst_uut = 1;
                 if(spi_busy == 1'b0)
                     next_state = SEL_SD_BLOCK;

             end
         SEL_SD_BLOCK:
             begin
                 rst_uut = 1;
                 spi_r_block = 1;
                 if(spi_busy == 1)
                     next_state = WAIT_BLOCK;
             end
         WAIT_BLOCK:
             begin
                 rst_uut = 1;
     		         spi_r_block = 1;
     		         if(spi_busy == 1'b0)
                         next_state = READ_DATA;
             end
         READ_DATA:
             begin
                 rst_uut = 1;
 		             spi_r_block = 1;

                 next_state = READ_BYTE;

                case(counter_bytes_o)
                    32'h0:reg_signature_w[0] = 1;
                    32'h1:reg_signature_w[1] = 1;
                    32'h2:reg_signature_w[2] = 1;
                    32'h3:reg_signature_w[3] = 1;
                    32'h4:reg_iteration_w = 1;
                    32'h5:reg_block_i_uut_w[0] = 1;
                    32'h6:reg_block_i_uut_w[1] = 1;
                    32'h7:reg_block_i_uut_w[2] = 1;
                    32'h8:reg_block_i_uut_w[3] = 1;
                    32'h9:reg_block_i_uut_w[4] = 1;
                    32'hA:reg_block_i_uut_w[5] = 1;
                    32'hB:reg_block_i_uut_w[6] = 1;
                    32'hC:reg_block_i_uut_w[7] = 1;
                    32'hD:reg_key_uut_w[0] = 1;
                    32'hE:reg_key_uut_w[1] = 1;
                    32'hF:reg_key_uut_w[2] = 1;
                    32'h10:reg_key_uut_w[3] = 1;
                    32'h11:reg_key_uut_w[4] = 1;
                    32'h12:reg_key_uut_w[5] = 1;
                    32'h13:reg_key_uut_w[6] = 1;
                    32'h14:reg_key_uut_w[7] = 1;
                    32'h15:reg_key_uut_w[8] = 1;
                    32'h16:reg_key_uut_w[9] = 1;
                    32'h17:reg_encdec_uut_o_w = 1;
                    32'h200: next_state = CHECK_SIGNATURE;
                    default:
                        begin
                            memory_inst_write = 1;
                        end
                endcase
             end
         READ_BYTE:
             begin
                 rst_uut = 1;
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
                 rst_uut = 1;
                 spi_r_block = 1;
                 if(spi_busy == 1'b0)
                 begin
                     next_state = READ_DATA;
                 end
             end
         CHECK_SIGNATURE:
             begin
               rst_uut = 1;
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

               if(counter_timer_o >= 32'h6E00000) begin
                    next_state = END_TEST;
               end  
               else if(encdec_uut) begin
                    if(end_dec_uut) begin
                        next_state = END_TEST;
                    end   
               end
               else if(encdec_uut == 0) begin
                    if(end_enc_uut) begin
                        next_state = END_TEST;
                    end    
               end
               
                 
               

             end
          END_TEST:
             begin
               reg_block_o_uut_o_w = 1;
               rst_bytes_counter = 1;
               if(spi_busy == 1'b0)
                   next_state = SEL_WRITE_SD_BLOCK;


             end
          SEL_WRITE_SD_BLOCK:
             begin
                 reg_block_o_uut_o_w = 1;
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
                   32'h0: reg_spi_data_in = signature[31:24];
                   32'h1: reg_spi_data_in = signature[23:16];
                   32'h2: reg_spi_data_in = signature[15:8];
                   32'h3: reg_spi_data_in = signature[7:0];
                   32'h4: reg_spi_data_in = reg_iteration_o;
                   32'h5: reg_spi_data_in = block_i_uut[63:56];
                   32'h6: reg_spi_data_in = block_i_uut[55:48];
                   32'h7: reg_spi_data_in = block_i_uut[47:40];
                   32'h8: reg_spi_data_in = block_i_uut[39:32];
                   32'h9: reg_spi_data_in = block_i_uut[31:24];
                   32'hA: reg_spi_data_in = block_i_uut[23:16];
                   32'hB: reg_spi_data_in = block_i_uut[15:8];
                   32'hC: reg_spi_data_in = block_i_uut[7:0];
                   32'hD: reg_spi_data_in = key_uut[79:72];
                   32'hE: reg_spi_data_in = key_uut[71:64];
                   32'hF: reg_spi_data_in = key_uut[63:56];
                   32'h10: reg_spi_data_in = key_uut[55:48];
                   32'h11: reg_spi_data_in = key_uut[47:40];
                   32'h12: reg_spi_data_in = key_uut[39:32];
                   32'h13: reg_spi_data_in = key_uut[31:24];
                   32'h14: reg_spi_data_in = key_uut[23:16];
                   32'h15: reg_spi_data_in = key_uut[15:8];
                   32'h16: reg_spi_data_in = key_uut[7:0];
                   32'h17: reg_spi_data_in = encdec_uut;
                   32'h18 : reg_spi_data_in = block_o_uut_o[7:0];
                   32'h19 : reg_spi_data_in = block_o_uut_o[15:8];
                   32'h1A : reg_spi_data_in = block_o_uut_o[23:16];
                   32'h1B : reg_spi_data_in = block_o_uut_o[31:24];
                   32'h1C : reg_spi_data_in = block_o_uut_o[39:32];
                   32'h1D : reg_spi_data_in = block_o_uut_o[47:40];
                   32'h1E : reg_spi_data_in = block_o_uut_o[55:48];
                   32'h1F : reg_spi_data_in = block_o_uut_o[63:56];
                   32'h200:;
                   32'h201:;
                   32'h202:;
                   32'h203:
                     begin
                         next_state = UPDATE_BLOCK_COUNTER;
                         rst_bytes_counter = 1;
                         up_iter_counter = 1;
                     end
                   default: reg_spi_data_in = memory_inst_o;
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

                 rst_uut = 1;
                 rst_timer_counter = 1;
                 up_bytes_counter = 1;

                 if(counter_timer_o == 32'h0 && counter_bytes_o > 32'hF0000)
                 begin
                    if(reg_iteration_o > counter_iter_o)
                      begin
                        rst_bytes_counter = 1;
                        next_state = BEGIN_READ_FROM_SD;
                      end
                    else
                      begin
                        up_block_counter = 1;
                        next_state = IDLE;
                      end
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
