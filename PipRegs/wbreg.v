/*
* File Name: wbreg.v
* Function: This is a group of registers contain all control signals during
* Write Back access stage, namely MemtoReg[1:0], RegWr, Fin
*/

module wbreg ( input wire clk,
               input wire [1:0] memtoregin,
               input wire regwrin, 
               input wire finin,
               output wire [1:0] memtoregout,
               output wire regwrout,
               output wire finout);

// internal registers
reg [1:0] memtoreg;
reg regwr;
reg fin;

// registers always output their contents
assign regwrout = regwr;
assign memtoregout = memtoreg;
assign finout = fin;


// write data
always @(posedge clk) begin
    memtoreg <= memtoregin;
    regwr <= regwrin;
    fin <= finin;
end

endmodule
