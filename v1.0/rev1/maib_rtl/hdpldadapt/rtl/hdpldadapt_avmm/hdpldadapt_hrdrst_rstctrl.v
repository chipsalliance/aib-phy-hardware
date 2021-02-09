// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module hdpldadapt_hrdrst_rstctrl
(
	input	wire		csr_rdy_in,
	input	wire		csr_rdy_dly_in,
	input	wire		usermode_in,
	input	wire		nfrzdrv_in,
	input	wire		pr_channel_freeze_n,
	input	wire		avmm_clock_reset_hrdrst_rx_osc_clk,
	input	wire		avmm_clock_reset_hrdrst_tx_osc_clk,
	input	wire		avmm_clock_hrdrst_rx_osc_clk,
	//input	wire		aib_fabric_osc_dll_lock,
	input	wire		sr_hssi_osc_transfer_en,
	//input	wire		r_avmm_hrdrst_osc_dll_lock_bypass,
	input	wire		adapter_scan_rst_n,
	input	wire		adapter_scan_mode_n,
	output  wire            csr_rdy_out,
	output  wire            csr_rdy_dly_out,
	output	wire		usermode_out,
	output	wire		nfrzdrv_out,
	//output  reg		aib_fabric_osc_dll_lock_req,
	output	wire		aib_fabric_csr_rdy_dly_in,
	output	wire		pld_hssi_osc_transfer_en,
	output	wire		avmm_reset_hrdrst_rx_osc_clk_rst_n,
	output	wire		avmm_reset_hrdrst_tx_osc_clk_rst_n,
	output	reg		avmm_hrdrst_fabric_osc_transfer_en,
	output  wire		avmm_hrdrst_testbus
);


/*
//********************************************************************
// Define Parameters 
//********************************************************************
	localparam  WAIT_RX_OSC_CLK_READY	= 2'b00;
	localparam  SEND_OCS_DLL_LOCK_REQ	= 2'b01;
	localparam  WAIT_OSC_DLL_LOCK		= 2'b10;
	localparam  OSC_TRANSFER_EN		= 2'b11;

//********************************************************************
//********************************************************************
	
	reg [1:0]   	osc_rst_sm_cs;
	reg [1:0]   	osc_rst_sm_ns;

	reg		avmm_hrdrst_osc_dll_lock_req_comb;
	reg		avmm_hrdrst_fabric_osc_transfer_en_comb;

        reg [3:0]       avmm_hrdrst_counter;
        reg             avmm_hrdrst_counter_done;
	reg		avmm_hrdrst_reset_count;
	reg		avmm_hrdrst_count_wait_for_clk_rdy;
*/

        wire            int_avmm_hrd_rst_n;
	wire		frz_2one_by_nfrzdrv_or_pr_channel_freeze_n;

//********************************************************************
// Feedthrough
//********************************************************************
        assign csr_rdy_out = csr_rdy_in;
        assign csr_rdy_dly_out = csr_rdy_dly_in;
	assign aib_fabric_csr_rdy_dly_in = csr_rdy_dly_in;
	assign usermode_out = usermode_in;
	assign nfrzdrv_out = nfrzdrv_in;

//********************************************************************
// Reset Synchronizer
//********************************************************************
assign int_avmm_hrd_rst_n = (adapter_scan_mode_n & csr_rdy_dly_in) | (~adapter_scan_mode_n & adapter_scan_rst_n);

cdclib_rst_n_sync cdclib_rst_n_sync_avmm_hrdrst_rx_osc_clk
        (
        .rst_n(int_avmm_hrd_rst_n),
        .rst_n_bypass(adapter_scan_rst_n),
        .clk (avmm_clock_reset_hrdrst_rx_osc_clk),
        .scan_mode_n(adapter_scan_mode_n),
        .rst_n_sync(avmm_reset_hrdrst_rx_osc_clk_rst_n)
        );

cdclib_rst_n_sync cdclib_rst_n_sync_avmm_hrdrst_tx_osc_clk
        (
        .rst_n(int_avmm_hrd_rst_n),
        .rst_n_bypass(adapter_scan_rst_n),
        .clk (avmm_clock_reset_hrdrst_tx_osc_clk),
        .scan_mode_n(adapter_scan_mode_n),
        .rst_n_sync(avmm_reset_hrdrst_tx_osc_clk_rst_n)
        );

//********************************************************************
// Test bus
//********************************************************************
//assign avmm_hrdrst_testbus[3:0] = {avmm_hrdrst_fabric_osc_transfer_en,aib_fabric_osc_dll_lock_req,osc_rst_sm_cs[1:0]};
assign avmm_hrdrst_testbus = avmm_hrdrst_fabric_osc_transfer_en;

//********************************************************************
// PLD
//********************************************************************
assign frz_2one_by_nfrzdrv_or_pr_channel_freeze_n = ~(nfrzdrv_in & pr_channel_freeze_n);
assign pld_hssi_osc_transfer_en = frz_2one_by_nfrzdrv_or_pr_channel_freeze_n | sr_hssi_osc_transfer_en; 

//********************************************************************
// Osc Reset State Machine Output
//********************************************************************

always @ (negedge avmm_reset_hrdrst_rx_osc_clk_rst_n or posedge avmm_clock_hrdrst_rx_osc_clk)
begin
	if (~avmm_reset_hrdrst_rx_osc_clk_rst_n)
	begin
		avmm_hrdrst_fabric_osc_transfer_en <= 1'b0;
	end
	else
	begin
		avmm_hrdrst_fabric_osc_transfer_en <= sr_hssi_osc_transfer_en;
      end
  end
/*
//********************************************************************
// Counters for Osc Reset SM
//********************************************************************
always @ (negedge avmm_reset_hrdrst_rx_osc_clk_rst_n or posedge avmm_clock_hrdrst_rx_osc_clk)
begin
	if (~avmm_reset_hrdrst_rx_osc_clk_rst_n)
	begin
		avmm_hrdrst_counter[3:0] <= 4'h0;
        	avmm_hrdrst_counter_done <= 1'b0;
      	end
    	else if (avmm_hrdrst_reset_count)
      	begin
        	avmm_hrdrst_counter[3:0] <= 4'h0;
        	avmm_hrdrst_counter_done <= 1'b0;
      	end
	else 
      	begin
        	avmm_hrdrst_counter <= avmm_hrdrst_counter + 4'h1;
        	if (~avmm_hrdrst_counter_done)
          	begin
            		if(avmm_hrdrst_count_wait_for_clk_rdy)
              		begin
                		avmm_hrdrst_counter_done <= (avmm_hrdrst_counter[3:0] == 4'b1000) ? 1'b1 : 1'b0;
              		end
         	end 
      	end
end

//********************************************************************
// Osc Reset State Machine Output
//********************************************************************

always @ (negedge avmm_reset_hrdrst_rx_osc_clk_rst_n or posedge avmm_clock_hrdrst_rx_osc_clk)
begin
	if (~avmm_reset_hrdrst_rx_osc_clk_rst_n)
	begin
		aib_fabric_osc_dll_lock_req <= 1'b0;
		avmm_hrdrst_fabric_osc_transfer_en <= 1'b0;
	end
	else
	begin
		aib_fabric_osc_dll_lock_req <= avmm_hrdrst_osc_dll_lock_req_comb; 
		avmm_hrdrst_fabric_osc_transfer_en <= avmm_hrdrst_fabric_osc_transfer_en_comb;
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
	avmm_hrdrst_osc_dll_lock_req_comb = 1'b0;
	avmm_hrdrst_fabric_osc_transfer_en_comb = 1'b0;
	avmm_hrdrst_reset_count = 1'b1;
	avmm_hrdrst_count_wait_for_clk_rdy = 1'b0;
    
	case(osc_rst_sm_cs)
	WAIT_RX_OSC_CLK_READY: 
	begin
		avmm_hrdrst_reset_count = 1'b0;
		avmm_hrdrst_count_wait_for_clk_rdy = 1'b1;
            	if(avmm_hrdrst_counter_done)
              	begin
                	osc_rst_sm_ns  = SEND_OCS_DLL_LOCK_REQ;
              	end
        end
        
	SEND_OCS_DLL_LOCK_REQ:
        begin
		avmm_hrdrst_osc_dll_lock_req_comb = 1'b1;
		osc_rst_sm_ns = WAIT_OSC_DLL_LOCK;
        end
      
	WAIT_OSC_DLL_LOCK:
        begin
		avmm_hrdrst_osc_dll_lock_req_comb = 1'b1;
              	if (sr_hssi_osc_transfer_en && (aib_fabric_osc_dll_lock || r_avmm_hrdrst_osc_dll_lock_bypass))
                begin
                	osc_rst_sm_ns = OSC_TRANSFER_EN;
            	end
        end

      	OSC_TRANSFER_EN:
        begin
		avmm_hrdrst_osc_dll_lock_req_comb = 1'b1;
		avmm_hrdrst_fabric_osc_transfer_en_comb = 1'b1;
        end

	default: 
        begin
		osc_rst_sm_ns = WAIT_RX_OSC_CLK_READY;
		avmm_hrdrst_osc_dll_lock_req_comb = 1'b0;
		avmm_hrdrst_fabric_osc_transfer_en_comb = 1'b0;
		avmm_hrdrst_reset_count = 1'b1;
		avmm_hrdrst_count_wait_for_clk_rdy = 1'b0;
        end
      endcase
  end
*/


endmodule // hdpldadapt_hrdrst_rstctrl

