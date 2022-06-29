// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2022 HCL Technologies Ltd.
// Copyright (C) 2022 Blue Cheetah Analog Design, Inc.

module aib_bs_clk_gating(
// Inputs
input jtag_clk,          // JTAG clock
input jtag_capture_dr,   // Capture data register
input jtag_tx_scanen_in, // JTAG TX scan enable
input i_scan_mode,       // Scan mode
// Outputs
output tx_jtag_clk_g,    // JATG clock gated for transmit shift register
output rx_jtag_clk_g     // JATG clock gated for receive shift register
);

wire rx_jtag_clk_en; // RX JTAG clock enable

// RX JTAG clock enable
assign rx_jtag_clk_en = jtag_tx_scanen_in | jtag_capture_dr;

// TX JTAG clock gate
clk_gate_cel clk_gate_tx_jtag(
.clkout (tx_jtag_clk_g),     // Clock gated
.clk    (jtag_clk),          // Clock input
.en     (jtag_tx_scanen_in), // Clock enable
.te     (i_scan_mode)        // Test enable
); // TX JTAG clock gate

// RX JTAG clock gate
clk_gate_cel clk_gate_rx_jtag(
.clkout (rx_jtag_clk_g),    // Clock gated
.clk    (jtag_clk),         // Clock input
.en     (rx_jtag_clk_en),   // Clock enable
.te     (i_scan_mode)       // Test enable
); // RX JTAG clock gate

endmodule
