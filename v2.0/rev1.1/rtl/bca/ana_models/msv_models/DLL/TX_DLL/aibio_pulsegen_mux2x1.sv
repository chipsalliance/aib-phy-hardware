`timescale 1ps/1fs

module aibio_pulsegen_mux2x1
		(
		//-------Supply pins---------//
		input vddcq,
		input vss,
		//-------Input pins----------//
		input [1:0] i_clkph,
		input [1:0] i_clkph_sel,
		//-------Output pins--------//
		output o_clkph
		);

assign o_clkph = (i_clkph_sel == 2'b01) ? i_clkph[0] :
					  (i_clkph_sel == 2'b10) ? i_clkph[1] :
					1'b0;

endmodule
