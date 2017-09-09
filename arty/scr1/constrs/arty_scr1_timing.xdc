##
## Copyright by Syntacore LLC © 2016, 2017. See LICENSE for details
## @file       <arty_scr1_timing.xdc>
## @brief      Timing constraints file for Xilinx Vivado implementation.
##

# NB! Primary clocks are defined in the synthesis constraint file (*_synth.xdc).

create_generated_clock -name SYS_CLK [get_pins i_sys_pll/clk_wiz_0/inst/plle2_adv_inst/CLKOUT0]

set_clock_groups -name async_osc100_tck -asynchronous -group {OSC_100 SYS_CLK SYS_CLK_VIRT} -group {JTAG_TCK JTAG_TCK_VIRT}

set_false_path -from [get_clocks JTAG_TCK] -to [get_clocks SYS_CLK]
set_false_path -from [get_clocks JTAG_TCK_VIRT] -to [get_clocks SYS_CLK]
set_false_path -from [get_clocks SYS_CLK] -to [get_clocks JTAG_TCK]

set_input_delay -clock [get_clocks SYS_CLK_VIRT] 3.300 [get_ports RESETn]
set_input_delay -clock [get_clocks SYS_CLK_VIRT] 3.300 [get_ports FTDI_TXD]
set_input_delay -clock [get_clocks SYS_CLK_VIRT] 3.300 [get_ports {BTN*}]
set_input_delay -clock [get_clocks JTAG_TCK_VIRT] 6.600 [get_ports {JD[2]}]
set_input_delay -clock [get_clocks JTAG_TCK_VIRT] 6.600 [get_ports {JD[4]}]
set_input_delay -clock [get_clocks JTAG_TCK_VIRT] 6.600 [get_ports {JD[5]}]
set_input_delay -clock [get_clocks JTAG_TCK_VIRT] 6.600 [get_ports {JD[6]}]
set_input_delay -clock [get_clocks JTAG_TCK_VIRT] 6.600 [get_ports {JD[7]}]

set_output_delay -clock [get_clocks SYS_CLK_VIRT] 3.300 [get_ports FTDI_RXD]
set_output_delay -clock [get_clocks SYS_CLK_VIRT] 3.300 [get_ports LED*]
set_output_delay -clock [get_clocks JTAG_TCK_VIRT] 6.600 [get_ports {JD[*]}]

