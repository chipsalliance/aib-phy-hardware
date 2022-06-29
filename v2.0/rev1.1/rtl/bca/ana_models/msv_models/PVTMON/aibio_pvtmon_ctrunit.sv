`timescale 1ps/1fs



module aibio_pvtmon_ctrunit(
				//-----Supply Pins---//
				input logic vdd,
				input logic vss,
				
				//-----Input Pins---//
				input logic din,
				input logic rb,
				input logic clk,
				
				//----Output pins----//
				output logic dout,
				output logic ctrout
				);
				
logic not1,nand1,nand2,nand3,not2,not3;
logic dff_out;

assign not1= ~din;
assign nand1 = ~(not1 & ctrout);
assign nand2= ~(nand1 & nand3);
assign nand3= ~(din & not2);
assign not2= ~dff_out;
assign not3= ~not2;
assign ctrout =not3;
assign dout=(din & not3);

DFF flop(
		.vdd(vdd),
		.vss(vss),
		.d(nand2),
		.rb(rb),
		.clk(clk),
		.o(dff_out)
		);


endmodule				
