# APB3 - CSR Bridge

Verilog bridge between an ARM APB3 master and a CSR bus slave.

This variant of the bridge uses 14 bits of address space on the APB bus. The lower 14 bits of the APB address are used to address the CSR bus.

*This variant of the bridge is untested.* Please [report any issues with this code](https://github.com/cdzombak/misc-hardware/issues).

## Background Information

ARM APB3 is used to interface to peripherals that are low bandwidth and don't require the high performance of a pipelined bus interface.

* [APB3 Documentation from ARM](http://infocenter.arm.com/help/index.jsp?topic=/com.arm.doc.ihi0024b/index.html) (requires registration)
* [Microsemi AMBA Interfacing Guide](http://www.actel.com/documents/SmartFusion_Build_APB3core_AN.pdf) (has an overview of APB3 interfacing and doesn't require registration)

The CSR bus is part of the open-source Milkymist SoC.

* [Documentation](http://www.milkymist.org/socdoc/csr.pdf)
* [Milkymist SoC](http://www.milkymist.org/mmsoc.html)
* [Milkymist on Github](https://github.com/milkymist)

## Feedback

Any feedback is welcomed, particularly bug reports or suggestions for improvement. You can message [me](https://github.com/cdzombak) on Github, email me, [open an issue](https://github.com/cdzombak/misc-hardware/issues), or fork this project and open a pull request.

# Author

This module was written by [Chris Dzombak](http://chris.dzombak.name).

It was originally used in a [UMich EECS373 project](http://chris.dzombak.name/373project) to interface with the DMX cores from the Milkymist project.
