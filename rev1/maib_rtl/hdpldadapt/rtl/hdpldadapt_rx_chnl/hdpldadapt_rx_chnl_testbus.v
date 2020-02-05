// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
//------------------------------------------------------------------------
// (C) 2009 Altera Corporation. .  
//
//------------------------------------------------------------------------
// File:        
// Revision:    
// Date:        
//------------------------------------------------------------------------
// Description: 
//
//------------------------------------------------------------------------

module hdpldadapt_rx_chnl_testbus 
    (
    input   wire  [3:0]           r_rx_datapath_tb_sel,  // testbus sel
    input   wire [19:0]           rx_fifo_testbus1, 		// RX FIFO
    input   wire [19:0]           rx_fifo_testbus2, 		// RX FIFO
    input   wire [19:0]           rx_cp_bond_testbus,
    input   wire [19:0]           rx_asn_testbus,
    input   wire [19:0]           deletion_sm_testbus,
    input   wire [19:0]           insertion_sm_testbus,
    input   wire [19:0]           word_align_testbus,
    input   wire [19:0]           rx_hrdrst_testbus,    
    input   wire [19:0]           sr_testbus,    
    input   wire [19:0]           avmm_testbus,
    input   wire [19:0]           tx_chnl_testbus,
    input   wire [19:0]           sr_test_data,
    input   wire [19:0]           sr_parity_error_flag,

    output  reg [19:0]		  rx_chnl_testbus
     );
   
    always @* begin
      case (r_rx_datapath_tb_sel)
        4'b0000: rx_chnl_testbus = rx_fifo_testbus1;
        4'b0001: rx_chnl_testbus = rx_fifo_testbus2;
        4'b0010: rx_chnl_testbus = rx_cp_bond_testbus;
        4'b0011: rx_chnl_testbus = deletion_sm_testbus;
        4'b0100: rx_chnl_testbus = insertion_sm_testbus;
        4'b0101: rx_chnl_testbus = rx_asn_testbus;
        4'b0110: rx_chnl_testbus = word_align_testbus;
        4'b1011: rx_chnl_testbus = rx_hrdrst_testbus;
        4'b1010: rx_chnl_testbus = sr_testbus;        
        4'b1001: rx_chnl_testbus = avmm_testbus;
        4'b1000: rx_chnl_testbus = tx_chnl_testbus;        
        4'b1100: rx_chnl_testbus = sr_test_data;
        4'b1101: rx_chnl_testbus = sr_parity_error_flag;
        default: rx_chnl_testbus = {20{1'b0}};
      endcase // case(r_rx_testbus_sel)
    end // always @ *
         
endmodule // hdpldadapt_rx_chnl_testbus
