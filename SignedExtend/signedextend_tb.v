/*
* File Name: signedextend_tb.v
* Function: this is a testbench for signed extend module
*/

module signedextend_tb();
parameter INWIDTH = 4;
parameter OUTWIDTH = 8;
reg [INWIDTH-1:0] din;
wire [OUTWIDTH-1:0] dout;

initial begin
    $dumpfile("signedextend.vcd");
    $dumpvars;
    din = 0;
    $display("dataInput\t dataOutput\t\n");
    $monitor("%b\t %b\t", din, dout);
    #1 din = 4'b0011;
    #2 din = 4'b1000;
    #2 din = 4'b1101;
    #2 $finish;
end

// DUT, device under test
signedextend #(.INWIDTH(INWIDTH), .OUTWIDTH(OUTWIDTH)) dut(din, dout);
endmodule
