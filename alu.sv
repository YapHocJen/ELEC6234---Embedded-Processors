//-----------------------------------------------------
// File Name   : alu.sv
// Function    : ALU module for picoMIPS
// Version: 1,  only 8 funcs, based on tjk's work
// Author:  Hoc Jen Yap
// Last rev. 23 Oct 12
//-----------------------------------------------------

`include "alucodes.sv"  
module alu #(parameter n =8) (
   input logic signed [n-1:0] a, b, // ALU operands
   input logic [2:0] func, // ALU function code
   output logic flag, // Z flag
   output logic signed [n-1:0] result // ALU result
);       

logic signed [15:0] mult_result;
// create the ALU, use signal ar in arithmetic operations
always_comb
begin
  //default output values; prevent latches 
  flag = 1'b0;
  result = a; // default
  mult_result = 16'b0;
  case(func)
     	`RADD  : begin
	     result = a+b; // arithmetic addition
		end
    	`RSUB  : begin
	     result = a-b; // arithmetic subtraction
		end   
		`RMUL : begin
			mult_result = a*b;
			result = mult_result[14:7];
		end
		default: ;
   endcase
 
 flag = result == {n{1'b0}}; // Z

 end //always_comb

endmodule //end of module ALU