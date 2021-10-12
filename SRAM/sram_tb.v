/*
* File Name: sram_tb.v
* Function: this is a testbench file for SRAM module, the file will test
* both read and write functions, then it will test its chip select pin and 
* test what will happen when read and write happens simultaneously.
*/

module sram_tb();
parameter AWIDTH = 8;
parameter DWIDTH = 32;
parameter DEPTH = 64;

reg clk, rd, wr, cs;
reg [AWIDTH-1:0] addr;
reg [DWIDTH-1:0] din;
wire [DWIDTH-1:0] dout;

initial begin
    clk = 0;
    rd = 0;
    cs = 0;
    wr = 0;
    din = 0;
end

always
    #2 clk = ~clk;

initial begin
    $dumpfile("sram.vcd");
    $dumpvars;
    #1 cs = 1;
    // write
    #1 addr = 8'h5C; // 24th word
    #1 din = 32'h5800FEA9;
    #8 wr = 1;
    #4 wr = 0;
    #1 din = 0;

    // read
    #3 rd = 1;
    #8 rd = 0;

    // write and read happens simultaneously
    #1 din = 32'h86AC57B3;
    #1 addr = 8'hFC; // 63th word 
    #1 rd = 1;
    #1 wr = 1;
    #8 $finish;
end

// DUT, device under test
sram #(.DWIDTH(DWIDTH), .AWIDTH(AWIDTH), .DEPTH(DEPTH)) dut (
                .clk(clk), 
                .rd(rd), 
                .wr(wr),
                .cs(cs),
                .address(addr),
                .din(din),
                .dout(dout));
endmodule
