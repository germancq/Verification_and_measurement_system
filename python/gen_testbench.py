# @Author: German Cano Quiveu <germancq>
# @Date:   2019-03-06T19:26:17+01:00
# @Email:  germancq@dte.us.es
# @Filename: gen_testbench.py
# @Last modified by:   germancq
# @Last modified time: 2019-04-05T13:40:59+02:00

import sys
import os
import itertools
import allpairspy
import math

BLOCK_SIZE = 512
NUM_BLOCK_TEST = 0x00100000
NUMBER_ITER = 3
SIGNATURE = 0xAABBCCDD


#valores a generar
'''

    - input_1 = {1,2,3,4,...n1}
    - input_2 = {1,2,3, .....n2}
    - input_3 = {0,1,.......n3}
    ....
'''

def gen_all_posibilities(micro_sd):
    parameters = [
        range(1,n1+1), #input_1 values
        range(1,n2+1), #input_2 values
        range(0,n3+1) #input_3 values
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
        print(pairs)
        micro_sd.seek(BLOCK_SIZE*(NUM_BLOCK_TEST+j))
        j = j+1
        micro_sd.write(SIGNATURE.to_bytes(4, byteorder='big'))
        micro_sd.write(NUMBER_ITER.to_bytes(1, byteorder='big'))
        #for k in range(0,2+1):
        micro_sd.write(pairs[2].to_bytes(4, byteorder='big'))
        micro_sd.write(pairs[1].to_bytes(1, byteorder='big'))
        micro_sd.write(pairs[0].to_bytes(1, byteorder='big'))
        micro_sd.write(zero.to_bytes(4, byteorder='big'))

    #last block with no signature
    micro_sd.seek(BLOCK_SIZE*(NUM_BLOCK_TEST+j))
    micro_sd.write(zero.to_bytes(4, byteorder='big'))


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
