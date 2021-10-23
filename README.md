# semiMIPS
This project is to develop a 32 bit MIPS architecture CPU, the main purpose to develop such project is to improve my Verilog language skill and digital circuit
design skill. The repository contains two different implementation version of MIPS CPU, the first one I made is single clocked implementaion, the 2nd one I made
is 5-stages pipelined implementaion.

## Contents
1. [Contents](#contents)<br>
2. [Resources](#resources)
3. [How to Use Tt](#how-to-use-it)
4. [Supported Instructions](#supported-instructions)
5. [Repository Files & Directories Explain](#repository-files--directories-explain)


## Resources
The book I used during the development is 
[*Computer Organization and Design MIPS Edition: The Hardware/Software Interface* by John L. Hennessy](https://www.amazon.com/Computer-Organization-Design-MIPS-Architecture/dp/0124077269).<br>
During the development of ISA I used this [website](https://en.wikibooks.org/wiki/MIPS_Assembly/Instruction_Formats) to help me to assign opcodes to each
instruction.

## How to Use It
You need to have`icarus verilog` installed on your machine, this project is entirely complied and simulated via `icarus verilog`.<br>
After cloning the repository into your local machine, `cd` into the root directory of the repository, then<br>
**for single clocked implementation CPU** execute:

    iverilog -c -cmd_file_singleclk -o <file output name>
**for 5-stages pipelined  implementation CPU** execute:

    iverilog -c -cmd_file_pipeline -o <file output name>
To simulate models, execute:

    vvp <file output name>
After the simulation completed, a `.vcd` file will be generated in the root of the repository which can be used by a wave viewr program to inspect waveforms of
the simulation, depends on the implementation you chose to complie, the file name of `.vcd` file is either `testsingleclk.vcp` or `testpipeline.vcp`. Along side
with the `.vcd` file, there will also be a memory file named `datamem.lst`, which contains memory content of the selected addresses after the program is finished,
at default testbench only prints the contents of `@4, @16` and `@64` into the memory file.<br>

Directory `TestMemoryFiles/` contains all the programs which was written in machine lanaguage that I used during testing. Their format used essentially
memory files that Verilog can recognize, during simulation, testbench will load one of them into CPU's instruction memory then start executing program. So if you
want to change the program the CPU is running, open testbench file either `mipssingleclk_tb.v` or `mipspipeline_tb.v`, which depends on which implementaion you
are dealing with, modified the code line below to match the program filename that you want to run:

    $readmemb("./TestMemoryFiles/pipctrlhaz.lst", dut.insmem.mem);
then recomplie the testbench file. The ISA and its opcode used here is identical with MIPS ISA, except some instructions are not implemented, including
floating point related instructions, etc.

## Supported Instructions
The details about supported instructions and their correspoding opcode field and funct code field can be found in files `CtrlUnit/opcode.v` and `ALUCtrl/funct.v`
respectively, noted some of them is not supported by my CPU's current datapath even though they are list in files, those are not supported has comment beside 
them with content that basically saying "it's not supported" or something like that.

## Repository Files & Directories Explain
directory `ALU/`<br>
the directory contains module file and its testbench file of component ALU, along 
with its complie file `cmd_file`. File `aluopdef.v` contains ALU op macros, since
ALU is not controled directly by main control unit here, rather it is directly
controled by a small combo module to tell ALU which operation to choose.<br>

directory `ALUCtrl/`<br>
the directory contains module that directly controls ALU, it receives control
signals from main control unit and funct field of instruction then decode them
to tell ALU exactly which operation to choose. File `funct.v` contains macros 
about funct field code and its corresponding R-type arithmetic operation.<br>

directory `BranchCtrl/`<br>
the module in here controls when to load a new PC address and which PC address
should be loaded into PC. It receives flags from ALU and several jump and branch
related control signals from main control unit, then it delivers its output to 
a MUX to select correct PC address and asserting PC load signal if necessary.<br>

directory `ControlHazardUnit/`<br>
It is only been deployed in pipeline implementaion, like the name suggests, 
it contains module Control Hazard Unit, whose main job
is to detect control hazard and resolve it.<br>

directory `COUNTER/`<br>
It contains 2 different PCs, `counter.v` is for single clocked implementaion,
`counterpip.v` is for pipeline implementaion, the only difference is pipelien
PC has an extra enable pin which is controled by Hazard Detection Unit, so
when such data hazard happens that forwarding can not solve it, then the unit can
disabling PC by deasserting PC's enable pin.<br>

directory `CtrlUnit/`<br>
It contains main control unit, the module file has details about what control 
signals the CPU has and what does each one of them do. File `opcode.v` contains
macros of instructions' opcode definition.<br>


directory `ForwardingUnit/`<br>
It is only deployed in pipeline implementation. It detects data hazard and 
uses forwarding to resolve data conflicts.<br>

directory `HazardDetectionUnit/`<br>
It is only deployed in pipeline implementation. It detects data hazard which 
can not be solved by forwarding and insert bubble (stalling) to try to resolve
it.<br>

directory `MUX/`<br>
It contains all the muxes that are used in this project, by controlling different
control signals you can control different mux to select different data input.
It is used to achieve compatible datapath with various instructions and 
forwarding datapath.<br>

directory `PipRegs/`<br>
It is only deployed in pipeline implementation. It contanis 4 pipeline registers.
<br>

directory `SignedExtend/`<br>
The module in here extends a 16 bit data to 32 bit data while preseving its sign.
<br>

directory `SRAM/`<br>
The SRAM module here is both been used as instruction memory and data memory.<br>

directroy `TestMemoryFiles/`<br>
It contains programs that can be run by the CPU, they are stored in memory file
format which Verilog can recognize.<br>

directory `Unstalling/`<br>
It is only deployed in pipeline implementation. 
The module here is placed between PC and main control unit, because ID stage is
at 2nd clock cycle of an instrcution lifetime, so at the very start of program
there will be no valid PC enable signal to feed into PC to keep PC running, in
a result the program will suffer stalling forever at the very start of program,
the resolution is this module, which will ensure PC to keep running during the
1st instruction lifetime.<br>

file `datapath_pipelining.drawio` and `datapath_singleclock.drawio`<br>
They are vectored image files that represents pipeline and single clocked 
datapath respectively, you can view and edit them on 
[diagrams](https://app.diagrams.net/).<br>
