/*
* File Name: aluctrl_tb.v
* Function: this is a testbench file for ALU control module
*/

module aluctrl_tb();
reg [2:0] aluop;
reg [5:0] funct;
wire [3:0] opcodeforalu;

initial begin
    $dumpfile("aluctrl.vcd");
    $dumpvars;
    aluop = 0;
    funct = 'hx;
    $display("aluop\t   funct\t     opcode\t\n");
    $monitor("%b\t      %h\t        %h\t", aluop, funct, opcodeforalu);

    #1 aluop = 0; // add
    #4 aluop = 1; // subtract
    #4 funct = 6'h2A;
    #4 aluop = 3; // and
    #4 aluop = 4; // or
    #4 aluop = 5; // add unsigned

    // R-type test
    #4 aluop = 2;
    #4 funct = 0; // LSL
    #4 funct = 2; // LSR
    #4 funct = 3; // ASR
    #4 funct = 6'h20; // add
    #4 funct = 6'h21; // add unsigned
    #4 funct = 6'h22; // subtract
    #4 funct = 6'h23; // subtract unsigned
    #4 funct = 6'h24; // and
    #4 funct = 6'h25; // or
    #4 funct = 6'h26; // xor
    #4 funct = 6'h2A; // subtract
    #4 funct = 6'h2B; // subtract unsigned
    #4 $finish;
end

// DUT, device under test
aluctrl dut(aluop, funct, opcodeforalu);

endmodule
