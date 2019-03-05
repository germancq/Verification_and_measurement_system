# @Author: German Cano Quiveu <germancq>
# @Date:   2019-03-05T11:54:37+01:00
# @Email:  germancq@dte.us.es
# @Filename: converter_7_seg.py
# @Last modified by:   germancq
# @Last modified time: 2019-03-05T15:17:44+01:00



'''
    _a_
  f|   |b
   |_g_|
  e|   |c
   |_d_|

   0: on
   1: off
   binario : g|f|e|d|c|b|a
'''
seven_seg_values = {
    0: 0b1000000,
    1: 0b1111001,
    2: 0b0100100,
    3: 0b0110000,
    4: 0b0011001,
    5: 0b0010010,
    6: 0b0000010,
    7: 0b1111000,
    8: 0b0000000,
    9: 0b0010000,
    10: 0b0001000,
    11: 0b0000011,
    12: 0b1000110,
    13: 0b0100001,
    14: 0b0000110,
    15: 0b0001110,
}


def seven_seg_to_digit(seven_seg_value):
    result = 0
    for key,value in seven_seg_values.items():
        if value == seven_seg_value:
            result = key
    return result

def digit_to_7_seg(data_in):
    return seven_seg_values.get(data_in,0b0000000)
