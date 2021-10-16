/*
* File Name: exreg.v
* Function: This is a group of registers contain all control signals during
* EXecute stage, namely ALUAltSrc, ALUSrc[1:0], RegDst[1:0], ALUOp[2:0].
*/

module exreg ( input wire clk,
               input wire alualtsrcin,
               input wire [1:0] alusrcin,
               input wire [1:0] regdstin,
               input wire [2:0] aluopin,
               output wire alualtsrcout,
               output wire [1:0] alusrcout,
               output wire [1:0] regdstout,
               output wire [2:0] aluopout );

// internal registers
reg alualtsrc;
reg [1:0] alusrc;
reg [1:0] regdst;
reg [2:0] aluop;

// registers always output their contents
assign alualtsrcout = alualtsrc;
assign alusrcout = alusrc;
assign regdstout = regdst;
assign aluopout = aluop;

// write data
always @(posedge clk) begin
    alualtsrc <= alualtsrcin;
    alusrc <= alusrcin;
    regdst <= regdstin;
    aluop <= aluopin;
end

endmodule
