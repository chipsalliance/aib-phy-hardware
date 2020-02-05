// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module c3aibadapt_txdp_map (
// DPRIO
//input wire        r_tx_chnl_datapath_map_hip_en,
//input wire        r_tx_chnl_datapath_map_gen12_cap,
//input wire        r_tx_chnl_datapath_map_gen3_cap,
//input wire        r_tx_chnl_datapath_map_pmawidth_less10,
//input wire        r_tx_chnl_datapath_map_10g_mode,
//input wire        r_tx_chnl_datapath_map_pma_direct,
//input wire        r_tx_chnl_datapath_map_fallback_mode,
input wire        r_tx_wa_en,

input wire [39:0] aib_hssi_tx_data_in,
input wire        r_tx_presethint_bypass,

input wire [2:0]  r_tx_chnl_datapath_map_mode,
input wire        r_tx_qpi_sr_enable,

// From TX ASYNC
input wire         pld_pma_tx_qpi_pulldn_sr,
input wire         pld_pma_tx_qpi_pullup_sr,
input wire         pld_pma_rx_qpi_pullup_sr,

// From TxEq
input wire [2:0] pld_g3_current_rxpreset,

// From Word builder
input wire         word_align_cmd,         // Control from word align to indicate word align done.
input wire [79:0]  word_align_datain,      // Data from word align.

// TX Synch Datapath
input wire         tx_ehip_clk,
input wire         tx_elane_clk,
input wire         tx_rsfec_clk,
input wire         tx_aib_transfer_clk,

input wire         tx_ehip_rst_n,
input wire         tx_elane_rst_n,
input wire         tx_rsfec_rst_n,
input wire         tx_aib_transfer_rst_n,

// From TX Clock
input wire         tx_clock_fifo_rd_clk,

// From TX Reset
input wire         tx_reset_fifo_rd_rst_n,

// From DFT
input wire         dft_adpt_rst,

// To ASN
output wire [1:0]  rx_pld_rate,

// To NF HSSI
output wire         pld_10g_tx_data_valid,
output wire         pld_pma_rx_qpi_pullup,
output wire         pld_pma_tx_qpi_pulldn,
output wire         pld_pma_tx_qpi_pullup,
output wire         pld_10g_tx_burst_en,
output wire         pld_10g_tx_wordslip,
output wire  [1:0]  pld_10g_tx_diag_status,
output wire         pld_8g_rddisable_tx,
output wire         pld_8g_wrenable_tx,

// To TxEQ block at RX Channel
output wire         txeq_rxeqeval,    
output wire         txeq_rxeqinprogress,
output wire         txeq_invalid_req,  
output wire         txeq_txdetectrx,  
output wire [1:0]   txeq_rate,       
output wire [1:0]   txeq_powerdown, 

// To EHIP/RSFEC
output reg [77:0]   tx_ehip_data,
output reg [77:0]   tx_elane_data,
output reg [77:0]   tx_rsfec_data,
output reg [39:0]   tx_pma_data,

// To Word-alignment
output wire	    mark_bit_location
);

localparam TX_EHIP_MODE   = 3'b001;
localparam TX_ELANE_MODE  = 3'b010;
localparam TX_RSFEC_MODE  = 3'b011;
localparam TX_PMADIR_MODE = 3'b100;

wire pipe_mode;

reg [2:0] qpi_reset_to_high_reg;
reg [2:0] qpi_reset_to_low_reg;

reg  rx_qpi_pullup, tx_qpi_pulldn, tx_qpi_pullup;
wire pld_pma_rx_qpi_pullup_fifo, pld_pma_tx_qpi_pulldn_fifo, pld_pma_tx_qpi_pullup_fifo;

// Tied off
assign pld_10g_tx_burst_en    = dft_adpt_rst ? 1'b1  : 1'b0;
assign pld_10g_tx_wordslip    = dft_adpt_rst ? 1'b1  : 1'b0;
assign pld_10g_tx_diag_status = dft_adpt_rst ? 2'b11 : 2'b00;
assign pld_8g_rddisable_tx    = dft_adpt_rst ? 1'b1  : 1'b0;
assign pld_8g_wrenable_tx     = dft_adpt_rst ? 1'b1  : 1'b0;

// Unpack
always @(posedge tx_ehip_clk or negedge tx_ehip_rst_n) begin
   if (!tx_ehip_rst_n) tx_ehip_data <= {78{1'b0}};
   else begin
     if (r_tx_chnl_datapath_map_mode == TX_EHIP_MODE)
       tx_ehip_data <= {word_align_datain[78:40], word_align_datain[38:0]};
     else 
       tx_ehip_data <= tx_ehip_data;
   end
end

always @(posedge tx_elane_clk or negedge tx_elane_rst_n) begin
   if (!tx_elane_rst_n) tx_elane_data <= {78{1'b0}};
   else begin
     if (r_tx_chnl_datapath_map_mode == TX_ELANE_MODE)
       tx_elane_data <= {word_align_datain[78:40], word_align_datain[38:0]};
     else 
       tx_elane_data <= tx_elane_data;
   end
end

always @(posedge tx_rsfec_clk or negedge tx_rsfec_rst_n) begin
   if (!tx_rsfec_rst_n) tx_rsfec_data <= {78{1'b0}};
   else begin
     if (r_tx_chnl_datapath_map_mode == TX_RSFEC_MODE)
       tx_rsfec_data <= {word_align_datain[78:40], word_align_datain[38:0]};
     else 
       tx_rsfec_data <= tx_rsfec_data;
   end
end

always @(posedge tx_aib_transfer_clk or negedge tx_aib_transfer_rst_n) begin
   if (!tx_aib_transfer_rst_n) tx_pma_data <= {40{1'b0}};
   else begin
     if (r_tx_chnl_datapath_map_mode == TX_PMADIR_MODE)
       tx_pma_data <= r_tx_wa_en ? {1'b0, aib_hssi_tx_data_in[38:0]} : aib_hssi_tx_data_in;
     else 
       tx_pma_data <= tx_pma_data;
   end
end

assign rx_pld_rate[1:0]  = 2'b00;

// assign pipe_mode  = ((r_tx_chnl_datapath_map_mode == 5'b0_1101) || (r_tx_chnl_datapath_map_mode == 5'b0_1110));
assign pipe_mode  = 1'b0;

// overwrite pld_g3_current_rxpreset from TxEq
// bypass from PLD
// wire [2:0] pld_g3_current_rxpreset_i = (r_tx_chnl_datapath_map_mode == 5'b0_1110) ? (r_tx_presethint_bypass ? pld_g3_current_rxpreset[2:0] : word_align_datain[60:58])
// 									: 3'b000;
assign txeq_rxeqeval          = 1'b0;
assign txeq_rxeqinprogress    = 1'b0;
assign txeq_invalid_req       = 1'b0;
assign txeq_txdetectrx        = 1'b0;
assign txeq_rate              = 2'b00;
assign txeq_powerdown         = 2'b00;


// To fix issue in FB 291184 assign pld_10g_tx_data_valid = dft_adpt_rst ? 1'b1   : (r_tx_chnl_datapath_map_mode == 5'b0_0111) ?  word_align_datain[36] : 1'b0;
// To fix issue in FB 291184 assign pld_10g_tx_data_valid = dft_adpt_rst ? 1'b1   : word_align_datain[36];
// In mode 9, 10, 11, 12, force 10g_tx_data_valid to 1
// assign pld_10g_tx_data_valid = dft_adpt_rst || (r_tx_chnl_datapath_map_mode == 5'b0_1000 || r_tx_chnl_datapath_map_mode == 5'b0_1001 || r_tx_chnl_datapath_map_mode == 5'b0_1010 || r_tx_chnl_datapath_map_mode == 5'b0_1011) ? 1'b1   : word_align_datain[36];
assign pld_10g_tx_data_valid = 1'b0;

assign pld_pma_rx_qpi_pullup = pld_pma_rx_qpi_pullup_sr; 
assign pld_pma_tx_qpi_pulldn = pld_pma_tx_qpi_pulldn_sr;
assign pld_pma_tx_qpi_pullup = pld_pma_tx_qpi_pullup_sr;

// In mode 4, 5 ,12 2x1x, marking bit is at location 19
// assign mark_bit_location = (r_tx_chnl_datapath_map_mode == 5'b0_0011 || r_tx_chnl_datapath_map_mode == 5'b0_0100 || r_tx_chnl_datapath_map_mode == 5'b0_1011);
assign mark_bit_location = 1'b0;

endmodule
