# DMX Cores Driver

C driver for the Milkymist DMX cores on an [Actel/Microsemi SmartFusion](http://www.actel.com/products/SmartFusion/default.aspx) device. This driver uses an indirectly-addressed APB3/CSR bridge, [for which Verilog HDL source is available in this Git repository](https://github.com/cdzombak/misc-hardware/tree/master/apb3_csr_bridge-indirect). The driver should be easy to port to other devices.

The DMX TX/RX cores are part of the open-source Milkymist SoC.

* [Cores Documentation](http://www.milkymist.org/socdoc/dmx.pdf)
* [Milkymist SoC](http://www.milkymist.org/mmsoc.html)
* [Milkymist on Github](https://github.com/milkymist)

## Use

The driver provides functions to:

* Set the transmitted DMX value (in the TX core) for a given DMX address (`dmx_tx()`)
* Get the most recently received DMX value (in the RX core) for a given DMX address (`dmx_rx()`)
* Get the value the TX core is currently transmitting for a given DMX address (`dmx_get_tx_value()`)

See `dmx.h` for information about each specific function.

This particular driver assumes that each core (transmit/receive) has its own APB/CSR bridge, and that each core is slave address `0` on its own CSR bus. Adapting the driver to a different situation should be trivial.

If the project is compiled with `-DACTEL_STDIO_THRU_UART` (which is how the SmartFusion evaluation board supports `printf` to print to a terminal), the driver includes a function that dumps some useful debug info to the console.

Note that the driver's API assumes that DMX addresses are 1-indexed (1-512). Undefined behavior will result if you pass the DMX address `0` to any of the driver functions. For performance reasons (these functions are likely to be used in loops), the driver does no sanity/error checking on its inputs.

## Feedback

Any feedback is welcomed, particularly bug reports or suggestions for improvement. You can message [me](https://github.com/cdzombak) on Github, email me, [open an issue](https://github.com/cdzombak/misc-hardware/issues), or fork this project and open a pull request.

# Author

This driver was written by [Chris Dzombak](http://chris.dzombak.name). It was originally used in a [UMich EECS373 project](http://chris.dzombak.name/373project).
