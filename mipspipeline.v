/*
* File Name: mipspipeline.v
* Function: this is the main file of MIPS single clocked architecture CPU,
* to understand the datapath one can view the file
* ./datapth_singleclock.drawio
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

// write port for register file module, this is a control signal
wire ctrlregwr;
// register file data input instance
wire [REGDWIDTH-1:0] regdinins;
wire [4:0] regwraddrins;
// register file data output instances
wire [REGDWIDTH-1:0] regdout1ins;
wire [REGDWIDTH-1:0] regdout2ins;

regfile #(.DWIDTH(REGDWIDTH)) regfileins (
        .clk(clk),
        .wr(ctrlregwr),
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
                .memtoregout(idexmemtoregout),
                .regwrout(idexregwrout),
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
                          .regwr(idexregwrin));

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

wire [31:0] aluresult;
wire [31:0] aluforwardout1;
wire [31:0] aluforwardout2;

// this instance is placed at ALU's 1st operand
aluforwardingmux aluforwardingmuxins1 (.aluforward(foraluforward1),
                                       .regdata(alualtsrcout),
                                       .aluresult(aluresult),
                                       .dmresult(regdinins),
                                       .out(aluforwardout1)); 

// this instance is placed at ALU's 2nd operand
aluforwardingmux aluforwardingmuxins2 (.aluforward(foraluforward2),
                                       .regdata(alusrcout),
                                       .aluresult(aluresult),
                                       .dmresult(regdinins),
                                       .out(aluforwardout2));

endmodule
