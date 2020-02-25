/**
 * @Author: German Cano Quiveu <germancq>
 * @Date:   2019-03-06T17:31:00+01:00
 * @Email:  germancq@dte.us.es
 * @Filename: sdspi_system.v
 * @Last modified by:   germancq
 * @Last modified time: 2019-03-08T15:27:09+01:00
 */
module sdspi_system(
  input clk,
  input rst,

  input start,
  output reg finish,


  input [31:0] n_blocks,
  input cmd18,
  input [4:0] sclk_speed,

  output sclk,
  output cs,
  output mosi,
  input miso,

  output SD_RESET,
  output SD_DAT_1,
  output SD_DAT_2

  );

  reg spi_rst;
  wire spi_busy;
  reg spi_r_byte;
  reg spi_r_multi_block;
  reg spi_r_block;
  wire [31:0] spi_block_addr;

  sdspihost sdspi_inst(
    .clk(clk),
    .reset(spi_rst),
    .busy(spi_busy),
    .err(),
    .crc_err(),

    .r_block(spi_r_block),
    .r_multi_block(spi_r_multi_block),
    .r_byte(spi_r_byte),
    .w_block(0),
    .w_byte(0),
    .block_addr(spi_block_addr),
    .data_out(),
    .data_in(8'h00),


    //SPI interface
    .miso(miso),
    .mosi(mosi),
    .sclk(sclk),
    .ss(cs),
    ////
    .sclk_speed(sclk_speed),

    
    .debug()
  );

  /**
    1 - Rst sdspi y esperar a IDLE
    2 - r_block con start_addr + counter_addr_o
    3 -
      a)leer hasta n_block*512 sii cmd18 = 1
      b)leer 512 bytes sii cmd18 = 0
    4 -
      a)finalizar sii cmd18 = 1
      b)finalizar si counter_addr_o == n_blocks
          b.1)up_addr = 1 e ir paso 2
  **/


wire [31:0] counter_addr_o;
reg counter_addr_rst;
reg counter_addr_up;
assign spi_block_addr = counter_addr_o;
contador_up counter_addr(
  .clk(clk),
  .rst(counter_addr_rst),
  .up(counter_addr_up),
  .q(counter_addr_o)
  );


reg counter_bytes_up;
wire [31:0] counter_bytes_o;
reg counter_bytes_rst;
contador_up counter_bytes(
   .clk(clk),
   .rst(counter_bytes_rst),
   .up(counter_bytes_up),
   .q(counter_bytes_o)
);

reg [3:0] current_state;
reg [3:0] next_state;

parameter IDLE = 4'h0;
parameter WAIT_RST_SPI = 4'h1;
parameter WAIT_FOR_SDSPI = 4'h2;
parameter SEL_SD_BLOCK = 4'h3;
parameter WAIT_BLOCK = 4'h4;
parameter READ_DATA = 4'h5;
parameter READ_BYTE = 4'h6;
parameter WAIT_BYTE = 4'h7;
parameter CHANGE_BLOCK = 4'h8;
parameter END_FSM = 4'h9;


always @ ( * )
begin

  next_state = current_state;

  finish = 1'b0;

  //spi
  spi_rst = 1'b0;
  spi_r_block = 1'b0;
  spi_r_multi_block = 1'b0;
  spi_r_byte = 1'b0;

  counter_addr_rst = 1'b0;
  counter_addr_up = 1'b0;

  counter_bytes_up = 1'b0;
  counter_bytes_rst = 1'b0;

  case(current_state)
    IDLE:
      begin
        spi_rst = 1'b1;
        counter_addr_rst = 1'b1;
        if(start == 1)
          next_state = WAIT_RST_SPI;
      end
    WAIT_RST_SPI:
      begin
        if(spi_busy == 1'b1)
          next_state = WAIT_FOR_SDSPI;
      end
    WAIT_FOR_SDSPI:
      begin
        if(spi_busy == 1'b0)
          next_state = SEL_SD_BLOCK;
      end
    SEL_SD_BLOCK:
      begin
        counter_bytes_rst = 1'b1;

        spi_r_block = ~cmd18;
        spi_r_multi_block = cmd18;
        if(spi_busy == 1'b1)
            next_state = WAIT_BLOCK;
      end
    WAIT_BLOCK:
      begin
        spi_r_block = ~cmd18;
        spi_r_multi_block = cmd18;
        if(spi_busy == 1'b0)
            next_state = READ_DATA;
      end
    READ_DATA:
      begin
        spi_r_block = ~cmd18;
        spi_r_multi_block = cmd18;

        next_state = READ_BYTE;

        if(cmd18)
          begin
            if(counter_bytes_o == (n_blocks<<9))
              next_state = END_FSM;
          end
        else
          begin
            if(counter_bytes_o == 32'h200)
            begin
              if(counter_addr_o == n_blocks)
                next_state = END_FSM;
              else
                next_state = CHANGE_BLOCK;
            end
          end
      end
    READ_BYTE:
      begin

        spi_r_block = ~cmd18;
        spi_r_multi_block = cmd18;
        spi_r_byte = 1;

        if(spi_busy == 1)
        begin
            next_state = WAIT_BYTE;
            counter_bytes_up = 1;
        end

      end
    WAIT_BYTE:
      begin
        spi_r_block = ~cmd18;
        spi_r_multi_block = cmd18;
        
        if(spi_busy == 1'b0)
        begin
            next_state = READ_DATA;
        end
      end
    CHANGE_BLOCK:
      begin
        counter_addr_up = 1'b1;
        next_state = SEL_SD_BLOCK;
      end
    END_FSM:
      begin
        finish = 1'b1;
      end
  endcase

end

always @ (posedge clk)
begin
  if(rst)
    current_state <= IDLE;
  else
    current_state <= next_state;
end

endmodule
