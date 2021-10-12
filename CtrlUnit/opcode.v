/*
* File Name: opcode.v
* Function: this file contains the opcode for implemented instructions, 
* opcode is 6bit width.
*/

`define RTYPE  6'h00 // R-type instructions
`define JUMP   6'h02 // jump to address
`define JAL    6'h03 // jump and link
`define BEQ    6'h04 // branch if equal
`define BNE    6'h05 // branch if not equal
`define BLEZ   6'h06 // branch if less than or equal to zero
`define BGTZ   6'h07 // brach if greater than zero
`define ADDI   6'h08 // add immeidate
`define ADDIU  6'h09 // add unsigned immeidate
`define SLTI   6'h0A // set to 1 if less than immeidate

`define ANDI   6'h0C // and immeidate
`define ORI    6'h0D // or immeidate
`define LUI    6'h0F // load upper immeidate
`define LB     6'h20 // load byte, not gonna implement
`define LW     6'h23 // load word
`define SB     6'h28 // store byte, not gonna implement
`define SH     6'h29 // store half word, not gonna implement
`define SW     6'h2B // store word
`define FIN    6'h10 // signal finish control signal
