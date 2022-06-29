`timescale 1ps/1fs

module aibio_pulsegen_oddevn_halfside
		(
		//---------Supply pins----------//
		input vddcq,
		input vss,
		//---------Input pins----------//
		input [7:0]i_clkph,
		input [2:0]i_evn_ph1_sel,
		input [2:0]i_evn_ph2_sel,
		input [2:0]i_odd_ph1_sel,
		input [2:0]i_odd_ph2_sel,
		//--------Output pins-----------//
		output o_clkph1_evn,
		output o_clkph1_odd,
		output o_clkph2_evn,
		output o_clkph2_odd
		);

aibio_pulsegen_phsel_halfside odd_ph1ph2
		(
		.vddcq(vddcq),
		.vss(vss),
		.i_clkph(i_clkph),
		.i_ph1sel(i_odd_ph1_sel),
		.i_ph2sel(i_odd_ph2_sel),
		.o_clkph1(o_clkph1_odd),
		.o_clkph2(o_clkph2_odd)
		);

aibio_pulsegen_phsel_halfside evn_ph1ph2
		(
		.vddcq(vddcq),
		.vss(vss),
		.i_clkph(i_clkph),
		.i_ph1sel(i_evn_ph1_sel),
		.i_ph2sel(i_evn_ph2_sel),
		.o_clkph1(o_clkph1_evn),
		.o_clkph2(o_clkph2_evn)
		);

endmodule
