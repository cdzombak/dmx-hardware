#include "dmx.h"

// See dmx.h for documentation on this library

#ifdef ACTEL_STDIO_THRU_UART
void print_dmx_info() {
	printf("TX: address: %x ; value: %x\r\n", (unsigned int) &DMX_TX_BRIDGE->address, (unsigned int) &DMX_TX_BRIDGE->value);
	printf("RX: address: %x ; value: %x\r\n", (unsigned int) &DMX_RX_BRIDGE->address, (unsigned int) &DMX_RX_BRIDGE->value);
}
#endif

void dmx_tx(uint16_t dmx_addr, uint8_t dmx_value) {
	DMX_TX_BRIDGE->address = (dmx_addr-1);
	DMX_TX_BRIDGE->value = (uint32_t) dmx_value;
}

uint8_t dmx_get_tx_value(uint16_t dmx_addr) {
	DMX_TX_BRIDGE->address = (dmx_addr-1);
	return (uint8_t) DMX_TX_BRIDGE->value;
}

uint8_t dmx_rx(uint16_t dmx_addr) {
	DMX_RX_BRIDGE->address = (dmx_addr-1);
	return (uint8_t) DMX_RX_BRIDGE->value;
}
