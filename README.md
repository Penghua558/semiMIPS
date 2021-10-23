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
You need to install `icarus verilog` installed on your machine, this project is entirely complied and simulated via `icarus verilog`.<br>
After cloning the repository into your local machine, `cd` into the root directory of the repository, then<br>
**for single clocked implementaion CPU** execute:
  iverilog -c -cmd_file_single
