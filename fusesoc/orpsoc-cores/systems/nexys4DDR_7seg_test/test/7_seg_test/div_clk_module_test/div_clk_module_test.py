# @Author: German Cano Quiveu <germancq>
# @Date:   2019-03-04T13:51:16+01:00
# @Email:  germancq@dte.us.es
# @Last modified by:   germancq
# @Last modified time: 2019-03-04T14:58:53+01:00

import cocotb
import numpy as np
import time
from cocotb.triggers import Timer,RisingEdge, FallingEdge
from cocotb.regression import TestFactory
from cocotb.result import TestFailure, ReturnValue
from cocotb.clock import Clock


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


def setup_function(dut, div_value):
    cocotb.fork(Clock(dut.clk, CLK_PERIOD).start())
    dut.div.value = div_value

@cocotb.coroutine
def rst_function_test(dut):
    dut.rst = 1
    yield n_cycles_clock(dut,10)

    if(dut.contador_o.value.integer != 0x00):
        raise TestFailure("Error rst,wrong value = %s"
                          % hex(int(dut.contador_o.value)))

    if(dut.an_gen_o.value.integer != 0x00):
        raise TestFailure("Error rst,wrong value = %s"
                          % hex(int(dut.an_gen_o.value)))

    dut.rst = 0


@cocotb.coroutine
def div_clk_function_test(dut, div_value):
    expected_value = calculate_expected_result(div_value)

    print expected_value

    yield n_cycles_clock(dut,expected_value)

    if(dut.an_gen_o.value.integer != 1):
        raise TestFailure("Error contador_o,wrong value = %i, expected = 1"
                          % int(dut.an_gen_o.value))

    yield n_cycles_clock(dut,expected_value-1)

    if(dut.an_gen_o.value.integer != 1):
        raise TestFailure("Error contador_o,wrong value = %i, expected = 1"
                          % int(dut.an_gen_o.value))

    yield n_cycles_clock(dut,1)

    if(dut.an_gen_o.value.integer != 2):
        raise TestFailure("Error an_gen_o,wrong value = %i, expected = 2"
                          % int(dut.an_gen_o.value))



@cocotb.coroutine
def n_cycles_clock(dut,n):
    for i in range(0,n):
        yield RisingEdge(dut.clk)
        yield FallingEdge(dut.clk)

def calculate_expected_result(div_value):
    return 2**(div_value)


@cocotb.coroutine
def run_test(dut, div_value = 2):
    setup_function(dut, div_value)
    yield rst_function_test(dut)
    yield div_clk_function_test(dut,div_value)



n = 10
factory = TestFactory(run_test)
factory.add_option("div_value", np.random.randint(low=4,high=5,size=n)) #array de 10 int aleatorios entre 0 y 15
factory.generate_tests()
