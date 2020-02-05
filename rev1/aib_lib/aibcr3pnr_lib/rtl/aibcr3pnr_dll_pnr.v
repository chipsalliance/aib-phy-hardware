// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
//------------------------------------------------------------------------
// Copyright (c) 2012 Altera Corporation. .
//
//------------------------------------------------------------------------
// File:        $ aibcr3pnr_dll_pnr.v $
// Date:        $DateTime: 2016/09/09 18:29:16 $
//------------------------------------------------------------------------
// Description: AIB DLL PnR 
//1. Copied over from io_dll_pnr and modified :
//	a. added input port csr_reg[51:0] --> AIB will receive csr/dprio from PCS adapter. 
//        i. csrclk, csren, early_csren, csrdatain, csr_scan_shift_n, csrdataout, cas_csrdin, cas_csrdout ports removed  
//        ii. instanciated csr registers removed
//        iii. csr related parameters commented out
//      b. added in input ports rb_clkdiv[1:0],rb_selflock,rb_half_code,dll_lock
//      c. added output port pvt_ref_half_gry
//      d. removed ports :
/*	      scan_shift_n,
              dft_pipeline_global_en_n,
	      bhniotri,               //core control signal
              early_bhniotri,         //hps control signal
              enrnsl,                 //core control signal
              early_enrnsl,           //hps control signal
              frzreg,                 //core control signal
              early_frzreg,           //hps control signal
              nfrzdrv,                //core control signal
              early_nfrzdrv,          //hps control signal
              niotri,                 //core control signal
              early_niotri,           //hps control signal
              plniotri,               //core control signal
              early_plniotri,         //hps control signal
              usermode,               //core control signal
              early_usermode,         //hps control signal
              wkpullup,               //core control signal
              local_bhniotri,         //local control signal
              local_enrnsl,           //local control signal
              local_frzreg,           //local control signal
              local_nfrzdrv,          //local control signal
              local_niotri,           //local control signal
              local_plniotri,         //local control signal
              local_usermode,         //local control signal
              local_wkpullup,         //local control signal
              hps_to_core_ctrl_en,    //rbpa_hps_ctrl_en sent to core
              test_si_dll,            //negative scan chain in
              test_so_dll,            //positive scan chain output
              test_dqs_o1,            // DFT test o from io_dqs_lgc_pnr scan chain1
              test_dqs_o2,            // DFT test o from io_dqs_lgc_pnr scan chain2
*/
//      e. added scan ports
/*	      pipeline_global_en,
              scan_mode_n,
              scan_shift,
              scan_rst_n,
              scan_clk_in,
              scan_in,
              scan_out
*/
//     f. replaced inherited test* ports with scan* ports
/*            (i) test_clk ==> scan_clk_in
	      (ii) atpg_en_n ==> scan_mode_n
              (iii) test_clr_n ==> scan_rst_n
*/
//     g. added synchronizers for t_up and t_down
//     h. bring out gate_shf
//     i. updated ctrl reset (follow io_dll_ctrl) after adding synchronizer 
//     j. increase bus width of rb_clkdiv from 2 to 3-bit
//     k. replaced aibcrpnr_sync with hd_dpcmn_bitsync3
//     l. changed scan_shift to scan_shift_n
//     m. connected scan_mode_n to dll_core
//------------------------------------------------------------------------
// Uncertainity :
//1. Need to remove all the hps and dqs related ports?
//------------------------------------------------------------------------

module aibcr3pnr_dll_pnr
#(
//-----------------------------------------------------------------------------------------------------------------------
//  Local calculated parameters
//-----------------------------------------------------------------------------------------------------------------------
parameter FF_DELAY     = 200
)
(
   input  wire [2:0]   core_dll,               // input from core to dll; DFT pins 
   input  wire         clk_pll,                // incoming clock, used to clock FSM
   input       [51:0]  csr_reg,                // AVMM bits from AIB adapter
   input  wire         reinit,                 // initialization enable
   input  wire         entest,                 // test enable
   input  wire         t_up,                   // output of phase detector outside of this RTL block
   input  wire         t_down,                 // output of phase detector outside of this RTL block
   output wire         launch,                 // Decode from gate_shf, Used as the input to the delay line
   output wire         measure,                // Decode from gate_shf, Used as the clock for the phase detector
   output wire   [7:0] f_gray,                 // gray code for nand delay chain, which is the coarse delay chain; increase to 8 bits
   output wire   [2:0] i_gray,                 // gray code for phase interpolator, which is the fine delay chain
   output wire  [12:0] dll_core,               // output from dll to core; DFT pins
   output wire   [10:0] pvt_ref_gry,            // filtered delay setting from dll, representing 1-clock-cycle worth of delay; increase to 11 bits
   output wire   [10:0] pvt_ref_half_gry,       // filtered delay setting from dll, representing 1/2-cycle worth of delay; increase to 11 bits
   output wire         dll_phdet_reset_n,      //
   output wire         dll_lock,
   output wire  [6:0]  gate_shf,               // for synchronizing purpose
   input  wire         test_clk_pll_en_n,      // ATPG :
   input wire  [2:0]   rb_clkdiv,
   input wire	       rb_selflock,
   input wire          rb_half_code,
   input wire          pipeline_global_en,
   input wire          scan_mode_n,
   input wire          scan_shift_n,
   input wire          scan_rst_n,
   input wire          scan_clk_in,
   input wire          scan_in,
   output wire         scan_out
);

`ifdef TIMESCALE_EN
  timeunit 1ps;
  timeprecision 1ps;
`endif

//----------------------------------------------------------------------------------------------------------------------------------------------------------------
//--- wire & reg -------------------------------------------------------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------------------------------------------------------------------

   wire       clk_pll_gated;
   wire       clk_pll_gated_tmux;
   wire       clk_pll_tmux;
   wire       reset_n_tmux;
//   reg        clk_pll_obs;
//   reg        reset_n_obs;

   wire                rb_dll_rst_en;
   wire                rb_dll_en;
   wire                rb_ndllrst_prgmnvrt;
   wire                rb_core_up_prgmnvrt;
   wire                rb_core_dn_prgmnvrt;
   wire                rb_core_updnen;
   wire                rb_spare;
   wire [10:0]          rb_dly_pst;              // increase to 11 bits
   wire                rb_ctlsel;
   wire [10:0]          rb_ctl_static;           // increase to 11 bits
   wire [21:0]         rb_dftmuxsel;
//   wire [3:0]          rb_new_dll;
   wire                core_up_in;
   wire                core_dn_in;
   wire [10:0]          pvt_ref_binary;          // increase to 11 bits
   wire [10:0]          internal_pvt_binary;     // binary pvt value for dll internal delay chain; increae to 11 bits
   wire                search_overflow;
   wire [3:0]          gate_state;  
   reg  [10:0]          dll_dftout;
   wire                up_core;
   wire                dn_core;
   wire                core_up;
   wire                core_dn;
   wire                ndllrst;
   wire                ndllrst_in;
   wire                dll_reset_n;            
   wire                test_clk_en;
//   wire                test_clk_gated;
   wire                scan_shift;

//========================================================================================================================================================================
//  test_clk muxes
//========================================================================================================================================================================

assign test_clk_en                = ~test_clk_pll_en_n;
assign scan_shift = ~scan_shift_n;

/* aibcrpnr_dll_atech_clkgate_cgc00 gated_clk_pll_inst  
(
    .clk    (clk_pll),
    .en     (1'b1),
    .clkout (clk_pll_gated)
);
*/

assign clk_pll_gated = clk_pll;                       // replace the clock gating cell with buffer, since the en is always 1b'1


//aibcrpnr_dll_atech_clkgate_cgc01 gated_test_clk_inst
/*
Removed after discussion with DFT team (Joseph)

c3lib_ckg_posedge_ctn gated_test_clk_inst
(
    .tst_en     (scan_shift),
    .clk_en     (test_clk_en),   
    .clk        (scan_clk_in),
    .gated_clk  (test_clk_gated)
);
*/

// aibcrpnr_dll_atech_clkmux muxed_pll_gated_inst
c3lib_mux2_ctn muxed_pll_gated_inst
(
    .ck0    (scan_clk_in),
    .ck1    (clk_pll_gated),
    .s0     (scan_mode_n),
    .ck_out (clk_pll_gated_tmux)
);


// aibcrpnr_dll_atech_clkmux muxed_pll_inst   
c3lib_mux2_ctn muxed_pll_inst   
(
    .ck0    (scan_clk_in),
    .ck1    (clk_pll),
    .s0     (scan_mode_n),
    .ck_out (clk_pll_tmux)
);

assign dll_phdet_reset_n          = scan_mode_n ? reset_n_tmux           : 1'b0 ;

//always @(posedge scan_clk_in) clk_pll_obs               <= #FF_DELAY clk_pll;
//always @(posedge scan_clk_in) reset_n_obs               <= #FF_DELAY reset_n_tmux;

//========================================================================================================================================================================
//end csr for phase alignment
//========================================================================================================================================================================

   assign rb_dll_rst_en                = csr_reg[0];		              //core reset enable
   assign rb_dll_en                    = csr_reg[1];		              //dll enable
   assign rb_ndllrst_prgmnvrt          = csr_reg[2];		              //core reset signal programmable inv
   assign rb_core_up_prgmnvrt          = csr_reg[3];		              //core_up signal programmable inv
   assign rb_core_dn_prgmnvrt          = csr_reg[4];		              //core_dn signal programmable inv
   assign rb_core_updnen               = csr_reg[5];		              //core updown control enable
   assign rb_dly_pst[10:0]             = csr_reg[16:6];                       //delay preset setting; change - increase 1 bit
   assign rb_ctlsel                    = csr_reg[17];		              //dll setting selection
   assign rb_ctl_static[10:0]          = {csr_reg[50],csr_reg[27:18]};	      //dll static setting; change - increase 1 bit
   assign rb_dftmuxsel[21:0]           = csr_reg[49:28];	              //dft mux selection; change - change from [19:0] to [21:0]
   assign rb_spare                     = csr_reg[51];                         //Not used
// assign rb_new_dll[3:0]              = csr_reg[51:48];   	
                                                                
   assign core_up         = core_dll[0];
   assign core_dn         = core_dll[1];
   assign ndllrst         = core_dll[2];

always @(*)
  case (rb_dftmuxsel[21:20])                                   // change - add 2 csr bits to observe bit[10]
    2'b00   : dll_dftout[10] =  pvt_ref_half_gry[10];
    2'b01   : dll_dftout[10] =  pvt_ref_binary[10];
    2'b10   : dll_dftout[10] =  internal_pvt_binary[10];
    2'b11   : dll_dftout[10] =  1'b0;
    default : dll_dftout[10] =  1'b0;
  endcase

always @(*)
  case (rb_dftmuxsel[19:18])                                   
    2'b00   : dll_dftout[9] =  pvt_ref_half_gry[9];
    2'b01   : dll_dftout[9] =  pvt_ref_binary[9];
    2'b10   : dll_dftout[9] =  internal_pvt_binary[9];
    2'b11   : dll_dftout[9] =  1'b0;
    default : dll_dftout[9] =  1'b0;
  endcase

always @(*)
  case (rb_dftmuxsel[17:16])
    2'b00   : dll_dftout[8] =  pvt_ref_half_gry[8];
    2'b01   : dll_dftout[8] =  pvt_ref_binary[8];
    2'b10   : dll_dftout[8] =  internal_pvt_binary[8];
    2'b11   : dll_dftout[8] =  1'b0;
    default : dll_dftout[8] =  1'b0;
  endcase

always @(*)
  case (rb_dftmuxsel[15:14])
    2'b00   : dll_dftout[7] =  pvt_ref_half_gry[7];
    2'b01   : dll_dftout[7] =  pvt_ref_binary[7];
    2'b10   : dll_dftout[7] =  internal_pvt_binary[7];
    2'b11   : dll_dftout[7] =  1'b0;
    default : dll_dftout[7] =  1'b0;
  endcase

always @(*)
  case (rb_dftmuxsel[13:12])
    2'b00   : dll_dftout[6] =  pvt_ref_half_gry[6];
    2'b01   : dll_dftout[6] =  pvt_ref_binary[6];
    2'b10   : dll_dftout[6] =  internal_pvt_binary[6];
    2'b11   : dll_dftout[6] =  1'b0;
    default : dll_dftout[6] =  1'b0;
  endcase

always @(*)
  case (rb_dftmuxsel[11:10])
    2'b00   : dll_dftout[5] =  pvt_ref_half_gry[5];
    2'b01   : dll_dftout[5] =  pvt_ref_binary[5];
    2'b10   : dll_dftout[5] =  internal_pvt_binary[5];
    2'b11   : dll_dftout[5] =  gate_state[3];
    default : dll_dftout[5] =  1'b0;
  endcase

always @(*)
  case (rb_dftmuxsel[9:8])
    2'b00   : dll_dftout[4] =  pvt_ref_half_gry[4];
    2'b01   : dll_dftout[4] =  pvt_ref_binary[4];
    2'b10   : dll_dftout[4] =  internal_pvt_binary[4];
    2'b11   : dll_dftout[4] =  gate_state[2];
    default : dll_dftout[4] =  1'b0;
  endcase

always @(*)
  case (rb_dftmuxsel[7:6])
    2'b00   : dll_dftout[3] =  pvt_ref_half_gry[3];
    2'b01   : dll_dftout[3] =  pvt_ref_binary[3];
    2'b10   : dll_dftout[3] =  internal_pvt_binary[3];
    2'b11   : dll_dftout[3] =  gate_state[1];
    default : dll_dftout[3] =  1'b0;
  endcase

always @(*)
  case (rb_dftmuxsel[5:4])
    2'b00   : dll_dftout[2] =  pvt_ref_half_gry[2];
    2'b01   : dll_dftout[2] =  pvt_ref_binary[2];
    2'b10   : dll_dftout[2] =  internal_pvt_binary[2];
    2'b11   : dll_dftout[2] =  gate_state[0];
    default : dll_dftout[2] =  1'b0;
  endcase

always @(*)
  case (rb_dftmuxsel[3:2])
    2'b00   : dll_dftout[1] =  pvt_ref_half_gry[1];
    2'b01   : dll_dftout[1] =  pvt_ref_binary[1];
    2'b10   : dll_dftout[1] =  internal_pvt_binary[1];
    2'b11   : dll_dftout[1] =  search_overflow;
    default : dll_dftout[1] =  1'b0;
  endcase

always @(*)
  case (rb_dftmuxsel[1:0])
    2'b00   : dll_dftout[0] =  pvt_ref_half_gry[0];
    2'b01   : dll_dftout[0] =  pvt_ref_binary[0];
    2'b10   : dll_dftout[0] =  internal_pvt_binary[0];
    2'b11   : dll_dftout[0] =  reset_n_tmux;
    default : dll_dftout[0] =  1'b0;
  endcase

   assign dll_core[12]  = dn_core;
   // assign dll_core[11]  = up_core;
   assign dll_core[11]  = scan_mode_n ? dll_lock : clk_pll_gated;		//dft request; change - change from [10] to [11]
   assign dll_core[10:0] = dll_dftout;                                          //change - [10] is now for delay code[10] observability

   assign ndllrst_in    = (rb_ndllrst_prgmnvrt)   ? ~ndllrst   : ndllrst;   	//core reset
   assign core_up_in  = (rb_core_up_prgmnvrt) ? ~core_up : core_up; 		//core up signal
   assign core_dn_in  = (rb_core_dn_prgmnvrt) ? ~core_dn : core_dn; 		//core dn signal

aibcr3pnr_dll_ctrl xdll_ctrl (
      .clk(clk_pll_tmux),
      .reinit(reinit),
      .entest(entest),
      .ndllrst_in(ndllrst_in),
      .rb_dll_en(rb_dll_en),
      .rb_dll_rst_en(rb_dll_rst_en),
      .atpg_en_n(scan_mode_n),
      .test_clr_n(scan_rst_n),
      .dll_reset_n(reset_n_tmux)
);

//t_up and t_down synchronization

wire t_up_sync,t_down_sync;

//hd_dpcmn_bitsync3 xsync_tup  ( .rst_n(reset_n_tmux), .clk(clk_pll_gated_tmux), .data_in(t_up),  .data_out(t_up_sync) ); 
//hd_dpcmn_bitsync3 xsync_tdown  ( .rst_n(reset_n_tmux), .clk(clk_pll_gated_tmux), .data_in(t_down),  .data_out(t_down_sync) ); 
c3lib_sync3_ulvt_bitsync xsync_tup  ( .rst_n(reset_n_tmux), .clk(clk_pll_gated_tmux), .data_in(t_up),  .data_out(t_up_sync) );
c3lib_sync3_ulvt_bitsync xsync_tdown  ( .rst_n(reset_n_tmux), .clk(clk_pll_gated_tmux), .data_in(t_down),  .data_out(t_down_sync) ); 

aibcr3pnr_dll_core xdll_core (
.clk           		( clk_pll_gated_tmux    	),
.reset_n       		( reset_n_tmux           	),
.rb_ctlsel     		( rb_ctlsel             	),
.rb_ctl_static 		( rb_ctl_static[10:0]    	),
.rb_core_updnen		( rb_core_updnen        	),
.rb_clkdiv              ( rb_clkdiv[2:0]		),
.rb_selflock            ( rb_selflock                   ),
.rb_half_code           ( rb_half_code                  ),
.rb_dly_pst             ( rb_dly_pst[10:0]              ),
.core_up       		( core_up_in            	),
.core_dn       		( core_dn_in            	),
.t_up          		( t_up_sync                  	),
.t_down        		( t_down_sync                	),
.launch        		( launch                	),
.measure       		( measure               	),
.f_gray        		( f_gray[7:0]           	),
.i_gray        		( i_gray[2:0]           	),
.up_core       		( up_core               	), 
.dn_core       		( dn_core               	), 
.scan_mode_n            ( scan_mode_n                   ),
.lock      		( dll_lock              	), 
.pvt_ref_binary		( pvt_ref_binary[10:0]   	), 
.internal_pvt_binary	( internal_pvt_binary[10:0]   	), 
.search_overflow	( search_overflow   		), 
.gate_state		( gate_state[3:0]   		), 
.gate_shf               ( gate_shf[6:0]                 ),
.pvt_ref_gry   		( pvt_ref_gry[10:0]      	), 
.pvt_ref_half_gry       ( pvt_ref_half_gry[10:0]        )
);

endmodule // aibcr3pnr_dll_pnr
