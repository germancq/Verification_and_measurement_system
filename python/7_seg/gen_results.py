# @Author: German Cano Quiveu <germancq>
# @Date:   2019-03-05T12:12:48+01:00
# @Email:  germancq@dte.us.es
# @Filename: gen_results.py
# @Last modified by:   germancq
# @Last modified time: 2019-03-05T17:41:50+01:00

import sys
import os
import itertools
import xlwt
from converter_7_seg import digit_to_7_seg, seven_seg_to_digit

BLOCK_SIZE = 512
NUM_BLOCK_TEST = 0x00100000

SIGNATURE = 0xAABBCCDD

def create_fields(sheet1):
    sheet1.write(0,1,'Data_in')
    sheet1.write(0,2,'Calculated_data_in')
    sheet1.write(0,3,'expected_seg')
    sheet1.write(0,4,'real_seg_0')
    sheet1.write(0,5,'real_seg_0')
    sheet1.write(0,6,'real_seg_2')
    sheet1.write(0,7,'real_seg_3')
    sheet1.write(0,8,'real_seg_4')
    sheet1.write(0,9,'real_seg_5')
    sheet1.write(0,10,'real_seg_6')
    sheet1.write(0,11,'real_seg_7')

def read_params_from_sd(sheet,block_n,micro_sd):
    micro_sd.seek(BLOCK_SIZE*block_n)
    signature = int.from_bytes(micro_sd.read(4),byteorder='big')
    data_in = int.from_bytes(micro_sd.read(4),byteorder='big')
    real_7_seg_0 = int.from_bytes(micro_sd.read(1),byteorder='big')
    real_7_seg_1 = int.from_bytes(micro_sd.read(1),byteorder='big')
    real_7_seg_2 = int.from_bytes(micro_sd.read(1),byteorder='big')
    real_7_seg_3 = int.from_bytes(micro_sd.read(1),byteorder='big')
    real_7_seg_4 = int.from_bytes(micro_sd.read(1),byteorder='big')
    real_7_seg_5 = int.from_bytes(micro_sd.read(1),byteorder='big')
    real_7_seg_6 = int.from_bytes(micro_sd.read(1),byteorder='big')
    real_7_seg_7 = int.from_bytes(micro_sd.read(1),byteorder='big')
    return (signature,
            data_in,
            real_7_seg_0,
            real_7_seg_1,
            real_7_seg_2,
            real_7_seg_3,
            real_7_seg_4,
            real_7_seg_5,
            real_7_seg_6,
            real_7_seg_7)

def calculated_data_in(params):
    result = 0x00000000
    for i in range(0,8):
        digit_v = seven_seg_to_digit(params[i+2])
        result = result | (digit_v <<(i*4))

    return result

def din_7_seg(din,n):
    result = din & (0x0000000f << (n*4))
    result = result >> (n*4)
    return result

def write_params(sheet1, params , i):
    calc_data_in = calculated_data_in(params)
    din_0 = din_7_seg(params[1],0)
    expected_seg = digit_to_7_seg(din_0)
    if(calc_data_in == params[1]):
        return i

    sheet1.write(i,1,hex(params[1]))
    sheet1.write(i,2,hex(calc_data_in))
    sheet1.write(i,3,hex(expected_seg))
    for k in range(0,8):
        sheet1.write(i,k+4,hex(params[k+2]))
    return i+1

def gen_calc(micro_sd):
    wb = xlwt.Workbook()
    sheet1 = wb.add_sheet("Hoja 1")
    create_fields(sheet1)
    valid_signature = 1
    i = 0
    while valid_signature == 1 :
        params = read_params_from_sd(sheet1,NUM_BLOCK_TEST+i,micro_sd)
        print(params[0])
        if params[0] != SIGNATURE:
            break
        i = write_params(sheet1,params,i)


    wb.save('test_7_seg.xls')

def main():
    with open(sys.argv[1],"rb") as micro_sd:
        gen_calc(micro_sd)


if __name__ == "__main__":
    main()
