/*
* File Name: regdstmux.v
* Function: it's a mux to decide which instruction field should be taken
* as a address for destination register. The mux is located between 
* instruction memory and register file.
*
* This module contains 1 control signal, RegDst, if it is deasserted, then
* the mux will take 15-11 field as destination register address, treat it
* like a R-format instruction; if it is asserted, then 20-16 is taken as
* the register address, treat it like an I-format instruction.
* code | meaning
* 00   | treat like R-format instruction, it takes 15-11 bit field
* 01   | treat like I-format instruction, it takes 20-16 bit field
* 10   | takes register $ra address
*/

`include "regindexdef.v"

module regdstmux(input wire [4:0] rdstaddr, // R-format dst address field
                 input wire [4:0] idstaddr, // I-format dst address field
                 input wire [1:0] regdst, // control signal
                 output reg [4:0] dstaddr);

always @(*) begin
    case (regdst)
        2'b00: dstaddr = rdstaddr;
        2'b01: dstaddr = idstaddr;
        2'b10: dstaddr = `ra;
        default: dstaddr = 'bz;
    endcase
end

endmodule
