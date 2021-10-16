/*
* File Name: exmemreg.v
* Function: this is EX/MEM pipeline register module. It contains WB register,
* MEM register, ALU result, zero flag, negative flag, overflow flag, 
* RegDstMUX output, register file data output 2, branch address, jump
* address.
*/

module exmemreg ( clk, memwrin, memrdin, bbnein, bbeqin, bblezin, bbgtzin,
                    jumpin,
                    memwrout, memrdout, bbneout, bbeqout, bblezout,
                    bbgtzout, jumpout,
                    memtoregin, regwrin,
                    memtoregout, regwrout,
                    aluoutin, zeroin, negativein, overflowin,
                    regdstmuxin, regdata2in, branaddrin, jmpaddrin,
                    aluoutout, zeroout, negativeout, overflowout,
                    regdstmuxout, regdata2out, branaddrout, jmpaddrout);
parameter AWIDTH = 32;
parameter DWIDTH = 32;

input wire clk, memwrin, memrdin, bbnein, bbeqin, bblezin, bbgtzin, jumpin;
output wire memwrout, memrdout, bbneout, bbeqout, bblezout, bbgtzout;
output wire jumpout;
input wire [1:0] memtoregin;
input wire regwrin;
output wire [1:0] memtoregout;
output wire regwrout;
input wire [DWIDTH-1:0] aluoutin;
input wire zeroin, negativein, overflowin;
input wire [4:0] regdstmuxin;
input wire [DWIDTH-1:0] regdata2in;
input wire [AWIDTH-1:0] branaddrin;
input wire [AWIDTH-1:0] jmpaddrin;
output reg [DWIDTH-1:0] aluoutout;
output reg zeroout, negativeout, overflowout;
output reg [4:0] regdstmuxout;
output reg [DWIDTH-1:0] regdata2out;
output reg [AWIDTH-1:0] branaddrout;
output reg [AWIDTH-1:0] jmpaddrout;

wbreg wbregins (clk, memtoregin, regwrin, memtoregout, regwrout);
memreg memregins (clk, memwrin, memrdin, bbnein, bbeqin, bblezin, 
                    bbgtzin, jumpin,
                    memwrout, memrdout, bbneout, bbeqout, bblezout,
                    bbgtzout, jumpout);

// memory
reg [DWIDTH-1:0] aluout;
reg zero, negative, overflow;
reg [4:0] regdstmux;
reg [DWIDTH-1:0] regdata2;
reg [AWIDTH-1:0] branaddr;
reg [AWIDTH-1:0] jmpaddr;

always @(aluout) begin
    aluoutout = aluout;
end

always @(zero) begin
    zeroout = zero;
end

always @(negative) begin
    negativeout = negative;
end

always @(overflow) begin
    overflowout = overflow;
end

always @(regdstmux) begin
    regdstmuxout = regdstmux;
end

always @(regdata2) begin
    regdata2out = regdata2;
end

always @(branaddr) begin
    branaddrout = branaddr;
end

always @(jmpaddr) begin
    jmpaddrout = jmpaddr;
end

always @(posedge clk) begin
    aluout <= aluoutin;
    zero <= zeroin;
    negative <= negativein;
    overflow <= overflowin;
    regdstmux <= regdstmuxin;
    regdata2 <= regdata2in;
    branaddr <= branaddrin;
    jmpaddr <= jmpaddrin;
end

endmodule
