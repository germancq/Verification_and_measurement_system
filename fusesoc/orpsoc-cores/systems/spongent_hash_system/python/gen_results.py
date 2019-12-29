'''
 # @ Author: German Cano Quiveu, germancq
 # @ Create Time: 2019-12-20 12:25:41
 # @ Modified by: Your name
 # @ Modified time: 2019-12-20 12:26:04
 # @ Description:
 '''

import sys
import os
import itertools
import xlwt

import importlib
sys.path.append('/home/germancq/gitProjects/examples_cryptography/python')
import spongent


BLOCK_SIZE = 512
NUM_BLOCK_TEST = 0x00100000 #1048576
SIGNATURE = 0xAABBCCDD

N = 256
r = 16
c = 256
R = 140 

def create_fields(sheet1):
    sheet1.write(0,1,'msg')
    sheet1.write(0,2,'hash')
    sheet1.write(0,3,'expected_hash')
    sheet1.write(0,4,'error')

def read_params_from_sd(block_n,micro_sd):
    micro_sd.seek(BLOCK_SIZE*block_n)
    signature = int.from_bytes(micro_sd.read(4),byteorder='big')
    n_iter = int.from_bytes(micro_sd.read(1),byteorder='big')
    param_0 = int.from_bytes(micro_sd.read(8),byteorder='little')
    #micro_sd.seek((BLOCK_SIZE*block_n) + RESULTS_OFFSET)
    if n_iter == 0 :
        n_iter = 1
    
    result = int.from_bytes(micro_sd.read(int(N/8)),byteorder='little')
    #print(hex(result))
    
    return (signature,
            param_0,
            result)


def write_params(sheet1, params , i):

    msg = params[1]
    result = params[2]
    spongent_impl = spongent.Spongent(N,c,r,R)
    expected_hash = spongent_impl.generate_hash(msg,64)
    
    print("*************************")
    print(hex(result))
    print(hex(expected_hash))
    print("*************************")
    error = 0
    
    if(expected_hash != result) :
        error = 1
    
    


    sheet1.write(i,1,hex(msg))
    sheet1.write(i,2,hex(result))
    sheet1.write(i,3,hex(expected_hash))
    sheet1.write(i,4,hex(error))
    
    
    return i+1

def gen_calc(micro_sd):
    wb = xlwt.Workbook()
    sheet1 = wb.add_sheet("Hoja_1")
    create_fields(sheet1)
    valid_signature = 1
    i = 1
    while valid_signature == 1 :
        params = read_params_from_sd(NUM_BLOCK_TEST+i-1,micro_sd)
        #print(params[0])
        if params[0] != SIGNATURE:
            break
        i = write_params(sheet1,params,i)


    wb.save('results_spongent256.xls')

def main():
    with open(sys.argv[1],"rb") as micro_sd:
        gen_calc(micro_sd)


if __name__ == "__main__":
    main()
