/// @file       <de10lite.sv>
/// @brief      Top-level entity with SCR1 for DE10-lite board
/// @authors    an-sc
///
/// Copyright by Syntacore LLC © 2016. ALL RIGHTS RESERVED. STRICTLY CONFIDENTIAL.
/// Information contained in this material is confidential and proprietary to Syntacore LLC
/// and its affiliates and may not be modified, copied, published, disclosed, distributed,
/// displayed or exhibited, in either electronic or printed formats without written
/// authorization of the Syntacore LLC. Subject to License Agreement.
///

`include "scr1_arch_types.svh"
`include "scr1_arch_description.svh"
`include "scr1_memif.svh"
`include "scr1_ipic.svh"

parameter bit [31:0] FPGA_DE10_BUILD_ID = `SCR1_ARCH_BUILD_ID;

module de10lite (

    input                           MAX10_CLK2_50,

    output               [12:0]     DRAM_ADDR,
    output                [1:0]     DRAM_BA,
    output                          DRAM_CAS_N,
    output                          DRAM_CKE,
    output                          DRAM_CLK,
    output                          DRAM_CS_N,
    inout                [15:0]     DRAM_DQ,
    output                          DRAM_LDQM,
    output                          DRAM_RAS_N,
    output                          DRAM_UDQM,
    output                          DRAM_WE_N,

    output                          UART_RXD,   // -> UART
    input                           UART_TXD,   // <- UART
    `ifdef SCR1_DBGC_EN
    input                           JTAG_TRST_N,
    input                           JTAG_TCK,
    input                           JTAG_TMS,
    input                           JTAG_TDI,
    output                          JTAG_TDO,

    `endif//SCR1_DBGC_EN

    output                [7:0]     HEX0,
    output                [7:0]     HEX1,
    output                [7:0]     HEX2,
    output                [7:0]     HEX3,
    output                [7:0]     HEX4,
    output                [7:0]     HEX5,
    input                 [0:0]     KEY,
    output                [9:0]     LEDR,
    input                 [9:0]     SW
);




//=======================================================
//  Signals / Variables declarations
//=======================================================
logic                               pll_locked;
logic                               clk_riscv;
logic                               clk_sdram;
logic                               rst_in;
logic [2:1]                         rst_in_d;
logic                               rst_n;


// --- SCR1 ---------------------------------------------
logic [3:0]                         ahb_imem_hprot;
logic [2:0]                         ahb_imem_hburst;
logic [2:0]                         ahb_imem_hsize;
logic [1:0]                         ahb_imem_htrans;
logic [SCR1_AHB_WIDTH-1:0]          ahb_imem_haddr;
logic                               ahb_imem_hready;
logic [SCR1_AHB_WIDTH-1:0]          ahb_imem_hrdata;
logic                               ahb_imem_hresp;
//
logic [3:0]                         ahb_dmem_hprot;
logic [2:0]                         ahb_dmem_hburst;
logic [2:0]                         ahb_dmem_hsize;
logic [1:0]                         ahb_dmem_htrans;
logic [SCR1_AHB_WIDTH-1:0]          ahb_dmem_haddr;
logic                               ahb_dmem_hwrite;
logic [SCR1_AHB_WIDTH-1:0]          ahb_dmem_hwdata;
logic                               ahb_dmem_hready;
logic [SCR1_AHB_WIDTH-1:0]          ahb_dmem_hrdata;
logic                               ahb_dmem_hresp;
//
logic                               riscv0_irq;
`ifdef SCR1_DBGC_EN
logic                               riscv_jtag_tdo;
logic                               riscv_jtag_tdo_en;
`endif//SCR1_DBGC_EN

// --- AHB-Avalon Bus -----------------------------------
logic                               avl_imem_write;
logic                               avl_imem_read;
logic                               avl_imem_waitrequest;
logic [SCR1_AHB_WIDTH-1:0]          avl_imem_address;
logic [3:0]                         avl_imem_byteenable;
logic [SCR1_AHB_WIDTH-1:0]          avl_imem_writedata;
logic                               avl_imem_readdatavalid;
logic [SCR1_AHB_WIDTH-1:0]          avl_imem_readdata;
logic [1:0]                         avl_imem_response;
//
logic                               avl_dmem_write;
logic                               avl_dmem_read;
logic                               avl_dmem_waitrequest;
logic [SCR1_AHB_WIDTH-1:0]          avl_dmem_address;
logic [3:0]                         avl_dmem_byteenable;
logic [SCR1_AHB_WIDTH-1:0]          avl_dmem_writedata;
logic                               avl_dmem_readdatavalid;
logic [SCR1_AHB_WIDTH-1:0]          avl_dmem_readdata;
logic [1:0]                         avl_dmem_response;






assign rst_in = KEY[0] & pll_locked;


pll i_pll (
    .inclk0         (MAX10_CLK2_50  ),
    .c0             (clk_riscv      ),
    .c1             (clk_sdram      ),
    .c2             (DRAM_CLK       ),
    .locked         (pll_locked     )
);




always_ff @(posedge clk_riscv, negedge rst_in)
begin
    if (~rst_in)    rst_in_d <= '0;
    else            rst_in_d <= {rst_in_d[1], rst_in};

end

assign rst_n = rst_in_d[2];







scr1_top_ahb i_scr1 (
        // Common
        .rst_n                      (rst_n                  ),
        .rst_n_out                  (                       ),
        .test_mode                  ('0                     ),
        .clk                        (clk_riscv              ),
        .rtc_clk                    (1'b0                   ),
        .fuse_mhartid               ('0                     ),

        // IRQ
        `ifdef SCR1_IPIC_EN
        .irq_lines                  ({'0,riscv0_irq}        ),
        `else
        .ext_irq                    (riscv0_irq             ),
        `endif//SCR1_IPIC_EN
        .soft_irq                   ('0                     ),

        `ifdef SCR1_DBGC_EN
        // Debug Interface - JTAG I/F
        .trst_n                     (JTAG_TRST_N            ),
        .tck                        (JTAG_TCK               ),
        .tms                        (JTAG_TMS               ),
        .tdi                        (JTAG_TDI               ),
        .tdo                        (riscv_jtag_tdo         ),
        .tdo_en                     (riscv_jtag_tdo_en      ),
        `endif//SCR1_DBGC_EN

        // Instruction Memory Interface
        .imem_hprot                 (ahb_imem_hprot         ),
        .imem_hburst                (ahb_imem_hburst        ),
        .imem_hsize                 (ahb_imem_hsize         ),
        .imem_htrans                (ahb_imem_htrans        ),
        .imem_hmastlock             (                       ),
        .imem_haddr                 (ahb_imem_haddr         ),
        .imem_hready                (ahb_imem_hready        ),
        .imem_hrdata                (ahb_imem_hrdata        ),
        .imem_hresp                 (ahb_imem_hresp         ),
        // Data Memory Interface
        .dmem_hprot                 (ahb_dmem_hprot         ),
        .dmem_hburst                (ahb_dmem_hburst        ),
        .dmem_hsize                 (ahb_dmem_hsize         ),
        .dmem_htrans                (ahb_dmem_htrans        ),
        .dmem_hmastlock             (                       ),
        .dmem_haddr                 (ahb_dmem_haddr         ),
        .dmem_hwrite                (ahb_dmem_hwrite        ),
        .dmem_hwdata                (ahb_dmem_hwdata        ),
        .dmem_hready                (ahb_dmem_hready        ),
        .dmem_hrdata                (ahb_dmem_hrdata        ),
        .dmem_hresp                 (ahb_dmem_hresp         )
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



always_ff @(posedge clk_riscv, negedge rst_n)
if (~rst_n)                 read_valid <= '0;
    else if (wb_ack)        read_valid <= '0;
    else if (uart_read)     read_valid <= '1;


always_ff @(posedge clk_riscv) begin
    uart_readdatavalid  <= wb_ack & read_valid;
    uart_readdata       <= {24'd0,wb_dat};
end


assign uart_waitrequest = ~wb_ack;


uart_top i_uart(
        .wb_clk_i                   (clk_riscv              ),
        // Wishbone signals
        .wb_rst_i                   (~rst_n                 ),
        .wb_adr_i                   (uart_address[4:2]      ),
        .wb_dat_i                   (uart_writedata[7:0]    ),
        .wb_dat_o                   (wb_dat                 ),
        .wb_we_i                    (uart_write             ),
        .wb_stb_i                   (read_valid|uart_write  ),
        .wb_cyc_i                   (read_valid|uart_write  ),
        .wb_ack_o                   (wb_ack                 ),
        .wb_sel_i                   (4'd1                   ),
        .int_o                      (riscv0_irq             ),

        .stx_pad_o                  (UART_RXD               ),
        .srx_pad_i                  (UART_TXD               ),

        .rts_pad_o                  (                       ),
        .cts_pad_i                  ('1                     ),
        .dtr_pad_o                  (                       ),
        .dsr_pad_i                  ('1                     ),
        .ri_pad_i                   ('1                     ),
        .dcd_pad_i                  ('1                     )
        );


//
// AHB IMEM Bridge
//

ahb_avalon_bridge i_ahb_imem (
        // avalon master side
        .clk                        (clk_riscv              ),
        .reset_n                    (rst_n                  ),
        .write                      (avl_imem_write         ),
        .read                       (avl_imem_read          ),
        .waitrequest                (avl_imem_waitrequest   ),
        .address                    (avl_imem_address       ),
        .byteenable                 (avl_imem_byteenable    ),
        .writedata                  (avl_imem_writedata     ),
        .readdatavalid              (avl_imem_readdatavalid ),
        .readdata                   (avl_imem_readdata      ),
        .response                   (avl_imem_response      ),
        // ahb slave side
        .HRDATA                     (ahb_imem_hrdata        ),
        .HRESP                      (ahb_imem_hresp         ),
        .HSIZE                      (ahb_imem_hsize         ),
        .HTRANS                     (ahb_imem_htrans        ),
        .HPROT                      (ahb_imem_hprot         ),
        .HADDR                      (ahb_imem_haddr         ),
        .HWDATA                     ('0                     ),
        .HWRITE                     ('0                     ),
        .HREADY                     (ahb_imem_hready        )
);

//
// AHB DMEM Bridge
//

ahb_avalon_bridge i_ahb_dmem (
        // avalon master side
        .clk                        (clk_riscv              ),
        .reset_n                    (rst_n                  ),
        .write                      (avl_dmem_write         ),
        .read                       (avl_dmem_read          ),
        .waitrequest                (avl_dmem_waitrequest   ),
        .address                    (avl_dmem_address       ),
        .byteenable                 (avl_dmem_byteenable    ),
        .writedata                  (avl_dmem_writedata     ),
        .readdatavalid              (avl_dmem_readdatavalid ),
        .readdata                   (avl_dmem_readdata      ),
        .response                   (avl_dmem_response      ),
        // ahb slave side
        .HRDATA                     (ahb_dmem_hrdata        ),
        .HRESP                      (ahb_dmem_hresp         ),
        .HSIZE                      (ahb_dmem_hsize         ),
        .HTRANS                     (ahb_dmem_htrans        ),
        .HPROT                      (ahb_dmem_hprot         ),
        .HADDR                      (ahb_dmem_haddr         ),
        .HWDATA                     (ahb_dmem_hwdata        ),
        .HWRITE                     (ahb_dmem_hwrite        ),
        .HREADY                     (ahb_dmem_hready        )
);



de10lite_qsys i_de10lite_qsys (
        .clk_clk                    (clk_riscv              ),
        .clk_sdram_clk              (clk_sdram              ),
        .reset_reset_n              (rst_n                  ),


        .pio_hex_1_0_export         ({HEX1,HEX0}            ),
        .pio_hex_3_2_export         ({HEX3,HEX2}            ),
        .pio_hex_5_4_export         ({HEX5,HEX4}            ),
        .pio_led_export             (LEDR                   ),
        .pio_sw_export              (SW                     ),
        .bld_id_export              (FPGA_DE10_BUILD_ID     ),

        .uart_waitrequest           (uart_waitrequest       ),
        .uart_readdata              (uart_readdata          ),
        .uart_readdatavalid         (uart_readdatavalid     ),
        .uart_burstcount            (                       ),
        .uart_writedata             (uart_writedata         ),
        .uart_address               (uart_address           ),
        .uart_write                 (uart_write             ),
        .uart_read                  (uart_read              ),
        .uart_byteenable            (                       ),
        .uart_debugaccess           (                       ),

        .sdram_addr                 (DRAM_ADDR              ),
        .sdram_ba                   (DRAM_BA                ),
        .sdram_cas_n                (DRAM_CAS_N             ),
        .sdram_cke                  (DRAM_CKE               ),
        .sdram_cs_n                 (DRAM_CS_N              ),
        .sdram_dq                   (DRAM_DQ                ),
        .sdram_dqm                  ({DRAM_UDQM,DRAM_LDQM}  ),
        .sdram_ras_n                (DRAM_RAS_N             ),
        .sdram_we_n                 (DRAM_WE_N              ),

        .avl_imem_write             (avl_imem_write         ),
        .avl_imem_read              (avl_imem_read          ),
        .avl_imem_waitrequest       (avl_imem_waitrequest   ),
        .avl_imem_debugaccess       (1'd0                   ),
        .avl_imem_address           (avl_imem_address       ),
        .avl_imem_burstcount        (1'd1                   ),
        .avl_imem_byteenable        (avl_imem_byteenable    ),
        .avl_imem_writedata         (avl_imem_writedata     ),
        .avl_imem_readdatavalid     (avl_imem_readdatavalid ),
        .avl_imem_readdata          (avl_imem_readdata      ),
        .avl_imem_response          (avl_imem_response      ),

        .avl_dmem_write             (avl_dmem_write         ),
        .avl_dmem_read              (avl_dmem_read          ),
        .avl_dmem_waitrequest       (avl_dmem_waitrequest   ),
        .avl_dmem_debugaccess       (1'd0                   ),
        .avl_dmem_address           (avl_dmem_address       ),
        .avl_dmem_burstcount        (1'd1                   ),
        .avl_dmem_byteenable        (avl_dmem_byteenable    ),
        .avl_dmem_writedata         (avl_dmem_writedata     ),
        .avl_dmem_readdatavalid     (avl_dmem_readdatavalid ),
        .avl_dmem_readdata          (avl_dmem_readdata      ),
        .avl_dmem_response          (avl_dmem_response      )
);









`ifdef SCR1_DBGC_EN
    assign JTAG_TDO  = (riscv_jtag_tdo_en)? riscv_jtag_tdo : 1'bz;
`else//SCR1_DBGC_EN
    assign JTAG_TDO  = 1'bZ;
`endif//SCR1_DBGC_EN







endmodule: de10lite
