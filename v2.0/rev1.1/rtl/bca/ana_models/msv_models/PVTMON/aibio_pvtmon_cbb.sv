`timescale 1ps/1fs

module aibio_pvtmon_cbb
		(
		//-----Supply Pins---//
		input logic vddc,
		input logic vss,
		//-----Input Pins---//
		input logic clk_sys,
		input logic count_start,
		input logic en,
		input logic [2:0]osc_sel,
		input logic [2:0]oscclkdiv,
		input logic [2:0]refclkdiv,
		input logic pvtmon_dfx_en,
		input logic [2:0]pvtmon_digview_sel,
		//----Output pins----//
		output logic count_done,
		output logic [9:0]codeout,
		output logic pvtmon_digviewout,
		//-------Spare Pins----------//
		input logic [3:0]i_pvtmon_spare,
		output logic [3:0]o_pvtmon_spare
		);


wire clkosc;
logic net5;

assign net5=en;

aibio_pvtmon_dig  aibio_pvtmon_dig(
					.vdd(vddc),
					.vss(vss),
					.clkosc(clk_osc),
					.clkref(clk_sys),
					.count_start(count_start),
					.en(net5),
					.oscdiv(oscclkdiv),
					.refdiv(refclkdiv),
					.dfx_en(pvtmon_dfx_en),
					.digview_sel(pvtmon_digview_sel),
					.count_done(count_done),
					.codeout(codeout),
					.digviewout(pvtmon_digviewout)
					);

aibio_pvtmon_oscbank pvtmon_oscbank (
					.vdd(vddc),
					.vss(vss),
					.en(net5),
					.osc_sel(osc_sel),
					.osc_out(clk_osc)
					);


assign 	o_pvtmon_spare[3] = ~vss;
assign 	o_pvtmon_spare[2] = ~vss;
assign 	o_pvtmon_spare[1] = ~vss;
assign 	o_pvtmon_spare[0] = ~vss;

endmodule
