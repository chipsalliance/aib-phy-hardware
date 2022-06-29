`timescale 1ps/1fs

module aibio_pulsegen_phsel_halfside
		(
		//---------Supply pins----------//
		input vddcq,
		input vss,
		//--------Input pins-----------//
		input [7:0]i_clkph,
		input [2:0]i_ph1sel,
		input [2:0]i_ph2sel,
		//--------Output pins---------//
		output o_clkph1,
		output o_clkph2
		);

aibio_pulsegen_mux8x1 I0
		(
		.vddcq(vddcq),
		.vss(vss),
		.i_clkph(i_clkph),
		.i_clksel(i_ph1sel),
		.o_clkph(o_clkph1)
		);

aibio_pulsegen_mux8x1 I1
		(
		.vddcq(vddcq),
		.vss(vss),
		.i_clkph(i_clkph),
		.i_clksel(i_ph2sel),
		.o_clkph(o_clkph2)
		);

endmodule

