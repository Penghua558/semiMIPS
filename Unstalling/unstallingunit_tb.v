/*
* File Name: unstallingunit_tb.v
* Function: This is a testbench file for module unstallingunit.
*/

module unstallingunit_tb ();
reg PCEn;
wire En0;

initial begin
    $dumpfile("test.vcp");
    $dumpvars;
    $display("PCEn\t En0\t\n");
    $monitor("%b\t %b\t\n", PCEn, En0);
    #1 PCEn = 1'bx;
    #1 PCEn = 1'b0;
    #3 PCEn = 1'b1;
    #2 PCEn = 1'bx;
    #1 $finish;
end

// DUT, device under test
unstallingunit dut(PCEn, En0);

endmodule
