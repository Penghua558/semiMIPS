/*
* File Name: aluctrl.v
* Function: this file describes ALU control unit, which takes 3bit ALUOp
* from control unit and 6bit funct field code from instruction if there's
* any, then output 4bit opcode for ALU.
*
* ALUop | meaning
* -----------------
* 000   | add(for load and store and addi instruction)
* 001   | subtract(beq and slti instruction)
* 010   | R-type instruction
* 011   | and(andi instruction)
* 100   | or(ori instruction)
* 101   | addu(adiu instruction)
* 110   | lsl(lui)
*/

`include "../ALU/aluopdef.v"
`include "funct.v"

module aluctrl(input wire [2:0] aluop,
               input wire [5:0] funct,
               output reg [3:0] opcodeforalu);

always @(aluop, funct) begin
    case (aluop)
        3'b000: opcodeforalu = `ADD;
        3'b001: opcodeforalu = `SUB;
        3'b010: begin // R-type instruction
                   case (funct)
                        `FUNCT_SLL: opcodeforalu = `LSL;
                        `FUNCT_SRL: opcodeforalu = `LSR;
                        `FUNCT_SRA: opcodeforalu = `ASR;
                        `FUNCT_ADD: opcodeforalu = `ADD;
                        `FUNCT_ADDU: opcodeforalu = `ADDU;
                        `FUNCT_SUB: opcodeforalu = `SUB;
                        `FUNCT_SUBU: opcodeforalu = `SUBU;
                        `FUNCT_AND: opcodeforalu = `AND;
                        `FUNCT_OR: opcodeforalu = `OR;
                        `FUNCT_XOR: opcodeforalu = `XOR;
                        `FUNCT_SLT: opcodeforalu = `SUB;
                        `FUNCT_SLTU: opcodeforalu = `SUBU;
                        default: opcodeforalu = 'hx;
                   endcase
                end
        3'b011: opcodeforalu = `AND;
        3'b100: opcodeforalu = `OR;
        3'b101: opcodeforalu = `ADDU;
        3'b110: opcodeforalu = `LSL;
        default: opcodeforalu = 'bx;
    endcase
end

endmodule
