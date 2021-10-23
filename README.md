# semiMIPS
This project is to develop a 32 bit MIPS architecture CPU, the main purpose to develop such project is to improve my Verilog language skill and digital circuit
design skill. The repository contains two different implementation version of MIPS CPU, the first one I made is single clocked implementaion, the 2nd one I made
is 5-stages pipelined implementaion.

## Contents
1. [Contents](#contents)<br>
2. [Resources](#resources)
3. [How to Use It](#how-to-use-it)
4. [Supported Instructions](#supported-instructions)
5. [Repository Files & Directories Explaination](#repository-files--directories-explaination)
6. [Pipeline Implementation Key Parts](#pipeline-implementation-key-parts)


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

## Repository Files & Directories Explaination
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
[diagrams](https://app.diagrams.net/), it's an online and free vector image
editor.<br>

file `mipspipeline_tb.v` and `mipspipeline.v`<br>
They are the testbench file and top module file for pipeline implementation.<br>

file `mipssingleclk_tb.v` and `mipssingleclk.v`<br>
They are the testbench file and top module file for single clock implementation.
<br>

file `datamem.lst`<br>
It is generated by simulation, after simulation testbench will print the
contents of selected memory addresses into this file.<br>


## Pipeline Implementation Key Parts
### Pipeline Registers
The pipeline I implemented here has 5 stages, namely IF (instruction fetch), ID(instruction decode), EX(execution), MEM(memory access) and WB(write back). They
are divided by 4 pipeline reigisters, their main job is to store critical instructon related information from previous clock cycle to make sure the instruction
can still be executed properly at next cycle at different pipeline stage. The 4 pipeline registers are IF/ID (placed between IF stage and ID stage), ID/EX (
placed between ID stage and EX stage), EX/MEM (placed between EX stage and MEM stage) and MEM/WB (placed between MEM stage and WB stage).<br>

Different pipeline register holds different informations, for example, IF/ID holds instruction and the next PC address, since ID stage only requires pipeline to
fetch correct instruction so IF/ID only need to hold 2 datas. On the other hand, ID/EX needs to hold the most data fields among 4 pipeline registers, during ID
stage, main control unit will decode the instruction obtained from IF/ID, so ID/EX need to store decoded information, aka, control signals, other than that,
ID/EX also need to store register file's read data output, Rt, Rs and Rd field, etc.<br>

Aside from this, IF/ID, ID/EX and EX/MEM has flush pins, which can zeros their control signal fields and instruction fields to produce a `nop` operation, this 
is useful when we need to discard ongoing operations or stalling CPU. IF/ID also has a write control pin, it is used to preserve its content.<br>

### Forwarding
The main issue to develop pipeline implementation is to deal with hazards, in this project I used forwarding technique to try to solve data hazard. Basically 
speaking, at normal running flow the result of an instruction will only be available after its WB stage, but sometimes other instructions demands the unavailable
results early, if the result is already ready at other stages then you can use forwarding to bypass the rest unfinished stage to put the ready result early into
use.<br>
In `TestMemoryFiles` there are 3 memory files are aim to test its forwarding capacity, I don't know how well those 3 testing programs covers the data hazard
situation, but at least current forwarding unit deployed in the CPU can solve those data hazards.<br>

### Stalling
There are one type of data hazard that forwarding can not solve, such situation is usually what the following instruction demand is not ready yet, for example,
a `lw` instruction followed by a `add` instruction, while the operand needed in `add` instruction is the same as `lw` instruction is trying to writing. Under such
circumstance, I use the stalling approach to solve it, when such data hazard is detected, CPU stalls `add` instruction to make it *wait* a clock cycle so that
the operand required can be ready in time.<br> 

By stalling, it simply means CPU repeats the same process, to achieve it I disable PC to make it stop counting so
at next clocl cycle CPU will process the same instruction, and deassert IF/ID's write pin so their instruction field can be preserved, to prevent the next 
instuction to be processed further, ID/EX's control signals field will be inserted a `nop` operation which in my case is basically a bunch of zeros so there will
be one stage that does nothing at all.

### Control Hazard
Another type of hazard that must be dealt with to make it a truly pipelined CPU/computer rather than a pipelined calculator is control hazard. When the pipeline
encounter a branch related instruction, since the test result will not be immediately ready so the CPU need to decide to take the branch or untake the branch 
at next clock cycle or rather just stall the pipeline until the result is available to make decision. I chose to predict that the branch will always be untaken,
in other words CPU will always execute instructions following the branch instruction.<br>

If branch test result later is revealed as untaken then nothing will happen, but if the test result is the branch should be taken, then what instructions the 
CPU executed during the result calculation period should be completely discarded to remove their effects, the approach to discard operation is similar with 
the approach to stalling, but the difference is instead only zeros IF/ID, you need to flush IF/ID, ID/EX and EX/MEM, because the branch test result is not 
avaible until MEM stage, meaning 3 wasted instructions have been put through pipeline, so we need to flush first 3 pipeline registers to remove their effects.<br>

Thus by doing so, every misprediction will cost 3 additional clock cycles, and it is true with jump related instruction, because 
both jump and branch instruction issue PC address load at the same stage, which makes it seems like we can improve jump instruction performance, unlike branch
instruction jump instrucion does not need to test, and both branch address and jump address can be made available during ID stage, so instead let the jump
control signal from EX/MEM to control jump I make the jump control signal directly from main control unit to control jump, so when a jump instruction is detected
, it can make the jump as early as at ID stage, which will only cost 1 additional clock cycle.
