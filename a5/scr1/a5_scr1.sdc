#**************************************************************
# Clocks
#**************************************************************
create_clock -name "OSC_50"         -period  20 [get_ports {CLKIN_50_BOT}]
create_clock -name "OSC_50_VIRT"    -period  20
create_clock -name "OSC_100"        -period  10 [get_ports {CLKINTOP_100_P}]
create_clock -name "OSC_100_VIRT"   -period  10
create_clock -name "JTAG_TCK"       -period 100 [get_ports {JTAG_TCK }]
create_clock -name "JTAG_TCK_VIRT"  -period 100

set_clock_groups -asynchronous  -group {OSC_50 OSC_50_VIRT}   \
                                -group {OSC_100 OSC_100_VIRT} \
                                -group {JTAG_TCK JTAG_TCK_VIRT}

create_generated_clock -add -source CLKIN_50_BOT -divide_by 5 -multiply_by 3  -duty_cycle 50.00 -name "CPU_CLK" { i_soc|sys_pll|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk }

derive_pll_clocks -create_base_clocks
derive_clock_uncertainty

#**************************************************************
# False Path
#**************************************************************
set_false_path -to   [get_ports {USER_LED[*]}]
set_false_path -to   [get_ports {UART_TXD}]
set_false_path -from [get_ports {UART_RXD}]
set_false_path -from [get_ports {JTAG_TRST_N}]
set_false_path -from [get_ports {JTAG_SRST_N}]
set_false_path -from [get_ports {USER_PB[*]}]

#**************************************************************
# IO Delays
#**************************************************************
set_input_delay  -add_delay -clock_fall -clock JTAG_TCK_VIRT -max  5 [get_ports {JTAG_TMS JTAG_TDI}]
set_input_delay  -add_delay -clock_fall -clock JTAG_TCK_VIRT -min  0 [get_ports {JTAG_TMS JTAG_TDI}]
set_output_delay -add_delay -clock_fall -clock JTAG_TCK_VIRT -max  5 [get_ports {JTAG_TDO}]
set_output_delay -add_delay -clock_fall -clock JTAG_TCK_VIRT -min  0 [get_ports {JTAG_TDO}]



