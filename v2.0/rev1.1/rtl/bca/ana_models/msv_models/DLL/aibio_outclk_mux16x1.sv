`timescale 1ps/1fs

module aibio_outclk_mux16x1
		(
		//--------Supply pins----------//
		input vddcq,
		input vss,
		//--------Input pins-----------//
		input [15:0]i_clkph,
		input [3:0]i_clksel,
		//--------Output pins---------//
		output o_clk
		);

wire [3:0] clk_sel_stg1;
wire [3:0] clk_sel_stg2;
wire [3:0] clkphsel_stg2;

aibio_decoder2x4 I4
		(
		.vddcq(vddcq),
		.vss(vss),
		.i(i_clksel[1:0]),
		.o(clk_sel_stg1)
		);

aibio_decoder2x4 I3
		(
		.vddcq(vddcq),
		.vss(vss),
		.i(i_clksel[3:2]),
		.o(clk_sel_stg2)
		);

aibio_pimux4x1 MUX0
		(
		.vddcq(vddcq),
		.vss(vss),
		.i_clkph(i_clkph[3:0]),
		.i_clkph_sel(clk_sel_stg1),
		.o_clkph(clkphsel_stg2[0])
		);

aibio_pimux4x1 I0
		(
		.vddcq(vddcq),
		.vss(vss),
		.i_clkph(i_clkph[7:4]),
		.i_clkph_sel(clk_sel_stg1),
		.o_clkph(clkphsel_stg2[1])
		);

aibio_pimux4x1 I2
		(
		.vddcq(vddcq),
		.vss(vss),
		.i_clkph(i_clkph[11:8]),
		.i_clkph_sel(clk_sel_stg1),
		.o_clkph(clkphsel_stg2[2])
		);

aibio_pimux4x1 I1
		(
		.vddcq(vddcq),
		.vss(vss),
		.i_clkph(i_clkph[15:12]),
		.i_clkph_sel(clk_sel_stg1),
		.o_clkph(clkphsel_stg2[3])
		);

aibio_pimux4x1 I5
		(
		.vddcq(vddcq),
		.vss(vss),
		.i_clkph(clkphsel_stg2),
		.i_clkph_sel(clk_sel_stg2),
		.o_clkph(o_clk)
		);

endmodule
