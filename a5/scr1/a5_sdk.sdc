
#**************************************************************
# Create Clock
#**************************************************************
create_clock -name clkin_50         -period  20 [get_ports {clkin_50 }]
create_clock -name clkin_100        -period  10 [get_ports {clkin_100}]
create_clock -name JTAG_TCK         -period 100 [get_ports {jtag_tck }]



derive_pll_clocks -create_base_clocks
derive_clock_uncertainty


#30Mhz
set CLK_RISCV "i_pll|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk"


#**************************************************************
set_input_delay  -add_delay -clock_fall -clock JTAG_TCK -max  5 [get_ports {jtag_tms jtag_tdi}]
set_input_delay  -add_delay -clock_fall -clock JTAG_TCK -min  0 [get_ports {jtag_tms jtag_tdi}]
set_output_delay -add_delay -clock_fall -clock JTAG_TCK -max  5 [get_ports {jtag_tdo}]
set_output_delay -add_delay -clock_fall -clock JTAG_TCK -min  0 [get_ports {jtag_tdo}]




set_false_path -to   [get_ports {user_led[*]}]
set_false_path -to   [get_ports {uart0_txd}]
set_false_path -from [get_ports {uart0_rxd}]
set_false_path -from [get_ports {jtag_trst_n}]
set_false_path -from {pwron_rst_in_ff2}



set_clock_groups -asynchronous -group [get_clocks { clkin_50  }]
set_clock_groups -asynchronous -group [get_clocks { clkin_100 }]
set_clock_groups -asynchronous -group [get_clocks { JTAG_TCK  }]
set_clock_groups -asynchronous -group [get_clocks  $CLK_RISCV  ]


