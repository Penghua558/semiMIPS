/*
* File Name: branctrl.v
* Function: though the module name only contains branch, it is in fact
* control both branch and jump instructions, given 3 flags from ALU and all 
* branch and jump control signals from control unit, the module will decode
* it into 2bit, then feed it to a MUX to decide whether we should load a new
* address into PC and which address should we load in, the address from
* branch instructions or the one from jump instructions.
*/

`include "./branchcodedef.v"

module branchctrl( input wire zero, // flag from ALU
                   input wire negative, // flag from ALU
                   input wire overflow, // flag from ALU
                   input wire jump, // jump signal from control unit
                   input wire branchbeq,
                   input wire branchbne,
                   input wire branchblez,
                   input wire branchbgtz,
                   output reg [1:0] out); // 3 cases in total, so we need 2 bits to control MUX

always @(*) begin
    out = `NOLOAD;
    if (jump | branchbeq | branchbne | branchblez | branchbgtz) begin
        if (jump) begin
            // jump instructions detected, so we should jump
            out = `SELJUMP;
        end else begin
            // if we are here it means we are about to determine if 
            // branch condition is met or not
            if (branchbeq & zero & ~negative & ~overflow) out = `SELBRANCH;
            if (branchbne & ~zero) out = `SELBRANCH;
            if (branchblez & (zero | negative)) out = `SELBRANCH;
            if (branchbgtz & ~zero & ~negative) out = `SELBRANCH;
        end
    end
end

endmodule
