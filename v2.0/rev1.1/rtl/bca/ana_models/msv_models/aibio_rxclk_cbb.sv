`timescale 1ps/1fs

module aibio_rxclk_cbb
(
	//------Supply pins------//
	input vddcq,
	input vss,
	//------Input pins------//
	input [4:0] dcc_p_pdsel,
	input [4:0] dcc_p_pusel,
	input [4:0] dcc_n_pdsel,
	input [4:0] dcc_n_pusel,
	input rxclkp,
	input rxclkn,
	input rxclk_en,
	input rxclk_localbias_en,
	input ipbias,
	input [2:0] ibias_ctrl,
	input gen1mode_en,
	//------Output pins------//
	output rxclkp_out,
	output rxclkn_out,
	//------Spare pins------//
	input [3:0] i_rxclk_spare,
	output [3:0] o_rxclk_spare
);

assign rxclkp_out = rxclk_en ? rxclkp : 1'b0;
assign rxclkn_out = rxclk_en ? rxclkn : 1'b0;

endmodule
