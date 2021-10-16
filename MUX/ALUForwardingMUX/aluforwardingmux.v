/*
* File Name: aluforwardingmux.v
* Function: this mux is placed between ALU operand pin and ID/EX pipeline
* register. This is to forwarding data among 3 sources: original data, ALU
* result, data memory output.
* code | meaning
* 00   | no forwarding( use register data)
* 10   | use ALU result
* 01   | use data output from data memory
*/

module aluforwardingmux ( aluforward, regdata, aluresult, dmresult, out);
parameter DWIDTH = 32;

input wire [1:0] aluforward;
input wire [DWIDTH-1:0] regdata;
input wire [DWIDTH-1:0] aluresult;
input wire [DWIDTH-1:0] dmresult;
output reg [DWIDTH-1:0] out;

always @(aluforward, regdata, aluresult, dmresult) begin
    case (aluforward)
        2'b00: out = regdata;
        2'b10: out = aluresult;
        2'b01: out = dmresult;
        default: out = regdata;
    endcase
end

endmodule
