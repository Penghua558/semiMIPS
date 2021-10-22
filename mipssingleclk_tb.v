/*
* File Name: mipssingleclk_tb.v
* Function: this is a testbench file for MIPS single clocked implemention
*/

`include "./mipssingleclk.v"

module mipssingleclk_tb ();
reg clk;
reg pcclr;
wire fin;

integer outfile; // file descriptor

always
    #2 clk = ~clk;

initial begin
    $dumpfile("testsingleclk.vcp");
    $dumpvars;
    clk = 0;
    pcclr = 0; // reset CPU
    $display("time\t current PC address\t Instruction\n");
    $monitor("%g\t %b\t %b\t", $time, dut.pcdata_out, dut.insmemins);
    $display("reading memory file...");
    $readmemb("./TestMemoryFiles/pipctrlhaz.lst", dut.insmem.mem);
    #1 pcclr = 1; // start running program
    $display("running program...");
    // output memory data to file
    @ (posedge fin);
    #1 outfile = $fopen("datamem.lst");
    $fdisplay(outfile, "%b", dut.datamem.mem[1]);
    $fdisplay(outfile, "%b", dut.datamem.mem[4]);
    $fdisplay(outfile, "%b", dut.datamem.mem[16]);
    $fclose(outfile);
    $display("%g\t program finished\n", $time);
    #8 $finish;
end


// DUT, device under test 
mipssingleclk dut (clk, pcclr, fin);

endmodule
