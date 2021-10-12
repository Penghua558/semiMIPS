/*
* File Name: alu_tb.v
* Function: this is test bench file for module ALU in alu.v file.
*/

`include "./aluopdef.v"

module alu_tb();
reg [31:0] A;
reg [31:0] B;
reg signed [31:0] signedA;
reg signed [31:0] signedB;
reg [3:0] op;
wire [31:0] out;
wire signed [31:0] signedout;
wire zero, overflow, negative;
wire szero, soverflow, snegative;

// instance for unsigned number test
alu aluU(
    .A  (A),
    .B  (B),
    .op (op),
    .out (out),
    .zero (zero),
    .overflow (overflow),
    .negative (negative));

// instance for signed number test
// the reason to seperate signed and unsigned to test is that the $display
// function will treat signed number as unsigned number regardless of its
// negative sign, so you need to convert result to negative manually, which
// is tedious
alu aluS(
    .A  (signedA),
    .B  (signedB),
    .op (op),
    .out (signedout),
    .zero (szero),
    .overflow (soverflow),
    .negative (snegative));

task add;
input reg signed [31:0] operandA;
input reg signed [31:0] operandB;
begin
    signedA = operandA;
    signedB = operandB;
    op = `ADD;
end
endtask

task subtract;
input reg signed [31:0] operandA;
input reg signed [31:0] operandB;
begin
    signedA = operandA;
    signedB = operandB;
    op = `SUB;
end
endtask

task negation;
input reg signed [31:0] operandA;
begin
    signedA = operandA;
    op = `NEG;
end
endtask

task addu;
input reg [31:0] operandA;
input reg [31:0] operandB;
begin
    A = operandA;
    B = operandB;
    op = `ADDU;
end
endtask

task subtractu;
input reg [31:0] operandA;
input reg [31:0] operandB;
begin
    A = operandA;
    B = operandB;
    op = `SUBU;
end
endtask

task andtask;
input reg [31:0] operandA;
input reg [31:0] operandB;
begin
    A = operandA;
    B = operandB;
    op = `AND;
end
endtask

task ortask;
input reg [31:0] operandA;
input reg [31:0] operandB;
begin
    A = operandA;
    B = operandB;
    op = `OR;
end
endtask

task xortask;
input reg [31:0] operandA;
input reg [31:0] operandB;
begin
    A = operandA;
    B = operandB;
    op = `XOR;
end
endtask

task nottask;
input reg [31:0] operandA;
begin
    A = operandA;
    op = `NOT;
end
endtask

task asl;
input reg [31:0] operandA;
input reg [31:0] operandB;
begin
    A = operandA;
    B = operandB;
    op = `ASL;
end
endtask

task asr;
input reg [31:0] operandA;
input reg [31:0] operandB;
begin
    A = operandA;
    B = operandB;
    op = `ASR;
end
endtask


task lsl;
input reg [31:0] operandA;
input reg [31:0] operandB;
begin
    A = operandA;
    B = operandB;
    op = `LSL;
end
endtask

task lsr;
input reg [31:0] operandA;
input reg [31:0] operandB;
begin
    A = operandA;
    B = operandB;
    op = `LSR;
end
endtask

initial begin
    $dumpfile("alu.vcd");
    $dumpvars;
end


initial begin
    $display("===========normal test cases==========");
    $display("time\t op\t A\t B\t out\t zero\t overflow\t negative\t signedA\t signedB\t signedout\t szero\t soverflow\t snegative\t\n");
    $monitor("%g\t %h\t %d\t %d\t %d\t %b\t %b\t %b\t %d\t %d\t %d\t %b\t %b\t %b\t\n", 
            $time, op, A, B, out, zero, overflow, negative, 
            signedA, signedB, signedout, szero, soverflow, snegative);
    #4 addu(48464, 344863132);
    #4 add(2152535, -98421354);
    #4 subtractu(46213, 135); 
    #4 subtract(-4431, -24653);
    #4 negation(13);
    #4 negation(-21);
    #4 negation(0);


    #1 $display("=========bitwise and shift operations test cases==========");
    $display("time\t op\t A\t B\t out\t zero\t overflow\t negative\t\n");
    #4 andtask(8, 24);
    #4 ortask(-24, 23);
    #4 xortask(5, 7);
    #4 nottask(124);
    #4 nottask(-73);
    #4 asl(8'b10011101, 2);
    #4 asr(8'b10011101, 2);
    #4 lsl(8'b10011101, 2);
    #4 lsr(8'b10011101, 2);


    $display("===========zero flag test cases==========");
    $display("time\t op\t A\t B\t out\t zero\t overflow\t negative\t\n");
    #4 add(23, -23);
    #4 subtract(0 ,0);
    #4 andtask(4'b1001, 4'b0110);


    $display("===========overflow test cases==========");
    $display("time\t op\t A\t B\t out\t zero\t overflow\t negative\t\n");
    #4 addu(4081813515,548256422);
    #4 add(-1710002356, -2023002144);
    #4 subtract(1600000000, -1052315422);
    #4 subtractu(825361200, 1246482356);

    #4 $finish;
end

endmodule
