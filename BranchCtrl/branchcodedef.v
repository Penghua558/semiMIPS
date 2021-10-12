/*
* File Name: branchcodedef.v
* Function: this file contains only macros for branch control module, macros
* define which code represents which address selection case
*/

`define NOLOAD 2'b00 // no PC address load, in other word, no jump, no branch
`define SELJUMP 2'b01 // choose address from jump instructions
`define SELBRANCH 2'b10 // choose address from branch instructions
