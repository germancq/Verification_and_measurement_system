/**
 * @Author: German Cano Quiveu <germancq>
 * @Date:   2019-03-01T13:21:14+01:00
 * @Email:  germancq@dte.us.es
 * @Filename: fsm_autotest.v
 * @Last modified by:   germancq
 * @Last modified time: 2019-04-05T13:26:09+02:00
 */

 

 module fsm_autotest
 (
     input clk,
     input clk_counter,
     input rst,
     //sdspihost signals
     input spi_busy,
     output [31:0] spi_block_addr,
     input [7:0] spi_data_out,
     output logic spi_r_block,
     output logic spi_r_byte,
     output logic spi_r_multi_block,
     output logic spi_rst,
     input spi_err,
     output [7:0] spi_data_in,
     output logic spi_w_block,
     output logic spi_w_byte,
     input spi_crc_err,
     //uut ctrl signals
     output logic uut_ctrl_mux,
     output logic uut_rst,
     output logic uut_start,
     //uut paramters signals
     output [31:0] uut_n_blocks,
     output [4:0] uut_sclk_speed,
     output [0:0] uut_cmd18,
     //uut results signals
     input  uut_finish,
     //debug
     output [31:0] debug_signal
     );


    localparam N_BLOCK_SIZE = 32;
    localparam SCLK_SPEED_SIZE = 5;
    localparam CMD18_SIZE = 1;
    localparam START_BLOCK = 32'h0x100000;


genvar i;

 /////registro SPI ///////////////////
 reg reg_spi_data_cl;
 reg reg_spi_data_w;
 reg [7:0] reg_spi_data_in;
 register #(.DATA_WIDTH(8)) reg_spi_data(
 	.clk(clk),
 	.cl(reg_spi_data_cl),
 	.w(reg_spi_data_w),
 	.din(reg_spi_data_in),
 	.dout(spi_data_in)
 );

 //////////signature registers///////////////////////
 
 logic [31:0] signature;
 logic [0:0] reg_signature_cl[3:0];
 logic [0:0] reg_signature_w[3:0];
 generate
    for (i=0;i<4;i=i+1) begin
        register #(.DATA_WIDTH(8)) reg_signature_i(
            .clk(clk),
            .cl(reg_signature_cl[i]),
            .w(reg_signature_w[i]),
            .din(spi_data_out),
            .dout(signature[(i<<3)+7:(i<<3)])
        );
    end
 endgenerate

 //////////iteration register///////////////////////
 logic reg_iteration_cl;
 logic reg_iteration_w;
 logic [7:0] reg_iteration_o;
 register #(.DATA_WIDTH(8)) reg_iteration(
 	.clk(clk),
 	.cl(reg_iteration_cl),
 	.w(reg_iteration_w),
 	.din(spi_data_out),
 	.dout(reg_iteration_o)
 );


///////////////////////////////////////////////////////////////////

//////////uut specific registers///////////////////////
  /////////////input_to_UUT_1////////////////
 
 logic [0:0] reg_din_n_blocks_cl[(N_BLOCK_SIZE>>3)-1:0];
 logic [0:0] reg_din_n_blocks_w[(N_BLOCK_SIZE>>3)-1:0];
 generate
    for (i=0;i<(N_BLOCK_SIZE>>3);i=i+1) begin
        register #(.DATA_WIDTH(8)) reg_input_to_UUT_1_i(
            .clk(clk),
            .cl(reg_din_n_blocks_cl[i]),
            .w(reg_din_n_blocks_w[i]),
            .din(spi_data_out),
            .dout(uut_n_blocks[(i<<3)+7:(i<<3)])
        );
    end
 endgenerate

 /////////////input_to_UUT_2////////////////
 
 logic [0:0] reg_din_sclk_speed_cl[0:0];
 logic [0:0] reg_din_sclk_speed_w[0:0];
 generate
    for (i=0;i<1;i=i+1) begin
        register #(.DATA_WIDTH(8)) reg_input_to_UUT_2_i(
            .clk(clk),
            .cl(reg_din_sclk_speed_cl[i]),
            .w(reg_din_sclk_speed_w[i]),
            .din(spi_data_out),
            .dout(uut_sclk_speed[SCLK_SPEED_SIZE-1:0])
        );
    end
 endgenerate


 /////////////input_to_UUT_3////////////////
 
 logic [0:0] reg_din_cmd18_cl[0:0];
 logic [0:0] reg_din_cmd18_w[0:0];
 generate
    for (i=0;i<1;i=i+1) begin
        register #(.DATA_WIDTH(8)) reg_input_to_UUT_3_i(
            .clk(clk),
            .cl(reg_din_cmd18_cl[i]),
            .w(reg_din_cmd18_w[i]),
            .din(spi_data_out),
            .dout(uut_cmd18[CMD18_SIZE-1:0])
        );
    end
 endgenerate
 

///////////////timer//////////////////////
 logic up_timer_counter;
 logic [31:0] counter_timer_o;
 logic rst_timer_counter;
 counter #(.DATA_WIDTH(32)) counter_timer(
    .clk(clk_counter),
    .rst(rst_timer_counter),
    .up(up_timer_counter),
    .down(1'b0),
    .din(32'b0),
    .dout(counter_timer_o)
 );

 ///////////////block_counter////////////////
 logic up_block_counter;
 logic [31:0] counter_block_o;
 logic rst_block_counter;
 assign spi_block_addr = counter_block_o;// + 32'h0x00100000;
 counter #(.DATA_WIDTH(32)) counter_block(
    .clk(clk),
    .rst(rst_block_counter),
    .up(up_block_counter),
    .down(1'b0),
    .din(START_BLOCK),
    .dout(counter_block_o)
 );


 ///////////////iter_counter////////////////
 logic up_iter_counter;
 logic [31:0] counter_iter_o;
 logic rst_iter_counter;
 logic [31:0] base_iter;
 assign base_iter = ((counter_iter_o) * 4) ;
 counter #(.DATA_WIDTH(32)) counter_iter_block(
    .clk(clk),
    .rst(rst_iter_counter),
    .up(up_iter_counter),
    .down(1'b0),
    .din(32'b0),
    .dout(counter_iter_o)
 );

  ////////////bytes counter ////////////////////

 logic up_bytes_counter;
 logic [15:0] counter_bytes_o;
 logic rst_bytes_counter;
 counter #(.DATA_WIDTH(16)) counter_bytes(
    .clk(clk),
    .rst(rst_bytes_counter),
    .up(up_bytes_counter),
    .down(1'b0),
    .din(16'b0),
    .dout(counter_bytes_o)
 );

 //////////////index_counter////////////////////
 
 logic up_index;
 logic [7:0] index_o;
 logic rst_index;
 counter #(.DATA_WIDTH(8)) counter_index(
    .clk(clk),
    .rst(rst_index),
    .up(up_index),
    .down(1'b0),
    .din(8'h0),
    .dout(index_o)
 );


 ///////////////memory////////////////
 logic memory_inst_write;
 logic [7:0] memory_inst_o;

 memory_module #(.ADDR(16),
                 .DATA_WIDTH(8))
 memory_inst(
    .clk(clk),
    .addr(counter_bytes_o),
    .r_w(memory_inst_write),
    .din(spi_data_out),
    .dout(memory_inst_o)
 );






 ///////////////states/////////////////////
  logic [31:0] j;

  localparam INITIAL_CONDITION = 5'h0;
  localparam IDLE = 5'h1;
  localparam BEGIN_READ_FROM_SD = 5'h2;
  localparam WAIT_RST_SPI = 5'h3;
  localparam SEL_SD_BLOCK = 5'h4;
  localparam WAIT_BLOCK = 5'h5;
  localparam READ_DATA = 5'h6;
  localparam WAIT_BYTE = 5'h7;
  localparam READ_BYTE = 5'h8;
  localparam CHECK_SIGNATURE = 5'h9;
  localparam START_TEST = 5'hA;
  localparam WAIT_UNTIL_END_TEST_OR_TIMEOUT = 5'hB;
  localparam END_TEST = 5'hC;
  localparam SEL_WRITE_SD_BLOCK = 5'hD;
  localparam WAIT_W_BLOCK = 5'hE;
  localparam WRITE_DATA = 5'hF;
  localparam WAIT_W_BYTE = 5'h10;
  localparam UPDATE_BLOCK_COUNTER = 5'h11;
  localparam END_FSM = 5'h12;


 
 logic[4:0] current_state,next_state;

 always_comb begin
     next_state = current_state;

     up_block_counter = 0;
     rst_block_counter = 0;

     up_timer_counter = 0;
     rst_timer_counter = 0;

     up_bytes_counter = 0;
     rst_bytes_counter = 0;

     up_iter_counter = 0;
     rst_iter_counter = 0;

     rst_index = 0;
     up_index = 0;


     spi_r_block = 0;
     spi_r_byte = 0;
     spi_r_multi_block = 0;
     spi_rst = 0;
     spi_w_block = 0;
     spi_w_byte = 0;

     reg_spi_data_cl = 0;
     reg_spi_data_w = 0;
     reg_spi_data_in = 8'hff;

     memory_inst_write = 0;

     uut_ctrl_mux = 0;
     uut_rst = 0;
     uut_start = 0;
     

     for (j=0;j<4;j=j+1) begin
         reg_signature_cl[j] = 0;
         reg_signature_w[j] = 0;
     end

     reg_iteration_cl = 0;
     reg_iteration_w = 0;

     for (j=0;j<(N_BLOCK_SIZE>>3);j=j+1) begin
         reg_din_n_blocks_cl[j] = 0;
         reg_din_n_blocks_w[j] = 0;
     end

     reg_din_sclk_speed_cl[0] = 0;
     reg_din_sclk_speed_w[0] = 0;

     reg_din_cmd18_cl[0] = 0;
     reg_din_cmd18_w[0] = 0;
        

     case(current_state)
         INITIAL_CONDITION :
            begin
                rst_block_counter = 1;
                next_state = IDLE;
            end
         IDLE:
             begin

                 rst_timer_counter = 1;
                 rst_iter_counter = 1;
                 rst_bytes_counter = 1;
                 
                 rst_index = 1;

                 uut_rst = 1;

                 for (j=0;j<4;j=j+1) begin
                    reg_signature_cl[j] = 1;
                 end
                 

                 reg_iteration_cl = 1;

                 for (j=0;j<(N_BLOCK_SIZE>>3);j=j+1) begin
                    reg_din_n_blocks_cl[j] = 1;
                 end
                 

                 reg_din_sclk_speed_cl[0] = 1;
                 reg_din_cmd18_cl[0] = 1;
                 

                 reg_spi_data_cl = 1;

                 next_state = BEGIN_READ_FROM_SD;
             end
         BEGIN_READ_FROM_SD:
             begin
                 uut_rst = 1;
                 spi_rst = 1;
                 if(spi_busy == 1'b1)
                     next_state = WAIT_RST_SPI;
             end
         WAIT_RST_SPI:
             begin
                 uut_rst = 1;
                 if(spi_busy == 1'b0)
                     next_state = SEL_SD_BLOCK;

             end
         SEL_SD_BLOCK:
             begin
                 uut_rst = 1;
                 spi_r_block = 1;
                 if(spi_busy == 1)
                     next_state = WAIT_BLOCK;
             end
         WAIT_BLOCK:
             begin
                 uut_rst = 1;
                 spi_r_block = 1;
                 if(spi_busy == 1'b0)
                     next_state = READ_DATA;
             end
         READ_DATA:
             begin
                 uut_rst = 1;
 		         spi_r_block = 1;

                 next_state = READ_BYTE;
 		              case(counter_bytes_o)
 		                32'h0:reg_signature_w[3] = 1;
                        32'h1:reg_signature_w[2] = 1;
                        32'h2:reg_signature_w[1] = 1;
                        32'h3:reg_signature_w[0] = 1;
                        32'h4:reg_iteration_w = 1;
                        32'h5 + index_o : begin
                            reg_din_n_blocks_w[index_o] = 1'b1;
                            up_index = 1'b1;
                            if(index_o == (N_BLOCK_SIZE>>3)-1) begin
                                rst_index = 1'b1;
                            end
                        end
                        32'h5 + (N_BLOCK_SIZE>>3) : begin
                            reg_din_sclk_speed_w[0] = 1'b1;
                        end
                        32'h5 + (N_BLOCK_SIZE>>3) + 1 : begin
                            reg_din_cmd18_w[0] = 1'b1;
                        end
                        32'h200: next_state = CHECK_SIGNATURE;
                   default:
                     begin
                         memory_inst_write = 1;
                     end
 		        endcase
             end
         READ_BYTE:
             begin
                 uut_rst = 1;
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
                 uut_rst = 1;
                 spi_r_block = 1;
                 if(spi_busy == 1'b0)
                 begin
                     next_state = READ_DATA;
                 end
             end
         CHECK_SIGNATURE:
             begin
               uut_ctrl_mux = 1;
               if(signature == 32'hAABBCCDD)
               begin
                 next_state = START_TEST;
               end
               else
                 next_state = END_FSM;
             end
          START_TEST:
             begin
               uut_ctrl_mux = 1;
               uut_start = 1;
               next_state = WAIT_UNTIL_END_TEST_OR_TIMEOUT;
             end
          WAIT_UNTIL_END_TEST_OR_TIMEOUT:
             begin
               uut_ctrl_mux = 1;
               up_timer_counter = 1;
               uut_start = 1;
               if(uut_finish == 1'b1)
                 next_state = END_TEST;
               else if(counter_timer_o >= 32'h6E00000)
                 next_state = END_TEST;

             end
          END_TEST:
             begin
               rst_index = 1'b1;
               uut_ctrl_mux = 1;
               up_bytes_counter  = 1'b1;
               if(spi_busy == 1'b0 && counter_bytes_o > 16'hF000) begin
                   next_state = SEL_WRITE_SD_BLOCK;
                   rst_bytes_counter = 1;
               end    


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
                 
                 reg_spi_data_w = 1;
                 spi_w_block = 1;
                 
                  
                 spi_w_byte = 1;
                 if(spi_busy == 1'b1) begin
                     next_state = WAIT_W_BYTE;     
                 end 
                 

                 case(counter_bytes_o)
                   32'h0: reg_spi_data_in = signature[31:24];
                   32'h1: reg_spi_data_in = signature[23:16];
                   32'h2: reg_spi_data_in = signature[15:8];
                   32'h3: reg_spi_data_in = signature[7:0];
                   32'h4: reg_spi_data_in = reg_iteration_o;
                   32'h5 + index_o: begin
                                reg_spi_data_in = uut_n_blocks >> (index_o * 8);
                          end
                   32'h9: reg_spi_data_in = uut_sclk_speed;
                   32'hA: reg_spi_data_in = uut_cmd18;
                   32'hC + base_iter + index_o : reg_spi_data_in = counter_timer_o >> (index_o * 8);
                   32'h200:;
                   32'h201:;
                   32'h202:;
                   32'h203:
                     begin
                         next_state = UPDATE_BLOCK_COUNTER;
                         rst_bytes_counter = 1;
                         up_iter_counter = 1;
                     end
                   default: begin
                            reg_spi_data_in = memory_inst_o;
                            rst_index = 1'b1;
                        end
                 endcase
             end  
          WAIT_W_BYTE:
             begin
                 spi_w_block = 1;
                 
                 if(spi_busy == 1'b0)
                 begin
                     up_index = 1'b1;
                     if(counter_bytes_o == 32'h4) begin
                        rst_index = 1'b1;
                     end
                     else if(counter_bytes_o == 32'h5+((N_BLOCK_SIZE>>3)-1)) begin
                        rst_index = 1'b1;
                     end
                     else if(counter_bytes_o == 32'hC + base_iter - 1) begin
                        rst_index = 1'b1;
                     end
                     else if(counter_bytes_o == 32'hC + base_iter + 3) begin
                        rst_index = 1'b1;
                     end
                     up_bytes_counter = 1;
                     next_state = WRITE_DATA;
                 end
             end
          UPDATE_BLOCK_COUNTER:
             begin
                 rst_index = 1'b1;
                 rst_timer_counter = 1;
                 up_bytes_counter = 1;

                 if(counter_timer_o == 32'h0 && counter_bytes_o > 16'hF000)
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

 always_ff @(posedge clk)
 begin
     if(rst == 1)
         current_state <= INITIAL_CONDITION;
     else
         current_state <= next_state;
 end



 assign debug_signal = {counter_block_o[7:0],counter_iter_o[7:0],base_iter[7:0],3'h0,current_state};

 endmodule : fsm_autotest
