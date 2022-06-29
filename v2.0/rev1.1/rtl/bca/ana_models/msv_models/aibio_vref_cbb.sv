`timescale 1ps/1fs

module aibio_vref_cbb
(
	//------Supply pins------//
	input vddc,
	input vddtx,
	inout vss,
	//------Input pins------//
	input vref_en,
	input calvref_en,
	input [6:0] vref_bin_0,
	input [6:0] vref_bin_1,
	input [6:0] vref_bin_2,
	input [6:0] vref_bin_3,
	input [4:0] calvref_bin,
	input gen1mode_en,
	input pwrgood_in,
	//------Output pins------//
	output [3:0] vref,
	output calvref,
	//------Spare pins------//
	input [3:0] i_vref_spare,
	output [3:0] o_vref_spare
);

endmodule
