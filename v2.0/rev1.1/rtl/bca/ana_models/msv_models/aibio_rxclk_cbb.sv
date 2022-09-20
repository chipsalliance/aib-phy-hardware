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

wire rxclkp_out_1;
wire rxclkp_out_2;
wire rxclkp_out_3;
wire rxclkn_out_1;
wire rxclkn_out_2;
wire rxclkn_out_3;

`ifdef POST_WORST
	localparam delay_rxclkp_out_1 = 150;
	localparam delay_rxclkp_out_2 = 5;
	localparam delay_rxclkn_out_1 = 150;
	localparam delay_rxclkn_out_2 = 3;
`else
	localparam delay_rxclkp_out_1 = 0.0;
	localparam delay_rxclkp_out_2 = 0.0;
	localparam delay_rxclkn_out_1 = 0.0;
	localparam delay_rxclkn_out_2 = 0.0;
`endif

assign #(delay_rxclkp_out_1)rxclkp_out_1 = rxclk_en ? rxclkp : 1'b0;
assign #(delay_rxclkp_out_1)rxclkp_out_2 = rxclk_en ? rxclkp_out_1 : 1'b0;
assign #(delay_rxclkp_out_1)rxclkp_out_3 = rxclk_en ? rxclkp_out_2 : 1'b0;
assign #(delay_rxclkp_out_2)rxclkp_out = rxclk_en ? rxclkp_out_3 : 1'b0;
assign #(delay_rxclkn_out_1)rxclkn_out_1 = rxclk_en ? rxclkn : 1'b0;
assign #(delay_rxclkn_out_1)rxclkn_out_2 = rxclk_en ? rxclkn_out_1 : 1'b0;
assign #(delay_rxclkn_out_1)rxclkn_out_3 = rxclk_en ? rxclkn_out_2 : 1'b0;
assign #(delay_rxclkn_out_2)rxclkn_out = rxclk_en ? rxclkn_out_3 : 1'b0;

endmodule
