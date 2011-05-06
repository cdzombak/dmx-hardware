// apb_csr_bridge.v

// This variant of the bridge is untested!
// Please report any issues:
//   https://github.com/cdzombak/misc-hardware/issues

// Bridge between an ARM APB3 master and a CSR slave.
// This version uses 14 bits of address space on the APB bus.
// For complete docs, source, and additional info, see:
//   http://github.com/cdzombak/misc-hardware/apb3_csr_bridge-direct

// Originally developed for a UMich EECS373 project:
//   < link TK >
// By Chris Dzombak
//   http://chris.dzombak.name
//   chris@chrisdzombak.net

module apb_csr_bridge(
  PCLK,
  PADDR,
  PENABLE,
  PSEL,
  PRESERN,
  PWRITE,
  PREADY,
  PSLVERR,
  PWDATA,
  PRDATA,
  CSR_A,
  CSR_WE,
  CSR_DW,
  CSR_DR
  );

input PCLK, PENABLE, PSEL, PRESERN, PWRITE;
input  [31:0] PADDR;
input  [31:0] PWDATA;
input  [31:0] CSR_DR;
output reg [31:0] PRDATA;
output reg [31:0] CSR_DW;
output reg [13:0] CSR_A;
output reg PREADY, CSR_WE;
output PSLVERR;

wire rd_enable;
wire wr_enable;

reg [1:0]  state;

parameter IDLE  = 2'b00;
parameter READ1 = 2'b01;
parameter READ2 = 2'b10;
parameter WRITE = 2'b11;

assign wr_enable = (PENABLE && PWRITE && PSEL);
assign rd_enable = (!PWRITE && PSEL);
assign PSLVERR = 1'b0;

always @(posedge PCLK, negedge PRESERN) begin
	if (!PRESERN) begin
		// reset
		CSR_A <= 32'b0;
		CSR_DW <= 32'b0;
		CSR_WE <= 1'b0;
		PREADY <= 1'b1;
		PRDATA <= 32'b0;
		state <= IDLE;
	end else begin
		case (state)
			IDLE:
				if (wr_enable) begin
					// writing data, so kick off write to CSR.
					CSR_A[31:14] <= 18'b0;
					CSR_A[13:0] <= PADDR[13:0];
					CSR_DW <= PWDATA;
					CSR_WE <= 1'b1;
					PREADY <= 1'b0;
					PRDATA <= 32'b0;
					state <= WRITE;
				end else if (rd_enable) begin
					// reading data, so kick off read from CSR
					CSR_A[31:14] <= 18'b0;
					CSR_A[13:0] <= PADDR[13:0];
					CSR_DW <= 32'b0;
					CSR_WE <= 1'b0;
					PREADY <= 1'b0;
					PRDATA <= 32'b0;
					state <= READ1;
				end else begin
					// just idle
					CSR_A <= 32'b0;
					CSR_DW <= 32'b0;
					CSR_WE <= 1'b0;
					PREADY <= 1'b1;
					PRDATA <= 32'b0;
					state <= IDLE;
				end
			READ1: begin
					// we just wrote address to the CSR bus, so it will have data ready next cycle
					CSR_A[31:14] <= 18'b0;
					CSR_A[13:0] <= PADDR[13:0];
					CSR_DW <= 32'b0;
					CSR_WE <= 1'b0;
					PREADY <= 1'b0;
					PRDATA <= 32'b0;
					state <= READ2;
				end
			READ2: begin
					// yay, CSR has data ready for us now
					PREADY <= 1'b1;
					PRDATA <= CSR_DR;
					CSR_A <= 32'b0;
					CSR_DW <= 32'b0;
					CSR_WE <= 1'b0;
					state <= IDLE;
				end
			WRITE: begin
					// we just wait one cycle to give the CSR write time to complete
					CSR_A[31:14] <= 18'b0;
					CSR_A[13:0] <= PADDR[13:0];
					CSR_DW <= 32'b0;
					CSR_WE <= 1'b0;
					PREADY <= 1'b1;
					PRDATA <= 32'b0;
					state <= IDLE;
				end
			default: begin
					// reset
					CSR_A <= 32'b0;
					CSR_DW <= 32'b0;
					CSR_WE <= 1'b0;
					PREADY <= 1'b1;
					PRDATA <= 32'b0;
					state <= IDLE;
				end
		endcase
	end
end

endmodule
