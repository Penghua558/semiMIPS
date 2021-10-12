/*
* File Name: pc.v
* Function: this is a synchronous counter, with parameterimized input data
* width and count range and synchronous load pin, asynchronous clear pin,
* active LOW,
* which will reset counter's state to all 0s, it also comes with en pin,
* active HIGH, without it been set the counter will not count. The counter
* comes with a default 32 bit data width, and can count up to 4096.
*/

module counter(data_in, en, clr, clk, load, data_out, data_out_next);
parameter DATAWIDTH = 32;
parameter UPPERLIMIT = 4096;

input wire [DATAWIDTH-1:0] data_in;
input wire en;
input wire clr;
input wire clk;
input wire load;
output reg [DATAWIDTH-1:0] data_out;
// this is the next output of current counter output
output reg [DATAWIDTH-1:0] data_out_next; 

always @(posedge clk, negedge clr) begin
    // asynchronous reset
    if (clr == 1'b0) begin
        data_out <= 0;
    end else begin
        if (en == 1'b1) begin
            // load case
            if (load == 1'b1) begin
                data_out <= data_in;
            end else begin
                // counter reaches count upper limit
                if (data_out >= UPPERLIMIT) begin
                    data_out <= 0;
                // counter not yet reaches count upper limit
                end else begin
                    data_out <= data_out + 4;
                end
            end
        end
    end
end

always @(data_out) begin
    if (data_out >= UPPERLIMIT) begin
        data_out_next = 0;
    end else begin
        data_out_next = data_out + 4;
    end
end

endmodule
