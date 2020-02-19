// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module c3aibadapt_hrdrst_rstctrl
(
	input	wire		cfg_avmm_rst_n,
	input	wire		hard_rst_n,
	input   wire            usermode_in,
        input   wire            cfg_avmm_clk,
	input	wire		avmm_clock_reset_hrdrst_rx_osc_clk,
	input	wire		avmm_clock_reset_hrdrst_tx_osc_clk,
	input	wire		avmm_clock_hrdrst_rx_osc_clk,
	input	wire		sr_fabric_osc_transfer_en,
	input	wire		dft_adpt_rst,
	input	wire		adapter_scan_rst_n,
	input	wire		adapter_scan_mode_n,
	output	wire		hard_rst_out_n,
	output  wire            usermode_out,
        output  wire            avmm_reset_cfg_avmm_rst_n,
	output wire		cfg_avmm_raw_rst_n,
	output	wire		avmm_reset_hrdrst_rx_osc_clk_rst_n,
	output	wire		avmm_reset_hrdrst_tx_osc_clk_rst_n,
	output	reg		avmm_hrdrst_hssi_osc_transfer_en,
	output	reg		avmm_hrdrst_hssi_osc_transfer_alive,
	output	wire [4:0]	avmm_hrdrst_testbus,
        output  wire [2:0]      avmm_hrdrst_tb_direct
);

//********************************************************************
// Define Parameters 
//********************************************************************
	localparam  WAIT_RX_OSC_CLK_READY	= 2'b00;
	localparam  OSC_TRANSFER_EN		= 2'b01;
	localparam  OSC_TRANSFER_ALIVE		= 2'b10;

//********************************************************************
//********************************************************************
	reg [1:0]   	osc_rst_sm_cs;
	reg [1:0]   	osc_rst_sm_ns;

	reg		avmm_hrdrst_hssi_osc_transfer_en_comb;
	reg		avmm_hrdrst_hssi_osc_transfer_alive_comb;

        wire            int_avmm_hrd_rst_n;

//********************************************************************
// Feedthrough
//********************************************************************
	assign hard_rst_out_n     = hard_rst_n;
	assign usermode_out       = usermode_in;
	assign cfg_avmm_raw_rst_n = cfg_avmm_rst_n;

//********************************************************************
// Reset Synchronizer
//********************************************************************
assign int_avmm_hrd_rst_n = (adapter_scan_mode_n & ~dft_adpt_rst & hard_rst_n) | (~adapter_scan_mode_n & adapter_scan_rst_n);

// hd_dpcmn_rst_n_sync hd_dpcmn_rst_n_sync_hrdrst_rx_osc_clk
c3lib_rstsync #(.RESET_VAL(0), .DST_CLK_FREQ_MHZ(1000))
  rst_n_sync_hrdrst_rx_osc_clk 
  (
  .rst_n(int_avmm_hrd_rst_n),
  .rst_n_bypass(adapter_scan_rst_n),
  .clk (avmm_clock_reset_hrdrst_rx_osc_clk),
  .scan_mode_n(adapter_scan_mode_n),
  .rst_n_sync(avmm_reset_hrdrst_rx_osc_clk_rst_n)
  );

// hd_dpcmn_rst_n_sync hd_dpcmn_rst_n_sync_hrdrst_tx_osc_clk
c3lib_rstsync #(.RESET_VAL(0), .DST_CLK_FREQ_MHZ(1000))
  rst_n_sync_hrdrst_tx_osc_clk 
  (
  .rst_n(int_avmm_hrd_rst_n),
  .rst_n_bypass(adapter_scan_rst_n),
  .clk (avmm_clock_reset_hrdrst_tx_osc_clk),
  .scan_mode_n(adapter_scan_mode_n),
  .rst_n_sync(avmm_reset_hrdrst_tx_osc_clk_rst_n)
  );

c3lib_rstsync #(.RESET_VAL(0), .DST_CLK_FREQ_MHZ(300))
  rst_n_sync_cfg_avmm_clk (
  .rst_n(cfg_avmm_rst_n),
  .rst_n_bypass(adapter_scan_rst_n),
  .clk (cfg_avmm_clk),
  .scan_mode_n(adapter_scan_mode_n),
  .rst_n_sync(avmm_reset_cfg_avmm_rst_n));

//********************************************************************
// Test bus
//********************************************************************
assign avmm_hrdrst_tb_direct[2:0] = {avmm_hrdrst_hssi_osc_transfer_alive, osc_rst_sm_cs[1:0]};

assign avmm_hrdrst_testbus[4:0] = {avmm_hrdrst_hssi_osc_transfer_alive,avmm_hrdrst_hssi_osc_transfer_en,sr_fabric_osc_transfer_en,osc_rst_sm_cs[1:0]};

//********************************************************************
// Osc Reset State Machine Output
//********************************************************************

always @ (negedge avmm_reset_hrdrst_rx_osc_clk_rst_n or posedge avmm_clock_hrdrst_rx_osc_clk)
begin
	if (~avmm_reset_hrdrst_rx_osc_clk_rst_n)
	begin
		avmm_hrdrst_hssi_osc_transfer_en <= 1'b0;
		avmm_hrdrst_hssi_osc_transfer_alive <= 1'b0;
	end
	else
	begin
		avmm_hrdrst_hssi_osc_transfer_en <= avmm_hrdrst_hssi_osc_transfer_en_comb;
		avmm_hrdrst_hssi_osc_transfer_alive <= avmm_hrdrst_hssi_osc_transfer_alive_comb;
      end
  end

//********************************************************************
// Osc Reset State Machine 
//********************************************************************
always @(negedge avmm_reset_hrdrst_rx_osc_clk_rst_n or posedge avmm_clock_hrdrst_rx_osc_clk) 
begin
	if (~avmm_reset_hrdrst_rx_osc_clk_rst_n) 
	begin
		osc_rst_sm_cs <= WAIT_RX_OSC_CLK_READY;
	end
	else 
	begin
		osc_rst_sm_cs <= osc_rst_sm_ns;
	end
end

always @ (*)
begin
	osc_rst_sm_ns = osc_rst_sm_cs;
	avmm_hrdrst_hssi_osc_transfer_en_comb = 1'b0;
	avmm_hrdrst_hssi_osc_transfer_alive_comb = 1'b0;
    
	case(osc_rst_sm_cs)
	WAIT_RX_OSC_CLK_READY: 
	begin
                osc_rst_sm_ns = OSC_TRANSFER_EN;
        end
        
      	OSC_TRANSFER_EN:
        begin
		avmm_hrdrst_hssi_osc_transfer_en_comb = 1'b1;
		if (sr_fabric_osc_transfer_en)
            	begin
              		osc_rst_sm_ns = OSC_TRANSFER_ALIVE;
            	end
        end
        
      	OSC_TRANSFER_ALIVE:
        begin
		avmm_hrdrst_hssi_osc_transfer_en_comb = 1'b1;
		avmm_hrdrst_hssi_osc_transfer_alive_comb = 1'b1;
        end

	default: 
        begin
		osc_rst_sm_ns = WAIT_RX_OSC_CLK_READY;
		avmm_hrdrst_hssi_osc_transfer_en_comb = 1'b0;
		avmm_hrdrst_hssi_osc_transfer_alive_comb = 1'b0;
        end
      endcase
  end

endmodule // c3aibadapt_hrdrst_rstctrl

