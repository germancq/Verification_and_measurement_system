# @Author: German Cano Quiveu <germancq>
# @Date:   2019-03-01T17:14:14+01:00
# @Email:  germancq@dte.us.es
# @Filename: an_gen_test.py
# @Last modified by:   germancq
# @Last modified time: 2019-03-01T17:22:53+01:00

import cocotb
import numpy as np
import time
from cocotb.triggers import Timer
from cocotb.regression import TestFactory
from cocotb.result import TestFailure, ReturnValue

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
    if(dut.an.value.integer != 0xFF):
        raise TestFailure("Error rst,wrong value = %s"
                          % hex(int(dut.an.value)))
    dut.rst = 0


@cocotb.coroutine
def mux_function_test(dut,an_gen_i):
    dut.an_gen_i.value = an_gen_i
    expected_value = calculate_expected_result(an_gen_i)
    yield Timer(1000)
    if(dut.an.value.integer != expected_value):
        raise TestFailure("Error mux,wrong value = %s, expected = %s"
                          % hex(int(dut.an.value))
                          % hex(expected_value))

    print("Expected value = {0}, Value = {1}".format(hex(expected_value),hex(int(dut.an.value))))



def calculate_expected_result(an_gen):
    return (0xFF ^ (0x1<<an_gen))

@cocotb.coroutine
def run_test(dut, ctrl_i = 0):
    yield rst_function_test(dut)
    yield mux_function_test(dut,ctrl_i)



n = 10
factory = TestFactory(run_test)
factory.add_option("ctrl_i", np.random.randint(low=0,high=8,size=n)) #array de 10 int aleatorios entre 0 y 15
factory.generate_tests()
