`timescale 1ps/1fs

module aibio_rxdll_cbb
		(
		//-------Supply pins----------//
		input vddcq,
		input vss,
		input vddc,
		//-------Input pins-----------//
		input ck_inp,
		input ck_inn,
		input ck_loopback,
		input ck_sys,
		input ck_jtag,
		input ck_cdr_inp,
		input ck_cdr_inn,
		input [1:0]inp_clksel,
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
		input [4:0]dll_digview_sel,
		input [4:0]dll_anaview_sel,
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

wire dll_enb;

assign dll_enb= ~dll_en;

aibio_inpclk_select inpclk_select
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
		.i_clksel(inp_clksel),
		.o_clkp(clkp),
		.o_clkn(clkn),
		.o_cdr_clkp(cdr_clkp),
		.o_cdr_clkn(cdr_clkn)
		);

aibio_dll_top dll_top
		(
		.vddcq(vddcq),
		.vss(vss),
		.i_clkp(clkp),
		.i_clkn(clkn),
		.i_clkp_cdr(cdr_clkp),
		.i_clkn_cdr(cdr_clkn),
		.i_dll_biasctrl(dll_biasctrl),
		.i_dll_capctrl(dll_capctrl),
		.i_dll_en(dll_en),
		.i_dll_enb(dll_enb),
		.o_up(up),
		.o_dn(dn),
		.o_upb(upb),
		.o_dnb(dnb),
		.o_dll_clkphb(clkphb),
		.o_piclk_180(piclk_180),
		.o_piclk_90(piclk_90),
		.o_cdr_clk(cdr_clk),
		.o_pbias(pbias),
		.o_nbias(nbias)
		);

aibio_loopback_detect loopback_detect
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

aibio_pioddevn_top pioddevn_top
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
		.i_capselb(~(pi_capctrl[1:0])),
		.i_clken(dll_en),
		.i_pien(dll_en),
		.i_reset(dll_reset),
		.i_update(picode_update),
		.o_clkpi_evn(piclk_even),
		.o_clkpi_odd(piclk_odd)
		);

aibio_piclk_dist piclk_dist
		(
		.vddcq(vddcq),
		.vss(vss),
		.i_piclk_even_in(piclk_even),
		.i_piclk_odd_in(piclk_odd),
		.i_loopback_en(loopback_en),
		.o_piclk_even_loopback(piclk_even_loopback),
		.o_piclk_odd_loopback(piclk_odd_loopback)
		);


aibio_outclk_select outclk_select
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
		.i_en(dll_en),
		.i_up(up),
		.i_dn(dn),
		.i_upb(upb),
		.i_dnb(dnb),
		.i_lockthresh(dll_lockthresh[1:0]),
		.i_lockctrl(dll_lockctrl),
		.lock(dll_lock)
		);

endmodule


module aibio_inpclk_select
		(
		//--------Supply pins----------//
		input vddcq,
		input vss,
		//--------Input pins-----------//
		input i_clk_inp,
		input i_clk_inn,
		input i_clk_loopback,
		input i_clk_sys,
		input i_clk_jtag,
		input i_clk_cdr_inp,
		input i_clk_cdr_inn,
		input [1:0] i_clksel,
		//--------Output pins-----------//
		output o_clkp,
		output o_clkn,
		output o_cdr_clkp,
		output o_cdr_clkn
		);

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

assign o_cdr_clkp = i_clk_cdr_inp;
assign o_cdr_clkn = i_clk_cdr_inn;

endmodule

module aibio_pioddevn_top
		(
		//--------Supply pins-----------//
		input vddcq,
		input vss,
		//--------Input pins-----------//
		input [15:0]i_clkphb,
		input [7:0]i_picode_evn,
		input [7:0]i_picode_odd,
		input i_pbias,
		input i_nbias,
		input [2:0]i_bias_trim,
		input [1:0]i_capsel,
		input [1:0]i_capselb,
		input i_clken,
		input i_pien,
		input i_reset,
		input i_update,
		//-------Output pins-----------//
		output o_clkpi_evn,
		output o_clkpi_odd
		);

//--------Internal signals----------//
wire [2:0]pbias_trim;
wire [2:0]nbias_trim;

aibio_bias_trim biastrim
		(
		.vddcq(vddcq),
		.vss(vss),
		.i_bias_trim(i_bias_trim),
		.i_pbias(i_pbias),
		.i_nbias(i_nbias),
		.o_pbias_trim(pbias_trim),
		.o_nbias_trim(nbias_trim)
		);


aibio_pi_top pi_evn
		(
		.vddcq(vddcq),
		.vss(vss),
		.i_picode(i_picode_evn),
		.i_clk_en(i_clken),
		.i_update(i_update),
		.i_reset(i_reset),
		.i_clkph(~i_clkphb),
		.i_pbias(i_pbias),
		.i_pbias_trim(pbias_trim),
		.i_nbias(i_nbias),
		.i_nbias_trim(nbias_trim),
		.i_cap_sel(i_capsel),
		.i_cap_selb(i_capselb),
		.i_pien(i_pien),
		.o_clkpi(o_clkpi_evn)
		);

aibio_pi_top pi_odd
		(
		.vddcq(vddcq),
		.vss(vss),
		.i_picode(i_picode_odd),
		.i_clk_en(i_clken),
		.i_update(i_update),
		.i_reset(i_reset),
		.i_clkph(~i_clkphb),
		.i_pbias(i_pbias),
		.i_pbias_trim(pbias_trim),
		.i_nbias(i_nbias),
		.i_nbias_trim(nbias_trim),
		.i_cap_sel(i_capsel),
		.i_cap_selb(i_capselb),
		.i_pien(i_pien),
		.o_clkpi(o_clkpi_odd)
		);


endmodule

module aibio_bias_trim
		(
		//-------Supply pins---------//
		input vddcq,
		input vss,
		//-------Input pins---------//
		input logic [2:0]i_bias_trim,
		input i_pbias,
		input i_nbias,
		//--------Output pins----------//
		output [2:0]o_pbias_trim,
		output [2:0]o_nbias_trim
			);

assign o_pbias_trim = ~(i_bias_trim);
assign o_nbias_trim = i_bias_trim;

endmodule


module aibio_pi_top
		(
		//--------Supply pins---------//
		input vddcq,
		input vss,
		//--------Input pins---------//
		input [7:0]i_picode,
		input i_clk_en,
		input i_update,
		input i_reset,
		input [15:0]i_clkph,
		input i_pbias,
		input [2:0]i_pbias_trim,
		input i_nbias,
		input [2:0]i_nbias_trim,
		input [1:0]i_cap_sel,
		input [1:0]i_cap_selb,
		input i_pien,
		//--------Output pins----------//
		output o_clkpi
			);

//---------Internal signals------------//
wire [7:0]clkphsel_stg1;
wire [1:0]clkphsel_stg2;
wire [7:0]pimixer;

wire [7:0]clkphsel_stg1_latched;
wire [1:0]clkphsel_stg2_latched;
wire [7:0]pimixer_latched;

wire clkph_odd;
wire clkph_evn;

aibio_pi_decode pi_decode
		(
		.vddcq(vddcq),
		.vss(vss),
		.i_picode(i_picode),
		.o_pimixer(pimixer),
		.o_clkphsel_stg1(clkphsel_stg1),
		.o_clkphsel_stg2(clkphsel_stg2)
		);

aibio_pi_codeupdate pi_codeupdate
		(
		.vddcq(vddcq),
		.vss(vss),
		.i_clk(o_clkpi),
		.i_clk_en(i_clk_en),
		.i_clkphsel_stg1(clkphsel_stg1),
		.i_clkphsel_stg2(clkphsel_stg2),
		.i_pimixer(pimixer),
		.i_update(i_update),
		.i_reset(i_reset),
		.o_clkphsel_stg1(clkphsel_stg1_latched),
		.o_clkphsel_stg2(clkphsel_stg2_latched),
		.o_pimixer(pimixer_latched)
		);


aibio_pimux16x2 pimux16x2
		(
		.vddcq(vddcq),
		.vss(vss),
		.i_clkph(i_clkph),
		.i_piphsel_stg1(clkphsel_stg1_latched),
		.i_piphsel_stg2(clkphsel_stg2_latched),
		.i_pi_en(i_pien),
		.i_pbias(i_pbias),
		.i_pbias_trim(i_pbias_trim),
		.i_nbias(i_nbias),
		.i_nbias_trim(i_nbias_trim),
		.i_cap_sel(i_cap_sel),
		.i_cap_selb(i_cap_selb),
		.o_clkph_evn(clkph_evn),
		.o_clkph_odd(clkph_odd)
		);


aibio_pi_mixer_top pi_mixer_top
		(
		.vddcq(vddcq),
		.vss(vss),
		.i_clkph_evn(clkph_evn),
		.i_clkph_odd(clkph_odd),
		.i_oddph_en(pimixer_latched),
		.i_pien(i_pien),
		.o_clkmix_out(o_clkpi)
		);

endmodule


module aibio_pi_decode
		(
		//--------Supply pins----------//
		input vddcq,
		input vss,
		//--------Input pins-----------//
		input [7:0] i_picode,
		//--------Output pins----------//
		output [7:0]o_clkphsel_stg1,
		output [1:0]o_clkphsel_stg2,
		output [7:0]o_pimixer
		);

wire [3:0] picode_plus1;
wire mix_on;
wire [7:0] curr_code;
wire [7:0] next_code;

wire [6:0] therm;
wire next_odd_en;
wire next_even_en;
//----------cyclic code generation-------------//

assign picode_plus1 = i_picode[6:3] + 1'b1;

//--------------------------------------------//

assign mix_on = i_picode[2] || i_picode[1] || i_picode[0];

//------------Current code generation---------------//

decoder3to8 i_curr_dec
			(
			.Data_in(i_picode[5:3]),
			.Data_out(curr_code)
			);

//--------------------------------------------------//

//-------------Next Code generation-----------------//

decoder3to8 i_next_dec
			(
			.Data_in(picode_plus1[2:0]),
			.Data_out(next_code)
			);

//--------------------------------------------------//

//-------------o_pimixer<7:0>---------------------//

bin_to_therm #(.BIN_BITS(3),.THERM_BITS(7))
		i_bin3_to_therm7
		(
		.binary(i_picode[2:0]),
		.therm(therm)
		);

assign o_pimixer = (i_picode[3] == 1'b0) ? {i_picode[3],therm}  :
						 (i_picode[3] == 1'b1) ? {i_picode[3],~therm} :
						 'd0;

//--------------------------------------------------//


//-----------------o_clkphsel_stg1<7:0>----------------------//

assign next_odd_en = mix_on && (!i_picode[3]);
assign next_even_en = mix_on && (i_picode[3]);

assign o_clkphsel_stg1[0] = (next_even_en == 1'b0) ? curr_code[0] :
									 (next_even_en == 1'b1) ? next_code[0] :
									 1'b0;

assign o_clkphsel_stg1[2] = (next_even_en == 1'b0) ? curr_code[2] :
									 (next_even_en == 1'b1) ? next_code[2] :
									 1'b0;

assign o_clkphsel_stg1[4] = (next_even_en == 1'b0) ? curr_code[4] :
									 (next_even_en == 1'b1) ? next_code[4] :
									 1'b0;

assign o_clkphsel_stg1[6] = (next_even_en == 1'b0) ? curr_code[6] :
									 (next_even_en == 1'b1) ? next_code[6] :
									 1'b0;

assign o_clkphsel_stg1[1] = (next_odd_en == 1'b0) ? curr_code[1] :
									 (next_odd_en == 1'b1) ? next_code[1] :
									 1'b0;

assign o_clkphsel_stg1[3] = (next_odd_en == 1'b0) ? curr_code[3] :
									 (next_odd_en == 1'b1) ? next_code[3] :
									 1'b0;

assign o_clkphsel_stg1[5] = (next_odd_en == 1'b0) ? curr_code[5] :
									 (next_odd_en == 1'b1) ? next_code[5] :
									 1'b0;

assign o_clkphsel_stg1[7] = (next_odd_en == 1'b0) ? curr_code[7] :
									 (next_odd_en == 1'b1) ? next_code[7] :
									 1'b0;

//------------------------------------------------------------------//


//----------------------o_clkphsel_stg2<1:0>------------------------//

assign o_clkphsel_stg2[0] = (next_even_en == 1'b0) ? i_picode[6] :
									 (next_even_en == 1'b1) ? picode_plus1[3] :
									 1'b0;

assign o_clkphsel_stg2[1] = (next_odd_en == 1'b0) ? i_picode[6] :
									 (next_odd_en == 1'b1) ? picode_plus1[3] :
									 1'b0;

//--------------------------------------------------------------------//
endmodule

module decoder3to8
	(
    input [2:0]Data_in,
    output reg [7:0]Data_out
    );

always @(Data_in)
	case (Data_in)
   	3'b000 : Data_out = 8'b00000001;
      3'b001 : Data_out = 8'b00000010;
      3'b010 : Data_out = 8'b00000100;
      3'b011 : Data_out = 8'b00001000;
      3'b100 : Data_out = 8'b00010000;
      3'b101 : Data_out = 8'b00100000;
      3'b110 : Data_out = 8'b01000000;
      3'b111 : Data_out = 8'b10000000;
      default : Data_out = 8'b00000000;
	endcase

endmodule

module bin_to_therm #(parameter BIN_BITS = 3, parameter THERM_BITS = 7)
		(
		input [BIN_BITS - 1 : 0] binary,
		output [THERM_BITS - 1 :0] therm
		);

genvar I;

generate
	for(I=0;I<THERM_BITS;I=I+1)
	begin
		assign therm[I] = (binary > I) ? 1'b1 : 1'b0;
	end
endgenerate

endmodule


module aibio_pi_codeupdate
		(
		//--------Supply pins----------//
 		input vddcq,
		input vss,
		//--------Input pins-----------//
 		input i_clk,
 		input i_clk_en,
		input [7:0]i_clkphsel_stg1,
		input [1:0]i_clkphsel_stg2,
		input [7:0]i_pimixer,
		input i_update,
		input i_reset,
		//---------Output pins---------//
		output reg [7:0]o_clkphsel_stg1,
		output reg [1:0]o_clkphsel_stg2,
		output reg [7:0]o_pimixer
		);

wire clk_anded;

reg [7:0] o_clkphsel_stg1_prev;
reg [7:0] o_clkphsel_stg2_prev;
reg [7:0] o_pimixer_prev;

assign clk_anded = i_clk && i_clk_en;

always @(posedge clk_anded or i_reset)
begin
	if(i_reset == 1'b1)
	begin
		o_clkphsel_stg1 = 1'b0;
		o_clkphsel_stg2 = 1'b0;
		o_pimixer = 1'b0;
	end
	else
	begin
		if(i_update == 1'b1)
		begin
			o_clkphsel_stg1 = i_clkphsel_stg1;
			o_clkphsel_stg2 = i_clkphsel_stg2;
			o_pimixer = i_pimixer;
			o_clkphsel_stg1_prev <= o_clkphsel_stg1;
			o_clkphsel_stg2_prev <= o_clkphsel_stg2;
			o_pimixer_prev <= o_pimixer;
		end
		else if(i_update == 1'b0)
		begin
			o_clkphsel_stg1 = o_clkphsel_stg1_prev;
			o_clkphsel_stg2 = o_clkphsel_stg2_prev;
			o_pimixer = o_pimixer_prev;
		end
	end
end

endmodule


module aibio_pimux16x2
		(
		//---------Supply pins------------//
		input vddcq,
		input vss,
		//--------Input pins-------------//
		input [15:0] i_clkph,
		input [7:0] i_piphsel_stg1,
		input [1:0] i_piphsel_stg2,
		input i_pbias,
		input [2:0] i_pbias_trim,
		input i_nbias,
		input [2:0] i_nbias_trim,
		input [1:0] i_cap_sel,
		input [1:0] i_cap_selb,
		input i_pi_en,
		//---------Output pins------------//
		output o_clkph_evn,
		output o_clkph_odd
		);

logic even_ph_LSB,even_ph_MSB;
logic odd_ph_LSB,odd_ph_MSB;

logic clkph_even,clkph_odd;

//========================================FIRST MUX==============================================================

assign even_ph_LSB =(i_pi_en == 1'b1 && i_piphsel_stg1[0] == 1'b1) ? i_clkph[0] :
		      		  (i_pi_en == 1'b1 && i_piphsel_stg1[2] == 1'b1) ? i_clkph[2] :
		      		  (i_pi_en == 1'b1 && i_piphsel_stg1[4] == 1'b1) ? i_clkph[4] :
		      		  (i_pi_en == 1'b1 && i_piphsel_stg1[6] == 1'b1) ? i_clkph[6] :
		      		  (i_pi_en == 1'b1 && (i_piphsel_stg1[0] == 1'b0 && i_piphsel_stg1[2] ==1'b0 && i_piphsel_stg1[4]==1'b0 && i_piphsel_stg1[6]==1'b0))? 1'bz :0;



assign even_ph_MSB = (i_pi_en == 1'b1 && i_piphsel_stg1[0] == 1'b1) ? i_clkph[8] :
		      			(i_pi_en == 1'b1 && i_piphsel_stg1[2] == 1'b1) ? i_clkph[10] :
		      			(i_pi_en == 1'b1 && i_piphsel_stg1[4] == 1'b1) ? i_clkph[12] :
		      			(i_pi_en == 1'b1 && i_piphsel_stg1[6] == 1'b1) ? i_clkph[14] :
		      			(i_pi_en == 1'b1 && (i_piphsel_stg1[0] == 1'b0 && i_piphsel_stg1[2] ==1'b0 && i_piphsel_stg1[4]==1'b0 && i_piphsel_stg1[6]==1'b0))? 1'bz :0;


assign odd_ph_LSB = (i_pi_en == 1'b1 && i_piphsel_stg1[1] == 1'b1) ? i_clkph[1] :
		      		  (i_pi_en == 1'b1 && i_piphsel_stg1[3] == 1'b1) ? i_clkph[3] :
		      		  (i_pi_en == 1'b1 && i_piphsel_stg1[5] == 1'b1) ? i_clkph[5] :
		      		  (i_pi_en == 1'b1 && i_piphsel_stg1[7] == 1'b1) ? i_clkph[7] :
		      		  (i_pi_en == 1'b1 && (i_piphsel_stg1[1] == 1'b0 && i_piphsel_stg1[3] ==1'b0 && i_piphsel_stg1[5]==1'b0 && i_piphsel_stg1[7]==1'b0))? 1'bz :0;

assign odd_ph_MSB = (i_pi_en == 1'b1 && i_piphsel_stg1[1] == 1'b1) ? i_clkph[9] :
		      		  (i_pi_en == 1'b1 && i_piphsel_stg1[3] == 1'b1) ? i_clkph[11] :
		      		  (i_pi_en == 1'b1 && i_piphsel_stg1[5] == 1'b1) ? i_clkph[13] :
		      		  (i_pi_en == 1'b1 && i_piphsel_stg1[7] == 1'b1) ? i_clkph[15] :
		      		  (i_pi_en == 1'b1 && (i_piphsel_stg1[1] == 1'b0 && i_piphsel_stg1[3] ==1'b0 && i_piphsel_stg1[5]==1'b0 && i_piphsel_stg1[7]==1'b0))? 1'bz :0;

//=========================================SECOND STAGE=============================================================
assign clkph_even = (i_pi_en == 1'b1 && i_piphsel_stg2[0] == 1'b0) ? even_ph_LSB :
						  (i_pi_en == 1'b1 && i_piphsel_stg2[0] == 1'b1) ? even_ph_MSB : 0;


assign clkph_odd =  (i_pi_en == 1'b1 && i_piphsel_stg2[1] == 1'b0) ? odd_ph_LSB :
						  (i_pi_en == 1'b1 && i_piphsel_stg2[1] == 1'b1) ? odd_ph_MSB : 0;

//================================================OUTPUT============================================================
assign o_clkph_evn = (i_pi_en == 1'b1) ? clkph_even : 0;
assign o_clkph_odd = (i_pi_en == 1'b1) ? clkph_odd : 0;



endmodule


module aibio_pi_mixer_top
		(
		//--------Supply pins----------//
		input vddcq,
		input vss,
		//--------Input pins----------//
		input i_clkph_evn,
		input i_clkph_odd,
		input [7:0] i_oddph_en,
		input i_pien,
		//--------Output pins----------//
		output o_clkmix_out
		);

real t1,t2,t3;
logic flag_even=0;
logic flag_odd=0;

integer i;
integer ones;
real clk_delay;
real out_ph;
logic clkmix_out_local=0;

always @(posedge i_clkph_evn,posedge i_clkph_odd)
begin
	if(i_clkph_evn===1'b1)
	begin
		if(!i_clkph_odd)
		begin
			flag_even=1;
			flag_odd=0;
			t1=$realtime;
			wait(i_clkph_odd==1'b1);
			t2=$realtime;
			t3=t2-t1;
		end
	end
	else if(i_clkph_odd===1'b1)
	begin
		if(!i_clkph_evn)
		begin
			flag_odd=1;
			flag_even=0;
			t1=$realtime;
			wait(i_clkph_evn==1'b1);
			t2=$realtime;
			t3=t2-t1;
		end
	end
end

always @(i_clkph_evn,i_clkph_odd)
begin
	if(i_clkph_evn===1'hz)
	begin
		flag_odd=1;
		flag_even=0;
	end
	else if(i_clkph_odd===1'hz)
	begin
		flag_even=1;
		flag_odd=0;
	end
end

assign clk_delay=t3;


always @(i_oddph_en)
begin
    ones = 0;  //initialize count variable.
    for(i=0;i<8;i=i+1)   //check for all the bits.
        if(i_oddph_en[i] == 1'b1)    //check if the bit is '1'
            ones = ones + 1;    //if its one, increment the count.
end

assign out_ph =(i_pien==1'b1 && ones==1) ? (clk_delay/8) :
					(i_pien==1'b1 && ones==2) ? (2*(clk_delay/8)) :
					(i_pien==1'b1 && ones==3) ? (3*(clk_delay/8)) :
					(i_pien==1'b1 && ones==4) ? (4*(clk_delay/8)) :
					(i_pien==1'b1 && ones==5) ? (5*(clk_delay/8)) :
					(i_pien==1'b1 && ones==6) ? (6*(clk_delay/8)) :
					(i_pien==1'b1 && ones==7) ? (7*(clk_delay/8)) : 0;


always @(i_clkph_evn,i_clkph_odd,i_pien,i_oddph_en,out_ph)
begin

	if(i_pien==1'b1 && flag_even==1'b1)
	begin
		clkmix_out_local <= #(out_ph) i_clkph_evn;
	end
	else if(i_pien==1'b1 && flag_odd==1'b1)
	begin
		clkmix_out_local <= #(out_ph) i_clkph_odd;
	end
	else
		clkmix_out_local=0;
end

assign o_clkmix_out = (i_pien==1'b1 && i_clkph_evn===1'hz) ? i_clkph_odd :
		      			 (i_pien==1'b1 && i_clkph_odd===1'hz) ? i_clkph_evn : clkmix_out_local;



endmodule


module aibio_piclk_dist
		(
		//---------Supply pins------------//
		input vddcq,
		input vss,
		//---------Input pins------------//
		input i_piclk_even_in,
		input i_piclk_odd_in,
		input i_loopback_en,
		//---------Output pins----------//
		output o_piclk_even_loopback,
		output o_piclk_odd_loopback
		);

assign o_piclk_even_loopback = i_loopback_en ? i_piclk_even_in : 1'b0;
assign o_piclk_odd_loopback = i_loopback_en ? i_piclk_odd_in : 1'b0;

endmodule


module aibio_loopback_detect
		(
		//----------Supply pins------------//
		input vddcq,
		input vss,
		//---------Input pins--------------//
		input i_cdr_clk,
		input i_piclk_90,
		input i_piclk_180,
		input i_sdr_mode,
		input i_reset,
		//---------Output pins-------------//
		output reg o_cdr_phdet
		);

wire clk_int;

assign clk_int = (i_sdr_mode) ? i_piclk_180 : i_piclk_90;

always @(posedge clk_int or i_reset)
begin
	if(i_reset)
	begin
		o_cdr_phdet = 1'b0;
	end
	else
	begin
		o_cdr_phdet = i_cdr_clk;
	end
end

endmodule
