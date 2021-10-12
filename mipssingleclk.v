/*
* File Name: mipssingleclk.v
* Function: this is the main file of MIPS single clocked architecture CPU,
* to understand the datapath one can view the file
* ./datapth_singleclock.drawio
* The CPU has 2 inputs, 1st is clock signal, 2nd is reset signal, which is
* active LOW, while reset signal is asserted the PC will always output 0,
* which results that CPU will stalk at 1st instruction
*/

`include "./COUNTER/counter.v"
`include "./SRAM/sram.v"
`include "./MUX/RegDstMUX/regdstmux.v"
`include "./RegFile/regfile.v"
`include "./SignedExtend/signedextend.v"
`include "./ALUCtrl/aluctrl.v"
`include "./MUX/ALUAltSrcMUX/alualtsrcmux.v"
`include "./MUX/ALUSrcMUX/alusrcmux.v"
`include "./ALU/alu.v"
`include "./MUX/RegSrcMUX/regsrcmux.v"
`include "./BranchCtrl/branchctrl.v"
`include "./MUX/PCAddrMUX/pcaddrmux.v"
`include "./CtrlUnit/ctrlunit.v"

module mipssingleclk( input wire clk,
                       input wire pcclr,
                       output wire fin);

parameter PCDATAWIDTH = 32; // instruction memory address has 32bit width
// instruction memory has capacity of 1028 instructions
parameter PCUPPERLIMIT = 4096; 

// data_in port for PC
wire [PCDATAWIDTH-1:0] pcaddress;
// en port of PC, it is controled by control unit, active HIGH
wire ctrlpcen;
// load port for PC
wire pcload;
// current pc address and next address port for PC
wire [PCDATAWIDTH-1:0] pcdata_out;
wire [PCDATAWIDTH-1:0] pcdata_out_next;

counter #(.DATAWIDTH(PCDATAWIDTH), .UPPERLIMIT(PCUPPERLIMIT)) PC (
        .clr(pcclr),
        .clk(clk),
        .data_in(pcaddress),
        .en(ctrlpcen),
        .load(pcload),
        .data_out(pcdata_out),
        .data_out_next(pcdata_out_next));

parameter INSMEMAWIDTH = PCDATAWIDTH;
parameter INSMEMDWIDTH = 32;
parameter INSMEMDEPTH = PCUPPERLIMIT/4;

// instruction from instruction memory
wire [INSMEMDWIDTH-1:0] insmemins;

// instruction memory instance
sram #(.AWIDTH(INSMEMAWIDTH), .DWIDTH(INSMEMDWIDTH), .DEPTH(INSMEMDEPTH)) 
    insmem ( 
        .clk(clk),
        .address(pcdata_out),
        .rd(1'b1),
        .wr(1'b0),
        .cs(1'b1),
        .dout(insmemins),
        .din('b0));


// 2bit width signal for regdstmux, this is a control signal
wire [1:0] ctrlregdst;
// write register address instance
wire [4:0] dstaddrins;

regdstmux regdstmuxins (
        .rdstaddr(insmemins[15:11]),
        .idstaddr(insmemins[20:16]),
        .regdst(ctrlregdst),
        .dstaddr(dstaddrins));


parameter REGDWIDTH = INSMEMDWIDTH;

// write port for register file module, this is a control signal
wire ctrlregwr;
// register file data input instance
wire [REGDWIDTH-1:0] regdinins;
// register file data output instances
wire [REGDWIDTH-1:0] regdout1ins;
wire [REGDWIDTH-1:0] regdout2ins;

regfile #(.DWIDTH(REGDWIDTH)) regfileins (
        .clk(clk),
        .wr(ctrlregwr),
        .rdaddr1(insmemins[25:21]),
        .rdaddr2(insmemins[20:16]),
        .wraddr(dstaddrins),
        .din(regdinins),
        .dout1(regdout1ins),
        .dout2(regdout2ins));


parameter EXINWIDTH = 16;
parameter EXOUTWIDTH = REGDWIDTH;

// data output port for signedextend
wire [EXOUTWIDTH-1:0] exdout;

signedextend #(.INWIDTH(EXINWIDTH), .OUTWIDTH(EXOUTWIDTH)) extendins (
            .din(insmemins[15:0]),
            .dout(exdout));


// ALUOp signal group, 3bit width, this is a control signal
wire [2:0] ctrlaluop;
// ALUOpcode for ALU directly port
wire [3:0] aluopcodeins;

aluctrl aluctrlins (
        .aluop(ctrlaluop),
        .funct(insmemins[5:0]),
        .opcodeforalu(aluopcodeins));


// ALU alternative source signal port, this is a control signal
wire ctrlalualtsrc;
// operand A for ALU
wire [REGDWIDTH-1:0] operandA;

alualtsrcmux alualtsrcmuxins (
        .regsrc(regdout1ins),
        .immsrc(exdout),
        .alualtsrc(ctrlalualtsrc),
        .operand(operandA));


// ALU source port, this is a control signal
wire [1:0] ctrlalusrc;
// operand B for ALU
wire [REGDWIDTH-1:0] operandB;

alusrcmux alusrcmuxins (
        .regsrc(regdout2ins),
        .immsrc(exdout),
        .alusrc(ctrlalusrc),
        .operand(operandB));


// ALU result
wire [31:0] aluout;
// flags of ALU ports
wire zeroins, negativeins, overflowins;

alu ALU (
        .A(operandA),
        .B(operandB),
        .op(aluopcodeins),
        .out(aluout),
        .zero(zeroins),
        .negative(negativeins),
        .overflow(overflowins));


parameter DATAMEMDWITH = REGDWIDTH;
// data out for data memory port
wire [DATAMEMDWITH-1:0] datamemdout;
// controls data memory's read and write behaviours, they are control signals
wire ctrldmemwr, ctrldmemrd;

sram #(.DWIDTH(DATAMEMDWITH)) datamem (
        .clk(clk),
        .cs(1'b1),
        .address(aluout),
        .din(regdout2ins),
        .dout(datamemdout),
        .wr(ctrldmemwr),
        .rd(ctrldmemrd));


// controls which data should be written into register, this is a control
// signal
wire [1:0] ctrlmemtoreg;

regsrcmux regsrcmuxins (
        .memdata(datamemdout),
        .negative(negativeins),
        .aludata(aluout),
        .pcdata(pcdata_out_next),
        .memtoreg(ctrlmemtoreg),
        .regdata(regdinins));


// controls whether CPU should jump or not, they are all control signals
wire ctrljump, ctrlbbeq, ctrlbbne, ctrlbblez, ctrlbbgtz;
// branch and jump control unit's output port
wire [1:0] branchout;

branchctrl branchctrlins (
        .zero(zeroins),
        .negative(negativeins),
        .overflow(overflowins),
        .jump(ctrljump),
        .branchbeq(ctrlbbeq),
        .branchbne(ctrlbbne),
        .branchblez(ctrlbblez),
        .branchbgtz(ctrlbbgtz),
        .out(branchout));

// branch address for branching
wire [INSMEMDWIDTH-1:0] branchaddr;
// jump address for jumping
wire [INSMEMDWIDTH-1:0] jumpaddr;

assign branchaddr = pcdata_out_next + (exdout << 2);
assign jumpaddr = {pcdata_out_next[31:28],insmemins[25:0],2'b00};

pcaddrmux pcaddrmuxins (
        .pcload(pcload),
        .pcaddr(pcaddress),
        .branchcode(branchout),
        .jumpaddr(jumpaddr),
        .branchaddr(branchaddr));


ctrlunit controlunit (
        .opcode(insmemins[31:26]),
        .RegDst(ctrlregdst),
        .RegWr(ctrlregwr),
        .ALUSrc(ctrlalusrc),
        .MemWr(ctrldmemwr),
        .MemRd(ctrldmemrd),
        .MemtoReg(ctrlmemtoreg),
        .Jump(ctrljump),
        .BBeq(ctrlbbeq),
        .BBne(ctrlbbne),
        .BBlez(ctrlbblez),
        .BBgtz(ctrlbbgtz),
        .PCEn(ctrlpcen),
        .ALUOp(ctrlaluop),
        .ALUAltSrc(ctrlalualtsrc),
        .Fin(fin));

endmodule
