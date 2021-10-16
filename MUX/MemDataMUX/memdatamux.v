/*
* File Name: memdatamux.v
* Function: this mux is placed between EX/MEM pipeline register and data
* memory, it can forward either data from 2nd register source from register
* file or the output data from data memory. It is to solve the data hazard
* when a lw instruction immediately following by a sw instruction, while
* they have the same source register field.
*
*  code | meaning
*  0    | forward register file data
*  1    | forward data memory data
*/

module memdatamux ( memdata, regdata, dmdata, out);
parameter DWIDTH = 32;

input wire memdata;
input wire [DWIDTH-1:0] regdata;
input wire [DWIDTH-1:0] dmdata;
output reg [DWIDTH-1:0] out;

always @(memdata, regdata, dmdata) begin
    case (memdata)
        1'b0: out = regdata;
        1'b1: out = dmdata;
    endcase
end

endmodule
