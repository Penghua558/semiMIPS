/*
* File Name: pc_tb.v
* Function: this is a testbench file for PC(program counter), the testbench
* shall test its asynchronous reset function, then its count function to see
* if it can count up to its designed upper limit then reset to 0 
* automatically, then test its load function and test module behavior if load
* into a too large data (exceeds its upper limit).
*/

module counter_tb();
parameter DATAWIDTH = 5;
parameter UPPERLIMIT = 28;
reg [DATAWIDTH-1:0] data_in;
reg clk, en, clr, load;
wire [DATAWIDTH-1:0] data_out;

// supply clock signal
always 
    #4 clk = ~clk;

initial begin
    $dumpfile("counter.vcd");
    $dumpvars;
    clk = 0;
    data_in = 0;
    en = 1;
    clr = 0;
    load = 0;
    $display("time\t en\t clr\t load\t data_in\t data_out\t\n");
    $monitor("%g\t %b\t %b\t %b\t %d\t %d\t\n",
                $time, en, clr, load, data_in, data_out);
    #7 clr = 1;
    #68 clr = 0;
    #2 clr = 1;
    #16 en = 0;
    #8 en = 1;
    #1 data_in = 8;
    #12 load = 1;
    #12 load = 0;
    #16 data_in = 30;
    #1 load = 1;
    #8 load = 0;
    #12 $finish;
end

// DUT, device under test
counter #(.DATAWIDTH(DATAWIDTH), .UPPERLIMIT(UPPERLIMIT)) dut (
    data_in, en, clr, clk, load, data_out);
endmodule
