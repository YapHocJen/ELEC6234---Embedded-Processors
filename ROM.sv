module asyncrom 
(
	output logic [7:0] data_out,
	input logic [7:0] addr
);

logic [7:0] mem [255:0];

//Get memory contents from file
initial begin
	$readmemh("wave.hex", mem);
end


assign	data_out = mem[addr];


endmodule
