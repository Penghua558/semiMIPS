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

// we deploy 2 internal variables, unit's output will first be passed to
// these variables, then through a simple x check, if the variables' content
// is x, then we modify unit's actual outputs to known states. This is due
// to the same reason we use insert Unstalling Unit bewtween PC and Control
// Unit.
reg pcentmp, ctrlsigtmp;

initial begin
    pcen = 1'b1;
    ctrlsig = 1'b0;
end

always @(pcentmp, ctrlsigtmp) begin
    if (pcentmp === 1'bx) begin
        pcen = 1'b1;
    end else begin
        pcen = pcentmp;
    end

    if (ctrlsigtmp === 1'bx) begin
        ctrlsig = 1'b0;
    end else begin
        ctrlsig = ctrlsigtmp;
    end
end

always @(*) begin
    // hazard detection
    if (idexmemrd &&
        ((idexrt == ifidrt) || (idexrt == ifidrs))) begin
        pcentmp = 1'b0;
        ctrlsigtmp = 1'b1;
    end else begin
        pcentmp = 1'b1;
        ctrlsigtmp = 1'b0;
    end
end

endmodule
