/**
 * @Author: German Cano Quiveu <germancq>
 * @Date:   2019-03-01T13:24:00+01:00
 * @Email:  germancq@dte.us.es
 * @Filename: spi_master.v
 * @Last modified by:   germancq
 * @Last modified time: 2019-03-01T13:24:42+01:00
 */

 module spi_master (
           input clk ,
           input clk_spi,
           input [7:0] data_in,
           output [7:0] data_out,
           input w_data,//0: read / 1: write
           input w_conf,//1: write_config, 0: write data
           input ss_in,// SPI SS

           output reg busy,// Data ready when not busy

           input miso,//SPI external connections
           output mosi,
           output sclk,
           output ss,
           output [31:0] debug
   );

 assign ss = ss_in;
 reg sclk_prev;
 wire sclk_curr;



 //miso
 reg master_in_cl;
 reg master_in_w;
 reg master_in_shl;
 registro_desp master_in_reg(
   .clk(clk),
   .cl(master_in_cl),
   .w(master_in_w),
   .din(8'hFF),
   .dout(data_out),
   .shr(1'b0),
   .shl(master_in_shl),
   .shift_bit(miso)
   );

 wire [7:0] reg_data_in;
   registro sclk_reg(
     .clk(clk),
     .cl(master_out_cl),
     .w(master_out_w),
     .din(data_in),
     .dout(reg_data_in)
   );


 //mosi
 assign mosi = master_out_o[7];
 wire [7:0] master_out_o;
 reg master_out_cl;
 reg master_out_w;
 reg master_out_shl;
 registro_desp master_out_reg(
   .clk(clk),
   .cl(master_out_cl),
   .w(master_out_w),
   .din(data_in),
   .dout(master_out_o),
   .shr(1'b0),
   .shl(master_out_shl),
   .shift_bit(1'b0)
   );


 wire [7:0] sclk_div;
 reg sclk_cl;
 reg sclk_w;
 registro reg_data_input(
   .clk(clk),
   .cl(sclk_cl),
   .w(sclk_w),
   .din(data_in),
   .dout(sclk_div)
 );


 reg reg_sclk;
 reg reg_sclk_cl;
 reg reg_sclk_w;
 registro #(.WIDTH(1)) sclk_register(
   .clk(clk),
   .cl(reg_sclk_cl),
   .w(reg_sclk_w),
   .din(reg_sclk),
   .dout(sclk)
 );


 assign sclk_curr = counter_sclk_o[sclk_div[4:0]];//sclk_div[4:0]
 reg up_sclk;
 wire [31:0] counter_sclk_o;
 reg rst_counter_sclk;
 contador_up counter_sclk(
    .clk(clk),
    .rst(rst_counter_sclk),
    .up(up_sclk),
    .q(counter_sclk_o)
 );

 reg up_data;
 wire [31:0] counter_data_o;
 reg rst_counter_data;
 contador_up counter_data(
    .clk(clk),
    .rst(rst_counter_data),
    .up(up_data),
    .q(counter_data_o)
 );

 assign debug = {master_out_o,data_out,data_in,sclk_div};


 always @(posedge clk)
 begin

   sclk_prev <= sclk_curr;

   rst_counter_data <= 0;
   up_data <= 0;

   rst_counter_sclk <= 0;
   up_sclk <= 0;

   sclk_cl <= 0;
   sclk_w <= 0;

   master_out_cl <= 0;
   master_out_w <= 0;
   master_out_shl <= 0;

   master_in_cl <= 0;
   master_in_w <= 0;
   master_in_shl <= 0;

   reg_sclk_cl <= 0;
   reg_sclk_w <= 0;

   busy <= 0;

   if(w_conf == 1)
     begin
       //rst_counter_sclk <= 1;
       rst_counter_data <= 1;
       sclk_w <= 1;
       reg_sclk <= 0;
       reg_sclk_w <= 1;
     end
   else if(ss_in == 1)
     begin
       //rst_counter_data <= 1;
       up_sclk <= 1;
       master_in_w <= 1;
       master_out_w <= 1;
       if(sclk_curr != sclk_prev)
       begin
         reg_sclk <= ~sclk;
         reg_sclk_w <= 1;
       end
       //up_data <= sclk;
     end
   else if(w_data == 1)
     begin
       rst_counter_data <= 1;
       //up_sclk <= 1;
       //rst_counter_sclk <= 1;
       master_out_w <= 1;
       //if(counter_sclk_o == 0)
       busy <= 1;
       //busy <= 1;
       reg_sclk <= 0;
       reg_sclk_w <= 1;
     end
   else if(counter_data_o == 8'd15)
     begin
       rst_counter_data <= 1;
       rst_counter_sclk <= 1;
       busy <= 0;
       reg_sclk <= 0;
       reg_sclk_w <= 1;
     end
   else if(busy == 1)
     begin
       up_sclk <= 1;
       busy <= 1;
       if(sclk_curr != sclk_prev)
         begin
           //slave captured at rising edge
           //rising edge
           up_data <= 1;
           //reg_sclk <= ~reg_sclk;

           if(sclk_curr == 1)
             begin
               reg_sclk <= 1;
               master_in_shl <= 1;

               reg_sclk_w <= 1;
             end
           else
             begin
               //falling edge
               reg_sclk <= 0;
               reg_sclk_w <= 1;
               master_out_shl <= 1;
             end

         end

     end
 end



 endmodule
