/*
* File Name: unstallingunit.v
* Function: This module is placed between PC and control unit, it takes
* PCEn pin of main control unit as input, its output is connected to PC's
* EN0 pin.
* The logical behavior is described below:
* Whenever its input is x(don't care), it always outputs HIGH, otherwise
* it outputs the value of input.
* The reason to put this temporary bypass device is to ensure PC is still
* counting during the 2nd clock cycle of a program, since control signals
* can only be valid after 2nd clock cycle because the pipeline architecture
* needs 1 clock cycle to store instruction to pipeline register.
*/

module unstallingunit ( input wire PCEn,
                        output reg En0);

always @(PCEn) begin
    if (PCEn == 1'bx) begin
        En0 = 1'b1;
    end else begin
        En0 = PCEn;
    end
end

endmodule
