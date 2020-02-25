/**
 * @Author: German Cano Quiveu <germancq>
 * @Date:   2019-03-01T14:05:10+01:00
 * @Email:  germancq@dte.us.es
 * @Filename: an_gen.v
 * @Last modified by:   germancq
 * @Last modified time: 2019-03-01T17:24:48+01:00
 */
module an_gen(
  input rst,
  input [2:0] an_gen_i,
  output reg [7:0] an
  );


always @ ( * )
begin
  an = 8'hFF;
  if(~rst)
    begin
      //an[an_gen_i] = 0;
      an = 8'hFF ^ (1'b1<<an_gen_i);
    end
end


endmodule
