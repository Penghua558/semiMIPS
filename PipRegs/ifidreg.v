/*
* File Name: ifidreg.v
* Function: this module is IF/ID pipeline register, it contains 
* instruction field, PC+4 field.
*/

module ifidreg ( clk, insin, insout, pcnextin, pcnextout);
parameter INSWIDTH = 32;
parameter AWIDTH = 32;

input wire clk;
input wire [INSWIDTH-1:0] insin;
input wire [AWIDTH-1:0] pcnextin;
output reg [INSWIDTH-1:0] insout;
output reg [AWIDTH-1:0] pcnextout;

// memory
reg [INSWIDTH-1:0] ins;
reg [AWIDTH-1:0] pcnext;

always @(ins) begin
    insout = ins;
end

always @(pcnext) begin
    pcnextout = pcnext;
end

always @(posedge clk) begin
    ins <= insin;
    pcnext <= pcnextin;
end

endmodule
