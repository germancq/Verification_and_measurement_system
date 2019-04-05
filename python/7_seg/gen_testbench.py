# @Author: German Cano Quiveu <germancq>
# @Date:   2019-03-05T11:46:25+01:00
# @Email:  germancq@dte.us.es
# @Filename: gen_testbench.py
# @Last modified by:   germancq
# @Last modified time: 2019-04-05T13:40:06+02:00

import sys
import os
import itertools
import allpairspy
import math
from converter_7_seg import digit_to_7_seg

BLOCK_SIZE = 512
NUM_BLOCK_TEST = 0x00100000
NUMBER_ITER = 1
SIGNATURE = 0xAABBCCDD


#valores a generar
'''

    - data [31:0] = {din,din,din,din,din,din,din,din}
    - expected_value

'''


def create_data_in(din):
    data_in = 0
    for i in range(0,8):
        data_in = data_in | (din << i*4)

    return data_in

def gen_all_posibilities(micro_sd):
    parameters = [
        range(0,2**4)#din
    ]
    total_posibilities = 1
    modulo_op = []
    for i in range(0,len(parameters)):
        total_posibilities = total_posibilities * len(parameters[i])
        modulo_op.insert(i,total_posibilities)
    print(total_posibilities)
    j = 0
    zero = 0
    for n in range (0, total_posibilities):
        pairs = create_posibility(n,parameters,modulo_op)
        print (pairs[0])
        data_in = create_data_in(pairs[0])
        print(data_in)
        print (hex(data_in))
        micro_sd.seek(BLOCK_SIZE*(NUM_BLOCK_TEST+j))
        j = j+1
        micro_sd.write(SIGNATURE.to_bytes(4, byteorder='big'))
        micro_sd.write(NUMBER_ITER.to_bytes(1, byteorder='big'))
        for k in range(0,1):
            micro_sd.write(data_in.to_bytes(4, byteorder='big'))


    #last block with no signature
    micro_sd.seek(BLOCK_SIZE*(NUM_BLOCK_TEST+j))
    micro_sd.write(zero.to_bytes(4, byteorder='big'))
    '''
    last_run = 0x0
    micro_sd.seek(BLOCK_SIZE*CONTROL_BLOCK_TEST)
    micro_sd.write(SIGNATURE.to_bytes(4, byteorder='big'))
    micro_sd.write(last_run.to_bytes(4, byteorder='big'))
    micro_sd.write(j.to_bytes(4, byteorder='big'))
    print (j)
    '''

def create_posibility(n,parameters,modulo_op):
    result = []
    for i in range(0,len(parameters)):
        x = n % modulo_op[i]
        long = len(parameters[i])
        factor_div = math.floor(modulo_op[i] / long)

        if(x != 0):
            element = math.floor(x / factor_div)
        else:
            element = 0

        result.append(parameters[i][element])
    return result





def main():
    with open(sys.argv[1],"rb+") as micro_sd:
        gen_all_posibilities(micro_sd)


if __name__ == "__main__":
    main()
