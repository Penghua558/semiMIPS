/*
* File Name: memreg.v
* Function: This is a group of registers contain all control signals during
* MEMory access stage, namely MemWr, MemRd, BBne, BBeq, BBlez, BBgtz, Jump.
* flush pin is to zero all control signals, it is synchronous, active HIGH.
*/

module memreg ( input wire clk,
                input wire flush,
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
    if (flush == 1'b1) begin
        memwr <= 'b0;
        memrd <= 'b0;
        bbne <= 'b0;
        bbeq <= 'b0;
        bblez <= 'b0;
        bbgtz <= 'b0;
        jump <= 'b0;
    end else begin
        memwr <= memwrin;
        memrd <= memrdin;
        bbne <= bbnein;
        bbeq <= bbeqin;
        bblez <= bblezin;
        bbgtz <= bbgtzin;
        jump <= jumpin;
    end
end

endmodule
