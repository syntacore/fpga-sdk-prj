/// @file       <a5_sdk.sv>
/// @brief      SC_RISCV_SDK @Arria V Starter kit
/// @authors    an-sc
///

`include "scr1_arch_types.svh"
`include "scr1_arch_description.svh"
`include "scr1_memif.svh"
`include "scr1_ipic.svh"



parameter bit [31:0] FPGA_A5_BUILD_ID = `SCR1_ARCH_BUILD_ID;



module a5_sdk (

    input                   cpu_resetn,
    input                   clkin_50,
    input                   clkin_100,

    //DDR3 x32 Devices Interface
    output                  ddr3_ck_p,
    output                  ddr3_ck_n,
    inout           [31:0]  ddr3_dq,
    inout            [3:0]  ddr3_dqs_p,
    inout            [3:0]  ddr3_dqs_n,
    output           [3:0]  ddr3_dm,
    output          [12:0]  ddr3_a,
    output           [2:0]  ddr3_ba,
    output                  ddr3_casn,
    output                  ddr3_rasn,
    output                  ddr3_cke,
    output                  ddr3_csn,
    output                  ddr3_odt,
    output                  ddr3_wen,
    output                  ddr3_rstn,
    input                   ddr3_oct_rzq,

    input                   uart0_rxd,
    output                  uart0_txd,

    input                   jtag_trst_n,
    input                   jtag_tck,
    input                   jtag_tms,
    input                   jtag_tdi,
    inout                   jtag_tdo,
    output           [1:0]  jtag_vcc,
    output           [7:0]  jtag_gnd,

    output           [3:0]  user_led
);



//=======================================================
//  Signals / Variables declarations
//=======================================================
logic                   pll_locked;
logic                   clk_riscv;
logic                   pwron_rst_in_n;
logic                   pwron_rst_in_ff1;
logic                   pwron_rst_in_ff2;
logic                   pwron_rst_n;
logic                   ddr3_init_done;
logic                   ddr3_cal_success;
logic                   ddr3_cal_fail;

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

logic [31:0]            riscv_irq;



logic                   riscv_jtag_trst_n;
logic                   riscv_jtag_tck;
logic                   riscv_jtag_tms;
logic                   riscv_jtag_tdi;
logic                   riscv_jtag_tdo_en_cpu0;
logic                   riscv_jtag_tdo_int_cpu0;








assign pwron_rst_in_n   =  pll_locked;

pll
i_pll (
    .rst        (~cpu_resetn    ),
    .refclk     (clkin_50       ),
    .outclk_0   (clk_riscv      ),
    .locked     (pll_locked     )
);

always_ff @(posedge clk_riscv, negedge pwron_rst_in_n)
begin
    if (pwron_rst_in_n == 1'b0) begin
        pwron_rst_in_ff1 <= 1'b0;
        pwron_rst_in_ff2 <= 1'b0;
    end
    else begin
        pwron_rst_in_ff1 <= pwron_rst_in_n;
        pwron_rst_in_ff2 <= pwron_rst_in_ff1;
    end
end
assign pwron_rst_n = pwron_rst_in_ff2;



logic riscv0_irq;
assign riscv_irq = {31'd0, riscv0_irq};




scr1_top_axi i_scr_top(

    // Common
    .rst_n                              (pwron_rst_n            ),
    .test_mode                          (1'd0                   ),
    .clk                                (clk_riscv              ),
    .rtc_clk                            (1'b0                   ),
    .rst_n_out                          (                       ),
    .fuse_mhartid                       (32'd0                  ),
    .irq_lines                          (riscv_irq              ),
    .soft_irq                           ('0                     ),
    // Debug Interface
    .trst_n                             (riscv_jtag_trst_n      ),
    .tck                                (riscv_jtag_tck         ),
    .tms                                (riscv_jtag_tms         ),
    .tdi                                (riscv_jtag_tdi         ),
    .tdo                                (riscv_jtag_tdo_int_cpu0),
    .tdo_en                             (riscv_jtag_tdo_en_cpu0 ),

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






//
// UART 16550 IP
//

logic [31:0]    uart_readdata;
logic           uart_readdatavalid;
logic [31:0]    uart_writedata;
logic  [4:0]    uart_address;
logic           uart_write;
logic           uart_read;
logic           uart_waitrequest;

logic           wb_ack;
logic  [7:0]    wb_dat;
logic           read_valid;



always_ff @(posedge clk_riscv, negedge pwron_rst_in_n)
if (~pwron_rst_in_n)        read_valid <= '0;
    else if (wb_ack)        read_valid <= '0;
    else if (uart_read)     read_valid <= '1;


always_ff @(posedge clk_riscv) begin
    uart_readdatavalid  <= wb_ack & read_valid;
    uart_readdata       <= {24'd0,wb_dat};
end


assign uart_waitrequest = ~wb_ack;


uart_top i_uart(
    .wb_clk_i       (clk_riscv              ),
    // Wishbone signals
    .wb_rst_i       (~pwron_rst_n           ),
    .wb_adr_i       (uart_address[4:2]      ),
    .wb_dat_i       (uart_writedata[7:0]    ),
    .wb_dat_o       (wb_dat                 ),
    .wb_we_i        (uart_write             ),
    .wb_stb_i       (read_valid|uart_write  ),
    .wb_cyc_i       (read_valid|uart_write  ),
    .wb_ack_o       (wb_ack                 ),
    .wb_sel_i       (4'd1                   ),
    .int_o          (riscv0_irq             ),

    .stx_pad_o      (uart0_txd              ),
    .srx_pad_i      (uart0_rxd              ),

    .rts_pad_o      (                       ),
    .cts_pad_i      ('1                     ),
    .dtr_pad_o      (                       ),
    .dsr_pad_i      ('1                     ),
    .ri_pad_i       ('1                     ),
    .dcd_pad_i      ('1                     )
    );






a5_sopc
i_a5_sopc (
    .clk_emi_clk                        (clkin_100          ),
    .clk_clk                            (clk_riscv          ),
    .clk_rst_reset_n                    (pwron_rst_n        ),
    //
    .ddr3_mem_a                         (ddr3_a             ),
    .ddr3_mem_ba                        (ddr3_ba            ),
    .ddr3_mem_ck                        (ddr3_ck_p          ),
    .ddr3_mem_ck_n                      (ddr3_ck_n          ),
    .ddr3_mem_cke                       (ddr3_cke           ),
    .ddr3_mem_cs_n                      (ddr3_csn           ),
    .ddr3_mem_dm                        (ddr3_dm            ),
    .ddr3_mem_ras_n                     (ddr3_rasn          ),
    .ddr3_mem_cas_n                     (ddr3_casn          ),
    .ddr3_mem_we_n                      (ddr3_wen           ),
    .ddr3_mem_reset_n                   (ddr3_rstn          ),
    .ddr3_mem_dq                        (ddr3_dq            ),
    .ddr3_mem_dqs                       (ddr3_dqs_p         ),
    .ddr3_mem_dqs_n                     (ddr3_dqs_n         ),
    .ddr3_mem_odt                       (ddr3_odt           ),
    .ddr3_oct_rzqin                     (ddr3_oct_rzq       ),
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


    .bld_id_export                      (FPGA_A5_BUILD_ID   )
);


assign riscv_jtag_trst_n    = jtag_trst_n;
assign riscv_jtag_tck       = jtag_tck;
assign riscv_jtag_tms       = jtag_tms;
assign riscv_jtag_tdi       = jtag_tdi;
assign jtag_tdo             = (riscv_jtag_tdo_en_cpu0) ? riscv_jtag_tdo_int_cpu0 : 1'bZ;







assign user_led[3]   = ~ddr3_cal_success;
assign user_led[2]   = ~ddr3_init_done;
assign user_led[1]   = ~ddr3_cal_fail;
assign user_led[0]   = '1;

assign jtag_vcc      = '1;
assign jtag_gnd      = '0;

endmodule
