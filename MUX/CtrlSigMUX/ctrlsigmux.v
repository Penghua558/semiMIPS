/*
* File Name: ctrlsigmux.v
* Function: this mux is placed between ID/EX pipeline register and control
* unit. The select pin is controled by hazard detection unit, by asserting
* and deasserting the select pin, the hazard detection unit can choose
* to use control signals produced by control unit, if everything is normal,
* or a NOP operation, if a bubble is required, insert a bubble will delay
* current instruction execution by 1 clock cycle.
* code | meaning
* 0    | use control signals from control unit
* 1    | use NOP operation
* 
* the select pin's name is CtrlSig.
*/

module ctrlsigmux ( input wire ctrlsig,
                    input wire ctrlalualtsrc,
                    input wire [1:0] ctrlalusrc,
                    input wire [1:0] ctrlregdst,
                    input wire [2:0] ctrlaluop,
                    input wire ctrlmemwr,
                    input wire ctrlmemrd,
                    input wire ctrlbbne,
                    input wire ctrlbbeq,
                    input wire ctrlbblez,
                    input wire ctrlbbgtz,
                    input wire ctrljump,
                    input wire [1:0] ctrlmemtoreg,
                    input wire ctrlregwr,
                    input wire ctrlfin,
                    output reg alualtsrc,
                    output reg [1:0] alusrc,
                    output reg [1:0] regdst,
                    output reg [2:0] aluop,
                    output reg memwr,
                    output reg memrd,
                    output reg bbne,
                    output reg bbeq,
                    output reg bblez,
                    output reg bbgtz,
                    output reg jump,
                    output reg [1:0] memtoreg,
                    output reg regwr,
                    output reg fin );

always @(*) begin
    case (ctrlsig)
        1'b0: begin
                alualtsrc = ctrlalualtsrc;
                alusrc = ctrlalusrc;
                regdst = ctrlregdst;
                aluop = ctrlaluop;
                memwr = ctrlmemwr;
                memrd = ctrlmemrd;
                bbne = ctrlbbne;
                bbeq = ctrlbbeq;
                bblez = ctrlbblez;
                bbgtz = ctrlbbgtz;
                jump = ctrljump;
                memtoreg = ctrlmemtoreg;
                regwr = ctrlregwr;
                fin = ctrlfin;
              end
        1'b1: begin
                alualtsrc = 1'b0;
                alusrc = 2'b00;
                regdst = 2'b00;
                aluop = 3'b000;
                memwr = 1'b0;
                memrd = 1'b0;
                bbne = 1'b0;
                bbeq = 1'b0;
                bblez = 1'b0;
                bbgtz = 1'b0;
                jump = 1'b0;
                memtoreg = 2'b00;
                regwr = 1'b0;
                fin = 1'b0;
              end
    endcase
end

endmodule
