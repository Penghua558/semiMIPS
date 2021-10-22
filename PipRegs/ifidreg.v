/*
* File Name: ifidreg.v
* Function: this module is IF/ID pipeline register, it contains 
* instruction field, PC+4 field.
* wr pin is write signal, active HIGH.
* flush pin is to zeros register's instruction field to make it a nop,
* it is a synchronous signal, even with wr is deasserted flush will still
* work, active HIGH.
*/

module ifidreg ( clk, insin, insout, pcnextin, pcnextout, wr, flush);
parameter INSWIDTH = 32;
parameter AWIDTH = 32;

input wire clk;
input wire [INSWIDTH-1:0] insin;
input wire [AWIDTH-1:0] pcnextin;
input wire wr;
input wire flush;
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
    if (wr == 1'b1) begin
        pcnext <= pcnextin;
    end

    if (flush == 1'b1) begin
        ins <= 'b0;
    end else if (wr == 1'b1) begin
        ins <= insin;
    end
end

endmodule
