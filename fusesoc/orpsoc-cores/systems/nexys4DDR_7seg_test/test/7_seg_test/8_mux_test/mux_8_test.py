# @Author: German Cano Quiveu <germancq>
# @Date:   2019-03-01T17:04:24+01:00
# @Email:  germancq@dte.us.es
# @Filename: mux_8_test.py
# @Last modified by:   germancq
# @Last modified time: 2019-03-01T17:11:48+01:00
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


def setup_uut(dut):
    dut.in1.value = 0
    dut.in2.value = 1
    dut.in3.value = 2
    dut.in4.value = 3
    dut.in5.value = 4
    dut.in6.value = 5
    dut.in7.value = 6
    dut.in8.value = 7


@cocotb.coroutine
def mux_function_test(dut,ctrl_i):
    dut.ctl.value = ctrl_i
    yield Timer(1000)
    if(dut.out.value.integer != ctrl_i):
        raise TestFailure("Error mux,wrong value = %s, expected = %s"
                          % hex(int(dut.out.value))
                          % hex(ctrl_i))

    print("Expected value = {0}, Value = {1}".format(hex(ctrl_i),hex(int(dut.out.value))))



@cocotb.coroutine
def run_test(dut, ctrl_i = 0):
    setup_uut(dut)
    yield mux_function_test(dut,ctrl_i)



n = 10
factory = TestFactory(run_test)
factory.add_option("ctrl_i", np.random.randint(low=0,high=8,size=n)) #array de 10 int aleatorios entre 0 y 15
factory.generate_tests()
