# SPDX-License-Identifier: Apache-2.0
# Copyright 2019 Blue Cheetah Analog Design, Inc.

set clk_period 1.0
set jtag_en 0
set shift_en 0
set scan_en 0
set dft_en 0
set dcc_en 1

array set alias_hier {
  dll_clkp_mux xaibcr3_top/xtxdatapath_tx/clkp_mux
  dll_interpolator_0 xaibcr3_top/xtxdatapath_tx/x982/x43/x4/x142
  dcc_helper xaibcr3_top/xrxdatapath_rx/x1591/I82/I0/I37
  dll_dly_retimer xaibcr3_top/xtxdatapath_tx/x982/x43
  dll_dly_mimic_retimer xaibcr3_top/xtxdatapath_tx/x982/x44
  dlyline_full_ff xaibcr3_top/xrxdatapath_rx/x1591/I82/I1/xdll_core/gate_shf_reg[0]
  mindly_full_ff xaibcr3_top/xrxdatapath_rx/x1591/I82/I1/xdll_core/gate_shf_reg[1]
  dcc_sl_div_flops xaibcr3_top/xrxdatapath_rx/x1591/I82/I1/xdll_core/xaibcr3pnr_self_lock_assertion/count1024_reg
  dll_sl_div_flops xaibcr3_top/xtxdatapath_tx/x982/I1/xdll_core/xaibcr3pnr_self_lock_assertion/count1024_reg
}

source PAR2_aibcr3_top_wrp/timing.sdc
