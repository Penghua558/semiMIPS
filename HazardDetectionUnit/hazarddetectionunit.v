/*
* File Name: hazarddetectionunit.v
* Function: this module's job is to detect bubble required data hazard then
* insert a bubble by mataining both PC and IF/ID pipeline register's states
* , and by supplying NOP operation control signals to ID/EX pipeline 
* register.
*/

module hazarddetectionunit ( input wire [4:0] idexrt,
                             input wire [4:0] ifidrs,
                             input wire [4:0] ifidrt,
                             input wire idexmemrd,
                             output reg pcen,
                             output reg ctrlsig );

always @(*) begin
    pcen = 1'b1;
    ctrlsig = 1'b0;
    
    // hazard detection
    if (idexmemrd &&
        ((idexrt == ifidrt) || (idexrt == ifidrs))) begin
        pcen = 1'b0;
        ctrlsig = 1'b1;
    end
end

endmodule
