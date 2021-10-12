/*
* File Name: regsrcmux.v
* Function: this mux selects between result from ALU and data from memory to
* write it into register file. Now added another data resource, PC+4.
*
* This module contains 1 control signal, MemtoReg, 
* code | meaning
* 00   | take data from ALU
* 01   | take data from memory
* 10   | take data PC+4
* 11   | take data from negative flag, this is specially for slti instruction
*/

module regsrcmux( input wire [31:0] memdata,
                  input wire [31:0] aludata,
                  input wire [31:0] pcdata,
                  input wire negative,
                  input wire [1:0] memtoreg,
                  output reg [31:0] regdata);

always @(*) begin
    case (memtoreg)
        2'b00: regdata = aludata;
        2'b01: regdata = memdata;
        2'b10: regdata = pcdata;
        2'b11: regdata = {31'b0,negative};
    endcase
end

endmodule
