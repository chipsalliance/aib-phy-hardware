`timescale 1ps/1fs
module mux2x1 (
		//-----Supply Pins---//
		input logic vdd,
		input logic vss,
		
		//-----Input Pins---//
		input logic [1:0]in,
		input logic s,
		
		//----Output pins----//
		output logic out
		);
		

always @(in or s)
begin

	if(s) 
	out= in[1];
	else
	out=in[0];

end

endmodule		
		
		
