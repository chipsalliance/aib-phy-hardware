`timescale 1ps/1fs

module aibio_pulsegen_mux8x1
		(
		//-------Supply pins---------//
		input vddcq,
		input vss,
		//-------Input pins----------//
		input [7:0] i_clkph,
		input [2:0] i_clksel,
		//-------Output pins---------//
		output wor o_clkph
//		output o_clkph 		//For LEC comment above line and uncomment this line
		);

wire [7:0] clk_sel;
//wor o_clkph;			//For LEC comment this line

aibio_decoder3x8 I1
		(
		.vddcq(vddcq),
		.vss(vss),
		.i(i_clksel),
		.o(clk_sel)
		);

aibio_pimux4x1 MUX0
		(
		.vddcq(vddcq),
		.vss(vss),
		.i_clkph({i_clkph[3],i_clkph[2],i_clkph[1],i_clkph[0]}),
		.i_clkph_sel({clk_sel[3],clk_sel[2],clk_sel[1],clk_sel[0]}),
		.o_clkph(o_clkph)
		);

aibio_pimux4x1 I0
		(
		.vddcq(vddcq),
		.vss(vss),
		.i_clkph({i_clkph[7],i_clkph[6],i_clkph[5],i_clkph[4]}),
		.i_clkph_sel({clk_sel[7],clk_sel[6],clk_sel[5],clk_sel[4]}),
		.o_clkph(o_clkph)
		);

//assign o_clkph = o_clkph_int1 || o_clkph_int2 ;

endmodule
