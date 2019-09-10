/// Copyright by Syntacore LLC © 2016, 2017, 2018. See LICENSE for details
/// @file       <nexys4ddr_scr1.sv>
/// @brief      Top-level entity with SCR1 for Digilent Nexys 4 DDR board
///

`include "scr1_arch_types.svh"
`include "scr1_arch_custom.svh"
`include "scr1_arch_description.svh"

parameter bit [31:0] FPGA_BUILD_ID = `SCR1_ARCH_BUILD_ID;


module nexys4ddr_scr1_top (


    input                   reset,
    input                   sys_clock,

    //DDR2
    output          [12:0]  ddr2_sdram_addr,
    output           [2:0]  ddr2_sdram_ba,
    output                  ddr2_sdram_cas_n,
    output          [0:0]   ddr2_sdram_ck_n,
    output          [0:0]   ddr2_sdram_ck_p,
    output          [0:0]   ddr2_sdram_cke,
    output          [0:0]   ddr2_sdram_cs_n,
    output          [1:0]   ddr2_sdram_dm,
    inout          [15:0]   ddr2_sdram_dq,
    inout           [1:0]   ddr2_sdram_dqs_n,
    inout           [1:0]   ddr2_sdram_dqs_p,
    output          [0:0]   ddr2_sdram_odt,
    output                  ddr2_sdram_ras_n,
    output                  ddr2_sdram_we_n,

    input                   uart_rxd,
    output                  uart_txd,

    output                  ddr_calib,

    input                   jtag_tck,
    input                   jtag_tms,
    input                   jtag_tdi,
    output                  jtag_tdo,

    output                  user_led15
);



//=======================================================
//  Signals / Variables declarations
//=======================================================
logic                   pll_locked;
logic                   clk_riscv;
logic                   rstn_riscv;

// --- SCR1 ---------------------------------------------

// AXI IMEM
logic [ 2:0]            axi_imem_arid;
logic [31:0]            axi_imem_araddr;
logic                   axi_imem_arvalid;
logic                   axi_imem_arready;
logic [ 7:0]            axi_imem_arlen;
logic [ 2:0]            axi_imem_arsize;
logic [ 1:0]            axi_imem_arburst;
logic [ 3:0]            axi_imem_arcache;
logic [ 2:0]            axi_imem_rid;
logic [31:0]            axi_imem_rdata;
logic                   axi_imem_rvalid;
logic                   axi_imem_rready;
logic [ 1:0]            axi_imem_rresp;
logic                   axi_imem_rlast;
// AXI DMEM
logic [ 1:0]            axi_dmem_awid;
logic [31:0]            axi_dmem_awaddr;
logic                   axi_dmem_awvalid;
logic                   axi_dmem_awready;
logic [ 7:0]            axi_dmem_awlen;
logic [ 2:0]            axi_dmem_awsize;
logic [ 1:0]            axi_dmem_awburst;
logic [ 3:0]            axi_dmem_awcache;
logic [31:0]            axi_dmem_wdata;
logic [ 3:0]            axi_dmem_wstrb;
logic                   axi_dmem_wvalid;
logic                   axi_dmem_wready;
logic                   axi_dmem_wlast;
logic [ 1:0]            axi_dmem_bid;
logic [ 1:0]            axi_dmem_bresp;
logic                   axi_dmem_bvalid;
logic                   axi_dmem_bready;
logic [ 1:0]            axi_dmem_arid;
logic [31:0]            axi_dmem_araddr;
logic                   axi_dmem_arvalid;
logic                   axi_dmem_arready;
logic [ 7:0]            axi_dmem_arlen;
logic [ 2:0]            axi_dmem_arsize;
logic [ 1:0]            axi_dmem_arburst;
logic [ 3:0]            axi_dmem_arcache;
logic [ 1:0]            axi_dmem_rid;
logic [31:0]            axi_dmem_rdata;
logic                   axi_dmem_rvalid;
logic                   axi_dmem_rready;
logic [ 1:0]            axi_dmem_rresp;
logic                   axi_dmem_rlast;


logic [SCR1_IRQ_LINES_NUM-1:0]      scr1_irq;
//logic [31:0]            riscv_irq;




logic [23:0] clk_cnt;
always @ (posedge clk_riscv, negedge rstn_riscv)
	if (~rstn_riscv) clk_cnt <= 'd0;
	else clk_cnt <= clk_cnt + 'd1;
assign user_led15 = clk_cnt[23];



logic riscv0_irq;
assign scr1_irq = {31'd0, riscv0_irq};


scr1_top_axi
i_scr1 (
    // Common
    .pwrup_rst_n                (1'b1),
    .rst_n                      (rstn_riscv),
    .cpu_rst_n                  (1'b1),
    .test_mode                  (1'b0),
    .test_rst_n                 (1'b1),
    .clk                        (clk_riscv),
    .rtc_clk                    (1'b0),
`ifdef SCR1_DBGC_EN
    .ndm_rst_n_out              (),
`endif // SCR1_DBGC_EN

    // Fuses
    .fuse_mhartid               ('0),
`ifdef SCR1_DBGC_EN
    .fuse_idcode                (`SCR1_TAP_IDCODE),
`endif // SCR1_DBGC_EN

    // IRQ
`ifdef SCR1_IPIC_EN
    .irq_lines                  (scr1_irq),
`else
    .ext_irq                    (scr1_irq[0]),
`endif // SCR1_IPIC_EN
    .soft_irq                   (1'b0),

`ifdef SCR1_DBGC_EN
    // Debug Interface - JTAG I/F
    .trst_n                     ('1),
    .tck                        (jtag_tck),
    .tms                        (jtag_tms),
    .tdi                        (jtag_tdi),
    .tdo                        (jtag_tdo),
    .tdo_en                     (),
`endif // SCR1_DBGC_EN

    // Instruction Memory Interface
    .io_axi_imem_awid           (),
    .io_axi_imem_awaddr         (),
    .io_axi_imem_awlen          (),
    .io_axi_imem_awsize         (),
    .io_axi_imem_awburst        (),
    .io_axi_imem_awlock         (),
    .io_axi_imem_awcache        (),
    .io_axi_imem_awprot         (),
    .io_axi_imem_awregion       (),
    .io_axi_imem_awuser         (),
    .io_axi_imem_awqos          (),
    .io_axi_imem_awvalid        (),
    .io_axi_imem_awready        ('0),
    .io_axi_imem_wdata          (),
    .io_axi_imem_wstrb          (),
    .io_axi_imem_wlast          (),
    .io_axi_imem_wuser          (),
    .io_axi_imem_wvalid         (),
    .io_axi_imem_wready         ('0),
    .io_axi_imem_bid            ('0),
    .io_axi_imem_bresp          ('0),
    .io_axi_imem_bvalid         ('0),
    .io_axi_imem_buser          ('0),
    .io_axi_imem_bready         (),
    .io_axi_imem_arid           (axi_imem_arid),
    .io_axi_imem_araddr         (axi_imem_araddr),
    .io_axi_imem_arlen          (axi_imem_arlen),
    .io_axi_imem_arsize         (axi_imem_arsize),
    .io_axi_imem_arburst        (axi_imem_arburst),
    .io_axi_imem_arlock         (),
    .io_axi_imem_arcache        (),
    .io_axi_imem_arprot         (),
    .io_axi_imem_arregion       (),
    .io_axi_imem_aruser         (),
    .io_axi_imem_arqos          (),
    .io_axi_imem_arvalid        (axi_imem_arvalid),
    .io_axi_imem_arready        (axi_imem_arready),
    .io_axi_imem_rid            (axi_imem_rid),
    .io_axi_imem_rdata          (axi_imem_rdata),
    .io_axi_imem_rresp          (axi_imem_rresp),
    .io_axi_imem_rlast          (axi_imem_rlast),
    .io_axi_imem_ruser          ('0),
    .io_axi_imem_rvalid         (axi_imem_rvalid),
    .io_axi_imem_rready         (axi_imem_rready),

    // Data Memory Interface
    .io_axi_dmem_awid           (axi_dmem_awid),
    .io_axi_dmem_awaddr         (axi_dmem_awaddr),
    .io_axi_dmem_awlen          (axi_dmem_awlen),
    .io_axi_dmem_awsize         (axi_dmem_awsize),
    .io_axi_dmem_awburst        (axi_dmem_awburst),
    .io_axi_dmem_awlock         (),
    .io_axi_dmem_awcache        (),
    .io_axi_dmem_awprot         (),
    .io_axi_dmem_awregion       (),
    .io_axi_dmem_awuser         (),
    .io_axi_dmem_awqos          (),
    .io_axi_dmem_awvalid        (axi_dmem_awvalid),
    .io_axi_dmem_awready        (axi_dmem_awready),
    .io_axi_dmem_wdata          (axi_dmem_wdata),
    .io_axi_dmem_wstrb          (axi_dmem_wstrb),
    .io_axi_dmem_wlast          (axi_dmem_wlast),
    .io_axi_dmem_wuser          (),
    .io_axi_dmem_wvalid         (axi_dmem_wvalid),
    .io_axi_dmem_wready         (axi_dmem_wready),
    .io_axi_dmem_bid            (axi_dmem_bid),
    .io_axi_dmem_bresp          (axi_dmem_bresp),
    .io_axi_dmem_bvalid         (axi_dmem_bvalid),
    .io_axi_dmem_buser          ('0),
    .io_axi_dmem_bready         (axi_dmem_bready),
    .io_axi_dmem_arid           (axi_dmem_arid),
    .io_axi_dmem_araddr         (axi_dmem_araddr),
    .io_axi_dmem_arlen          (axi_dmem_arlen),
    .io_axi_dmem_arsize         (axi_dmem_arsize),
    .io_axi_dmem_arburst        (axi_dmem_arburst),
    .io_axi_dmem_arlock         (),
    .io_axi_dmem_arcache        (),
    .io_axi_dmem_arprot         (),
    .io_axi_dmem_arregion       (),
    .io_axi_dmem_aruser         (),
    .io_axi_dmem_arqos          (),
    .io_axi_dmem_arvalid        (axi_dmem_arvalid),
    .io_axi_dmem_arready        (axi_dmem_arready),
    .io_axi_dmem_rid            (axi_dmem_rid),
    .io_axi_dmem_rdata          (axi_dmem_rdata),
    .io_axi_dmem_rresp          (axi_dmem_rresp),
    .io_axi_dmem_rlast          (axi_dmem_rlast),
    .io_axi_dmem_ruser          ('0),
    .io_axi_dmem_rvalid         (axi_dmem_rvalid),
    .io_axi_dmem_rready         (axi_dmem_rready)
);


soc i_soc (
    .reset                      (reset              ),
    .sys_clock                  (sys_clock          ),
    .clk_riscv                  (clk_riscv          ),
    .rstn_riscv                 (rstn_riscv         ),


    .uart_ctsn                  ('1                 ),
    .uart_rtsn                  (                   ),
    .uart_rxd                   (uart_rxd           ),
    .uart_txd                   (uart_txd           ),

    .uart_irq                   (riscv0_irq         ),

    .ddr_calib                  (ddr_calib          ),

    .ddr2_sdram_addr            (ddr2_sdram_addr    ),
    .ddr2_sdram_ba              (ddr2_sdram_ba      ),
    .ddr2_sdram_cas_n           (ddr2_sdram_cas_n   ),
    .ddr2_sdram_ck_n            (ddr2_sdram_ck_n    ),
    .ddr2_sdram_ck_p            (ddr2_sdram_ck_p    ),
    .ddr2_sdram_cke             (ddr2_sdram_cke     ),
    .ddr2_sdram_cs_n            (ddr2_sdram_cs_n    ),
    .ddr2_sdram_dm              (ddr2_sdram_dm      ),
    .ddr2_sdram_dq              (ddr2_sdram_dq      ),
    .ddr2_sdram_dqs_n           (ddr2_sdram_dqs_n   ),
    .ddr2_sdram_dqs_p           (ddr2_sdram_dqs_p   ),
    .ddr2_sdram_odt             (ddr2_sdram_odt     ),
    .ddr2_sdram_ras_n           (ddr2_sdram_ras_n   ),
    .ddr2_sdram_we_n            (ddr2_sdram_we_n    ),


    .axi_imem_arid              (axi_imem_arid      ),
    .axi_imem_araddr            (axi_imem_araddr    ),
    .axi_imem_arlen             (axi_imem_arlen     ),
    .axi_imem_arsize            (axi_imem_arsize    ),
    .axi_imem_arburst           (axi_imem_arburst   ),
    .axi_imem_arlock            ('0                 ),
    .axi_imem_arcache           ('d3                ),
    .axi_imem_arprot            ('0                 ),
    .axi_imem_arqos             ('0                 ),
    .axi_imem_arvalid           (axi_imem_arvalid   ),
    .axi_imem_arready           (axi_imem_arready   ),
    .axi_imem_rid               (axi_imem_rid       ),
    .axi_imem_rdata             (axi_imem_rdata     ),
    .axi_imem_rresp             (axi_imem_rresp     ),
    .axi_imem_rlast             (axi_imem_rlast     ),
    .axi_imem_rvalid            (axi_imem_rvalid    ),
    .axi_imem_rready            (axi_imem_rready    ),

    .axi_dmem_awid              (axi_dmem_awid      ),
    .axi_dmem_awaddr            (axi_dmem_awaddr    ),
    .axi_dmem_awlen             (axi_dmem_awlen     ),
    .axi_dmem_awsize            (axi_dmem_awsize    ),
    .axi_dmem_awburst           (axi_dmem_awburst   ),
    .axi_dmem_awlock            ('0                 ),
    .axi_dmem_awcache           ('d3                ),
    .axi_dmem_awprot            ('0                 ),
    .axi_dmem_awqos             ('0                 ),
    .axi_dmem_awvalid           (axi_dmem_awvalid   ),
    .axi_dmem_awready           (axi_dmem_awready   ),
    .axi_dmem_wdata             (axi_dmem_wdata     ),
    .axi_dmem_wstrb             (axi_dmem_wstrb     ),
    .axi_dmem_wlast             (axi_dmem_wlast     ),
    .axi_dmem_wvalid            (axi_dmem_wvalid    ),
    .axi_dmem_wready            (axi_dmem_wready    ),
    .axi_dmem_bid               (axi_dmem_bid       ),
    .axi_dmem_bresp             (axi_dmem_bresp     ),
    .axi_dmem_bvalid            (axi_dmem_bvalid    ),
    .axi_dmem_bready            (axi_dmem_bready    ),
    .axi_dmem_arid              (axi_dmem_arid      ),
    .axi_dmem_araddr            (axi_dmem_araddr    ),
    .axi_dmem_arlen             (axi_dmem_arlen     ),
    .axi_dmem_arsize            (axi_dmem_arsize    ),
    .axi_dmem_arburst           (axi_dmem_arburst   ),
    .axi_dmem_arlock            ('0                 ),
    .axi_dmem_arcache           ('d3                ),
    .axi_dmem_arprot            ('0                 ),
    .axi_dmem_arqos             ('0                 ),
    .axi_dmem_arvalid           (axi_dmem_arvalid   ),
    .axi_dmem_arready           (axi_dmem_arready   ),
    .axi_dmem_rid               (axi_dmem_rid       ),
    .axi_dmem_rdata             (axi_dmem_rdata     ),
    .axi_dmem_rresp             (axi_dmem_rresp     ),
    .axi_dmem_rlast             (axi_dmem_rlast     ),
    .axi_dmem_rvalid            (axi_dmem_rvalid    ),
    .axi_dmem_rready            (axi_dmem_rready    ),

    .bld_id_tri_i               (FPGA_BUILD_ID      )
);


endmodule : nexys4ddr_scr1_top
