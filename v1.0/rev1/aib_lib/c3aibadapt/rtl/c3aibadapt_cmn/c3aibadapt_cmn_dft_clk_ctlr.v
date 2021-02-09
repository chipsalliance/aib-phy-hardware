// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// DFT_clock_controller.v
//
// Clock switch-over between func clock and test clock
// Provide burst counter support (use gray-code counter)

module c3aibadapt_cmn_dft_clk_ctlr (
  user_clk,                               //User clock
  test_clk,                               //Test clock      
  rst_n,				  //Reset (active low)
  clk_sel_n,                              //Mux sel between user or test clock, Active low
  scan_enable,                            //Scan enable control signal, Active high in IP, Active low in top level
  occ_enable,                             //Control signal to enable OCC, Active high in IP, Active low in top level
  atpg_mode,                              //Control signal for test mode, Active high in IP, Active low in top level
  out_clk                                 //Output clock 
);

parameter CONTROL_REGISTER_PRESENT = 0;

input user_clk;
input test_clk;
input rst_n;
input clk_sel_n;
input scan_enable;
input atpg_mode;
input occ_enable;
output out_clk;

wire int_test_clk;
wire int_user_clk; 
wire [1:0] burst_cnt;                     //may required more bus width if more pulse needed. Current is 2 pulses
wire clk_sel;
wire occ_enable_nand;
wire occ_user_clken;
wire occ_rst_n;

//Inversion for the clock selection  control signal
assign clk_sel = ~clk_sel_n;

// Reset logic
assign occ_rst_n = (atpg_mode == 1'b1)? 1'b1 : rst_n;


// clock mux (between user and test clock) - use clock MUX
// c3adapt_cmn_clkmux2 altr_ckmux21_inst(
c3lib_mux2_ctn altr_ckmux21_inst(
  .ck_out  (out_clk),
  .ck0     (int_user_clk),
  .ck1     (int_test_clk),
  .s0      (clk_sel)
);

// scan control registers
c3aibadapt_cmn_occ_test_ctlregs ctl_reg (
  .clk   (test_clk),
  .rst_n (occ_rst_n),
  .ctrl  (burst_cnt)
//  .clken (test_clk_en)
);

//test clock enable
generate
if(CONTROL_REGISTER_PRESENT == 1) begin : CONTROL_REG
  reg test_clken /* synopsys preserve_sequential */;
  always @(posedge test_clk)
    test_clken <= test_clken;

  // c3adapt_cmn_occ_clkgate altr_clkgate_test_inst (
  //    .clk          (test_clk),
  //    .clk_enable_i (test_clken),
  //    .clk_o        (int_test_clk)
  // );
  c3lib_ckg_posedge_ctn altr_clkgate_test_inst (
    .gated_clk    (int_test_clk),
    .clk          (test_clk),
    .clk_en       (test_clken),
    .tst_en       (1'b0)
  );
end
else begin
  assign int_test_clk = test_clk;
end

endgenerate

// user clock enable
// c3adapt_cmn_occ_clkgate altr_clkgate_user_inst(
//    .clk          (user_clk),
//    .clk_enable_i (occ_user_clken),
//    .clk_o        (int_user_clk)
// );
c3lib_ckg_posedge_ctn altr_clkgate_user_inst(
  .gated_clk    (int_user_clk),
  .clk          (user_clk),
  .clk_en       (occ_user_clken),
  .tst_en       (int_user_clk)
);

c3aibadapt_cmn_occ_enable_logic occ_enable_logic_inst(

    .user_clk (user_clk),
    .scan_enable (scan_enable),
    .occ_enable (occ_enable),
    .atpg_mode (atpg_mode),
    .burst_cnt (burst_cnt),
    .occ_user_clken (occ_user_clken)
);

endmodule
