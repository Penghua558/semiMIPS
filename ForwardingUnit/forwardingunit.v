/*
* File Name: forwardingunit.v
* Function: this is forwarding unit, using forwarding technique to solve
* data hazards. This unit currently basically takes effects in two places:
* ALU operands and data memory input data.
*/

module forwardingunit ( input wire exmemregwr, 
                        input wire [4:0] exmemregmuxout, 
                        input wire [4:0] idexrs,
                        input wire [4:0] idexrt,
                        input wire memwbregwr,
                        input wire [4:0] ifidrt,
                        input wire [4:0] ifidrs,
                        input wire idexmemwr,
                        input wire [4:0] memwbregmuxout,
                        input wire [4:0] exmemrt,
                        input wire exmemmemwr,
                        input wire [31:0] idexins,
                        input wire [31:0] exmemins,
                        input wire [31:0] memwbins,
                        output reg [1:0] aluforward1,
                        output reg [1:0] aluforward2,
                        output reg memdata,
                        output reg memdata2,
                        output reg regdata1,
                        output reg regdata2 );

always @(*) begin
    aluforward1 = 2'b00;
    aluforward2 = 2'b00;
    memdata = 1'b0;
    memdata2 = 1'b0;
    regdata1 = 1'b0;
    regdata2 = 1'b0;

    if (exmemregwr && (exmemregmuxout != 0) && 
        (exmemregmuxout == idexrs)) begin
        aluforward1 = 2'b10;
    end

    // added ID/EX.MemWr check is to exclude sw instruction scenario
    if (exmemregwr && (exmemregmuxout != 0) &&
        (exmemregmuxout == idexrt) && idexmemwr != 1'b1 &&
        (idexins[31:26] == 6'h00)) begin
        aluforward2 = 2'b10;
    end

    if (memwbregwr && (memwbregmuxout != 0) &&
        !(exmemregwr && (exmemregmuxout != 0) && 
        (exmemregmuxout == idexrs)) &&
        (memwbregmuxout == idexrs)) begin
        aluforward1 = 2'b01;
    end

    if (memwbregwr && (memwbregmuxout != 0) && (idexmemwr != 1'b1) &&
        !(exmemregwr && (exmemregmuxout != 0) &&
        (exmemregmuxout == idexrt)) &&
        (memwbregmuxout == idexrt) &&
        (idexins == 6'h00)) begin
        aluforward2 = 2'b01;
    end

    if ((memwbregmuxout == exmemrt) && exmemmemwr && 
        (exmemrt != 0)) begin
        memdata = 1'b1;
    end

    if (idexmemwr && (idexrt != 0) && 
        (memwbregmuxout == idexrt)) begin
        memdata2 = 1'b1;
    end
    
    if (memwbregwr && (ifidrt != 0) &&
        (ifidrt == memwbregmuxout)) begin
        regdata2 = 1'b1;
    end

    if (memwbregwr && (ifidrs != 0) &&
        (ifidrs == memwbregmuxout)) begin
        regdata1 = 1'b1;
    end

end

endmodule
