`ifndef SCR1_ARCH_CUSTOM_SVH
`define SCR1_ARCH_CUSTOM_SVH
/// Copyright by Syntacore LLC ?? 2016, 2017, 2021. See LICENSE for details
/// @file       <scr1_arch_custom.svh>
/// @brief      Custom Architecture Parameters File
///

// Current FPGA build identificators, can be modified
`define SCR1_PTFM_SOC_ID            32'h21050500
`define SCR1_PTFM_BLD_ID            32'h22011201
`define SCR1_PTFM_CORE_CLK_FREQ     32'd25000000

`define SCR1_TRGT_FPGA_XILINX        // Uncomment if target platform is Xilinx FPGAs
//`define SCR1_TRGT_FPGA_INTEL         // Uncomment if target platform is Intel FPGAs AND --->
//`define SCR1_TRGT_FPGA_INTEL_MAX10   // ---> Uncomment if target platform is Intel MAX 10 FPGAs
//`define SCR1_TRGT_FPGA_INTEL_ARRIAV  // ---> Uncomment if target platform is Intel Arria V FPGAs





// Uncomment to select recommended core architecture configurations
// Default SCR1 FPGA SDK created for RV32IMC_MAX config

`define SCR1_CFG_RV32IMC_MAX
//`define SCR1_CFG_RV32IC_BASE
//`define SCR1_CFG_RV32EC_MIN



parameter bit [`SCR1_XLEN-1:0]          SCR1_ARCH_RST_VECTOR        = 'hFFFFFF00;   // Reset vector
parameter bit [`SCR1_XLEN-1:0]          SCR1_ARCH_MTVEC_BASE        = 'hFFFFFF80;   // MTVEC BASE field reset value

parameter bit [`SCR1_DMEM_AWIDTH-1:0]   SCR1_TCM_ADDR_MASK          = 'hFFFF0000;   // TCM mask and size
parameter bit [`SCR1_DMEM_AWIDTH-1:0]   SCR1_TCM_ADDR_PATTERN       = 'hF0000000;   // TCM address match pattern

parameter bit [`SCR1_DMEM_AWIDTH-1:0]   SCR1_TIMER_ADDR_MASK        = 'hFFFFFFE0;   // Timer mask (should be 0xFFFFFFE0)
parameter bit [`SCR1_DMEM_AWIDTH-1:0]   SCR1_TIMER_ADDR_PATTERN     = 'hF0040000;   // Timer address match pattern

`endif // SCR1_ARCH_CUSTOM_SVH