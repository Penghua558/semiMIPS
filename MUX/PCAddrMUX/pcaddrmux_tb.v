/*
* File Name: pcaddrmux_tb.v
* Function: this is a testbench file for PC address selection MUX
*/

`include "../../BranchCtrl/branchcodedef.v"

module pcaddrmux_tb();
reg [31:0] jumpaddr;
reg [31:0] branchaddr;
reg [1:0] branchcode;
wire pcload;
wire [31:0] pcaddr;

initial begin
    $dumpfile("pcaddrmux.vcd");
    $dumpvars;
    branchcode = 0;
    $display("code\t pcload\t addr\t\n");
    $monitor("%b\t %b\t %h\t\n", branchcode, pcload, pcaddr);
    #4 jumpaddr = 32'h12345678;
    #4 branchaddr = 32'h87654321;
    #4 branchcode = `SELJUMP;
    #4 branchcode = `SELBRANCH;
    #4 branchcode = 2'b11;

    #1 $finish;
end

pcaddrmux dut(.jumpaddr(jumpaddr),
              .branchaddr(branchaddr),
              .branchcode(branchcode),
              .pcload(pcload),
              .pcaddr(pcaddr));
endmodule
