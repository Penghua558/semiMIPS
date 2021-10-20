/*
* File Name: memwbreg.v
* Function: this is MEM/WB pipeline register, which contains WB register,
* RegDstMUX output, ALU result, data memory output, PC+4,negative flag.
*/


/* `include "./wbreg.v" */

module memwbreg (clk, memtoregin, regwrin, finin,
                    memtoregout, regwrout, finout,
                    regdstmuxin, aluoutin, dmdatain, pcnextin, negativein,
                    regdstmuxout, aluoutout, dmdataout, pcnextout,
                    negativeout);
parameter DWIDTH = 32;
parameter AWIDTH = 32;

input wire clk;
input wire [1:0] memtoregin;
input wire regwrin;
output wire [1:0] memtoregout;
output wire regwrout;
input wire [4:0] regdstmuxin;
input wire [DWIDTH-1:0] aluoutin;
input wire [DWIDTH-1:0] dmdatain;
input wire [AWIDTH-1:0] pcnextin;
input wire negativein;
output reg [4:0] regdstmuxout;
output reg [DWIDTH-1:0] aluoutout;
output reg [DWIDTH-1:0] dmdataout;
output reg [AWIDTH-1:0] pcnextout;
output reg negativeout;
input wire finin;
output wire finout;

wbreg wbregins (clk, memtoregin, regwrin, finin,
                memtoregout, regwrout, finout);

// memory
reg [4:0] regdstmux;
reg [DWIDTH-1:0] aluout;
reg [DWIDTH-1:0] dmdata;
reg [AWIDTH-1:0] pcnext;
reg negative;

always @(regdstmux) begin
    regdstmuxout = regdstmux;
end

always @(aluout) begin
    aluoutout = aluout;
end

always @(dmdata) begin
    dmdataout = dmdata;
end

always @(pcnext) begin
    pcnextout = pcnext;
end

always @(negative) begin
    negativeout = negative;
end

always @(posedge clk) begin
    regdstmux <= regdstmuxin;
    aluout <= aluoutin;
    dmdata <= dmdatain;
    pcnext <= pcnextin;
    negative <= negativein;
end

endmodule
