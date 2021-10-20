/*
* File Name: mipspipeline.v
* Function: this is the main file of MIPS pipeline architecture CPU,
* to understand the datapath one can view the file
* ./datapath_pipelining.drawio
* The CPU has 2 inputs, 1st is clock signal, 2nd is reset signal, which is
* active LOW, while reset signal is asserted the PC will always output 0,
* which results that CPU will stalk at 1st instruction
*/

`include "./COUNTER/counterpip.v"
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
`include "./Unstalling/unstallingunit.v"
`include "./PipRegs/ifidreg.v"
`include "./PipRegs/idexreg.v"
`include "./MUX/CtrlSigMUX/ctrlsigmux.v"
`include "./MUX/ALUForwardingMUX/aluforwardingmux.v"
`include "./PipRegs/exmemreg.v"
`include "./MUX/MemDataMUX/memdatamux.v"
`include "./HazardDetectionUnit/hazarddetectionunit.v"
`include "./ForwardingUnit/forwardingunit.v"

module mipspipeline( input wire clk,
                       input wire pcclr,
                       output wire fin);

parameter PCDATAWIDTH = 32; // instruction memory address has 32bit width
// instruction memory has capacity of 1028 instructions
parameter PCUPPERLIMIT = 4096; 

// data_in port for PC
wire [PCDATAWIDTH-1:0] pcaddress;
// en0 port for PC, this pin is controled by output of Unstalling Unit
wire unstallingout;
// en1 port of PC, it is controled by hazard detection unit, active HIGH
wire hazpcen;
// load port for PC
wire pcload;
// current pc address and next address port for PC
wire [PCDATAWIDTH-1:0] pcdata_out;
wire [PCDATAWIDTH-1:0] pcdata_out_next;

counterpip #(.DATAWIDTH(PCDATAWIDTH), .UPPERLIMIT(PCUPPERLIMIT)) PC (
        .clr(pcclr),
        .clk(clk),
        .data_in(pcaddress),
        .en0(unstallingout),
        .en1(hazpcen),
        .load(pcload),
        .data_out(pcdata_out),
        .data_out_next(pcdata_out_next));

// PCEn port of Unstalling Unit, is it connected to PCEn control signal of 
// control unit
wire ctrlpcen; 
unstallingunit unstallingunitins (ctrlpcen, unstallingout);

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

parameter IFIDAWIDTH = PCDATAWIDTH;
parameter IFIDINSWIDTH = INSMEMDWIDTH;

// insout port for module IF/ID pipeline register
wire [IFIDINSWIDTH-1:0] ifidinsout;
// pcnextout port for module IF/ID pipeline register
wire [IFIDAWIDTH-1:0] ifidpcnextout;

// IF/ID pipeline register instance
ifidreg #(.INSWIDTH(IFIDINSWIDTH), .AWIDTH(IFIDAWIDTH)) 
    ifidregins (.clk(clk),
                .insin(insmemins),
                .pcnextin(pcdata_out_next),
                .insout(ifidinsout),
                .pcnextout(ifidpcnextout));



parameter REGDWIDTH = INSMEMDWIDTH;

// this control signal is supplied by MEM/WB pipeline register
wire memwbregwrout;
// register file data input instance
wire [REGDWIDTH-1:0] regdinins;
wire [4:0] regwraddrins;
// register file data output instances
wire [REGDWIDTH-1:0] regdout1ins;
wire [REGDWIDTH-1:0] regdout2ins;

regfile #(.DWIDTH(REGDWIDTH)) regfileins (
        .clk(clk),
        .wr(memwbregwrout),
        .rdaddr1(ifidinsout[25:21]),
        .rdaddr2(ifidinsout[20:16]),
        .wraddr(regwraddrins),
        .din(regdinins),
        .dout1(regdout1ins),
        .dout2(regdout2ins));


parameter EXINWIDTH = 16;
parameter EXOUTWIDTH = REGDWIDTH;

// data output port for signedextend
wire [EXOUTWIDTH-1:0] exdout;

signedextend #(.INWIDTH(EXINWIDTH), .OUTWIDTH(EXOUTWIDTH)) extendins (
            .din(ifidinsout[15:0]),
            .dout(exdout));


// ID/EX pipeline register instance 
parameter IDEXDWIDTH = REGDWIDTH;
parameter IDEXAWIDTH = IFIDAWIDTH;

// ID/EX EX stage control signals ports
wire idexalualtsrcin, idexalualtsrcout;
wire [1:0] idexalusrcin;
wire [1:0] idexalusrcout;
wire [1:0] idexregdstin;
wire [1:0] idexregdstout;
wire [2:0] idexaluopin;
wire [2:0] idexaluopout;
// ID/EX MEM stage control signals ports
wire idexmemwrin, idexmemwrout, idexmemrdin, idexmemrdout;
wire idexbbnein, idexbbneout, idexbbeqin, idexbbeqout;
wire idexbblezin, idexbblezout, idexbbgtzin, idexbbgtzout;
wire idexjumpin, idexjumpout;
// ID/EX WB stage control signals ports
wire [1:0] idexmemtoregin;
wire [1:0] idexmemtoregout;
wire idexregwrin, idexregwrout;
wire idexfinin, idexfinout;

wire [IDEXDWIDTH-1:0] idexregdata1out;
wire [IDEXDWIDTH-1:0] idexregdata2out;
wire [EXOUTWIDTH-1:0] idexsignexout;
wire [5:0] idexfunctout;
wire [4:0] idexrtout;
wire [4:0] idexrsout;
wire [4:0] idexrdout;
wire [IDEXAWIDTH-1:0] idexbranaddrin;
wire [IDEXAWIDTH-1:0] idexbranaddrout;
wire [IDEXAWIDTH-1:0] idexjmpaddrin;
wire [IDEXAWIDTH-1:0] idexjmpaddrout;
wire [IDEXAWIDTH-1:0] idexpcnextout;

// branch address and jump address calculation
assign idexbranaddrin = (exdout << 2) + ifidpcnextout;
assign idexjmpaddrin = {ifidpcnextout[31:28], ifidinsout[25:0], 2'b00};


idexreg #(.DWIDTH(IDEXDWIDTH), .AWIDTH(IDEXAWIDTH))
    idexregins (.clk(clk),
                .alualtsrcin(idexalualtsrcin),
                .alusrcin(idexalusrcin),
                .regdstin(idexregdstin),
                .aluopin(idexaluopin),
                .alualtsrcout(idexalualtsrcout),
                .alusrcout(idexalusrcout),
                .regdstout(idexregdstout),
                .aluopout(idexaluopout),
                .memwrin(idexmemwrin),
                .memrdin(idexmemrdin),
                .bbnein(idexbbnein),
                .bbeqin(idexbbeqin),
                .bblezin(idexbblezin),
                .bbgtzin(idexbbgtzin),
                .jumpin(idexjumpin),
                .memwrout(idexmemwrout),
                .memrdout(idexmemrdout),
                .bbneout(idexbbneout),
                .bbeqout(idexbbeqout),
                .bblezout(idexbblezout),
                .bbgtzout(idexbbgtzout),
                .jumpout(idexjumpout),
                .memtoregin(idexmemtoregin),
                .regwrin(idexregwrin),
                .finin(idexfinin),
                .memtoregout(idexmemtoregout),
                .regwrout(idexregwrout),
                .finout(idexfinout),
                .regdata1in(regdout1ins),
                .regdata2in(regdout2ins),
                .signexin(exdout),
                .functin(ifidinsout[5:0]),
                .rtin(ifidinsout[20:16]),
                .rsin(ifidinsout[25:21]),
                .rdin(ifidinsout[15:11]),
                .pcnextin(ifidpcnextout),
                .branaddrin(idexbranaddrin),
                .jmpaddrin(idexjmpaddrin),
                .regdata1out(idexregdata1out),
                .regdata2out(idexregdata2out),
                .signexout(idexsignexout),
                .functout(idexfunctout),
                .rtout(idexrtout),
                .rsout(idexrsout),
                .rdout(idexrdout),
                .pcnextout(idexpcnextout),
                .branaddrout(idexbranaddrout),
                .jmpaddrout(idexjmpaddrout));


// CtrlSigMUX instance
// ctrlsig port, this signal is controled by hazard detection unit
wire hazctrlsig;
// they are controled by control unit
wire ctrlalualtsrc;
wire [1:0] ctrlalusrc;
wire [1:0] ctrlregdst;
wire [2:0] ctrlaluop;
wire ctrlmemwr;
wire ctrlmemrd;
wire ctrlbbne;
wire ctrlbbeq;
wire ctrlbblez;
wire ctrlbbgtz;
wire ctrljump;
wire [1:0] ctrlmemtoreg;
wire ctrlregwr;
wire ctrlfin;

ctrlsigmux ctrlsigmuxins (.ctrlsig(hazctrlsig),
                          .ctrlalualtsrc(ctrlalualtsrc),
                          .ctrlalusrc(ctrlalusrc),
                          .ctrlregdst(ctrlregdst),
                          .ctrlaluop(ctrlaluop),
                          .ctrlmemwr(ctrlmemwr),
                          .ctrlmemrd(ctrlmemrd),
                          .ctrlbbne(ctrlbbne),
                          .ctrlbbeq(ctrlbbeq),
                          .ctrlbblez(ctrlbblez),
                          .ctrlbbgtz(ctrlbbgtz),
                          .ctrljump(ctrljump),
                          .ctrlmemtoreg(ctrlmemtoreg),
                          .ctrlregwr(ctrlregwr),
                          .ctrlfin(ctrlfin),
                          .alualtsrc(idexalualtsrcin),
                          .alusrc(idexalusrcin),
                          .regdst(idexregdstin),
                          .aluop(idexaluopin),
                          .memwr(idexmemwrin),
                          .memrd(idexmemrdin),
                          .bbne(idexbbnein),
                          .bbeq(idexbbeqin),
                          .bblez(idexbblezin),
                          .bbgtz(idexbbgtzin),
                          .jump(idexjumpin),
                          .memtoreg(idexmemtoregin),
                          .regwr(idexregwrin),
                          .fin(idexfinin) );

// ALUAltSrcMUX instance
// mux output port
wire [31:0] alualtsrcout;

alualtsrcmux alualtsrcmuxins (.regsrc(idexregdata1out),
                              .immsrc(idexsignexout),
                              .alualtsrc(idexalualtsrcout),
                              .operand(alualtsrcout));

// ALUSrcMUX instance
// mux output port
wire [31:0] alusrcout;

alusrcmux alusrcmuxins (.regsrc(idexregdata2out),
                        .immsrc(idexsignexout),
                        .operand(alusrcout),
                        .alusrc(idexalusrcout));


// RegDstMUX instance
// mux output port
wire [4:0] regdstout;

regdstmux regdstmuxins (.rdstaddr(idexrdout),
                        .idstaddr(idexrtout),
                        .regdst(idexregdstout),
                        .dstaddr(regdstout));


// 2 ALUForwardingMUX instances
// this group of signal is controled by forwarding unit
wire [1:0] foraluforward1;
wire [1:0] foraluforward2;

wire [31:0] exmemaluresultout;
wire [31:0] aluforwardout1;
wire [31:0] aluforwardout2;

// this instance is placed at ALU's 1st operand
aluforwardingmux aluforwardingmuxins1 (.aluforward(foraluforward1),
                                       .regdata(alualtsrcout),
                                       .aluresult(exmemaluresultout),
                                       .dmresult(regdinins),
                                       .out(aluforwardout1)); 

// this instance is placed at ALU's 2nd operand
aluforwardingmux aluforwardingmuxins2 (.aluforward(foraluforward2),
                                       .regdata(alusrcout),
                                       .aluresult(exmemaluresultout),
                                       .dmresult(regdinins),
                                       .out(aluforwardout2));


// ALU Control Unit instance
// instance output port
wire [3:0] aluctrlout;

aluctrl aluctrlins (.aluop(idexaluopout),
                    .funct(idexfunctout),
                    .opcodeforalu(aluctrlout));

// ALU instance
// instance output ports
wire [31:0] aluresult;
wire aluzero, aluoverflow, alunegative;

alu aluins (.op(aluctrlout),
            .A(aluforwardout1),
            .B(aluforwardout2),
            .out(aluresult),
            .zero(aluzero),
            .overflow(aluoverflow),
            .negative(alunegative));



// EX/MEM pipeline register instance
// MEM control signals output ports
wire exmemmemwrout, exmemmemrdout;
wire exmembbneout, exmembbeqout, exmembblezout, exmembbgtzout;
wire exmemjumpout;

// WB control signals output ports
wire [1:0] exmemmemtoregout;
wire exmemregwrout;
wire exmemfinout;

wire exmemzeroout, exmemnegativeout, exmemoverflowout;
wire [4:0] exmemregdstmuxout;
wire [31:0] exmemregdata2out;
wire [31:0] exmembranaddrout;
wire [31:0] exmemjmpaddrout;
wire [4:0] exmemrtout;
wire [31:0] exmempcnextout;

exmemreg exmemregins (.clk(clk),
                      .memwrin(idexmemwrout),
                      .memrdin(idexmemrdout),
                      .bbnein(idexbbneout),
                      .bblezin(idexbblezout),
                      .bbgtzin(idexbbgtzout),
                      .jumpin(idexjumpout),
                      .memwrout(exmemmemwrout),
                      .memrdout(exmemmemrdout),
                      .bbneout(exmembbneout),
                      .bbeqout(exmembbeqout),
                      .bblezout(exmembblezout),
                      .bbgtzout(exmembbgtzout),
                      .jumpout(exmemjumpout),
                      .memtoregin(idexmemtoregout),
                      .regwrin(idexregwrout),
                      .finin(idexfinout),
                      .memtoregout(exmemmemtoregout),
                      .regwrout(exmemregwrout),
                      .finout(exmemfinout),
                      .aluoutin(aluresult),
                      .zeroin(aluzero),
                      .negativein(alunegative),
                      .overflowin(aluoverflow),
                      .regdstmuxin(regdstout),
                      .regdata2in(idexregdata2out),
                      .branaddrin(idexbranaddrout),
                      .jmpaddrin(idexjmpaddrout),
                      .pcnextin(idexpcnextout),
                      .rtin(idexrtout),
                      .aluoutout(exmemaluresultout),
                      .zeroout(exmemzeroout),
                      .negativeout(exmemnegativeout), 
                      .overflowout(exmemoverflowout),
                      .regdstmuxout(exmemregdstmuxout),
                      .regdata2out(exmemregdata2out),
                      .branaddrout(exmembranaddrout),
                      .jmpaddrout(exmemjmpaddrout),
                      .rtout(exmemrtout),
                      .pcnextout(exmempcnextout));




// MemDataMUX instance
// select pin port, this signal is controled by forwarding unit
wire formemdata;

wire [31:0] memwbdmdataout;
wire [31:0] memdatamuxout;

memdatamux memdatamuxins (.regdata(exmemregdata2out),
                          .memdata(formemdata),
                          .dmdata(regdinins),
                          .out(memdatamuxout));


// Data Memory instance
parameter DMDEPTH = 10240;

// data output port
wire [31:0] dmdataout;

sram #(.DEPTH(DMDEPTH)) datamem (.clk(clk),
                                 .address(exmemaluresultout),
                                 .din(memdatamuxout),
                                 .dout(dmdataout),
                                 .rd(exmemmemrdout),
                                 .wr(exmemmemwrout),
                                 .cs(1'b1));



// Branch and Jump Control Unit instance
// output port
wire [1:0] branchctrlout;

branchctrl branctrlins (.zero(exmemzeroout),
                        .negative(exmemnegativeout),
                        .overflow(exmemoverflowout),
                        .jump(exmemjumpout),
                        .branchbeq(exmembbeqout),
                        .branchbne(exmembbneout),
                        .branchblez(exmembblezout),
                        .branchbgtz(exmembbgtzout),
                        .out(branchctrlout));



// PCAddrMUX instance
pcaddrmux pcaddrmuxins (.jumpaddr(exmemjmpaddrout),
                        .branchaddr(exmembranaddrout),
                        .branchcode(branchctrlout),
                        .pcload(pcload),
                        .pcaddr(pcaddress));



// MEM/WB pipeline register
// data output ports
wire [1:0] memwbmemtoregout;
wire [31:0] memwbaluoutout;
wire [31:0] memwbpcnextout;
wire memwbnegativeout;

memwbreg memwbregins (.clk(clk),
                      .memtoregin(exmemmemtoregout),
                      .regwrin(exmemregwrout),
                      .finin(exmemfinout),
                      .memtoregout(memwbmemtoregout),
                      .regwrout(memwbregwrout),
                      .finout(fin),
                      .regdstmuxin(exmemregdstmuxout),
                      .aluoutin(exmemaluresultout),
                      .dmdatain(dmdataout),
                      .pcnextin(exmempcnextout),
                      .negativein(exmemnegativeout),
                      .regdstmuxout(regwraddrins),
                      .aluoutout(memwbaluoutout),
                      .dmdataout(memwbdmdataout),
                      .pcnextout(memwbpcnextout),
                      .negativeout(memwbnegativeout));



// RegSrcMUX instance
regsrcmux regsrcmuxins (.memdata(memwbdmdataout),
                        .aludata(memwbaluoutout),
                        .pcdata(memwbpcnextout),
                        .negative(memwbnegativeout),
                        .memtoreg(memwbmemtoregout),
                        .regdata(regdinins));



// Control Unit instance
ctrlunit ctrlunitins (.opcode(ifidinsout),
                      .RegDst(ctrlregdst),
                      .RegWr(ctrlregwr),
                      .ALUSrc(ctrlalusrc),
                      .MemWr(ctrlmemwr),
                      .MemRd(ctrlmemrd),
                      .MemtoReg(ctrlmemtoreg),
                      .Jump(ctrljump),
                      .BBeq(ctrlbbeq),
                      .BBne(ctrlbbne),
                      .BBlez(ctrlbblez),
                      .BBgtz(ctrlbbgtz),
                      .ALUOp(ctrlaluop),
                      .ALUAltSrc(ctrlalualtsrc),
                      .Fin(ctrlfin),
                      .PCEn(ctrlpcen));


// Forwarding Unit instance
forwardingunit forwardingunitins (.exmemregwr(exmemregwrout),
                                  .exmemregmuxout(exmemregdstmuxout),
                                  .idexrs(idexrsout),
                                  .idexrt(idexrtout),
                                  .memwbregwr(memwbregwrout),
                                  .memwbregmuxout(regwraddrins),
                                  .exmemrt(exmemrtout),
                                  .exmemmemwr(exmemmemwrout),
                                  .aluforward1(foraluforward1),
                                  .aluforward2(foraluforward2),
                                  .memdata(formemdata));



// Hazard Detection Unit instance
hazarddetectionunit hazarddetectionunitins (.idexrt(idexrtout),
                                            .ifidrs(ifidinsout[25:21]),
                                            .ifidrt(ifidinsout[20:16]),
                                            .idexmemrd(idexmemrdout),
                                            .pcen(hazpcen),
                                            .ctrlsig(hazctrlsig));

endmodule
