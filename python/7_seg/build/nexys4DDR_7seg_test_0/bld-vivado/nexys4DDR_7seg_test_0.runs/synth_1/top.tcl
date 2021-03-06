# 
# Synthesis run script generated by Vivado
# 

create_project -in_memory -part xc7a100tcsg324-2

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir /home/germancq/gitProjects/BIST_measurements/python/7_seg/build/nexys4DDR_7seg_test_0/bld-vivado/nexys4DDR_7seg_test_0.cache/wt [current_project]
set_property parent.project_path /home/germancq/gitProjects/BIST_measurements/python/7_seg/build/nexys4DDR_7seg_test_0/bld-vivado/nexys4DDR_7seg_test_0.xpr [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
read_verilog -library xil_defaultlib {
  /home/germancq/gitProjects/BIST_measurements/python/7_seg/build/nexys4DDR_7seg_test_0/src/nexys4DDR_7seg_test_0/rtl/verilog/top.v
  /home/germancq/gitProjects/BIST_measurements/python/7_seg/build/nexys4DDR_7seg_test_0/src/nexys4DDR_7seg_test_0/rtl/verilog/misc/contador_up.v
  /home/germancq/gitProjects/BIST_measurements/python/7_seg/build/nexys4DDR_7seg_test_0/src/nexys4DDR_7seg_test_0/rtl/verilog/misc/genericMux.v
  /home/germancq/gitProjects/BIST_measurements/python/7_seg/build/nexys4DDR_7seg_test_0/src/nexys4DDR_7seg_test_0/rtl/verilog/misc/registro_desp.v
  /home/germancq/gitProjects/BIST_measurements/python/7_seg/build/nexys4DDR_7seg_test_0/src/nexys4DDR_7seg_test_0/rtl/verilog/misc/registro.v
  /home/germancq/gitProjects/BIST_measurements/python/7_seg/build/nexys4DDR_7seg_test_0/src/nexys4DDR_7seg_test_0/rtl/verilog/7_seg/display.v
  /home/germancq/gitProjects/BIST_measurements/python/7_seg/build/nexys4DDR_7seg_test_0/src/nexys4DDR_7seg_test_0/rtl/verilog/7_seg/an_gen.v
  /home/germancq/gitProjects/BIST_measurements/python/7_seg/build/nexys4DDR_7seg_test_0/src/nexys4DDR_7seg_test_0/rtl/verilog/7_seg/dec_to_7_seg.v
  /home/germancq/gitProjects/BIST_measurements/python/7_seg/build/nexys4DDR_7seg_test_0/src/nexys4DDR_7seg_test_0/rtl/verilog/7_seg/div_clk_module.v
  /home/germancq/gitProjects/BIST_measurements/python/7_seg/build/nexys4DDR_7seg_test_0/src/nexys4DDR_7seg_test_0/rtl/verilog/7_seg/mux_8.v
  /home/germancq/gitProjects/BIST_measurements/python/7_seg/build/nexys4DDR_7seg_test_0/src/nexys4DDR_7seg_test_0/rtl/verilog/autotest_module/autotest_module.v
  /home/germancq/gitProjects/BIST_measurements/python/7_seg/build/nexys4DDR_7seg_test_0/src/nexys4DDR_7seg_test_0/rtl/verilog/autotest_module/fsm_autotest.v
  /home/germancq/gitProjects/BIST_measurements/python/7_seg/build/nexys4DDR_7seg_test_0/src/nexys4DDR_7seg_test_0/rtl/verilog/autotest_module/sdspi/sdspihost.v
  /home/germancq/gitProjects/BIST_measurements/python/7_seg/build/nexys4DDR_7seg_test_0/src/nexys4DDR_7seg_test_0/rtl/verilog/autotest_module/sdspi/sdcmd.v
  /home/germancq/gitProjects/BIST_measurements/python/7_seg/build/nexys4DDR_7seg_test_0/src/nexys4DDR_7seg_test_0/rtl/verilog/autotest_module/sdspi/spi_master.v
}
foreach dcp [get_files -quiet -all *.dcp] {
  set_property used_in_implementation false $dcp
}
read_xdc /home/germancq/gitProjects/BIST_measurements/python/7_seg/build/nexys4DDR_7seg_test_0/src/nexys4DDR_7seg_test_0/data/Nexys4DDR_Master.xdc
set_property used_in_implementation false [get_files /home/germancq/gitProjects/BIST_measurements/python/7_seg/build/nexys4DDR_7seg_test_0/src/nexys4DDR_7seg_test_0/data/Nexys4DDR_Master.xdc]


synth_design -top top -part xc7a100tcsg324-2


write_checkpoint -force -noxdef top.dcp

catch { report_utilization -file top_utilization_synth.rpt -pb top_utilization_synth.pb }
