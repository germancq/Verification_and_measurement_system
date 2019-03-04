# @Author: German Cano Quiveu <germancq>
# @Date:   2019-03-04T15:08:21+01:00
# @Email:  germancq@dte.us.es
# @Filename: Makefile
# @Last modified by:   germancq
# @Last modified time: 2019-03-04T17:16:05+01:00

VERILOG_SOURCES = ../../../rtl/verilog/7_seg/display.v \
                  ../../../rtl/verilog/7_seg/dec_to_7_seg.v \
                  ../../../rtl/verilog/7_seg/mux_8.v \
									../../../rtl/verilog/7_seg/an_gen.v \
                  ../../../rtl/verilog/7_seg/div_clk_module.v \
				  				../../../rtl/verilog/misc/contador_up.v \
                  ../../../rtl/verilog/misc/genericMux.v \

TOPLEVEL=display
MODULE=display_test
include $(COCOTB)/makefiles/Makefile.inc
include $(COCOTB)/makefiles/Makefile.sim
