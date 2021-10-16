/*
* File Name: exreg_tb.v
* Function: this is a testbench file for exreg module.
*/

module exreg_tb ();
reg clk;
reg alualtsrcin;
reg [1:0] alusrcin;
reg [1:0] regdstin;
reg [2:0] aluopin;
wire alualtsrcout;
wire [1:0] alusrcout;
wire [1:0] regdstout;
wire [2:0] aluopout;

always
    #2 clk = ~clk;

initial begin
    $dumpfile("test.vcd");
    $dumpvars;
    clk = 0;
    $display("alualtsrcin\t alusrcin\t regdstin\t aluopin\t alualtsrcout\t");
    $display("alusrcout\t regdstout\t aluopout\n");
    $monitor("%b\t %b\t %b\t %b\t %b\t %b\t %b\t %b\t"
            , alualtsrcin, alusrcin, regdstin, aluopin, alualtsrcout,
            alusrcout, regdstout, aluopout);
    #4 alualtsrcin = 0;
    #2 alusrcin = 2'b10;
    #2 regdstin = 2'b11;
    #2 aluopin = 3'b011;
    #3 alusrcin = 2'b11;
    #3 $finish;
end

// DUT, device under test
exreg dut (clk, alualtsrcin, alusrcin, regdstin, aluopin,
            alualtsrcout, alusrcout, regdstout, aluopout);
endmodule
