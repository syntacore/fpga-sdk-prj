# SCR1 SDK. Xilinx Vivado Design Suite project for Arty board

## Key features
* Board: Digilent Arty (https://reference.digilentinc.com/reference/programmable-logic/arty/start)
* Tool: Xilinx Vivado Design Suite 2017.3

## Folder contents
Folder | Description
------ | -----------
constrs                | Constraint files
src                    | Project's RTL source files
arty_scr1.tcl          | TCL-file for project creation
mem_update.tcl         | TCL-file for onchip SRAM memory initialization
README.md              | This file
scbl.mem               | The onchip SRAM memory content file with the SCR1 Bootloader
write_mmi.tcl          | TCL-file with procedures for mem_update.tcl

Hereinafter this folder is named <PROJECT_HOME_DIR> (the folder containing this README file).

## Project deployment
1. Install Arty's board files in Vivado directory structure, as described here:
    https://reference.digilentinc.com/reference/software/vivado/board-files


2. Launch Vivado IDE, and in its Tcl Console change current directory to the <PROJECT_HOME_DIR>.

3. In Tcl Console, execute the following command


    source ./arty_scr1.tcl

The script "arty_scr1.tcl" creates Vivado project arty_scr1 and prepares used IPs for further synthesis.

## Synthesizing design and building bitstream file
In the just deployed and open project, click on

* Project Navigator / Program and Debug / Generate Bitstream button

and press OK on the following Vivado confirmation request.
This will start the process of full design rebuilding, from synthesis through bitstream file generation.

## Onchip memory update
Due to Vivado Design Suite specifics described in the Xilinx AR #63042, initialization of the onchip memories
is performed after bitstream file generation, by a standalone script mem_update.tcl.

In the Tcl Console, execute the following commands:

    cd <PROJECT_HOME_DIR>/arty_scr1
    source "../../../scripts/xilinx/mem_update.tcl"

After successful completion, the folder

    <PROJECT_HOME_DIR>/arty_scr1/arty.runs/impl_1

should contain updated bit-file arty_scr1_top_new.bit and MCS-file arty_scr1_top_new.mcs for configuration FLASH chip programming.

## SCR1 Memory Map
Base Address | Length | Name          | Description
------------ | ------ | ------------- | -----------
0x00000000   | 256 MB | SDRAM         | Onboard DDR3L SDRAM.
0xF0000000   | 64  kB | TCM           | SCR1 Tightly-Coupled Memory (refer to SCR1 EAS).
0xF0040000   | 32   B | Timer         | SCR1 Timer registers (refer to SCR1 EAS).
0xFF000000   |        | MMIO BASE     | Base address for Memory-Mapped Peripheral IO resources, resided externally to SCR1 core.
0xFF000000   | 4   kB | SOC_ID        | 32-bit SOC_ID register.
0xFF001000   | 4   kB | BLD_ID        | 32-bit BLD_ID register.
0xFF002000   | 4   kB | CORE_CLK_FREQ | 32-bit Core Clock Frequency register.
0xFF010000   | 4   kB | UART          | 16550 UART registers (refer to Xilinx IP description for details). Interrupt line is assigned to IRQ[0].
0xFF020000   | 4   kB | LED           | LED PIO registers: PIO_LED.
0xFF021000   | 4   kB | LED_RGB       | RGB LED PIO registers: PIO_LED_RGB.
0xFF028000   | 4   kB | BTN           | Push Button PIO register: PIO_PBUTTON. Has associated interrupt line assigned to IRQ[1].
0xFFFF0000   | 64  kB | SRAM          | Onchip SRAM containing pre-programmed SCR Loader firmware. SCR1_RST_VECTOR and SCR1_CSR_MTVEC_BASE are both mapped here.

## MMIO Registers

### PIO_LED, Programmable IO LED Control Register (0xFF020000)
Bit(s) | Name | Description
-------| ---- | -----------
0      | LED0 | LED[0] control: corresponds to the onboard LD4. If a bit is 1, LED is illuminated.
1      | LED1 | LED[1] control (onboard LD5).

### PIO_LED_RGB, Programmable IO LED RGB Control Register (0xFF021000)
Bit(s) | Name | Description
-------| ---- | -----------
0..2   | LED0 | LED[0] control: bits [2:0] correspond to {red, green, blue} partial LEDs of the onboard LD0. If a bit is 1, appropriate internal LED is illuminated.
3..5   | LED1 | LED[1] control (onboard LD1).
6..8   | LED2 | LED[2] control (onboard LD2).
9..11  | LED3 | LED[3] control (onboard LD3).

### PIO_PBUTTON, Programmable IO Push Button Status Register (0xFF028000)
Bit(s) | Name | Description
-------| ---- | -----------
0..3   | BTN  | BTN status: bits [3:0] correspond to {BTN3, BTN2, BTN1, BTN0} onboard push buttons. For details refer to the Xilinx AXI GPIO IP documentation.


## SCR1 JTAG Pin-Out

SCR1 JTAG port is routed to the onboard Pmod connector JD.

Net    | JD bit | Pmod JD pin
-------| ------ | -----------
TRSTn  | 2      | 3
TCK    | 3      | 4
TDO    | 4      | 7
TDI    | 5      | 8
SRSTn  | 6      | 9
TMS    | 7      | 10

