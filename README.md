# semiMIPS
This project is to develop a 32 bit MIPS architecture CPU, the main purpose to develop such project is to improve my Verilog language skill and digital circuit
design skill. The repository contains two different implementation version of MIPS CPU, the first one I made is single clocked implementaion, the 2nd one I made
is 5-stages pipelined implementaion.

## Contents
1. [Contents](#contents)<br>
2. [Resources](#resources)
3. [How to use it](#how-to-use-it)


## Resources
The book I used during the development is 
[*Computer Organization and Design MIPS Edition: The Hardware/Software Interface* by John L. Hennessy](https://www.amazon.com/Computer-Organization-Design-MIPS-Architecture/dp/0124077269).<br>
During the development of ISA I used this [website](https://en.wikibooks.org/wiki/MIPS_Assembly/Instruction_Formats) to help me to assign opcodes to each
instruction.

## How to use it
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
at default testbench only prints the contents of `@4, @16 and @64` into the memory file.<br>

Directory `TestMemoryFiles/` contains all the programs which was written in machine lanaguage that I used during testing. Their format used essentially
memory files that Verilog can recognize, during simulation, testbench will load one of them into CPU's instruction memory then start executing program. So if you
want to change the program the CPU is running, open testbench file either `mipssingleclk_tb.v` or `mipspipeline_tb.v`, which depends on which implementaion you
are dealing with, modified the code line below to match the program filename that you want to run:

    $readmemb("./TestMemoryFiles/pipctrlhaz.lst", dut.insmem.mem);
