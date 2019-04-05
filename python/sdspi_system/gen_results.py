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

BLOCK_SIZE = 512
NUM_BLOCK_TEST = 0x00100000
RESULTS_OFFSET = 0xC
SIGNATURE = 0xAABBCCDD

def create_fields(sheet1):
    sheet1.write(0,1,'n_blocks')
    sheet1.write(0,2,'sclk_speed MHz')
    sheet1.write(0,3,'cmd18')
    sheet1.write(0,4,'avg_time ms')
    sheet1.write(0,5,'best time ms')
    sheet1.write(0,6,'worst time ms')
    sheet1.write(0,7,'total time minutes')
    sheet1.write(0,8,'iterations')

def read_params_from_sd(sheet,block_n,micro_sd):
    micro_sd.seek(BLOCK_SIZE*block_n)
    signature = int.from_bytes(micro_sd.read(4),byteorder='big')
    n_iter = int.from_bytes(micro_sd.read(1),byteorder='big')
    n_blocks = int.from_bytes(micro_sd.read(4),byteorder='big')
    sclk_speed = int.from_bytes(micro_sd.read(1),byteorder='big')
    cmd18 = int.from_bytes(micro_sd.read(1),byteorder='big')
    micro_sd.seek((BLOCK_SIZE*block_n) + RESULTS_OFFSET)
    if n_iter == 0 :
        n_iter = 1
    avg_time = 0
    best_time = 0xFFFFFFFF
    worst_time = 0
    total_time = 0
    for i in range(0,n_iter):
        time = int.from_bytes(micro_sd.read(4),byteorder='big')
        time_ms = calculated_time_in_ms(time)
        #print ('iter is = %i' % i)
        #print ('time is = %i' % time)
        avg_time = avg_time + time_ms
        if(time_ms > worst_time):
            worst_time = time_ms
        if(time_ms < best_time):
            best_time = time_ms

    total_time = (avg_time / (1000.0 * 60))
    avg_time = (avg_time / n_iter)
    return (signature,
            n_blocks,
            sclk_speed,
            cmd18,
            avg_time,
            best_time,
            worst_time,
            total_time,
            n_iter)

def get_clk_speed_from_factor(n, base_clk=100):
    return (base_clk / (2**(n+1)))

def calculated_time_in_ms(time_units,base_clk=100,div_clk=7):
    clk_counter = get_clk_speed_from_factor(div_clk)
    #print ('time units is = %i' % time_units)
    #clk_counter in Mhz
    # 1/clk_counter = (1/clk_counterHz)* 10**(-6) s
    period_in_us = (1/(clk_counter))
    return time_units * period_in_us * (10**(-3))

def write_params(sheet1, params , i):

    sheet1.write(i,1,params[1])
    sclk_speed = get_clk_speed_from_factor(params[2])
    sheet1.write(i,2,sclk_speed)
    sheet1.write(i,3,params[3])
    #avg_time_in_ms = calculated_time_in_ms(params[4])
    sheet1.write(i,4,params[4])
    #best_time_in_ms = calculated_time_in_ms(params[5])
    sheet1.write(i,5,params[5])
    #worst_time_in_ms = calculated_time_in_ms(params[6])
    sheet1.write(i,6,params[6])
    sheet1.write(i,7,params[7])
    sheet1.write(i,8,params[8])
    return i+1

def gen_calc(micro_sd):
    wb = xlwt.Workbook()
    sheet1 = wb.add_sheet("Hoja 1")
    create_fields(sheet1)
    valid_signature = 1
    i = 1
    while valid_signature == 1 :
        params = read_params_from_sd(sheet1,NUM_BLOCK_TEST+i-1,micro_sd)
        #print(params[0])
        if params[0] != SIGNATURE:
            break
        i = write_params(sheet1,params,i)


    wb.save('test_iter_0_sdspi_system.xls')

def main():
    with open(sys.argv[1],"rb") as micro_sd:
        gen_calc(micro_sd)


if __name__ == "__main__":
    main()
