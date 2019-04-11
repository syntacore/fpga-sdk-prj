`ifndef SCR1_ARCH_CUSTOM_SVH
`define SCR1_ARCH_CUSTOM_SVH
/// Copyright by Syntacore LLC © 2016, 2017. See LICENSE for details
/// @file       <scr1_arch_custom.svh>
/// @brief      Custom Architecture Parameters File
///

`define SCR1_TARGET_FPGA_XILINX
`define SCR1_ARCH_BUILD_ID          32'h19040500
`define SCR1_ARCH_SYS_ID            32'h17090400



parameter bit [`SCR1_XLEN-1:0]          SCR1_ARCH_RST_VECTOR        = 'hFFFFFF00;   // Reset vector
parameter bit [`SCR1_XLEN-1:0]          SCR1_ARCH_CSR_MTVEC_BASE    = 'hFFFFFF80;   // MTVEC BASE field reset value

parameter bit [`SCR1_DMEM_AWIDTH-1:0]   SCR1_TCM_ADDR_MASK          = 'hFFFF0000;   // TCM mask and size
parameter bit [`SCR1_DMEM_AWIDTH-1:0]   SCR1_TCM_ADDR_PATTERN       = 'hF0000000;   // TCM address match pattern

parameter bit [`SCR1_DMEM_AWIDTH-1:0]   SCR1_TIMER_ADDR_MASK        = 'hFFFFFFE0;   // Timer mask (should be 0xFFFFFFE0)
parameter bit [`SCR1_DMEM_AWIDTH-1:0]   SCR1_TIMER_ADDR_PATTERN     = 'hF0040000;   // Timer address match pattern



`endif // SCR1_ARCH_CUSTOM_SVH