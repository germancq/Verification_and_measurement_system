# @Author: German Cano Quiveu <germancq>
# @Date:   2019-03-06T19:26:17+01:00
# @Email:  germancq@dte.us.es
# @Filename: gen_testbench.py
# @Last modified by:   germancq
# @Last modified time: 2019-03-08T14:49:22+01:00

import sys
import os
import itertools
import allpairspy
import math

BLOCK_SIZE = 512
NUM_BLOCK_TEST = 0x00100000
SIGNATURE = 0xAABBCCDD


#valores a generar
'''

    - n_blocks = {0,1,2,3,4} = 10**n
    - sclk_speed = {1,2,3,4}
    - cmd18 = {0,1}

'''

def gen_all_posibilities(micro_sd):
    parameters = [
        range(0,1+1),
        range(1,4+1),#sclk_speed
        range(0,5+1)#n_blocks
    ]
    total_posibilities = 1
    for i in range(0,len(parameters)):
        total_posibilities = total_posibilities * len(parameters[i])
    print(total_posibilities)
    j = 0
    zero = 0
    for n in range (0, total_posibilities):
        pairs = create_posibility(n,parameters)
        print(pairs)
        n_blocks = 10 ** pairs[2]
        micro_sd.seek(BLOCK_SIZE*(NUM_BLOCK_TEST+j))
        j = j+1
        micro_sd.write(SIGNATURE.to_bytes(4, byteorder='big'))
        #for k in range(0,2+1):
        micro_sd.write(n_blocks.to_bytes(4, byteorder='big'))
        micro_sd.write(pairs[1].to_bytes(1, byteorder='big'))
        micro_sd.write(pairs[0].to_bytes(1, byteorder='big'))
        micro_sd.write(zero.to_bytes(4, byteorder='big'))

    #last block with no signature
    micro_sd.seek(BLOCK_SIZE*(NUM_BLOCK_TEST+j))
    micro_sd.write(zero.to_bytes(4, byteorder='big'))


def create_posibility(n,parameters):
    modulo_op = []
    div_op = []
    anteriores_posibilidades = 1
    for i in range(len(parameters),0,-1):
        value = anteriores_posibilidades * len(parameters[i-1])
        modulo_op.insert(0,value)
        anteriores_posibilidades = value

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
