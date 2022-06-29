`timescale 1ps/1fs

module aibio_rxdll_cbb
		(
		//-------Supply pins----------//
		input vddcq,
		input vss,
		//-------Input pins-----------//
		input ck_inp,
		input ck_inn,
		input ck_loopback,
		input ck_sys,
		input ck_jtag,
		input ck_cdr_inp,
		input ck_cdr_inn,
		input [1:0]inp_cksel,
		input dll_en,
		input dll_reset,
		input loopback_en,
		input [3:0]dll_biasctrl,
		input [4:0]dll_capctrl,
		input [3:0]pi_biasctrl,
		input [4:0]pi_capctrl,
		input [3:0]cdr_ctrl,
		input [7:0]dll_piodd_code,
		input [7:0]dll_pieven_code,
		input picode_update,
		input [3:0]dll_pisoc_code,
		input [3:0]dll_piadapter_code,
		input [3:0]dll_lockthresh,
		input [1:0]dll_lockctrl,
		input pwrgood_in,
		input dll_dfx_en,
		input sdr_mode,
		input [4:0]dll_digviewsel,
		input [4:0]dll_anaviewsel,
		input [7:0]i_dll_spare,
		//--------Output pins-----------//
		output phdet_cdr_out,
		output dll_lock,
		output piclk_odd,
		output piclk_even,
		output piclk_even_loopback,
		output piclk_odd_loopback,
		output piclk_odd_fifo,
		output piclk_even_fifo,
		output piclk_adapter,
		output piclk_soc,
		output inbias,
		output ipbias,
		output [1:0]dll_digviewout,
		output dll_anaviewout,
		output [7:0]o_dll_spare
		);

wire clkp,clkn;
wire cdr_clkp,cdr_clkn;
wire up,dn,upb,dnb;
wire [15:0]clkphb;
wire piclk_180,piclk_90;
wire cdr_clk;

wire pbias;
wire nbias;

wire pi_capctrlb_0;
wire pi_capctrlb_1;

wire dll_en_int;
wire dll_enb_int;

assign dll_enb_int= ~dll_en_int;

assign pi_capctrlb_1 = ~pi_capctrl[1];
assign pi_capctrlb_0 = ~pi_capctrl[0];

//assign dll_lock_en = dll_en & dll_reset ;
assign dll_en_int = dll_en & pwrgood_in;

real ph_diff;
real ph_diff_lock;

wire jtag_en;

aibio_inpclk_select inclk_selector
		(
 		.vddcq(vddcq),
		.vss(vss),
		.i_clk_inp(ck_inp),
		.i_clk_inn(ck_inn),
		.i_clk_loopback(ck_loopback),
		.i_clk_jtag(ck_jtag),
		.i_clk_sys(ck_sys),
		.i_clk_cdr_inp(ck_cdr_inp),
		.i_clk_cdr_inn(ck_cdr_inn),
		.i_clksel(inp_cksel),
		.o_clkp(clkp),
		.o_clkn(clkn),
		.o_cdr_clkp(cdr_clkp),
		.o_cdr_clkn(cdr_clkn)
		);

aibio_dll_top DLL
		(
		.vddcq(vddcq),
		.vss(vss),
		.i_clkp(clkp),
		.i_clkn(clkn),
		.i_clkp_cdr(cdr_clkp),
		.i_clkn_cdr(cdr_clkn),
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
		.o_piclk_180(piclk_180),
		.o_piclk_90(piclk_90),
		.o_cdr_clk(cdr_clk),
		.o_pbias(pbias),
		.o_nbias(nbias),
		.ph_diff(ph_diff)
		);

aibio_cdr_detect I41
		(
		.vddcq(vddcq),
		.vss(vss),
		.i_cdr_clk(cdr_clk),
		.i_piclk_90(piclk_90),
		.i_piclk_180(piclk_180),
		.i_sdr_mode(sdr_mode),
		.i_reset(dll_reset),
		.o_cdr_phdet(phdet_cdr_out)
		);

aibio_pioddevn_top PI
		(
		.vddcq(vddcq),
		.vss(vss),
		.i_clkphb(clkphb),
		.i_picode_evn(dll_pieven_code),
		.i_picode_odd(dll_piodd_code),
		.i_pbias(pbias),
		.i_nbias(nbias),
		.i_bias_trim(pi_biasctrl[2:0]),
		.i_capsel(pi_capctrl[1:0]),
		.i_capselb({pi_capctrlb_1,pi_capctrlb_0}),
		.i_clken(dll_en_int),
		.i_pien(dll_en_int),
		.i_reset(dll_reset),
		.i_update(picode_update),
		.o_clkpi_evn(piclk_even),
		.o_clkpi_odd(piclk_odd),
		.ph_diff(ph_diff_lock)
		);

aibio_clock_dist piclk_dist
		(
		.vddcq(vddcq),
		.vss(vss),
		.i_piclk_even_in(piclk_even),
		.i_piclk_odd_in(piclk_odd),
		.i_loopback_en(loopback_en),
		.o_piclk_even_loopback(piclk_even_loopback),
		.o_piclk_odd_loopback(piclk_odd_loopback)
		);


aibio_outclk_select outclk_selector
		(
		.vddcq(vddcq),
		.vss(vss),
		.i_clkphb(clkphb),
		.i_adapter_code(dll_piadapter_code),
		.i_soc_code(dll_pisoc_code),
		.o_clk_adapter(piclk_adapter),
		.o_clk_soc(piclk_soc)
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

assign ph_diff_lock = (dll_lock) ? ph_diff : 0.0;

assign jtag_en = inp_cksel[1] && inp_cksel[0] ;

endmodule
