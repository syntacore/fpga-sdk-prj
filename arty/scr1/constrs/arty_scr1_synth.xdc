##
## Copyright by Syntacore LLC © 2016, 2017. See LICENSE for details
## @file       <arty_scr1_synth.xdc>
## @brief      Constraint file for Xilinx Vivado synthesis.
##

## Primary Clocks
set_property -dict {PACKAGE_PIN E3 IOSTANDARD LVCMOS33} [get_ports OSC_100]
create_clock -period 10.000 -name OSC_100 -waveform {0.000 5.000} -add [get_ports OSC_100]
create_clock -period 40.000 -name SYS_CLK_VIRT -waveform {0.000 20.000}
create_clock -period 100.000 -name JTAG_TCK -waveform {0.000 50.000} -add [get_ports {JD[3]}]
create_clock -period 100.000 -name JTAG_TCK_VIRT -waveform {0.000 50.000}
