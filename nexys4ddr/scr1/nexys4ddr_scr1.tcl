
# Set the reference directory for source file relative paths (by default the value is script directory path)
set origin_dir "."

# Use origin directory path location variable, if specified in the tcl shell
if { [info exists ::origin_dir_loc] } {
  set origin_dir $::origin_dir_loc
}

# Set the project name
set _xil_proj_name_ "nexys4ddr_scr1"

# Use project name variable, if specified in the tcl shell
if { [info exists ::user_project_name] } {
  set _xil_proj_name_ $::user_project_name
}

variable script_file
set script_file "nexys4ddr_scr1.tcl"

# Help information for this script
proc help {} {
  variable script_file
  puts "\nDescription:"
  puts "Recreate a Vivado project from this script. The created project will be"
  puts "functionally equivalent to the original project for which this script was"
  puts "generated. The script contains commands for creating a project, filesets,"
  puts "runs, adding/importing sources and setting properties on various objects.\n"
  puts "Syntax:"
  puts "$script_file"
  puts "$script_file -tclargs \[--origin_dir <path>\]"
  puts "$script_file -tclargs \[--project_name <name>\]"
  puts "$script_file -tclargs \[--help\]\n"
  puts "Usage:"
  puts "Name                   Description"
  puts "-------------------------------------------------------------------------"
  puts "\[--origin_dir <path>\]  Determine source file paths wrt this path. Default"
  puts "                       origin_dir path value is \".\", otherwise, the value"
  puts "                       that was set with the \"-paths_relative_to\" switch"
  puts "                       when this script was generated.\n"
  puts "\[--project_name <name>\] Create project with the specified name. Default"
  puts "                       name is the name of the project from where this"
  puts "                       script was generated.\n"
  puts "\[--help\]               Print help information for this script"
  puts "-------------------------------------------------------------------------\n"
  exit 0
}

if { $::argc > 0 } {
  for {set i 0} {$i < $::argc} {incr i} {
    set option [string trim [lindex $::argv $i]]
    switch -regexp -- $option {
      "--origin_dir"   { incr i; set origin_dir [lindex $::argv $i] }
      "--project_name" { incr i; set _xil_proj_name_ [lindex $::argv $i] }
      "--help"         { help }
      default {
        if { [regexp {^-} $option] } {
          puts "ERROR: Unknown option '$option' specified, please type '$script_file -tclargs --help' for usage info.\n"
          return 1
        }
      }
    }
  }
}

# Set the directory path for the original project from where this script was exported
set orig_proj_dir "[file normalize "$origin_dir/nexys4ddr_scr1"]"

# Create project
create_project ${_xil_proj_name_} ./${_xil_proj_name_} -part xc7a100tcsg324-1

# Set the directory path for the new project
set proj_dir [get_property directory [current_project]]

# Reconstruct message rules
set_msg_config  -ruleid {1}  -id {Synth 8-5858}  -suppress  -source 16
set_msg_config  -ruleid {14}  -id {[BD 41-1306]}  -suppress  -source 2
set_msg_config  -ruleid {15}  -id {[BD 41-1271]}  -suppress  -source 2
set_msg_config  -ruleid {2}  -id {Synth 8-5856}  -suppress  -source 16
set_msg_config  -ruleid {3}  -id {Synth 8-3917}  -suppress  -source 16


# Set project properties
set obj [current_project]
set_property -name "board_part" -value "digilentinc.com:nexys4_ddr:part0:1.1" -objects $obj
set_property -name "default_lib" -value "xil_defaultlib" -objects $obj
set_property -name "ip_cache_permissions" -value "read write" -objects $obj
set_property -name "ip_output_repo" -value "$proj_dir/${_xil_proj_name_}.cache/ip" -objects $obj
set_property -name "sim.ip.auto_export_scripts" -value "1" -objects $obj
set_property -name "simulator_language" -value "Mixed" -objects $obj
set_property -name "source_mgmt_mode" -value "DisplayOnly" -objects $obj
set_property -name "xpm_libraries" -value "XPM_CDC XPM_FIFO XPM_MEMORY" -objects $obj

# Create 'sources_1' fileset (if not found)
if {[string equal [get_filesets -quiet sources_1] ""]} {
  create_fileset -srcset sources_1
}

# Set 'sources_1' fileset object
set obj [get_filesets sources_1]
set files [list \
 "[file normalize "$origin_dir/../../../scr1/src/includes/scr1_arch_description.svh"]"\
 "[file normalize "$origin_dir/src/scr1_arch_custom.svh"]"\
 "[file normalize "$origin_dir/../../../scr1/src/includes/scr1_arch_types.svh"]"\
 "[file normalize "$origin_dir/../../../scr1/src/includes/scr1_riscv_isa_decoding.svh"]"\
 "[file normalize "$origin_dir/../../../scr1/src/includes/scr1_search_ms1.svh"]"\
 "[file normalize "$origin_dir/../../../scr1/src/includes/scr1_ipic.svh"]"\
 "[file normalize "$origin_dir/../../../scr1/src/includes/scr1_memif.svh"]"\
 "[file normalize "$origin_dir/../../../scr1/src/includes/scr1_tdu.svh"]"\
 "[file normalize "$origin_dir/../../../scr1/src/includes/scr1_hdu.svh"]"\
 "[file normalize "$origin_dir/../../../scr1/src/includes/scr1_tapc.svh"]"\
 "[file normalize "$origin_dir/../../../scr1/src/includes/scr1_dm.svh"]"\
 "[file normalize "$origin_dir/../../../scr1/src/core/pipeline/scr1_pipe_mprf.sv"]"\
 "[file normalize "$origin_dir/../../../scr1/src/core/pipeline/scr1_pipe_lsu.sv"]"\
 "[file normalize "$origin_dir/../../../scr1/src/core/pipeline/scr1_pipe_ifu.sv"]"\
 "[file normalize "$origin_dir/../../../scr1/src/core/pipeline/scr1_pipe_idu.sv"]"\
 "[file normalize "$origin_dir/../../../scr1/src/core/pipeline/scr1_pipe_ialu.sv"]"\
 "[file normalize "$origin_dir/../../../scr1/src/core/pipeline/scr1_pipe_exu.sv"]"\
 "[file normalize "$origin_dir/../../../scr1/src/core/pipeline/scr1_pipe_hdu.sv"]"\
 "[file normalize "$origin_dir/../../../scr1/src/core/pipeline/scr1_pipe_csr.sv"]"\
 "[file normalize "$origin_dir/../../../scr1/src/core/pipeline/scr1_ipic.sv"]"\
  "[file normalize "$origin_dir/../../../scr1/src/core/pipeline/scr1_pipe_tdu.sv"]"\
 "[file normalize "$origin_dir/../../../scr1/src/core/pipeline/scr1_pipe_top.sv"]"\
 "[file normalize "$origin_dir/../../../scr1/src/core/primitives/scr1_reset_cells.sv"]"\
 "[file normalize "$origin_dir/../../../scr1/src/core/scr1_dm.sv"]"\
 "[file normalize "$origin_dir/../../../scr1/src/core/scr1_dmi.sv"]"\
 "[file normalize "$origin_dir/../../../scr1/src/core/scr1_scu.sv"]"\
 "[file normalize "$origin_dir/../../../scr1/src/core/scr1_tapc_synchronizer.sv"]"\
 "[file normalize "$origin_dir/../../../scr1/src/core/scr1_tapc_shift_reg.sv"]"\
 "[file normalize "$origin_dir/../../../scr1/src/core/scr1_tapc.sv"]"\
 "[file normalize "$origin_dir/../../../scr1/src/core/scr1_core_top.sv"]"\
 "[file normalize "$origin_dir/../../../scr1/src/top/scr1_dp_memory.sv"]"\
 "[file normalize "$origin_dir/../../../scr1/src/top/scr1_tcm.sv"]"\
 "[file normalize "$origin_dir/../../../scr1/src/top/scr1_imem_router.sv"]"\
 "[file normalize "$origin_dir/../../../scr1/src/top/scr1_dmem_router.sv"]"\
 "[file normalize "$origin_dir/../../../scr1/src/top/scr1_mem_axi.sv"]"\
 "[file normalize "$origin_dir/../../../scr1/src/top/scr1_timer.sv"]"\
 "[file normalize "$origin_dir/../../../scr1/src/top/scr1_top_axi.sv"]"\
 "[file normalize "$origin_dir/src/nexys4ddr_scr1.sv"]"\
]
add_files -norecurse -fileset $obj $files

# Set 'sources_1' fileset file properties for remote files
set file "$origin_dir/../../../scr1/src/includes/scr1_arch_description.svh"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "Verilog Header" -objects $file_obj

set file "$origin_dir/src/scr1_arch_custom.svh"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "Verilog Header" -objects $file_obj

set file "$origin_dir/../../../scr1/src/includes/scr1_arch_types.svh"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "Verilog Header" -objects $file_obj

set file "$origin_dir/../../../scr1/src/includes/scr1_riscv_isa_decoding.svh"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "Verilog Header" -objects $file_obj

set file "$origin_dir/../../../scr1/src/includes/scr1_search_ms1.svh"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "Verilog Header" -objects $file_obj

set file "$origin_dir/../../../scr1/src/includes/scr1_ipic.svh"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "Verilog Header" -objects $file_obj

set file "$origin_dir/../../../scr1/src/includes/scr1_memif.svh"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "Verilog Header" -objects $file_obj

set file "$origin_dir/../../../scr1/src/includes/scr1_tdu.svh"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "Verilog Header" -objects $file_obj

set file "$origin_dir/../../../scr1/src/includes/scr1_hdu.svh"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "Verilog Header" -objects $file_obj

set file "$origin_dir/../../../scr1/src/includes/scr1_tapc.svh"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "Verilog Header" -objects $file_obj

set file "$origin_dir/../../../scr1/src/includes/scr1_dm.svh"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "Verilog Header" -objects $file_obj

set file "$origin_dir/../../../scr1/src/core/pipeline/scr1_pipe_mprf.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../../scr1/src/core/pipeline/scr1_pipe_lsu.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../../scr1/src/core/pipeline/scr1_pipe_ifu.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../../scr1/src/core/pipeline/scr1_pipe_idu.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../../scr1/src/core/pipeline/scr1_pipe_ialu.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../../scr1/src/core/pipeline/scr1_pipe_exu.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../../scr1/src/core/pipeline/scr1_pipe_hdu.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../../scr1/src/core/pipeline/scr1_pipe_csr.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../../scr1/src/core/pipeline/scr1_ipic.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../../scr1/src/core/pipeline/scr1_pipe_tdu.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../../scr1/src/core/pipeline/scr1_pipe_top.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../../scr1/src/core/primitives/scr1_reset_cells.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../../scr1/src/core/scr1_dm.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../../scr1/src/core/scr1_dmi.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../../scr1/src/core/scr1_scu.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../../scr1/src/core/scr1_tapc_synchronizer.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../../scr1/src/core/scr1_tapc_shift_reg.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../../scr1/src/core/scr1_tapc.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../../scr1/src/core/scr1_core_top.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../../scr1/src/top/scr1_dp_memory.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../../scr1/src/top/scr1_tcm.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../../scr1/src/top/scr1_imem_router.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../../scr1/src/top/scr1_dmem_router.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../../scr1/src/top/scr1_mem_axi.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../../scr1/src/top/scr1_timer.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../../scr1/src/top/scr1_top_axi.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/src/nexys4ddr_scr1.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

# Set 'sources_1' fileset file properties for local files
# None

# Set 'sources_1' fileset properties
set obj [get_filesets sources_1]
set_property -name "top" -value "nexys4ddr_scr1" -objects $obj
set_property -name "verilog_define" -value "SCR1_ARCH_CUSTOM=1" -objects $obj

# Create 'constrs_1' fileset (if not found)
if {[string equal [get_filesets -quiet constrs_1] ""]} {
  create_fileset -constrset constrs_1
}

# Set 'constrs_1' fileset object
set obj [get_filesets constrs_1]

# Add/Import constrs file and set constrs file properties
set file "[file normalize "$origin_dir/constrs/nexys4ddr_scr1_synth.xdc"]"
set file_added [add_files -norecurse -fileset $obj [list $file]]
set file "$origin_dir/constrs/nexys4ddr_scr1_synth.xdc"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets constrs_1] [list "*$file"]]
set_property -name "file_type" -value "XDC" -objects $file_obj

# Set 'constrs_1' fileset properties
set obj [get_filesets constrs_1]
set_property -name "target_constrs_file" -value "[file normalize "$origin_dir/constrs/nexys4ddr_scr1_synth.xdc"]" -objects $obj

# Create 'constrs_2' fileset (if not found)
if {[string equal [get_filesets -quiet constrs_2] ""]} {
  create_fileset -constrset constrs_2
}

# Set 'constrs_2' fileset object
set obj [get_filesets constrs_2]

# Add/Import constrs file and set constrs file properties
set file "[file normalize "$origin_dir/constrs/nexys4ddr_scr1_synth.xdc"]"
set file_added [add_files -norecurse -fileset $obj [list $file]]
set file "$origin_dir/constrs/nexys4ddr_scr1_synth.xdc"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets constrs_2] [list "*$file"]]
set_property -name "file_type" -value "XDC" -objects $file_obj

# Add/Import constrs file and set constrs file properties
set file "[file normalize "$origin_dir/constrs/nexys4ddr_scr1_physical.xdc"]"
set file_added [add_files -norecurse -fileset $obj [list $file]]
set file "$origin_dir/constrs/nexys4ddr_scr1_physical.xdc"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets constrs_2] [list "*$file"]]
set_property -name "file_type" -value "XDC" -objects $file_obj

# Add/Import constrs file and set constrs file properties
set file "[file normalize "$origin_dir/constrs/nexys4ddr_scr1_timing.xdc"]"
set file_added [add_files -norecurse -fileset $obj [list $file]]
set file "$origin_dir/constrs/nexys4ddr_scr1_timing.xdc"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets constrs_2] [list "*$file"]]
set_property -name "file_type" -value "XDC" -objects $file_obj

# Set 'constrs_2' fileset properties
#set obj [get_filesets constrs_2]

# Create 'sim_1' fileset (if not found)
if {[string equal [get_filesets -quiet sim_1] ""]} {
  create_fileset -simset sim_1
}

# Set 'sim_1' fileset object
set obj [get_filesets sim_1]
# Empty (no sources present)

# Set 'sim_1' fileset properties
set obj [get_filesets sim_1]
set_property -name "top" -value "nexys4ddr_scr1" -objects $obj
set_property -name "verilog_define" -value "SCR1_ARCH_CUSTOM=1" -objects $obj


# Adding sources referenced in BDs, if not already added


# Proc to create BD nexys4ddr_sopc
proc cr_bd_nexys4ddr_sopc { parentCell } {

  # CHANGE DESIGN NAME HERE
  set design_name nexys4ddr_sopc

  common::send_msg_id "BD_TCL-003" "INFO" "Currently there is no design <$design_name> in project, so creating one..."

  create_bd_design $design_name

  set bCheckIPsPassed 1
  ##################################################################
  # CHECK IPs
  ##################################################################
  set bCheckIPs 1
  if { $bCheckIPs == 1 } {
    if {[expr [string range [version -short] 0 5] > "2018.2"]} {
      set list_check_ips "\ 
      xilinx.com:ip:axi_gpio:2.0\
      xilinx.com:ip:blk_mem_gen:8.4\
      xilinx.com:ip:axi_bram_ctrl:4.1\
      xilinx.com:ip:clk_wiz:6.0\
      xilinx.com:ip:axi_clock_converter:2.1\
      xilinx.com:ip:mig_7series:4.2\
      xilinx.com:ip:proc_sys_reset:5.0\
      xilinx.com:ip:smartconnect:1.0\
      xilinx.com:ip:axi_uart16550:2.0\
      xilinx.com:ip:util_vector_logic:2.0\
      xilinx.com:ip:xlconstant:1.1\
      "
    } else {
      set list_check_ips "\ 
      xilinx.com:ip:axi_gpio:2.0\
      xilinx.com:ip:blk_mem_gen:8.4\
      xilinx.com:ip:axi_bram_ctrl:4.0\
      xilinx.com:ip:clk_wiz:6.0\
      xilinx.com:ip:axi_clock_converter:2.1\
      xilinx.com:ip:mig_7series:4.1\
      xilinx.com:ip:proc_sys_reset:5.0\
      xilinx.com:ip:smartconnect:1.0\
      xilinx.com:ip:axi_uart16550:2.0\
      xilinx.com:ip:util_vector_logic:2.0\
      xilinx.com:ip:xlconstant:1.1\
      "
    }

   set list_ips_missing ""
   common::send_msg_id "BD_TCL-006" "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

   foreach ip_vlnv $list_check_ips {
      set ip_obj [get_ipdefs -all $ip_vlnv]
      if { $ip_obj eq "" } {
         lappend list_ips_missing $ip_vlnv
      }
   }

   if { $list_ips_missing ne "" } {
      catch {common::send_msg_id "BD_TCL-115" "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
      set bCheckIPsPassed 0
   }

  }

  if { $bCheckIPsPassed != 1 } {
    common::send_msg_id "BD_TCL-1003" "WARNING" "Will not continue with creation of design due to the error(s) above."
    return 3
  }

  variable script_folder

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set axi_dmem [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 axi_dmem ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {32} \
   CONFIG.ARUSER_WIDTH {0} \
   CONFIG.AWUSER_WIDTH {0} \
   CONFIG.BUSER_WIDTH {0} \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.HAS_BRESP {1} \
   CONFIG.HAS_BURST {1} \
   CONFIG.HAS_CACHE {1} \
   CONFIG.HAS_LOCK {0} \
   CONFIG.HAS_PROT {0} \
   CONFIG.HAS_QOS {0} \
   CONFIG.HAS_REGION {0} \
   CONFIG.HAS_RRESP {1} \
   CONFIG.HAS_WSTRB {1} \
   CONFIG.ID_WIDTH {4} \
   CONFIG.MAX_BURST_LENGTH {8} \
   CONFIG.NUM_READ_OUTSTANDING {0} \
   CONFIG.NUM_READ_THREADS {1} \
   CONFIG.NUM_WRITE_OUTSTANDING {0} \
   CONFIG.NUM_WRITE_THREADS {1} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   CONFIG.RUSER_BITS_PER_BYTE {0} \
   CONFIG.RUSER_WIDTH {0} \
   CONFIG.SUPPORTS_NARROW_BURST {1} \
   CONFIG.WUSER_BITS_PER_BYTE {0} \
   CONFIG.WUSER_WIDTH {0} \
   ] $axi_dmem
  set axi_imem [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 axi_imem ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {32} \
   CONFIG.ARUSER_WIDTH {0} \
   CONFIG.AWUSER_WIDTH {0} \
   CONFIG.BUSER_WIDTH {0} \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.HAS_BRESP {1} \
   CONFIG.HAS_BURST {1} \
   CONFIG.HAS_CACHE {1} \
   CONFIG.HAS_LOCK {0} \
   CONFIG.HAS_PROT {0} \
   CONFIG.HAS_QOS {0} \
   CONFIG.HAS_REGION {0} \
   CONFIG.HAS_RRESP {1} \
   CONFIG.HAS_WSTRB {1} \
   CONFIG.ID_WIDTH {4} \
   CONFIG.MAX_BURST_LENGTH {8} \
   CONFIG.NUM_READ_OUTSTANDING {8} \
   CONFIG.NUM_READ_THREADS {1} \
   CONFIG.NUM_WRITE_OUTSTANDING {8} \
   CONFIG.NUM_WRITE_THREADS {1} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_ONLY} \
   CONFIG.RUSER_BITS_PER_BYTE {0} \
   CONFIG.RUSER_WIDTH {0} \
   CONFIG.SUPPORTS_NARROW_BURST {1} \
   CONFIG.WUSER_BITS_PER_BYTE {0} \
   CONFIG.WUSER_WIDTH {0} \
   ] $axi_imem
  set bld_id [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 bld_id ]
  set core_clk_freq [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 core_clk_freq ]
  set ddr2 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 ddr2 ]
  set soc_id [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 soc_id ]
  set uart [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:uart_rtl:1.0 uart ]

  # Create ports
  set cpu_clk_o [ create_bd_port -dir O -type clk cpu_clk_o ]
  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {axi_imem:axi_dmem} \
   CONFIG.ASSOCIATED_RESET {rstn} \
 ] $cpu_clk_o
  set cpu_reset_o [ create_bd_port -dir O -type rst cpu_reset_o ]
  set ddr2_init_complete [ create_bd_port -dir O ddr2_init_complete ]
  set osc_clk [ create_bd_port -dir I -type clk osc_clk ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {100000000} \
   CONFIG.PHASE {0.000} \
 ] $osc_clk
  set pwrup_rst_n_o [ create_bd_port -dir O -type rst pwrup_rst_n_o ]
  set soc_rst_n [ create_bd_port -dir I -type rst soc_rst_n ]
  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_LOW} \
 ] $soc_rst_n
  set uart_irq [ create_bd_port -dir O -type intr uart_irq ]

  # Create instance: bld_id, and set properties
  set bld_id [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 bld_id ]
  set_property -dict [ list \
   CONFIG.C_ALL_INPUTS {1} \
 ] $bld_id

  # Create instance: blk_mem_gen_0, and set properties
  set blk_mem_gen_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 blk_mem_gen_0 ]
  set_property -dict [ list \
   CONFIG.Assume_Synchronous_Clk {true} \
   CONFIG.EN_SAFETY_CKT {false} \
   CONFIG.Enable_B {Use_ENB_Pin} \
   CONFIG.Memory_Type {True_Dual_Port_RAM} \
   CONFIG.Port_B_Clock {100} \
   CONFIG.Port_B_Enable_Rate {100} \
   CONFIG.Port_B_Write_Rate {50} \
   CONFIG.Use_RSTB_Pin {true} \
 ] $blk_mem_gen_0

  # Create instance: bram_ctrl, and set properties
if {[expr [string range [version -short] 0 5] > "2018.2"]} {
  set bram_ctrl [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.1 bram_ctrl ]
} else {
  set bram_ctrl [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 bram_ctrl ]
}
  set_property -dict [ list \
   CONFIG.C_SELECT_XPM {0} \
   CONFIG.SINGLE_PORT_BRAM {0} \
 ] $bram_ctrl

  # Create instance: clk_wiz_0, and set properties
  set clk_wiz_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_wiz_0 ]
  set_property -dict [ list \
   CONFIG.CLKOUT1_JITTER {193.277} \
   CONFIG.CLKOUT1_PHASE_ERROR {132.063} \
   CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {30.000} \
   CONFIG.CLKOUT2_JITTER {132.221} \
   CONFIG.CLKOUT2_PHASE_ERROR {132.063} \
   CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {200.000} \
   CONFIG.CLKOUT2_USED {true} \
   CONFIG.CLK_IN1_BOARD_INTERFACE {Custom} \
   CONFIG.MMCM_CLKFBOUT_MULT_F {6.000} \
   CONFIG.MMCM_CLKIN1_PERIOD {10.0} \
   CONFIG.MMCM_CLKIN2_PERIOD {10.0} \
   CONFIG.MMCM_CLKOUT0_DIVIDE_F {20.000} \
   CONFIG.MMCM_CLKOUT1_DIVIDE {3} \
   CONFIG.MMCM_DIVCLK_DIVIDE {1} \
   CONFIG.NUM_OUT_CLKS {2} \
   CONFIG.RESET_BOARD_INTERFACE {Custom} \
   CONFIG.RESET_PORT {resetn} \
   CONFIG.RESET_TYPE {ACTIVE_LOW} \
   CONFIG.USE_BOARD_FLOW {true} \
   CONFIG.USE_LOCKED {true} \
   CONFIG.USE_RESET {true} \
 ] $clk_wiz_0

  # Create instance: core_clk_freq, and set properties
  set core_clk_freq [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 core_clk_freq ]
  set_property -dict [ list \
   CONFIG.C_ALL_INPUTS {1} \
 ] $core_clk_freq

  # Create instance: ddr2_sdram, and set properties
  if {[expr [string range [version -short] 0 5] > "2018.2"]} {
    set ddr2_sdram [ create_bd_cell -type ip -vlnv xilinx.com:ip:mig_7series:4.2 ddr2_sdram ]
  } else {
    set ddr2_sdram [ create_bd_cell -type ip -vlnv xilinx.com:ip:mig_7series:4.1 ddr2_sdram ]
  }

  set_property -dict [ list \
   CONFIG.BOARD_MIG_PARAM {ddr2_sdram} \
 ] $ddr2_sdram

  # Create instance: ddr_clock_converter_0, and set properties
  set ddr_clock_converter_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_clock_converter:2.1 ddr_clock_converter_0 ]

  # Create instance: riscv_rstn, and set properties
  set riscv_rstn [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 riscv_rstn ]
  set_property -dict [ list \
   CONFIG.RESET_BOARD_INTERFACE {reset} \
   CONFIG.USE_BOARD_FLOW {true} \
 ] $riscv_rstn

  # Create instance: smartconnect_0, and set properties
  set smartconnect_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_0 ]
  set_property -dict [ list \
   CONFIG.HAS_ARESETN {1} \
   CONFIG.NUM_CLKS {1} \
   CONFIG.NUM_MI {6} \
   CONFIG.NUM_SI {2} \
 ] $smartconnect_0

  # Create instance: soc_id, and set properties
  set soc_id [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 soc_id ]
  set_property -dict [ list \
   CONFIG.C_ALL_INPUTS {1} \
 ] $soc_id

  # Create instance: uart, and set properties
  set uart [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_uart16550:2.0 uart ]
  set_property -dict [ list \
   CONFIG.C_S_AXI_ACLK_FREQ_HZ {30000000} \
   CONFIG.UART_BOARD_INTERFACE {Custom} \
   CONFIG.USE_BOARD_FLOW {true} \
 ] $uart

  # Create instance: util_vector_logic_0, and set properties
  set util_vector_logic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_0 ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {not} \
   CONFIG.C_SIZE {1} \
   CONFIG.LOGO_FILE {data/sym_notgate.png} \
 ] $util_vector_logic_0

  # Create instance: xlconstant_log_1, and set properties
  set xlconstant_log_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_log_1 ]

  # Create interface connections
  connect_bd_intf_net -intf_net axi [get_bd_intf_ports axi_imem] [get_bd_intf_pins smartconnect_0/S00_AXI]
  connect_bd_intf_net -intf_net axi_gpio_0_GPIO [get_bd_intf_ports soc_id] [get_bd_intf_pins soc_id/GPIO]
  connect_bd_intf_net -intf_net axi_nc_1 [get_bd_intf_ports axi_dmem] [get_bd_intf_pins smartconnect_0/S01_AXI]
  connect_bd_intf_net -intf_net bld_id_GPIO [get_bd_intf_ports bld_id] [get_bd_intf_pins bld_id/GPIO]
  connect_bd_intf_net -intf_net bram_ctrl_BRAM_PORTA [get_bd_intf_pins blk_mem_gen_0/BRAM_PORTA] [get_bd_intf_pins bram_ctrl/BRAM_PORTA]
  connect_bd_intf_net -intf_net bram_ctrl_BRAM_PORTB [get_bd_intf_pins blk_mem_gen_0/BRAM_PORTB] [get_bd_intf_pins bram_ctrl/BRAM_PORTB]
  connect_bd_intf_net -intf_net core_clk_freq_GPIO [get_bd_intf_ports core_clk_freq] [get_bd_intf_pins core_clk_freq/GPIO]
  connect_bd_intf_net -intf_net ddr_clock_converter_0_M_AXI [get_bd_intf_pins ddr2_sdram/S_AXI] [get_bd_intf_pins ddr_clock_converter_0/M_AXI]
  connect_bd_intf_net -intf_net mig_7series_0_DDR2 [get_bd_intf_ports ddr2] [get_bd_intf_pins ddr2_sdram/DDR2]
  connect_bd_intf_net -intf_net smartconnect_0_M00_AXI [get_bd_intf_pins bram_ctrl/S_AXI] [get_bd_intf_pins smartconnect_0/M00_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M01_AXI [get_bd_intf_pins smartconnect_0/M01_AXI] [get_bd_intf_pins uart/S_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M02_AXI [get_bd_intf_pins smartconnect_0/M02_AXI] [get_bd_intf_pins soc_id/S_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M03_AXI [get_bd_intf_pins ddr_clock_converter_0/S_AXI] [get_bd_intf_pins smartconnect_0/M03_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M04_AXI [get_bd_intf_pins bld_id/S_AXI] [get_bd_intf_pins smartconnect_0/M04_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M05_AXI [get_bd_intf_pins core_clk_freq/S_AXI] [get_bd_intf_pins smartconnect_0/M05_AXI]
  connect_bd_intf_net -intf_net uart_UART [get_bd_intf_ports uart] [get_bd_intf_pins uart/UART]

  # Create port connections
  connect_bd_net -net axi_uart16550_0_ip2intc_irpt [get_bd_ports uart_irq] [get_bd_pins uart/ip2intc_irpt]
  connect_bd_net -net clk_RISCV [get_bd_ports cpu_clk_o] [get_bd_pins bld_id/s_axi_aclk] [get_bd_pins bram_ctrl/s_axi_aclk] [get_bd_pins clk_wiz_0/clk_out1] [get_bd_pins core_clk_freq/s_axi_aclk] [get_bd_pins ddr_clock_converter_0/s_axi_aclk] [get_bd_pins riscv_rstn/slowest_sync_clk] [get_bd_pins smartconnect_0/aclk] [get_bd_pins soc_id/s_axi_aclk] [get_bd_pins uart/s_axi_aclk]
  connect_bd_net -net clk_wiz_0_clk_out2 [get_bd_pins clk_wiz_0/clk_out2] [get_bd_pins ddr2_sdram/sys_clk_i]
  connect_bd_net -net clk_wiz_0_locked [get_bd_ports pwrup_rst_n_o] [get_bd_pins clk_wiz_0/locked] [get_bd_pins riscv_rstn/dcm_locked]
  connect_bd_net -net ddr_rstn_interconnect_aresetn [get_bd_pins ddr2_sdram/aresetn] [get_bd_pins ddr_clock_converter_0/m_axi_aresetn] [get_bd_pins util_vector_logic_0/Res]
  connect_bd_net -net mig_7series_0_init_calib_complete [get_bd_ports ddr2_init_complete] [get_bd_pins ddr2_sdram/init_calib_complete]
  connect_bd_net -net mig_7series_0_ui_clk_sync_rst [get_bd_pins ddr2_sdram/ui_clk_sync_rst] [get_bd_pins riscv_rstn/mb_debug_sys_rst] [get_bd_pins util_vector_logic_0/Op1]
  connect_bd_net -net mig_7series_1_ui_clk [get_bd_pins ddr2_sdram/ui_clk] [get_bd_pins ddr_clock_converter_0/m_axi_aclk]
  connect_bd_net -net proc_sys_reset_0_interconnect_aresetn [get_bd_pins ddr_clock_converter_0/s_axi_aresetn] [get_bd_pins riscv_rstn/interconnect_aresetn] [get_bd_pins smartconnect_0/aresetn]
  connect_bd_net -net reset [get_bd_ports soc_rst_n] [get_bd_pins ddr2_sdram/sys_rst] [get_bd_pins riscv_rstn/ext_reset_in]
  connect_bd_net -net riscv_rstn_mb_reset [get_bd_ports cpu_reset_o] [get_bd_pins riscv_rstn/mb_reset]
  connect_bd_net -net riscv_rstn_peripheral_aresetn [get_bd_pins bld_id/s_axi_aresetn] [get_bd_pins bram_ctrl/s_axi_aresetn] [get_bd_pins core_clk_freq/s_axi_aresetn] [get_bd_pins riscv_rstn/peripheral_aresetn] [get_bd_pins soc_id/s_axi_aresetn] [get_bd_pins uart/s_axi_aresetn]
  connect_bd_net -net sys_clock_1 [get_bd_ports osc_clk] [get_bd_pins clk_wiz_0/clk_in1]
  connect_bd_net -net xlconstant_log_1_dout [get_bd_pins clk_wiz_0/resetn] [get_bd_pins xlconstant_log_1/dout]

  # Create address segments
  create_bd_addr_seg -range 0x00001000 -offset 0xFF000000 [get_bd_addr_spaces axi_dmem] [get_bd_addr_segs soc_id/S_AXI/Reg] SEG_axi_gpio_0_Reg
  create_bd_addr_seg -range 0x00001000 -offset 0xFF001000 [get_bd_addr_spaces axi_dmem] [get_bd_addr_segs bld_id/S_AXI/Reg] SEG_bld_id_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0xFFFF0000 [get_bd_addr_spaces axi_dmem] [get_bd_addr_segs bram_ctrl/S_AXI/Mem0] SEG_bram_ctrl_Mem0
  create_bd_addr_seg -range 0x00010000 -offset 0xFFFF0000 [get_bd_addr_spaces axi_imem] [get_bd_addr_segs bram_ctrl/S_AXI/Mem0] SEG_bram_ctrl_Mem0
  create_bd_addr_seg -range 0x00001000 -offset 0xFF002000 [get_bd_addr_spaces axi_dmem] [get_bd_addr_segs core_clk_freq/S_AXI/Reg] SEG_core_clk_freq_Reg
  create_bd_addr_seg -range 0x08000000 -offset 0x00000000 [get_bd_addr_spaces axi_dmem] [get_bd_addr_segs ddr2_sdram/memmap/memaddr] SEG_mig_7series_0_memaddr
  create_bd_addr_seg -range 0x08000000 -offset 0x00000000 [get_bd_addr_spaces axi_imem] [get_bd_addr_segs ddr2_sdram/memmap/memaddr] SEG_mig_7series_0_memaddr
  create_bd_addr_seg -range 0x00001000 -offset 0xFF010000 [get_bd_addr_spaces axi_dmem] [get_bd_addr_segs uart/S_AXI/Reg] SEG_uart_Reg

  # Exclude Address Segments
  create_bd_addr_seg -range 0x00001000 -offset 0xFF000000 [get_bd_addr_spaces axi_imem] [get_bd_addr_segs soc_id/S_AXI/Reg] SEG_axi_gpio_0_Reg
  exclude_bd_addr_seg [get_bd_addr_segs axi_imem/SEG_axi_gpio_0_Reg]

  create_bd_addr_seg -range 0x00001000 -offset 0xFF001000 [get_bd_addr_spaces axi_imem] [get_bd_addr_segs bld_id/S_AXI/Reg] SEG_bld_id_Reg
  exclude_bd_addr_seg [get_bd_addr_segs axi_imem/SEG_bld_id_Reg]

  create_bd_addr_seg -range 0x00001000 -offset 0xFF002000 [get_bd_addr_spaces axi_imem] [get_bd_addr_segs core_clk_freq/S_AXI/Reg] SEG_core_clk_freq_Reg
  exclude_bd_addr_seg [get_bd_addr_segs axi_imem/SEG_core_clk_freq_Reg]

  create_bd_addr_seg -range 0x00001000 -offset 0xFF010000 [get_bd_addr_spaces axi_imem] [get_bd_addr_segs uart/S_AXI/Reg] SEG_uart_Reg
  exclude_bd_addr_seg [get_bd_addr_segs axi_imem/SEG_uart_Reg]



  # Restore current instance
  current_bd_instance $oldCurInst

  save_bd_design
  close_bd_design $design_name
}
# End of cr_bd_nexys4ddr_sopc()
cr_bd_nexys4ddr_sopc ""
set_property SYNTH_CHECKPOINT_MODE "Hierarchical" [get_files nexys4ddr_sopc.bd ] 

# Create 'synth_1' run (if not found)
if {[string equal [get_runs -quiet synth_1] ""]} {
    create_run -name synth_1 -part xc7a100tcsg324-1 -flow {Vivado Synthesis 2018} -strategy "Flow_PerfOptimized_high" -report_strategy {No Reports} -constrset constrs_1
} else {
  set_property strategy "Flow_PerfOptimized_high" [get_runs synth_1]
  set_property flow "Vivado Synthesis 2018" [get_runs synth_1]
}
set obj [get_runs synth_1]
set_property set_report_strategy_name 1 $obj
set_property report_strategy {Vivado Synthesis Default Reports} $obj
set_property set_report_strategy_name 0 $obj
# Create 'synth_1_synth_report_utilization_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs synth_1] synth_1_synth_report_utilization_0] "" ] } {
  create_report_config -report_name synth_1_synth_report_utilization_0 -report_type report_utilization:1.0 -steps synth_design -runs synth_1
}
set obj [get_report_configs -of_objects [get_runs synth_1] synth_1_synth_report_utilization_0]
if { $obj != "" } {

}
set obj [get_runs synth_1]
set_property -name "strategy" -value "Flow_PerfOptimized_high" -objects $obj

# set the current synth run
current_run -synthesis [get_runs synth_1]

# Create 'impl_1' run (if not found)
if {[string equal [get_runs -quiet impl_1] ""]} {
    create_run -name impl_1 -part xc7a100tcsg324-1 -flow {Vivado Implementation 2018} -strategy "Performance_ExtraTimingOpt" -report_strategy {No Reports} -constrset constrs_2 -parent_run synth_1
} else {
  set_property strategy "Performance_ExtraTimingOpt" [get_runs impl_1]
  set_property flow "Vivado Implementation 2018" [get_runs impl_1]
}
set obj [get_runs impl_1]
set_property set_report_strategy_name 1 $obj
set_property report_strategy {Vivado Implementation Default Reports} $obj
set_property set_report_strategy_name 0 $obj
# Create 'impl_1_init_report_timing_summary_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_init_report_timing_summary_0] "" ] } {
  create_report_config -report_name impl_1_init_report_timing_summary_0 -report_type report_timing_summary:1.0 -steps init_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_init_report_timing_summary_0]
if { $obj != "" } {
set_property -name "is_enabled" -value "0" -objects $obj

}
# Create 'impl_1_opt_report_drc_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_opt_report_drc_0] "" ] } {
  create_report_config -report_name impl_1_opt_report_drc_0 -report_type report_drc:1.0 -steps opt_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_opt_report_drc_0]
if { $obj != "" } {

}
# Create 'impl_1_opt_report_timing_summary_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_opt_report_timing_summary_0] "" ] } {
  create_report_config -report_name impl_1_opt_report_timing_summary_0 -report_type report_timing_summary:1.0 -steps opt_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_opt_report_timing_summary_0]
if { $obj != "" } {
set_property -name "is_enabled" -value "0" -objects $obj

}
# Create 'impl_1_power_opt_report_timing_summary_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_power_opt_report_timing_summary_0] "" ] } {
  create_report_config -report_name impl_1_power_opt_report_timing_summary_0 -report_type report_timing_summary:1.0 -steps power_opt_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_power_opt_report_timing_summary_0]
if { $obj != "" } {
set_property -name "is_enabled" -value "0" -objects $obj

}
# Create 'impl_1_place_report_io_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_place_report_io_0] "" ] } {
  create_report_config -report_name impl_1_place_report_io_0 -report_type report_io:1.0 -steps place_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_place_report_io_0]
if { $obj != "" } {

}
# Create 'impl_1_place_report_utilization_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_place_report_utilization_0] "" ] } {
  create_report_config -report_name impl_1_place_report_utilization_0 -report_type report_utilization:1.0 -steps place_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_place_report_utilization_0]
if { $obj != "" } {

}
# Create 'impl_1_place_report_control_sets_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_place_report_control_sets_0] "" ] } {
  create_report_config -report_name impl_1_place_report_control_sets_0 -report_type report_control_sets:1.0 -steps place_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_place_report_control_sets_0]
if { $obj != "" } {

}
# Create 'impl_1_place_report_incremental_reuse_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_place_report_incremental_reuse_0] "" ] } {
  create_report_config -report_name impl_1_place_report_incremental_reuse_0 -report_type report_incremental_reuse:1.0 -steps place_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_place_report_incremental_reuse_0]
if { $obj != "" } {
set_property -name "is_enabled" -value "0" -objects $obj

}
# Create 'impl_1_place_report_incremental_reuse_1' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_place_report_incremental_reuse_1] "" ] } {
  create_report_config -report_name impl_1_place_report_incremental_reuse_1 -report_type report_incremental_reuse:1.0 -steps place_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_place_report_incremental_reuse_1]
if { $obj != "" } {
set_property -name "is_enabled" -value "0" -objects $obj

}
# Create 'impl_1_place_report_timing_summary_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_place_report_timing_summary_0] "" ] } {
  create_report_config -report_name impl_1_place_report_timing_summary_0 -report_type report_timing_summary:1.0 -steps place_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_place_report_timing_summary_0]
if { $obj != "" } {
set_property -name "is_enabled" -value "0" -objects $obj

}
# Create 'impl_1_post_place_power_opt_report_timing_summary_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_post_place_power_opt_report_timing_summary_0] "" ] } {
  create_report_config -report_name impl_1_post_place_power_opt_report_timing_summary_0 -report_type report_timing_summary:1.0 -steps post_place_power_opt_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_post_place_power_opt_report_timing_summary_0]
if { $obj != "" } {
set_property -name "is_enabled" -value "0" -objects $obj

}
# Create 'impl_1_phys_opt_report_timing_summary_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_phys_opt_report_timing_summary_0] "" ] } {
  create_report_config -report_name impl_1_phys_opt_report_timing_summary_0 -report_type report_timing_summary:1.0 -steps phys_opt_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_phys_opt_report_timing_summary_0]
if { $obj != "" } {
set_property -name "is_enabled" -value "0" -objects $obj

}
# Create 'impl_1_route_report_drc_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_route_report_drc_0] "" ] } {
  create_report_config -report_name impl_1_route_report_drc_0 -report_type report_drc:1.0 -steps route_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_route_report_drc_0]
if { $obj != "" } {

}
# Create 'impl_1_route_report_methodology_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_route_report_methodology_0] "" ] } {
  create_report_config -report_name impl_1_route_report_methodology_0 -report_type report_methodology:1.0 -steps route_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_route_report_methodology_0]
if { $obj != "" } {

}
# Create 'impl_1_route_report_power_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_route_report_power_0] "" ] } {
  create_report_config -report_name impl_1_route_report_power_0 -report_type report_power:1.0 -steps route_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_route_report_power_0]
if { $obj != "" } {

}
# Create 'impl_1_route_report_route_status_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_route_report_route_status_0] "" ] } {
  create_report_config -report_name impl_1_route_report_route_status_0 -report_type report_route_status:1.0 -steps route_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_route_report_route_status_0]
if { $obj != "" } {

}
# Create 'impl_1_route_report_timing_summary_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_route_report_timing_summary_0] "" ] } {
  create_report_config -report_name impl_1_route_report_timing_summary_0 -report_type report_timing_summary:1.0 -steps route_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_route_report_timing_summary_0]
if { $obj != "" } {

}
# Create 'impl_1_route_report_incremental_reuse_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_route_report_incremental_reuse_0] "" ] } {
  create_report_config -report_name impl_1_route_report_incremental_reuse_0 -report_type report_incremental_reuse:1.0 -steps route_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_route_report_incremental_reuse_0]
if { $obj != "" } {

}
# Create 'impl_1_route_report_clock_utilization_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_route_report_clock_utilization_0] "" ] } {
  create_report_config -report_name impl_1_route_report_clock_utilization_0 -report_type report_clock_utilization:1.0 -steps route_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_route_report_clock_utilization_0]
if { $obj != "" } {

}
# Create 'impl_1_route_report_bus_skew_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_route_report_bus_skew_0] "" ] } {
  create_report_config -report_name impl_1_route_report_bus_skew_0 -report_type report_bus_skew:1.1 -steps route_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_route_report_bus_skew_0]
if { $obj != "" } {

}
# Create 'impl_1_post_route_phys_opt_report_timing_summary_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_post_route_phys_opt_report_timing_summary_0] "" ] } {
  create_report_config -report_name impl_1_post_route_phys_opt_report_timing_summary_0 -report_type report_timing_summary:1.0 -steps post_route_phys_opt_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_post_route_phys_opt_report_timing_summary_0]
if { $obj != "" } {

}
# Create 'impl_1_post_route_phys_opt_report_bus_skew_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_post_route_phys_opt_report_bus_skew_0] "" ] } {
  create_report_config -report_name impl_1_post_route_phys_opt_report_bus_skew_0 -report_type report_bus_skew:1.1 -steps post_route_phys_opt_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_post_route_phys_opt_report_bus_skew_0]
if { $obj != "" } {

}
set obj [get_runs impl_1]
set_property -name "constrset" -value "constrs_2" -objects $obj
set_property -name "strategy" -value "Performance_ExtraTimingOpt" -objects $obj
set_property -name "steps.place_design.args.directive" -value "ExtraTimingOpt" -objects $obj
set_property -name "steps.phys_opt_design.is_enabled" -value "1" -objects $obj
set_property -name "steps.phys_opt_design.args.directive" -value "Explore" -objects $obj
set_property -name "steps.route_design.args.directive" -value "NoTimingRelaxation" -objects $obj
set_property -name "steps.write_bitstream.args.readback_file" -value "0" -objects $obj
set_property -name "steps.write_bitstream.args.verbose" -value "0" -objects $obj

# set the current impl run
current_run -implementation [get_runs impl_1]

puts "INFO: Project created:${_xil_proj_name_}"
