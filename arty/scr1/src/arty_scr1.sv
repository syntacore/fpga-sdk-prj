/// Copyright by Syntacore LLC ?? 2016, 2017, 2021. See LICENSE for details
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
//
//User-defined board-specific parameters accessible as memory-mapped GPIO
parameter bit [31:0] FPGA_ARTY_SOC_ID           = `SCR1_PTFM_SOC_ID;
parameter bit [31:0] FPGA_ARTY_BLD_ID           = `SCR1_PTFM_BLD_ID;
parameter bit [31:0] FPGA_ARTY_CORE_CLK_FREQ    = `SCR1_PTFM_CORE_CLK_FREQ;

module arty_scr1 (
    // === CLOCK ===========================================
    input  logic                    OSC_100,
    // === RESET ===========================================
    input  logic                    RESETn,
    // === DDR3 SDRAM ======================================
    output logic                    DDR3_CK_N,
    output logic                    DDR3_CK_P,
    output logic                    DDR3_CKE,
    output logic                    DDR3_RESET_N,
    output logic                    DDR3_CS_N,
    output logic                    DDR3_WE_N,
    output logic                    DDR3_RAS_N,
    output logic                    DDR3_CAS_N,
    output logic [2:0]              DDR3_BA,
    output logic [13:0]             DDR3_ADDR,
    output logic [1:0]              DDR3_DM,
    inout  logic [15:0]             DDR3_DQ,
    inout  logic [1:0]              DDR3_DQS_P,
    inout  logic [1:0]              DDR3_DQS_N,
    output logic                    DDR3_ODT,
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

//=======================================================
//  Signals / Variables declarations
//=======================================================
logic                               pwrup_rst_n;
logic                               cpu_clk;
logic                               extn_rst_in_n;
logic                               extn_rst_n;
logic [1:0]                         extn_rst_n_sync;
logic                               hard_rst_n;
logic [3:0]                         hard_rst_n_count;
logic                               soc_rst_n;
logic                               cpu_reset;
`ifdef SCR1_DBG_EN
logic                               sys_rst_n;
`endif // SCR1_DBG_EN

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
`ifdef SCR1_IPIC_EN
logic [SCR1_IRQ_LINES_NUM-1:0]      scr1_irq;
`else
logic                               scr1_irq;
`endif // SCR1_IPIC_EN
// --- JTAG ---
`ifdef SCR1_DBG_EN
logic                               jtag_srst_n;
logic                               jtag_trst_n;
logic                               jtag_tck;
logic                               jtag_tms;
logic                               jtag_tdi;
logic                               jtag_tdo;
logic                               jtag_tdo_en;
`endif // SCR1_DBG_EN

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

//=======================================================
//  Resets
//=======================================================
assign extn_rst_in_n    = RESETn
`ifdef SCR1_DBG_EN
                        & jtag_srst_n
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
                    hard_rst_n_count    <= hard_rst_n_count + 1;
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
            rtc_counter <= (FPGA_ARTY_CORE_CLK_FREQ/2);
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
scr1_top_ahb
i_scr1 (
    // Common
    .pwrup_rst_n                (pwrup_rst_n),
    .rst_n                      (hard_rst_n),
    .cpu_rst_n                  (~cpu_reset),
    .test_mode                  (1'b0),
    .test_rst_n                 (1'b1),
    .clk                        (cpu_clk),
    .rtc_clk                    (1'b0),
`ifdef SCR1_DBG_EN
    .sys_rst_n_o                (sys_rst_n),
    .sys_rdc_qlfy_o             (),
`endif // SCR1_DBG_EN

    // Fuses
    .fuse_mhartid               ('0),
`ifdef SCR1_DBG_EN
    .fuse_idcode                (`SCR1_TAP_IDCODE),
`endif // SCR1_DBG_EN

    // IRQ
`ifdef SCR1_IPIC_EN
    .irq_lines                  (scr1_irq),
`else
    .ext_irq                    (scr1_irq),
`endif // SCR1_IPIC_EN
    .soft_irq                   (1'b0),

`ifdef SCR1_DBG_EN
    // Debug Interface - JTAG I/F
    .trst_n                     (jtag_trst_n),
    .tck                        (jtag_tck),
    .tms                        (jtag_tms),
    .tdi                        (jtag_tdi),
    .tdo                        (jtag_tdo),
    .tdo_en                     (jtag_tdo_en),
`endif // SCR1_DBG_EN

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

//=======================================================
//  FPGA Platform's System-on-Programmable-Chip (SOPC)
//=======================================================
arty_sopc
i_soc (
    // Common
    .pwrup_rst_n_o              (pwrup_rst_n),
    .soc_rst_n                  (soc_rst_n),
    .cpu_reset_o                (cpu_reset),
    .osc_clk                    (OSC_100),
    .cpu_clk_o                  (cpu_clk),

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
    //// DDR3 SDRAM
    .ddr3_ck_p                  (DDR3_CK_P),
    .ddr3_ck_n                  (DDR3_CK_N),
    .ddr3_cke                   (DDR3_CKE),
    .ddr3_reset_n               (DDR3_RESET_N),
    .ddr3_cs_n                  (DDR3_CS_N),
    .ddr3_we_n                  (DDR3_WE_N),
    .ddr3_ras_n                 (DDR3_RAS_N),
    .ddr3_cas_n                 (DDR3_CAS_N),
    .ddr3_ba                    (DDR3_BA),
    .ddr3_addr                  (DDR3_ADDR),
    .ddr3_dm                    (DDR3_DM),
    .ddr3_dq                    (DDR3_DQ),
    .ddr3_dqs_p                 (DDR3_DQS_P),
    .ddr3_dqs_n                 (DDR3_DQS_N),
    .ddr3_odt                   (DDR3_ODT),
    //// DDR3 SDRAM initialization/calibration complete
    .ddr3_init_complete         (),
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
    .soc_id_tri_i               (FPGA_ARTY_SOC_ID),
    .bld_id_tri_i               (FPGA_ARTY_BLD_ID),
    .core_clk_freq_tri_i        (FPGA_ARTY_CORE_CLK_FREQ)
);

//==========================================================
// JTAG
//==========================================================
`ifdef SCR1_DBG_EN
// JTAG pin-out PMOD-JTAG-SYNTACORE-1
assign jtag_srst_n      = JD[6];    // PMOD JD.pin9
assign jtag_trst_n      = JD[2];    // PMOD JD.pin3
assign jtag_tck         = JD[3];    // PMOD JD.pin4
assign jtag_tms         = JD[7];    // PMOD JD.pin10
assign jtag_tdi         = JD[5];    // PMOD JD.pin8
assign JD[4]            = (jtag_tdo_en == 1'b1) ? jtag_tdo : 1'bZ; // PMOD JD.pin7
`else // SCR1_DBG_EN
assign JD               = 'Z;
`endif // SCR1_DBG_EN

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

endmodule : arty_scr1
