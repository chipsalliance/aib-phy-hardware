`timescale 1ps/1fs

module aibio_txdll_cbb
(
	//------Supply pins------//
	input vddcq,
	input vddc,
	input vss,
	//------Input pins------//
	input ck_in,
	input ck_loopback,
	input ck_sys,
	input ck_jtag,
	input [1:0] inp_clksel,
	input dll_en,
	input dll_reset,
	input [3:0] dll_biasctrl,
	input [4:0] dll_capctrl,
	input [3:0] dll_cksoc_code,
	input [3:0] dll_ckadapter_code,
	input [3:0] dll_even_phase1_sel,
	input [3:0] dll_odd_phase1_sel,
	input [3:0] dll_even_phase2_sel,
	input [3:0] dll_odd_phase2_sel,
	input [3:0] dll_lockthresh,
	input [1:0] dll_lockctrl,
	input pwrgood_in,
	input dll_dfx_en,
	input [4:0] dll_digview_sel,
	input [4:0] dll_anaview_sel,
	//------Output pins------//
	output dll_lock,
	output clk_odd,
	output clk_even,
	output clk_soc,
	output clk_adapter,
	output pulseclk_odd,
	output pulseclk_even,
	output inbias,
	output ipbias,
	output [1:0] dll_digviewout,
	output dll_anaviewout,
	//------Spare pins------//
	input [7:0] i_dll_spare,
	output [7:0] o_dll_spare
);

wire clkp,clkn;
wire up,dn,upb,dnb;
wire [15:0]clkphb;

wire dll_enb;

assign dll_enb= ~dll_en;

aibio_inpclk_select_txdll inpclk_select
		(
 		.vddcq(vddcq),
		.vss(vss),
		.i_clk_in(ck_in),
		.i_clk_loopback(ck_loopback),
		.i_clk_sys(ck_sys),
		.i_clk_jtag(ck_jtag),
		.i_clksel(inp_clksel),
		.o_clkp(clkp),
		.o_clkn(clkn)
		);

aibio_dll_top dll_top
		(
		.vddcq(vddcq),
		.vss(vss),
		.i_clkp(clkp),
		.i_clkn(clkn),
		.i_clkp_cdr(),
		.i_clkn_cdr(),
		.i_dll_biasctrl(dll_biasctrl),
		.i_dll_capctrl(dll_capctrl),
		.i_dll_en(dll_en),
		.i_dll_enb(dll_enb),
		.o_up(up),
		.o_dn(dn),
		.o_upb(upb),
		.o_dnb(dnb),
		.o_dll_clkphb(clkphb),
		.o_piclk_180(),
		.o_piclk_90(),
		.o_cdr_clk(),
		.o_pbias(),
		.o_nbias()
		);

aibio_lock_detector lock_detector
		(
		.vddcq(vddcq),
  		.vss(vss),
		.i_clkin(ck_sys),
		.i_en(dll_en),
		.i_up(up),
		.i_dn(dn),
		.i_upb(upb),
		.i_dnb(dnb),
		.i_lockthresh(dll_lockthresh[1:0]),
		.i_lockctrl(dll_lockctrl),
		.lock(dll_lock)
		);

aibio_pulsegen_top pulsegen
		(
		.vddcq(vddcq),
		.vss(vss),
		.i_clkph(clkphb),
		.i_dll_even_phase1_sel(dll_even_phase1_sel),
		.i_dll_odd_phase1_sel(dll_odd_phase1_sel),
		.i_dll_even_phase2_sel(dll_even_phase2_sel),
		.i_dll_odd_phase2_sel(dll_odd_phase2_sel),
		.o_clk_even(clk_even),
		.o_clk_odd(clk_odd),
		.o_pulseclk_even(pulseclk_even),
		.o_pulseclk_odd(pulseclk_odd)
		);

aibio_outclk_select outclk_select
		(
		.vddcq(vddcq),
		.vss(vss),
		.i_clkphb(clkphb),
		.i_adapter_code(dll_ckadapter_code),
		.i_soc_code(dll_cksoc_code),
		.o_clk_adapter(clk_adapter),
		.o_clk_soc(clk_soc)
		);


endmodule


module aibio_inpclk_select_txdll
		(
		//--------Supply pins----------//
		input vddcq,
		input vss,
		//--------Input pins-----------//
		input i_clk_in,
		input i_clk_loopback,
		input i_clk_sys,
		input i_clk_jtag,
		input [1:0] i_clksel,
		//--------Output pins-----------//
		output o_clkp,
		output o_clkn
		);

wire i_clk_inp;
wire i_clk_inn;
wire i_clk_loopbackp;
wire i_clk_loopbackn;
wire i_clk_sysp;
wire i_clk_sysn;
wire i_clk_jtagp;
wire i_clk_jtagn;

assign i_clk_loopbackp = i_clk_loopback;
assign i_clk_loopbackn = ~i_clk_loopback;

assign i_clk_sysp = i_clk_sys;
assign i_clk_sysn = ~i_clk_sys;

assign i_clk_inp = i_clk_in;
assign i_clk_inn = ~i_clk_in;

assign i_clk_jtagp = i_clk_jtag;
assign i_clk_jtagn = ~i_clk_jtag;


assign o_clkp = (i_clksel == 2'b00) ? i_clk_inp :
					 (i_clksel == 2'b01) ? i_clk_loopbackp :
					 (i_clksel == 2'b10) ? i_clk_sysp :
					 (i_clksel == 2'b11) ? i_clk_jtagp :
					 1'b0;

assign o_clkn = (i_clksel == 2'b00) ? i_clk_inn :
					 (i_clksel == 2'b01) ? i_clk_loopbackn :
					 (i_clksel == 2'b10) ? i_clk_sysn :
					 (i_clksel == 2'b11) ? i_clk_jtagn :
					 1'b0;

endmodule


module aibio_pulsegen_top
		(
		//---------Supply pins----------//
		input vddcq,
		input vss,
		//---------Input pins----------//
		input [15:0] i_clkph,
		input [3:0] i_dll_even_phase1_sel,
		input [3:0] i_dll_odd_phase1_sel,
		input [3:0] i_dll_even_phase2_sel,
		input [3:0] i_dll_odd_phase2_sel,
		//--------Output pins-----------//
		output o_clk_even,
		output o_clk_odd,
		output o_pulseclk_even,
		output o_pulseclk_odd
		);

wire [3:0]dll_even_phase2_sel_int;
wire [3:0]dll_odd_phase2_sel_int;

wire dll_even_phase2_selb_3;
wire dll_odd_phase2_selb_3;

assign dll_even_phase2_selb_3 = ~i_dll_even_phase2_sel[3];
assign dll_odd_phase2_selb_3 = ~i_dll_odd_phase2_sel[3];
assign dll_even_phase2_sel_int = {dll_even_phase2_selb_3,i_dll_even_phase2_sel[2:0]};
assign dll_odd_phase2_sel_int = {dll_odd_phase2_selb_3,i_dll_odd_phase2_sel[2:0]};

assign o_clk_even = ~i_clkph[i_dll_even_phase1_sel];
assign o_clk_odd = ~i_clkph[i_dll_odd_phase1_sel];
assign o_pulseclk_even = o_clk_even && (i_clkph[dll_even_phase2_sel_int]);
assign o_pulseclk_odd = o_clk_odd && (i_clkph[dll_odd_phase2_sel_int]);

endmodule
