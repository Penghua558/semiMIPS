/*
* File Name: memreg.v
* Function: This is a group of registers contain all control signals during
* MEMory access stage, namely MemWr, MemRd, BBne, BBeq, BBlez, BBgtz, Jump.
*/

module memreg ( input wire clk,
               input wire memwrin,
               input wire memrdin,
               input wire bbnein,
               input wire bbeqin,
               input wire bblezin,
               input wire bbgtzin,
               input wire jumpin,
               output wire memwrout,
               output wire memrdout,
               output wire bbneout,
               output wire bbeqout,
               output wire bblezout,
               output wire bbgtzout,
               output wire jumpout);

// internal registers
reg memwr, memrd, bbne, bbeq, bblez, bbgtz, jump;

// registers always output their contents
assign memwrout = memwr;
assign memrdout = memrd;
assign bbneout = bbne;
assign bbeqout = bbeq;
assign bblezout = bblez;
assign bbgtzout = bbgtz;
assign jumpout = jump;

// write data
always @(posedge clk) begin
    memwr <= memwrin;
    memrd <= memrdin;
    bbne <= bbnein;
    bbeq <= bbeqin;
    bblez <= bbeqin;
    bbgtz <= bbgtzin;
    jump <= jumpin;
end

endmodule
