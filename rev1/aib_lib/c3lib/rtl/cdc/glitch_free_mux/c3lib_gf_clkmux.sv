// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 

//-----------------------------------------------------------------------------
// Copyright (C) 2015 Altera Corporation. 
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
//  $Date: 2018/03/12 $
//-----------------------------------------------------------------------------
// Description: Glitch Free Clock Mux
//              Produce a glitch free clock (o_avmm_clk) from muxing AVMM1 USER clk from CR3SSM clock
//              The selector is the bit 0 of the base local register at address[8:0] = 9'h0
//              ( signal arbiter )
//              The module also produce a asynchronous reset (o_avmm_rst_n) which de-assertion
//              is synchronized to the gated clock o_avmm_clk
//              the scan IO i_scan_mode_n, i_rst_n_bypass can bypass the async reset o_avmm_rst_n
//
//---------------------------------------------------------------------------
//
//
//-----------------------------------------------------------------------------
// Change log
//
//
//-----------------------------------------------------------------------------
module c3lib_gf_clkmux (
      input logic i_sel_clk,      // Clock Mux selector
      input logic i_clk_a  ,      // User-AVMM clk input
      input logic i_rst_a_n,      // User-AVMM clk input
      input logic i_clk_b  ,      // CRSSM-AVMM clk input
      input logic i_rst_b_n,      // CRSSM-AVMM clk input
      input logic i_scan_mode_n,  // Active low i_scan_mode_n = 0,selects i_clk_a. When =1, selection determined by i_
      input logic i_rst_n_bypass, // DFT controllable reset input from test logic
      output logic o_clk_out      // Mux clock output 
);


logic [2:0] clk_a_sel;
logic [2:0] clk_b_sel;
logic g_clk_a;
logic g_clk_b;
logic tst_clk_en_a;
logic tst_clk_en_b;
logic mux_i_rst_b_n;
logic mux_i_rst_a_n;

// To make spyglass happy
var	logic	clk_a_sel_bit2_inv;
var	logic	i_sel_clk_inv;
var	logic	clk_b_sel_bit2_inv;


/////////////////////////////////////////////////////////////////////////
//
// Clock B selection (i_sel_clk = 1b)
//
/////////////////////////////////////////////////////////////////////////
assign clk_a_sel_bit2_inv = ~clk_a_sel[2];
c3lib_and2_lcell gfmux_clk_b_sel (
  .in0         (i_sel_clk),
  .in1         (clk_a_sel_bit2_inv),
  .out         (clk_b_sel[0])
  );

//DFX control
c3lib_mux2_svt_2x gfmux_clk_b_scan_rst_mux( 
  .in0 (i_rst_n_bypass),
  .in1 (i_rst_b_n),
  .sel (i_scan_mode_n),
  .out (mux_i_rst_b_n)
);
  
c3lib_bitsync #(
      .DWIDTH            (1  ),
      .RESET_VAL         (0  ),
      .DST_CLK_FREQ_MHZ  (500),
      .SRC_DATA_FREQ_MHZ (100)
) clk_b_sel_sync           (
      .clk               (i_clk_b ),
      .rst_n             (mux_i_rst_b_n),
      .data_in           (clk_b_sel[0] ),
      .data_out          (clk_b_sel[1] )
);

always @(negedge i_clk_b or negedge mux_i_rst_b_n) begin : p_gfclk_b
   if (mux_i_rst_b_n==1'b0) begin
      clk_b_sel[2] <= 1'b0;
   end
   else begin
      clk_b_sel[2] <= clk_b_sel[1];
   end
end : p_gfclk_b

/////////////////////////////////////////////////////////////////////////
//
// Clock A selection (i_sel_clk = 0b)
//
/////////////////////////////////////////////////////////////////////////
assign i_sel_clk_inv      = ~i_sel_clk;
assign clk_b_sel_bit2_inv = ~clk_b_sel[2];
c3lib_and2_lcell gfmux_clk_a_sel (
  .in0         (i_sel_clk_inv),
  .in1         (clk_b_sel_bit2_inv),
  .out         (clk_a_sel[0])
  );

//DFX control
c3lib_mux2_svt_2x gfmux_clk_a_scan_rst_mux( 
  .in0 (i_rst_n_bypass),
  .in1 (i_rst_a_n),
  .sel (i_scan_mode_n),
  .out (mux_i_rst_a_n)
);
  
c3lib_bitsync #(
      .DWIDTH            (1  ),
      .RESET_VAL         (0  ),
      .DST_CLK_FREQ_MHZ  (500),
      .SRC_DATA_FREQ_MHZ (100)
) clk_a_sel_sync           (
      .clk               (i_clk_a ),
      .rst_n             (mux_i_rst_a_n),
      .data_in           (clk_a_sel[0] ),
      .data_out          (clk_a_sel[1] )
);


always @(negedge i_clk_a or negedge mux_i_rst_a_n) begin : p_gfclk_a
   if (mux_i_rst_a_n==1'b0) begin
      clk_a_sel[2] <= 1'b0;
   end
   else begin
      clk_a_sel[2] <= clk_a_sel[1];
   end
end : p_gfclk_a


////////////////////////////////////////
// Mux clock outputs
////////////////////////////////////////

//enable i_clk_a to propagate to output in DFT mode
c3lib_mux2_svt_2x gfmux_tst_clk_en_a( 
  .in0 (1'b1),
  .in1 (clk_a_sel[2]),
  .sel (i_scan_mode_n), //active low in scan mode
  .out (tst_clk_en_a)
);

//disable i_clk_b gate in DFT mode
c3lib_mux2_svt_2x gfmux_tst_clk_en_b( 
  .in0 (1'b0),
  .in1 (clk_b_sel[2]),
  .sel (i_scan_mode_n), //active low in scan mode
  .out (tst_clk_en_b)
);


// c3lib_ckg_posedge_ctn gfmux_clk_gate_a (
//    .tst_en    (~i_scan_mode_n & ~i_sel_clk ), //  
//    .clk_en    (i_scan_mode_n  & tst_clk_en_a   ), //  input  logic
//    .clk       (i_clk_a), //  input  logic
//    .gated_clk (g_clk_a)  //  output logic
// );
// 
// c3lib_ckg_posedge_ctn gfmux_clk_gate_b (
//    .tst_en    (~i_scan_mode_n & i_sel_clk  ), //  
//    .clk_en    (i_scan_mode_n  & tst_clk_en_b      ), //  input  logic
//    .clk       (i_clk_b   ), //  input  logic
//    .gated_clk (g_clk_b  )  //  output logic
// );

//    //NOTE: This AND-OR can be replaced by three discrete NAND2 cells.
//    c3lib_and2_svt_2x gfmux_clk_gate_a ( 
//      .in0 (tst_clk_en_a),
//      .in1 (i_clk_a),
//      .out (g_clk_a)
//      );
//      
//    c3lib_and2_svt_2x gfmux_clk_gate_b ( 
//      .in0 (tst_clk_en_b),
//      .in1 (i_clk_b),
//      .out (g_clk_b)
//      );
//      
//    c3lib_or2_svt_2x gfmux_clk_out_or (
//      .in0         (g_clk_a),
//      .in1         (g_clk_b),
//      .out         (o_clk_out)
//      );


c3lib_nand2_lcell gfmux_clk_gate_a ( 
  .in0 (tst_clk_en_a),
  .in1 (i_clk_a),
  .out (g_clk_a)
  );
  
c3lib_nand2_lcell gfmux_clk_gate_b ( 
  .in0 (tst_clk_en_b),
  .in1 (i_clk_b),
  .out (g_clk_b)
  );
  
c3lib_nand2_lcell gfmux_clk_out (
  .in0         (g_clk_a),
  .in1         (g_clk_b),
  .out         (o_clk_out)
  );



endmodule : c3lib_gf_clkmux

