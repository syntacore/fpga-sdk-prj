# Tcl-file for Xilinx Vivado projects: mem_update.tcl

# Input parameters:
set proj            [current_project]
set proj_dir        [get_property directory [current_project]]
set top_entity      [get_property top [get_filesets sources_1]]
set obj_dir         [get_property directory [get_runs impl_1]]
#set mem_file        "../[glob -nocomplain *.mem]"
set mem_file        "../scbl.mem"
set bit_file        "${top_entity}.bit"
set out_file        "${top_entity}_new.bit"
set cmd_file        "../write_mmi.tcl"
set sram_cell       "blk_mem_gen_0"
set mmi_file        "${sram_cell}.mmi"
set mcs_file        "${top_entity}_new.mcs"

# Normalization
set obj_dir         [file normalize "$obj_dir"]
set mem_file        [file normalize "$proj_dir/$mem_file"]
set bit_file        [file normalize "$obj_dir/$bit_file"]
set out_file        [file normalize "$obj_dir/$out_file"]
set cmd_file        [file normalize "$proj_dir/$cmd_file"]
set mmi_file        [file normalize "$obj_dir/$mmi_file"]
set mcs_file        [file normalize "$obj_dir/$mcs_file"]

# Check if necessary files are present
if {![file exists $bit_file]} {
    error "ERROR! Bit-file $bit_file is not found."
}
if {![file exists $mem_file]} {
    error "ERROR! Mem-file $mem_file is not found."
}

# Sourcing of write_mmi.tcl
# It is necessary for onchip memory initialization.
# For details refer to Xilinx AR 63042.
if {![file exists $cmd_file]} {
    error "ERROR! Tcl-script $cmd_file is not found."
} else {
    source -quiet $cmd_file
}

open_run -quiet impl_1

if {[get_cells -hierarchical $sram_cell] eq ""} {
    error "ERROR! SRAM cell $sram_cell is not found in the design impl_1."
}

write_mmi $sram_cell $mmi_file

exec updatemem -force --meminfo $mmi_file --data $mem_file --bit $bit_file \
    --proc "dummy" --out $out_file

write_cfgmem  -force -format mcs -size 16 -interface SPIx4 \
    -loadbit "up 0x00000000 $out_file " -checksum \
    -file "$mcs_file"
