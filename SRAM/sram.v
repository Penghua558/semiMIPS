/*
* File Name: sram.v
* Function: this is module for SRAM (static RAM), the data width and depth is
* parameteraized, it has din for data input, dout for data output,
* cs for chip select, wr for write signal, rd for read signal. To be able to
* use the chip, cs should be set at first, then set either wr or rd pin to
* issue memory operations. The default SRAM has 10K x 32bit memory, with 
* 32bit long address.
*/

module sram (clk, address, din, dout, rd, wr, cs);
parameter AWIDTH = 32;
parameter DWIDTH = 32;
parameter DEPTH = 10240;

input wire clk;
input wire [AWIDTH-1:0] address;
input wire [DWIDTH-1:0] din;
input wire rd;
input wire wr;
input wire cs;
output reg [DWIDTH-1:0] dout;

// internal variable
// the reason to use a temporary dout is to capture any change that may
// affect data output
wire [DWIDTH-1:0] dtempout;

// memory
reg [DWIDTH-1:0] mem[0:DEPTH-1];

assign dtempout = (cs && rd)? mem[address/4]:'hz;

always @(dtempout) begin
    dout = dtempout;
end

always @(posedge clk) begin
    if (cs && wr) mem[address/4] <= din;
end

endmodule
