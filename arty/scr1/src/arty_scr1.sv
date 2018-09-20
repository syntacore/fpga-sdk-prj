/// Copyright by Syntacore LLC © 2016, 2017. See LICENSE for details
/// @file       <arty_scr1.sv>
/// @brief      Top-level entity with SCR1 for Digilent Arty board
///

`include "scr1_arch_types.svh"
`include "scr1_arch_description.svh"
`include "scr1_arch_custom.svh"
`include "scr1_memif.svh"
`ifdef SCR1_IPIC_EN
`include "scr1_ipic.svh"
`endif // SCR1_IPIC_EN

parameter bit [31:0] FPGA_ARTY_BUILD_ID     = `SCR1_ARCH_BUILD_ID;
parameter bit [31:0] FPGA_ARTY_SYS_ID       = `SCR1_ARCH_SYS_ID;

module arty_scr1_top (
    // === CLOCK ===========================================
    input  logic                    OSC_100,
    // === RESET ===========================================
    input  logic                    RESETn,
    // === LEDs ============================================
    output logic    [ 3:0]          LEDR,
    output logic    [ 3:0]          LEDG,
    output logic    [ 3:0]          LEDB,
    output logic    [ 7:4]          LED,
    // === Buttons =========================================
    input  logic    [ 3:0]          BTN,
    // === PMOD D ==========================================
    inout  logic    [ 7:0]          JD,
    // === FTDI UART =======================================
    input  logic                    FTDI_TXD,
    output logic                    FTDI_RXD
);

//=======================================================
//  PARAMETER declarations
//=======================================================
localparam int unsigned SCR1_CORE_FREQUENCY     = 25000000;

//=======================================================
//  Signals / Variables declarations
//=======================================================
logic                               pll_rst_in;
logic                               pll_locked;
logic                               clk_riscv;
logic                               hard_rst_in_n;
logic   [1:0]                       hard_rst_in_sync;
logic                               hard_rst_n;

// --- SCR1 ---------------------------------------------
logic [3:0]                         ahb_imem_hprot;
logic [2:0]                         ahb_imem_hburst;
logic [2:0]                         ahb_imem_hsize;
logic [1:0]                         ahb_imem_htrans;
//logic                               ahb_imem_hmastlock;
logic [SCR1_AHB_WIDTH-1:0]          ahb_imem_haddr;
logic                               ahb_imem_hready;
logic [SCR1_AHB_WIDTH-1:0]          ahb_imem_hrdata;
logic                               ahb_imem_hresp;
//
logic [3:0]                         ahb_dmem_hprot;
logic [2:0]                         ahb_dmem_hburst;
logic [2:0]                         ahb_dmem_hsize;
logic [1:0]                         ahb_dmem_htrans;
//logic                               ahb_dmem_hmastlock;
logic [SCR1_AHB_WIDTH-1:0]          ahb_dmem_haddr;
logic                               ahb_dmem_hwrite;
logic [SCR1_AHB_WIDTH-1:0]          ahb_dmem_hwdata;
logic                               ahb_dmem_hready;
logic [SCR1_AHB_WIDTH-1:0]          ahb_dmem_hrdata;
logic                               ahb_dmem_hresp;
//
logic [SCR1_IRQ_LINES_NUM-1:0]      scr1_irq;
// --- JTAG ---
`ifdef SCR1_DBGC_EN
logic                               jtag_trst_n;
logic                               jtag_tck;
logic                               jtag_tms;
logic                               jtag_tdi;
logic                               jtag_tdo;
logic                               jtag_tdo_en;
`endif // SCR1_DBGC_EN

// --- UART ---------------------------------------------
logic                               uart_rxd;   // -> UART
logic                               uart_txd;   // <- UART
logic                               uart_rts_n; // <- UART
logic                               uart_dtr_n; // <- UART
logic                               uart_irq;

// --- PIO ----------------------------------------------
logic [ 1:0]                        pio_led;
logic [11:0]                        pio_led_rgb;
//logic [ 3:0]                        pio_sw;
logic [ 3:0]                        pio_pb;
logic                               pio_pb_irq;

// --- LED ----------------------------------------------

// --- Heartbeat ----------------------------------------
logic [31:0]                        rtc_counter;
logic                               tick_2Hz;
logic                               heartbeat;


//=======================================================
//  Structural coding
//=======================================================
assign pll_rst_in_n     = RESETn;
assign hard_rst_in_n    = RESETn & pll_locked & jtag_srst_n;

sys_pll
i_sys_pll (
    .rst_n      (pll_rst_in_n),
    .clk_in     (OSC_100),
    .clk_out    (clk_riscv),
    .locked     (pll_locked)
);

always_ff @(posedge clk_riscv, negedge hard_rst_in_n)
begin
    if (~hard_rst_in_n) begin
        hard_rst_in_sync[0] <= 1'b0;
        hard_rst_in_sync[1] <= 1'b0;
    end
    else begin
        hard_rst_in_sync[0] <= hard_rst_in_n;
        hard_rst_in_sync[1] <= hard_rst_in_sync[0];
    end
end
assign hard_rst_n = hard_rst_in_sync[1];

scr1_top_ahb
i_scr1 (
    // Common
    .rst_n                      (hard_rst_n),
    .rst_n_out                  (),
    .test_mode                  (1'd0),
    .clk                        (clk_riscv),
    .rtc_clk                    (1'b0),
    // Fuses
    .fuse_mhartid               ('0),

    // IRQ
`ifdef SCR1_IPIC_EN
    .irq_lines                  (scr1_irq),
`else
    .ext_irq                    (scr1_irq[0]),
`endif // SCR1_IPIC_EN
    .soft_irq                   (1'b0),

`ifdef SCR1_DBGC_EN
    // Debug Interface - JTAG I/F
    .trst_n                     (jtag_trst_n),
    .tck                        (jtag_tck),
    .tms                        (jtag_tms),
    .tdi                        (jtag_tdi),
    .tdo                        (jtag_tdo),
    .tdo_en                     (jtag_tdo_en),
`endif // SCR1_DBGC_EN

    // Instruction Memory Interface
    .imem_hprot                 (ahb_imem_hprot),
    .imem_hburst                (ahb_imem_hburst),
    .imem_hsize                 (ahb_imem_hsize),
    .imem_htrans                (ahb_imem_htrans),
    .imem_hmastlock             (),
    .imem_haddr                 (ahb_imem_haddr),
    .imem_hready                (ahb_imem_hready),
    .imem_hrdata                (ahb_imem_hrdata),
    .imem_hresp                 (ahb_imem_hresp),

    // Data Memory Interface
    .dmem_hprot                 (ahb_dmem_hprot),
    .dmem_hburst                (ahb_dmem_hburst),
    .dmem_hsize                 (ahb_dmem_hsize),
    .dmem_htrans                (ahb_dmem_htrans),
    .dmem_hmastlock             (),
    .dmem_haddr                 (ahb_dmem_haddr),
    .dmem_hwrite                (ahb_dmem_hwrite),
    .dmem_hwdata                (ahb_dmem_hwdata),
    .dmem_hready                (ahb_dmem_hready),
    .dmem_hrdata                (ahb_dmem_hrdata),
    .dmem_hresp                 (ahb_dmem_hresp)
);

assign scr1_irq = {'0, pio_pb_irq, uart_irq};

system
i_system (
    // Common
    .sys_clk                    (clk_riscv),
    .sys_rst_n                  (hard_rst_n),
    // AHB I-Mem
    .ahb_imem_sel               (1'b1),
    .ahb_imem_htrans            (ahb_imem_htrans),
    .ahb_imem_hwrite            (1'b0),
    .ahb_imem_hsize             (ahb_imem_hsize),
    .ahb_imem_hready_in         (ahb_imem_hready),
    .ahb_imem_hready_out        (ahb_imem_hready),
    .ahb_imem_hburst            (ahb_imem_hburst),
    .ahb_imem_hprot             (ahb_imem_hprot),
    .ahb_imem_hresp             (ahb_imem_hresp),
    .ahb_imem_haddr             (ahb_imem_haddr),
    .ahb_imem_hwdata            ('0),
    .ahb_imem_hrdata            (ahb_imem_hrdata),
    // AHB D-Mem
    .ahb_dmem_sel               (1'b1),
    .ahb_dmem_htrans            (ahb_dmem_htrans),
    .ahb_dmem_hwrite            (ahb_dmem_hwrite),
    .ahb_dmem_hsize             (ahb_dmem_hsize),
    .ahb_dmem_hready_in         (ahb_dmem_hready),
    .ahb_dmem_hready_out        (ahb_dmem_hready),
    .ahb_dmem_hburst            (ahb_dmem_hburst),
    .ahb_dmem_hprot             (ahb_dmem_hprot),
    .ahb_dmem_hresp             (ahb_dmem_hresp),
    .ahb_dmem_haddr             (ahb_dmem_haddr),
    .ahb_dmem_hwdata            (ahb_dmem_hwdata),
    .ahb_dmem_hrdata            (ahb_dmem_hrdata),
    // UART
    .uart_rxd                   (uart_rxd),
    .uart_txd                   (uart_txd),
    .uart_rtsn                  (uart_rts_n),
    .uart_ctsn                  (uart_rts_n),
    .uart_dtrn                  (uart_dtr_n),
    .uart_dsrn                  (uart_dtr_n),
    .uart_ri                    (1'b1),
    .uart_dcdn                  (uart_dtr_n),
    .uart_baudoutn              (),
    .uart_ddis                  (),
    .uart_out1n                 (),
    .uart_out2n                 (),
    .uart_rxrdyn                (),
    .uart_txrdyn                (),
    .uart_irq                   (uart_irq),
    .pio_led_rgb_tri_o          (pio_led_rgb),
    .pio_led_tri_o              (pio_led),
    .pio_pb_tri_i               (pio_pb),
    .pio_pb_irq                 (pio_pb_irq),
    .sys_id_tri_i               (FPGA_ARTY_SYS_ID),
    .bld_id_tri_i               (FPGA_ARTY_BUILD_ID)
);

always_ff @(posedge clk_riscv, negedge hard_rst_n)
begin
    if (~hard_rst_n) begin
        rtc_counter     <= '0;
        tick_2Hz        <= 1'b0;
    end
    else begin
        if (rtc_counter == '0) begin
            rtc_counter <= (SCR1_CORE_FREQUENCY/2);
            tick_2Hz    <= 1'b1;
        end
        else begin
            rtc_counter <= rtc_counter - 1'b1;
            tick_2Hz    <= 1'b0;
        end
    end
end

always_ff @(posedge clk_riscv, negedge hard_rst_n)
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

//==========================================================
// JTAG
//==========================================================
`ifdef SCR1_DBGC_EN
assign jtag_srst_n      = JD[6];
assign jtag_trst_n      = JD[2];
assign jtag_tck         = JD[3];
assign jtag_tms         = JD[7];
assign jtag_tdi         = JD[5];
assign JD[4]            = (jtag_tdo_en == 1'b1) ? jtag_tdo : 1'bZ;
`else // SCR1_DBGC_EN
assign JD[4]            = 1'bZ;
`endif // SCR1_DBGC_EN

//==========================================================
// UART
//==========================================================
assign uart_rxd         = FTDI_TXD;
//assign uart_rxd         = JD[0]; // JD[0] - PMOD Ext. UART's TxD
assign FTDI_RXD         = uart_txd;
//assign JD[1]            = uart_txd;// JD[1] - PMOD Ext. UART's RxD

//==========================================================
// LEDs
//==========================================================
assign LED[5:4]         = pio_led;
assign LED[6]           = ~hard_rst_n;
assign LED[7]           = heartbeat;
assign LEDR             = {pio_led_rgb[11], pio_led_rgb[8], pio_led_rgb[5], pio_led_rgb[2]};
assign LEDG             = {pio_led_rgb[10], pio_led_rgb[7], pio_led_rgb[4], pio_led_rgb[1]};
assign LEDB             = {pio_led_rgb[ 9], pio_led_rgb[6], pio_led_rgb[3], pio_led_rgb[0]};

//==========================================================
// DIP Switch
//==========================================================
//assign pio_sw               = SW;

//==========================================================
// Buttons
//==========================================================
assign pio_pb           = BTN;

endmodule : arty_scr1_top
