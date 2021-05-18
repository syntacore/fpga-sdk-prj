##
## Copyright by Syntacore LLC © 2016, 2017, 2021. See LICENSE for details
## @file       <nexys4ddr_scr1_timing.xdc>
## @brief      Timing constraints file for Xilinx Vivado implementation.
##

# NB! Primary clocks are defined in the synthesis constraint file (*_synth.xdc).

create_generated_clock -name CPU_CLK [get_pins i_soc/clk_wiz_0/inst/mmcm_adv_inst/CLKOUT0]

set_clock_groups -name async_clk100mhz_tck -asynchronous -group {CLK100MHZ CPU_CLK CPU_CLK_VIRT} -group {JTAG_TCK JTAG_TCK_VIRT}

set_false_path -from [get_clocks JTAG_TCK]      -to [get_clocks CPU_CLK]
set_false_path -from [get_clocks JTAG_TCK_VIRT] -to [get_clocks CPU_CLK]
set_false_path -from [get_clocks CPU_CLK]       -to [get_clocks JTAG_TCK]
set_false_path                                  -to [get_ports FTDI_RXD]
set_false_path -from [get_ports FTDI_TXD]
set_false_path                                  -to [get_ports {LED[0]}]

set_input_delay     -clock [get_clocks CPU_CLK_VIRT]    3.300 [get_ports CPU_RESETn]
set_input_delay     -clock [get_clocks CPU_CLK_VIRT]    3.300 [get_ports FTDI_TXD]
set_input_delay     -clock [get_clocks JTAG_TCK_VIRT]   6.600 [get_ports {JC[*]}]
#set_input_delay     -clock [get_clocks JTAG_TCK_VIRT]   6.600 [get_ports {JC[0]}]
#set_input_delay     -clock [get_clocks JTAG_TCK_VIRT]   6.600 [get_ports {JC[1]}]
#set_input_delay     -clock [get_clocks JTAG_TCK_VIRT]   6.600 [get_ports {JC[2]}]
#set_input_delay     -clock [get_clocks JTAG_TCK_VIRT]   6.600 [get_ports {JC[4]}]
#set_input_delay     -clock [get_clocks JTAG_TCK_VIRT]   6.600 [get_ports {JC[5]}]
#set_input_delay     -clock [get_clocks JTAG_TCK_VIRT]   6.600 [get_ports {JC[6]}]
#set_input_delay     -clock [get_clocks JTAG_TCK_VIRT]   6.600 [get_ports {JC[7]}]

set_output_delay    -clock [get_clocks CPU_CLK_VIRT]    3.300 [get_ports FTDI_RXD]
set_output_delay    -clock [get_clocks CPU_CLK_VIRT]    3.300 [get_ports LED*]
set_output_delay    -clock [get_clocks JTAG_TCK_VIRT]   6.600 [get_ports {JC[*]}]

#set_input_delay -clock JTAG_TCK -clock_fall -max -add_delay 5.000 [get_ports {JC[0] JC[1]}]
#set_input_delay -clock JTAG_TCK -clock_fall -min -add_delay 0.000 [get_ports {JC[0] JC[1]}]
#set_output_delay -clock JTAG_TCK -clock_fall -max -add_delay 5.000 [get_ports {JC[2]}]
#set_output_delay -clock JTAG_TCK -clock_fall -min -add_delay 0.000 [get_ports {JC[2]}]

