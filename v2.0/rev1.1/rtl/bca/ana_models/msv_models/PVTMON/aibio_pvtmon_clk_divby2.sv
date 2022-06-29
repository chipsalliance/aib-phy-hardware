`timescale 1ps/1fs
module aibio_pvtmon_clk_divby2(
				//-----Supply Pins---//
				input logic vdd,
				input logic vss,
				
				//-----Input Pins---//
				input logic clk,
				input logic rb,
				
				//----Output pins----//
				output logic clkout
				);
				
logic net3;
logic net2;

DFF i_flop (
		.vdd(vdd),
		.vss(vss),
		.clk(clk),
		.rb(rb),
		.d(net3),
		.o(net2)
		);
				


assign net3=~net2;
assign clkout=~net3;

endmodule
