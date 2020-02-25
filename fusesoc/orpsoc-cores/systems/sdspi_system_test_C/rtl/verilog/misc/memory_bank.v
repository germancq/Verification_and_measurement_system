/**
 * @Author: German Cano Quiveu <germancq>
 * @Date:   2019-04-01T17:37:55+02:00
 * @Email:  germancq@dte.us.es
 * @Filename: memory_bank.v
 * @Last modified by:   germancq
 * @Last modified time: 2019-04-05T12:25:00+02:00
 */
 module memory_bank #(parameter DATA_WIDTH = 8, DEPTH = 512) (
     input clk,
     input [$clog2(DEPTH)-1:0] addr,
     input write,
     input [DATA_WIDTH-1:0] data_in,
     output reg [DATA_WIDTH-1:0] data_out
     );

     reg [DATA_WIDTH-1:0] memory_array [0:DEPTH-1];

     always @ (posedge clk)
     begin
         if(write) begin
             memory_array[addr] <= data_in;
         end
         else begin
             data_out <= memory_array[addr];
         end
     end
 endmodule
