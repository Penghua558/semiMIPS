/*
* File Name: ctrlhazardunit.v
* Function: this module is to take care of control hazard, for now the 
* scheme is to predict that branch will always to be untaken, so CPU will
* always execute branch instruction's following instructions, if the 
* prediction is wrong, then the unit will flush IF/ID, ID/EX and EX/MEM's
* control signals and instruction field to zeros to discard all previous
* operations.
*/

module ctrlhazardunit ( input wire pcload, 
                        output reg ifidflush,
                        output reg idexflush,
                        output reg exmemflush );

initial begin
    ifidflush = 0;
    idexflush = 0;
    exmemflush = 0;
end

always @(pcload) begin
    if (pcload == 1'b1) begin
        // branch is taken, discard previous operations
        ifidflush = 1;
        idexflush = 1;
        exmemflush = 1;
    end else begin
        // branch is untaken
        ifidflush = 0;
        idexflush = 0;
        exmemflush = 0;
    end
end

endmodule
