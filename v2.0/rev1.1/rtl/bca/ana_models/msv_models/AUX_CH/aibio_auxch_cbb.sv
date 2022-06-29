`timescale 1ps/1fs

module aibio_auxch_cbb
		(
		//----supply pins----//
		input vddc,
		input vss,
		//-----input pins-------------//
		input dual_mode_sel,
		input i_m_power_on_reset,
		input m_por_ovrd,
		input m_device_detect_ovrd,
		input [2:0]rxbuf_cfg,
		input powergood,
		input gen1mode_en,
		//-----inout pins-----------------//
		inout xx_power_on_reset,
		inout xx_device_detect,
		//-------output pins--------------//
		output o_m_power_on_reset,
		output m_device_detect,
		//--------spare pins---------------//
		input [3:0]i_aux_spare,
		output [3:0]o_aux_spare
		);


wire net016;
wire net017;
wire net09;
wire net028;
wire net023;
wire net013;

wire vin1;
wire vin2;


assign net013 = ~i_m_power_on_reset;
assign net09 = ~ dual_mode_sel;
assign net028 = ~net09;
assign net023 = ~vddc;

assign o_m_power_on_reset = (m_por_ovrd & net016);
assign m_device_detect = (net017 | m_device_detect_ovrd);

assign xx_power_on_reset = (net09)? ~net013 : 1'hz;
assign xx_device_detect = (net028) ? ~net023 :1'hz;

assign vin1 = xx_power_on_reset;
assign vin2 = xx_device_detect;

aibio_auxch_Schmit_trigger schmit_trigger1
		(
		.vddc(vddc),
		.vss(vss),
		.vin(vin1),
		.vout(net016)
		);


aibio_auxch_Schmit_trigger schmit_trigger2
		(
		.vddc(vddc),
		.vss(vss),
		.vin(vin2),
		.vout(net017)
		);

endmodule

