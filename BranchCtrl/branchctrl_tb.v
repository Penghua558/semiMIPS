/*
* File Name: branchctrl_tb.v
* Function: this is a testbench file for branch control module
*/

module branchctrl_tb();
reg zero, negative, overflow, jump, branchbeq, branchbne, branchblez, branchbgtz;
wire [1:0] out;

initial begin
    $dumpfile("branchctrl.vcd");
    $dumpvars;
    zero = 0;
    negative = 0;
    overflow = 0;
    jump = 0;
    branchbeq = 0;
    branchbne = 0;
    branchblez = 0;
    branchbgtz = 0;

    $display("zero\t neg\t over\t jump\t beq\t bne\t blez\t bgtz\t out\t\n");
    $monitor("%b\t %b\t %b\t %b\t %b\t %b\t %b\t %b\t %b\n",
            zero, negative, overflow, jump, branchbeq, branchbne, branchblez,
            branchbgtz, out);
    // test jump
    #4 zero = 1;
    #4 jump = 1;

    // test beq
    #4 jump = 0;
    #4 branchbeq = 1;

    // test bne
    #4 branchbeq = 0;
    #4 branchbne = 1;
    #4 zero = 0;
    #4 overflow = 1;

    // test blez
    #4 branchbne = 0;
    #4 branchblez = 1;
    #4 zero = 1;
    #4 zero = 0;
    #4 negative = 1;

    // test bgtz
    #4 branchblez = 0;
    #4 branchbgtz = 1;
    #4 overflow = 0;
    #4 negative = 0;

    #1 $finish;
end

// DUT, device under test
branchctrl dut(.zero(zero),
                .negative(negative),
                .overflow(overflow),
                .jump(jump),
                .branchbeq(branchbeq),
                .branchbne(branchbne),
                .branchblez(branchblez),
                .branchbgtz(branchbgtz),
                .out(out));
endmodule
