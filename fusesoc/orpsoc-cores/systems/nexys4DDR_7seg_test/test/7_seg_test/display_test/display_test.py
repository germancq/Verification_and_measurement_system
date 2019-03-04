# @Author: German Cano Quiveu <germancq>
# @Date:   2019-03-04T15:08:33+01:00
# @Email:  germancq@dte.us.es
# @Filename: display_test.py
# @Last modified by:   germancq
# @Last modified time: 2019-03-04T17:45:33+01:00


import cocotb
import numpy as np
import time
from cocotb.triggers import Timer,RisingEdge, FallingEdge
from cocotb.regression import TestFactory
from cocotb.result import TestFailure, ReturnValue
from cocotb.clock import Clock

import sys
sys.path.insert(0, '/home/germancq/gitProjects/BIST_measurements/fusesoc/orpsoc-cores/systems/nexys4DDR_7seg_test/test/7_seg_test/misc')
from seven_seg import digit_to_7_seg

CLK_PERIOD = 20 # 50 MHz

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


def setup_function(dut, din):
    cocotb.fork(Clock(dut.clk, CLK_PERIOD).start())
    dut.div_value.value = 10
    dut.din.value = din

@cocotb.coroutine
def rst_function_test(dut):
    dut.rst = 1
    yield n_cycles_clock(dut,10)

    if(dut.seg.value.integer != 0x00):
        raise TestFailure("Error rst,wrong seg value = %s"
                          % hex(int(dut.seg.value)))

    if(dut.an.value.integer != 0xFF):
        raise TestFailure("Error rst,wrong an value = %s"
                          % hex(int(dut.an.value)))

    dut.rst = 0


@cocotb.coroutine
def display_function_test(dut, din, c1 , c2):
    yield n_cycles_clock(dut,c1)

    if(dut.an.value.integer != calculate_an_expected_result(dut.an_gen.value.integer)):
        raise TestFailure("Error an,wrong value = %s, expected = %s"
                          % hex(int(dut.an.value))
                          % hex(calculate_an_expected_result(dut.an_gen.value.integer)))


    if(dut.seg.value.integer != calculate_seg_expected_result(din,dut.an_gen.value.integer)):
        raise TestFailure("Error seg,wrong value = %s, expected = %s"
                          % hex(int(dut.seg.value))
                          % hex(calculate_seg_expected_result(din,dut.an_gen.value.integer)))

    yield n_cycles_clock(dut,c2)

    if(dut.an.value.integer != calculate_an_expected_result(dut.an_gen.value.integer)):
        raise TestFailure("Error an,wrong value = %s, expected = %s"
                          % hex(int(dut.an.value))
                          % hex(calculate_an_expected_result(dut.an_gen.value.integer)))


    if(dut.seg.value.integer != calculate_seg_expected_result(din,dut.an_gen.value.integer)):
        raise TestFailure("Error seg,wrong value = %s, expected = %s"
                          % hex(int(dut.seg.value))
                          % hex(calculate_seg_expected_result(din,dut.an_gen.value.integer)))





@cocotb.coroutine
def n_cycles_clock(dut,n):
    for i in range(0,n):
        yield RisingEdge(dut.clk)
        yield FallingEdge(dut.clk)

def calculate_seg_expected_result(din,n):
    data_in = din & (0xF << (n*4))
    data_in = data_in >> (n*4)
    return digit_to_7_seg(data_in)

def calculate_an_expected_result(n):
    return (0xFF ^ (0x1<<n))


@cocotb.coroutine
def run_test(dut, din = 2,c1 = 10, c2 = 10):
    setup_function(dut, din)
    yield rst_function_test(dut)
    yield display_function_test(dut,din,c1,c2)



n = 10
factory = TestFactory(run_test)
factory.add_option("din", np.random.randint(low=0,high=(2**32),size=n)) #array de 10 int aleatorios entre 0 y 15
factory.add_option("c1", np.random.randint(low=10,high=2000,size=1))
factory.add_option("c2", np.random.randint(low=10,high=2000,size=1))
factory.generate_tests()
