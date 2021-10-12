/*
* File Name: pcaddrmux.v
* Function: this module is esstialy a mux, it takes 2 32bit addresses ready
* to be loaded into PC at next clock cycle, given a 2bit code from branch
* and jump control unit, the mux will decide which address to take or just
* ignore these 2 addresses.
*/

`include "branchcodedef.v"

module pcaddrmux(input wire [31:0] jumpaddr,
                 input wire [31:0] branchaddr,
                 input wire [1:0] branchcode,
                 output reg pcload, // this pin will connect to PC load
                 output reg [31:0] pcaddr);

always @(*) begin
    case (branchcode)
        `NOLOAD: pcload = 0;
        `SELJUMP: begin
                    pcaddr = jumpaddr;
                    pcload = 1;
                  end
        `SELBRANCH: begin
                        pcaddr = branchaddr;
                        pcload = 1;
                    end
        default: pcload = 0;
    endcase
end

endmodule
