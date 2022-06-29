// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2022 HCL Technologies Ltd.
// Copyright (C) 2022 Blue Cheetah Analog Design, Inc.

module aib_txfifo_clk_gating #(
parameter FF_DEPTH = 16,
parameter DEPTH4   = (FF_DEPTH * 4),
parameter PNT_S    = $clog2(DEPTH4)
)
(
// Outputs
output [FF_DEPTH-1:0] tff_clk_39_0,     // Clocks for word 39-0 of TX FIFO
output [FF_DEPTH-1:0] tff_clk_79_40,    // Clocks for word 79-40 of TX FIFO
output [FF_DEPTH-1:0] tff_clk_119_80,   // Clocks for word 119-80 of TX FIFO
output [FF_DEPTH-1:0] tff_clk_159_120,  // Clocks for word 159-120 of TX FIFO
output [FF_DEPTH-1:0] tff_clk_199_160,
output [FF_DEPTH-1:0] tff_clk_239_200,
output [FF_DEPTH-1:0] tff_clk_279_240,
output [FF_DEPTH-1:0] tff_clk_319_280,

// Inputs
input             txf_wr_clk,   // TX FIFO write clock
input             txf_wr_en,    // TX FIFO write enable
input [PNT_S-1:0] txf_pnt_ff,   // Indicates TX FIFO element to be written
input [1:0]       tx_fifo_mode, // Indicates TX FIFO operation mode
input             m_gen2_mode,  // Indicates TX FIFO operates in GEN2 mode
input             scan_en       // Scan enable
);

localparam [1:0] FIFO1X = 2'b00; // FIFO 1X mode
localparam [1:0] FIFO2X = 2'b01; // FIFO 2X mode
localparam [1:0] FIFO4X = 2'b10; // FIFO 4X mode

localparam [1:0] WD_79_0    = 2'b00;
localparam [1:0] WD_159_80  = 2'b01;
localparam [1:0] WD_239_160 = 2'b10;
localparam [1:0] WD_319_240 = 2'b11;

localparam [0:0] WD_159_0   = 1'b0;
localparam [0:0] WD_319_160 = 1'b1;

reg [FF_DEPTH-1:0] tff_clk_39_0_en;     // Clocks enable for word 39-0
reg [FF_DEPTH-1:0] tff_clk_79_40_en;    // Clocks enable for word 79-40
reg [FF_DEPTH-1:0] tff_clk_119_80_en;   // Clocks enable for word 119-80
reg [FF_DEPTH-1:0] tff_clk_159_120_en;  // Clocks enable for word 159-120
reg [FF_DEPTH-1:0] tff_clk_199_160_en;
reg [FF_DEPTH-1:0] tff_clk_239_200_en;
reg [FF_DEPTH-1:0] tff_clk_279_240_en;
reg [FF_DEPTH-1:0] tff_clk_319_280_en;

// TX FIFO clock enable logic
always @(*)
  begin: tx_fifo_clk_en_logic
    tff_clk_39_0_en[FF_DEPTH-1:0]    = {FF_DEPTH{1'b0}};
    tff_clk_79_40_en[FF_DEPTH-1:0]   = {FF_DEPTH{1'b0}};
    tff_clk_119_80_en[FF_DEPTH-1:0]  = {FF_DEPTH{1'b0}};
    tff_clk_159_120_en[FF_DEPTH-1:0] = {FF_DEPTH{1'b0}};
    tff_clk_199_160_en[FF_DEPTH-1:0] = {FF_DEPTH{1'b0}};
    tff_clk_239_200_en[FF_DEPTH-1:0] = {FF_DEPTH{1'b0}};
    tff_clk_279_240_en[FF_DEPTH-1:0] = {FF_DEPTH{1'b0}};
    tff_clk_319_280_en[FF_DEPTH-1:0] = {FF_DEPTH{1'b0}};
    case(tx_fifo_mode[1:0])
      FIFO1X: // FIFO 1X mode
        begin
          case(txf_pnt_ff[1:0])
            WD_79_0:
              begin
                tff_clk_39_0_en[txf_pnt_ff[PNT_S-1:2]]  = txf_wr_en;
                if(m_gen2_mode)
                  tff_clk_79_40_en[txf_pnt_ff[PNT_S-1:2]] = txf_wr_en;
              end
            WD_159_80:
              begin
                tff_clk_119_80_en[txf_pnt_ff[PNT_S-1:2]]  = txf_wr_en;
                if(m_gen2_mode)
                  tff_clk_159_120_en[txf_pnt_ff[PNT_S-1:2]] = txf_wr_en;
              end
            WD_239_160:
              begin
                tff_clk_199_160_en[txf_pnt_ff[PNT_S-1:2]] = txf_wr_en;
                if(m_gen2_mode)
                  tff_clk_239_200_en[txf_pnt_ff[PNT_S-1:2]] = txf_wr_en;
              end
            WD_319_240:
              begin
                tff_clk_279_240_en[txf_pnt_ff[PNT_S-1:2]] = txf_wr_en;
                if(m_gen2_mode)
                  tff_clk_319_280_en[txf_pnt_ff[PNT_S-1:2]] = txf_wr_en;
              end
          endcase
        end // FIFO1X
      FIFO2X: // FIFO 2X mode
        begin
          case(txf_pnt_ff[1])
            WD_159_0:
              begin
                tff_clk_39_0_en[txf_pnt_ff[PNT_S-1:2]]   = txf_wr_en;
                tff_clk_119_80_en[txf_pnt_ff[PNT_S-1:2]] = txf_wr_en;
                if(m_gen2_mode)
                  begin
                    tff_clk_79_40_en[txf_pnt_ff[PNT_S-1:2]]   = txf_wr_en;
                    tff_clk_159_120_en[txf_pnt_ff[PNT_S-1:2]] = txf_wr_en;
                  end
              end
            WD_319_160:
              begin
                tff_clk_199_160_en[txf_pnt_ff[PNT_S-1:2]] = txf_wr_en;
                tff_clk_279_240_en[txf_pnt_ff[PNT_S-1:2]] = txf_wr_en;
                if(m_gen2_mode)
                  begin
                    tff_clk_239_200_en[txf_pnt_ff[PNT_S-1:2]] = txf_wr_en;
                    tff_clk_319_280_en[txf_pnt_ff[PNT_S-1:2]] = txf_wr_en;
                  end
              end
          endcase
        end
      FIFO4X: // FIFO 4X mode
        begin
          tff_clk_39_0_en[txf_pnt_ff[PNT_S-1:2]]    = txf_wr_en;
          tff_clk_79_40_en[txf_pnt_ff[PNT_S-1:2]]   = txf_wr_en;
          tff_clk_119_80_en[txf_pnt_ff[PNT_S-1:2]]  = txf_wr_en;
          tff_clk_159_120_en[txf_pnt_ff[PNT_S-1:2]] = txf_wr_en;
          tff_clk_199_160_en[txf_pnt_ff[PNT_S-1:2]] = txf_wr_en;
          tff_clk_239_200_en[txf_pnt_ff[PNT_S-1:2]] = txf_wr_en;
          tff_clk_279_240_en[txf_pnt_ff[PNT_S-1:2]] = txf_wr_en;
          tff_clk_319_280_en[txf_pnt_ff[PNT_S-1:2]] = txf_wr_en;
        end // FIFO4X
      default: // default - reg mode
        begin
          tff_clk_39_0_en[FF_DEPTH-1:0]    = {FF_DEPTH{1'b0}};
          tff_clk_79_40_en[FF_DEPTH-1:0]   = {FF_DEPTH{1'b0}};
          tff_clk_119_80_en[FF_DEPTH-1:0]  = {FF_DEPTH{1'b0}};
          tff_clk_159_120_en[FF_DEPTH-1:0] = {FF_DEPTH{1'b0}};
          tff_clk_199_160_en[FF_DEPTH-1:0] = {FF_DEPTH{1'b0}};
          tff_clk_239_200_en[FF_DEPTH-1:0] = {FF_DEPTH{1'b0}};
          tff_clk_279_240_en[FF_DEPTH-1:0] = {FF_DEPTH{1'b0}};
          tff_clk_319_280_en[FF_DEPTH-1:0] = {FF_DEPTH{1'b0}};
        end // default
    endcase
  end // block: tx_fifo_clk_en_logic

genvar i;
// Clock gates for FIFO word 39-0
generate
  for(i=0;i<FF_DEPTH;i = i+1)
    begin:  clk_gate_cel_39_0_gen
      clk_gate_cel clk_gate_cel_39_0(
      .clkout (tff_clk_39_0[i]),    // Clock gated
      .clk    (txf_wr_clk),         // Clock input
      .en     (tff_clk_39_0_en[i]), // Clock enable
      .te     (scan_en)             // Test enable
      );
    end // block: clk_gate_cel_39_0_gen
endgenerate

// Clock gates for FIFO word 79-40
generate
  for(i=0;i<FF_DEPTH;i = i+1)
    begin:  clk_gate_cel_79_40_gen
      clk_gate_cel clk_gate_cel_79_40(
      .clkout (tff_clk_79_40[i]),    // Clock gated
      .clk    (txf_wr_clk),         // Clock input
      .en     (tff_clk_79_40_en[i]), // Clock enable
      .te     (scan_en)             // Test enable
      );
    end // block: clk_gate_cel_79_40_gen
endgenerate

// Clock gates for FIFO word 119-80
generate
  for(i=0;i<FF_DEPTH;i = i+1)
    begin:  clk_gate_cel_119_80_gen
      clk_gate_cel clk_gate_cel_119_80(
      .clkout (tff_clk_119_80[i]),    // Clock gated
      .clk    (txf_wr_clk),           // Clock input
      .en     (tff_clk_119_80_en[i]), // Clock enable
      .te     (scan_en)               // Test enable
      );
    end // block: clk_gate_cel_119_80_gen
endgenerate

// Clock gates for FIFO word 159-120
generate
  for(i=0;i<FF_DEPTH;i = i+1)
    begin:  clk_gate_cel_159_120_gen
      clk_gate_cel clk_gate_cel_159_120(
      .clkout (tff_clk_159_120[i]),    // Clock gated
      .clk    (txf_wr_clk),           // Clock input
      .en     (tff_clk_159_120_en[i]), // Clock enable
      .te     (scan_en)               // Test enable
      );
    end // block: clk_gate_cel_159_120_gen
endgenerate

// Clock gates for FIFO word 199-160
generate
  for(i=0;i<FF_DEPTH;i = i+1)
    begin:  clk_gate_cel_199_160_gen
      clk_gate_cel clk_gate_cel_199_160(
      .clkout (tff_clk_199_160[i]),    // Clock gated
      .clk    (txf_wr_clk),            // Clock input
      .en     (tff_clk_199_160_en[i]), // Clock enable
      .te     (scan_en)                // Test enable
      );
    end // block: clk_gate_cel_199_160_gen
endgenerate

// Clock gates for FIFO word 239-200
generate
  for(i=0;i<FF_DEPTH;i = i+1)
    begin:  clk_gate_cel_239_200_gen
      clk_gate_cel clk_gate_cel_239_200(
      .clkout (tff_clk_239_200[i]),    // Clock gated
      .clk    (txf_wr_clk),            // Clock input
      .en     (tff_clk_239_200_en[i]), // Clock enable
      .te     (scan_en)                // Test enable
      );
    end // block: clk_gate_cel_239_200_gen
endgenerate

// Clock gates for FIFO word 279-240
generate
  for(i=0;i<FF_DEPTH;i = i+1)
    begin:  clk_gate_cel_279_240_gen
      clk_gate_cel clk_gate_cel_279_240(
      .clkout (tff_clk_279_240[i]),    // Clock gated
      .clk    (txf_wr_clk),            // Clock input
      .en     (tff_clk_279_240_en[i]), // Clock enable
      .te     (scan_en)                // Test enable
      );
    end // block: clk_gate_cel_279_240_gen
endgenerate

// Clock gates for FIFO word 319-280
generate
  for(i=0;i<FF_DEPTH;i = i+1)
    begin:  clk_gate_cel_319_280_gen
      clk_gate_cel clk_gate_cel_319_280(
      .clkout (tff_clk_319_280[i]),    // Clock gated
      .clk    (txf_wr_clk),            // Clock input
      .en     (tff_clk_319_280_en[i]), // Clock enable
      .te     (scan_en)                // Test enable
      );
    end // block: clk_gate_cel_319_280_gen
endgenerate

endmodule // aib_txfifo_clk_gating
