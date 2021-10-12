/*
* File Name: alualtsrcmux.v
* Function: this mux is located between register file and ALU, serves as a
* mux to select ALU operand from immediate number or register. This MUX is
* for operand A of ALU.
*
* This module contains 1 control signal, ALUALtSrc, if it is deasserted, it will
* take data from register file as the operand; if it is asserted, it will
* take data from immediate number as the operand.
*/

module alualtsrcmux( input wire [31:0] regsrc,
                  input wire [31:0] immsrc,
                  input wire alualtsrc,
                  output reg [31:0] operand);

always @(*) begin
    if (alualtsrc) begin
        operand = immsrc;
    end else begin
        operand = regsrc;
    end
end

endmodule
