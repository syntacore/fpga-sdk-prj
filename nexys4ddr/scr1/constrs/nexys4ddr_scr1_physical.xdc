##
## Copyright by Syntacore LLC © 2016, 2017, 2021. See LICENSE for details
## @file       <nexys4ddr_scr1_physical.xdc>
## @brief      Physical constraints file for Xilinx Vivado implementation.
##

## Clock & Reset
set_property -dict { PACKAGE_PIN E3     IOSTANDARD LVCMOS33 }   [get_ports CLK100MHZ]
set_property -dict { PACKAGE_PIN C12    IOSTANDARD LVCMOS33 }   [get_ports CPU_RESETn]
set_property PULLUP     true                                    [get_ports CPU_RESETn]

## UART
set_property -dict { PACKAGE_PIN D4     IOSTANDARD LVCMOS33 }   [get_ports FTDI_RXD]
set_property -dict { PACKAGE_PIN C4     IOSTANDARD LVCMOS33 }   [get_ports FTDI_TXD]

## LEDs
set_property -dict { PACKAGE_PIN H17    IOSTANDARD LVCMOS33 }   [get_ports {LED[0]}]
set_property -dict { PACKAGE_PIN K15    IOSTANDARD LVCMOS33 }   [get_ports {LED[1]}]
set_property -dict { PACKAGE_PIN J13    IOSTANDARD LVCMOS33 }   [get_ports {LED[2]}]
set_property -dict { PACKAGE_PIN N14    IOSTANDARD LVCMOS33 }   [get_ports {LED[3]}]
set_property -dict { PACKAGE_PIN R18    IOSTANDARD LVCMOS33 }   [get_ports {LED[4]}]
set_property -dict { PACKAGE_PIN V17    IOSTANDARD LVCMOS33 }   [get_ports {LED[5]}]
set_property -dict { PACKAGE_PIN U17    IOSTANDARD LVCMOS33 }   [get_ports {LED[6]}]
set_property -dict { PACKAGE_PIN U16    IOSTANDARD LVCMOS33 }   [get_ports {LED[7]}]
set_property -dict { PACKAGE_PIN V16    IOSTANDARD LVCMOS33 }   [get_ports {LED[8]}]
set_property -dict { PACKAGE_PIN T15    IOSTANDARD LVCMOS33 }   [get_ports {LED[9]}]
set_property -dict { PACKAGE_PIN U14    IOSTANDARD LVCMOS33 }   [get_ports {LED[10]}]
set_property -dict { PACKAGE_PIN T16    IOSTANDARD LVCMOS33 }   [get_ports {LED[11]}]
set_property -dict { PACKAGE_PIN V15    IOSTANDARD LVCMOS33 }   [get_ports {LED[12]}]
set_property -dict { PACKAGE_PIN V14    IOSTANDARD LVCMOS33 }   [get_ports {LED[13]}]
set_property -dict { PACKAGE_PIN V12    IOSTANDARD LVCMOS33 }   [get_ports {LED[14]}]
set_property -dict { PACKAGE_PIN V11    IOSTANDARD LVCMOS33 }   [get_ports {LED[15]}]

## PMOD Header JC
set_property -dict { PACKAGE_PIN G6     IOSTANDARD LVCMOS33 }   [get_ports {JC[3]}]
set_property -dict { PACKAGE_PIN K1     IOSTANDARD LVCMOS33 }   [get_ports {JC[0]}]
set_property -dict { PACKAGE_PIN F6     IOSTANDARD LVCMOS33 }   [get_ports {JC[1]}]
set_property -dict { PACKAGE_PIN J2     IOSTANDARD LVCMOS33 }   [get_ports {JC[2]}]

set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets {JC_IBUF[3]}]
set_property PULLDOWN   true    [get_ports {JC[3]}]
set_property PULLUP     true    [get_ports {JC[0]}]
set_property PULLUP     true    [get_ports {JC[1]}]
set_property PULLUP     true    [get_ports {JC[2]}]

## FPGA Configuration
set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]
set_property CONFIG_MODE SPIx4 [current_design]
set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]