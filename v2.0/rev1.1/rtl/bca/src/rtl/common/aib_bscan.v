// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2022 HCL Technologies Ltd.
// Copyright (C) 2022 Blue Cheetah Analog Design, Inc.
// Copyright (C) 2021 Intel Corporation. 

module aib_bscan (
   input   odat_asyn_aib,       //async data RX from AIB 
   input   async_data_adap,     //async data TX from HSSI Adapter
   input   tx_async_en_adap,    // TX asynchronous enable from Adapter
   input   jtag_tx_scanen_in,   //JTAG shift DR, active high
   input   tx_jtag_clk_g,       // Gated clock for TX shift register
   input   rx_jtag_clk_g,       // Gated clock for RX shift register
   input   jtag_tx_scan_in,     //JTAG TX data scan in
   input   jtag_mode_in,        //JTAG mode select
   input   jtag_rstb_en,        //reset_en from TAP
   input   jtag_rstb,           //reset signal from TAP
   input   jtag_intest,         //intest from TAP

   output   jtag_rx_scan_out,   //JTAG TX scan chain output
   output   tx_async_en_aib,    // TX asynchronous enable to AIB pad
   output   odat_asyn_adap,     //async data RX to HSSI Adapter
   output   async_data_aib      //async data TX to AIB
);

reg [1:0]   tx_reg;
reg         rx_reg;
reg         rx_nreg;
wire [1:0]  tx_shift;  
wire [1:0]  tx_intst;  
wire        rx_shift; 

assign jtag_rx_scan_out = rx_nreg;

clk_mux async_data_aib_ckmux(
// Inputs
.clk1   (tx_reg[1]),        // s=1
.clk2   (async_data_adap),  // s=0
.s      (jtag_mode_in),
// Outputs
.clkout (async_data_aib)
);

assign tx_async_en_aib = jtag_mode_in ? tx_reg[0] : tx_async_en_adap;

clk_mux odat_asyn_adap_ckmux(
// Inputs
.clk1   (rx_reg),        // s=1
.clk2   (odat_asyn_aib), // s=0
.s      (jtag_intest),
// Outputs
.clkout (odat_asyn_adap)
);

assign tx_shift[0] = (jtag_tx_scanen_in) ? tx_reg[1] : tx_intst[0];

clk_mux tx_shift_4_ckmux(
// Inputs
.clk1   (jtag_tx_scan_in),  // s=1
.clk2   (tx_intst[1]),      // s=0
.s      (jtag_tx_scanen_in),
// Outputs
.clkout (tx_shift[1])
);

assign tx_intst[0] = (jtag_intest) ? tx_async_en_adap : tx_reg[0];

clk_mux tx_intst_4_ckmux(
// Inputs
.clk1   (async_data_adap), // s=1
.clk2   (tx_reg[1]),       // s=0
.s      (jtag_intest),
// Outputs
.clkout (tx_intst[1])
);

always @(posedge tx_jtag_clk_g)
  begin
    tx_reg <= tx_shift;
  end

clk_mux rx_shift_0_ckmux(
// Inputs
.clk1   (tx_reg[0]),          // s=1
.clk2   (odat_asyn_adap),  // s=0
.s      (jtag_tx_scanen_in),
// Outputs
.clkout (rx_shift)
);

always @(posedge rx_jtag_clk_g)
  begin
    rx_reg <= rx_shift;
  end

always @(negedge rx_jtag_clk_g)
  begin
    rx_nreg <= rx_reg;
  end

endmodule
