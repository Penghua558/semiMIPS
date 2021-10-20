/*
* File Name: exmemreg.v
* Function: this is EX/MEM pipeline register module. It contains WB register,
* MEM register, ALU result, zero flag, negative flag, overflow flag, 
* RegDstMUX output, register file data output 2, branch address, jump
* address.
*/

/* `include "./wbreg.v" */
/* `include "./memreg.v" */

module exmemreg ( clk, memwrin, memrdin, bbnein, bbeqin, bblezin, bbgtzin,
                    jumpin,
                    memwrout, memrdout, bbneout, bbeqout, bblezout,
                    bbgtzout, jumpout,
                    memtoregin, regwrin, finin,
                    memtoregout, regwrout, finout,
                    aluoutin, zeroin, negativein, overflowin,
                    regdstmuxin, regdata2in, branaddrin, jmpaddrin, pcnextin,
                    aluoutout, zeroout, negativeout, overflowout,
                    regdstmuxout, regdata2out, branaddrout, jmpaddrout,
                    rtin, rtout, pcnextout);
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
input wire [AWIDTH-1:0] pcnextin;
output reg [DWIDTH-1:0] aluoutout;
output reg zeroout, negativeout, overflowout;
output reg [4:0] regdstmuxout;
output reg [DWIDTH-1:0] regdata2out;
output reg [AWIDTH-1:0] branaddrout;
output reg [AWIDTH-1:0] jmpaddrout;
input wire [4:0] rtin;
output reg [4:0] rtout;
output reg [AWIDTH-1:0] pcnextout;
input wire finin;
output wire finout;

wbreg wbregins (clk, memtoregin, regwrin, finin,
                memtoregout, regwrout, finout);
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
reg [4:0] rt;
reg [AWIDTH-1:0] pcnext;

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

always @(rt) begin
    rtout = rt;
end

always @(pcnext) begin
    pcnextout = pcnext;
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
    rt <= rtin;
    pcnext <= pcnextin;
end

endmodule
