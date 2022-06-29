`timescale 1ps/1fs

module aibio_pimux4x1
	(
	//----------Supply pins----------//
	input vddcq,
	input vss,
	//---------Input pins-----------//
	input [3:0]i_clkph,
	input [3:0]i_clkph_sel,
	//---------Output pins----------//
	output o_clkph
	);

assign o_clkph =  (i_clkph_sel == 4'b0001) ? i_clkph[0] :
						(i_clkph_sel == 4'b0010) ? i_clkph[1] :
						(i_clkph_sel == 4'b0100) ? i_clkph[2] :
						(i_clkph_sel == 4'b1000) ? i_clkph[3] :
						1'b0;

endmodule
