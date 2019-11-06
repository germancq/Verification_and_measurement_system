# @Author: German Cano Quiveu <germancq>
# @Date:   2019-03-06T19:26:26+01:00
# @Email:  germancq@dte.us.es
# @Filename: gen_results.py
# @Last modified by:   germancq
# @Last modified time: 2019-04-05T12:31:49+02:00

import sys
import os
import itertools
import xlwt

import importlib
sys.path.append('/home/germancq/gitProjects/examples_cryptography/python')
import trivium

BLOCK_SIZE = 512
NUM_BLOCK_TEST = 0x00100000
SIGNATURE = 0xAABBCCDD

def create_fields(sheet1):
    sheet1.write(0,1,'iv')
    sheet1.write(0,2,'key')
    sheet1.write(0,3,'keystream')
    sheet1.write(0,4,'expected_value')
    sheet1.write(0,5,'error')

def read_params_from_sd(block_n,micro_sd):
    micro_sd.seek(BLOCK_SIZE*block_n)
    signature = int.from_bytes(micro_sd.read(4),byteorder='big')
    n_iter = int.from_bytes(micro_sd.read(1),byteorder='big')
    param_0 = int.from_bytes(micro_sd.read(10),byteorder='big')
    param_1 = int.from_bytes(micro_sd.read(10),byteorder='big')
    
    result = int.from_bytes(micro_sd.read(8),byteorder='little')
    #print(hex(result))
    
    return (signature,
            param_0,
            param_1,
            result)


def write_params(sheet1, params , i):

    key = params[2]
    iv = params[1]
    result = params[3]
    
    
    expected_value = trivium.trivium_impl(key,iv,64)
    
    #print(expected_value)

    expected_value = int(expected_value,2)

    print(hex(expected_value))
    print(hex(result))

    
    
    error = 0
    if(expected_value != result) :
        error = 1


    sheet1.write(i,1,hex(iv))
    sheet1.write(i,2,hex(key))
    sheet1.write(i,3,hex(result))
    sheet1.write(i,4,hex(expected_value))
    sheet1.write(i,5,hex(error))
    
    return i+1

def gen_calc(micro_sd):
    wb = xlwt.Workbook()
    sheet1 = wb.add_sheet("Hoja_1")
    create_fields(sheet1)
    valid_signature = 1
    i = 1
    while valid_signature == 1 :
        params = read_params_from_sd(NUM_BLOCK_TEST+i-1,micro_sd)
        print(i)
        if params[0] != SIGNATURE:
            break
        i = write_params(sheet1,params,i)


    wb.save('results_sheet.xls')

def main():
    with open(sys.argv[1],"rb") as micro_sd:
        
        gen_calc(micro_sd)


if __name__ == "__main__":
    main()
