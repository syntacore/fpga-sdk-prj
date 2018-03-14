`ifndef SCR1_ARCH_CUSTOM_SVH
`define SCR1_ARCH_CUSTOM_SVH
/// Copyright by Syntacore LLC © 2016, 2017. See LICENSE for details
/// @file       <scr1_arch_custom.svh>
/// @brief      Custom Architecture Parameters File
///

`define SCR1_TARGET_FPGA_XILINX
`define SCR1_ARCH_BUILD_ID          32'h18031400
`define SCR1_ARCH_SYS_ID            32'h17090400

//-------------------------------------------------------------------------------
// Core configurable parameters (customized for SCR1 Arty SDK)
//-------------------------------------------------------------------------------

//`define SCR1_RVE_EXT                // enables RV32E base integer instruction set
`define SCR1_RVM_EXT                // enables standard extension for integer mul/div
`define SCR1_RVC_EXT                // enables standard extension for compressed instructions

`define SCR1_IFU_QUEUE_BYPASS       // enables bypass between IFU and IDU stages
`define SCR1_EXU_STAGE_BYPASS       // enables bypass between IDU and EXU stages

`define SCR1_FAST_MUL               // enables one-cycle multiplication

// `define SCR1_CLKCTRL_EN             // enables global clock gating

`define SCR1_DBGC_EN                // enables debug controller
`define SCR1_BRKM_EN                // enables breakpoint module
`define SCR1_IPIC_EN                // enables interrupt controller
`define SCR1_IPIC_SYNC_EN           // enables IPIC synchronizer
`define SCR1_TCM_EN                 // enables tightly-coupled memory

//`define SCR1_VECT_IRQ_EN            // enables vectored interrupts
`define SCR1_CSR_MCOUNTEN_EN        // enables custom MCOUNTEN CSR
parameter int unsigned SCR1_CSR_MTVEC_BASE_RW_BITS = 26;    // number of writable high-order bits in MTVEC BASE field
                                                            // legal values are 0 to 26
                                                            // read-only bits are hardwired to reset value

`define SCR1_IMEM_AHB_IN_BP         // bypass instruction memory AHB bridge input register
`define SCR1_IMEM_AHB_OUT_BP        // bypass instruction memory AHB bridge output register
`define SCR1_DMEM_AHB_IN_BP         // bypass data memory AHB bridge input register
`define SCR1_DMEM_AHB_OUT_BP        // bypass data memory AHB bridge output register

`ifdef SCR1_TCM_EN
parameter bit [`SCR1_DMEM_AWIDTH-1:0]   SCR1_TCM_ADDR_MASK          = 'hFFFF0000;
parameter bit [`SCR1_DMEM_AWIDTH-1:0]   SCR1_TCM_ADDR_PATTERN       = 'hF0000000;
`endif // SCR1_TCM_EN

parameter bit [`SCR1_DMEM_AWIDTH-1:0]   SCR1_TIMER_ADDR_MASK        = 'hFFFFFFE0;
parameter bit [`SCR1_DMEM_AWIDTH-1:0]   SCR1_TIMER_ADDR_PATTERN     = 'hF0040000;

// CSR parameters:
parameter bit [`SCR1_XLEN-1:0]          SCR1_ARCH_RST_VECTOR        = 32'hFFFFFF00;
parameter bit [`SCR1_XLEN-1:SCR1_CSR_MTVEC_BASE_ZERO_BITS]  SCR1_ARCH_CSR_MTVEC_BASE_RST_VAL    = SCR1_CSR_MTVEC_BASE_VAL_BITS'(`SCR1_XLEN'hFFFFFF80 >> SCR1_CSR_MTVEC_BASE_ZERO_BITS);

`endif // SCR1_ARCH_CUSTOM_SVH