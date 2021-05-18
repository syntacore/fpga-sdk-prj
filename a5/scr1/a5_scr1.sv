/// Copyright by Syntacore LLC © 2016, 2017, 2021. See LICENSE for details
/// @file       <a5_scr1.sv>
/// @brief      SC_RISCV_SDK @Arria V Starter kit
///

`include "scr1_arch_types.svh"
`include "scr1_arch_description.svh"
`include "scr1_memif.svh"
`include "scr1_ipic.svh"

parameter bit [31:0] FPGA_A5_SOC_ID         = `SCR1_PTFM_SOC_ID;
parameter bit [31:0] FPGA_A5_BLD_ID         = `SCR1_PTFM_BLD_ID;
parameter bit [31:0] FPGA_A5_CORE_CLK_FREQ  = `SCR1_PTFM_CORE_CLK_FREQ;

module a5_scr1 (
    // === CLOCK ===========================================
    input  logic                    CLKIN_50_BOT,
    input  logic                    CLKINTOP_100_P,
    // === RESET ===========================================
    // USER_PB[2] is used as manual reset for SCR1 (see below).
    // === DDR3 SDRAM ======================================
    output logic            DDR3_CK_N,
    output logic            DDR3_CK_P,
    output logic            DDR3_CKE,
    output logic            DDR3_RESET_N,
    output logic            DDR3_CS_N,
    output logic            DDR3_WE_N,
    output logic            DDR3_RAS_N,
    output logic            DDR3_CAS_N,
    output logic [2:0]      DDR3_BA,
    output logic [12:0]     DDR3_ADDR,
    output logic [3:0]      DDR3_DM,
    inout  logic [31:0]     DDR3_DQ,
    inout  logic [3:0]      DDR3_DQS_P,
    inout  logic [3:0]      DDR3_DQS_N,
    output logic            DDR3_ODT,
    input  logic            DDR3_OCT_RZQ,
    // === LEDs ============================================
    output logic [3:0]      USER_LED,
    // === Buttons =========================================
    input  logic [2:0]      USER_PB,
    // === JTAG ============================================
    `ifdef SCR1_DBG_EN
    input  logic            JTAG_SRST_N,
    input  logic            JTAG_TRST_N,
    input  logic            JTAG_TCK,
    input  logic            JTAG_TMS,
    input  logic            JTAG_TDI,
    output logic            JTAG_TDO,
    output logic [1:0]      JTAG_VCC,
    output logic [7:0]      JTAG_GND,
    `endif//SCR1_DBG_EN
    // === UART ============================================
    output logic            UART_TXD,    // <- UART
    input  logic            UART_RXD     // -> UART
);



//=======================================================
//  Signals / Variables declarations
//=======================================================
logic                   pwrup_rst_n;
logic                   cpu_clk;
logic                   extn_rst_in_n;
logic                   extn_rst_n;
logic [1:0]             extn_rst_n_sync;
logic                   hard_rst_n;
logic [3:0]             hard_rst_n_count;
logic                   soc_rst_n;
logic                   cpu_rst_n;
`ifdef SCR1_DBG_EN
logic                   sys_rst_n;
`endif // SCR1_DBG_EN

// --- SCR1 ---------------------------------------------
// AXI
logic [ 3:0]            axi_imem_awid;
logic [31:0]            axi_imem_awaddr;
logic                   axi_imem_awvalid;
logic                   axi_imem_awready;
logic [ 7:0]            axi_imem_awlen;
logic [ 2:0]            axi_imem_awsize;
logic [ 1:0]            axi_imem_awburst;
logic [31:0]            axi_imem_wdata;
logic [ 3:0]            axi_imem_wstrb;
logic                   axi_imem_wvalid;
logic                   axi_imem_wready;
logic                   axi_imem_wlast;
logic [ 3:0]            axi_imem_bid;
logic [ 1:0]            axi_imem_bresp;
logic                   axi_imem_bvalid;
logic                   axi_imem_bready;
logic [ 3:0]            axi_imem_arid;
logic [31:0]            axi_imem_araddr;
logic                   axi_imem_arvalid;
logic                   axi_imem_arready;
logic [ 7:0]            axi_imem_arlen;
logic [ 2:0]            axi_imem_arsize;
logic [ 1:0]            axi_imem_arburst;
logic [ 3:0]            axi_imem_rid;
logic [31:0]            axi_imem_rdata;
logic                   axi_imem_rvalid;
logic                   axi_imem_rready;
logic [ 1:0]            axi_imem_rresp;
logic                   axi_imem_rlast;
//
logic [ 3:0]            axi_dmem_awid;
logic [31:0]            axi_dmem_awaddr;
logic                   axi_dmem_awvalid;
logic                   axi_dmem_awready;
logic [ 7:0]            axi_dmem_awlen;
logic [ 2:0]            axi_dmem_awsize;
logic [ 1:0]            axi_dmem_awburst;
logic [31:0]            axi_dmem_wdata;
logic [ 3:0]            axi_dmem_wstrb;
logic                   axi_dmem_wvalid;
logic                   axi_dmem_wready;
logic                   axi_dmem_wlast;
logic [ 3:0]            axi_dmem_bid;
logic [ 1:0]            axi_dmem_bresp;
logic                   axi_dmem_bvalid;
logic                   axi_dmem_bready;
logic [ 3:0]            axi_dmem_arid;
logic [31:0]            axi_dmem_araddr;
logic                   axi_dmem_arvalid;
logic                   axi_dmem_arready;
logic [ 7:0]            axi_dmem_arlen;
logic [ 2:0]            axi_dmem_arsize;
logic [ 1:0]            axi_dmem_arburst;
logic [ 3:0]            axi_dmem_rid;
logic [31:0]            axi_dmem_rdata;
logic                   axi_dmem_rvalid;
logic                   axi_dmem_rready;
logic [ 1:0]            axi_dmem_rresp;
logic                   axi_dmem_rlast;
`ifdef SCR1_IPIC_EN
logic [31:0]            scr1_irq;
`else
logic                   scr1_irq;
`endif // SCR1_IPIC_EN

// --- DDR3 SDRAM ---------------------------------------
logic                   ddr3_init_done;
logic                   ddr3_cal_success;
logic                   ddr3_cal_fail;

// --- JTAG ---------------------------------------------
`ifdef SCR1_DBG_EN
logic                   scr1_jtag_trst_n;
logic                   scr1_jtag_tck;
logic                   scr1_jtag_tms;
logic                   scr1_jtag_tdi;
logic                   scr1_jtag_tdo_en;
logic                   scr1_jtag_tdo_int;
`endif // SCR1_DBG_EN

// --- UART ---------------------------------------------
//logic                   uart_rxd;   // -> UART
//logic                   uart_txd;   // <- UART
logic                   uart_rts_n; // <- UART
logic                   uart_dtr_n; // <- UART
logic                   uart_irq;

logic [31:0]            uart_readdata;
logic                   uart_readdatavalid;
logic [31:0]            uart_writedata;
logic  [4:0]            uart_address;
logic                   uart_write;
logic                   uart_read;
logic                   uart_waitrequest;

logic                   uart_wb_ack;
logic  [7:0]            uart_wb_dat;
logic                   uart_read_vd;
// --- Heartbeat ----------------------------------------
logic [31:0]            rtc_counter;
logic                   tick_2Hz;
logic                   heartbeat;

//=======================================================
//  Resets
//=======================================================
assign extn_rst_in_n    = USER_PB[2]
`ifdef SCR1_DBG_EN
                        & JTAG_SRST_N
`endif // SCR1_DBG_EN
;

always_ff @(posedge cpu_clk, negedge pwrup_rst_n)
begin
    if (~pwrup_rst_n) begin
        extn_rst_n_sync     <= '0;
    end else begin
        extn_rst_n_sync[0]  <= extn_rst_in_n;
        extn_rst_n_sync[1]  <= extn_rst_n_sync[0];
    end
end
assign extn_rst_n = extn_rst_n_sync[1];

always_ff @(posedge cpu_clk, negedge pwrup_rst_n)
begin
    if (~pwrup_rst_n) begin
        hard_rst_n          <= 1'b0;
        hard_rst_n_count    <= '0;
    end else begin
        if (hard_rst_n) begin
            // hard_rst_n == 1 - de-asserted
            hard_rst_n          <= extn_rst_n;
            hard_rst_n_count    <= '0;
        end else begin
            // hard_rst_n == 0 - asserted
            if (extn_rst_n) begin
                if (hard_rst_n_count == '1) begin
                    // If extn_rst_n = 1 at least 16 clocks,
                    // de-assert hard_rst_n
                    hard_rst_n          <= 1'b1;
                end else begin
                    hard_rst_n_count    <= hard_rst_n_count + 1'b1;
                end
            end else begin
                // If extn_rst_n is asserted within 16-cycles window -> start
                // counting from the beginning
                hard_rst_n_count    <= '0;
            end
        end
    end
end

`ifdef SCR1_DBG_EN
assign soc_rst_n = sys_rst_n;
`else
assign soc_rst_n = hard_rst_n;
`endif // SCR1_DBG_EN

//=======================================================
//  Heartbeat
//=======================================================
always_ff @(posedge cpu_clk, negedge hard_rst_n)
begin
    if (~hard_rst_n) begin
        rtc_counter     <= '0;
        tick_2Hz        <= 1'b0;
    end
    else begin
        if (rtc_counter == '0) begin
            rtc_counter <= (FPGA_A5_CORE_CLK_FREQ/2);
            tick_2Hz    <= 1'b1;
        end
        else begin
            rtc_counter <= rtc_counter - 1'b1;
            tick_2Hz    <= 1'b0;
        end
    end
end

always_ff @(posedge cpu_clk, negedge hard_rst_n)
begin
    if (~hard_rst_n) begin
        heartbeat       <= 1'b0;
    end
    else begin
        if (tick_2Hz) begin
            heartbeat   <= ~heartbeat;
        end
    end
end

//=======================================================
//  SCR1 Core's Processor Cluster
//=======================================================
scr1_top_axi
i_scr_top (
    // Common
    .pwrup_rst_n                        (pwrup_rst_n            ),
    .rst_n                              (hard_rst_n             ),
    .cpu_rst_n                          (cpu_rst_n              ),
    .test_mode                          (1'b0                   ),
    .test_rst_n                         (1'b1                   ),
    .clk                                (cpu_clk                ),
    .rtc_clk                            (1'b0                   ),
`ifdef SCR1_DBG_EN
    .sys_rst_n_o                        (sys_rst_n              ),
    .sys_rdc_qlfy_o                     (                       ),
`endif // SCR1_DBG_EN

    // Fuses
    .fuse_mhartid                       ('0                     ),
`ifdef SCR1_DBG_EN
    .fuse_idcode                        (`SCR1_TAP_IDCODE       ),
`endif // SCR1_DBG_EN

`ifdef SCR1_IPIC_EN
    .irq_lines                          (scr1_irq               ),
`else // SCR1_IPIC_EN
    .ext_irq                            (scr1_irq               ),
`endif // SCR1_IPIC_EN
    .soft_irq                           ('0                     ),
    // Debug Interface
`ifdef SCR1_DBG_EN
    .trst_n                             (scr1_jtag_trst_n       ),
    .tck                                (scr1_jtag_tck          ),
    .tms                                (scr1_jtag_tms          ),
    .tdi                                (scr1_jtag_tdi          ),
    .tdo                                (scr1_jtag_tdo_int      ),
    .tdo_en                             (scr1_jtag_tdo_en       ),
`endif // SCR1_DBG_EN

    //---------------------------------------------------------------
    // AXI IMEM Interface
    //---------------------------------------------------------------
    .io_axi_imem_awid                  (axi_imem_awid),
    .io_axi_imem_awaddr                (axi_imem_awaddr),
    .io_axi_imem_awlen                 (axi_imem_awlen),
    .io_axi_imem_awsize                (axi_imem_awsize),
    .io_axi_imem_awburst               (axi_imem_awburst),
    .io_axi_imem_awlock                (),
    .io_axi_imem_awcache               (),
    .io_axi_imem_awprot                (),
    .io_axi_imem_awregion              (),
    .io_axi_imem_awuser                (),
    .io_axi_imem_awqos                 (),
    .io_axi_imem_awvalid               (axi_imem_awvalid),
    .io_axi_imem_awready               (axi_imem_awready),
    .io_axi_imem_wdata                 (axi_imem_wdata),
    .io_axi_imem_wstrb                 (axi_imem_wstrb),
    .io_axi_imem_wlast                 (axi_imem_wlast),
    .io_axi_imem_wuser                 (),
    .io_axi_imem_wvalid                (axi_imem_wvalid),
    .io_axi_imem_wready                (axi_imem_wready),
    .io_axi_imem_bid                   (axi_imem_bid),
    .io_axi_imem_bresp                 (axi_imem_bresp),
    .io_axi_imem_bvalid                (axi_imem_bvalid),
    .io_axi_imem_buser                 ('0),
    .io_axi_imem_bready                (axi_imem_bready),
    .io_axi_imem_arid                  (axi_imem_arid),
    .io_axi_imem_araddr                (axi_imem_araddr),
    .io_axi_imem_arlen                 (axi_imem_arlen),
    .io_axi_imem_arsize                (axi_imem_arsize),
    .io_axi_imem_arburst               (axi_imem_arburst),
    .io_axi_imem_arlock                (),
    .io_axi_imem_arcache               (),
    .io_axi_imem_arprot                (),
    .io_axi_imem_arregion              (),
    .io_axi_imem_aruser                (),
    .io_axi_imem_arqos                 (),
    .io_axi_imem_arvalid               (axi_imem_arvalid),
    .io_axi_imem_arready               (axi_imem_arready),
    .io_axi_imem_rid                   (axi_imem_rid),
    .io_axi_imem_rdata                 (axi_imem_rdata),
    .io_axi_imem_rresp                 (axi_imem_rresp),
    .io_axi_imem_rlast                 (axi_imem_rlast),
    .io_axi_imem_ruser                 ('0),
    .io_axi_imem_rvalid                (axi_imem_rvalid),
    .io_axi_imem_rready                (axi_imem_rready),
    //---------------------------------------------------------------
    // AXI DMEM Interface
    //---------------------------------------------------------------
    .io_axi_dmem_awid                  (axi_dmem_awid),
    .io_axi_dmem_awaddr                (axi_dmem_awaddr),
    .io_axi_dmem_awlen                 (axi_dmem_awlen),
    .io_axi_dmem_awsize                (axi_dmem_awsize),
    .io_axi_dmem_awburst               (axi_dmem_awburst),
    .io_axi_dmem_awlock                (),
    .io_axi_dmem_awcache               (),
    .io_axi_dmem_awprot                (),
    .io_axi_dmem_awregion              (),
    .io_axi_dmem_awuser                (),
    .io_axi_dmem_awqos                 (),
    .io_axi_dmem_awvalid               (axi_dmem_awvalid),
    .io_axi_dmem_awready               (axi_dmem_awready),
    .io_axi_dmem_wdata                 (axi_dmem_wdata),
    .io_axi_dmem_wstrb                 (axi_dmem_wstrb),
    .io_axi_dmem_wlast                 (axi_dmem_wlast),
    .io_axi_dmem_wuser                 (),
    .io_axi_dmem_wvalid                (axi_dmem_wvalid),
    .io_axi_dmem_wready                (axi_dmem_wready),
    .io_axi_dmem_bid                   (axi_dmem_bid),
    .io_axi_dmem_bresp                 (axi_dmem_bresp),
    .io_axi_dmem_bvalid                (axi_dmem_bvalid),
    .io_axi_dmem_buser                 ('0),
    .io_axi_dmem_bready                (axi_dmem_bready),
    .io_axi_dmem_arid                  (axi_dmem_arid),
    .io_axi_dmem_araddr                (axi_dmem_araddr),
    .io_axi_dmem_arlen                 (axi_dmem_arlen),
    .io_axi_dmem_arsize                (axi_dmem_arsize),
    .io_axi_dmem_arburst               (axi_dmem_arburst),
    .io_axi_dmem_arlock                (),
    .io_axi_dmem_arcache               (),
    .io_axi_dmem_arprot                (),
    .io_axi_dmem_arregion              (),
    .io_axi_dmem_aruser                (),
    .io_axi_dmem_arqos                 (),
    .io_axi_dmem_arvalid               (axi_dmem_arvalid),
    .io_axi_dmem_arready               (axi_dmem_arready),
    .io_axi_dmem_rid                   (axi_dmem_rid),
    .io_axi_dmem_rdata                 (axi_dmem_rdata),
    .io_axi_dmem_rresp                 (axi_dmem_rresp),
    .io_axi_dmem_rlast                 (axi_dmem_rlast),
    .io_axi_dmem_ruser                 ('0),
    .io_axi_dmem_rvalid                (axi_dmem_rvalid),
    .io_axi_dmem_rready                (axi_dmem_rready)
);

assign scr1_irq = {31'd0, uart_irq};

//==========================================================
// UART 16550 IP
//==========================================================
always_ff @(posedge cpu_clk, negedge soc_rst_n)
if (~soc_rst_n)             uart_read_vd <= '0;
    else if (uart_wb_ack)   uart_read_vd <= '0;
    else if (uart_read)     uart_read_vd <= '1;

always_ff @(posedge cpu_clk) begin
    uart_readdatavalid  <= uart_wb_ack & uart_read_vd;
    uart_readdata       <= {24'd0,uart_wb_dat};
end

assign uart_waitrequest = ~uart_wb_ack;

uart_top i_uart(
    .wb_clk_i       (cpu_clk                ),
    // Wishbone signals
    .wb_rst_i       (~soc_rst_n             ),
    .wb_adr_i       (uart_address[4:2]      ),
    .wb_dat_i       (uart_writedata[7:0]    ),
    .wb_dat_o       (uart_wb_dat            ),
    .wb_we_i        (uart_write             ),
    .wb_stb_i       (uart_read_vd|uart_write),
    .wb_cyc_i       (uart_read_vd|uart_write),
    .wb_ack_o       (uart_wb_ack            ),
    .wb_sel_i       (4'd1                   ),
    .int_o          (uart_irq               ),

    .stx_pad_o      (UART_TXD               ),
    .srx_pad_i      (UART_RXD               ),

    .rts_pad_o      (uart_rts_n             ),
    .cts_pad_i      (uart_rts_n             ),
    .dtr_pad_o      (uart_dtr_n             ),
    .dsr_pad_i      (uart_dtr_n             ),
    .ri_pad_i       ('1                     ),
    .dcd_pad_i      ('1                     )
);

//=======================================================
//  FPGA Platform's System-on-Programmable-Chip (SOPC)
//=======================================================
a5_sopc
i_soc (
    .osc_100_clk                        (CLKINTOP_100_P     ),
    .osc_50_clk                         (CLKIN_50_BOT       ),
    .sys_pll_reset                      (1'b0               ),
    .pwrup_rst_n_out_export             (pwrup_rst_n        ),
    .soc_reset_in_reset_n               (soc_rst_n          ),
    .cpu_reset_in_reset_n               (ddr3_init_done     ),
    .cpu_reset_out_reset_n              (cpu_rst_n          ),
    .cpu_clk_clk                        (cpu_clk            ),
    //
    .ddr3_mem_a                         (DDR3_ADDR          ),
    .ddr3_mem_ba                        (DDR3_BA            ),
    .ddr3_mem_ck                        (DDR3_CK_P          ),
    .ddr3_mem_ck_n                      (DDR3_CK_N          ),
    .ddr3_mem_cke                       (DDR3_CKE           ),
    .ddr3_mem_cs_n                      (DDR3_CS_N          ),
    .ddr3_mem_dm                        (DDR3_DM            ),
    .ddr3_mem_ras_n                     (DDR3_RAS_N         ),
    .ddr3_mem_cas_n                     (DDR3_CAS_N         ),
    .ddr3_mem_we_n                      (DDR3_WE_N          ),
    .ddr3_mem_reset_n                   (DDR3_RESET_N       ),
    .ddr3_mem_dq                        (DDR3_DQ            ),
    .ddr3_mem_dqs                       (DDR3_DQS_P         ),
    .ddr3_mem_dqs_n                     (DDR3_DQS_N         ),
    .ddr3_mem_odt                       (DDR3_ODT           ),
    .ddr3_oct_rzqin                     (DDR3_OCT_RZQ       ),
    .ddr3_status_local_init_done        (ddr3_init_done     ),
    .ddr3_status_local_cal_success      (ddr3_cal_success   ),
    .ddr3_status_local_cal_fail         (ddr3_cal_fail      ),
    //
    .axi_imem_awid                      (axi_imem_awid      ),
    .axi_imem_awaddr                    (axi_imem_awaddr    ),
    .axi_imem_awlen                     (axi_imem_awlen     ),
    .axi_imem_awsize                    (axi_imem_awsize    ),
    .axi_imem_awburst                   (axi_imem_awburst   ),
    .axi_imem_awprot                    ('0                 ),
    .axi_imem_awvalid                   (axi_imem_awvalid   ),
    .axi_imem_awready                   (axi_imem_awready   ),
    .axi_imem_wdata                     (axi_imem_wdata     ),
    .axi_imem_wstrb                     (axi_imem_wstrb     ),
    .axi_imem_wlast                     (axi_imem_wlast     ),
    .axi_imem_wvalid                    (axi_imem_wvalid    ),
    .axi_imem_wready                    (axi_imem_wready    ),
    .axi_imem_bid                       (axi_imem_bid       ),
    .axi_imem_bresp                     (axi_imem_bresp     ),
    .axi_imem_bvalid                    (axi_imem_bvalid    ),
    .axi_imem_bready                    (axi_imem_bready    ),
    .axi_imem_arid                      (axi_imem_arid      ),
    .axi_imem_araddr                    (axi_imem_araddr    ),
    .axi_imem_arlen                     (axi_imem_arlen     ),
    .axi_imem_arsize                    (axi_imem_arsize    ),
    .axi_imem_arburst                   (axi_imem_arburst   ),
    .axi_imem_arprot                    ('0                 ),
    .axi_imem_arvalid                   (axi_imem_arvalid   ),
    .axi_imem_arready                   (axi_imem_arready   ),
    .axi_imem_rid                       (axi_imem_rid       ),
    .axi_imem_rdata                     (axi_imem_rdata     ),
    .axi_imem_rresp                     (axi_imem_rresp     ),
    .axi_imem_rlast                     (axi_imem_rlast     ),
    .axi_imem_rvalid                    (axi_imem_rvalid    ),
    .axi_imem_rready                    (axi_imem_rready    ),

    .axi_dmem_awid                      (axi_dmem_awid      ),
    .axi_dmem_awaddr                    (axi_dmem_awaddr    ),
    .axi_dmem_awlen                     (axi_dmem_awlen     ),
    .axi_dmem_awsize                    (axi_dmem_awsize    ),
    .axi_dmem_awburst                   (axi_dmem_awburst   ),
    .axi_dmem_awprot                    ('0                 ),
    .axi_dmem_awvalid                   (axi_dmem_awvalid   ),
    .axi_dmem_awready                   (axi_dmem_awready   ),
    .axi_dmem_wdata                     (axi_dmem_wdata     ),
    .axi_dmem_wstrb                     (axi_dmem_wstrb     ),
    .axi_dmem_wlast                     (axi_dmem_wlast     ),
    .axi_dmem_wvalid                    (axi_dmem_wvalid    ),
    .axi_dmem_wready                    (axi_dmem_wready    ),
    .axi_dmem_bid                       (axi_dmem_bid       ),
    .axi_dmem_bresp                     (axi_dmem_bresp     ),
    .axi_dmem_bvalid                    (axi_dmem_bvalid    ),
    .axi_dmem_bready                    (axi_dmem_bready    ),
    .axi_dmem_arid                      (axi_dmem_arid      ),
    .axi_dmem_araddr                    (axi_dmem_araddr    ),
    .axi_dmem_arlen                     (axi_dmem_arlen     ),
    .axi_dmem_arsize                    (axi_dmem_arsize    ),
    .axi_dmem_arburst                   (axi_dmem_arburst   ),
    .axi_dmem_arprot                    ('0                 ),
    .axi_dmem_arvalid                   (axi_dmem_arvalid   ),
    .axi_dmem_arready                   (axi_dmem_arready   ),
    .axi_dmem_rid                       (axi_dmem_rid       ),
    .axi_dmem_rdata                     (axi_dmem_rdata     ),
    .axi_dmem_rresp                     (axi_dmem_rresp     ),
    .axi_dmem_rlast                     (axi_dmem_rlast     ),
    .axi_dmem_rvalid                    (axi_dmem_rvalid    ),
    .axi_dmem_rready                    (axi_dmem_rready    ),

    .uart_waitrequest                   (uart_waitrequest   ),
    .uart_readdata                      (uart_readdata      ),
    .uart_readdatavalid                 (uart_readdatavalid ),
    .uart_burstcount                    (                   ),
    .uart_writedata                     (uart_writedata     ),
    .uart_address                       (uart_address       ),
    .uart_write                         (uart_write         ),
    .uart_read                          (uart_read          ),
    .uart_byteenable                    (                   ),
    .uart_debugaccess                   (                   ),


    .soc_id_export                      (FPGA_A5_SOC_ID     ),
    .bld_id_export                      (FPGA_A5_BLD_ID     ),
    .core_clk_freq_export               (FPGA_A5_CORE_CLK_FREQ)
);

//==========================================================
// JTAG
//==========================================================
`ifdef SCR1_DBG_EN
assign scr1_jtag_trst_n     = JTAG_TRST_N;
assign scr1_jtag_tck        = JTAG_TCK;
assign scr1_jtag_tms        = JTAG_TMS;
assign scr1_jtag_tdi        = JTAG_TDI;
assign JTAG_TDO             = (scr1_jtag_tdo_en) ? scr1_jtag_tdo_int : 1'bZ;
//
assign JTAG_VCC             = '1;
assign JTAG_GND             = '0;
`endif // SCR1_DBG_EN

//==========================================================
// LEDs
//==========================================================
assign USER_LED[3]   = ~ddr3_cal_fail;
assign USER_LED[2]   = ~ddr3_cal_success;
//assign USER_LED[1]   = ~ddr3_init_done;
assign USER_LED[1]   =  hard_rst_n;
assign USER_LED[0]   = ~heartbeat;

endmodule
