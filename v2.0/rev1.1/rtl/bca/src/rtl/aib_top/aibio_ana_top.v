// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2022 HCL Technologies Ltd.
// Copyright (C) 2022 Blue Cheetah Analog Design, Inc.

module aibio_ana_top
(
inout [101:0] iopad,
inout  vddc2,
inout  vddc1,
inout  vddtx,
inout  vss,
//=========================================
input       [101:0] tx_datain_even, //From Adapter
input       [101:0] tx_datain_odd,
input       [101:0] async_data_in,
output wire [101:0] rx_even_out, //To Adapter
output wire [101:0] rx_odd_out,
output wire [101:0] async_data_out,
input       [1:0]   shift_en_clkbuf,
//====================================
input               test_clk,
input               jtag_clk,
input               jtag_tx_scanen_in,
input               jtag_din,
input               jtag_mode_in,
input               jtag_rstb_en,
input               jtag_rstb,
input               jtag_intest,
output              jtag_dout,
//====================================
input               rx_calen,
input               rcomp_cal_en_g1,
input               rcomp_cal_en_g2,
input  [4:0]        rx_ofscal_g1,
input  [4:0]        rx_ofscal_g2,
input  [6:0]        rcomp_cal_code_g1,
input  [6:0]        rcomp_cal_code_g2,
output              rcomp_out_g2, 
output              rcomp_out_g1, 
input  [101:0]      rx_en,
input               gen1mode_en,
input               gen2mode_en,
input  [101:0][4:0] rx_ofscal_even, 
input  [101:0][4:0] rx_ofscal_odd,
input  [3:0]        rx_deskew,
input  [103:0]      txrx_dfx_en,
input  [4:0]        txrx_digviewsel,
input  [2:0]        txrx_anaviewsel,
input  [4:0]        onehot_anaviewsel,
output [3:0]        txrx_anaviewout,
input  [101:0]      tx_en,
input  [101:0]      tx_async_en,
input  [101:0]      rx_async_en,
input  [101:0]      sdr_mode_en,
input  [101:0]      wkpu_en,
input  [101:0]      wkpd_en,
input  [101:0]      fault_stdby,
input  [101:0]      tx_bypass_serialiser,
input  [7:0]        txdrv_npd_sel,
input  [7:0]        txdrv_npu_sel,
input  [7:0]        txdrv_ppu_sel,
input  [3:0]        tx_deskew,
input               iotxrx_tx_deskew_en_ff,   
input               iotxrx_tx_deskew_step_ff, 
input               iotxrx_tx_deskew_ovrd_ff, 
input               iotxrx_rx_deskew_en_ff,   
input               iotxrx_rx_deskew_step_ff, 
input               iotxrx_rx_deskew_ovrd_ff, 
//===========================================
//TX DLL
//------Input pins------//
input ck_in,
input ck_sys,
input tx_dll_en,
input rx_dll_en,
input tx_dll_reset,
input rx_dll_reset,
input [1:0] tx_inp_clksel,
input [1:0] rx_inp_clksel,
input [3:0] tx_dll_biasctrl,
input [3:0] rx_dll_biasctrl,
input [4:0] tx_dll_capctrl,
input [4:0] rx_dll_capctrl,
input [3:0] dll_cksoc_code,
input [3:0] dll_ckadapter_code,
input [3:0] dll_even_phase1_sel,
input [3:0] dll_odd_phase1_sel,
input [3:0] dll_even_phase2_sel,
input [3:0] dll_odd_phase2_sel,
input [3:0] tx_dll_lockthresh,
input [3:0] rx_dll_lockthresh,
input [1:0] tx_dll_lockctrl,
input [1:0] rx_dll_lockctrl,
input tx_dll_dfx_en,
input rx_dll_dfx_en,
input sdr_mode,
input [4:0] tx_dll_digview_sel,
input [4:0] rx_dll_digview_sel,
//------Output pins------//
output wire tx_dll_lock,
output wire clk_soc,
output wire clk_adapter,
output wire tx_clk_even,
output wire tx_dll_anaviewout,

//RX DLL
//------Input pins------//
input picode_update,
input [3:0] pi_biasctrl,
input [4:0] pi_capctrl,
input [3:0] cdr_ctrl,
input [7:0] dll_piodd_code,
input [7:0] dll_pieven_code,
input [3:0] dll_pisoc_code,
input [3:0] dll_piadapter_code,
input       n_lpbk,
//------Output pins------//
output wire phdet_cdr_out,
output wire rx_dll_lock,
output wire piclk_adapter,
output wire piclk_soc,
output wire piclk_odd,
output wire rx_dll_anaviewout,
//------Spare pins------//
output wire [1:0]digviewout,

//VREF_CBB
//------Input pins------//
input vref_en,
input calvref_en,
input [6:0] vref_bin_0,
input [6:0] vref_bin_1,
input [6:0] vref_bin_2,
input [6:0] vref_bin_3,
input [4:0] calvref_bin,

//Rx Clk CBB
//------Input pins------//
input [4:0] dcc_p_pdsel,
input [4:0] dcc_p_pusel,
input [4:0] dcc_n_pdsel,
input [4:0] dcc_n_pusel,
input rxclk_en,
input [2:0]ibias_ctrl_red,
input [2:0]ibias_ctrl_nored,
input [2:0]ibias_ctrl_cdr,
//DCS CBB
//------Input pins------//
input [1:0] clkdiv,
input reset,
input sel_clkp,
input sel_clkn,
input en_single_ended,
input chopen,
input dcs_dfx_en,
//------Output pins------//
output wire dc_gt_50,
output wire dcs_anaviewout,
// Scan mode
input i_scan_mode
);

//Oring all the digviewout signals
//Clock buffer distribution to txrx_cbb module
wire [101:0]ckrx_even;
wire [101:0]ckrx_odd;
wire [101:0]cktx_even;
wire [101:0]cktx_odd;
wire [101:0]txrx_anaviewout_intr;
wire [7:0]  o_txrx_spare_g1_nc;
wire [7:0]  o_txrx_spare_g2_nc;
wire piclk_even ;
wire piclk_even_lpbk, piclk_odd_lpbk;
wire pulseclk_even_loopback, pulseclk_odd_loopback;
wire tx_clk_odd ;
//Output from Vref module
wire rx_vrefp_gen1, rx_vrefn_gen1, rx_vrefp_gen2, rx_vrefn_gen2;
wire calvref;

wire redun_sel, fs_fwd_clkp_out_cdr, fs_fwd_clkn_out_cdr;
wire fs_fwd_clkp_out_red, fs_fwd_clkp_out_nored;
wire fs_fwd_clkn_out_red, fs_fwd_clkn_out_nored;
wire [3:0]tx_ipbias;

wire [1:0] rx_dll_digviewout;
wire [1:0] tx_dll_digviewout;
wire [7:0] o_dll_spare_tx_nc;
wire       rx_inbias_nc;
wire       rx_ipbias_nc;
wire       piclk_odd_fifo_nc;
wire       piclk_even_fifo_nc;
wire [7:0] o_dll_spare_rx_nc;
wire [3:0] o_vref_spare_nc;
wire       dc_gt_50_preflop_nc;
wire       ckph1_nc;
wire [203:0]  txrx_digviewout;
wire       tx_inbias_nc;
reg        txrx_digviewout_0;
reg        txrx_digviewout_1;

//Inv1 clock buffer
wire [3:0]clkp_inv1;
wire [3:0]clkn_inv1;
wire [3:0]clkp_b_inv1;
wire [3:0]clkn_b_inv1;

wire [3:0]clkp_inv1_lpbk;
wire [3:0]clkn_inv1_lpbk;
wire [3:0]clkp_b_inv1_lpbk;
wire [3:0]clkn_b_inv1_lpbk;

//Inv2 clock buffer
wire [3:0]clkp_inv2;
wire [3:0]clkn_inv2;
wire [3:0]clkp_inv2_lpbk;
wire [3:0]clkn_inv2_lpbk;

wire [3:0]clkp_b_inv2;
wire [3:0]clkn_b_inv2;
wire [3:0]clkp_b_inv2_lpbk;
wire [3:0]clkn_b_inv2_lpbk;

wire [3:0] o_rxclk_spare_nored_nc;
wire [3:0] o_rxclk_spare_red_nc;
wire [3:0] o_rxclk_spare_cdr_nc;
wire [3:0] o_dcs_spare_nc;

wire rxclk_en_red;
wire rxclk_en_nored;
wire [6:0]txdrv_npu_code;
wire [6:0]txdrv_ppu_code;

wire [101:0] vdd;
wire [101:0] [3:0] tx_deskew_data;
wire [101:0] [3:0] rx_deskew_data;


wire [1:0] txrx_digviewout_g1_nc;
wire [1:0] txrx_digviewout_g2_nc; 
wire  txrx_anaviewout_g1_nc;
wire  txrx_anaviewout_g2_nc;
wire  rx_out_odd_g2_nc;
wire  rx_async_g2_nc;
wire  rcomp_out_g1_nc;
wire  rx_out_odd_g1_nc;

wire tx_clk_odd_nc;
wire tx_clk_even_nc;

wire fs_fwd_clkp_out;
wire fs_fwd_clkn_out;

//------------------------------------------------------------------------------
// Boundary scan implementation
//------------------------------------------------------------------------------
wire [101:0] rx_padasync_o;
wire [101:0] jtag_clk_out_nc;
wire [101:0] jtag_dout_int;
wire [101:0] jtag_din_int;
wire [101:0] rxpad_en_i;
wire [101:0] tx_padasync_i;
wire [101:0] dig_rstb_aib_nc;
wire [101:0] jtag_clkn_out_nc;
wire         gen1mode_en_bs;
wire         gen2mode_en_bs;
wire [101:0] txrx_dfx_en_bs;
wire [101:0] sdr_mode_en_bs;
wire [101:0] rx_async_en_bs;
wire [101:0] tx_en_bs;
wire [101:0] tx_async_en_aib;
wire [101:0] tx_async_en_int;
integer m; // Interger for always loop

//------------------------------------------------------------------------------
// DLL signals with scan_mode logic
//------------------------------------------------------------------------------
wire [3:0] tx_dll_biasctrl_int;
wire [4:0] tx_dll_capctrl_int;     
wire [3:0] dll_cksoc_code_int;     
wire [3:0] dll_ckadapter_code_int;
wire [3:0] dll_even_phase1_sel_int;
wire [3:0] dll_odd_phase1_sel_int; 
wire [3:0] dll_even_phase2_sel_int;
wire [3:0] dll_odd_phase2_sel_int; 
wire [3:0] tx_dll_lockthresh_int; 
wire [1:0] tx_dll_lockctrl_int;   
wire       n_lpbk_int;
wire       tx_dll_dfx_en_int; 
wire [4:0] tx_dll_digview_sel_int; 
wire [4:0] onehot_anaviewsel_int;  

wire [3:0] rx_dll_biasctrl_int;
wire [4:0] rx_dll_capctrl_int;
wire [3:0] pi_biasctrl_int;
wire [4:0] pi_capctrl_int;
wire [3:0] cdr_ctrl_int;
wire [7:0] dll_piodd_code_int;
wire [7:0] dll_pieven_code_int;
wire       picode_update_int;
wire [3:0] dll_pisoc_code_int;    
wire [3:0] dll_piadapter_code_int;
wire [3:0] rx_dll_lockthresh_int;
wire [1:0] rx_dll_lockctrl_int;
wire       rx_dll_dfx_en_int;
wire       sdr_mode_int;
wire [4:0] rx_dll_digview_sel_int;
wire       rx_dll_en_int;
wire       rx_calen_int;

//------------------------------------------------------------------------------
// Multi Dimension array to one dimension array 
//------------------------------------------------------------------------------
wire [407:0] tx_deskew_data_int;
wire [407:0] rx_deskew_data_int;
genvar j;
generate
 for(j=0; j<102; j=j+1)
  begin
   assign tx_deskew_data_int[4*j+3:4*j]  = tx_deskew_data[j];
   assign rx_deskew_data_int[4*j+3:4*j]  = rx_deskew_data[j];
  end
endgenerate
//------------------------------------------------------------------------------
// Boundary scan implementation end
//------------------------------------------------------------------------------

genvar i;
generate
  for (i=0; i<44; i=i+1)
    begin: vdd_0_43
      assign vdd[i] = vddtx;
    end
  for (i=44; i<58; i=i+1)
    begin: vdd_44_57
      assign vdd[i] = vddc2; 
    end
  for (i=58; i<102; i=i+1)
    begin: vdd_50_101
      assign vdd[i] = vddtx;
    end
endgenerate


// TXRX digital view bits ored
always @(*)
  begin: txrx_digviewout_bit_logic
    for (m=0; m<102; m=m+1)
      begin
       txrx_digviewout_0 = 1'b0;
       txrx_digviewout_1 = 1'b0;
       txrx_digviewout_0 = txrx_digviewout_0 | txrx_digviewout[m*2];
       txrx_digviewout_1 = txrx_digviewout_1 | txrx_digviewout[m*2+1];
      end
  end // block: txrx_digviewout_bit_logic

assign  digviewout[0] = tx_dll_digviewout[0] |
                        rx_dll_digviewout[0] |
                        txrx_digviewout_0;

assign  digviewout[1] = tx_dll_digviewout[1] |
                        rx_dll_digviewout[1] |
                        txrx_digviewout_1;

//------------------------------------------------------------------------------
//                            BOUNDARY SCAN LOGIC
//------------------------------------------------------------------------------

// Connected  PADS DIN and DOUT according to physical position
// to help on placement.
assign jtag_din_int[100] = jtag_din;
assign jtag_din_int[101] = jtag_dout_int[100];
assign jtag_din_int[98]  = jtag_dout_int[101];
assign jtag_din_int[99]  = jtag_dout_int[98];
assign jtag_din_int[96]  = jtag_dout_int[99];
assign jtag_din_int[97]  = jtag_dout_int[96];

assign jtag_din_int[95]  = jtag_dout_int[97];
assign jtag_din_int[94]  = jtag_dout_int[95];
assign jtag_din_int[93]  = jtag_dout_int[94];
assign jtag_din_int[92]  = jtag_dout_int[93];
assign jtag_din_int[91]  = jtag_dout_int[92];
assign jtag_din_int[90]  = jtag_dout_int[91];

assign jtag_din_int[88]  = jtag_dout_int[90];
assign jtag_din_int[89]  = jtag_dout_int[88];
assign jtag_din_int[86]  = jtag_dout_int[89];
assign jtag_din_int[87]  = jtag_dout_int[86];
assign jtag_din_int[84]  = jtag_dout_int[87];
assign jtag_din_int[85]  = jtag_dout_int[84];

assign jtag_din_int[83]  = jtag_dout_int[85];
assign jtag_din_int[82]  = jtag_dout_int[83];
assign jtag_din_int[81]  = jtag_dout_int[82];
assign jtag_din_int[80]  = jtag_dout_int[81];
assign jtag_din_int[79]  = jtag_dout_int[80];
assign jtag_din_int[78]  = jtag_dout_int[79];

assign jtag_din_int[76]  = jtag_dout_int[78];
assign jtag_din_int[77]  = jtag_dout_int[76];
assign jtag_din_int[74]  = jtag_dout_int[77];
assign jtag_din_int[75]  = jtag_dout_int[74];
assign jtag_din_int[72]  = jtag_dout_int[75];
assign jtag_din_int[73]  = jtag_dout_int[72];

assign jtag_din_int[71]  = jtag_dout_int[73];
assign jtag_din_int[70]  = jtag_dout_int[71];
assign jtag_din_int[69]  = jtag_dout_int[70];
assign jtag_din_int[68]  = jtag_dout_int[69];
assign jtag_din_int[67]  = jtag_dout_int[68];
assign jtag_din_int[66]  = jtag_dout_int[67];

assign jtag_din_int[64]  = jtag_dout_int[66];
assign jtag_din_int[65]  = jtag_dout_int[64];
assign jtag_din_int[62]  = jtag_dout_int[65];
assign jtag_din_int[63]  = jtag_dout_int[62];
assign jtag_din_int[60]  = jtag_dout_int[63];
assign jtag_din_int[61]  = jtag_dout_int[60];

assign jtag_din_int[59]  = jtag_dout_int[61];
assign jtag_din_int[58]  = jtag_dout_int[59];
assign jtag_din_int[57]  = jtag_dout_int[58];
assign jtag_din_int[56]  = jtag_dout_int[57];
assign jtag_din_int[55]  = jtag_dout_int[56];
assign jtag_din_int[54]  = jtag_dout_int[55];

assign jtag_din_int[52]  = jtag_dout_int[54];
assign jtag_din_int[53]  = jtag_dout_int[52];
assign jtag_din_int[50]  = jtag_dout_int[53];
assign jtag_din_int[51]  = jtag_dout_int[50];
assign jtag_din_int[48]  = jtag_dout_int[51];
assign jtag_din_int[49]  = jtag_dout_int[48];

assign jtag_din_int[47]  = jtag_dout_int[49];
assign jtag_din_int[46]  = jtag_dout_int[47];
assign jtag_din_int[45]  = jtag_dout_int[46];
assign jtag_din_int[44]  = jtag_dout_int[45];
assign jtag_din_int[43]  = jtag_dout_int[44];
assign jtag_din_int[42]  = jtag_dout_int[43];

assign jtag_din_int[40]  = jtag_dout_int[42];
assign jtag_din_int[41]  = jtag_dout_int[40];
assign jtag_din_int[38]  = jtag_dout_int[41];
assign jtag_din_int[39]  = jtag_dout_int[38];
assign jtag_din_int[36]  = jtag_dout_int[39];
assign jtag_din_int[37]  = jtag_dout_int[36];

assign jtag_din_int[35]  = jtag_dout_int[37];
assign jtag_din_int[34]  = jtag_dout_int[35];
assign jtag_din_int[33]  = jtag_dout_int[34];
assign jtag_din_int[32]  = jtag_dout_int[33];
assign jtag_din_int[31]  = jtag_dout_int[32];
assign jtag_din_int[30]  = jtag_dout_int[31];

assign jtag_din_int[28]  = jtag_dout_int[30];
assign jtag_din_int[29]  = jtag_dout_int[28];
assign jtag_din_int[26]  = jtag_dout_int[29];
assign jtag_din_int[27]  = jtag_dout_int[26];
assign jtag_din_int[24]  = jtag_dout_int[27];
assign jtag_din_int[25]  = jtag_dout_int[24];

assign jtag_din_int[23]  = jtag_dout_int[25];
assign jtag_din_int[22]  = jtag_dout_int[23];
assign jtag_din_int[21]  = jtag_dout_int[22];
assign jtag_din_int[20]  = jtag_dout_int[21];
assign jtag_din_int[19]  = jtag_dout_int[20];
assign jtag_din_int[18]  = jtag_dout_int[19];

assign jtag_din_int[16]  = jtag_dout_int[18];
assign jtag_din_int[17]  = jtag_dout_int[16];
assign jtag_din_int[14]  = jtag_dout_int[17];
assign jtag_din_int[15]  = jtag_dout_int[14];
assign jtag_din_int[12]  = jtag_dout_int[15];
assign jtag_din_int[13]  = jtag_dout_int[12];

assign jtag_din_int[11]  = jtag_dout_int[13];
assign jtag_din_int[10]  = jtag_dout_int[11];
assign jtag_din_int[9]   = jtag_dout_int[10];
assign jtag_din_int[8]   = jtag_dout_int[9];
assign jtag_din_int[7]   = jtag_dout_int[8];
assign jtag_din_int[6]   = jtag_dout_int[7];

assign jtag_din_int[4]   = jtag_dout_int[6];
assign jtag_din_int[5]   = jtag_dout_int[4];
assign jtag_din_int[2]   = jtag_dout_int[5];
assign jtag_din_int[3]   = jtag_dout_int[2];
assign jtag_din_int[0]   = jtag_dout_int[3];
assign jtag_din_int[1]   = jtag_dout_int[0];

// TDO connection
assign jtag_dout = jtag_dout_int[1];

// Scan logc for TX ASYNC enable
assign tx_async_en_int[101:0] = i_scan_mode ?
                                {102{1'b0}} :
                                (tx_async_en[101:0] &
                                ~fault_stdby[101:0]);

generate
  for(i=0;i<102;i=i+1)
    begin: bscan_gen
       aib_bscan aib_bscan_pad1_i (
      .odat_asyn_aib     (rx_padasync_o[i]), //async data RX from AIB 
      .async_data_adap   (async_data_in[i]), //async data TX from HSSI Adapter
      .tx_async_en_adap  (tx_async_en_int[i]), // TX asynchronous enable from Adapter
      .jtag_tx_scanen_in (jtag_tx_scanen_in), //JTAG shift DR, active high
      .tx_jtag_clk_g     (jtag_clk), // clock for TX shift register
      .rx_jtag_clk_g     (jtag_clk), // clock for RX shift register
      .jtag_tx_scan_in   (jtag_din_int[i]), //JTAG TX data scan in
      .jtag_mode_in      (jtag_mode_in), //JTAG mode select
      .jtag_rstb_en      (jtag_rstb_en), //reset_en from TAP
      .jtag_rstb         (jtag_rstb), //reset signal from TAP
      .jtag_intest       (jtag_intest), //intest from TAP                         
      // Outputs
      .jtag_rx_scan_out  (jtag_dout_int[i]),  //JTAG TX scan chain output
      .tx_async_en_aib   (tx_async_en_aib[i]),// TX asynchronous enable to AIB pad
      .odat_asyn_adap    (async_data_out[i]), //async data RX to HSSI Adapter
      .async_data_aib    (tx_padasync_i[i])   //async data TX to AIB
      );
    end // block: bscan_gen
endgenerate

assign rxpad_en_i[101:0] = rx_en[101:0]       &
                          ~fault_stdby[101:0] &
                          {102{(~i_scan_mode)}};

assign gen1mode_en_bs        = jtag_mode_in ? 1'b1   : gen1mode_en;
assign gen2mode_en_bs        = jtag_mode_in ? 1'b0   : gen2mode_en;
assign txrx_dfx_en_bs[101:0] = jtag_mode_in ? 102'h0 : txrx_dfx_en[101:0];
assign sdr_mode_en_bs[101:0] = jtag_mode_in ? {102{1'b1}} : sdr_mode_en[101:0];

assign rx_async_en_bs[101:0] = jtag_mode_in ?
                               {102{1'b1}} :
                              ( rx_async_en[101:0] &
                               ~fault_stdby[101:0] &
                                {102{(~i_scan_mode)}} );

assign tx_en_bs[101:0] = jtag_mode_in ?
                         {102{1'b0}} :
                         ( tx_en[101:0] &
                          ~fault_stdby[101:0] &
                          {102{(~i_scan_mode)}} );

assign rx_calen_int = jtag_mode_in ? 1'b0 : (rx_calen & ~i_scan_mode);

assign txrx_anaviewout[3:0] = { txrx_anaviewout_intr[25],
                                txrx_anaviewout_intr[73],
                                txrx_anaviewout_intr[28],
                                txrx_anaviewout_intr[76] };

//------------------------------------------------------------------------------
//                        END OF BOUNDARY SCAN LOGIC IMPLEMENTATION
//------------------------------------------------------------------------------


generate
 for (i=0; i<102; i=i+1)
  begin: aibio_txrx_cbb
  
  wire [7:0] o_txrx_spare_nc;
  wire [1:0] txrx_digviewout_pin;
  
  assign txrx_digviewout[2*i+1:2*i] = txrx_digviewout_pin[1:0];
  
   aibio_txrx_cbb i_pad(
        //------Supply pins------//
        .vddc(vddc2),
        .vddtx(vdd[i]),
        .vss(vss),
        //------input pins------//
        .ckrx_odd(ckrx_odd[i]),
        .ckrx_even(ckrx_even[i]),
        .rx_calen(rx_calen_int), 
        .rx_vref_cal(calvref), //output from vref 
        .rx_en(rxpad_en_i[i]), //Based on modes, we will enable the tx&rx enables
        .rx_vrefp_gen1(rx_vrefp_gen1),
        .rx_vrefn_gen1(rx_vrefn_gen1),
        .rx_vrefp_gen2(rx_vrefp_gen2),
        .rx_vrefn_gen2(rx_vrefn_gen2),
        .gen1mode_en(gen1mode_en_bs),
        .gen2mode_en(gen2mode_en_bs),
        .rx_ofscal_even({3'b000, rx_ofscal_even[i][4:0]}),
        .rx_ofscal_odd({3'b000, rx_ofscal_odd[i][4:0]}),
        .rx_deskew(rx_deskew_data_int[4*i+3:4*i]), 
        .txrx_dfx_en(txrx_dfx_en_bs[i]),
        .txrx_digviewsel(txrx_digviewsel[4:0]),
        .txrx_anaviewsel(txrx_anaviewsel[2:0]),
        .cktx_odd(cktx_odd[i]),
        .cktx_even(cktx_even[i]),
        .tx_en(tx_en_bs[i]),
        .tx_compen_p(1'b0), //Expected
        .tx_compen_n(1'b0), //Expected
        .tx_datain_odd(tx_datain_odd[i]), //From Adapter
        .tx_datain_even(tx_datain_even[i]), //From Adapter
        .tx_drv_npdsel(txdrv_npd_sel[7:0]),
        .tx_drv_npusel(txdrv_npu_sel[7:0]),
        .tx_drv_ppusel(txdrv_ppu_sel[7:0]), 
        .tx_deskew(tx_deskew_data_int[4*i+3:4*i]), 
        .rst_padlow_strap(1'b0),
        .pwrgood_in (1'b1),
        .pwrgood_io_in(1'b1), 
        .tx_async(tx_padasync_i[i]), //Asyn data Inputs
        .tx_async_en(tx_async_en_aib[i]),
        .rx_async_en(rx_async_en_bs[i]),
        .sdr_mode_en(sdr_mode_en_bs[i]),
        .wkpu_en(wkpu_en[i]),
        .wkpd_en(wkpd_en[i]),
        .tx_bypass_serialiser(tx_bypass_serialiser[i]),
        .txrx_anaview_in (1'b0), // FIX ME!!! 
        //------Output pins------//
        .rx_out_even(rx_even_out[i]),
        .rx_out_odd(rx_odd_out[i]),
        .rx_async(rx_padasync_o[i]),
        .txrx_anaviewout(txrx_anaviewout_intr[i]), //Independent to each
        .txrx_digviewout(txrx_digviewout_pin[1:0]), //Independent to Each
        //------InOut pins------//
        .xx_pad(iopad[i]),
        //------Spare pins------//
        .i_txrx_spare(8'h00), //[7:0]
        .o_txrx_spare(o_txrx_spare_nc[7:0]) //[7:0]
        );
  end
endgenerate

//==========De_skew Logic========//
aib_deskew_logic i_tx_deskew(
	.deskew_en(iotxrx_tx_deskew_en_ff),   
	.deskew_ovrd(iotxrx_tx_deskew_ovrd_ff), 
	.deskew_step(iotxrx_tx_deskew_step_ff), 
	.deskew_data(tx_deskew),
	.deskew_out(tx_deskew_data)
	);

aib_deskew_logic i_rx_deskew(
	.deskew_en(iotxrx_rx_deskew_en_ff),   
	.deskew_ovrd(iotxrx_rx_deskew_ovrd_ff), 
	.deskew_step(iotxrx_rx_deskew_step_ff), 
	.deskew_data(rx_deskew),
	.deskew_out(rx_deskew_data)
	);
assign txdrv_npu_code = gen1mode_en  ? {7{1'b0}}         : rcomp_cal_code_g2;
assign txdrv_ppu_code = gen1mode_en  ? rcomp_cal_code_g2 : rcomp_cal_code_g1;
aibio_txrx_cbb i_replica_g2(
        //------Supply pins------//
        .vddc(vddc2),
        .vddtx(vddtx), 
        .vss(vss),
        //------input pins------//
        .ckrx_odd(cktx_odd[0]), //BUmp0 clock (Gen1 Bump6)
        .ckrx_even(cktx_even[0]), //Bump0 clock
        .rx_calen(rx_calen), 
        .rx_vref_cal(calvref), //output from vref module
        .rx_en(rcomp_cal_en_g2), //Based on Rcomp en
        .rx_vrefp_gen1(rx_vrefp_gen1),
        .rx_vrefn_gen1(rx_vrefn_gen1),
        .rx_vrefp_gen2(rx_vrefp_gen2),
        .rx_vrefn_gen2(rx_vrefn_gen2),
        .gen1mode_en(gen1mode_en),
        .gen2mode_en(gen2mode_en),
        .rx_ofscal_even({3'b000,rx_ofscal_g2[4:0]}), 
        .rx_ofscal_odd(8'b0001_0000), 
        .rx_deskew(4'b0000),
       .txrx_dfx_en(txrx_dfx_en[102]),
       .txrx_digviewsel(txrx_digviewsel[4:0]),
       .txrx_anaviewsel(txrx_anaviewsel[2:0]),
       .cktx_odd(1'b0), 
       .cktx_even(1'b0), 
       .tx_en(1'b0), 
       .tx_compen_p(rcomp_cal_en_g2 && gen1mode_en), 
       .tx_compen_n(rcomp_cal_en_g2 && !gen1mode_en), 
       .tx_datain_odd(1'd0), 
       .tx_datain_even(1'd0), //From Adapter
       .tx_drv_npdsel(txdrv_npd_sel[7:0]),
       .tx_drv_npusel({1'b0, txdrv_npu_code[6:0]}),
       .tx_drv_ppusel({1'b0, txdrv_ppu_code[6:0]}),
       .tx_deskew(4'b0000), //[3:0]
       .rst_padlow_strap(1'b0),
       .pwrgood_in (1'b1),
       .pwrgood_io_in(1'b1), 
       .tx_async(1'b0), //Asyn data Inputs
       .tx_async_en(1'b0),
       .rx_async_en(1'b0),
       .sdr_mode_en(1'b0),
       .wkpu_en(1'b0),
       .wkpd_en(1'b0),
       .tx_bypass_serialiser(1'b0), 
       .txrx_anaview_in (1'b0), // FIX ME!!! 
        //------Output pins------//
        .rx_out_even(rcomp_out_g2),
        .rx_out_odd(rx_out_odd_g2_nc),
        .rx_async(rx_async_g2_nc),
        .txrx_anaviewout(txrx_anaviewout_g2_nc), //Independent to each
        .txrx_digviewout(txrx_digviewout_g2_nc[1:0]), //Independent to Each
        //------InOut pins------//
        .xx_pad(), //when rcomp_en is enabled then xx_pad will go from o to 1 after few clock cycles, or while running DV runs use rcomp override signalto enable the rcomp done 
        //------Spare pins------//
        .i_txrx_spare(8'h00), //[7:0]
        .o_txrx_spare(o_txrx_spare_g2_nc) //[7:0]
        );


aibio_txrx_cbb i_replica_g1(
        //------Supply pins------//
        .vddc(vddc2),
        .vddtx(vddc2), 
        .vss(vss),
        //------input pins------//
        .ckrx_odd(cktx_odd[6]), 
        .ckrx_even(cktx_even[6]), 
        .rx_calen(rx_calen), 
        .rx_vref_cal(calvref), 
        .rx_en(rcomp_cal_en_g1), 
        .rx_vrefp_gen1(rx_vrefp_gen1),
        .rx_vrefn_gen1(rx_vrefn_gen1),
        .rx_vrefp_gen2(rx_vrefp_gen2),
        .rx_vrefn_gen2(rx_vrefn_gen2),
        .gen1mode_en(gen1mode_en),
        .gen2mode_en(gen2mode_en),
        .rx_ofscal_even({3'b000,rx_ofscal_g1[4:0]}), 
        .rx_ofscal_odd(8'b0001_0000), 
        .rx_deskew(4'b0000),
       .txrx_dfx_en(txrx_dfx_en[103]),
       .txrx_digviewsel(txrx_digviewsel[4:0]),
       .txrx_anaviewsel(txrx_anaviewsel[2:0]),
       .cktx_odd(1'b0), 
       .cktx_even(1'b0), 
       .tx_en(1'b0), 
       .tx_compen_p(rcomp_cal_en_g1), 
       .tx_compen_n(1'b0), 
       .tx_datain_odd(1'b0), 
       .tx_datain_even(1'b0), 
       .tx_drv_npdsel(txdrv_npd_sel[7:0]),
       .tx_drv_npusel({1'b0, txdrv_npu_code[6:0]}),
       .tx_drv_ppusel({1'b0, txdrv_ppu_code[6:0]}),
       .tx_deskew(4'b0000), //[3:0]
       .rst_padlow_strap(1'b0),
       .pwrgood_in (1'b1),
       .pwrgood_io_in(1'b1), 
       .tx_async(1'b0), //Asyn data Inputs
       .tx_async_en(1'b0), 
       .rx_async_en(1'b1), //This is come from rcomp FSM
       .sdr_mode_en(1'b0),
       .wkpu_en(1'b0),
       .wkpd_en(1'b0),
       .tx_bypass_serialiser(1'b0),
       .txrx_anaview_in (1'b0), // FIX ME!!!  
        //------Output pins------//
        .rx_out_even(rcomp_out_g1_nc), 
        .rx_out_odd(rx_out_odd_g1_nc),
        .rx_async(rcomp_out_g1), 
        .txrx_anaviewout(txrx_anaviewout_g1_nc), //Independent to each
        .txrx_digviewout(txrx_digviewout_g1_nc), //Independent to Each
        //------InOut pins------//
        .xx_pad(),
        //------Spare pins------//
        .i_txrx_spare(8'h00), //[7:0]
        .o_txrx_spare(o_txrx_spare_g1_nc) //[7:0]
        );

//------------------------------------------------------------------------------
// Logic to keep TX DLL control signals stable during scan mode
//------------------------------------------------------------------------------

assign tx_dll_biasctrl_int[3:0]     = i_scan_mode ? 4'h0 : tx_dll_biasctrl[3:0];
assign tx_dll_capctrl_int[4:0]      = i_scan_mode ? 5'h3 : tx_dll_capctrl[4:0];
assign dll_cksoc_code_int[3:0]      = i_scan_mode ? 4'h0 : dll_cksoc_code[3:0];
assign dll_ckadapter_code_int[3:0]  = i_scan_mode ? 4'h0 : dll_ckadapter_code[3:0];
assign dll_even_phase1_sel_int[3:0] = i_scan_mode ? 4'h0 : dll_even_phase1_sel[3:0];
assign dll_odd_phase1_sel_int[3:0]  = i_scan_mode ? 4'h8 : dll_odd_phase1_sel[3:0];
assign dll_even_phase2_sel_int[3:0] = i_scan_mode ? 4'h6 : dll_even_phase2_sel[3:0];
assign dll_odd_phase2_sel_int[3:0]  = i_scan_mode ? 4'he : dll_odd_phase2_sel[3:0];
assign tx_dll_lockthresh_int[3:0]   = i_scan_mode ? 4'h0 : tx_dll_lockthresh[3:0];
assign tx_dll_lockctrl_int[1:0]     = i_scan_mode ? 2'h0 : tx_dll_lockctrl[1:0];
assign n_lpbk_int                   = i_scan_mode ? 1'h0 : n_lpbk;
assign tx_dll_dfx_en_int            = i_scan_mode ? 1'h0 : tx_dll_dfx_en;
assign tx_dll_digview_sel_int[4:0]  = i_scan_mode ? 5'h0 : tx_dll_digview_sel[4:0];
assign onehot_anaviewsel_int[4:0]   = i_scan_mode ? 5'h0 : onehot_anaviewsel[4:0];

//==============TxDLL==================
aibio_txdll_cbb i_txdll (
        .vddcq(vddc1),
        .vss(vss),
        //------Input pins------//
        .ck_in(ck_in), //Tclk, Main clock
        .ck_loopback(clkp_b_inv2[1]), //Rx clock, from RxDLL clock distribution(Inv2), rx0 data clock should connect
        .ck_sys(ck_sys), //This is required for ADC,DAC and PVT monitor to operate
        .ck_jtag(test_clk), 
        .inp_cksel(tx_inp_clksel), //2-bits
        .dll_en(tx_dll_en),
        .dll_reset(tx_dll_reset),
        .dll_biasctrl(tx_dll_biasctrl_int[3:0]), //Configaration bits
        .dll_capctrl(tx_dll_capctrl_int[4:0]), 
        .dll_cksoc_code(dll_cksoc_code_int[3:0]),  //4'b0000 and Reg
        .dll_ckadapter_code(dll_ckadapter_code_int[3:0]), 
        .dll_even_phase1_sel(dll_even_phase1_sel_int[3:0]), 
        .dll_odd_phase1_sel(dll_odd_phase1_sel_int[3:0]), 
        .dll_even_phase2_sel(dll_even_phase2_sel_int[3:0]), 
        .dll_odd_phase2_sel(dll_odd_phase2_sel_int[3:0]), 
        .dll_lockthresh(tx_dll_lockthresh_int[3:0]), 
        .dll_lockctrl(tx_dll_lockctrl_int[1:0]), 
        .loopback_en(n_lpbk_int), 
        .pwrgood_in(1'b1), 
        .dll_dfx_en(tx_dll_dfx_en_int), 
        .dll_digview_sel(tx_dll_digview_sel_int[4:0]), 
        .dll_anaview_sel(onehot_anaviewsel_int[4:0]), 
        //------Output pins------//
        .dll_lock(tx_dll_lock),
        .clk_odd(tx_clk_odd_nc), 
        .clk_even(tx_clk_even_nc), 
        .clk_soc(clk_soc), //Golden Clock
        .clk_adapter(clk_adapter), 
        .pulseclk_odd(tx_clk_odd), 
        .pulseclk_even(tx_clk_even), 
        .pulseclk_odd_loopback(pulseclk_odd_loopback), 
        .pulseclk_even_loopback(pulseclk_even_loopback), 
        .inbias(tx_inbias_nc), //Not used
        .ipbias(tx_ipbias), //CDR
        .dll_digviewout(tx_dll_digviewout[1:0]),
        .dll_anaviewout(tx_dll_anaviewout), 
        //------Spare pins------//
        .i_dll_spare(8'h00), 
        .o_dll_spare(o_dll_spare_tx_nc[7:0])
        );

//------------------------------------------------------------------------------
// Logic to keep RX DLL control signals stable during scan mode
//------------------------------------------------------------------------------

assign rx_dll_biasctrl_int[3:0]    = i_scan_mode ? 4'h0 : rx_dll_biasctrl[3:0];
assign rx_dll_capctrl_int[4:0]     = i_scan_mode ? 5'h0 : rx_dll_capctrl[4:0];
assign pi_biasctrl_int[3:0]        = i_scan_mode ? 4'h0 : pi_biasctrl[3:0];
assign pi_capctrl_int[4:0]         = i_scan_mode ? 5'h3 : pi_capctrl[4:0];
assign cdr_ctrl_int[3:0]           = i_scan_mode ? 4'h0 : cdr_ctrl[3:0];
assign dll_piodd_code_int[7:0]     = i_scan_mode ? 8'h0 : dll_piodd_code[7:0];
assign dll_pieven_code_int[7:0]    = i_scan_mode ? 8'h0 : dll_pieven_code[7:0];
assign picode_update_int           = i_scan_mode ? 1'h0 : picode_update;
assign dll_pisoc_code_int[3:0]     = i_scan_mode ? 4'h0 : dll_pisoc_code[3:0];
assign dll_piadapter_code_int[3:0] = i_scan_mode ? 4'h0 : dll_piadapter_code[3:0];
assign rx_dll_lockthresh_int[3:0]  = i_scan_mode ? 4'h0 : rx_dll_lockthresh[3:0];
assign rx_dll_lockctrl_int[1:0]    = i_scan_mode ? 2'h0 : rx_dll_lockctrl[1:0];
assign rx_dll_dfx_en_int           = i_scan_mode ? 1'h0 : rx_dll_dfx_en;
assign sdr_mode_int                = i_scan_mode ? 1'h0 : sdr_mode;
assign rx_dll_digview_sel_int[4:0] = i_scan_mode ? 5'h0 : rx_dll_digview_sel[4:0];
assign rx_dll_en_int               = i_scan_mode ? 1'h1 : rx_dll_en;

aibio_rxdll_cbb i_rxdll (
        .vddcq(vddc1),
        .vss(vss),
        .ck_inp(fs_fwd_clkp_out), 
        .ck_inn(fs_fwd_clkn_out),
        .ck_loopback(ck_in), 
        .ck_sys(ck_sys), 
        .ck_jtag(test_clk), 
        .ck_cdr_inp(fs_fwd_clkp_out_cdr), 
        .ck_cdr_inn(fs_fwd_clkn_out_cdr), 
        .inp_cksel(rx_inp_clksel),  
        .dll_en(rx_dll_en_int),
        .dll_reset(rx_dll_reset),
        .loopback_en(n_lpbk_int), //TBD, Enables the loopback clocks from RxDLL 
        .dll_biasctrl(rx_dll_biasctrl_int[3:0]), //Config registers
        .dll_capctrl(rx_dll_capctrl_int[4:0]), //Config registers
        .pi_biasctrl(pi_biasctrl_int[3:0]), //Config registers
        .pi_capctrl(pi_capctrl_int[4:0]), //Config registers
        .cdr_ctrl(cdr_ctrl_int[3:0]), //Config registers(Not used)
        .dll_piodd_code(dll_piodd_code_int[7:0]), //FSM | Register 
        .dll_pieven_code(dll_pieven_code_int[7:0]), //FSM 
        .picode_update(picode_update_int), //FSM 
        .dll_pisoc_code(dll_pisoc_code_int[3:0]), //FSM 
        .dll_piadapter_code(dll_piadapter_code_int[3:0]), //FSM 
        .dll_lockthresh(rx_dll_lockthresh_int[3:0]), //Config Reg 
        .dll_lockctrl(rx_dll_lockctrl_int[1:0]), //Config Reg
        .pwrgood_in(1'b1), //
        .dll_dfx_en(rx_dll_dfx_en_int), //Config Reg
        .sdr_mode(sdr_mode_int), //This is common for txrx cbb module, used for Gen1 Mode
        .dll_digviewsel(rx_dll_digview_sel_int[4:0]), //Config Reg
        .dll_anaviewsel(onehot_anaviewsel_int[4:0]), //Config Reg
        //------Output pins------//
        .phdet_cdr_out(phdet_cdr_out), 
        .dll_lock(rx_dll_lock), 
        .piclk_odd(piclk_odd), 
        .piclk_even(piclk_even), 
        .piclk_odd_loopback(piclk_odd_lpbk), 
        .piclk_even_loopback(piclk_even_lpbk), 
        .piclk_odd_fifo(piclk_odd_fifo_nc), //Not used
        .piclk_even_fifo(piclk_even_fifo_nc), //Not used
        .piclk_adapter(piclk_adapter), 
        .piclk_soc(piclk_soc), 
        .inbias(rx_inbias_nc), //Not used
        .ipbias(rx_ipbias_nc), //Not used
        .dll_digviewout(rx_dll_digviewout[1:0]), //View Mux 
        .dll_anaviewout(rx_dll_anaviewout), //View Mux 
        //------Spare pins------//
        .i_dll_spare(8'h00), 
        .o_dll_spare(o_dll_spare_rx_nc[7:0])
        );

aibio_vref_cbb i_aibio_vref_cbb (
//------Supply pins------//
.vddc(vddc2),
.vddtx(vddtx),
.vss(vss),
//------Input pins------//
.vref_en(vref_en), //Input
.calvref_en(calvref_en), //FSM 
.vref_bin_0(vref_bin_0), //From Registers
.vref_bin_1(vref_bin_1), //From Registers
.vref_bin_2(vref_bin_2), //From Registers
.vref_bin_3(vref_bin_3), //From Registers
.calvref_bin(calvref_bin[4:0]), //From Registers
.gen1mode_en(gen1mode_en), 
.pwrgood_in(1'b1), 
//------Output pins------//
.vref({rx_vrefn_gen2,rx_vrefp_gen2,rx_vrefn_gen1,rx_vrefp_gen1}), //Ins
.calvref(calvref),
//------Spare pins------//
.i_vref_spare(4'h0),
.o_vref_spare(o_vref_spare_nc) // Unused
);

assign redun_sel = (shift_en_clkbuf[0] & shift_en_clkbuf[1]);

assign rxclk_en_red   =  redun_sel & rxclk_en;
assign rxclk_en_nored = ~redun_sel & rxclk_en;

//Falling edge correspondse to Raising edge of even clock
assign fs_fwd_clkp_out = redun_sel ? fs_fwd_clkp_out_red : fs_fwd_clkp_out_nored;
assign fs_fwd_clkn_out = redun_sel ? fs_fwd_clkn_out_red : fs_fwd_clkn_out_nored;

aibio_rxclk_cbb i_fs_fwd_clk_nored(
//------Supply pins------//
 .vddcq(vddc1),
 .vss(vss),
//------Input pins------//
.dcc_p_pdsel(dcc_p_pdsel),
.dcc_p_pusel(dcc_p_pusel),
.dcc_n_pdsel(dcc_n_pdsel),
.dcc_n_pusel(dcc_n_pusel),
.rxclkp(iopad[70]), 
.rxclkn(iopad[71]), 
.rxclk_en(rxclk_en_nored),
.rxclk_localbias_en(1'b1),
.ipbias(tx_ipbias[0]),
.ibias_ctrl(ibias_ctrl_nored), //3-bit signal
.gen1mode_en(gen1mode_en),
//------Output pins------//
.rxclkp_out(fs_fwd_clkp_out_nored),
.rxclkn_out(fs_fwd_clkn_out_nored),
//------Spare pins------//
.i_rxclk_spare(4'h0),    
.o_rxclk_spare(o_rxclk_spare_nored_nc[3:0])     
);

aibio_rxclk_cbb i_fs_fwd_clk_red(
//------Supply pins------//
.vddcq(vddc1),
.vss(vss),
//------Input pins------//
.dcc_p_pdsel(dcc_p_pdsel), 
.dcc_p_pusel(dcc_p_pusel), 
.dcc_n_pdsel(dcc_n_pdsel), 
.dcc_n_pusel(dcc_n_pusel), 
.rxclkp(iopad[68]),
.rxclkn(iopad[69]),
.rxclk_en(rxclk_en_red),
.rxclk_localbias_en(1'b1),
.ipbias(tx_ipbias[1]),
.ibias_ctrl(ibias_ctrl_red), //3-bit signal
.gen1mode_en(gen1mode_en),
//------Output pins------//
.rxclkp_out(fs_fwd_clkp_out_red), 
.rxclkn_out(fs_fwd_clkn_out_red),
//------Spare pins------//
.i_rxclk_spare(4'h0),    
.o_rxclk_spare(o_rxclk_spare_red_nc[3:0])     
);

aibio_rxclk_cbb i_cdr(
//------Supply pins------//
.vddcq(vddc1),
.vss(vss),
//------Input pins------//
.dcc_p_pdsel(dcc_p_pdsel),  
.dcc_p_pusel(dcc_p_pusel),  
.dcc_n_pdsel(dcc_n_pdsel),  
.dcc_n_pusel(dcc_n_pusel),  
.rxclkp(clkp_b_inv2[1]), //From Distribution, From RX0, RX1
.rxclkn(clkn_b_inv2[1]),
.rxclk_en(rxclk_en),
.rxclk_localbias_en(1'b1), 
.ipbias(tx_ipbias[2]), //rx_ipbias TBD
.ibias_ctrl(ibias_ctrl_cdr), //3-bit signal
.gen1mode_en(gen1mode_en),
//------Output pins------//
.rxclkp_out(fs_fwd_clkp_out_cdr), 
.rxclkn_out(fs_fwd_clkn_out_cdr),
//------Spare pins------//
.i_rxclk_spare(4'h0),    
.o_rxclk_spare(o_rxclk_spare_cdr_nc[3:0])     
);

aibio_dqs_dcs_cbb i_dqs_dcs_cbb( 
//------Supply pins------//
.vddc(vddc2), 
.vssx(vss), 
//------Input pins------//
.clk(ck_sys), 
.clkdiv(clkdiv),  //[1:0] COnfig 
.clkn(fs_fwd_clkn_out), 
.clkp(fs_fwd_clkp_out), 
.dcs_en(rxclk_en), 
.reset(reset), //TBD with Aswin //FIX ME!!!
.sel_clkp(sel_clkp), //Config Register
.sel_clkn(sel_clkn), //Config Register 
.en_single_ended(en_single_ended), //Config Register
.chopen(chopen), //From FSM, Calibration FSM for DCS
.dcs_dfx_en(dcs_dfx_en), //Config Register
.dcs_anaviewsel(onehot_anaviewsel[2:0]),  //[2:0] //Config Register
//------Output pins------//
.dc_gt_50(dc_gt_50), //Will go to FSM
.dc_gt_50_preflop(dc_gt_50_preflop_nc), //Unused
.ckph1(ckph1_nc), //Unused
.dcs_anaviewout(dcs_anaviewout), //Analog modules
//------Spare pins------//
.dcs_spare(4'h0),   //[3:0]
.o_dcs_spare(o_dcs_spare_nc[3:0])    //[3:0]
);


//Clock Distribution to txrx_cbb module, LUT
function [6:0]clock_map1;
  input [6:0]index;
    case(index[6:0])
      7'd0:    clock_map1 = 100;
      7'd1:    clock_map1 = 101;
      7'd2:    clock_map1 = 98;
      7'd3:    clock_map1 = 90;
      7'd4:    clock_map1 = 91;
      7'd5:    clock_map1 = 92;
      7'd6:    clock_map1 = 88;
      7'd7:    clock_map1 = 89;
      7'd8:    clock_map1 = 86;
      7'd9:    clock_map1 = 78;
      7'd10:   clock_map1 = 79;
      7'd11:   clock_map1 = 80;
      7'd12:   clock_map1 = 76;
      7'd13:   clock_map1 = 77;
      7'd14:   clock_map1 = 74;
      7'd15:   clock_map1 = 66;
      7'd16:   clock_map1 = 67;
      7'd17:   clock_map1 = 68;
      7'd18:   clock_map1 = 64;
      7'd19:   clock_map1 = 65;
      7'd20:   clock_map1 = 62;
      7'd21:   clock_map1 = 54;
      7'd22:   clock_map1 = 55;
      7'd23:   clock_map1 = 56;
      default: clock_map1 = 56;
    endcase
endfunction

function [6:0]clock_map2;
  input [6:0]index;
    case(index[6:0])
      7'd0:    clock_map2 = 99;
      7'd1:    clock_map2 = 96;
      7'd2:    clock_map2 = 97;
      7'd3:    clock_map2 = 93;
      7'd4:    clock_map2 = 94;
      7'd5:    clock_map2 = 95;
      7'd6:    clock_map2 = 87;
      7'd7:    clock_map2 = 84;
      7'd8:    clock_map2 = 85;
      7'd9:    clock_map2 = 81;
      7'd10:   clock_map2 = 82;
      7'd11:   clock_map2 = 83;
      7'd12:   clock_map2 = 75;
      7'd13:   clock_map2 = 72;
      7'd14:   clock_map2 = 73;
      7'd15:   clock_map2 = 69;
      7'd16:   clock_map2 = 70;
      7'd17:   clock_map2 = 71;
      7'd18:   clock_map2 = 63;
      7'd19:   clock_map2 = 60;
      7'd20:   clock_map2 = 61;
      7'd21:   clock_map2 = 58;
      7'd22:   clock_map2 = 59;
      7'd23:   clock_map2 = 57;
      default: clock_map2 = 57; 
    endcase
endfunction

function [6:0]clock_map3;
  input [6:0]index;
    case(index[6:0])
      7'd0:    clock_map3 = 42;
      7'd1:    clock_map3 = 43;
      7'd2:    clock_map3 = 44;
      7'd3:    clock_map3 = 40;
      7'd4:    clock_map3 = 41;
      7'd5:    clock_map3 = 38;
      7'd6:    clock_map3 = 30;
      7'd7:    clock_map3 = 31;
      7'd8:    clock_map3 = 32;
      7'd9:    clock_map3 = 28;
      7'd10:   clock_map3 = 29;
      7'd11:   clock_map3 = 26;
      7'd12:   clock_map3 = 18;
      7'd13:   clock_map3 = 19;
      7'd14:   clock_map3 = 20;
      7'd15:   clock_map3 = 16;
      7'd16:   clock_map3 = 17;
      7'd17:   clock_map3 = 14;
      7'd18:   clock_map3 = 6;
      7'd19:   clock_map3 = 7;
      7'd20:   clock_map3 = 8;
      7'd21:   clock_map3 = 4;
      7'd22:   clock_map3 = 5;
      7'd23:   clock_map3 = 2;
      default: clock_map3 = 2;
    endcase
endfunction

function [6:0]clock_map4;
  input [6:0]index;
    case(index[6:0])
      7'd0:    clock_map4 = 45;
      7'd1:    clock_map4 = 46;
      7'd2:    clock_map4 = 47;
      7'd3:    clock_map4 = 39;
      7'd4:    clock_map4 = 36;
      7'd5:    clock_map4 = 37;
      7'd6:    clock_map4 = 33;
      7'd7:    clock_map4 = 34;
      7'd8:    clock_map4 = 35;
      7'd9:    clock_map4 = 27;
      7'd10:   clock_map4 = 24;
      7'd11:   clock_map4 = 25;
      7'd12:   clock_map4 = 21;
      7'd13:   clock_map4 = 22;
      7'd14:   clock_map4 = 23;
      7'd15:   clock_map4 = 15;
      7'd16:   clock_map4 = 12;
      7'd17:   clock_map4 = 13;
      7'd18:   clock_map4 = 9;
      7'd19:   clock_map4 = 10;
      7'd20:   clock_map4 = 11;
      7'd21:   clock_map4 = 3;
      7'd22:   clock_map4 = 0;
      7'd23:   clock_map4 = 1;
      default: clock_map4 = 1;
    endcase
endfunction

generate
  for(i=0; i<24; i=i+1)
    begin: cktx_map1
      assign cktx_even[clock_map1(i)] = clkp_b_inv2_lpbk[0];
      assign cktx_odd[clock_map1(i)]  = clkn_b_inv2_lpbk[0];
      assign ckrx_even[clock_map1(i)] = clkp_b_inv2[0];
      assign ckrx_odd[clock_map1(i)]  = clkn_b_inv2[0];
    end // block: cktx_map1
endgenerate

generate
  for(i=0; i<24; i=i+1) 
    begin: cktx_map2
      assign cktx_even[clock_map2(i)] = clkp_b_inv2_lpbk[1];
      assign cktx_odd[clock_map2(i)]  = clkn_b_inv2_lpbk[1];
      assign ckrx_even[clock_map2(i)] = clkp_b_inv2[1];
      assign ckrx_odd[clock_map2(i)]  = clkn_b_inv2[1];
    end // blockcktx_map2
endgenerate

generate
  for(i=0; i<24; i=i+1)
    begin: cktx_map3
      assign cktx_even[clock_map3(i)] = clkp_b_inv2[2];
      assign cktx_odd[clock_map3(i)]  = clkn_b_inv2[2];
      assign ckrx_even[clock_map3(i)] = clkp_b_inv2_lpbk[2];
      assign ckrx_odd[clock_map3(i)]  = clkn_b_inv2_lpbk[2];
    end // block: cktx_map3
endgenerate

generate
  for(i=0; i<24; i=i+1)
    begin: cktx_map4
      assign cktx_even[clock_map4(i)] = clkp_b_inv2[3];
      assign cktx_odd[clock_map4(i)]  = clkn_b_inv2[3];
      assign ckrx_even[clock_map4(i)] = clkp_b_inv2_lpbk[3];
      assign ckrx_odd[clock_map4(i)]  = clkn_b_inv2_lpbk[3];
    end // block: cktx_map4
endgenerate

assign cktx_even[53:48] = 6'h0;
assign cktx_odd[53:48]  = 6'h0;
assign ckrx_even[53:48] = 6'h0;
assign ckrx_odd[53:48]  = 6'h0;

//TxDLL
assign clkp_inv1[2] = tx_clk_even;
assign clkp_inv1[3] = tx_clk_even;
assign clkn_inv1[2] = tx_clk_odd;
assign clkn_inv1[3] = tx_clk_odd;
//RxDLL
assign clkp_inv1[0] = piclk_even; //Falling edge of clock fs_fwd_clk, sends even data
assign clkp_inv1[1] = piclk_even;
assign clkn_inv1[0] = piclk_odd; 
assign clkn_inv1[1] = piclk_odd; 

//TxDLL Loopback clocks
assign clkp_inv1_lpbk[0] = pulseclk_even_loopback; //TBD
assign clkp_inv1_lpbk[1] = pulseclk_even_loopback; 
assign clkn_inv1_lpbk[0] = pulseclk_odd_loopback; 
assign clkn_inv1_lpbk[1] = pulseclk_odd_loopback; 
//RxDLL Loopback clocks
assign clkp_inv1_lpbk[2] = piclk_even_lpbk;
assign clkp_inv1_lpbk[3] = piclk_even_lpbk;
assign clkn_inv1_lpbk[2] = piclk_odd_lpbk;
assign clkn_inv1_lpbk[3] = piclk_odd_lpbk;

//Even Clocks
assign clkp_inv2[0] = clkp_b_inv1[0];
assign clkp_inv2[1] = clkp_b_inv1[1];
assign clkp_inv2[2] = clkp_b_inv1[2];
assign clkp_inv2[3] = clkp_b_inv1[3];
// Odd clocks
assign clkn_inv2[0] = clkn_b_inv1[0];
assign clkn_inv2[1] = clkn_b_inv1[1];
assign clkn_inv2[2] = clkn_b_inv1[2];
assign clkn_inv2[3] = clkn_b_inv1[3];
//Loop Back clocks
assign clkp_inv2_lpbk[0] = clkp_b_inv1_lpbk[0];
assign clkp_inv2_lpbk[1] = clkp_b_inv1_lpbk[1];
assign clkp_inv2_lpbk[2] = clkp_b_inv1_lpbk[2];
assign clkp_inv2_lpbk[3] = clkp_b_inv1_lpbk[3];
//Loop Back clocks
assign clkn_inv2_lpbk[0] = clkn_b_inv1_lpbk[0];
assign clkn_inv2_lpbk[1] = clkn_b_inv1_lpbk[1];
assign clkn_inv2_lpbk[2] = clkn_b_inv1_lpbk[2];
assign clkn_inv2_lpbk[3] = clkn_b_inv1_lpbk[3];

//Loopback clocks
generate
  for (i=0; i<4; i=i+1)
    begin: aibio_clkdist_inv1
      aibio_clkdist_inv1_cbb i_clkdist_inv1(
      //------Supply pins------//
      .vddcq(vddc1),
      .vss(vss),
      //------Input pins------//
      .clkp(clkp_inv1[i]),
      .clkn(clkn_inv1[i]),
      //------Output pins------//
      .clkp_b(clkp_b_inv1[i]),
      .clkn_b(clkn_b_inv1[i])
       );
    end // block: aibio_clkdist_inv1

   for (i=0; i<4; i=i+1)
     begin: aibio_clkdist_inv1_lpb
       aibio_clkdist_inv1_cbb i_clkdist_inv1_lpb(
       //------Supply pins------//
       .vddcq(vddc1),
       .vss(vss),
       //------Input pins------//
       .clkp(clkp_inv1_lpbk[i]),
       .clkn(clkn_inv1_lpbk[i]),
       //------Output pins------//
       .clkp_b(clkp_b_inv1_lpbk[i]),
       .clkn_b(clkn_b_inv1_lpbk[i])
       );
     end // block: aibio_clkdist_inv2
endgenerate

generate
  for (i=0; i<4; i=i+1)
   begin: aibio_clkdist_inv2
    aibio_clkdist_inv2_cbb i_clkdist_inv2(
        //------Supply pins------//
        .vddcq(vddc1),
        .vss(vss),
        //------Input pins------//
        .clkp(clkp_inv2[i]),
        .clkn(clkn_inv2[i]),
        //------Output pins------//
        .clkp_b(clkp_b_inv2[i]),
        .clkn_b(clkn_b_inv2[i])
);
   end // block: aibio_clkdist_inv2
endgenerate

generate
  for (i=0; i<4; i=i+1)
   begin: aibio_clkdist_inv2_lpb
    aibio_clkdist_inv2_cbb i_clkdist_inv2_lpb(
        //------Supply pins------//
        .vddcq(vddc1),
        .vss(vss),
        //------Input pins------//
        .clkp(clkp_inv2_lpbk[i]),
        .clkn(clkn_inv2_lpbk[i]),
        //------Output pins------//
        .clkp_b(clkp_b_inv2_lpbk[i]),
        .clkn_b(clkn_b_inv2_lpbk[i])
);
   end // block: aibio_clkdist_inv2_lpb
endgenerate

endmodule

