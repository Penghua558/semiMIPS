/*
* File Name: signedextend.v
* Function: this is a module to do signed extension operation on a given
* data. The default input data width is 16bit, output data width is 32bit.
*/

module signedextend #(parameter INWIDTH = 16, parameter OUTWIDTH = 32)(
                        input wire [INWIDTH-1:0] din,
                        output reg [OUTWIDTH-1:0] dout);

always @(din) begin
    dout = {{(OUTWIDTH-INWIDTH){din[INWIDTH-1]}}, din};
end

endmodule
