#ifndef DMX_H_
#define DMX_H_

#include "CMSIS/a2fxxxm3.h"
#include <inttypes.h>

// Driver for DMX transmitter and receiver through APB-CSR bridge
// by Chris Dzombak < http://chris.dzombak.name >

// Assumes that each core (TX/RX) has its own bus bridge.
// Assumes DMX devices are slave ID 0 on CSR buses.
// Note: DMX addresses are 1-indexed (1-512).

// For complete documentation or to report issues:
// < https://github.com/cdzombak/misc-hardware/dmx_driver >

typedef struct
{
    __IO uint32_t address;
    __IO uint32_t value;
} bridge_t;

#define DMX_TX_BASE 0x40050100
#define DMX_RX_BASE 0x40050200

#define DMX_TX_BRIDGE ((bridge_t *) DMX_TX_BASE)
#define DMX_RX_BRIDGE ((bridge_t *) DMX_RX_BASE)

// Sets the transmitted value (0-255) for the given DMX address
void dmx_tx(uint16_t dmx_addr, uint8_t dmx_value);

// Gets the most recently received value for the given DMX address
uint8_t dmx_rx(uint16_t dmx_addr);

// Gets the value the TX core is currently transmitting for the given DMX address
uint8_t dmx_get_tx_value(uint16_t dmx_addr);

#ifdef ACTEL_STDIO_THRU_UART
void print_dmx_info();
#endif

#endif // DMX_H_
