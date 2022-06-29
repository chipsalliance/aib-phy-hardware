`timescale 1ps/1fs

module aibio_outclk_select
		(
		//--------Supply pins----------//
		input vddcq,
		input vss,
		//--------Input pins-----------//
		input [15:0]i_clkphb,
		input [3:0]i_adapter_code,
		input [3:0]i_soc_code,
		//--------Output pins---------//
		output o_clk_adapter,
		output o_clk_soc
		);



assign o_clk_adapter = ~ i_clkphb[i_adapter_code];
assign o_clk_soc = ~ i_clkphb[i_soc_code];

endmodule

