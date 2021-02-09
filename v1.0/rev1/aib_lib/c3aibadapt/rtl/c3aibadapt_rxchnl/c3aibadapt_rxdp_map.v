// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module c3aibadapt_rxdp_map (

  input wire [2:0]   r_dp_map_mode,
  input wire         r_wm_en,
  
  // From NF HSSI
  input wire         pld_pma_rx_found,
  input wire         pld_8g_rxelecidle,
  input wire         pld_rx_prbs_done,
  input wire         pld_rx_prbs_err,
  
  // EHIP
  input wire         rx_ehip_clk,
  input wire         rx_ehip_rst_n,
  input wire [77:0]  rx_ehip_data,
  
  // ELANE
  input wire         rx_elane_clk,
  input wire         rx_elane_rst_n,
  input wire [77:0]  rx_elane_data,
  
  // RSFEC
  input wire         rx_rsfec_clk,
  input wire         rx_rsfec_rst_n,
  input wire [77:0]  rx_rsfec_data,
  
  // XCVRIF
  input wire         rx_pma_clk,
  input wire         rx_pma_rst_n,
  input wire [39:0]  rx_pma_data,
  
  // Loopback
  input wire         r_rx_aib_lpbk_en,
  input wire [1:0]   r_rx_adapter_lpbk_mode,
  input wire         tx_aib_transfer_clk,
  input wire         tx_aib_transfer_clk_rst_n,
  input wire [39:0]  tx_pma_data_lpbk,
  
  // From ASN
  input wire         rx_asn_phystatus,
  
  // From DFT
  input wire         dft_adpt_rst,
  
  // From Clock and Reset
  input wire         rx_clock_fifo_wr_clk,
  input wire         rx_reset_fifo_wr_rst_n,
  
  // To ASN
  output wire        rx_pcs_phystatus,
  
  // To Word Marker 
  output reg [77:0]  word_marker_data,
  output wire	     mark_bit_location,
  output wire [39:0] pma_direct_data
);

localparam RX_EHIP_MODE   = 3'b001;
localparam RX_ELANE_MODE  = 3'b010;
localparam RX_RSFEC_MODE  = 3'b011;
localparam RX_PMADIR_MODE = 3'b100;

wire pld_pma_rx_found_sync;
wire pld_rx_prbs_done_sync;
wire pld_rx_prbs_err_sync;

reg [77:0] ehip_data;
reg [77:0] elane_data;
reg [77:0] rsfec_data;
reg [39:0] pma_lpbk_data;
reg [39:0] rx_pma_data_d0;
reg        rx_pma_wm;


assign pma_direct_data = (r_rx_aib_lpbk_en && (r_rx_adapter_lpbk_mode == 2'b01)) ? pma_lpbk_data : rx_pma_data_d0;

// hd_dpcmn_bitsync2
c3lib_bitsync
  #(
  .SRC_DATA_FREQ_MHZ    (200),   // Source data freq
  .DST_CLK_FREQ_MHZ     (500),   // Dest clock freq
  .DWIDTH               (1),     // Sync Data input
  .RESET_VAL            (0))     // Reset value
  bitsync2_pld_rx_prbs_done (
    .clk      (rx_clock_fifo_wr_clk),
    .rst_n    (rx_reset_fifo_wr_rst_n),
    .data_in  (pld_rx_prbs_done),
    .data_out (pld_rx_prbs_done_sync));

// hd_dpcmn_bitsync2
c3lib_bitsync
  #(
  .SRC_DATA_FREQ_MHZ    (200),   // Source data freq
  .DST_CLK_FREQ_MHZ     (500),   // Dest clock freq
  .DWIDTH               (1),     // Sync Data input
  .RESET_VAL            (0))     // Reset value
  bitsync2_pld_rx_prbs_err (
    .clk      (rx_clock_fifo_wr_clk),
    .rst_n    (rx_reset_fifo_wr_rst_n),
    .data_in  (pld_rx_prbs_err),
    .data_out (pld_rx_prbs_err_sync));

// hd_dpcmn_bitsync2
c3lib_bitsync
  #(
  .SRC_DATA_FREQ_MHZ    (200),   // Source data freq
  .DST_CLK_FREQ_MHZ     (500),   // Dest clock freq
  .DWIDTH               (1),     // Sync Data input
  .RESET_VAL            (0))     // Reset value
  bitsync2_pld_pma_rx_found (
    .clk      (rx_clock_fifo_wr_clk),
    .rst_n    (rx_reset_fifo_wr_rst_n),
    .data_in  (pld_pma_rx_found),
    .data_out (pld_pma_rx_found_sync));


// Packing
always @(posedge rx_ehip_clk or negedge rx_ehip_rst_n) begin
   if (!rx_ehip_rst_n) 
     ehip_data <= {78{1'b0}};
   else begin
     if (r_dp_map_mode == RX_EHIP_MODE) 
       ehip_data <= rx_ehip_data;
   end
end

always @(posedge rx_elane_clk or negedge rx_elane_rst_n) begin
   if (!rx_elane_rst_n) 
     elane_data <= {78{1'b0}};
   else begin
     if (r_dp_map_mode == RX_ELANE_MODE) 
       elane_data <= rx_elane_data;
   end
end

always @(posedge rx_rsfec_clk or negedge rx_rsfec_rst_n) begin
   if (!rx_rsfec_rst_n) 
     rsfec_data <= {78{1'b0}};
   else begin
     if (r_dp_map_mode == RX_RSFEC_MODE) 
       rsfec_data <= rx_rsfec_data;
   end
end

// Loopback 1x mode
always @(posedge tx_aib_transfer_clk or negedge tx_aib_transfer_clk_rst_n) begin
   if (!tx_aib_transfer_clk_rst_n) 
     pma_lpbk_data <= {40{1'b0}};
   else begin
     if (r_rx_aib_lpbk_en && (r_rx_adapter_lpbk_mode == 2'b01))
       pma_lpbk_data <= tx_pma_data_lpbk;
     else pma_lpbk_data <= pma_lpbk_data;
   end
end

// For PMA-Direct half-width mode, place word mark on MSB
always @(posedge rx_pma_clk or negedge rx_pma_rst_n) begin
   if (!rx_pma_rst_n) begin
     rx_pma_data_d0 <= {40{1'b0}};
     rx_pma_wm      <= 1'b0;
   end
   else begin
     if (r_dp_map_mode == RX_PMADIR_MODE) 
       rx_pma_data_d0 <= r_wm_en ? {rx_pma_wm,rx_pma_data[38:0]} : rx_pma_data;
     else rx_pma_data_d0 <= rx_pma_data_d0;

     if (r_wm_en)
       rx_pma_wm  <= ~rx_pma_wm;
   end
end

always @* begin
  case (r_dp_map_mode)
    RX_EHIP_MODE:  word_marker_data = ehip_data;
    RX_ELANE_MODE: word_marker_data = elane_data;
    RX_RSFEC_MODE: word_marker_data = rsfec_data;
    default:       word_marker_data = {78{1'b0}};
  endcase
end

assign rx_pcs_phystatus = 1'b0;

// In mode 4, 5 ,12 2x1x, marking bit is at location 19
assign mark_bit_location = 1'b0;

endmodule
