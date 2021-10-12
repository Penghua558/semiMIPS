/*
* File Name: ctrlunit.v
* Function: this file contains control unit, it takes opcode field in 
* instruction as input, it in turn will output 13 control signals.
* 
* Signal   |  function when asserted | function when deasserted  
* --------------------------------------------------------------
* RegWr    | issue write signal to   | don't issue write signal to register
*          | register file           | file, so that no data will be written
*                                    | into register file
* ---------------------------------------------------------------
*  MemWr   | issue write signal to   | don't issue write signal to data
*          | data memory             | memory, so that no data will be 
*                                    | written into data memory
* ------------------------------------------------------------------
* MemRd    | issue read signal to    | don't issue read signal to data
*          | data memory             | memory, so that no data will output
* -------------------------------------------------------------------
* Jump     | signals branch and jump | current instruction is not related
*          | control unit that current| to jump
*          | instruction is related to|
*          | jump                     |
* ------------------------------------------------------------------
* BranchBeq| signal branch and jump  | current instruction is not beq
*          | control unit that current|
*          | instruction is beq      |
* -------------------------------------------------------------------
* BranchBne| signal branch and jump  | current instruction is not bne
*          | control unit that current|
*          | instruction is bne      |
* --------------------------------------------------------------------
* BranchBlez| signal branch and jump | current instruction is not blez
*          | control unit that current|
*          | instruction is blez     |
* --------------------------------------------------------------------
* BranchBgtz| signal branch and jump | current instruction is not bgtz
*          | control unit that current|
*          | instruction is bgtz     |
* -------------------------------------------------------------------
*  PCEn    | enable PC to keep counting | disable PC to counting, 
*                                       | output will stay the same value
*                                       | before PC is disabled
* -------------------------------------------------------------------
* ALUAltSrc| takes extended immediate| takes data from register file as
*          | number as operand A for | operand A for ALU
*          | ALU                     |
* -------------------------------------------------------------------
*  Fin     | the signal is HIGH,     | the signal is LOW, which indicates
*          | which indicates the     | the program is not finished yet
*          | program is finished     |
*
* A special signal is ALUOp, it has 3bit width, it is sent to ALU control
* unit to issue ALU operation to ALU.
* ALUOp signal:
* ALUOp code | meaning
* --------------------
* 000        | issue add( load and store instruction, addi) 
* --------------------
* 001        | issue subtract(beq, slti)
* ---------------------
* 010        | depends on funct field in R-formt instruction
* ----------------------
* 011        | issue and(andi)
* ----------------------
* 100        | issue or(ori)
* ----------------------
* 101        | issue addu(addiu)
* ----------------------
* 110        | issue lsl(lui)
*
* RegDst is a 2bit width signal, it controls which register address source
* to taken.
* code | meaning
* 00   | treat like R-format instruction, it takes 15-11 bit field
* 01   | treat like I-format instruction, it takes 20-16 bit field
* 10   | takes register $ra address
*
* MemtoReg is a 2bit width signal, it controls which data should be 
* supplied to register file as written data.
* code | meaning
* 00   | take data from ALU
* 01   | take data from memory
* 10   | take data PC+4
* 11   | take data from negative flag, this is specially for slti instruction
*
* ALUSrc is a 2bit width signal, it controls wchich data should be taken
* for operand B of ALU.
* code | meaning
* 00   | takes operand from register
* 01   | takes operand from immediate number
* 10   | takes operand from constant 16
*/

`include "./opcode.v"

module ctrlunit( input wire [5:0] opcode, // first 6bit from MSB
                 output reg [1:0] RegDst,
                 output reg RegWr,
                 output reg [1:0] ALUSrc,
                 output reg MemWr,
                 output reg MemRd,
                 output reg [1:0] MemtoReg,
                 output reg Jump,
                 output reg BBeq, // short for BranchBne
                 output reg BBne, // short for BranchBne
                 output reg BBlez, // short for BranchBlez
                 output reg BBgtz, // short for BranchBgtz
                 output reg PCEn,
                 output reg [2:0] ALUOp,
                 output reg ALUAltSrc,
                 output reg Fin); 

// this task eases assignment to 20bit width control signal by passing a
// 20it binary string
task assctrlsig; // short for assign control signals
input [19:0] ctrlsig;
begin
    {RegDst, RegWr, ALUSrc, MemWr, MemRd, MemtoReg, Jump, 
        BBeq, BBne, BBlez, BBgtz, PCEn, ALUOp, ALUAltSrc, Fin} = ctrlsig;
end
endtask

always @(opcode) begin
    case(opcode)
        `RTYPE: assctrlsig(20'b001000x00_00000_1_010_0_0); 
        `JUMP: assctrlsig(20'bxx0xx0xxx_10000_1_xxx_x_0);
        `JAL: assctrlsig(20'b101xx0x10_10000_1_xxx_x_0);
        `BEQ: assctrlsig(20'bxx0000xxx_01000_1_001_0_0);
        `BNE: assctrlsig(20'bxx0000xxx_00100_1_001_0_0);
        `BLEZ: assctrlsig(20'bxx0000xxx_00010_1_001_0_0);
        `BGTZ: assctrlsig(20'bxx0000xxx_00001_1_001_0_0);
        `ADDI: assctrlsig(20'b011010x00_00000_1_000_0_0);
        `ADDIU: assctrlsig(20'b011010x00_00000_1_101_0_0);
        `SLTI: assctrlsig(20'b011010x11_00000_1_001_0_0);
        `ANDI: assctrlsig(20'b011010x00_00000_1_011_0_0);
        `ORI: assctrlsig(20'b011010x00_00000_1_100_0_0);
        `LUI: assctrlsig(20'b011100x00_00000_1_110_1_0);
        `LW: assctrlsig(20'b011010101_00000_1_000_0_0);
        `SW: assctrlsig(20'bxx0011xxx_00000_1_000_0_0);
        `FIN: assctrlsig(20'bxx0xx0xxx_00000_0_xxx_x_1);
        default: assctrlsig('b0); // nop, PC is also been disabled
    endcase
end

endmodule
