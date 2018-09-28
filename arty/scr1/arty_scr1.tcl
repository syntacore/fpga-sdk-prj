
# Set the reference directory for source file relative paths (by default the value is script directory path)
set origin_dir "."

# Use origin directory path location variable, if specified in the tcl shell
if { [info exists ::origin_dir_loc] } {
  set origin_dir $::origin_dir_loc
}

variable script_file
set script_file "arty_scr1.tcl"

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
  puts "$script_file -tclargs \[--help\]\n"
  puts "Usage:"
  puts "Name                   Description"
  puts "-------------------------------------------------------------------------"
  puts "\[--origin_dir <path>\]  Determine source file paths wrt this path. Default"
  puts "                       origin_dir path value is \".\", otherwise, the value"
  puts "                       that was set with the \"-paths_relative_to\" switch"
  puts "                       when this script was generated.\n"
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
set orig_proj_dir "[file normalize "$origin_dir/"]"

# Create project
create_project arty_scr1 ./arty_scr1 -part xc7a35ticsg324-1L

# Set the directory path for the new project
set proj_dir [get_property directory [current_project]]

# Reconstruct message rules
# None

# Set project properties
set obj [get_projects arty_scr1]
set_property "board_part" "digilentinc.com:arty:part0:1.1" $obj
set_property "compxlib.activehdl_compiled_library_dir" "$proj_dir/arty_scr1.cache/compile_simlib/activehdl" $obj
set_property "compxlib.funcsim" "1" $obj
set_property "compxlib.ies_compiled_library_dir" "$proj_dir/arty_scr1.cache/compile_simlib/ies" $obj
set_property "compxlib.modelsim_compiled_library_dir" "$proj_dir/arty_scr1.cache/compile_simlib/modelsim" $obj
set_property "compxlib.overwrite_libs" "0" $obj
set_property "compxlib.questa_compiled_library_dir" "$proj_dir/arty_scr1.cache/compile_simlib/questa" $obj
set_property "compxlib.riviera_compiled_library_dir" "$proj_dir/arty_scr1.cache/compile_simlib/riviera" $obj
set_property "compxlib.timesim" "1" $obj
set_property "compxlib.vcs_compiled_library_dir" "$proj_dir/arty_scr1.cache/compile_simlib/vcs" $obj
set_property "compxlib.xsim_compiled_library_dir" "" $obj
set_property "corecontainer.enable" "0" $obj
set_property "default_lib" "xil_defaultlib" $obj
set_property "dsa.num_compute_units" "16" $obj
set_property "enable_optional_runs_sta" "0" $obj
set_property "generate_ip_upgrade_log" "1" $obj
set_property "ip_cache_permissions" "read write" $obj
set_property "ip_output_repo" "$proj_dir/arty_scr1.cache/ip" $obj
set_property "managed_ip" "0" $obj
set_property "pr_flow" "0" $obj
set_property "sim.ip.auto_export_scripts" "1" $obj
set_property "sim.use_ip_compiled_libs" "1" $obj
set_property "simulator_language" "Mixed" $obj
set_property "source_mgmt_mode" "DisplayOnly" $obj
set_property "target_language" "Verilog" $obj
set_property "target_simulator" "XSim" $obj
set_property "xpm_libraries" "" $obj
set_property "xsim.array_display_limit" "64" $obj
set_property "xsim.radix" "hex" $obj
set_property "xsim.time_unit" "ns" $obj
set_property "xsim.trace_limit" "65536" $obj

# Create 'sources_1' fileset (if not found)
if {[string equal [get_filesets -quiet sources_1] ""]} {
  create_fileset -srcset sources_1
}

# Set 'sources_1' fileset object
set obj [get_filesets sources_1]
set files [list \
 "[file normalize "$origin_dir/bd/system/system.bd"]"\
 "[file normalize "$origin_dir/bd/sys_pll/sys_pll.bd"]"\
 "[file normalize "$origin_dir/../../../scr1/src/includes/scr1_arch_description.svh"]"\
 "[file normalize "$origin_dir/src/scr1_arch_custom.svh"]"\
 "[file normalize "$origin_dir/../../../scr1/src/includes/scr1_arch_types.svh"]"\
 "[file normalize "$origin_dir/../../../scr1/src/includes/scr1_riscv_isa_decoding.svh"]"\
 "[file normalize "$origin_dir/../../../scr1/src/includes/scr1_search_ms1.svh"]"\
 "[file normalize "$origin_dir/../../../scr1/src/includes/scr1_ipic.svh"]"\
 "[file normalize "$origin_dir/../../../scr1/src/includes/scr1_memif.svh"]"\
 "[file normalize "$origin_dir/../../../scr1/src/includes/scr1_ahb.svh"]"\
 "[file normalize "$origin_dir/../../../scr1/src/includes/scr1_brkm.svh"]"\
 "[file normalize "$origin_dir/../../../scr1/src/includes/scr1_tapc.svh"]"\
 "[file normalize "$origin_dir/../../../scr1/src/includes/scr1_dbgc.svh"]"\
 "[file normalize "$origin_dir/../../../scr1/src/pipeline/scr1_pipe_mprf.sv"]"\
 "[file normalize "$origin_dir/../../../scr1/src/pipeline/scr1_pipe_lsu.sv"]"\
 "[file normalize "$origin_dir/../../../scr1/src/pipeline/scr1_pipe_ifu.sv"]"\
 "[file normalize "$origin_dir/../../../scr1/src/pipeline/scr1_pipe_idu.sv"]"\
 "[file normalize "$origin_dir/../../../scr1/src/pipeline/scr1_pipe_ialu.sv"]"\
 "[file normalize "$origin_dir/../../../scr1/src/pipeline/scr1_pipe_exu.sv"]"\
 "[file normalize "$origin_dir/../../../scr1/src/pipeline/scr1_pipe_dbga.sv"]"\
 "[file normalize "$origin_dir/../../../scr1/src/pipeline/scr1_pipe_csr.sv"]"\
 "[file normalize "$origin_dir/../../../scr1/src/pipeline/scr1_ipic.sv"]"\
 "[file normalize "$origin_dir/../../../scr1/src/pipeline/scr1_brkm_matcher.sv"]"\
 "[file normalize "$origin_dir/../../../scr1/src/pipeline/scr1_pipe_brkm.sv"]"\
 "[file normalize "$origin_dir/../../../scr1/src/pipeline/scr1_pipe_top.sv"]"\
 "[file normalize "$origin_dir/../../../scr1/src/core/scr1_sync_rstn.sv"]"\
 "[file normalize "$origin_dir/../../../scr1/src/core/scr1_dbgc.sv"]"\
 "[file normalize "$origin_dir/../../../scr1/src/core/scr1_tapc_synchronizer.sv"]"\
 "[file normalize "$origin_dir/../../../scr1/src/core/scr1_tapc_shift_reg.sv"]"\
 "[file normalize "$origin_dir/../../../scr1/src/core/scr1_tapc_data_reg.sv"]"\
 "[file normalize "$origin_dir/../../../scr1/src/core/scr1_tapc.sv"]"\
 "[file normalize "$origin_dir/../../../scr1/src/core/scr1_core_top.sv"]"\
 "[file normalize "$origin_dir/../../../scr1/src/top/scr1_dp_memory.sv"]"\
 "[file normalize "$origin_dir/../../../scr1/src/top/scr1_tcm.sv"]"\
 "[file normalize "$origin_dir/../../../scr1/src/top/scr1_imem_router.sv"]"\
 "[file normalize "$origin_dir/../../../scr1/src/top/scr1_imem_ahb.sv"]"\
 "[file normalize "$origin_dir/../../../scr1/src/top/scr1_dmem_router.sv"]"\
 "[file normalize "$origin_dir/../../../scr1/src/top/scr1_dmem_ahb.sv"]"\
 "[file normalize "$origin_dir/../../../scr1/src/top/scr1_timer.sv"]"\
 "[file normalize "$origin_dir/../../../scr1/src/top/scr1_top_ahb.sv"]"\
 "[file normalize "$origin_dir/src/arty_scr1.sv"]"\
]
add_files -norecurse -fileset $obj $files

# Set 'sources_1' fileset file properties for remote files
set file "$origin_dir/bd/system/system.bd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "exclude_debug_logic" "0" $file_obj
if { ![get_property "is_locked" $file_obj] } {
  set_property "generate_synth_checkpoint" "1" $file_obj
}
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
if { ![get_property "is_locked" $file_obj] } {
  set_property "is_locked" "0" $file_obj
}
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
if { ![get_property "is_locked" $file_obj] } {
  set_property "synth_checkpoint_mode" "Hierarchical" $file_obj
}
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/bd/sys_pll/sys_pll.bd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "exclude_debug_logic" "0" $file_obj
if { ![get_property "is_locked" $file_obj] } {
  set_property "generate_synth_checkpoint" "1" $file_obj
}
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
if { ![get_property "is_locked" $file_obj] } {
  set_property "is_locked" "0" $file_obj
}
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
if { ![get_property "is_locked" $file_obj] } {
  set_property "synth_checkpoint_mode" "Hierarchical" $file_obj
}
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../../scr1/src/includes/scr1_arch_description.svh"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog Header" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis simulation" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/src/scr1_arch_custom.svh"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog Header" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis simulation" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../../scr1/src/includes/scr1_arch_types.svh"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog Header" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis simulation" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../../scr1/src/includes/scr1_riscv_isa_decoding.svh"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog Header" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis simulation" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../../scr1/src/includes/scr1_search_ms1.svh"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog Header" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis simulation" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../../scr1/src/includes/scr1_ipic.svh"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog Header" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis simulation" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../../scr1/src/includes/scr1_memif.svh"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog Header" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis simulation" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../../scr1/src/includes/scr1_ahb.svh"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog Header" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis simulation" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../../scr1/src/includes/scr1_brkm.svh"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog Header" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis simulation" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../../scr1/src/includes/scr1_tapc.svh"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog Header" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis simulation" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../../scr1/src/includes/scr1_dbgc.svh"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog Header" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis simulation" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../../scr1/src/pipeline/scr1_pipe_mprf.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "SystemVerilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../../scr1/src/pipeline/scr1_pipe_lsu.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "SystemVerilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../../scr1/src/pipeline/scr1_pipe_ifu.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "SystemVerilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../../scr1/src/pipeline/scr1_pipe_idu.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "SystemVerilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../../scr1/src/pipeline/scr1_pipe_ialu.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "SystemVerilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../../scr1/src/pipeline/scr1_pipe_exu.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "SystemVerilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../../scr1/src/pipeline/scr1_pipe_dbga.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "SystemVerilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../../scr1/src/pipeline/scr1_pipe_csr.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "SystemVerilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../../scr1/src/pipeline/scr1_ipic.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "SystemVerilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../../scr1/src/pipeline/scr1_brkm_matcher.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "SystemVerilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../../scr1/src/pipeline/scr1_pipe_brkm.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "SystemVerilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../../scr1/src/pipeline/scr1_pipe_top.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "SystemVerilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../../scr1/src/core/scr1_sync_rstn.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "SystemVerilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../../scr1/src/core/scr1_dbgc.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "SystemVerilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../../scr1/src/core/scr1_tapc_synchronizer.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "SystemVerilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../../scr1/src/core/scr1_tapc_shift_reg.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "SystemVerilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../../scr1/src/core/scr1_tapc_data_reg.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "SystemVerilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../../scr1/src/core/scr1_tapc.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "SystemVerilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../../scr1/src/core/scr1_core_top.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "SystemVerilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../../scr1/src/top/scr1_dp_memory.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "SystemVerilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../../scr1/src/top/scr1_tcm.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "SystemVerilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../../scr1/src/top/scr1_imem_router.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "SystemVerilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../../scr1/src/top/scr1_imem_ahb.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "SystemVerilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../../scr1/src/top/scr1_dmem_router.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "SystemVerilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../../scr1/src/top/scr1_dmem_ahb.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "SystemVerilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../../scr1/src/top/scr1_timer.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "SystemVerilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../../scr1/src/top/scr1_top_ahb.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "SystemVerilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/src/arty_scr1.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "SystemVerilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj


# Set 'sources_1' fileset file properties for local files
# None

# Set 'sources_1' fileset properties
set obj [get_filesets sources_1]
set_property "design_mode" "RTL" $obj
set_property "edif_extra_search_paths" "" $obj
set_property "elab_link_dcps" "1" $obj
set_property "elab_load_timing_constraints" "1" $obj
set_property "generic" "" $obj
set_property "include_dirs" "" $obj
set_property "lib_map_file" "" $obj
set_property "loop_count" "1000" $obj
set_property "name" "sources_1" $obj
set_property "top" "arty_scr1_top" $obj
set_property "verilog_define" "SCR1_ARCH_CUSTOM=1" $obj
set_property "verilog_uppercase" "0" $obj

# Create 'constrs_1' fileset (if not found)
if {[string equal [get_filesets -quiet constrs_1] ""]} {
  create_fileset -constrset constrs_1
}

# Set 'constrs_1' fileset object
set obj [get_filesets constrs_1]

# Add/Import constrs file and set constrs file properties
set file "[file normalize "$origin_dir/constrs/arty_scr1_synth.xdc"]"
set file_added [add_files -norecurse -fileset $obj $file]
set file "$origin_dir/constrs/arty_scr1_synth.xdc"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets constrs_1] [list "*$file"]]
set_property "file_type" "XDC" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "processing_order" "NORMAL" $file_obj
set_property "scoped_to_cells" "" $file_obj
set_property "scoped_to_ref" "" $file_obj
set_property "used_in" "synthesis implementation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

# Set 'constrs_1' fileset properties
set obj [get_filesets constrs_1]
set_property "name" "constrs_1" $obj
set_property "target_constrs_file" "[file normalize "$origin_dir/constrs/arty_scr1_synth.xdc"]" $obj

# Create 'constrs_2' fileset (if not found)
if {[string equal [get_filesets -quiet constrs_2] ""]} {
  create_fileset -constrset constrs_2
}

# Set 'constrs_2' fileset object
set obj [get_filesets constrs_2]

# Add/Import constrs file and set constrs file properties
set file "[file normalize "$origin_dir/constrs/arty_scr1_synth.xdc"]"
set file_added [add_files -norecurse -fileset $obj $file]
set file "$origin_dir/constrs/arty_scr1_synth.xdc"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets constrs_2] [list "*$file"]]
set_property "file_type" "XDC" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "processing_order" "NORMAL" $file_obj
set_property "scoped_to_cells" "" $file_obj
set_property "scoped_to_ref" "" $file_obj
set_property "used_in" "synthesis implementation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

# Add/Import constrs file and set constrs file properties
set file "[file normalize "$origin_dir/constrs/arty_scr1_physical.xdc"]"
set file_added [add_files -norecurse -fileset $obj $file]
set file "$origin_dir/constrs/arty_scr1_physical.xdc"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets constrs_2] [list "*$file"]]
set_property "file_type" "XDC" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "processing_order" "NORMAL" $file_obj
set_property "scoped_to_cells" "" $file_obj
set_property "scoped_to_ref" "" $file_obj
set_property "used_in" "synthesis implementation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

# Add/Import constrs file and set constrs file properties
set file "[file normalize "$origin_dir/constrs/arty_scr1_timing.xdc"]"
set file_added [add_files -norecurse -fileset $obj $file]
set file "$origin_dir/constrs/arty_scr1_timing.xdc"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets constrs_2] [list "*$file"]]
set_property "file_type" "XDC" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "processing_order" "NORMAL" $file_obj
set_property "scoped_to_cells" "" $file_obj
set_property "scoped_to_ref" "" $file_obj
set_property "used_in" "synthesis implementation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

# Set 'constrs_2' fileset properties
set obj [get_filesets constrs_2]
set_property "name" "constrs_2" $obj
set_property "target_constrs_file" "" $obj

# Create 'sim_1' fileset (if not found)
if {[string equal [get_filesets -quiet sim_1] ""]} {
  create_fileset -simset sim_1
}

# Set 'sim_1' fileset object
set obj [get_filesets sim_1]
# Empty (no sources present)

# Set 'sim_1' fileset properties
set obj [get_filesets sim_1]
set_property "generic" "" $obj
set_property "include_dirs" "" $obj
set_property "name" "sim_1" $obj
set_property "nl.cell" "" $obj
set_property "nl.incl_unisim_models" "0" $obj
set_property "nl.process_corner" "slow" $obj
set_property "nl.rename_top" "" $obj
set_property "nl.sdf_anno" "1" $obj
set_property "nl.write_all_overrides" "0" $obj
set_property "runtime" "1000ns" $obj
set_property "source_set" "sources_1" $obj
set_property "top" "arty_scr1_top" $obj
set_property "transport_int_delay" "0" $obj
set_property "transport_path_delay" "0" $obj
set_property "unit_under_test" "" $obj
set_property "verilog_define" "SCR1_ARCH_CUSTOM=1" $obj
set_property "verilog_uppercase" "0" $obj
set_property "xelab.debug_level" "typical" $obj
set_property "xelab.dll" "0" $obj
set_property "xelab.load_glbl" "1" $obj
set_property "xelab.more_options" "" $obj
set_property "xelab.mt_level" "auto" $obj
set_property "xelab.nosort" "1" $obj
set_property "xelab.rangecheck" "0" $obj
set_property "xelab.relax" "1" $obj
set_property "xelab.sdf_delay" "sdfmax" $obj
set_property "xelab.snapshot" "" $obj
set_property "xelab.unifast" "" $obj
set_property "xsim.compile.incremental" "0" $obj
set_property "xsim.compile.xvhdl.more_options" "" $obj
set_property "xsim.compile.xvhdl.nosort" "1" $obj
set_property "xsim.compile.xvhdl.relax" "1" $obj
set_property "xsim.compile.xvlog.more_options" "" $obj
set_property "xsim.compile.xvlog.nosort" "1" $obj
set_property "xsim.compile.xvlog.relax" "1" $obj
set_property "xsim.elaborate.debug_level" "typical" $obj
set_property "xsim.elaborate.load_glbl" "1" $obj
set_property "xsim.elaborate.mt_level" "auto" $obj
set_property "xsim.elaborate.rangecheck" "0" $obj
set_property "xsim.elaborate.relax" "1" $obj
set_property "xsim.elaborate.sdf_delay" "sdfmax" $obj
set_property "xsim.elaborate.snapshot" "" $obj
set_property "xsim.elaborate.xelab.more_options" "" $obj
set_property "xsim.more_options" "" $obj
set_property "xsim.saif" "" $obj
set_property "xsim.simulate.log_all_signals" "0" $obj
set_property "xsim.simulate.runtime" "1000ns" $obj
set_property "xsim.simulate.saif" "" $obj
set_property "xsim.simulate.saif_all_signals" "0" $obj
set_property "xsim.simulate.saif_scope" "" $obj
set_property "xsim.simulate.wdb" "" $obj
set_property "xsim.simulate.xsim.more_options" "" $obj
set_property "xsim.tclbatch" "" $obj
set_property "xsim.view" "" $obj
set_property "xsim.wdb" "" $obj

# Create 'synth_1' run (if not found)
if {[string equal [get_runs -quiet synth_1] ""]} {
  create_run -name synth_1 -part xc7a35ticsg324-1L -flow {Vivado Synthesis 2018} -strategy "Flow_PerfOptimized_high" -constrset constrs_1
} else {
  set_property strategy "Flow_PerfOptimized_high" [get_runs synth_1]
  set_property flow "Vivado Synthesis 2018" [get_runs synth_1]
}
set obj [get_runs synth_1]
set_property "constrset" "constrs_1" $obj
set_property "description" "Higher performance designs, resource sharing is turned off, the global fanout guide is set to a lower number, FSM extraction forced to one-hot, LUT combining is disabled, equivalent registers are preserved, SRL are inferred  with a larger threshold" $obj
set_property "flow" "Vivado Synthesis 2018" $obj
set_property "name" "synth_1" $obj
set_property "needs_refresh" "0" $obj
set_property "srcset" "sources_1" $obj
set_property "strategy" "Flow_PerfOptimized_high" $obj
set_property "incremental_checkpoint" "" $obj
set_property "include_in_archive" "1" $obj
set_property "steps.synth_design.tcl.pre" "" $obj
set_property "steps.synth_design.tcl.post" "" $obj
set_property "steps.synth_design.args.flatten_hierarchy" "rebuilt" $obj
set_property "steps.synth_design.args.gated_clock_conversion" "off" $obj
set_property "steps.synth_design.args.bufg" "12" $obj
set_property "steps.synth_design.args.fanout_limit" "400" $obj
set_property "steps.synth_design.args.directive" "Default" $obj
set_property "steps.synth_design.args.retiming" "0" $obj
set_property "steps.synth_design.args.fsm_extraction" "one_hot" $obj
set_property "steps.synth_design.args.keep_equivalent_registers" "1" $obj
set_property "steps.synth_design.args.resource_sharing" "off" $obj
set_property "steps.synth_design.args.control_set_opt_threshold" "auto" $obj
set_property "steps.synth_design.args.no_lc" "1" $obj
set_property "steps.synth_design.args.no_srlextract" "0" $obj
set_property "steps.synth_design.args.shreg_min_size" "5" $obj
set_property "steps.synth_design.args.max_bram" "-1" $obj
set_property "steps.synth_design.args.max_uram" "-1" $obj
set_property "steps.synth_design.args.max_dsp" "-1" $obj
set_property "steps.synth_design.args.max_bram_cascade_height" "-1" $obj
set_property "steps.synth_design.args.max_uram_cascade_height" "-1" $obj
set_property "steps.synth_design.args.cascade_dsp" "auto" $obj
set_property "steps.synth_design.args.assert" "0" $obj
set_property -name {steps.synth_design.args.more options} -value {} -objects $obj

# set the current synth run
current_run -synthesis [get_runs synth_1]

# Create 'impl_1' run (if not found)
if {[string equal [get_runs -quiet impl_1] ""]} {
  create_run -name impl_1 -part xc7a35ticsg324-1L -flow {Vivado Implementation 2018} -strategy "Performance_WLBlockPlacement" -constrset constrs_2 -parent_run synth_1
} else {
  set_property strategy "Performance_WLBlockPlacement" [get_runs impl_1]
  set_property flow "Vivado Implementation 2018" [get_runs impl_1]
}
set obj [get_runs impl_1]
set_property "constrset" "constrs_2" $obj
set_property "description" "Ignore timing constraints for placing Block RAM and DSPs, use wirelength instead." $obj
set_property "flow" "Vivado Implementation 2018" $obj
set_property "name" "impl_1" $obj
set_property "needs_refresh" "0" $obj
set_property "pr_configuration" "" $obj
set_property "srcset" "sources_1" $obj
set_property "strategy" "Performance_WLBlockPlacement" $obj
set_property "incremental_checkpoint" "" $obj
set_property "include_in_archive" "1" $obj
set_property "steps.opt_design.is_enabled" "1" $obj
set_property "steps.opt_design.tcl.pre" "" $obj
set_property "steps.opt_design.tcl.post" "" $obj
set_property "steps.opt_design.args.verbose" "0" $obj
set_property "steps.opt_design.args.directive" "Default" $obj
set_property -name {steps.opt_design.args.more options} -value {} -objects $obj
set_property "steps.power_opt_design.is_enabled" "0" $obj
set_property "steps.power_opt_design.tcl.pre" "" $obj
set_property "steps.power_opt_design.tcl.post" "" $obj
set_property -name {steps.power_opt_design.args.more options} -value {} -objects $obj
set_property "steps.place_design.tcl.pre" "" $obj
set_property "steps.place_design.tcl.post" "" $obj
set_property "steps.place_design.args.directive" "WLDrivenBlockPlacement" $obj
set_property -name {steps.place_design.args.more options} -value {} -objects $obj
set_property "steps.post_place_power_opt_design.is_enabled" "0" $obj
set_property "steps.post_place_power_opt_design.tcl.pre" "" $obj
set_property "steps.post_place_power_opt_design.tcl.post" "" $obj
set_property -name {steps.post_place_power_opt_design.args.more options} -value {} -objects $obj
set_property "steps.phys_opt_design.is_enabled" "1" $obj
set_property "steps.phys_opt_design.tcl.pre" "" $obj
set_property "steps.phys_opt_design.tcl.post" "" $obj
set_property "steps.phys_opt_design.args.directive" "AlternateReplication" $obj
set_property -name {steps.phys_opt_design.args.more options} -value {} -objects $obj
set_property "steps.route_design.tcl.pre" "" $obj
set_property "steps.route_design.tcl.post" "" $obj
set_property "steps.route_design.args.directive" "Explore" $obj
set_property -name {steps.route_design.args.more options} -value {} -objects $obj
set_property "steps.post_route_phys_opt_design.is_enabled" "0" $obj
set_property "steps.post_route_phys_opt_design.tcl.pre" "" $obj
set_property "steps.post_route_phys_opt_design.tcl.post" "" $obj
set_property "steps.post_route_phys_opt_design.args.directive" "Default" $obj
set_property -name {steps.post_route_phys_opt_design.args.more options} -value {} -objects $obj
set_property "steps.write_bitstream.tcl.pre" "" $obj
set_property "steps.write_bitstream.tcl.post" "" $obj
set_property "steps.write_bitstream.args.raw_bitfile" "0" $obj
set_property "steps.write_bitstream.args.mask_file" "0" $obj
set_property "steps.write_bitstream.args.no_binary_bitfile" "0" $obj
set_property "steps.write_bitstream.args.bin_file" "0" $obj
set_property "steps.write_bitstream.args.readback_file" "0" $obj
set_property "steps.write_bitstream.args.logic_location_file" "0" $obj
set_property "steps.write_bitstream.args.verbose" "0" $obj
set_property -name {steps.write_bitstream.args.more options} -value {} -objects $obj

# set the current impl run
current_run -implementation [get_runs impl_1]

# Open BDs to recover their meta-data
open_bd_design [file normalize "$origin_dir/bd/sys_pll/sys_pll.bd"]
open_bd_design [file normalize "$origin_dir/bd/system/system.bd"]

puts "INFO: Project created:arty_scr1"
