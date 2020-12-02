# SPDX-License-Identifier: Apache-2.0
# Copyright 2019 Blue Cheetah Analog Design, Inc.

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#=============================================================================
## Copyright (c) 2017 Ayar Labs, Inc.
## All Rights Reserved.
##
## Notice: All information contained herein is, and remains the the property
## of Ayar Labs, Inc.
##
## The information contained herein is confidential and proprietary information
## of Ayar Labs, Inc. and its licensors, if any, and is subject to applicable
## non-disclosure agreement with Ayar Labs, Inc. Dissemination of information,
## use of this material, or reproduction of this material is strictly forbidden
## unless prior written permission is obtained from Ayar Labs, Inc.
##
## THESE MATERIALS ARE PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
## OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF
## MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, TITLE OR NONINFRINGEMENT,
## ALL OF WHICH ARE SPECIFICALLY DISCLAIMED. IN NO EVENT WILL AYAR LABS, INC.
## BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
## CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH
## THESE MATERIALS OR THE USE THEREOF.
##
## This notice shall be included in its entirety on all copies made from this
## file
##
##=============================================================================


##################### CHECK for DC shell or Fishtail ##########################

#-----------------------------------------------------------------------------
# Set Units
#-----------------------------------------------------------------------------
set_units -capacitance 1.0pF
set_units -time 1.0ns

#-----------------------------------------------------------------------------
# Variables
#-----------------------------------------------------------------------------
# Cycling through modes only Base constraints, no changes to the constraints yet; Need more info

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
set jtag_clk_period     33.33
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
# AVMM clock at 125MHz
set CFG_AVMM_CLK_PERIOD     [expr $clk_period * 8.0]
#####
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
create_clock [get_ports io_aib85] -name i_aib_rx_sr_clk -period $AIB_OSC_PERIOD
# BCA: We need to make sure that the aibcr3_buffx1_top lib includes arcs from iclkn to oclkb_out in order
# to support the below statement, especially if we are deleting generated clocks from within the libs.
create_clock [get_ports io_aib84] -name i_aib_rx_sr_clk_n -period $AIB_OSC_PERIOD \
    -waveform " [expr $AIB_OSC_PERIOD/2] $AIB_OSC_PERIOD "

create_generated_clock -name aib_tx_sr_clk_in_div1 -divide_by 1 \
  -source [get_pin aib_iotop_wrp/xaibcr3_top_wrp/osc_clkin] \
  [get_pin aib_iotop_wrp/xaibcr3_top_wrp/ohssi_tx_sr_clk_in]

########################
# Sampling clock
########################
    # BCA: Removing redundancy constraints
    # create_clock [get_ports io_aib48] -name i_aib_sclk_r -period $SCLK_PERIOD
    create_clock [get_ports io_aib76] -name i_aib_sclk -period $SCLK_PERIOD

########################
# Half-rate clocks
########################

set clkname m_ns_fwd_div2_clk
create_clock [get_ports $clkname] -name $clkname -period $RX_HR_WORD_CLK_PERIOD



########################
# Full-rate clocks
########################
# BCA: Phase comp clocks are half-rate
set clkname m_wr_clk
create_clock [get_ports $clkname] -name $clkname -period $RX_FR_WORD_CLK_PERIOD
set clkname m_rd_clk
create_clock [get_ports $clkname] -name $clkname -period $TX_FR_WORD_CLK_PERIOD

set clkname m_ns_fwd_clk
create_clock [get_ports $clkname] -name $clkname -period $RX_FR_WORD_CLK_PERIOD

set clkname m_ns_rcv_clk
create_clock [get_ports $clkname] -name $clkname -period $RX_FR_WORD_CLK_PERIOD

########################
# TX clocks (AIB2ADAPT clocks)
########################
# Create different clock sources (because of where this comes from...)
# BCA: Removing redundancy constraints
# create_clock [get_ports io_aib30] -name tx_transfer_clk_r -period $TX_FR_WORD_CLK_PERIOD
create_clock [get_ports io_aib41] -name tx_transfer_clk -period $TX_FR_WORD_CLK_PERIOD
create_clock [get_ports io_aib40] -name tx_transfer_clk_n -period $TX_FR_WORD_CLK_PERIOD \
   -waveform " [expr $TX_FR_WORD_CLK_PERIOD/2] $TX_FR_WORD_CLK_PERIOD "

##Additional Clocks
create_clock [get_ports io_aib87] -name pma_core_clkin -period $TX_FR_WORD_CLK_PERIOD
create_clock [get_ports io_aib86] -name pma_core_clkin_n -period $TX_FR_WORD_CLK_PERIOD \
   -waveform " [expr $TX_FR_WORD_CLK_PERIOD/2] $TX_FR_WORD_CLK_PERIOD "

create_generated_clock -name tx_transfer_div1_clk -divide_by 1 \
    -source /designs/aib_slv/instances_hier/aib_iotop_wrp/instances_seq/xaibcr3_top_wrp/pins_in/aib43 \
    [get_pin aib_iotop_wrp/xaibcr3_top_wrp/ohssi_tx_transfer_clk]

create_generated_clock -name tx_transfer_div2_clk -divide_by 2 \
    -source [get_pin aib_adapt/fs_fwd_clk] \
    [get_driving_pin [get_pin aib_adapt/m_fs_fwd_div2_clk]]

########################
# Feed-through clocks
########################

#CRSSM Config clock
set clkname i_cfg_avmm_clk
create_clock [get_ports $clkname] -name $clkname -period $CFG_AVMM_CLK_PERIOD

########################
#AVMM Usr clocks
########################
create_generated_clock -name aib_rx_sr_clk_in_avmm1_clk_m -divide_by 8 \
  -source [get_pin aib_adapt/aib_adapt_avmm/avmm1/adapt_avmm1clk_ctl/tcm_ckdiv8_avmm_clock_avmm_clk_int/CLK_DIV_8.uu_c3dfx_tcm_div8/clk_in] \
  [get_pin aib_adapt/aib_adapt_avmm/avmm1/adapt_avmm1clk_ctl/tcm_ckdiv8_avmm_clock_avmm_clk_int/CLK_DIV_8.uu_c3dfx_tcm_div8/clk_out]

create_generated_clock -name aib_rx_sr_clk_in_avmm1_clk -divide_by 1 -add \
  -master_clock aib_rx_sr_clk_in_avmm1_clk_m \
  -source [get_pin aib_adapt/aib_adapt_avmm/avmm1/adapt_avmm1clk_ctl/tcm_ckdiv8_avmm_clock_avmm_clk_int/CLK_DIV_8.uu_c3dfx_tcm_div8/clk_out] \
  [get_driving_pin [get_pin aib_adapt/aib_adapt_avmm/avmm1/adapt_avmm1clk_ctl/tcm_ckdiv8_avmm_clock_avmm_clk_int/o_clk]]

create_generated_clock -name aib_rx_sr_clk_in_div1 -divide_by 1 \
  -source /designs/aib_slv/instances_hier/aib_iotop_wrp/instances_seq/xaibcr3_top_wrp/pins_in/aib82 \
  [get_pin aib_iotop_wrp/xaibcr3_top_wrp/ohssi_sr_clk_in]


#### disable all signals crossing clocks.
set all_adpt_clocks [get_object_name [all_clocks]]

# BCA: Removing redundancy constraints
#########################
#Clock Grouping
#########################
set_clock_groups -asynchronous -name ASYNC_GRP                             \
   -group {i_aib_rx_sr_clk i_aib_rx_sr_clk_n aib_rx_sr_clk_in_avmm1_clk_m aib_rx_sr_clk_in_avmm1_clk aib_rx_sr_clk_in_div1} \
  -group {i_aib_tx_sr_clk aib_tx_sr_clk_in_div1}                                      \
  -group i_aib_sclk                                       \
  -group {tx_transfer_clk tx_transfer_div1_clk tx_transfer_div2_clk} \
  -group {m_ns_fwd_clk m_ns_fwd_div2_clk} \
  -group i_cfg_avmm_clk \
  -group m_rd_clk \
  -group m_wr_clk
#########################

# internal_clk1 and internal_clk2 select lines

# Chen: For Genus, the Q pin is lowercase on these flops
set sel_q_pins [get_pins -of [get_cells * -hier -filter "is_sequential==true"] \
  -filter "full_name =~ aib_adapt/aib_adapt_avmm/avmm1/adapt_avmm1_config/adapt_usr_csr/r_dprio3_rx_internal_clk1_sel*/q && pin_direction==out"]

foreach_in_collection q_pin $sel_q_pins {
  set_case_analysis 0 [get_pins $q_pin]
  }

set sel_q_pins [get_pins -of [get_cells * -hier -filter "is_sequential==true"] \
  -filter "full_name =~ aib_adapt/aib_adapt_avmm/avmm1/adapt_avmm1_config/adapt_usr_csr/r_dprio*_rx_internal_clk2_sel*/q && pin_direction==out"]

foreach_in_collection q_pin $sel_q_pins {
  set_case_analysis 0 [get_pins $q_pin]
  }

# BCA: Additional case analysis must be done to make FIFO mode work properly (i.e., not have excessive hold time constraints applied by the tools)
set_case_analysis 0 [get_pins aib_adapt/aib_adapt_avmm/avmm1/adapt_avmm1_config/adapt_usr_csr/r_dprio3_rx_fifo_wr_clk_sel_reg[2]/q]
set_case_analysis 1 [get_pins aib_adapt/aib_adapt_avmm/avmm1/adapt_avmm1_config/adapt_usr_csr/r_dprio3_rx_fifo_wr_clk_sel_reg[1]/q]
set_case_analysis 0 [get_pins aib_adapt/aib_adapt_avmm/avmm1/adapt_avmm1_config/adapt_usr_csr/r_dprio3_rx_fifo_wr_clk_sel_reg[0]/q]

########################
### Timing exceptions
########################

set_false_path -through [get_pin aib_adapt/aib_adapt_avmm/avmm1/adapt_avmm1_config/adapt_cfg_csr/r_aib_csr*_aib_csr*_ctrl_*_reg*/*] \
-through [get_pin aib_iotop_wrp/xaibcr3_top_wrp/r_aib_csr_ctrl*]

# These are tied to 0 at the level above aib_slv
set_false_path -from [get_ports sl_external_cntl_*]
set_false_path -from [get_ports ms_external_cntl_*]

# Asynchronous inputs. Don't do hold fixing
set_false_path -hold -from [get_ports ms_tx_dcc_dll_lock_req]
set_false_path -hold -from [get_ports ms_rx_dcc_dll_lock_req]

# This is a static signal. It will be tied hi or low at the macro instantiation level.
set_false_path -from [get_ports dual_mode_select]

################

####################
#TEST SDC constraints
########################

# Osc-related clock
create_clock [get_ports i_jtag_clkdr_in] -name tck_jtag_clkdr_in -period $jtag_clk_period

# Create scan clocks when in scan mode
if {$scan_en} {
    #Create scan clock. This clock uses a slower period (250 MHz)

    # Looks like i_scan_clk1, 2, 3, 4 replaced with just i_scan_clk
    create_clock [get_ports i_scan_clk] -name scan_clk -period $SCAN_CLK_PERIOD
    create_clock [get_ports scan_clk] -name DFT_scan_clk -period $SCAN_CLK_PERIOD 

    create_clock [get_ports i_test_clk_62m] -name test_clk_62m -period $TEST_CLK_62M_PERIOD
    create_clock [get_ports i_test_clk_125m] -name test_clk_125m -period $TEST_CLK_125M_PERIOD
    create_clock [get_ports i_test_clk_250m] -name test_clk_250m -period $TEST_CLK_250M_PERIOD
    create_clock [get_ports i_test_clk_500m] -name test_clk_500m -period $TEST_CLK_500M_PERIOD
    create_clock [get_ports i_test_clk_1g] -name test_clk_1g -period $TEST_CLK_1G_PERIOD

    ########################
    #AVMM Usr clocks
    ########################
    # Changed source / master clocks to scan_clk instead of scan_clk1
    create_generated_clock -name aib_rx_sr_clk_in_avmm1_clk_scan -divide_by 1 -add \
      -master_clock scan_clk  \
      -source [get_ports i_scan_clk] \
      [get_driving_pin [get_pin aib_adapt/aib_adapt_avmm/avmm1/adapt_avmm1clk_ctl/tcm_ckdiv8_avmm_clock_avmm_clk_int/o_clk]]

    create_generated_clock -name aib_rx_sr_clk_in_avmm1_clk_test -divide_by 1 -add \
      -master_clock test_clk_125m  \
      -source [get_ports i_test_clk_125m] \
      [get_driving_pin [get_pin aib_adapt/aib_adapt_avmm/avmm1/adapt_avmm1clk_ctl/tcm_ckdiv8_avmm_clock_avmm_clk_int/o_clk]]

    create_clock -add [get_ports m_ns_fwd_clk]      -name i_rx_pma_clk_scan_clk      -period $SCAN_CLK_PERIOD
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
                                                                               -group {i_cfg_avmm_clk_scan_clk          } \
                                                                               -group {tx_pma_div2_clk_scan             } 

     
    set_clock_groups -physically_exclusive -name excl_aib_rx_sr_clk_in_avmm_clk -group {aib_rx_sr_clk_in_avmm1_clk_scan} \
                                                              -group aib_rx_sr_clk_in_avmm1_clk_test     \
                                                              -group aib_rx_sr_clk_in_avmm1_clk  

    
set_clock_groups -physically_exclusive -name excl_i_rx_pma_clk_scan_clk       -group [get_clocks i_rx_pma_clk_scan_clk] \
                                                                              -group [get_clocks m_ns_fwd_clk]
set_clock_groups -physically_exclusive -name excl_i_cfg_avmm_clk_scan_clk     -group [get_clocks i_cfg_avmm_clk_scan_clk] \
                                                                              -group [get_clocks i_cfg_avmm_clk]
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
set_dont_touch [get_nets -segments i_por_aib_vccl]

# Genus changes the logical function of sl_sideband[72] if it is not protected
set_dont_touch sl_sideband[72]

# Each of these used to be tied to uu_c3lib_a16svt16_and2_a4/B, however that doesn't exist in genus. Must tie it to in1 of u_c3lib_and2_svt_4x
set_case_analysis 0 [get_pins aib_adapt/aib_adapt_avmm/avmm1/adapt_avmm1_config/adapt_cfg_csr/r_ifctl_hwcfg_adpt_en_reg/Q]
set_case_analysis 0 [get_pins aib_adapt/aib_adapt_avmm/avmm1/adapt_avmm1_config/adapt_cfg_csr/r_ifctl_hwcfg_aib_en_reg/Q]

# Some false path stuff
set_false_path -through [get_pins aib_iotop_wrp/xaibcr3_top_wrp/oaibdftdll2adjch[*]]
set_false_path -through [get_pins aib_iotop_wrp/xaibcr3_top_wrp/iaibdftdll2adjch[*]]
set_false_path -through [get_pins aib_iotop_wrp/xaibcr3_top_wrp/oaibdftdll2core[*]]
set_false_path -through [get_pins aib_iotop_wrp/xaibcr3_top_wrp/iaibdftcore2dll[*]]
set_false_path -through [get_pins aib_iotop_wrp/xaibcr3_top_wrp/ishared_direct_async_in[*]]
set_false_path -through [get_pins aib_iotop_wrp/xaibcr3_top_wrp/oshared_direct_async_out[*]]

# More false path stuff
set_false_path -through [get_pins aib_iotop_wrp/xaibcr3_top_wrp/ohssi_pld_pma_rxpma_rstb]
set_false_path -through [get_pins aib_iotop_wrp/xaibcr3_top_wrp/ohssi_pld_pma_txpma_rstb]
set_false_path -through [get_pins aib_iotop_wrp/xaibcr3_top_wrp/ohssi_pcs_rx_pld_rst_n]
set_false_path -through [get_pins aib_iotop_wrp/xaibcr3_top_wrp/ohssi_pcs_tx_pld_rst_n]
set_false_path -through aib_iotop_wrp/xaibcr3_top_wrp/ohssi_adapter_rx_pld_rst_n
set_false_path -through aib_iotop_wrp/xaibcr3_top_wrp/ohssi_adapter_tx_pld_rst_n
set_false_path -hold -through  [get_ports {conf_done}]

#set_false_path on scan_en , scan_reset , scan_mode
set_false_path -from [get_ports i_test_c3adapt_tcb_static_common*]
set_false_path -from [get_ports i_jtag_intest_in]

# BCA: False path created by a timing constraint on PAR2 AIB port
set_false_path -from io_aib41 -to aib_iotop_wrp/xaibcr3_top_wrp/aib43
set_false_path -from io_aib40 -to aib_iotop_wrp/xaibcr3_top_wrp/aib42

# Looked at c3aibadapt_top_wrp, channel ID is a constant!
set_false_path -through  [get_ports i_channel_id*]

# Not sure what these do...
set_input_delay -clock [get_clocks i_cfg_avmm_clk] -add_delay -min 2.0 [get_ports {i_test_c3adapt_scan_in[1]}]
set_input_delay -clock [get_clocks m_ns_fwd_clk] -add_delay -min 2.0 [get_ports {i_test_c3adapt_scan_in[8]}]
set_false_path -hold -through  [get_ports {i_test_c3adapt_scan_in[*]}]

########################################
# Input & Output Delays
########################################
# Intel spec is 800ps of external delay
set external_delay 0.8
set external_delay_out 0.7

# BCA: Phasecomp IO delays
set_input_delay -clock [get_clocks m_wr_clk] -add_delay -max $external_delay [get_ports data_in*]
set_input_delay -clock [get_clocks m_wr_clk] -add_delay -min [expr $RX_FR_WORD_CLK_PERIOD * 0.1] [get_ports data_in*]

set_output_delay -clock [get_clocks m_rd_clk] -add_delay -max $external_delay_out [get_ports data_out*]
set_output_delay -clock [get_clocks m_rd_clk] -add_delay -min 0 [get_ports data_out*]

# Input/output delays on cfg_avmm* ports
set_input_delay -clock [get_clocks i_cfg_avmm_clk] -add_delay -max [expr $CFG_AVMM_CLK_PERIOD/2] [get_ports i_cfg_avmm*]
set_input_delay -clock [get_clocks i_cfg_avmm_clk] -add_delay -min 0 [get_ports i_cfg_avmm*]

set_output_delay -clock [get_clocks i_cfg_avmm_clk] -add_delay -max [expr $CFG_AVMM_CLK_PERIOD/2] [get_ports o_cfg_avmm*]
set_output_delay -clock [get_clocks i_cfg_avmm_clk] -add_delay -min 0 [get_ports o_cfg_avmm*]


# Jtag IO delays
set_input_delay -clock [get_clocks tck_jtag_clkdr_in] -add_delay -max $external_delay [get_ports {i_jtag_bs_chain_in i_jtag_bs_scanen_in i_jtag_weakpdn_in i_jtag_weakpu_in i_jtag_mode_in i_jtag_intest_in i_jtag_clksel_in}]
set_input_delay -clock [get_clocks tck_jtag_clkdr_in] -add_delay -min 0 [get_ports {i_jtag_bs_chain_in i_jtag_bs_scanen_in i_jtag_weakpdn_in i_jtag_weakpu_in i_jtag_mode_in i_jtag_intest_in i_jtag_clksel_in}]

set_output_delay -clock [get_clocks tck_jtag_clkdr_in] -add_delay -max $external_delay [get_ports o_jtag_last_bs_chain_out]
set_output_delay -clock [get_clocks tck_jtag_clkdr_in] -add_delay -min 0 [get_ports o_jtag_last_bs_chain_out]

# Contrain max from input AVMM to output AVMM direct feedthrough ports to 200ps
# Direction of the clock propagation, need to set min and max
#set_max_delay [expr $CFG_AVMM_CLK_PERIOD/2 + 0.45] -from [get_ports i_cfg_avmm*] -to [get_ports o_adpt_cfg*]
set_max_delay [expr $CFG_AVMM_CLK_PERIOD/2 + 0.15] -from [get_ports i_cfg_avmm*] -to [get_ports o_adpt_cfg*]
set_min_delay 0.05 -from [get_ports i_cfg_avmm*] -to [get_ports o_adpt_cfg*]
# Opposite direction of the clock propagation, just set the max to be as small as possible
# BCA: Relaxed this by 100ps since we only have 2 channels in series.
#set_max_delay [expr $CFG_AVMM_CLK_PERIOD/2 + 0.2] -from [get_ports i_adpt_cfg*] \
    -to [get_ports o_cfg_avmm*]
set_max_delay [expr $CFG_AVMM_CLK_PERIOD/2 + 0.15] -from [get_ports i_adpt_cfg*] \
    -to [get_ports o_cfg_avmm*]

# Input / output data

# BCA: These are asynchronous, essentially DC signals, so just make sure they have a constraint.
set_max_delay 1.0 -to [get_ports sl_sideband*]
set_max_delay 1.0 -to [get_ports ms_sideband*]
set_max_delay 2.5 -from [get_ports sl_tx_dcc_dll_lock_req]
set_max_delay 1.0 -from [get_ports ms_tx_dcc_dll_lock_req]
set_max_delay 2.5 -from [get_ports sl_rx_dcc_dll_lock_req]
set_max_delay 1.0 -from [get_ports ms_rx_dcc_dll_lock_req]

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
set_max_capacitance 0.30 [concat [get_ports i_jtag_*]]
set_max_transition 0.100 [concat [get_ports i_jtag_*]]

# Make sure all output transitions are < 40 ps given a pin load of 20 fF
set_max_transition 0.100 [all_outputs]
set_load -pin_load 0.020 [all_outputs]
# Non critical outputs transitions
set_max_transition 0.100 [concat [get_ports o_jtag_*]]

