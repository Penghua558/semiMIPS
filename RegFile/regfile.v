/*
* File Name: regfile.v
* Function: this is a register file, which contains 32 registers in total,
* the registers' name and their indecies will be identical to the
* implementaion of MIPS architecture.
*/

module regfile #(parameter DWIDTH = 32)( // DWIDTH defines the data width
input wire [4:0] rdaddr1, // read register1 address
input wire [4:0] rdaddr2, // read register2 address
input wire [4:0] wraddr, // write register address
input wire [DWIDTH-1:0] din, // data that written into register
input wire wr, // write to register signal, active HIGH
input wire clk, // clock signal
output reg [DWIDTH-1:0] dout1, // register1 data output
output reg [DWIDTH-1:0] dout2); // register2 data output

// allocate 32 registers
reg [DWIDTH-1:0] register [0:31];

// internal output variable to let register file can write and read the same
// register
wire [DWIDTH-1:0] dtempout1;
wire [DWIDTH-1:0] dtempout2;

always @(dtempout1) begin
    dout1 = dtempout1;
end

always @(dtempout2) begin
    dout2 = dtempout2;
end

// read registers
// zero register always stores value of 0
assign dtempout1 = (rdaddr1 == 0) ? 0:register[rdaddr1];
assign dtempout2 = (rdaddr2 == 0)? 0:register[rdaddr2];

// write data into register
always @(posedge clk) begin
    if (wr) register[wraddr] = din;
end

endmodule
