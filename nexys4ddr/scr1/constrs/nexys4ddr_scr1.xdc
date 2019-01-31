set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]
set_property CONFIG_MODE SPIx4 [current_design]
set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]




create_clock -period  200.000 -name JTAG_TCK  [get_ports jtag_tck]




#**************************************************************

set_input_delay -clock JTAG_TCK -clock_fall -max -add_delay 5.000 [get_ports {jtag_tms jtag_tdi}]
set_input_delay -clock JTAG_TCK -clock_fall -min -add_delay 0.000 [get_ports {jtag_tms jtag_tdi}]
set_output_delay -clock JTAG_TCK -clock_fall -max -add_delay 5.000 [get_ports jtag_tdo]
set_output_delay -clock JTAG_TCK -clock_fall -min -add_delay 0.000 [get_ports jtag_tdo]



set_clock_groups -asynchronous -group [get_clocks JTAG_TCK]



set_false_path -to   [get_ports uart_txd]
set_false_path -from [get_ports uart_rxd]






#**************************************************************
set_property -dict { PACKAGE_PIN H17   IOSTANDARD LVCMOS33 } [get_ports ddr_calib];
set_property -dict { PACKAGE_PIN D4    IOSTANDARD LVCMOS33 } [get_ports uart_txd];
set_property -dict { PACKAGE_PIN C4    IOSTANDARD LVCMOS33 } [get_ports uart_rxd];
set_property -dict {PACKAGE_PIN V11 IOSTANDARD LVCMOS33} [get_ports user_led15]

# Pmod Header JC
set_property -dict { PACKAGE_PIN G6    IOSTANDARD LVCMOS33 } [get_ports jtag_tck];
set_property -dict { PACKAGE_PIN J2    IOSTANDARD LVCMOS33 } [get_ports jtag_tdo];
set_property -dict { PACKAGE_PIN F6    IOSTANDARD LVCMOS33 } [get_ports jtag_tdi];
set_property -dict { PACKAGE_PIN K1    IOSTANDARD LVCMOS33 } [get_ports jtag_tms];


set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets jtag_tck_IBUF]
set_property PULLUP true                 [get_ports jtag_tdo]










