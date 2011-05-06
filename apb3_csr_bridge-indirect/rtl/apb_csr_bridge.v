// apb_csr_bridge.v

// Bridge between an ARM APB3 master and a CSR slave.
// Uses an indirect addressing scheme.
// For complete docs, source, and additional info, see:
//   http://github.com/cdzombak/misc-hardware/apb3_csr_bridge-indirect

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

reg [13:0] addr;
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
		addr <= 13'b0;
		state <= IDLE;
		PRDATA <= 32'b0;
		CSR_DW <= 32'b0;
		CSR_A <= 32'b0;
		PREADY <= 1'b1;
		CSR_WE <= 1'b0;
	end else begin
		case (state)
			IDLE:
				if (wr_enable) begin
					case (PADDR[2])
						1'b0: begin
								// writing address. save address for future use, and we're ready to go.
								addr <= PWDATA[13:0];
								state <= IDLE;
								PRDATA <= 32'b0;
								CSR_DW <= 32'b0;
								CSR_A <= 32'b0;
								PREADY <= 1'b1;
								CSR_WE <= 1'b0;
							end
						1'b1: begin
								// writing data, so kick off write to CSR.
								CSR_A <= addr;
								CSR_DW <= PWDATA;
								CSR_WE <= 1'b1;
								state <= WRITE;
								PREADY <= 1'b0;
								PRDATA <= 32'b0;
								addr <= addr;
							end
					endcase
				end else if (rd_enable) begin
					case (PADDR[2])
						1'b0: begin
								// reading address register
								PRDATA[31:14] <= 18'b0;
								PRDATA[13:0]  <= addr;
								CSR_DW <= 32'b0;
								CSR_A <= 32'b0;
								PREADY <= 1'b1;
								CSR_WE <= 1'b0;
								state <= IDLE;
								addr <= addr;
							end
						1'b1: begin
								// reading data, so kick off read from CSR
								CSR_A <= addr;
								CSR_DW <= 32'b0;
								CSR_WE <= 1'b0;
								PREADY <= 1'b0;
								PRDATA <= 32'b0;
								state <= READ1;
								addr <= addr;
							end
					endcase
				end else begin
					// just idle
					addr <= addr;
					state <= IDLE;
					PRDATA <= 32'b0;
					CSR_DW <= 32'b0;
					CSR_A <= 32'b0;
					PREADY <= 1'b1;
					CSR_WE <= 1'b0;
				end
			READ1: begin
					// we just wrote address to the CSR bus, so it will have data ready next cycle
					CSR_A <= addr;
					CSR_DW <= 32'b0;
					CSR_WE <= 1'b0;
					PREADY <= 1'b0;
					PRDATA <= 32'b0;
					addr <= addr;
					state <= READ2;
				end
			READ2: begin
					// yay, CSR has data ready for us now
					PREADY <= 1'b1;
					PRDATA <= CSR_DR;
					CSR_A <= 32'b0;
					CSR_DW <= 32'b0;
					CSR_WE <= 1'b0;
					addr <= addr;
					state <= IDLE;
				end
			WRITE: begin
					// we just wait one cycle to give the CSR write time to complete
					CSR_WE <= 1'b0;
					PREADY <= 1'b1;
					PRDATA <= 32'b0;
					CSR_A <= addr;
					CSR_DW <= 32'b0;
					addr <= addr;
					state <= IDLE;
				end
			default: begin
					// reset
					addr <= 13'b0;
					state <= IDLE;
					PRDATA <= 32'b0;
					CSR_DW <= 32'b0;
					CSR_A <= 32'b0;
					PREADY <= 1'b1;
					CSR_WE <= 1'b0;
				end
		endcase
	end
end

endmodule
