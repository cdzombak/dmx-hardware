# APB3 - CSR Bridge

Verilog bridge between an ARM APB3 master and a CSR bus slave.

## Indirect Addressing

This variant of the bridge uses an "indirect" address scheme where addresses don't map directly from the APB address space to the CSR address space. In an ideal world, we could simply use the lower 14 bits of the APB address as the CSR address, but in some situations (particularly when using the MSS on a Microsemi SmartFusion device) that much address space is not available on the APB.

This bridge has a two-register interface. The registers are mapped into the processor's memory.

* Read/write to address 0 to set or retrieve the (14 bit) CSR target address.
* Read/write to address 4 to perform a (32 bit) read/write on the CSR bus using the address you previously wrote into the bridge.

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
