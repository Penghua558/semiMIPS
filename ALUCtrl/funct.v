/*
* File Name: funct.v
* Function: this file contains 6bit funct code for R-type instructions.
*/

`define FUNCT_SLL  6'h00 // logical shift left
`define FUNCT_SRL  6'h02 // logical shift right
`define FUNCT_SRA  6'h03 // arithmetic shift right
`define FUNCT_JR   6'h08 // jump register, not gonna implement
`define FUNCT_ADD  6'h20 // add
`define FUNCT_ADDU 6'h21 // add unsigned
`define FUNCT_SUB  6'h22 // subtract
`define FUNCT_SUBU 6'h23 // subtract unsigned
`define FUNCT_AND  6'h24 // and
`define FUNCT_OR   6'h25 // or
`define FUNCT_XOR  6'h26 // xor
`define FUNCT_SLT  6'h2A // set to 1 if less than
`define FUNCT_SLTU 6'h2B // set to 1 if less than unsigned
