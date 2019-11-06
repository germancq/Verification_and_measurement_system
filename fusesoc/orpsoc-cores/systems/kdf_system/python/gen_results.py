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
import keyDerivationFunction

BLOCK_SIZE = 512
NUM_BLOCK_TEST = 0x00100000
SIGNATURE = 0xAABBCCDD

def create_fields(sheet1):
    sheet1.write(0,1,'salt')
    sheet1.write(0,2,'count')
    sheet1.write(0,3,'user_password')
    sheet1.write(0,4,'key_derivated')
    sheet1.write(0,5,'expected_value')
    sheet1.write(0,6,'time')
    sheet1.write(0,7,'error')
    

def read_params_from_sd(block_n,micro_sd):
    micro_sd.seek(BLOCK_SIZE*block_n)
    signature = int.from_bytes(micro_sd.read(4),byteorder='big')
    n_iter = int.from_bytes(micro_sd.read(1),byteorder='big')
    param_0 = int.from_bytes(micro_sd.read(8),byteorder='big')
    param_1 = int.from_bytes(micro_sd.read(4),byteorder='big')
    param_2 = int.from_bytes(micro_sd.read(4),byteorder='big')
    #micro_sd.seek((BLOCK_SIZE*block_n) + RESULTS_OFFSET)
    if n_iter == 0 :
        n_iter = 1
    
    result = int.from_bytes(micro_sd.read(16),byteorder='little')
    time_value = int.from_bytes(micro_sd.read(4),byteorder='little')
    #print(hex(result))
    
    return (signature,
            param_0,
            param_1,
            param_2,
            result,
            time_value)


def write_params(sheet1, params , i):

    salt = params[1]
    count_value = params[2]
    user_password = params[3] 
    result = params[4]
    time_value = calculated_time_in_ms(params[5])
    kdf_impl = keyDerivationFunction.KDF(count_value,salt,user_password)   
    expected_value = kdf_impl.generate_derivate_key()
    print("*************************")
    print(i)
    print(count_value)
    print(hex(result))
    print(hex(expected_value))
    print("*************************")
    error = 0
    if(expected_value != result) :
        error = 1


    sheet1.write(i,1,hex(salt))
    sheet1.write(i,2,count_value)
    sheet1.write(i,3,hex(user_password))
    sheet1.write(i,4,hex(result))
    sheet1.write(i,5,hex(expected_value))
    sheet1.write(i,6,time_value)
    sheet1.write(i,7,hex(error))
    
    return i+1

def calculated_time_in_ms(time_units,base_clk=100,div_clk=7):
    clk_counter = get_clk_speed_from_factor(div_clk)
    #print ('time units is = %i' % time_units)
    #clk_counter in Mhz
    # 1/clk_counter = (1/clk_counterHz)* 10**(-6) s
    period_in_us = (1/(clk_counter))
    return time_units * period_in_us * (10**(-3))    

def get_clk_speed_from_factor(n, base_clk=100):
    return (base_clk / (2**(n+1)))


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


    wb.save('results_sheet.xls')

def main():
    with open(sys.argv[1],"rb") as micro_sd:
        gen_calc(micro_sd)


if __name__ == "__main__":
    main()
