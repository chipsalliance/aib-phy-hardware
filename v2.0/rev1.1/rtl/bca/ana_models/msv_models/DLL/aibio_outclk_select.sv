`timescale 1ps/1fs

module aibio_outclk_select
		(
		//----------Supply pins-----------//
		input vddcq,
		input vss,
		//----------Input pins-----------//
		input [3:0] i_adapter_code,
		input [3:0] i_soc_code,
		input [15:0] i_clkphb,
		//----------Output pins-----------//
		output o_clk_adapter,
		output o_clk_soc
		);

wire clk_adapter_b;
wire clk_soc_b;

aibio_outclk_mux16x1 Adapater_MUX
		(
		.vddcq(vddcq),
		.vss(vss),
		.i_clkph(i_clkphb),
		.i_clksel(i_adapter_code),
		.o_clk(clk_adapter_b)
		);

aibio_outclk_mux16x1 SOC_MUX
		(
		.vddcq(vddcq),
		.vss(vss),
		.i_clkph(i_clkphb),
		.i_clksel(i_soc_code),
		.o_clk(clk_soc_b)
		);


assign o_clk_adapter = ~clk_adapter_b;
assign o_clk_soc = ~clk_soc_b;

endmodule
