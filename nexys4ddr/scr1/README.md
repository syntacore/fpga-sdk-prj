# SCR1 SDK. Xilinx Vivado Design Suite project for Nexys4DDR board

## Key features
* Board: Digilent Nexys4DDR (https://reference.digilentinc.com/reference/programmable-logic/nexys-4-ddr/start)
* Tool: Xilinx Vivado Design Suite 2018.1

## Folder contents
Folder | Description
------ | -----------
bd                    | Block design files
constrs               | Constraint files
src                   | Project's RTL source files
nexys4ddr_scr1.tcl    | TCL-file for project creation
README.md             | This file
scbl.mem              | The onchip SRAM memory content file  with the SCR1 Bootloader.

Hereinafter this folder is named <PROJECT_HOME_DIR> (the folder containing this README file).

## Project deployment
1. Install Nexys4DDR's board files in Vivado directory structure, as described here:
    https://reference.digilentinc.com/reference/software/vivado/board-files


2. Launch Vivado IDE, and in its Tcl Console change current directory to the <PROJECT_HOME_DIR>.

3. In Tcl Console, execute the following command


    source ./nexys4ddr_scr1.tcl

The script "nexys4ddr_scr1.tcl" creates Vivado project nexys4ddr_scr1 and prepares used IPs for further synthesis.

## Synthesizing design and building bitstream file
In the just deployed and open project, click on

* Project Navigator / Program and Debug / Generate Bitstream button

and press OK on the following Vivado confirmation request.
This will start the process of full design rebuilding, from synthesis through bitstream file generation.

## Onchip memory update
Due to Vivado Design Suite specifics described in the Xilinx AR #63042, initialization of the onchip memories
is performed after bitstream file generation, by a standalone script mem_update.tcl.

In the Tcl Console, execute the following commands:

    cd <PROJECT_HOME_DIR>/nexys4ddr_scr1
    source "../mem_update.tcl"

After successful completion, the folder

    <PROJECT_HOME_DIR>/nexys4ddr_scr1/nexys4ddr_scr1.runs/impl_1

should contain updated bit-file nexys4ddr_scr1_top_new.bit and MCS-file nexys4ddr_scr1_top_new.mcs for configuration FLASH chip programming.

## SCR1 Memory Map
Base Address | Length | Name | Description
------------ | ------ | ---- | -----------
0x00000000   | 128 MB | SDRAM | Onboard DDR2 SDRAM.
0xF0000000   | 64  kB | TCM  | SCR1 Tightly-Coupled Memory (refer to SCR1 EAS).
0xF0040000   | 32   B | Timer | SCR1 Timer registers (refer to SCR1 EAS).
0xFF000000   |  | MMIO BASE  | Base address for Memory-Mapped Peripheral IO resources, resided externally to SCR1 core.
0xFF000000   | 4   kB | BLD_ID | 32-bit Build ID register.
0xFF010000   | 4   kB | UART | 16550 UART registers (refer to Xilinx IP description for details). Interrupt line is assigned to IRQ[0].
0xFFFF0000   | 64  kB | SRAM | Onchip SRAM containing pre-programmed SCR Loader firmware. SCR1_RST_VECTOR and SCR1_CSR_MTVEC_BASE are both mapped here.

## SCR1 JTAG Pin-Out

SCR1 JTAG port is routed to the onboard Pmod connector JC. The pin-out is suitable for direct
connecting of the Digilent-HS2 USB JTAG adapter.

Net    | Pmod JC pin
-------| -----------
TMS    | 1
TDI    | 2
TDO    | 3
TCK    | 4
GND    | 5
3V3    | 6


