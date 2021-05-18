#**************************************************************
# Clocks
#**************************************************************
create_clock  -name MAX10_CLK2_50       -period 20  [get_ports {MAX10_CLK2_50}]
create_clock  -name JTAG_TCK            -period 200 [get_ports {JTAG_TCK}]
create_clock  -name CLK_SDRAM_EXT_VIRT  -period 10

create_generated_clock  -source MAX10_CLK2_50 \
                        -divide_by 5 \
                        -multiply_by 2 \
                        -duty_cycle 50.00 \
                        -name CPU_CLK \
                        { i_soc|sys_pll|sd1|pll7|clk[0] }

create_generated_clock  -source MAX10_CLK2_50 \
                        -multiply_by 2 \
                        -duty_cycle 50.00 \
                        -name CLK_SDRAM \
                        { i_soc|sys_pll|sd1|pll7|clk[1] }

create_generated_clock  -source MAX10_CLK2_50 \
                        -multiply_by 2 \
                        -phase 108.00 \
                        -duty_cycle 50.00 \
                        -name CLK_SDRAM_EXT \
                        { i_soc|sys_pll|sd1|pll7|clk[2] }

derive_pll_clocks -create_base_clocks
derive_clock_uncertainty



set_clock_groups -asynchronous -group {MAX10_CLK2_50}
set_clock_groups -asynchronous -group {JTAG_TCK}
set_clock_groups -asynchronous -group {CPU_CLK}
set_clock_groups -asynchronous -group {CLK_SDRAM_EXT CLK_SDRAM_EXT_VIRT}

#**************************************************************
# False Path
#**************************************************************
set_false_path -to   [get_ports {DRAM_CLK}]
set_false_path -to   [get_ports {HEX*}]
set_false_path -to   [get_ports {LEDR*}]
set_false_path -to   [get_ports {UART_TXD}]
set_false_path -from [get_ports {UART_RXD}]
set_false_path -from [get_ports {JTAG_SRST_N}]
set_false_path -from [get_ports {JTAG_TRST_N}]
set_false_path -from [get_ports {KEY*}]
set_false_path -from [get_ports {SW*}]

#**************************************************************
# Set Input Delay
#**************************************************************
# suppose +- 100 ps skew
# Board Delay (Data) + Propagation Delay - Board Delay (Clock)
# max 5.4(max) +0.4(trace delay) +0.1 = 5.9
# min 2.7(min) +0.4(trace delay) -0.1 = 3.0
set_input_delay -max -clock CLK_SDRAM_EXT_VIRT 5.9 [get_ports DRAM_DQ*]
set_input_delay -min -clock CLK_SDRAM_EXT_VIRT 3.0 [get_ports DRAM_DQ*]

#shift-window
set_multicycle_path -from [get_clocks {CLK_SDRAM_EXT_VIRT}] \
                    -to   [get_clocks {MAX10_CLK2_50}] \
                    -setup 2

set_input_delay  -add_delay -clock_fall -clock JTAG_TCK -max  5 [get_ports {JTAG_TMS JTAG_TDI}]
set_input_delay  -add_delay -clock_fall -clock JTAG_TCK -min  0 [get_ports {JTAG_TMS JTAG_TDI}]

#**************************************************************
# Set Output Delay
#**************************************************************
# suppose +- 100 ps skew
# max : Board Delay (Data) - Board Delay (Clock) + tsu (External Device)
# min : Board Delay (Data) - Board Delay (Clock) - th (External Device)
# max 1.5+0.1 =1.6
# min -0.8-0.1 = 0.9
set_output_delay -max -clock CLK_SDRAM_EXT_VIRT  1.6  [get_ports {DRAM_DQ* DRAM_*DQM}]
set_output_delay -min -clock CLK_SDRAM_EXT_VIRT -0.9  [get_ports {DRAM_DQ* DRAM_*DQM}]
set_output_delay -max -clock CLK_SDRAM_EXT_VIRT  1.6  [get_ports {DRAM_ADDR* DRAM_BA* DRAM_RAS_N DRAM_CAS_N DRAM_WE_N DRAM_CKE DRAM_CS_N}]
set_output_delay -min -clock CLK_SDRAM_EXT_VIRT -0.9  [get_ports {DRAM_ADDR* DRAM_BA* DRAM_RAS_N DRAM_CAS_N DRAM_WE_N DRAM_CKE DRAM_CS_N}]

set_output_delay -add_delay -clock_fall -clock JTAG_TCK -max  5 [get_ports {JTAG_TDO}]
set_output_delay -add_delay -clock_fall -clock JTAG_TCK -min  0 [get_ports {JTAG_TDO}]