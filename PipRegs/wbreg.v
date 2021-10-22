/*
* File Name: wbreg.v
* Function: This is a group of registers contain all control signals during
* Write Back access stage, namely MemtoReg[1:0], RegWr, Fin
* flush pin is to zero all control signals, it is synchronous, active HIGH.
*/

module wbreg ( input wire clk,
               input wire flush,
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
    if (flush == 1'b1) begin
        memtoreg <= 'b0;
        regwr <= 'b0;
        fin <= 'b0;
    end else begin
        memtoreg <= memtoregin;
        regwr <= regwrin;
        fin <= finin;
    end
end
endmodule
