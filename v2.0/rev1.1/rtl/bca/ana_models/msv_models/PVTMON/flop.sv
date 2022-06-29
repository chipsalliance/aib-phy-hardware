`timescale 1ps/1fs

module DFF(
		//-----Supply Pins---//
		input logic vdd,
		input logic vss,
		
		//-----Input Pins---//
		input logic clk,
		input logic rb,
		input logic d,
		
		//----Output pins----//
		output logic o
		);
initial o <= 0;		
always @(posedge clk or negedge rb )
begin
	if(rb == 1'b0)
	begin
		o = 'd0;
	end
	else
	begin
		o = d;
	end

end

endmodule
