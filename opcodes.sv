// opcodes.sv
//-----------------------------------------------------
// File Name   : opcodes.sv
// Function    : picoMIPS opcode definitions 
//               for example 28 Feb 14
// Author:   Hoc Jen Yap
// Last rev. 19 Apr 24
//-----------------------------------------------------

// NOP
`define NOP  	3'b000
// ADD %d, %s;  %d = %d+%s
`define ADD  	3'b001
//BNE %d, %s, addr; PC = (%d!=%s? addr: PC+1)
//BNE is modified for absolute branching
`define BNE  	3'b011
//BEQ %d, %s, addr; PC = (%d==%s? addr: PC+1)
//BEQ also modified for absolute branching
`define BEQ		3'b111
//lw %d, offset(%s); %d = ROM[%s+offset]
`define LW		3'b101
//MULI %d, %s, imm; %d = %s*imm
`define MULI	3'b110



// //IN %d SW0_7; %d = SW0_7
// `define IN		4'b0010
// //HS %d SW8; %d = SW8
// `define HS		4'b0111