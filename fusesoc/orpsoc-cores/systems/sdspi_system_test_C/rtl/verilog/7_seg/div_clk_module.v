/**
 * @Author: German Cano Quiveu <germancq>
 * @Date:   2019-03-01T13:54:31+01:00
 * @Email:  germancq@dte.us.es
 * @Filename: div_clk_module.v
 * @Last modified by:   germancq
 * @Last modified time: 2019-03-01T14:04:33+01:00
 */
module div_clk_module(
  input clk,
  input rst,
  input [31:0] div,
  output [2:0] an_gen_o
  );


assign an_gen_o[0] = contador_o[div];
assign an_gen_o[1] = contador_o[div+1];
assign an_gen_o[2] = contador_o[div+2];
wire [31:0] contador_o;
contador_up div_clk_counter(
   .clk(clk),
   .rst(rst),
   .up(1'b1),
   .q(contador_o)
);

endmodule
