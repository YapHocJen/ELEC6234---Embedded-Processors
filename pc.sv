//-----------------------------------------------------
// File Name : pc.sv
// Function : picoMIPS Program Counter
// functions: increment, absolute
// Author: Hoc Jen Yap
// Ver 1. Based on tjk's works
//-----------------------------------------------------
module pc #(parameter Psize = 5) // up to 64 instructions
(input logic clk, reset, PCincr, PCabsbranch,
 input logic [Psize-1:0] Branchaddr,
 output logic [Psize-1 : 0]PCout
);

//------------- code starts here---------

always_ff @ ( posedge clk or negedge reset) // async reset
  if (!reset) //active-low reset
     PCout <= {Psize{1'b0}};
  else if (PCincr) // increment or relative branch
     PCout <= PCout + 1;
  else if (PCabsbranch) // absolute branch
     PCout <= Branchaddr;

endmodule // module pc