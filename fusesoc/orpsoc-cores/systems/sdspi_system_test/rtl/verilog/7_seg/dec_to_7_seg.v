/**
 * @Author: German Cano Quiveu <germancq>
 * @Date:   2019-03-01T13:05:18+01:00
 * @Email:  germancq@dte.us.es
 * @Filename: dec_to_7_seg.v
 * @Last modified by:   germancq
 * @Last modified time: 2019-03-01T16:31:28+01:00
 */
module dec_to_7_seg(
  input rst,
  input [3:0] din,
  output reg [6:0] seg
  );

  always @ ( * )
  begin
    if(rst)
      seg = 7'b0000000;
    else
      begin
        case(din)
          //////////<---MSB-LSB<---
          //////////////gfedcba////////////////////////////////////////////           a
          0:seg = 7'b1000000;////0000                                                   __
          1:seg = 7'b1111001;////0001                                                f/      /b
          2:seg = 7'b0100100;////0010                                                  g
          //                                                                       __
          3:seg = 7'b0110000;////0011                                              e /   /c
          4:seg = 7'b0011001;////0100                                               __
          5:seg = 7'b0010010;////0101                                            d
          6:seg = 7'b0000010;////0110
          7:seg = 7'b1111000;////0111
          8:seg = 7'b0000000;////1000
          9:seg = 7'b0010000;////1001
          'hA:seg = 7'b0001000;
          'hB:seg = 7'b0000011;
          'hC:seg = 7'b1000110;
          'hD:seg = 7'b0100001;
          'hE:seg = 7'b0000110;
          'hF:seg = 7'b0001110;
        endcase
      end
  end

endmodule
