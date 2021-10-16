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
                        input memwbregwr,
                        input wire [4:0] memwbregmuxout,
                        input wire [4:0] exmemrt,
                        input wire exmemmemwr,
                        output reg [1:0] aluforward1,
                        output reg [1:0] aluforward2,
                        output reg memdata);

always @(*) begin
    aluforward1 = 2'b00;
    aluforward2 = 2'b00;
    memdata = 1'b0;

    if (exmemregwr && (exmemregmuxout != 0) && 
        (exmemregmuxout == idexrs)) begin
        aluforward1 = 2'b10;
    end

    if (exmemregwr && (exmemregmuxout != 0) &&
        (exmemregmuxout == idexrt)) begin
        aluforward2 = 2'b10;
    end

    if (memwbregwr && (memwbregmuxout != 0) &&
        !(exmemregwr && (exmemregmuxout != 0) && 
        (exmemregmuxout != idexrs)) &&
        (memwbregmuxout == idexrs)) begin
        aluforward1 = 2'b01;
    end

    if (memwbregwr && (memwbregmuxout != 0) &&
        !(exmemregwr && (exmemregmuxout != 0) &&
        (exmemregmuxout != idexrt)) &&
        (memwbregmuxout == idexrt)) begin
        aluforward2 = 2'b01;
    end

    if ((memwbregmuxout == exmemregmuxout) && exmemmemwr && 
        (exmemrt != 0)) begin
        memdata = 1'b1;
    end
end

endmodule
