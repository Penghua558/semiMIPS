/*
* File Name: alu.v
* Function: this is a 32 bit ALU, it can support add, subtract, 2's
* complement, add unsigned, subtract unsigned, and/or/xor/1's complement, 
* arithmetic shift left/right, logical shift left/right, ALU has 3 flags, 
* namely zero, overflow, negative, they are all active high. ALU's opcode
* is defined by macro.
*/

`include "./aluopdef.v"

module alu(
input wire [31:0] A, // operand A
input wire [31:0] B, // operand B
input wire [3:0] op, // opcode for ALU
output reg [31:0] out, // result of ALU
output reg zero, // zero flag to indicate result is zero, active HIGH
output reg overflow, // flag to indicate result is overflow, active HIGH
output reg negative); // flag to indicate result is negative, active HIGH

wire signed [31:0] signedA; // signed operand A
wire signed [31:0] signedB; // signed operand B

// internal variable used to detect negative in unsigned subtraction 
reg [31:0] tempout; 
// internal variable used to detect overflow and negative in signed operations
reg signed [31:0] signedout;

// convert both operands to signed numbers
assign signedA = A;
assign signedB = B;

always @(A, B, op) begin
    out = 0;
    overflow = 0;
    negative = 0;
    case(op) // calculate result and determine flags
        `ADD : begin
                    out = signedA + signedB;
                    signedout = signedA + signedB;
                    if ((signedA >= 0 && signedB >= 0 && signedout < 0) ||
                        (signedA < 0 && signedB < 0 && signedout >= 0)) begin
                       overflow = 1; 
                    end
                    if ((signedA < 0 && signedB < 0) || 
                        ((out >> 31) == 1 && ~(signedA > 0 && signedB > 0)))
                    begin
                        negative = 1;
                    end
                end
        `SUB : begin
                    out = signedA - signedB;
                    signedout = signedA - signedB;
                    if ((signedA >= 0 && signedB < 0 && signedout < 0) || 
                        (signedA < 0 && signedB >= 0 && signedout >= 0)) begin
                        overflow = 1;
                    end
                    if ((signedA < 0 && signedB > 0) ||
                        ((out >> 31) == 1 && ~(signedA > 0 && signedB < 0)))
                    begin
                        negative = 1;
                    end
                end
        `ADDU : {overflow, out} = A + B;
        `SUBU : begin 
                    {overflow, out} = A - B;
                    {negative, tempout}= {1'b0, A} - {1'b0, B}; 
                end
        `NEG : begin
                    out = 0 - signedA;
                    negative = out >> 31;
                    if (signedA < 0 && out < 0) overflow = 1;
                end
        `AND : out = A & B;
        `OR : out = A | B;
        `XOR : out = A ^ B;
        `NOT : out = ~A;
        `ASL : out = A <<< B;
        `ASR : out = A >>> B;
        `LSL : out = A << B;
        `LSR : out = A >> B;
        default : out = 32'bx;
    endcase

    // determine zero flag
    zero = 0;
    if (op!= 4'hD && op != 4'hE && op != 4'hF && out == 4'h0) begin
        zero = 1;
    end else begin
        zero = 0;
    end
end

endmodule
