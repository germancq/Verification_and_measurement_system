# @Author: German Cano Quiveu <germancq>
# @Date:   2019-03-01T15:52:04+01:00
# @Email:  germancq@dte.us.es
# @Filename: dec_to_7_seg_test.py
# @Last modified by:   germancq
# @Last modified time: 2019-03-04T15:23:17+01:00

import cocotb
import numpy as np
import time
from cocotb.triggers import Timer
from cocotb.regression import TestFactory
from cocotb.result import TestFailure, ReturnValue
from cocotb.binary import BinaryValue

import sys
sys.path.insert(0, '/home/germancq/gitProjects/BIST_measurements/fusesoc/orpsoc-cores/systems/nexys4DDR_7seg_test/test/7_seg_test/misc')
from seven_seg import digit_to_7_seg

#the keyword yield
#   Testbenches built using Cocotb use coroutines.
#   While the coroutine is executing the simulation is paused.
#   The coroutine uses the yield keyword
#   to pass control of execution back to
#   the simulator and simulation time can advance again.
#
#   yield return when the 'Trigger' is resolve
#
#   Coroutines may also yield a list of triggers
#   to indicate that execution should resume if any of them fires

@cocotb.coroutine
def rst_function_test(dut):
    dut.rst = 1
    yield Timer(1000) #default units = ps
    if(dut.seg.value.integer != 0):
        raise TestFailure("Error rst,wrong value = %s"
                          % hex(int(dut.seg.value)))
    dut.rst = 0

@cocotb.coroutine
def converter_function_test(dut,din):
    expected_result = digit_to_7_seg(din)
    dut.din = din
    yield Timer(1000)
    if(dut.seg.value.integer != expected_result):
        raise TestFailure("Error converter,wrong value = %s, expected = %s"
                          % hex(int(dut.seg.value))
                          % hex(expected_result))

    print("Data_in = {2};Expected value = {0}, Value = {1}".format(hex(expected_result),hex(int(dut.seg.value)),hex(din)))



@cocotb.coroutine
def run_test(dut, din = 0):
    print os.getcwd()
    yield rst_function_test(dut)
    yield converter_function_test(dut,din)



n = 10
factory = TestFactory(run_test)
factory.add_option("din", np.random.randint(low=0,high=16,size=n)) #array de 10 int aleatorios entre 0 y 15
factory.generate_tests()
