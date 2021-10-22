/*
* File Name: idexreg.v
* Function: this module is ID/EX pipeline register. It contains WB register,
* MEM register, EX register, register file data output 1&2, SignedExtend
* module output, funct code field, Rt field, Rs field, Rd field, PC+4 field,
* branch address field and jump address field, instruction.
* flush pin is to zero all control signals and instruction field, it is 
* synchronous, active HIGH.
*/

/* `include "./wbreg.v" */
/* `include "./memreg.v" */
/* `include "./exreg.v" */

module idexreg ( clk, flush, alualtsrcin, alusrcin, regdstin, aluopin, 
                alualtsrcout, alusrcout, regdstout, aluopout,
                memwrin, memrdin, bbnein, bbeqin, bblezin, bbgtzin,
                jumpin, 
                memwrout, memrdout, bbneout, bbeqout, bblezout, 
                bbgtzout, jumpout, 
                memtoregin, regwrin, finin,
                memtoregout, regwrout, finout,
                regdata1in, regdata2in, signexin, functin, rtin, rsin,
                rdin, pcnextin, branaddrin, jmpaddrin, insin,
                regdata1out, regdata2out, signexout, functout, rtout,
                rsout, rdout, pcnextout, branaddrout, jmpaddrout, insout );
parameter DWIDTH = 32;
parameter AWIDTH = 32;

input wire clk;
input wire flush;
input wire alualtsrcin;
input wire [1:0] alusrcin;
input wire [1:0] regdstin;
input wire [2:0] aluopin;
output wire alualtsrcout;
output wire [1:0] alusrcout;
output wire  [1:0] regdstout;
output wire [2:0] aluopout;
input wire memwrin, memrdin, bbnein, bbeqin, bblezin, bbgtzin, jumpin;
output wire  memwrout, memrdout, bbneout, bbeqout, bblezout, bbgtzout;
output wire jumpout;
input wire [1:0] memtoregin;
input wire regwrin;
output wire [1:0] memtoregout;
output wire regwrout;
input wire [DWIDTH-1:0] regdata1in;
input wire [DWIDTH-1:0] regdata2in;
input wire [31:0] signexin;
input wire [5:0] functin;
input wire [4:0] rtin;
input wire [4:0] rsin;
input wire [4:0] rdin;
input wire [AWIDTH-1:0] pcnextin;
input wire [AWIDTH-1:0] branaddrin;
input wire [AWIDTH-1:0] jmpaddrin;
output reg [DWIDTH-1:0] regdata1out;
output reg [DWIDTH-1:0] regdata2out;
output reg [31:0] signexout;
output reg [5:0] functout;
output reg [4:0] rtout;
output reg [4:0] rsout;
output reg [4:0] rdout;
output reg [AWIDTH-1:0] pcnextout;
output reg [AWIDTH-1:0] branaddrout;
output reg [AWIDTH-1:0] jmpaddrout;
input wire finin;
output wire finout;
input wire [31:0] insin;
output reg [31:0] insout;

wbreg wbregins (clk, flush, memtoregin, regwrin, finin, 
                memtoregout, regwrout, finout);
memreg memregins (clk, flush, memwrin, memrdin, bbnein, bbeqin, bblezin,
                    bbgtzin, jumpin, memwrout, memrdout, bbneout,
                    bbeqout, bblezout, bbgtzout, jumpout);
exreg exregins (clk, flush, alualtsrcin, alusrcin, regdstin, aluopin,
                alualtsrcout, alusrcout, regdstout, aluopout);

// memory
reg [DWIDTH-1:0] regdata1;
reg [DWIDTH-1:0] regdata2;
reg [31:0] signex;
reg [5:0] funct;
reg [4:0] rt;
reg [4:0] rs;
reg [4:0] rd;
reg [AWIDTH-1:0] pcnext;
reg [AWIDTH-1:0] branaddr;
reg [AWIDTH-1:0] jmpaddr;
reg [31:0] ins;

always @(regdata1) begin
    regdata1out = regdata1;
end

always @(regdata2) begin
    regdata2out = regdata2;
end

always @(signex) begin
    signexout = signex;
end

always @(funct) begin
    functout = funct;
end

always @(rt) begin
    rtout = rt;
end

always @(rs) begin
    rsout = rs;
end

always @(rd) begin
    rdout = rd;
end

always @(pcnext) begin
    pcnextout = pcnext;
end

always @(branaddr) begin
    branaddrout = branaddr;
end

always @(jmpaddr) begin
    jmpaddrout = jmpaddr;
end

always @(ins) begin
    insout = ins;
end

always @(posedge clk) begin
    regdata1 <= regdata1in;
    regdata2 <= regdata2in;
    signex <= signexin;
    funct <= functin;
    rt <= rtin;
    rs <= rsin;
    rd <= rdin;
    pcnext <= pcnextin;
    branaddr <= branaddrin;
    jmpaddr <= jmpaddrin;

    if (flush == 1'b1) begin
        ins <= 'b0;
    end else begin
        ins <= insin;
    end
end

endmodule
