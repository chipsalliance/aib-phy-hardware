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

module c3aibadapt_rxchnl_testbus 
    (
    input   wire  [3:0]           r_rx_datapath_tb_sel,  // testbus sel
    input   wire  [2:0]           r_rx_pcs_testbus_sel,  // testbus sel
    input   wire                  r_rx_pcspma_testbus_sel,  // testbus sel
    input   wire [19:0]           rx_fifo_testbus1, 		// RX FIFO
    input   wire [19:0]           rx_fifo_testbus2, 		// RX FIFO
    input   wire [19:0]           rx_cp_bond_testbus,
    input   wire [19:0]           rx_hrdrst_testbus,    
    input   wire [19:0]           rx_asn_testbus1,
    input   wire [19:0]           rx_asn_testbus2,
    input   wire [19:0]           txeq_testbus1,
    input   wire [19:0]           txeq_testbus2,
    input   wire [19:0]           tx_chnl_testbus,
    input   wire [19:0]           avmm_testbus,
    input   wire [19:0]           pld_test_data,
    input   wire [7:0]            pld_pma_testbus,
    input   wire [12:0]           oaibdftdll2core,

    output  wire [1:0]            rx_direct_transfer_testbus,
    output  wire                  tx_direct_transfer_testbus,
    output  wire [19:0]		  rx_chnl_testbus
     );
  
   reg rx_direct_transfer_testbus_bit0_int;
   reg rx_direct_transfer_testbus_bit1_int;
   reg tx_direct_transfer_testbus_int;
   reg pma_testbus_bit0_int;
   reg pma_testbus_bit1_int;
   reg [19:0]	rx_chnl_testbus_int;
 
    always @* begin
      case (r_rx_datapath_tb_sel)
        4'b0000: rx_chnl_testbus_int = rx_fifo_testbus1;
        4'b0001: rx_chnl_testbus_int = rx_fifo_testbus2;
        4'b1011: rx_chnl_testbus_int = rx_hrdrst_testbus;
        4'b1001: rx_chnl_testbus_int = avmm_testbus;
        4'b1000: rx_chnl_testbus_int = tx_chnl_testbus;        
        4'b1100: rx_chnl_testbus_int = pld_test_data;
        4'b1101: rx_chnl_testbus_int = {{7{1'b0}},oaibdftdll2core};
        default: rx_chnl_testbus_int = {20{1'b0}};
      endcase // case(r_rx_testbus_sel)
    end // always @ *

// assign rx_chnl_testbus = (r_rx_datapath_tb_sel == 4'b0101) ? txeq_testbus1 : rx_chnl_testbus_int;
assign rx_chnl_testbus = rx_chnl_testbus_int;

    always @* begin
      case (r_rx_pcs_testbus_sel[2:0])
        3'b000: rx_direct_transfer_testbus_bit0_int = rx_chnl_testbus[0]; 
        3'b001: rx_direct_transfer_testbus_bit0_int = rx_chnl_testbus[3]; 
        3'b010: rx_direct_transfer_testbus_bit0_int = rx_chnl_testbus[6]; 
        3'b011: rx_direct_transfer_testbus_bit0_int = rx_chnl_testbus[9]; 
        3'b100: rx_direct_transfer_testbus_bit0_int = rx_chnl_testbus[12]; 
        3'b101: rx_direct_transfer_testbus_bit0_int = rx_chnl_testbus[15]; 
        3'b110: rx_direct_transfer_testbus_bit0_int = rx_chnl_testbus[18]; 
        default: rx_direct_transfer_testbus_bit0_int = rx_chnl_testbus[0];
      endcase
    end

    always @* begin
      case (r_rx_pcs_testbus_sel[2:0])
        3'b000: tx_direct_transfer_testbus_int = rx_chnl_testbus[1];
        3'b001: tx_direct_transfer_testbus_int = rx_chnl_testbus[4];
        3'b010: tx_direct_transfer_testbus_int = rx_chnl_testbus[7];
        3'b011: tx_direct_transfer_testbus_int = rx_chnl_testbus[10];
        3'b100: tx_direct_transfer_testbus_int = rx_chnl_testbus[13];
        3'b101: tx_direct_transfer_testbus_int = rx_chnl_testbus[16];
        3'b110: tx_direct_transfer_testbus_int = rx_chnl_testbus[19];
        default: tx_direct_transfer_testbus_int = rx_chnl_testbus[1];
      endcase
    end
 
    always @* begin
      case (r_rx_pcs_testbus_sel[2:0])
        3'b000: rx_direct_transfer_testbus_bit1_int = rx_chnl_testbus[2];
        3'b001: rx_direct_transfer_testbus_bit1_int = rx_chnl_testbus[5];
        3'b010: rx_direct_transfer_testbus_bit1_int = rx_chnl_testbus[8];
        3'b011: rx_direct_transfer_testbus_bit1_int = rx_chnl_testbus[11];
        3'b100: rx_direct_transfer_testbus_bit1_int = rx_chnl_testbus[14];
        3'b101: rx_direct_transfer_testbus_bit1_int = rx_chnl_testbus[17];
        default: rx_direct_transfer_testbus_bit1_int = rx_chnl_testbus[2];
      endcase
    end

// XCVRIF SSR
    always @* begin
      case (r_rx_pcs_testbus_sel[1:0])
        2'b00: pma_testbus_bit0_int = pld_pma_testbus[0];
        2'b01: pma_testbus_bit0_int = pld_pma_testbus[2];
        2'b10: pma_testbus_bit0_int = pld_pma_testbus[4];
        2'b11: pma_testbus_bit0_int = pld_pma_testbus[6];
        default: pma_testbus_bit0_int = pld_pma_testbus[0];
      endcase
    end

    always @* begin
      case (r_rx_pcs_testbus_sel[1:0])
        2'b00: pma_testbus_bit1_int = pld_pma_testbus[1];
        2'b01: pma_testbus_bit1_int = pld_pma_testbus[3];
        2'b10: pma_testbus_bit1_int = pld_pma_testbus[5];
        2'b11: pma_testbus_bit1_int = pld_pma_testbus[7];
        default: pma_testbus_bit1_int = pld_pma_testbus[1];
      endcase
    end

    assign tx_direct_transfer_testbus    = r_rx_pcspma_testbus_sel ? tx_direct_transfer_testbus_int : pma_testbus_bit1_int;
    assign rx_direct_transfer_testbus[0] = r_rx_pcspma_testbus_sel ? rx_direct_transfer_testbus_bit0_int : pma_testbus_bit0_int;
    assign rx_direct_transfer_testbus[1] = rx_direct_transfer_testbus_bit1_int;
   
endmodule // c3aibadapt_rxchnl_testbus
