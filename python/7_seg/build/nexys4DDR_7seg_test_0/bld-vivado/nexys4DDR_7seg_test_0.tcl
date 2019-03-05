# Auto-generated project tcl file

create_project nexys4DDR_7seg_test_0

set_property part xc7a100tcsg324-2 [current_project]



read_verilog ../src/nexys4DDR_7seg_test_0/rtl/verilog/top.v
read_verilog ../src/nexys4DDR_7seg_test_0/rtl/verilog/misc/contador_up.v
read_verilog ../src/nexys4DDR_7seg_test_0/rtl/verilog/misc/genericMux.v
read_verilog ../src/nexys4DDR_7seg_test_0/rtl/verilog/misc/registro_desp.v
read_verilog ../src/nexys4DDR_7seg_test_0/rtl/verilog/misc/registro.v
read_verilog ../src/nexys4DDR_7seg_test_0/rtl/verilog/7_seg/display.v
read_verilog ../src/nexys4DDR_7seg_test_0/rtl/verilog/7_seg/an_gen.v
read_verilog ../src/nexys4DDR_7seg_test_0/rtl/verilog/7_seg/dec_to_7_seg.v
read_verilog ../src/nexys4DDR_7seg_test_0/rtl/verilog/7_seg/div_clk_module.v
read_verilog ../src/nexys4DDR_7seg_test_0/rtl/verilog/7_seg/mux_8.v
read_verilog ../src/nexys4DDR_7seg_test_0/rtl/verilog/autotest_module/autotest_module.v
read_verilog ../src/nexys4DDR_7seg_test_0/rtl/verilog/autotest_module/fsm_autotest.v
read_verilog ../src/nexys4DDR_7seg_test_0/rtl/verilog/autotest_module/sdspi/sdspihost.v
read_verilog ../src/nexys4DDR_7seg_test_0/rtl/verilog/autotest_module/sdspi/sdcmd.v
read_verilog ../src/nexys4DDR_7seg_test_0/rtl/verilog/autotest_module/sdspi/spi_master.v
read_xdc ../src/nexys4DDR_7seg_test_0/data/Nexys4DDR_Master.xdc


set_property top top [current_fileset]
set_property source_mgmt_mode None [current_project]
