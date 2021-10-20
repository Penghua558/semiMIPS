/*
* File Name: hazarddetectionunit_tb.v
* Function: this is a testbench file for Hazard Detection unit.
*/

module hazarddetectionunit_tb ();
reg [4:0] idexrt;
reg [4:0] ifidrs;
reg [4:0] ifidrt;
reg idexmemrd;
wire pcen, ctrlsig;

initial begin
    $dumpfile("test.vcp");
    $dumpvars;
    #4 ;
    #1 idexmemrd = 1'b1;
    #1 idexrt = 5'b1;
    #1 ifidrt = 5'b1;
    #1 idexrt = 5'b10;
    #1 ifidrs = 5'b10;
    #1 $finish;
end

// DUT, device under test
hazarddetectionunit dut (idexrt, ifidrs, ifidrt, idexmemrd, pcen, ctrlsig);
endmodule
