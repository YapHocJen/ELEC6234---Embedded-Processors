//------------------------------------
// File Name   : cpu.sv
// Function    : picoMIPS CPU top level encapsulating module, version 2
// Author      : Hoc Jen Yap
// Ver 1 :  PC , prog memory, regs, ALU and decoder, ROM
//			Based on tjk's work
// Last revised: 27 Oct 2012
//------------------------------------

`include "alucodes.sv"
module cpu #(parameter n=8)(
	input logic clk, nreset, SW8, 
	input logic [n-1:0] uInput, 
	output logic [n-1:0] outport
);

// declarations of local signals that connect CPU modules
// ALU
logic [2:0] ALUfunc; // ALU function
logic flag; // Z flag routed to decoder
logic imm; // immediate operand signal
logic [n-1:0] Alub, aluresult; // output from imm MUX and aluresult
//
// registers, outport connected to register 5
logic [n-1:0] Rdata1, Rdata2, Wdata; // Register data, and 
logic w; // register write control
//
// Program Counter 
parameter Psize = 5; // up to 64 instructions
logic PCincr,PCabsbranch; // program counter control
logic [Psize-1 : 0]ProgAddress;
// Program Memory
parameter Isize = 16; // Isize - instruction width
logic [Isize-1:0] I; // I - instruction code
//ROM
logic [n-1:0] data_out;

//control signal for ROM and ALU output
logic dres;

//------------- code starts here ---------
// module instantiations
pc  #(.Psize(Psize)) progCounter (.clk(clk),.reset(nreset),
        .PCincr(PCincr),
        .PCabsbranch(PCabsbranch),
        .Branchaddr(I[Psize-1:0]), //instruction branch address is 5-bits to make 16-bit instructions
        .PCout(ProgAddress) );

prog #(.Psize(Psize),.Isize(Isize)) 
      progMemory (.address(ProgAddress),.I(I));

decoder  D (.opcode(I[Isize-1:Isize-3]), //Opcode -> 1-3 leftmost bits of instruction
            .PCincr(PCincr),
            .PCabsbranch(PCabsbranch), 
            .flag(flag), // ALU flags
		  .ALUfunc(ALUfunc),.imm(imm),.w(w),
		  .dres(dres));


regs	#(.n(n)) gpr(
		.clk(clk),
		.w(w),
		.sw8(SW8),
		.uInput(uInput),
		.Wdata(Wdata),
		.Raddr1(I[Isize-4:Isize-6]),
		.Raddr2(I[Isize-10:Isize-12]),
		.Waddr(I[Isize-7:Isize-9]),
		.Rdata1(Rdata1),
		.Rdata2(Rdata2),
		.disp(outport)
);

alu    #(.n(n))  iu(.a(Rdata1),.b(Alub),
       .func(ALUfunc),.flag(flag),
       .result(aluresult)); // ALU result -> ROM addr/dest register
	   
asyncrom rom(
		.data_out(data_out),
		.addr(aluresult)
);

//memory multiplexer after ROM
assign Wdata = (dres ? data_out:aluresult); 


//imm multiplexer before alu
assign Alub = (imm ? {{{I[6]}},I[6:0]} : Rdata2);

endmodule