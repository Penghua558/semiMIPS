/*
* File Name: regfile_tb.v
* Function: this is a testbench for module regfile, the testbench tests 
* the read and write functions, and lastly will test the special case where
* write and read operation happen on the same register simultnaneously.
*/

module regfile_tb();
parameter DWIDTH = 32;

reg [4:0] rdaddr1;
reg [4:0] rdaddr2;
reg [4:0] wraddr;
reg [DWIDTH-1:0] din;
reg clk, wr;
wire [DWIDTH-1:0] dout1;
wire [DWIDTH-1:0] dout2;

initial begin
    clk = 0;
    wr = 0;
    rdaddr1 = 0;
    rdaddr2 = 0;
    din = 0;
end

// supply clock signal
always
   #2 clk = ~clk;

initial begin
    $dumpfile("regfile.vcd");
    $dumpvars;
    $display("time\t readReg1\t readReg2\t writeReg\t writeData\t wr\t Regout1\t Regout2\t\n");
    $monitor("%g\t %d\t %d\t %d\t", $time, rdaddr1, rdaddr2, wraddr,
            "%h\t %b\t %h\t %h\t\n", din, wr, dout1, dout2);
    // write to 6th register, aka $a1
    #4 wraddr = 5;
    #1 din = 32'h192489AC;
    #1 wr = 1;
    #5 wr = 0;

    // write to 15th register, aka $t6
    #1 wraddr = 14;
    #1 din = 32'h70CA7800;
    #1 wr = 1;
    #5 wr = 0;

    // read registers
    #2 rdaddr1 = 14;
    #4 rdaddr2 = 5;

    // test special case where read and write operations on a same register
    // happen simultnaneously
    #1 wraddr = 5;
    #1 din = 32'h658921D3;
    #4 wr = 1;
    #4 wr = 0;

    #4 $finish;
end

// DUT, device under test
regfile #(.DWIDTH(DWIDTH)) dut (
        .rdaddr1(rdaddr1),
        .rdaddr2(rdaddr2),
        .wraddr(wraddr),
        .wr(wr),
        .clk(clk),
        .din(din),
        .dout1(dout1),
        .dout2(dout2));

endmodule
