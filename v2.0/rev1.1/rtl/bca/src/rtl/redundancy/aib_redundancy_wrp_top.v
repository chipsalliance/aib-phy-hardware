// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2022 HCL Technologies Ltd.
// Copyright (C) 2022 Blue Cheetah Analog Design, Inc.

module aib_redundancy_wrp_top
        #(parameter DATAWIDTH = 40) (
        input [101:0] shift_en,
        input [DATAWIDTH-1:0] tx_data_in_even,
        input [DATAWIDTH-1:0] tx_data_in_odd,
        input [101:0] data_even_from_pad,
        input [101:0] data_odd_from_pad,
        input tx_lpbk_mode, //Configure through AVMM registers 
        input rx_lpbk_mode, //Configure through AVMM registers 
        input sdr_mode_en, //Configure through AVMM registers 
        input gen1mode_en, //Configure through AVMM registers 
        input csr_paden, // PAD enable register
        input io_ctrl1_tx_wkpu_ff, // Weak pull-up for TX IOs
        input io_ctrl1_tx_wkpd_ff, // Weak pull-down for TX IOs
        input io_ctrl1_rx_wkpu_ff, // Weak pull-up for RX IOs
        input io_ctrl1_rx_wkpd_ff, // Weak pull-down for RX IOs
        input iopad_rstb, 
        input fwd_clk_test_sync, 
        //Async Signals 
        input ns_adapter_rstn,
        input ns_mac_rdy     ,
        input ns_sr_load     ,
        input ns_sr_data     ,
        input ns_sr_clk      ,
        input ns_rcv_clk     ,
        input       [101:0] pad_to_adapter_async_in,
        output wire [101:0] async_data_to_pad,
        output fs_rcv_clk_out,
        output fs_sr_clk_out      ,
        output fs_sr_data_out     ,
        output fs_sr_load_out     ,
        output fs_mac_rdy_out     ,
        output fs_adapter_rstn_out,

        //To Analog block
        output wire [101:0] even_data_to_pad,
        output wire [101:0] odd_data_to_pad,
        output wire [101:0] rx_en_to_pad,
        output wire [101:0] tx_en_to_pad,
        output wire [101:0] tx_async_en_to_pad,
        output wire [101:0] rx_async_en_to_pad,
        output wire [101:0] sdr_mode_en_to_pad,
        output wire [101:0] wkpu_en_out,
        output wire [101:0] wkpd_en_out,
        output      [101:0] fault_stdby,
        //To Adapter
        output wire [DATAWIDTH-1:0] rx_data_out_even,
        output wire [DATAWIDTH-1:0] rx_data_out_odd

);

wire [101:0] adapter_to_pad_data_even;
wire [101:0] adapter_to_pad_data_odd;

wire [101:0] adapter_to_pad_async;
wire [101:0] async_data_to_adapter;

wire [101:0] pad_to_adapter_dout_even;
wire [101:0] pad_to_adapter_dout_odd;

wire [39:0] rx_even_data;
wire [39:0] rx_odd_data;
wire [39:0] rx_even_data_lpbk;
wire [39:0] rx_odd_data_lpbk;
wire [39:0] tx_even_data_lpbk;
wire [39:0] tx_odd_data_lpbk;
//Enable signals
wire [101:0] rx_en;
wire [101:0] tx_en;
wire [101:0] async_tx_en;
wire [101:0] async_rx_en;
wire [101:0] sdr_mode;
wire [101:0] wkpu_en_in;
wire [101:0] wkpd_en_in;

wire [101:0] tx_en_out;
wire [101:0] rx_en_out;
wire [101:0] async_tx_en_out;
wire [101:0] async_rx_en_out;

wire [101:0] tx_en_out_nc;
wire [101:0] rx_en_out_nc;
wire [101:0] async_tx_en_out_nc;
wire [101:0] async_rx_en_out_nc;
wire [101:0] sdr_mode_en_out_nc;
wire [101:0] wkpu_en_out_nc;
wire [101:0] wkpd_en_out_nc;
wire [101:0] pad_en;

wire bert_clk_test;

// SDR_MODE needs to through redundancy
assign sdr_mode[29:0]    = sdr_mode_en ? {30{1'b1}} : {30{1'b0}};
assign sdr_mode[31:30]   = {2{1'b0}};  
assign sdr_mode[41:32]   = sdr_mode_en ? {10{1'b1}} : {10{1'b0}};
assign sdr_mode[49:42]   = sdr_mode_en ? {8{1'b1}}  : {8{1'b0}};
assign sdr_mode[51:50]   = sdr_mode_en ? {2{1'b1}}  : {2{1'b0}};
assign sdr_mode[59:52]   = sdr_mode_en ? {8{1'b1}}  : {8{1'b0}};
assign sdr_mode[69:60]   = sdr_mode_en ? {10{1'b1}} : {10{1'b0}};
assign sdr_mode[71:70]   = {2{1'b0}};  
assign sdr_mode[101:72]  = sdr_mode_en ? {30{1'b1}} : {30{1'b0}};

//==================================================
//Data Muxing between loop back data and actual data
//==================================================
assign tx_even_data_lpbk = rx_lpbk_mode ? tx_data_in_even   : 40'd0;
assign tx_odd_data_lpbk  = rx_lpbk_mode ? tx_data_in_odd    : 40'd0;

assign rx_data_out_even[DATAWIDTH-1:4]  = tx_lpbk_mode                     ?
                                          rx_even_data_lpbk[DATAWIDTH-1:4] :
                                          rx_even_data[DATAWIDTH-1:4];

assign rx_data_out_odd[DATAWIDTH-1:4]   = tx_lpbk_mode                     ?
                                          rx_odd_data_lpbk[DATAWIDTH-1:4]  :
                                          rx_odd_data[DATAWIDTH-1:4] ; 

assign rx_data_out_even[0] =
                bert_clk_test ? pad_to_adapter_dout_even[30] :
               (tx_lpbk_mode ? rx_even_data_lpbk[0] : rx_even_data[0]);

assign rx_data_out_even[1] =
                bert_clk_test ? pad_to_adapter_dout_even[31] :
               (tx_lpbk_mode ? rx_even_data_lpbk[1] : rx_even_data[1]);

assign rx_data_out_even[2] =
                bert_clk_test ? pad_to_adapter_dout_even[71] :
               (tx_lpbk_mode ? rx_even_data_lpbk[2] : rx_even_data[2]);

assign rx_data_out_even[3] =
                bert_clk_test ? pad_to_adapter_dout_even[70] :
               (tx_lpbk_mode ? rx_even_data_lpbk[3] : rx_even_data[3]);

assign rx_data_out_odd[0] =
                bert_clk_test ? pad_to_adapter_dout_odd[30] :
               (tx_lpbk_mode ? rx_odd_data_lpbk[0] : rx_odd_data[0]);

assign rx_data_out_odd[1] =
                bert_clk_test ? pad_to_adapter_dout_odd[31] :
               (tx_lpbk_mode ? rx_odd_data_lpbk[1] : rx_odd_data[1]);

assign rx_data_out_odd[2] =
                bert_clk_test ? pad_to_adapter_dout_odd[71] :
               (tx_lpbk_mode ? rx_odd_data_lpbk[2] : rx_odd_data[2]);

assign rx_data_out_odd[3] =
                bert_clk_test ? pad_to_adapter_dout_odd[70] :
               (tx_lpbk_mode ? rx_odd_data_lpbk[3] : rx_odd_data[3]);

//------------------------------------------------------------------------------
// Logic to put pads with fault/unused in standby mode according to redundancy
//------------------------------------------------------------------------------

assign fault_stdby[0] = shift_en[0];
assign fault_stdby[1] = shift_en[0] | (shift_en[1] & ~shift_en[0]);

genvar i;
generate
  for(i=2;i<50;i=i+1)
    begin: tx_fault_stdby_en_gen
      assign fault_stdby[i] = (shift_en[i] & ~shift_en[i-1]) |
                              (shift_en[i-1] & ~shift_en[i-2]);
    end // block: tx_fault_stdby_en_gen
endgenerate

assign fault_stdby[50] = 1'b0;
assign fault_stdby[51] = 1'b0;

generate
  for(i=99;i>51;i=i-1)
    begin: rx_fault_stdby_en_gen
      assign fault_stdby[i] = (shift_en[i] & ~shift_en[i+1]) |
                              (shift_en[i+1] & ~shift_en[i+2]);
    end // block: rx_fault_stdby_en_gen
endgenerate

assign fault_stdby[100] = shift_en[101] | (shift_en[100] & ~shift_en[101]);
assign fault_stdby[101] = shift_en[101];

assign pad_en[101:0] = {102{csr_paden}};

//------------------------------------------------------------------------------

//assign tx_en[29:0]   = {30{1'b1}}; Enable signal Should control w.r.to
//conf_done signal
assign tx_en[19:0]   = iopad_rstb ? (gen1mode_en ? {20{1'b0}} : pad_en[19:0]) : {20{1'b0}}; 
assign tx_en[29:20]  = iopad_rstb ?  pad_en[29:20] : {10{1'b0}}; // for  Tx IOs AVMM and Gen1 & Gen2
assign tx_en[31:30]  = iopad_rstb ?  pad_en[31:30] : {2{1'b0}};  // Near side forwarded clock
assign tx_en[41:32]  = iopad_rstb ?  pad_en[41:32] : {10{1'b0}}; // for TX IOs
assign tx_en[49:42]  = {8{1'b0}};
assign tx_en[51:50]  = {2{1'b0}};  
assign tx_en[59:52]  = {8{1'b0}};
assign tx_en[69:60]  = iopad_rstb ? (rx_lpbk_mode ? pad_en[69:60] : {10{1'b0}}) : {10{1'b0}}; 
assign tx_en[71:70]  = iopad_rstb ? {2{bert_clk_test | rx_lpbk_mode | tx_lpbk_mode}} : {2{1'b0}};  
assign tx_en[81:72]  = iopad_rstb ? (rx_lpbk_mode ? pad_en[81:72] : {10{1'b0}}) : {10{1'b0}}; // for  Rx IOs
assign tx_en[101:82] = iopad_rstb ? (gen1mode_en  ? {20{1'b0}} : (rx_lpbk_mode ? pad_en[101:82] :
                                   {20{1'b0}})) : {20{1'b0}}; // for  Rx IOs

assign async_tx_en[29:0]   = {30{1'b0}}; // for  Tx IOs
assign async_tx_en[31:30]  = {2{1'b0}};  
assign async_tx_en[41:32]  = {10{1'b0}}; // for TX IOs

assign async_tx_en[42]     = (iopad_rstb & gen1mode_en) ? pad_en[42] : 1'b0; // ns_rcv_clk
assign async_tx_en[43]     = (iopad_rstb & gen1mode_en) ? pad_en[43] : 1'b0; // ns_rcv_clk_b
assign async_tx_en[44]     =  iopad_rstb ? pad_en[44] : 1'b0;
assign async_tx_en[45]     = (iopad_rstb & gen1mode_en) ? pad_en[45] : 1'b0; // ns_sr_clk_b
assign async_tx_en[49:46]  =  iopad_rstb ? pad_en[49:46]  : {4{1'b0}};

assign async_tx_en[51:50]  = {2{1'b0}};  // spares
assign async_tx_en[59:52]  = {8{1'b0}}; 
assign async_tx_en[69:60]  = {10{1'b0}}; // for RX IOs
assign async_tx_en[71:70]  = {2{1'b0}};  
assign async_tx_en[101:72] = {30{1'b0}}; // for  Rx IOs

assign async_rx_en[29:0]   = {30{1'b0}}; // for  Tx IOs
assign async_rx_en[31:30]  = {2{1'b0}}; 
assign async_rx_en[41:32]  = {10{1'b0}}; // for TX IOs
assign async_rx_en[49:42]  = {8{1'b0}};
assign async_rx_en[51:50]  = {2{1'b0}};  // spares

//------------------------------------------------------------------------------
// Rx async enable for signals not used on nearside loopback
//------------------------------------------------------------------------------
assign async_rx_en[55:52]  =  
                    iopad_rstb                                              ?
                  ( pad_en[55:52] & {4{(~(rx_lpbk_mode | tx_lpbk_mode))}} ) :
                    {4{1'b0}};

assign async_rx_en[56] = ( iopad_rstb & gen1mode_en )                      ?
                         ( pad_en[56] & (~(rx_lpbk_mode | tx_lpbk_mode)) ) :
                           1'b0; // fs_sr_clk_b

assign async_rx_en[57] =   iopad_rstb                                      ?
                         ( pad_en[57] & (~(rx_lpbk_mode | tx_lpbk_mode)) ) :
                           1'b0;

assign async_rx_en[58] = ( iopad_rstb & gen1mode_en )                      ?
                         ( pad_en[58] & (~(rx_lpbk_mode | tx_lpbk_mode)) ) :
                           1'b0; // fs_rcv_clk_b

assign async_rx_en[59] = ( iopad_rstb & gen1mode_en )                      ?
                         ( pad_en[59] & (~(rx_lpbk_mode | tx_lpbk_mode)) ) :
                           1'b0; // fs_rcv_clk

//------------------------------------------------------------------------------

assign async_rx_en[69:60]  = {10{1'b0}}; // for RX IOs
assign async_rx_en[71:70]  = {2{1'b0}};
assign async_rx_en[101:72] = {30{1'b0}}; // for  Rx IOs
 
assign rx_en[19:0]   = iopad_rstb ? (gen1mode_en  ? {20{1'b0}} : tx_lpbk_mode ? pad_en[19:0] : 
                                  {20{1'b0}}) : {20{1'b0}}; 
assign rx_en[29:20]  = iopad_rstb ? (tx_lpbk_mode ? pad_en[29:20] : {10{1'b0}}) : {10{1'b0}}; 
assign rx_en[31:30]  = iopad_rstb ? {2{bert_clk_test | tx_lpbk_mode}} : {2{1'b0}};  // Near side forwarded clock
assign rx_en[41:32]  = iopad_rstb ? (tx_lpbk_mode ? pad_en[41:32] : {10{1'b0}}) : {10{1'b0}}; // for TX IOs
assign rx_en[49:42]  = {8{1'b0}};
assign rx_en[51:50]  = {2{1'b0}};  // spares

//------------------------------------------------------------------------------
// Rx async enable for signals not used on nearside loopback
//------------------------------------------------------------------------------
assign rx_en[55:52]  =
          iopad_rstb                                               ?
        ( pad_en[55:52] & {4{(~(rx_lpbk_mode | tx_lpbk_mode))}} )  :
         {4{1'b0}};

assign rx_en[56] = ( iopad_rstb & gen1mode_en )                      ?
                   ( pad_en[56] & (~(rx_lpbk_mode | tx_lpbk_mode)) ) :
                     1'b0; // fs_sr_clk_b

assign rx_en[57] =   iopad_rstb                                      ?
                   ( pad_en[57] & (~(rx_lpbk_mode | tx_lpbk_mode)) ) :
                     1'b0;

assign rx_en[58] = ( iopad_rstb & gen1mode_en )                      ?
                   ( pad_en[58] & (~(rx_lpbk_mode | tx_lpbk_mode)) ) :
                     1'b0; // fs_rcv_clk_b

assign rx_en[59] = ( iopad_rstb & gen1mode_en )                      ?
                   ( pad_en[59] & (~(rx_lpbk_mode | tx_lpbk_mode)) ) :
                     1'b0; // fs_rcv_clk

//------------------------------------------------------------------------------

assign rx_en[69:60]  = iopad_rstb ? pad_en[69:60] : {10{1'b0}}; // for RX IOs
assign rx_en[71:70]  = iopad_rstb ? {2{bert_clk_test}} : {2{1'b0}};  // Far side forwarded clock
assign rx_en[81:72]  = iopad_rstb ? pad_en[81:72] : {10{1'b0}}; // for  Rx IOs
assign rx_en[101:82] = iopad_rstb ? (gen1mode_en ? {20{1'b0}} : pad_en[101:82]) : {20{1'b0}}; // for  Rx IOs

assign wkpu_en_in[101:52] = {50{io_ctrl1_rx_wkpu_ff}};
assign wkpu_en_in[51:50]  = {2{1'b0}};
assign wkpu_en_in[49:0]   = {50{io_ctrl1_tx_wkpu_ff}};

assign wkpd_en_in[101:60] = {42{io_ctrl1_rx_wkpd_ff | (~iopad_rstb)}};
assign wkpd_en_in[51:50]  = 2'b11;
assign wkpd_en_in[41:0]   = {42{io_ctrl1_tx_wkpd_ff | (~iopad_rstb)}};

assign wkpd_en_in[42]     =  io_ctrl1_tx_wkpd_ff | (~gen1mode_en) | (~iopad_rstb); // ns_rcv_clk
assign wkpd_en_in[43]     =  io_ctrl1_tx_wkpd_ff | (~gen1mode_en) | (~iopad_rstb); // ns_rcv_clk_b
assign wkpd_en_in[44]     =  io_ctrl1_tx_wkpd_ff | (~iopad_rstb);
assign wkpd_en_in[45]     =  io_ctrl1_tx_wkpd_ff | (~gen1mode_en) | (~iopad_rstb);// ns_sr_clk_b
assign wkpd_en_in[49:46]  =  {4{io_ctrl1_tx_wkpd_ff | (~iopad_rstb)}};

assign wkpd_en_in[55:52]  = {4{io_ctrl1_rx_wkpd_ff | (~iopad_rstb)}}; 
assign wkpd_en_in[56]     =  io_ctrl1_tx_wkpd_ff | (~gen1mode_en) | (~iopad_rstb); // fs_sr_clk_b
assign wkpd_en_in[57]     =  io_ctrl1_rx_wkpd_ff | (~iopad_rstb);
assign wkpd_en_in[58]     =  io_ctrl1_tx_wkpd_ff | (~gen1mode_en) | (~iopad_rstb); // fs_rcv_clk_b
assign wkpd_en_in[59]     =  io_ctrl1_tx_wkpd_ff | (~gen1mode_en) | (~iopad_rstb); // fs_rcv_clk

assign tx_en_to_pad       = tx_en_out;
assign tx_async_en_to_pad = async_tx_en_out;
assign rx_en_to_pad       = rx_en_out;
assign rx_async_en_to_pad = async_rx_en_out;

//=========================================
//Input Tx Even and Odd Data(From Adapter)
//=========================================

// PAD 0-29 - TX data
generate
  for(i=0; i<15; i=i+1)
   begin: adapter_to_pad_0_29
    assign adapter_to_pad_data_even[2*i]     = tx_data_in_even[38-(2*i)];
    assign adapter_to_pad_data_even[(2*i)+1] = tx_data_in_even[39-(2*i)];
    assign adapter_to_pad_data_odd[2*i]      = tx_data_in_odd[38-(2*i)];
    assign adapter_to_pad_data_odd[(2*i)+1]  = tx_data_in_odd[39-(2*i)];
   end
endgenerate

// PAD 32-41 - TX data
generate
  for(i=0; i<5; i=i+1)
   begin: adapter_to_pad_32_41
    assign adapter_to_pad_data_even[32+(2*i)]   = tx_data_in_even[8-(2*i)];
    assign adapter_to_pad_data_even[32+(2*i)+1] = tx_data_in_even[9-(2*i)];
    assign adapter_to_pad_data_odd[32+(2*i)]    = tx_data_in_odd[8-(2*i)];
    assign adapter_to_pad_data_odd[32+(2*i)+1]  = tx_data_in_odd[9-(2*i)];
   end
endgenerate

//==============================================
// Loopback data at Transmitter IO Pads
//=============================================

// PAD 60-69 - RX data loop back
generate
  for(i=0; i<5; i=i+1)
   begin: adapter_to_pad_60_69
    assign adapter_to_pad_data_even[60+(2*i)]   = tx_even_data_lpbk[1+(2*i)];
    assign adapter_to_pad_data_even[60+(2*i)+1] = tx_even_data_lpbk[2*i];
    assign adapter_to_pad_data_odd[60+(2*i)]    = tx_odd_data_lpbk[1+(2*i)];
    assign adapter_to_pad_data_odd[60+(2*i)+1]  = tx_odd_data_lpbk[2*i];
   end
endgenerate

// PAD 72-101 - RX data loopback
generate
  for(i=0; i<15; i=i+1)
   begin: adapter_to_pad_72_101
    assign adapter_to_pad_data_even[72+(2*i)]   = tx_even_data_lpbk[11+(2*i)];
    assign adapter_to_pad_data_even[72+(2*i)+1] = tx_even_data_lpbk[10+(2*i)];
    assign adapter_to_pad_data_odd[72+(2*i)]    = tx_odd_data_lpbk[11+(2*i)];
    assign adapter_to_pad_data_odd[72+(2*i)+1]  = tx_odd_data_lpbk[10+(2*i)];
   end
endgenerate


//Driving constant value(1'b0) to unused bits
generate
  for(i=42; i<60; i=i+1)
   begin: adapter_to_pad_even_42_58
    assign adapter_to_pad_data_even[i] = 1'b0;
    assign adapter_to_pad_data_odd[i]  = 1'b0;
   end
endgenerate

// Selection of clock test logic to observe forward clock from the bumps
// In this mode BERT generators drives the clock pads and BERT checkers 
// receive data to check stuck at failures in clock path logic.
assign bert_clk_test = fwd_clk_test_sync & 
                           (rx_lpbk_mode | tx_lpbk_mode);

//Near side Loopback Mode
assign adapter_to_pad_data_even[70] = bert_clk_test ? tx_data_in_even[3] : 1'b1; 
assign adapter_to_pad_data_even[71] = bert_clk_test ? tx_data_in_even[2] : 1'b0; 
 
assign adapter_to_pad_data_odd[70] = bert_clk_test ? tx_data_in_odd[3] : 1'b0; 
assign adapter_to_pad_data_odd[71] = bert_clk_test ? tx_data_in_odd[2] : 1'b1; 

//==============================================
//ns_fwd_clk Even Data
assign adapter_to_pad_data_even[31]  = bert_clk_test ? tx_data_in_even[1] : 1'b1; 
assign adapter_to_pad_data_even[30]  = bert_clk_test ? tx_data_in_even[0] : 1'b0;
//ns_fwd_clk Odd Data
assign adapter_to_pad_data_odd[31]   = bert_clk_test ? tx_data_in_odd[1] : 1'b0; 
assign adapter_to_pad_data_odd[30]   = bert_clk_test ? tx_data_in_odd[0] : 1'b1; 

//================================================
//Loop back Data from Transmitter Redundancy ouput
//================================================
//Loopback Data should come from Analog

// PAD 60-69 - RX data
generate
  for(i=0; i<5; i=i+1)
   begin: rx_pad_to_adapt_lpb_0_9
    assign rx_even_data_lpbk[1+(2*i)] = pad_to_adapter_dout_even[40-(2*i)+1];
    assign rx_even_data_lpbk[2*i]     = pad_to_adapter_dout_even[40-(2*i)];
    assign rx_odd_data_lpbk[1+(2*i)]  = pad_to_adapter_dout_odd[40-(2*i)+1];
    assign rx_odd_data_lpbk[2*i]      = pad_to_adapter_dout_odd[40-(2*i)];
   end
endgenerate

// PAD 72-101 - RX data
generate
  for(i=0; i<15; i=i+1)
   begin: rx_pad_to_adapt_lpb_10_39
    assign rx_even_data_lpbk[10+(2*i)+1] = pad_to_adapter_dout_even[28-(2*i)+1];
    assign rx_even_data_lpbk[10+(2*i)]   = pad_to_adapter_dout_even[28-(2*i)];
    assign rx_odd_data_lpbk[10+(2*i)+1]  = pad_to_adapter_dout_odd[28-(2*i)+1];
    assign rx_odd_data_lpbk[10+(2*i)]    = pad_to_adapter_dout_odd[28-(2*i)];
   end
endgenerate

//============================================
//Output(Rx Even and Odd Data Bits) To Adapter
//============================================

// PAD 60-69 - RX data
generate
  for(i=0; i<5; i=i+1)
   begin: rx_pad_to_adapt_data_60_69
    assign rx_even_data[1+(2*i)] = pad_to_adapter_dout_even[60+(2*i)];
    assign rx_even_data[2*i]     = pad_to_adapter_dout_even[60+(2*i)+1];
    assign rx_odd_data[1+(2*i)]  = pad_to_adapter_dout_odd[60+(2*i)];
    assign rx_odd_data[2*i]      = pad_to_adapter_dout_odd[60+(2*i)+1];
   end
endgenerate

// PAD 72-101 - RX data
generate
  for(i=0; i<15; i=i+1)
   begin: rx_pad_to_adapt_data_72_101
    assign rx_even_data[11+(2*i)] = pad_to_adapter_dout_even[72+(2*i)];
    assign rx_even_data[10+(2*i)] = pad_to_adapter_dout_even[72+(2*i)+1];
    assign rx_odd_data[11+(2*i)]  = pad_to_adapter_dout_odd[72+(2*i)];
    assign rx_odd_data[10+(2*i)]  = pad_to_adapter_dout_odd[72+(2*i)+1];
   end
endgenerate

//==========================================
// Async Signals From Adapter
//==========================================
assign adapter_to_pad_async[49]  = ns_adapter_rstn;
assign adapter_to_pad_async[48]  = ns_mac_rdy     ;
assign adapter_to_pad_async[47]  = ns_sr_load     ;
assign adapter_to_pad_async[46]  = ns_sr_data     ;
assign adapter_to_pad_async[45]  = ~ns_sr_clk     ; // FIX ME !!!
assign adapter_to_pad_async[44]  = ns_sr_clk      ;
assign adapter_to_pad_async[43]  = ~ns_rcv_clk; // FIX ME !!!
assign adapter_to_pad_async[42]  = ns_rcv_clk;
assign adapter_to_pad_async[31]  = 1'b0; // FIX ME !!!
assign adapter_to_pad_async[30]  = 1'b0;

assign adapter_to_pad_async[29:0]   = {30{1'b0}};
assign adapter_to_pad_async[41:32]  = {10{1'b0}};
assign adapter_to_pad_async[101:50] = {52{1'b0}};

//==========================================
//Async signals to Adapter
//==========================================
assign fs_rcv_clk_out      = async_data_to_adapter[59];
assign fs_sr_clk_out       = async_data_to_adapter[57];
assign fs_sr_data_out      = async_data_to_adapter[55];
assign fs_sr_load_out      = async_data_to_adapter[54];
assign fs_mac_rdy_out      = async_data_to_adapter[53];

assign fs_adapter_rstn_out = async_data_to_adapter[52] |
                             rx_lpbk_mode              |
                             tx_lpbk_mode;

//=============================================
//Redundancy Module Instantiation
//=============================================
aib_redundancy_wrp
        i_aib_redundancy_adapter_to_pad (
            .pad_shift         (shift_en                 ),

            .pad_even_data_in  (adapter_to_pad_data_even ),
            .pad_odd_data_in   (adapter_to_pad_data_odd  ),
            .pad_async_in      (adapter_to_pad_async     ),
            .pad_async_out     (async_data_to_pad        ),
            .pad_even_data_out (even_data_to_pad         ),
            .pad_odd_data_out  (odd_data_to_pad          ),

            .pad_tx_en         (tx_en                    ),
            .pad_rx_en         (rx_en                    ),
            .pad_async_tx_en   (async_tx_en              ),
            .pad_async_rx_en   (async_rx_en              ),
            .pad_sdr_mode_en   (sdr_mode                 ),
            .wkpu_en_in        (wkpu_en_in[101:0]        ),
            .wkpd_en_in        (wkpd_en_in[101:0]        ),

            .pad_tx_en_out      (tx_en_out               ),
            .pad_rx_en_out      (rx_en_out               ),
            .pad_async_tx_en_out(async_tx_en_out         ),
            .pad_async_rx_en_out(async_rx_en_out         ),
            .pad_sdr_mode_en_out(sdr_mode_en_to_pad      ),
            .wkpu_en_out        (wkpu_en_out[101:0]      ),
            .wkpd_en_out        (wkpd_en_out[101:0]      )
       );

aib_redundancy_wrp
i_aib_redundancy_pad_to_adapter (
            .pad_shift         (shift_en                 ),

            .pad_even_data_in  (data_even_from_pad       ),
            .pad_odd_data_in   (data_odd_from_pad        ),
            .pad_async_in      (pad_to_adapter_async_in  ),
            .pad_async_out     (async_data_to_adapter    ),
            .pad_even_data_out (pad_to_adapter_dout_even ),
            .pad_odd_data_out  (pad_to_adapter_dout_odd  ),

            .pad_tx_en         ( {102{1'b0}}             ), //Drive to constant values(102'b0)
            .pad_rx_en         ( {102{1'b0}}             ),
            .pad_async_tx_en   ( {102{1'b0}}             ),
            .pad_async_rx_en   ( {102{1'b0}}             ),
            .pad_sdr_mode_en   ( {102{1'b0}}             ),
            .wkpu_en_in        ( {102{1'b0}}             ),
            .wkpd_en_in        ( {102{1'b0}}             ),

            .pad_tx_en_out     (tx_en_out_nc             ), 
            .pad_rx_en_out     (rx_en_out_nc             ), 
            .pad_async_tx_en_out(async_tx_en_out_nc      ), 
            .pad_async_rx_en_out(async_rx_en_out_nc      ),  
            .pad_sdr_mode_en_out(sdr_mode_en_out_nc      ),
            .wkpu_en_out        (wkpu_en_out_nc[101:0]   ),
            .wkpd_en_out        (wkpd_en_out_nc[101:0]   )
        );

endmodule
