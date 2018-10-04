# ULX3S JTAG pass-thru

Pass onboard FT231X signals to external GPIO header
so [ULX3S](https://github.com/emard/ulx3s) can 
be used as USB-JTAG programmer for other boards.

Pinout:

    GN15:TCK    GP15:TDI
    GN14:TDO    GP14:TMS

This pinout is arranged similar to the JTAG header
on [ULX3S](https://github.com/emard/ulx3s) for easier cabling.

# Compiling

FPGA bitstream will compile 
with [prjtrellis](https://github.com/SymbiFlow/prjtrellis)-[nextpnr](https://github.com/YosysHQ/nextpnr)-[yosys](https://github.com/YosysHQ/yosys) tools.
Compile tools in any directory (without make install),
edit makefile here to set directory paths of the tools,
finally compile JTAG pass-thru:

    make clean
    make

# Programming

First board can be programmed using either FleaFPGA-JTAG:

    make program

or using [my OpenOCD fork](https://github.com/emard/openocd) with 
mainstream [OpenOCD](https://sourceforge.net/projects/openocd/files/openocd/) and
my ["ft232r: unhardcoded" patch](http://openocd.zylin.com/#/c/4681/):

    make program_ft231x

To program second board, connect JTAG header and proprely
power second board ([ULX3S](https://github.com/emard/ulx3s) should be powered at US1
connector, not at 3.3V pin JTAG header).

Multiple FT231X connected to same computer can be
distinguished by serial numbers specified in files:

    ft231x.ocd   program first board with onboard usb-jtag
    ft231x2.ocd  program second board with jtag-thru

In those files the serial number can be specified with line:

    ft232r_serial_desc 250001

Custom serial number can be set from linux commandline
with [ftx_prog](https://github.com/richardeoin/ftx-prog):

    ftx_prog --new-serial-number 250001

To program other board thru first board using jtag-thru:

    make program_ft231x2
