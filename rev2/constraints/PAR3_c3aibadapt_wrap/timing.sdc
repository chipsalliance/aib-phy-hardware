# SPDX-License-Identifier: Apache-2.0
# Copyright 2019 Blue Cheetah Analog Design, Inc.
# Copyright (c) 2019 Ayar Labs, Inc.

set_units -capacitance 1.0pF
set_units -time 1.0ns

# user mode 1 is dcc_en = 0, user mode 2 is dcc_en = 1
echo "=============================================================================="
echo "Reading SDC file..."
echo "=============================================================================="
echo "Clk Period = " $clk_period
echo "JTAG en = " $jtag_en
echo "scan en = " $scan_en
echo "DFT en = " $dft_en
echo "dcc_en = " $dcc_en
# echo "Redundancy mode en" = $redundancy_mode
echo "Do we need atpg_scan?? no test patterns implemented currently only cycling"
echo "through usermode and redundancy"
echo "=============================================================================="

proc get_driving_pin {pin} {
       return [get_pins -leaf -of [all_connected [get_pins $pin]] -filter {pin_direction =~ *out}]
}

# Comments indicated this should be at 250MHz
set SCAN_CLK_PERIOD         [expr $clk_period * 4.0]

# BCA: No clock will be running at full 1GHz during JTAG
if {$jtag_en} {
  set AIB_OSC_PERIOD          $SCAN_CLK_PERIOD
} else {
  set AIB_OSC_PERIOD          $clk_period
}
set SCLK_PERIOD             $clk_period
set TX_FR_WORD_CLK_PERIOD   $clk_period
set RX_FR_WORD_CLK_PERIOD   $clk_period
# It appears that the clocks that are left don't use this
set TX_HR_WORD_CLK_PERIOD   [expr $clk_period * 2.0]
set RX_HR_WORD_CLK_PERIOD   [expr $clk_period * 2.0]
set CFG_AVMM_CLK_PERIOD     3.6

set clk_uncertainty 0.050

set TEST_CLK_62M_PERIOD     16.0
set TEST_CLK_125M_PERIOD    8.0
set TEST_CLK_250M_PERIOD    4.0
set TEST_CLK_500M_PERIOD    2.0
set TEST_CLK_1G_PERIOD      1.0

# Set the mode for the aibcr3_top_wrp
set top_wrp_inst [filter libcell [find / -libcell aibcr3_top_wrp] [find / -instance *]]
if {$dcc_en} {
  set_mode dcc_en $top_wrp_inst
} elseif {$jtag_en} {
  set_mode jtag_en $top_wrp_inst
} else {
  set_mode functional $top_wrp_inst
}

########################
# Osc-related clock
########################
create_clock [get_ports i_osc_clk] -name i_aib_tx_sr_clk -period $AIB_OSC_PERIOD

########################
# SR clock in
########################
# BCA: Removed redundancy constraints
create_clock [get_ports io_aib83] -name i_aib_rx_sr_clk -period $AIB_OSC_PERIOD
# BCA: We need to make sure that the aibcr3_buffx1_top lib includes arcs from iclkn to oclkb_out in order
# to support the below statement, especially if we are deleting generated clocks from within the libs.
create_clock [get_ports io_aib82] -name i_aib_rx_sr_clk_n -period $AIB_OSC_PERIOD -waveform " [expr $AIB_OSC_PERIOD/2] $AIB_OSC_PERIOD "

create_generated_clock -name aib_tx_sr_clk_in_div2_m -divide_by 2 -add \
  -master_clock i_aib_tx_sr_clk \
  -source [get_pin xaibcr3_top_wrp/ohssi_tx_sr_clk_in] \
  [get_pins c3aibadapt/adapt_sr/adapt_srclk_ctl/tcm_ckdiv2_sr_tx_sr_clk/CLK_DIV_2.uu_c3dfx_tcm_div2/clk_out]

create_generated_clock -name aib_tx_sr_clk_in_div2 -divide_by 1 -add \
  -master_clock aib_tx_sr_clk_in_div2_m \
  -source [get_pins c3aibadapt/adapt_sr/adapt_srclk_ctl/tcm_ckdiv2_sr_tx_sr_clk/CLK_DIV_2.uu_c3dfx_tcm_div2/clk_out] \
  [get_driving_pin [get_pins * -hier -filter "full_name =~ c3aibadapt/adapt_sr/adapt_srclk_ctl/tcm_ckdiv2_sr_tx_sr_clk/o_clk"]]

# BCA: Master clock is actually the oscillator clock, despite the naming.  Verified correct master.
create_generated_clock -name aib_tx_sr_clk_in_div4_m -divide_by 4 -add \
  -master_clock i_aib_tx_sr_clk \
  -source [get_pins xaibcr3_top_wrp/ohssi_tx_sr_clk_in] \
          [get_pins c3aibadapt/adapt_sr/adapt_srclk_ctl/tcm_ckdiv4_sr_tx_sr_clk/CLK_DIV_4.uu_c3dfx_tcm_div4/clk_out]

create_generated_clock -name aib_tx_sr_clk_in_div4 -divide_by 1 -add \
  -master_clock aib_tx_sr_clk_in_div4_m \
  -source [get_pins c3aibadapt/adapt_sr/adapt_srclk_ctl/tcm_ckdiv4_sr_tx_sr_clk/CLK_DIV_4.uu_c3dfx_tcm_div4/clk_out] \
  [get_driving_pin [get_pins * -hier -filter "full_name =~ c3aibadapt/adapt_sr/adapt_srclk_ctl/tcm_ckdiv4_sr_tx_sr_clk/o_clk"]]

create_generated_clock -name aib_tx_sr_clk_in_div1 -divide_by 1 -add \
  -master_clock i_aib_tx_sr_clk  \
  -source [get_pin xaibcr3_top_wrp/ohssi_tx_sr_clk_in] \
  [get_driving_pin [get_pins * -hier -filter "full_name =~ c3aibadapt/adapt_sr/adapt_srclk_ctl/tcm_ckmux2_tx_sr_clk_in/uu_c3dfx_tcm/o_clk"]]

########################
# Sampling clock
########################
    # BCA: Removing redundancy constraints
    # create_clock [get_ports io_aib48] -name i_aib_sclk_r -period $SCLK_PERIOD
    create_clock [get_ports io_aib58] -name i_aib_sclk -period $SCLK_PERIOD

# BCA: This clock currently is not propagating in jtag mode, but appears to propagate in other modes.  Likely OK then.
# Note: This one seems to end up with infinite transition time in the lib - maybe we can get rid of this generated
# clock entirely since it is div 1?
create_generated_clock -name aib_sclk_div1 -divide_by 1 -add -master_clock i_aib_sclk  \
  -source [get_pin xaibcr3_top_wrp/ohssi_pld_sclk] \
  [get_driving_pin [get_pins * -hier -filter "full_name =~ c3aibadapt/adapt_rxchnl/rxclk_ctl/tcm_ckmux2_rx_fifo_sclk/uu_c3dfx_tcm/o_clk"]]

########################
# Half-rate clocks
########################

set clkname i_rx_pma_div2_clk
create_clock [get_ports $clkname] -name $clkname -period $RX_HR_WORD_CLK_PERIOD

# BCA: Phase comp clocks are half-rate
set clkname i_rx_elane_clk
create_clock [get_ports $clkname] -name $clkname -period $RX_HR_WORD_CLK_PERIOD
set clkname i_tx_elane_clk
create_clock [get_ports $clkname] -name $clkname -period $TX_HR_WORD_CLK_PERIOD


########################
# Full-rate clocks
########################
set clkname i_tx_pma_clk
create_clock [get_ports $clkname] -name $clkname -period $TX_FR_WORD_CLK_PERIOD

set clkname i_rx_pma_clk
create_clock [get_ports $clkname] -name $clkname -period $RX_FR_WORD_CLK_PERIOD

########################
# TX clocks (AIB2ADAPT clocks)
########################
# Create different clock sources (because of where this comes from...)
# BCA: Removing redundancy constraints
# create_clock [get_ports io_aib30] -name tx_transfer_clk_r -period $TX_FR_WORD_CLK_PERIOD
create_clock [get_ports io_aib43] -name tx_transfer_clk -period $TX_FR_WORD_CLK_PERIOD
create_clock [get_ports io_aib42] -name tx_transfer_clk_n -period $TX_FR_WORD_CLK_PERIOD \
   -waveform " [expr $TX_FR_WORD_CLK_PERIOD/2] $TX_FR_WORD_CLK_PERIOD "

# Model output transfer clock
create_generated_clock -name tx_transfer_clk_out -divide_by 1 -add -master_clock tx_transfer_clk \
    -source [get_pin xaibcr3_top_wrp/ohssi_tx_transfer_clk] \
    [get_port o_tx_transfer_clk]

# BCA: Removed because this path is combinational in our design
create_generated_clock -name tx_transfer_div1_clk -divide_by 1 -add -master_clock tx_transfer_clk \
    -source [get_pin xaibcr3_top_wrp/ohssi_tx_transfer_clk] \
    [get_driving_pin [get_pins * -hier -filter "full_name =~ c3aibadapt/adapt_txchnl/txclk_ctl/tcm_clkmux2_tx_fifo_wr_clk_mux1/uu_c3dfx_tcm/o_clk"]]

create_generated_clock -name tx_transfer_div2_clk_m -divide_by 2 -add -master_clock tx_transfer_clk \
    -source [get_pin xaibcr3_top_wrp/ohssi_tx_transfer_clk] \
    [get_pins c3aibadapt/adapt_txchnl/txclk_ctl/tcm_ckdiv2_tx_transfer/CLK_DIV_2.uu_c3dfx_tcm_div2/clk_out]

create_generated_clock -name tx_transfer_div2_clk -divide_by 1 -add -master_clock tx_transfer_div2_clk_m \
    -source [get_pin c3aibadapt/adapt_txchnl/txclk_ctl/tcm_ckdiv2_tx_transfer/CLK_DIV_2.uu_c3dfx_tcm_div2/clk_out] \
    [get_driving_pin [get_pin c3aibadapt/adapt_txchnl/txclk_ctl/tcm_ckdiv2_tx_transfer/o_clk]]

create_generated_clock -name tx_pma_div2_clk_m -divide_by 2 -add -master_clock i_tx_pma_clk \
    -source [get_ports i_tx_pma_clk] \
    [get_pins c3aibadapt/adapt_txchnl/txclk_ctl/tcm_ckdiv2_tx_pma/CLK_DIV_2.uu_c3dfx_tcm_div2/clk_out]

create_generated_clock -name tx_pma_div2_clk -divide_by 1 -add -master_clock tx_pma_div2_clk_m \
    -source [get_pins c3aibadapt/adapt_txchnl/txclk_ctl/tcm_ckdiv2_tx_pma/CLK_DIV_2.uu_c3dfx_tcm_div2/clk_out] \
    [get_driving_pin [get_pin c3aibadapt/adapt_txchnl/txclk_ctl/tcm_ckdiv2_tx_pma/o_clk]]

########################
# Feed-through clocks
########################

#CRSSM Config clock
set clkname i_cfg_avmm_clk
create_clock [get_ports $clkname] -name $clkname -period $CFG_AVMM_CLK_PERIOD

########################
#AVMM Usr clocks
########################
create_generated_clock -name aib_rx_sr_clk_in_avmm1_clk_m -divide_by 8 -add \
  -master_clock i_aib_rx_sr_clk_n \
  -source [get_pin xaibcr3_top_wrp/ohssi_sr_clk_in] \
  [get_pin c3aibadapt/adapt_avmm/avmm1/adapt_avmm1clk_ctl/tcm_ckdiv8_avmm_clock_avmm_clk_int/CLK_DIV_8.uu_c3dfx_tcm_div8/clk_out]

create_generated_clock -name aib_rx_sr_clk_in_avmm1_clk -divide_by 1 -add \
  -master_clock aib_rx_sr_clk_in_avmm1_clk_m \
  -source [get_pin c3aibadapt/adapt_avmm/avmm1/adapt_avmm1clk_ctl/tcm_ckdiv8_avmm_clock_avmm_clk_int/CLK_DIV_8.uu_c3dfx_tcm_div8/clk_out] \
  [get_driving_pin [get_pin c3aibadapt/adapt_avmm/avmm1/adapt_avmm1clk_ctl/tcm_ckdiv8_avmm_clock_avmm_clk_int/o_clk]]

create_generated_clock -name aib_rx_sr_clk_in_div1 -divide_by 1 -add \
  -master_clock i_aib_rx_sr_clk_n  \
  -source [get_pin xaibcr3_top_wrp/ohssi_sr_clk_in] \
  [get_driving_pin [get_pins * -hier -filter "full_name =~ c3aibadapt/adapt_sr/adapt_srclk_ctl/tcm_ckmux2_sr_rx_osc_clk/uu_c3dfx_tcm/o_clk"]]


#### disable all signals crossing clocks.
set all_adpt_clocks [get_object_name [all_clocks]]

# BCA: Removing redundancy constraints
set_clock_groups -asynchronous -name ASYNC_GRP                             \
   -group {i_aib_rx_sr_clk i_aib_rx_sr_clk_n aib_rx_sr_clk_in_avmm1_clk_m aib_rx_sr_clk_in_avmm1_clk aib_rx_sr_clk_in_div1} \
  -group {i_aib_tx_sr_clk aib_tx_sr_clk_in_div1 aib_tx_sr_clk_in_div2_m aib_tx_sr_clk_in_div2 aib_tx_sr_clk_in_div4_m aib_tx_sr_clk_in_div4} \
  -group {i_aib_sclk aib_sclk_div1}                                      \
  -group {tx_transfer_clk tx_transfer_div1_clk tx_transfer_div2_clk_m tx_transfer_div2_clk}       \
  -group i_rx_pma_div2_clk                      \
  -group {i_tx_pma_clk tx_pma_div2_clk_m tx_pma_div2_clk}        \
  -group {i_rx_pma_clk} \
  -group i_cfg_avmm_clk \
  -group i_tx_elane_clk \
  -group i_rx_elane_clk

set_clock_groups -logically_exclusive -group [get_clocks aib_tx_sr_clk_in_div1] -group [get_clocks aib_tx_sr_clk_in_div2]
set_clock_groups -logically_exclusive -group [get_clocks aib_tx_sr_clk_in_div1] -group [get_clocks aib_tx_sr_clk_in_div4]
set_clock_groups -logically_exclusive -group [get_clocks aib_tx_sr_clk_in_div2] -group [get_clocks aib_tx_sr_clk_in_div4]

# internal_clk1 and internal_clk2 select lines

# Chen: For Genus, the Q pin is lowercase on these flops
set sel_q_pins [get_pins -of [get_cells * -hier -filter "is_sequential==true"] \
  -filter "full_name =~ c3aibadapt/adapt_avmm/avmm1/adapt_avmm1_config/adapt_usr_csr/r_dprio3_rx_internal_clk1_sel*/q && pin_direction==out"]

foreach_in_collection q_pin $sel_q_pins {
  set_case_analysis 0 [get_pins $q_pin]
  }

set sel_q_pins [get_pins -of [get_cells * -hier -filter "is_sequential==true"] \
  -filter "full_name =~ c3aibadapt/adapt_avmm/avmm1/adapt_avmm1_config/adapt_usr_csr/r_dprio*_rx_internal_clk2_sel*/q && pin_direction==out"]

foreach_in_collection q_pin $sel_q_pins {
  set_case_analysis 0 [get_pins $q_pin]
  }

# BCA: Additional case analysis must be done to make FIFO mode work properly (i.e., not have excessive hold time constraints applied by the tools)
set_case_analysis 1 [get_pins c3aibadapt/adapt_rxchnl/rxclk_ctl/cmn_clkmux2_rx_fifo_wr_clk3/c3lib_ckmux4_gate/ck_mux_3/sel]

set_case_analysis 0 [get_pins c3aibadapt/adapt_avmm/avmm1/adapt_avmm1_config/adapt_usr_csr/r_dprio3_rx_fifo_wr_clk_sel_reg[2]/q]
set_case_analysis 1 [get_pins c3aibadapt/adapt_avmm/avmm1/adapt_avmm1_config/adapt_usr_csr/r_dprio3_rx_fifo_wr_clk_sel_reg[1]/q]
set_case_analysis 0 [get_pins c3aibadapt/adapt_avmm/avmm1/adapt_avmm1_config/adapt_usr_csr/r_dprio3_rx_fifo_wr_clk_sel_reg[0]/q]

########################
### Timing exceptions
########################

set_false_path -through [get_pin c3aibadapt/adapt_avmm/avmm1/adapt_avmm1_config/adapt_cfg_csr/r_aib_csr*_aib_csr*_ctrl_*_reg*/*] \
-through [get_pin xaibcr3_top_wrp/r_aib_csr_ctrl*]

################

####################
#TEST SDC constraints
########################

# Osc-related clock
create_clock [get_ports i_jtag_clkdr_in] -name tck_jtag_clkdr_in -period $SCAN_CLK_PERIOD

# Create scan clocks when in scan mode
if {$scan_en} {
    #Create scan clock. This clock uses a slower period (250 MHz)

    # Looks like i_scan_clk1, 2, 3, 4 replaced with just i_scan_clk
    create_clock [get_ports i_scan_clk] -name scan_clk -period $SCAN_CLK_PERIOD

    create_clock [get_ports i_test_clk_62m] -name test_clk_62m -period $TEST_CLK_62M_PERIOD
    create_clock [get_ports i_test_clk_125m] -name test_clk_125m -period $TEST_CLK_125M_PERIOD
    create_clock [get_ports i_test_clk_250m] -name test_clk_250m -period $TEST_CLK_250M_PERIOD
    create_clock [get_ports i_test_clk_500m] -name test_clk_500m -period $TEST_CLK_500M_PERIOD
    create_clock [get_ports i_test_clk_1g] -name test_clk_1g -period $TEST_CLK_1G_PERIOD

    ########################
    # SR clock in
    ########################
    # Changed source / master clocks to scan_clk instead of scan_clk4
    create_generated_clock -name aib_rx_sr_clk_in_div1_scan -divide_by 1 -add \
      -master_clock scan_clk  \
      -source [get_ports i_scan_clk] \
      [get_driving_pin [get_pins * -hier -filter "full_name =~ c3aibadapt/adapt_sr/adapt_srclk_ctl/tcm_ckmux2_sr_rx_osc_clk/uu_c3dfx_tcm/o_clk"]]

    create_generated_clock -name aib_rx_sr_clk_in_div1_test -divide_by 1 -add \
      -master_clock test_clk_1g  \
      -source [get_ports i_test_clk_1g] \
      [get_driving_pin [get_pins * -hier -filter "full_name =~ c3aibadapt/adapt_sr/adapt_srclk_ctl/tcm_ckmux2_sr_rx_osc_clk/uu_c3dfx_tcm/o_clk"]]

    create_generated_clock -name aib_tx_sr_clk_in_div2_scan -divide_by 1 -add \
      -master_clock scan_clk  \
      -source [get_ports i_scan_clk] \
      [get_driving_pin [get_pins * -hier -filter "full_name =~ c3aibadapt/adapt_sr/adapt_srclk_ctl/tcm_ckdiv2_sr_tx_sr_clk/o_clk"]]

    create_generated_clock -name aib_tx_sr_clk_in_div2_test -divide_by 1 -add \
      -master_clock test_clk_500m  \
      -source [get_ports i_test_clk_500m] \
      [get_driving_pin [get_pins * -hier -filter "full_name =~ c3aibadapt/adapt_sr/adapt_srclk_ctl/tcm_ckdiv2_sr_tx_sr_clk/o_clk"]]

    create_generated_clock -name aib_tx_sr_clk_in_div4_scan -divide_by 1 -add \
      -master_clock scan_clk  \
      -source [get_ports i_scan_clk] \
      [get_driving_pin [get_pins * -hier -filter "full_name =~ c3aibadapt/adapt_sr/adapt_srclk_ctl/tcm_ckdiv4_sr_tx_sr_clk/o_clk"]]

    create_generated_clock -name aib_tx_sr_clk_in_div4_test -divide_by 1 -add \
      -master_clock test_clk_250m  \
      -source [get_ports i_test_clk_250m] \
      [get_driving_pin [get_pins * -hier -filter "full_name =~ c3aibadapt/adapt_sr/adapt_srclk_ctl/tcm_ckdiv4_sr_tx_sr_clk/o_clk"]]

    create_generated_clock -name aib_tx_sr_clk_in_div1_scan -divide_by 1 -add \
      -master_clock scan_clk  \
      -source [get_ports i_scan_clk] \
      [get_driving_pin [get_pins * -hier -filter "full_name =~ c3aibadapt/adapt_sr/adapt_srclk_ctl/tcm_ckmux2_tx_sr_clk_in/uu_c3dfx_tcm/o_clk"]]

    create_generated_clock -name aib_tx_sr_clk_in_div1_test -divide_by 1 -add \
      -master_clock test_clk_1g  \
      -source [get_ports i_test_clk_1g] \
      [get_driving_pin [get_pins * -hier -filter "full_name =~ c3aibadapt/adapt_sr/adapt_srclk_ctl/tcm_ckmux2_tx_sr_clk_in/uu_c3dfx_tcm/o_clk"]]

    ########################
    # Sampling clock
    ########################
    # Changed source / master clocks to scan_clk instead of scan_clk1
    create_generated_clock -name aib_sclk_div1_scan -divide_by 1 -add \
      -master_clock scan_clk  \
      -source [get_ports i_scan_clk] \
      [get_driving_pin [get_pins * -hier -filter "full_name =~ c3aibadapt/adapt_rxchnl/rxclk_ctl/tcm_ckmux2_rx_fifo_sclk/uu_c3dfx_tcm/o_clk"]]

    create_generated_clock -name aib_sclk_div1_test -divide_by 1 -add \
      -master_clock test_clk_500m  \
      -source [get_ports i_test_clk_500m] \
      [get_driving_pin [get_pins * -hier -filter "full_name =~ c3aibadapt/adapt_rxchnl/rxclk_ctl/tcm_ckmux2_rx_fifo_sclk/uu_c3dfx_tcm/o_clk"]]

    ########################
    # TX clocks
    ########################
    # Changed source / master clocks to scan_clk instead of scan_clk2
    create_generated_clock -name tx_transfer_div1_clk_scan -divide_by 1 -add \
      -master_clock scan_clk  \
      -source [get_ports i_scan_clk] \
      [get_driving_pin [get_pins * -hier -filter "full_name =~ c3aibadapt/adapt_txchnl/txclk_ctl/tcm_clkmux2_tx_fifo_wr_clk_mux1/uu_c3dfx_tcm/o_clk"]]

    create_generated_clock -name tx_transfer_div1_clk_test -divide_by 1 -add \
      -master_clock test_clk_1g  \
      -source [get_ports i_test_clk_1g] \
      [get_driving_pin [get_pins * -hier -filter "full_name =~ c3aibadapt/adapt_txchnl/txclk_ctl/tcm_clkmux2_tx_fifo_wr_clk_mux1/uu_c3dfx_tcm/o_clk"]]

    create_generated_clock -name tx_transfer_div2_clk_scan -divide_by 1 -add \
      -master_clock scan_clk  \
      -source [get_ports i_scan_clk] \
      [get_driving_pin [get_pin c3aibadapt/adapt_txchnl/txclk_ctl/tcm_ckdiv2_tx_transfer/o_clk]]

    create_generated_clock -name tx_transfer_div2_clk_test -divide_by 1 -add \
      -master_clock test_clk_500m  \
      -source [get_ports i_test_clk_500m] \
      [get_driving_pin [get_pin c3aibadapt/adapt_txchnl/txclk_ctl/tcm_ckdiv2_tx_transfer/o_clk]]

    # Changed source / master clocks to scan_clk instead of scan_clk3
    create_generated_clock -name tx_pma_div2_clk_scan -divide_by 1 -add \
      -master_clock scan_clk  \
      -source [get_ports i_scan_clk] \
      [get_driving_pin [get_pin c3aibadapt/adapt_txchnl/txclk_ctl/tcm_ckdiv2_tx_pma/o_clk]]

    create_generated_clock -name tx_pma_div2_clk_test -divide_by 1 -add \
      -master_clock test_clk_500m  \
      -source [get_ports i_test_clk_500m] \
      [get_driving_pin [get_pin c3aibadapt/adapt_txchnl/txclk_ctl/tcm_ckdiv2_tx_pma/o_clk]]

    ########################
    #AVMM Usr clocks
    ########################
    # Changed source / master clocks to scan_clk instead of scan_clk1
    create_generated_clock -name aib_rx_sr_clk_in_avmm1_clk_scan -divide_by 1 -add \
      -master_clock scan_clk  \
      -source [get_ports i_scan_clk] \
      [get_driving_pin [get_pin c3aibadapt/adapt_avmm/avmm1/adapt_avmm1clk_ctl/tcm_ckdiv8_avmm_clock_avmm_clk_int/o_clk]]

    create_generated_clock -name aib_rx_sr_clk_in_avmm1_clk_test -divide_by 1 -add \
      -master_clock test_clk_125m  \
      -source [get_ports i_test_clk_125m] \
      [get_driving_pin [get_pin c3aibadapt/adapt_avmm/avmm1/adapt_avmm1clk_ctl/tcm_ckdiv8_avmm_clock_avmm_clk_int/o_clk]]

    create_clock -add [get_ports i_rx_pma_clk]      -name i_rx_pma_clk_scan_clk      -period $SCAN_CLK_PERIOD
    create_clock -add [get_ports i_cfg_avmm_clk]    -name i_cfg_avmm_clk_scan_clk    -period $SCAN_CLK_PERIOD

    set func_clocks [get_clocks -filter "full_name!~*scan*"]
    set func_clocks [remove_from_collection $func_clocks [get_clocks -filter "full_name=~*tck*"]]
    set only_func_clocks [get_clocks -filter "full_name!~*scan*"]
    set only_func_clocks [remove_from_collection $only_func_clocks [get_clocks -filter "full_name=~*test*"]]
    set only_func_clocks [remove_from_collection $only_func_clocks [get_clocks -filter "full_name=~*tck*"]]

    #
    #Scan clocks
    #
    set all_scan_func_clock [all_clocks]

    set test_clocks [get_clocks -filter "full_name=~*scan*"]
    set test_external [get_clocks -filter "full_name=~*test*"]
    set tck_clocks [get_clocks -filter "full_name=~*tck*"]

    #Both should be same for full scan design
    # Chen: in Genus, the D pin is lowercase
    set d_pins  [get_pins -of [get_cells * -hier -filter "is_sequential==true"] -filter "full_name =~ */d && pin_direction==in"]

    foreach_in_collection scan_clock_name $test_clocks {
        set_false_path -from [get_clocks $scan_clock_name ] -to [get_pins $d_pins]
    }

    get_clocks $func_clocks

    set_clock_groups -asynchronous -name ASYNC_GRP_FUNC_SCAN_TEST_1                             \
      -group [get_clocks $only_func_clocks] \
      -group [get_clocks $test_clocks] \
      -group [get_clocks $tck_clocks] \
      -group [get_clocks $test_external]
}

# These were commentted out previously...why? TODO: Only need to add these in scan mode?
if {$scan_en} {
    set_clock_groups -asynchronous -name excl_scan_clk                         -group {aib_rx_sr_clk_in_avmm1_clk_scan  } \
                                                                               -group {aib_sclk_div1_scan               } \
                                                                               -group {i_cfg_avmm_clk_scan_clk          } \
                                                                               -group {i_rx_pma_clk_scan_clk            tx_transfer_div1_clk_scan   tx_transfer_div2_clk_scan} \
                                                                               -group {tx_pma_div2_clk_scan                                     } \
                                                                               -group {aib_rx_sr_clk_in_div1_scan      aib_tx_sr_clk_in_div1_scan   aib_tx_sr_clk_in_div2_scan  aib_tx_sr_clk_in_div4_scan }

    set_clock_groups -asynchronous -name excl_scan_clk_2                       -group {aib_rx_sr_clk_in_avmm1_clk_scan } \
                                                                               -group {aib_sclk_div1_scan              }


    set_clock_groups -asynchronous -name excl_test_clk                         -group {aib_rx_sr_clk_in_avmm1_clk_test    aib_sclk_div1_test       } \
                                                                               -group {tx_transfer_div1_clk_test} \
                                                                               -group {tx_transfer_div2_clk_test} \
                                                                               -group {tx_pma_div2_clk_test                                        } \
                                                                               -group {aib_tx_sr_clk_in_div1_test     aib_tx_sr_clk_in_div2_test    aib_tx_sr_clk_in_div4_test     } \
                                                                               -group {aib_rx_sr_clk_in_div1_test}

    set_clock_groups -asynchronous -name excl_test_clk_2                       -group {aib_rx_sr_clk_in_avmm1_clk_test } \
                                                                               -group {aib_sclk_div1_test              }

    set_clock_groups -physically_exclusive -name excl_aib_rx_sr_clk_in_div1    -group {aib_rx_sr_clk_in_div1_scan        } \
                                                                               -group {aib_rx_sr_clk_in_div1_test        } \
                                                                               -group {aib_rx_sr_clk_in_div1             }

    set_clock_groups -physically_exclusive -name excl_aib_tx_sr_clk_in_div2    -group {aib_tx_sr_clk_in_div2_scan        } \
                                                                               -group {aib_tx_sr_clk_in_div2_test        } \
                                                                               -group {aib_tx_sr_clk_in_div2             }

    set_clock_groups -physically_exclusive -name excl_aib_tx_sr_clk_in_div4    -group {aib_tx_sr_clk_in_div4_scan        } \
                                                                               -group {aib_tx_sr_clk_in_div4_test        } \
                                                                               -group {aib_tx_sr_clk_in_div4             }

    set_clock_groups -physically_exclusive -name excl_aib_tx_sr_clk_in_div1    -group {aib_tx_sr_clk_in_div1_scan        } \
                                                                               -group {aib_tx_sr_clk_in_div1_test        } \
                                                                               -group {aib_tx_sr_clk_in_div1             }

    set_clock_groups -physically_exclusive -name excl_aib_sclk_div1            -group {aib_sclk_div1_scan        } \
                                                                               -group {aib_sclk_div1_test        } \
                                                                               -group {aib_sclk_div1             }

    set_clock_groups -physically_exclusive -name excl_tx_transfer_div1_clk     -group {tx_transfer_div1_clk_scan        } \
                                                                               -group {tx_transfer_div1_clk_test        } \
                                                                               -group {tx_transfer_div1_clk             }

    set_clock_groups -physically_exclusive -name excl_tx_transfer_div2_clk     -group {tx_transfer_div2_clk_scan        } \
                                                                               -group {tx_transfer_div2_clk_test        } \
                                                                               -group {tx_transfer_div2_clk             }

    set_clock_groups -physically_exclusive -name excl_tx_pma_div2_clk          -group {tx_pma_div2_clk_scan        } \
                                                                               -group {tx_pma_div2_clk_test        } \
                                                                               -group {tx_pma_div2_clk             }

    set_clock_groups -physically_exclusive -name excl_aib_rx_sr_clk_in_avmm_clk -group {aib_rx_sr_clk_in_avmm1_clk_scan        } \
                                                              -group {aib_rx_sr_clk_in_avmm1_clk_test        } \
                                                              -group {aib_rx_sr_clk_in_avmm1_clk             }

    set_clock_groups -logically_exclusive -name excl_sr_clk_scan_1             -group [get_clocks aib_tx_sr_clk_in_div1_scan] \
                                                                               -group [get_clocks aib_tx_sr_clk_in_div2_scan] \
                                                                               -group [get_clocks aib_tx_sr_clk_in_div4_scan]

    set_clock_groups -logically_exclusive -name excl_sr_clk_test_1             -group [get_clocks aib_tx_sr_clk_in_div1_test] \
                                                                               -group [get_clocks aib_tx_sr_clk_in_div2_test] \
                                                                               -group [get_clocks aib_tx_sr_clk_in_div4_test]

set_clock_groups -physically_exclusive -name excl_i_rx_pma_clk_scan_clk       -group [get_clocks i_rx_pma_clk_scan_clk] \
                                                                              -group [get_clocks i_rx_pma_clk]
set_clock_groups -physically_exclusive -name excl_i_cfg_avmm_clk_scan_clk     -group [get_clocks i_cfg_avmm_clk_scan_clk] \
                                                                              -group [get_clocks i_cfg_avmm_clk]
}

if {$scan_en} {
    ####### DFT stop propagation #######

    set_clock_sense -stop_propagation -clocks [get_clocks i_rx_pma_clk_scan_clk]     \
        [get_pins c3aibadapt/adapt_rxchnl/rxclk_ctl/cmn_clkmux4_rx_fifo_rd_clk1/c3lib_ckmux4_gate/ck2]

    # More clocks that don't seem to exist
    set_clock_sense -stop_propagation -clocks [get_clocks tx_transfer_div2_clk_scan] \
        [get_pins c3aibadapt/adapt_txchnl/txclk_ctl/cmn_clkmux4_txfifo_rd_clk/c3lib_ckmux4_gate/ck3]
    set_clock_sense -stop_propagation -clocks [get_clocks tx_transfer_div1_clk_scan] \
        [get_pins c3aibadapt/adapt_rxchnl/rxclk_ctl/cmn_clkmux2_rx_fifo_wr_clk3/c3lib_ckmux4_gate/ck0]
    set_clock_sense -stop_propagation -clocks [get_clocks tx_transfer_div2_clk_scan] \
        [get_pins c3aibadapt/adapt_rxchnl/rxclk_ctl/cmn_clkmux2_rx_fifo_wr_clk3/c3lib_ckmux4_gate/ck1]
}

# Tie these off based on $scan_en
set_case_analysis $scan_en [get_ports i_test_c3adapt_tcb_static_common*]

#####clk gating hold violation(Quoc)######

# BCA: Don't touch nets (AIB ports are directly recreated from lower level)
foreach_in_collection aib_ports [get_ports io_aib*] {
  set_dont_touch [get_nets -segments [get_object_name $aib_ports]]
}
# Prevent buffering of this net that directly connects between PAR2 and PAR3 ports
set_dont_touch [get_nets -segments o_osc_clk]

# Genus changes the logical function of sl_sideband[72] if it is not protected
set_dont_touch sl_sideband[72]

# Each of these used to be tied to uu_c3lib_a16svt16_and2_a4/B, however that doesn't exist in genus. Must tie it to in1 of u_c3lib_and2_svt_4x
set_case_analysis 1 [get_pins c3aibadapt/adapt_rxchnl/rxclk_ctl/cmn_clkand2_rx_async_rx_osc_clk_scg/u_c3lib_and2_svt_4x/in1]
set_case_analysis 1 [get_pins c3aibadapt/adapt_rxchnl/rxclk_ctl/cmn_clkand2_rx_hrdrst_rx_osc_clk_scg/u_c3lib_and2_svt_4x/in1]
set_case_analysis 1 [get_pins c3aibadapt/adapt_rxchnl/rxclk_ctl/cmn_clkand2_rx_fifo_rd_clk_scg/u_c3lib_and2_svt_4x/in1]
set_case_analysis 1 [get_pins c3aibadapt/adapt_rxchnl/rxclk_ctl/cmn_clkand2_rx_async_tx_osc_clk_scg/u_c3lib_and2_svt_4x/in1]
set_case_analysis 1 [get_pins c3aibadapt/adapt_rxchnl/rxclk_ctl/cmn_clkand2_q1_rx_fifo_wr_clk_scg/u_c3lib_and2_svt_4x/in1]
set_case_analysis 1 [get_pins c3aibadapt/adapt_rxchnl/rxclk_ctl/cmn_clkand2_q2_rx_fifo_wr_clk_scg/u_c3lib_and2_svt_4x/in1]
set_case_analysis 1 [get_pins c3aibadapt/adapt_rxchnl/rxclk_ctl/cmn_clkand2_q3_rx_fifo_wr_clk_scg/u_c3lib_and2_svt_4x/in1]
set_case_analysis 1 [get_pins c3aibadapt/adapt_rxchnl/rxclk_ctl/cmn_clkand2_q4_rx_fifo_wr_clk_scg/u_c3lib_and2_svt_4x/in1]
set_case_analysis 1 [get_pins c3aibadapt/adapt_txchnl/txclk_ctl/cmn_clkand2_tx_hrdrst_rx_osc_clk_scg/u_c3lib_and2_svt_4x/in1]
set_case_analysis 1 [get_pins c3aibadapt/adapt_txchnl/txclk_ctl/cmn_clkand2_tx_hip_async_rx_osc_clk_scg/u_c3lib_and2_svt_4x/in1]
set_case_analysis 1 [get_pins c3aibadapt/adapt_txchnl/txclk_ctl/cmn_clkand2_tx_async_rx_osc_clk_scg/u_c3lib_and2_svt_4x/in1]
set_case_analysis 1 [get_pins c3aibadapt/adapt_txchnl/txclk_ctl/cmn_clkand2_tx_async_tx_osc_clk_scg/u_c3lib_and2_svt_4x/in1]
set_case_analysis 1 [get_pins c3aibadapt/adapt_txchnl/txclk_ctl/cmn_clkand2_tx_hip_async_tx_osc_clk_scg/u_c3lib_and2_svt_4x/in1]
set_case_analysis 1 [get_pins c3aibadapt/adapt_txchnl/txclk_ctl/cmn_clkand2_tx_fifo_rd_clk_scg/u_c3lib_and2_svt_4x/in1]
set_case_analysis 1 [get_pins c3aibadapt/adapt_txchnl/txclk_ctl/cmn_clkand2_q2_tx_fifo_wr_clk_scg/u_c3lib_and2_svt_4x/in1]
set_case_analysis 1 [get_pins c3aibadapt/adapt_txchnl/txclk_ctl/cmn_clkand2_q1_tx_fifo_wr_clk_scg/u_c3lib_and2_svt_4x/in1]
set_case_analysis 1 [get_pins c3aibadapt/adapt_txchnl/txclk_ctl/cmn_clkand2_q4_tx_fifo_wr_clk_scg/u_c3lib_and2_svt_4x/in1]
set_case_analysis 1 [get_pins c3aibadapt/adapt_txchnl/txclk_ctl/cmn_clkand2_q3_tx_fifo_wr_clk_scg/u_c3lib_and2_svt_4x/in1]
set_case_analysis 1 [get_pins c3aibadapt/adapt_avmm/avmm2/adapt_avmm2clk_ctl/ckand2_avmm_avmm_clk_scg/u_c3lib_and2_svt_4x/in1]
set_case_analysis 1 [get_pins c3aibadapt/adapt_avmm/avmm2/adapt_avmm2clk_ctl/ckand2_avmm_rx_osc_clk_scg/u_c3lib_and2_svt_4x/in1]
set_case_analysis 1 [get_pins c3aibadapt/adapt_avmm/avmm2/adapt_avmm2clk_ctl/ckand2_avmm_tx_osc_clk_scg/u_c3lib_and2_svt_4x/in1]
set_case_analysis 1 [get_pins c3aibadapt/adapt_avmm/avmm1/adapt_avmm1clk_ctl/ckand2_avmm_hrdrst_tx_osc_clk_scg/u_c3lib_and2_svt_4x/in1]
set_case_analysis 1 [get_pins c3aibadapt/adapt_avmm/avmm1/adapt_avmm1clk_ctl/ckand2_avmm_tx_osc_clk_scg/u_c3lib_and2_svt_4x/in1]
set_case_analysis 1 [get_pins c3aibadapt/adapt_avmm/avmm1/adapt_avmm1clk_ctl/ckand2_avmm_rx_osc_clk_scg/u_c3lib_and2_svt_4x/in1]
set_case_analysis 1 [get_pins c3aibadapt/adapt_avmm/hrdrst_clkctl/ckand2_avmm_hrdrst_rx_osc_clk_scg/u_c3lib_and2_svt_4x/in1]
set_case_analysis 1 [get_pins c3aibadapt/adapt_avmm/hrdrst_clkctl/ckand2_avmm_hrdrst_tx_osc_clk_scg/u_c3lib_and2_svt_4x/in1]
set_case_analysis 1 [get_pins c3aibadapt/adapt_sr/adapt_srclk_ctl/ckand2_sr_rx_osc_clk_scg/u_c3lib_and2_svt_4x/in1]
set_case_analysis 1 [get_pins c3aibadapt/adapt_sr/adapt_srclk_ctl/ckand2_sr_tx_osc_clk_scg/u_c3lib_and2_svt_4x/in1]
set_case_analysis 0 [get_pins c3aibadapt/i_aib_shared_direct_async*]
set_case_analysis 0 [get_pins c3aibadapt/adapt_avmm/avmm1/adapt_avmm1_config/adapt_cfg_csr/r_ifctl_hwcfg_adpt_en_reg/Q]
set_case_analysis 0 [get_pins c3aibadapt/adapt_avmm/avmm1/adapt_avmm1_config/adapt_cfg_csr/r_ifctl_hwcfg_aib_en_reg/Q]

# Some false path stuff
set_false_path -through [get_pins xaibcr3_top_wrp/oaibdftdll2adjch[*]]
set_false_path -through [get_pins xaibcr3_top_wrp/iaibdftdll2adjch[*]]
set_false_path -through [get_pins xaibcr3_top_wrp/oaibdftdll2core[*]]
set_false_path -through [get_pins xaibcr3_top_wrp/iaibdftcore2dll[*]]
set_false_path -through [get_pins xaibcr3_top_wrp/ishared_direct_async_in[*]]
set_false_path -through [get_pins xaibcr3_top_wrp/oshared_direct_async_out[*]]

# More false path stuff
set_false_path -through [get_pins xaibcr3_top_wrp/ohssi_pld_pma_rxpma_rstb]
set_false_path -through [get_pins xaibcr3_top_wrp/ohssi_pld_pma_txpma_rstb]
set_false_path -through [get_pins xaibcr3_top_wrp/ohssi_pcs_rx_pld_rst_n]
set_false_path -through [get_pins xaibcr3_top_wrp/ohssi_pcs_tx_pld_rst_n]
set_false_path -through xaibcr3_top_wrp/ohssi_adapter_rx_pld_rst_n
set_false_path -through xaibcr3_top_wrp/ohssi_adapter_tx_pld_rst_n
set_false_path -hold -through  [get_ports {i_adpt_hard_rst_n}]

#set_false_path on scan_en , scan_reset , scan_mode
set_false_path -from [get_ports i_test_c3adapt_tcb_static_common*]
set_false_path -from [get_ports i_jtag_intest_in]

# BCA: False path created by a timing constraint on PAR2 AIB port
set_false_path -from io_aib43 -to xaibcr3_top_wrp/aib43
set_false_path -from io_aib42 -to xaibcr3_top_wrp/aib42

# Looked at c3aibadapt_top_wrp, channel ID is a constant!
set_false_path -through  [get_ports i_channel_id*]

# Not sure what these do...
set_input_delay -clock [get_clocks i_cfg_avmm_clk] -add_delay -min 2.0 [get_ports {i_test_c3adapt_scan_in[1]}]
set_input_delay -clock [get_clocks i_rx_pma_clk] -add_delay -min 2.0 [get_ports {i_test_c3adapt_scan_in[8]}]
set_false_path -hold -through  [get_ports {i_test_c3adapt_scan_in[*]}]

# BCA: Phasecomp IO delays
set_input_delay -clock [get_clocks i_rx_elane_clk] -add_delay -max [expr $RX_HR_WORD_CLK_PERIOD * 0.8] [get_ports i_rx_elane_data*]
set_input_delay -clock [get_clocks i_rx_elane_clk] -add_delay -min 0 [get_ports i_rx_elane_data*]

set_output_delay -clock [get_clocks i_tx_elane_clk] -add_delay -max [expr $TX_HR_WORD_CLK_PERIOD * 0.8] [get_ports o_tx_elane_data*]
set_output_delay -clock [get_clocks i_tx_elane_clk] -add_delay -min 0 [get_ports o_tx_elane_data*]

# Input/output delays on cfg_avmm* ports
set_input_delay -clock [get_clocks i_cfg_avmm_clk] -add_delay -max [expr $CFG_AVMM_CLK_PERIOD/2] [get_ports i_cfg_avmm*]
set_input_delay -clock [get_clocks i_cfg_avmm_clk] -add_delay -min 0 [get_ports i_cfg_avmm*]

set_output_delay -clock [get_clocks i_cfg_avmm_clk] -add_delay -max [expr $CFG_AVMM_CLK_PERIOD/2] [get_ports o_cfg_avmm*]
set_output_delay -clock [get_clocks i_cfg_avmm_clk] -add_delay -min 0 [get_ports o_cfg_avmm*]

# Contrain max from input AVMM to output AVMM direct feedthrough ports to 200ps
# Direction of the clock propagation, need to set min and max
set_max_delay [expr $CFG_AVMM_CLK_PERIOD/2 + 0.45] -from [get_ports i_cfg_avmm*] -to [get_ports o_adpt_cfg*]
set_min_delay 0.05 -from [get_ports i_cfg_avmm*] -to [get_ports o_adpt_cfg*]
# Opposite direction of the clock propagation, just set the max to be as small as possible
# BCA: Relaxed this by 100ps since we only have 2 channels in series.
set_max_delay [expr $CFG_AVMM_CLK_PERIOD/2 + 0.2] -from [get_ports i_adpt_cfg*] -to [get_ports o_cfg_avmm*]

# Input / output data
set_input_delay -clock [get_clocks i_rx_pma_clk] -add_delay -max        [expr $RX_FR_WORD_CLK_PERIOD/2] [get_ports i_rx_pma_data[*]]
set_input_delay -clock [get_clocks i_rx_pma_clk] -add_delay -min        [expr $RX_FR_WORD_CLK_PERIOD/2] [get_ports i_rx_pma_data[*]]

set_output_delay -clock [get_clocks tx_transfer_clk_out] -add_delay -max    [expr $TX_FR_WORD_CLK_PERIOD/2] [get_ports o_tx_pma_data[*]]
set_output_delay -clock [get_clocks tx_transfer_clk_out] -add_delay -min    [expr $TX_FR_WORD_CLK_PERIOD/2] [get_ports o_tx_pma_data[*]]

# SSR registers
set_input_delay -clock [get_clocks i_aib_tx_sr_clk] -add_delay -max [expr $AIB_OSC_PERIOD/4] [get_ports i_chnl_ssr[*]]
set_input_delay -clock [get_clocks i_aib_tx_sr_clk] -add_delay -min [expr $AIB_OSC_PERIOD/4] [get_ports i_chnl_ssr[*]]

set_output_delay -clock [get_clocks i_aib_rx_sr_clk] -add_delay -max [expr $AIB_OSC_PERIOD/4] [get_ports o_chnl_ssr[*]]
set_output_delay -clock [get_clocks i_aib_rx_sr_clk] -add_delay -min [expr $AIB_OSC_PERIOD/4] [get_ports o_chnl_ssr[*]]

set_multicycle_path -setup 3 -to [get_ports o_chnl_ssr[*]]
set_false_path -to [get_ports o_chnl_ssr[*]]

# BCA: These are asynchronous, essentially DC signals, so just make sure they have a constraint.
set_max_delay 1.0 -to [get_ports sl_sideband*]
set_max_delay 1.0 -to [get_ports ms_sideband*]

########################
### Set clock uncertainty
########################

set_clock_uncertainty $clk_uncertainty [get_clocks]

#-----------------------------------------------------------------------------
# DRV constraints
#-----------------------------------------------------------------------------
set_input_transition -min 0.001 [all_inputs]
set_input_transition -max 0.100 [all_inputs]

set_input_transition -min 0.001 [all_inputs]
set_input_transition -max 0.100 [all_inputs]

set_max_transition 0.100 [all_inputs]
set_max_capacitance 0.010 [all_inputs]
# Set defaults for signals we care less about to be a lot higher
set_max_capacitance 0.30 [concat [get_ports i_jtag_*] [get_ports i_aibdftdll2adjch[*]]]
set_max_transition 0.100 [concat [get_ports i_jtag_*] [get_ports i_aibdftdll2adjch[*]]]

# Make sure all output transitions are < 40 ps given a pin load of 20 fF
set_max_transition 0.100 [all_outputs]
set_load -pin_load 0.020 [all_outputs]
# Non critical outputs transitions
set_max_transition 0.100 [concat [get_ports o_jtag_*] [get_ports o_aibdftdll2adjch[*]]]

