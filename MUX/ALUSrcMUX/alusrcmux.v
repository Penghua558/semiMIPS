/*
* File Name: alusrcmux.v
* Function: this mux is located between register file and ALU, serves as a
* mux to select ALU operand from immediate number or register or a constant
* 16.
*
* This module contains 1 control signal, ALUSrc, if it is deasserted, it will
* take data from register file as the operand; if it is asserted, it will
* take data from immediate number as the operand.
* code | meaning
* 00   | takes operand from register
* 01   | takes operand from immediate number
* 10   | takes operand from constant 16
*/

module alusrcmux( input wire [31:0] regsrc,
                  input wire [31:0] immsrc,
                  input wire [1:0] alusrc,
                  output reg [31:0] operand);

always @(*) begin
    case (alusrc)
        2'b00: operand = regsrc;
        2'b01: operand = immsrc;
        2'b10: operand = 32'd16;
        default: operand = 32'bx;
    endcase
end

endmodule
