//---------------------------------------------------------
// File Name   : decoder.sv
// Function    : picoMIPS instruction decoder 
// Author: Hoc Jen yap
// ver 1:  Based on tjk's work
// Last revised: 26 Oct 2012
//---------------------------------------------------------

`include "alucodes.sv"
`include "opcodes.sv"
//---------------------------------------------------------
module decoder
( input logic [2:0] opcode, // top 3 bits of instruction
input flag, // Zero-result flag
// output signals
//    PC control
output logic PCincr,PCabsbranch,
//    ALU control
output logic [2:0] ALUfunc, 
// imm mux control
output logic imm,
//   register file control and ROM MUX control
output logic w, dres
  );
   
//------------- code starts here ---------
// instruction decoder
always_comb 
begin
// set default output signal values for NOP instruction
	PCincr = 1'b1; // PC increments by default
	PCabsbranch = 1'b0;
	imm=1'b0; w=1'b0; dres=1'b0;
	ALUfunc= 3'b000;
	case(opcode)
	`NOP: ;
	`ADD : begin // register-register
			w = 1'b1; // write result to dest register
			ALUfunc = `RADD;
		  end
	`MULI: begin // register-immediate
			w = 1'b1; // write result to dest register
			imm = 1'b1; // set ctrl signal for imm operand MUX
			ALUfunc = `RMUL;
		  end
	// `IN : begin
			// w = 1'b1; //write result to dest register
			// imm = 2'b10; //set ctrl signal for SW0_7 in imm operand MUX
			// ALUfunc = `RADD;
		// end
	// `HS: begin
			// w = 1'b1;
			// imm = 2'b11;
			// ALUfunc = `RADD;
		// end
	`LW: begin
			w = 1'b1;
			imm = 1'b1;
			dres = 1'b1;
			ALUfunc = `RADD;
		end
	`BEQ: begin
			PCabsbranch = flag; //Take absolute branch if Z==1
			PCincr = ~flag;
			ALUfunc = `RSUB;
		end
	`BNE: begin
			PCabsbranch = ~flag; //Take absolute branch if Z==0 
			PCincr = flag;
			ALUfunc = `RSUB;
		end
	default:
		$error("unimplemented opcode %h",opcode);

	endcase // opcode
	end // always_comb


	endmodule //module decoder --------------------------------