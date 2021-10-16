/*
* File Name: wbreg.v
* Function: This is a group of registers contain all control signals during
* Write Back access stage, namely MemtoReg[1:0], RegWr.
*/

module wbreg ( input wire clk,
               input wire [1:0] memtoregin,
               input wire regwrin, 
               output wire [1:0] memtoregout,
               output wire regwrout );

// internal registers
reg [1:0] memtoreg;
reg regwr;

// registers always output their contents
assign regwrout = regwr;
assign memtoregout = memtoreg;


// write data
always @(posedge clk) begin
    memtoreg <= memtoregin;
    regwr <= regwrin;
end

endmodule
