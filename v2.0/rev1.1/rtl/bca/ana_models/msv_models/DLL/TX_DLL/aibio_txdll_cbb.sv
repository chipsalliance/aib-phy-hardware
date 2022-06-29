`timescale 1ps/1fs

module aibio_txdll_cbb
(
	//------Supply pins------//
	input vddcq,
	input vss,
	//------Input pins------//
	input ck_in,
	input ck_loopback,
	input ck_sys,
	input ck_jtag,
	input [1:0] inp_cksel,
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
	input loopback_en,
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
	output pulseclk_odd_loopback,
	output pulseclk_even_loopback,
	output inbias,
	output [3:0] ipbias,
	output [1:0] dll_digviewout,
	output dll_anaviewout,
	//------Spare pins------//
	input [7:0] i_dll_spare,
	output [7:0] o_dll_spare
);

wire clkp,clkn;
wire up,dn,upb,dnb;
wire [15:0]clkphb;

wire dll_lock_en;

wire jtag_en;
wire dll_en_int;
wire dll_enb_int;

assign dll_en_int = dll_en & pwrgood_in;
assign dll_enb_int= ~dll_en_int;

//assign dll_lock_en = dll_en & dll_reset ;

aibio_inpclk_select_txdll inpclk_select
		(
 		.vddcq(vddcq),
		.vss(vss),
		.i_clk_in(ck_in),
		.i_clk_loopback(ck_loopback),
		.i_clk_sys(ck_sys),
		.i_clk_jtag(ck_jtag),
		.i_clksel(inp_cksel),
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
		.i_dll_en(dll_en_int),
		.i_dll_enb(dll_enb_int),
		.i_reset(dll_reset),
		.i_jtag_en(jtag_en),
		.o_up(up),
		.o_dn(dn),
		.o_upb(upb),
		.o_dnb(dnb),
		.o_dll_clkphb(clkphb),
		.o_piclk_180(),
		.o_piclk_90(),
		.o_cdr_clk(),
		.o_pbias(),
		.o_nbias(),
		.ph_diff()
		);

aibio_lock_detector lock_detector
		(
		.vddcq(vddcq),
  		.vss(vss),
		.i_clkin(ck_sys),
		.i_up(up),
		.i_dn(dn),
		.i_upb(upb),
		.i_dnb(dnb),
		.i_reset(dll_reset),
		.i_lockthresh(dll_lockthresh[1:0]),
		.i_lockctrl(dll_lockctrl),
		.o_dll_lock(dll_lock)
		);

aibio_pulsegen_top pulsegen
		(
		.vddcq(vddcq),
		.vss(vss),
		.i_clkphb(clkphb),
		.i_dll_even_phase1_sel(dll_even_phase1_sel),
		.i_dll_odd_phase1_sel(dll_odd_phase1_sel),
		.i_dll_even_phase2_sel(dll_even_phase2_sel),
		.i_dll_odd_phase2_sel(dll_odd_phase2_sel),
		.o_clk_even(),
		.o_clk_odd(),
		.o_pulseclk_even(pulseclk_even),
		.o_pulseclk_odd(pulseclk_odd)
		);

aibio_clock_dist piclk_dist
		(
		.vddcq(vddcq),
		.vss(vss),
		.i_piclk_even_in(pulseclk_even),
		.i_piclk_odd_in(pulseclk_odd),
		.i_loopback_en(loopback_en),
		.o_piclk_even_loopback(pulseclk_even_loopback),
		.o_piclk_odd_loopback(pulseclk_odd_loopback)
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

assign jtag_en = inp_cksel[1] && inp_cksel[0] ;

endmodule
