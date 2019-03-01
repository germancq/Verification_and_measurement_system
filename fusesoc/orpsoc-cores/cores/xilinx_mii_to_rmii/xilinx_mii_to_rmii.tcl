create_project -force -in_memory xilinx_mii_to_rmii
set_property target_language verilog [current_project]
set_property part xc7a100tcsg324-1 [current_project]
read_ip xilinx_mii_to_rmii.xci
generate_target -force synthesis [get_files xilinx_mii_to_rmii.xci]
