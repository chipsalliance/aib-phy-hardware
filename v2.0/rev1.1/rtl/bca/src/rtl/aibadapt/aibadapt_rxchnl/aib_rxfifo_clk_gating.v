// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2022 HCL Technologies Ltd.
// Copyright (C) 2022 Blue Cheetah Analog Design, Inc.

module aib_rxfifo_clk_gating #(
parameter FF_DEPTH = 16,
parameter DEPTH4   = FF_DEPTH * 4,
parameter PNT_S    = $clog2(DEPTH4)
)
(
// Outputs
output [FF_DEPTH-1:0] rff_clk_39_0,     // Clocks for word 39-0 of RX FIFO
output [FF_DEPTH-1:0] rff_clk_79_40,    // Clocks for word 79-40 of RX FIFO
output [FF_DEPTH-1:0] rff_clk_119_80,
output [FF_DEPTH-1:0] rff_clk_159_120,
output [FF_DEPTH-1:0] rff_clk_199_160,
output [FF_DEPTH-1:0] rff_clk_239_200,
output [FF_DEPTH-1:0] rff_clk_279_240,
output [FF_DEPTH-1:0] rff_clk_319_280,
// Inputs
input             rxf_wr_clk,   // RX FIFO write clock
input             rxf_wr_en,    // RX FIFO write enable
input [PNT_S-1:0] rxf_pnt_ff,   // Indicates RX FIFO element to be written
input             m_gen2_mode,  // Indicates RX FIFO operates in GEN2 mode
input             scan_en       // Scan enable
);

localparam [1:0] FIFO1X = 2'b00; // FIFO 1X mode
localparam [1:0] FIFO2X = 2'b01; // FIFO 2X mode
localparam [1:0] FIFO4X = 2'b10; // FIFO 4X mode

localparam [1:0] WD_79_0    = 2'd0;
localparam [1:0] WD_159_80  = 2'd1;
localparam [1:0] WD_239_160 = 2'd2;
localparam [1:0] WD_319_240 = 2'd3;

reg [FF_DEPTH-1:0] rff_clk_39_0_en;     // Clocks enable for word 39-0
reg [FF_DEPTH-1:0] rff_clk_79_40_en;    // Clocks enable for word 79-40
reg [FF_DEPTH-1:0] rff_clk_119_80_en;
reg [FF_DEPTH-1:0] rff_clk_159_120_en;
reg [FF_DEPTH-1:0] rff_clk_199_160_en;
reg [FF_DEPTH-1:0] rff_clk_239_200_en;
reg [FF_DEPTH-1:0] rff_clk_279_240_en;
reg [FF_DEPTH-1:0] rff_clk_319_280_en;

// RX FIFO clock enable logic
always @(*)
  begin: rx_fifo_clk_en_logic
    rff_clk_39_0_en[FF_DEPTH-1:0]    = {FF_DEPTH{1'b0}};
    rff_clk_79_40_en[FF_DEPTH-1:0]   = {FF_DEPTH{1'b0}};
    rff_clk_119_80_en[FF_DEPTH-1:0]  = {FF_DEPTH{1'b0}};
    rff_clk_159_120_en[FF_DEPTH-1:0] = {FF_DEPTH{1'b0}};
    rff_clk_199_160_en[FF_DEPTH-1:0] = {FF_DEPTH{1'b0}};
    rff_clk_239_200_en[FF_DEPTH-1:0] = {FF_DEPTH{1'b0}};
    rff_clk_279_240_en[FF_DEPTH-1:0] = {FF_DEPTH{1'b0}};
    rff_clk_319_280_en[FF_DEPTH-1:0] = {FF_DEPTH{1'b0}};
    if(m_gen2_mode)// GEN2
      begin
        case(rxf_pnt_ff[1:0])
          WD_79_0:
            begin
              rff_clk_39_0_en[rxf_pnt_ff[PNT_S-1:2]]  = rxf_wr_en;
              rff_clk_79_40_en[rxf_pnt_ff[PNT_S-1:2]] = rxf_wr_en;
            end
          WD_159_80:
            begin
              rff_clk_119_80_en[rxf_pnt_ff[PNT_S-1:2]]  = rxf_wr_en;
              rff_clk_159_120_en[rxf_pnt_ff[PNT_S-1:2]] = rxf_wr_en;
            end
          WD_239_160:
            begin
              rff_clk_199_160_en[rxf_pnt_ff[PNT_S-1:2]] = rxf_wr_en;
              rff_clk_239_200_en[rxf_pnt_ff[PNT_S-1:2]] = rxf_wr_en;
            end
          WD_319_240:
            begin
              rff_clk_279_240_en[rxf_pnt_ff[PNT_S-1:2]] = rxf_wr_en;
              rff_clk_319_280_en[rxf_pnt_ff[PNT_S-1:2]] = rxf_wr_en;
            end
        endcase
      end // GEN2
    else // GEN1
      begin
        case(rxf_pnt_ff[1:0])
          WD_79_0:
            begin
              rff_clk_39_0_en[rxf_pnt_ff[PNT_S-1:2]]  = rxf_wr_en;
            end
          WD_159_80:
            begin
              rff_clk_119_80_en[rxf_pnt_ff[PNT_S-1:2]]  = rxf_wr_en;
            end
          WD_239_160:
            begin
              rff_clk_199_160_en[rxf_pnt_ff[PNT_S-1:2]] = rxf_wr_en;
            end
          WD_319_240:
            begin
              rff_clk_279_240_en[rxf_pnt_ff[PNT_S-1:2]] = rxf_wr_en;
            end
        endcase
      end
  end // blockk: rx_fifo_clk_en_logic

genvar i;
// Clock gates for FIFO word 39-0
generate
  for(i=0;i<FF_DEPTH;i = i+1)
    begin:  clk_gate_cel_39_0_gen
      clk_gate_cel clk_gate_cel_39_0(
      .clkout (rff_clk_39_0[i]),    // Clock gated
      .clk    (rxf_wr_clk),         // Clock input
      .en     (rff_clk_39_0_en[i]), // Clock enable
      .te     (scan_en)             // Test enable
      );
    end // block: clk_gate_cel_39_0_gen
endgenerate

// Clock gates for FIFO word 79-40
generate
  for(i=0;i<FF_DEPTH;i = i+1)
    begin:  clk_gate_cel_79_40_gen
      clk_gate_cel clk_gate_cel_79_40(
      .clkout (rff_clk_79_40[i]),    // Clock gated
      .clk    (rxf_wr_clk),         // Clock input
      .en     (rff_clk_79_40_en[i]), // Clock enable
      .te     (scan_en)             // Test enable
      );
    end // block: clk_gate_cel_79_40_gen
endgenerate

// Clock gates for FIFO word 119-80
generate
  for(i=0;i<FF_DEPTH;i = i+1)
    begin:  clk_gate_cel_119_80_gen
      clk_gate_cel clk_gate_cel_119_80(
      .clkout (rff_clk_119_80[i]),    // Clock gated
      .clk    (rxf_wr_clk),           // Clock input
      .en     (rff_clk_119_80_en[i]), // Clock enable
      .te     (scan_en)               // Test enable
      );
    end // block: clk_gate_cel_119_80_gen
endgenerate

// Clock gates for FIFO word 159-120
generate
  for(i=0;i<FF_DEPTH;i = i+1)
    begin:  clk_gate_cel_159_120_gen
      clk_gate_cel clk_gate_cel_159_120(
      .clkout (rff_clk_159_120[i]),    // Clock gated
      .clk    (rxf_wr_clk),           // Clock input
      .en     (rff_clk_159_120_en[i]), // Clock enable
      .te     (scan_en)               // Test enable
      );
    end // block: clk_gate_cel_159_120_gen
endgenerate

// Clock gates for FIFO word 199-160
generate
  for(i=0;i<FF_DEPTH;i = i+1)
    begin:  clk_gate_cel_199_160_gen
      clk_gate_cel clk_gate_cel_199_160(
      .clkout (rff_clk_199_160[i]),    // Clock gated
      .clk    (rxf_wr_clk),            // Clock input
      .en     (rff_clk_199_160_en[i]), // Clock enable
      .te     (scan_en)                // Test enable
      );
    end // block: clk_gate_cel_199_160_gen
endgenerate

// Clock gates for FIFO word 239-200
generate
  for(i=0;i<FF_DEPTH;i = i+1)
    begin:  clk_gate_cel_239_200_gen
      clk_gate_cel clk_gate_cel_239_200(
      .clkout (rff_clk_239_200[i]),    // Clock gated
      .clk    (rxf_wr_clk),            // Clock input
      .en     (rff_clk_239_200_en[i]), // Clock enable
      .te     (scan_en)                // Test enable
      );
    end // block: clk_gate_cel_239_200_gen
endgenerate

// Clock gates for FIFO word 279-240
generate
  for(i=0;i<FF_DEPTH;i = i+1)
    begin:  clk_gate_cel_279_240_gen
      clk_gate_cel clk_gate_cel_279_240(
      .clkout (rff_clk_279_240[i]),    // Clock gated
      .clk    (rxf_wr_clk),            // Clock input
      .en     (rff_clk_279_240_en[i]), // Clock enable
      .te     (scan_en)                // Test enable
      );
    end // block: clk_gate_cel_279_240_gen
endgenerate

// Clock gates for FIFO word 319-280
generate
  for(i=0;i<FF_DEPTH;i = i+1)
    begin:  clk_gate_cel_319_280_gen
      clk_gate_cel clk_gate_cel_319_280(
      .clkout (rff_clk_319_280[i]),    // Clock gated
      .clk    (rxf_wr_clk),            // Clock input
      .en     (rff_clk_319_280_en[i]), // Clock enable
      .te     (scan_en)                // Test enable
      );
    end // block: clk_gate_cel_319_280_gen
endgenerate

endmodule // aib_rxfifo_clk_gating
