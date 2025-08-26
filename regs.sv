//-----------------------------------------------------
// File Name : regs.sv
// Function : picoMIPS 8 x n registers, %0 == 0
// Version 1 : Based on tjk's work
// Author: Hoc Jen Yap
// Last rev. 27 Oct 2012
//-----------------------------------------------------
module regs #(parameter n = 8) // n - data bus width
(input logic clk, w, sw8,// clk, write control, and handshake signal (register 1)
 input logic [n-1:0] uInput, //Route sw0_7 directly to register 2
 input logic [n-1:0] Wdata,
 input logic [2:0] Raddr1, Raddr2, Waddr,
 output logic [n-1:0] Rdata1, Rdata2, disp
 );
	
 	// Declare 32 n-bit registers 
	logic [n-1:0] gpr [5:0];
	
	// write process, dest reg is Raddr2
	always_ff @ (posedge clk)
	begin
		if (w) begin
            gpr[Waddr] <= Wdata;
		end
		gpr[1] = {n{sw8}};
		gpr[2] = uInput;
	end
 
	// read process, output 0 if %0 is selected
	always_comb begin
		
		Rdata1 = (Raddr1 == 3'd0) ? {n{1'b0}} : gpr[Raddr1];
		Rdata2 = (Raddr2 == 3'd0) ? {n{1'b0}} : gpr[Raddr2];
		disp = gpr[5];
	end
	

endmodule // module regs