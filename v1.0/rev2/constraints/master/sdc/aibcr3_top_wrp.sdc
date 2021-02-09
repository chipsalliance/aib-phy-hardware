# SPDX-License-Identifier: Apache-2.0
# Copyright 2019 Blue Cheetah Analog Design, Inc.

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set aib_map(aib46) [list aib46 q1 r0 11 t 0 aib61 true xaibcr3_top/xtxdatapath_tx/xdirect_out1]
set aib_map(aib0) [list aib0 q1 r0 10 t 2 aib46 true xaibcr3_top/xrxdatapath_rx/xpoutp0]
set aib_map(aib2) [list aib2 q1 r0 9 t 4 aib0 true xaibcr3_top/xrxdatapath_rx/xpoutp2]
set aib_map(aib4) [list aib4 q1 r0 8 t 6 aib2 true xaibcr3_top/xrxdatapath_rx/xpoutp4]
set aib_map(aib6) [list aib6 q1 r0 7 t 8 aib4 true xaibcr3_top/xrxdatapath_rx/xpoutp6]
set aib_map(aib8) [list aib8 q1 r0 6 t 10 aib6 true xaibcr3_top/xrxdatapath_rx/xpoutp8]
set aib_map(aib41) [list aib41 q1 r0 5 b 12 aib8 true xaibcr3_top/xrxdatapath_rx/xrx_clkp]
set aib_map(aib10) [list aib10 q1 r0 4 b 14 aib41 true xaibcr3_top/xrxdatapath_rx/xpoutp10]
set aib_map(aib12) [list aib12 q1 r0 3 b 16 aib10 true xaibcr3_top/xrxdatapath_rx/xpoutp12]
set aib_map(aib14) [list aib14 q1 r0 2 b 18 aib12 true xaibcr3_top/xrxdatapath_rx/xpoutp14]
set aib_map(aib16) [list aib16 q1 r0 1 b 20 aib14 true xaibcr3_top/xrxdatapath_rx/xpoutp16]
set aib_map(aib18) [list aib18 q1 r0 0 b 22 aib16 true xaibcr3_top/xrxdatapath_rx/xpoutp18]
set aib_map(aib44) [list aib44 q2 r0 0 b 24 aib18 false xaibcr3_top/xrxdatapath_rx/xdirect_in1]
set aib_map(aib38) [list aib38 q2 r0 1 b 26 aib44 false xaibcr3_top/xtxdatapath_tx/xpinp18]
set aib_map(aib36) [list aib36 q2 r0 2 b 28 aib38 false xaibcr3_top/xtxdatapath_tx/xpinp16]
set aib_map(aib34) [list aib34 q2 r0 3 b 30 aib36 false xaibcr3_top/xtxdatapath_tx/xpinp14]
set aib_map(aib32) [list aib32 q2 r0 4 b 32 aib34 false xaibcr3_top/xtxdatapath_tx/xpinp12]
set aib_map(aib30) [list aib30 q2 r0 5 b 34 aib32 false xaibcr3_top/xtxdatapath_tx/xpinp10]
set aib_map(aib43) [list aib43 q2 r0 6 t 36 aib30 false xaibcr3_top/xtxdatapath_tx/x187]
set aib_map(aib28) [list aib28 q2 r0 7 t 38 aib43 false xaibcr3_top/xtxdatapath_tx/xpinp8]
set aib_map(aib26) [list aib26 q2 r0 8 t 40 aib28 false xaibcr3_top/xtxdatapath_tx/xpinp6]
set aib_map(aib24) [list aib24 q2 r0 9 t 42 aib26 false xaibcr3_top/xtxdatapath_tx/xpinp4]
set aib_map(aib22) [list aib22 q2 r0 10 t 44 aib24 false xaibcr3_top/xtxdatapath_tx/xpinp2]
set aib_map(aib20) [list aib20 q2 r0 11 t 46 aib22 false xaibcr3_top/xtxdatapath_tx/xpinp0]
set aib_map(aib66) [list aib66 q3 r0 11 t 48 aib20 true xaibcr3_top/xrxdatapath_rx/xdirect_out2]
set aib_map(aib68) [list aib68 q3 r0 10 t 50 aib66 true xaibcr3_top/xtxdatapath_tx/xasynctx0]
set aib_map(aib71) [list aib71 q3 r0 9 t 52 aib68 true xaibcr3_top/xtxdatapath_tx/xasynctx2]
set aib_map(aib93) [list aib93 q3 r0 8 t 54 aib71 true xaibcr3_top/xavmm1/xsdr_in2]
set aib_map(aib89) [list aib89 q3 r0 7 t 56 aib93 true xaibcr3_top/xavmm1/xsdr_in3]
set aib_map(aib83) [list aib83 q3 r0 6 t 58 aib89 true xaibcr3_top/xavmm1/xrx_clkp]
set aib_map(aib87) [list aib87 q3 r0 5 b 60 aib83 true xaibcr3_top/xtxdatapath_tx/xdiout_clkp0]
set aib_map(aib78) [list aib78 q3 r0 4 b 62 aib87 true xaibcr3_top/xavmm1/xavmm1_in0]
set aib_map(aib80) [list aib80 q3 r0 3 b 64 aib78 true xaibcr3_top/xavmm2/xvinp10]
set aib_map(aib64) [list aib64 q3 r0 2 b 66 aib80 true xaibcr3_top/xtxdatapath_tx/xdirect_in1_1]
set aib_map(aib57) [list aib57 q3 r0 1 b 68 aib64 true xaibcr3_top/xrxdatapath_rx/xdiin_clkp]
set aib_map(aib51) [list aib51 q3 r0 0 b 70 aib57 true xaibcr3_top/xrxdatapath_rx/xdirect_out4]
set aib_map(aib49) [list aib49 q4 r0 0 b 72 aib51 false xaibcr3_top/xrxdatapath_rx/xdirect_out6]
set aib_map(aib53) [list aib53 q4 r0 1 b 74 aib49 false xaibcr3_top/xrxdatapath_rx/xxdout_clkp]
set aib_map(aib62) [list aib62 q4 r0 2 b 76 aib53 false xaibcr3_top/xtxdatapath_tx/xdirect_out0]
set aib_map(aib48) [list aib48 q4 r0 3 b 78 aib62 false xaibcr3_top/xtxdatapath_tx/xdiout_clkp1]
set aib_map(aib58) [list aib58 q4 r0 4 b 80 aib48 false xaibcr3_top/xrxdatapath_rx/xdirect_in0]
set aib_map(aib76) [list aib76 q4 r0 5 b 82 aib58 false xaibcr3_top/xavmm1/xrx]
set aib_map(aib85) [list aib85 q4 r0 6 t 84 aib76 false xaibcr3_top/xavmm1/xtx_clkp]
set aib_map(aib95) [list aib95 q4 r0 7 t 86 aib85 false xaibcr3_top/xavmm1/xsdr_out2]
set aib_map(aib91) [list aib91 q4 r0 8 t 88 aib95 false xaibcr3_top/xavmm1/xsdr_out3]
set aib_map(aib75) [list aib75 q4 r0 9 t 90 aib91 false xaibcr3_top/xtxdatapath_tx/xasynctx4]
set aib_map(aib72) [list aib72 q4 r0 10 t 92 aib75 false xaibcr3_top/xtxdatapath_tx/xasyncrx0]
set aib_map(aib61) [list aib61 q4 r0 11 t 94 aib72 false xaibcr3_top/xtxdatapath_tx/xdirect_in3_1]
set aib_map(aib47) [list aib47 q1 r1 11 t 1 aib50 true xaibcr3_top/xrxdatapath_rx/xdirect_out1]
set aib_map(aib1) [list aib1 q1 r1 10 t 3 aib47 true xaibcr3_top/xrxdatapath_rx/xpoutp1]
set aib_map(aib3) [list aib3 q1 r1 9 t 5 aib1 true xaibcr3_top/xrxdatapath_rx/xpoutp3]
set aib_map(aib5) [list aib5 q1 r1 8 t 7 aib3 true xaibcr3_top/xrxdatapath_rx/xpoutp5]
set aib_map(aib7) [list aib7 q1 r1 7 t 9 aib5 true xaibcr3_top/xrxdatapath_rx/xpoutp7]
set aib_map(aib9) [list aib9 q1 r1 6 t 11 aib7 true xaibcr3_top/xrxdatapath_rx/xpoutp9]
set aib_map(aib40) [list aib40 q1 r1 5 b 13 aib9 true xaibcr3_top/xrxdatapath_rx/xrx_clkn]
set aib_map(aib11) [list aib11 q1 r1 4 b 15 aib40 true xaibcr3_top/xrxdatapath_rx/xpoutp11]
set aib_map(aib13) [list aib13 q1 r1 3 b 17 aib11 true xaibcr3_top/xrxdatapath_rx/xpoutp13]
set aib_map(aib15) [list aib15 q1 r1 2 b 19 aib13 true xaibcr3_top/xrxdatapath_rx/xpoutp15]
set aib_map(aib17) [list aib17 q1 r1 1 b 21 aib15 true xaibcr3_top/xrxdatapath_rx/xpoutp17]
set aib_map(aib19) [list aib19 q1 r1 0 b 23 aib17 true xaibcr3_top/xrxdatapath_rx/xpoutp19]
set aib_map(aib45) [list aib45 q2 r1 0 b 25 aib19 false xaibcr3_top/xtxdatapath_tx/xdirect_out]
set aib_map(aib39) [list aib39 q2 r1 1 b 27 aib45 false xaibcr3_top/xtxdatapath_tx/xpinp19]
set aib_map(aib37) [list aib37 q2 r1 2 b 29 aib39 false xaibcr3_top/xtxdatapath_tx/xpinp17]
set aib_map(aib35) [list aib35 q2 r1 3 b 31 aib37 false xaibcr3_top/xtxdatapath_tx/xpinp15]
set aib_map(aib33) [list aib33 q2 r1 4 b 33 aib35 false xaibcr3_top/xtxdatapath_tx/xpinp13]
set aib_map(aib31) [list aib31 q2 r1 5 b 35 aib33 false xaibcr3_top/xtxdatapath_tx/xpinp11]
set aib_map(aib42) [list aib42 q2 r1 6 t 37 aib31 false xaibcr3_top/xtxdatapath_tx/x454]
set aib_map(aib29) [list aib29 q2 r1 7 t 39 aib42 false xaibcr3_top/xtxdatapath_tx/x455]
set aib_map(aib27) [list aib27 q2 r1 8 t 41 aib29 false xaibcr3_top/xtxdatapath_tx/x429]
set aib_map(aib25) [list aib25 q2 r1 9 t 43 aib27 false xaibcr3_top/xtxdatapath_tx/x446]
set aib_map(aib23) [list aib23 q2 r1 10 t 45 aib25 false xaibcr3_top/xtxdatapath_tx/x438]
set aib_map(aib21) [list aib21 q2 r1 11 t 47 aib23 false xaibcr3_top/xtxdatapath_tx/x430]
set aib_map(aib67) [list aib67 q3 r1 11 t 49 aib21 true xaibcr3_top/xtxdatapath_tx/xdirect_in4_1]
set aib_map(aib69) [list aib69 q3 r1 10 t 51 aib67 true xaibcr3_top/xtxdatapath_tx/xasynctx1]
set aib_map(aib70) [list aib70 q3 r1 9 t 53 aib69 true xaibcr3_top/xtxdatapath_tx/xasynctx3]
set aib_map(aib92) [list aib92 q3 r1 8 t 55 aib70 true xaibcr3_top/xavmm1/xsdr_in0]
set aib_map(aib88) [list aib88 q3 r1 7 t 57 aib92 true xaibcr3_top/xavmm1/xsdr_in1]
set aib_map(aib82) [list aib82 q3 r1 6 t 59 aib88 true xaibcr3_top/xavmm1/xrx_clkn]
set aib_map(aib86) [list aib86 q3 r1 5 b 61 aib82 true xaibcr3_top/xtxdatapath_tx/xdiout_clkn0]
set aib_map(aib79) [list aib79 q3 r1 4 b 63 aib86 true xaibcr3_top/xavmm1/xavmm1_in1]
set aib_map(aib81) [list aib81 q3 r1 3 b 65 aib79 true xaibcr3_top/xavmm2/xvinp11]
set aib_map(aib65) [list aib65 q3 r1 2 b 67 aib81 true xaibcr3_top/xrxdatapath_rx/xdirect_in2]
set aib_map(aib59) [list aib59 q3 r1 1 b 69 aib65 true xaibcr3_top/xrxdatapath_rx/xdiin_clkn]
set aib_map(aib52) [list aib52 q3 r1 0 b 71 aib59 true xaibcr3_top/xrxdatapath_rx/xdirect_out5]
set aib_map(aib56) [list aib56 q4 r1 0 b 73 aib52 false xaibcr3_top/xtxdatapath_tx/xdirect_outpclk3]
set aib_map(aib54) [list aib54 q4 r1 1 b 75 aib56 false xaibcr3_top/xrxdatapath_rx/xxdout_clkn]
set aib_map(aib60) [list aib60 q4 r1 2 b 77 aib54 false xaibcr3_top/xrxdatapath_rx/xxdirect_out0]
set aib_map(aib55) [list aib55 q4 r1 3 b 79 aib60 false xaibcr3_top/xtxdatapath_tx/xdiout_clkn1]
set aib_map(aib63) [list aib63 q4 r1 4 b 81 aib55 false xaibcr3_top/xrxdatapath_rx/xdirect_in3]
set aib_map(aib77) [list aib77 q4 r1 5 b 83 aib63 false xaibcr3_top/xavmm2/xvoutp1]
set aib_map(aib84) [list aib84 q4 r1 6 t 85 aib77 false xaibcr3_top/xavmm1/xtx_clkn]
set aib_map(aib94) [list aib94 q4 r1 7 t 87 aib84 false xaibcr3_top/xavmm1/xsdr_out0]
set aib_map(aib90) [list aib90 q4 r1 8 t 89 aib94 false xaibcr3_top/xavmm1/xsdr_out1]
set aib_map(aib74) [list aib74 q4 r1 9 t 91 aib90 false xaibcr3_top/xtxdatapath_tx/xasyncrx2]
set aib_map(aib73) [list aib73 q4 r1 10 t 93 aib74 false xaibcr3_top/xtxdatapath_tx/xasyncrx1]
set aib_map(aib50) [list aib50 q4 r1 11 t 95 aib73 false xaibcr3_top/xrxdatapath_rx/xdirect_out3]

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

#=========================================================================
# Constraints file
#-------------------------------------------------------------------------
#
# This file contains various constraints for your chip including the
# target clock period, the capacitive load of output pins, and any
# input/output delay constraints.

#-----------------------------------------------------------------------------
# Set Units
#-----------------------------------------------------------------------------
set_units -capacitance 1.0pF
set_units -time 1.0ns

#-----------------------------------------------------------------------------
# Variables
#-----------------------------------------------------------------------------
# Cycling through modes only Base constraints from Jumbo, no changes to the constraints yet; Need more info

# user mode 1 is dcc_en = 0, user mode 2 is dcc_en = 1
echo "=============================================================================="
echo "Reading SDC file..."
echo "=============================================================================="
echo "Clk Period = " $clk_period
echo "JTAG en = " $jtag_en
echo "scan en = " $scan_en
echo "DFT en = " $dft_en
echo "DLL /DLL en = " $dcc_en
#echo "Redundancy mode en" = $redundancy_mode
echo "Do we need atpg_scan?? no test patterns implemented currently only cycling"
echo "through usermode and redundancy"
echo "=============================================================================="

# Clock periods (in ns)
# Could potentially go as low as 20MHz if necessary
set jtag_clk_period     33.33
set scan_clk_period     20.0
# Clock uncertainty  (Need different uncertainities for different clocks ?)
set clk_uncertainty     0.020
set dll_clk_uncertainty     0.020
set dcc_clk_uncertainty     0.040

# Strobeclk to distclk maximum skew
set strb_to_dist_max_early_skew   0.05
set strb_to_dist_max_late_skew   0.20

# adapt2aib insertion delay margin is equal to the delay of incoming data
# relative to the adapt2aib_clk (ihssi_rx_transfer_clk). Ideally, the
# ihssi_rx_data_out[*] arrives much later than ihssi_rx_transfer_clk, due
# to the depth of the clock tree within the aib_top_wrp
set adapt2aib_insertion 0.15
# aib2adapt insertion delay margin is equal to the delay of outgoing data
# path in the adapter relative to the capture clk within the adapter (clock
# tree built from ohssi_tx_transfer_clk). Ideally, ohssi_tx_data_in
# arrives at the output much later than ohssi_tx_transfer_data[*] due to
# the depth of the clock tree within the adapter
set aib2adapt_insertion_max 0.0
set aib2adapt_insertion_min -0.3
#-----------------------------------------------------------------------------
# Helper Functions
#-----------------------------------------------------------------------------

#-----------------------------------------------------------------------------
# Clock definitions
#-----------------------------------------------------------------------------
## PMA TX clock (Connects to ilaunchclk_in0 of tx_xdiout_clkn0, xdiout_clkp0 and ilaunchclk_in1 of avmm1_xrx_clkp, avmm1_xrx_clkn)
# This is the 1GHz clock forwarded from the AIB to the FPGA, is forwarded back to us via aib43/42
create_clock -name tx_pma_clk -period $clk_period [get_ports ihssi_pma_aib_tx_clk]

# These are the 500MHz clocks supplied from AIB to FPGA. Do these need a phase relationship requirement?
# This connects to ilaunchclk0 of tx_xdiout_clkp1, tx_xdiout_clkn1 and ilaunchclk1 of tx_xdirect_out0, rx_xxdirect_out0
create_clock -name rx_pma_div2_clk -period [expr $clk_period * 2] [get_ports ihssi_pld_pcs_rx_clk_out]
# This connects to ilaunchclk0 of rx_xxdout_clkp, rx_xxdout_clkn and ilaunchclk1 of rx_xdirect_out6, rx_xdirect_outpclk3
create_clock -name tx_pma_div2_clk -period [expr $clk_period * 2] [get_ports ihssi_pld_pcs_tx_clk_out]

# HSSI transfer clock (Input to the DCC )
# NOTE: For this to work correctly, we must be able trace through the DCC block and clocks through the launch / measure path
create_clock -name adapt2aib_clk -period $clk_period [get_ports ihssi_rx_transfer_clk]
# SR clock (AVMM TX Clk in) Driven by osc_clkin
create_clock -name adapt2aib_ssr_clk -period $clk_period [get_ports ihssi_sr_clk_out]
# JTAG scan chain signal
create_clock -name ijtag_clkdr_in_chain_clk -period $jtag_clk_period [get_ports ijtag_clkdr_in_chain]
# Oscillator clock in (Ayar PLL clock)
create_clock -name osc_clkin_clk -period $clk_period [get_ports osc_clkin]

# Scan clocks
create_clock -name iatpg_bsr0_scan_shift_clk -period $scan_clk_period [get_ports iatpg_bsr0_scan_shift_clk]
create_clock -name iatpg_bsr1_scan_shift_clk -period $scan_clk_period [get_ports iatpg_bsr1_scan_shift_clk]
create_clock -name iatpg_bsr2_scan_shift_clk -period $scan_clk_period [get_ports iatpg_bsr2_scan_shift_clk]
create_clock -name iatpg_bsr3_scan_shift_clk -period $scan_clk_period [get_ports iatpg_bsr3_scan_shift_clk]
create_clock -name iatpg_scan_clk_in0 -period $scan_clk_period [get_ports iatpg_scan_clk_in0]
create_clock -name iatpg_scan_clk_in1 -period $scan_clk_period [get_ports iatpg_scan_clk_in1]

# Create a virtual clock to constrain all aib output ports
if {$scan_en} {
    create_clock -period $scan_clk_period -name virtual_aib_clock
} elseif {$jtag_en} {
    create_clock -period $jtag_clk_period -name virtual_aib_clock
} else {
    # AIB output ports
    create_clock -period [expr $clk_period / 2] -name virtual_aib_clock
    set_clock_latency -source [expr $clk_period / 2 + 0.0] [get_clocks virtual_aib_clock]
}

#-----------------------------------------------------------------------------
# Clock From Bump Definitions : (bump, redundant bump)
#-----------------------------------------------------------------------------
# tx_clk_n: (aib42, aib31) = inverted TX transfer clock from HSSI
# tx_clk:   (aib43, aib30) = TX transfer clock from HSSI
# rx_clk_p/n:       (aib41/40, aib8/9) = RX transfer clock to HSSI
# pma_core_clkin:   (aib57, aib64) = clock from PMA
# pld_sclk:         (aib58, aib48) = per-channel dedicated micro-bump
# pma_core_clkin_n: (aib59, aib65) = inverted clock from PMA
# core_clk:         (aib72, aib75) = core clock
# sr_clk_n_in:      (aib82, aib88) = inverted clock SDR
# sr_clk_in:        (aib83, aib89) = clock SDR
# aib83 clock SDR

# tx_clk_n Actually the receive clock_n for the Receiver
# tx_clk Actually the receive clock Receiver
# pma_core_clkin (async diff rx clkp RX)
# pld_sclk : async rx
# pma_core_clkin_n (async diff rx clkn RX)
# shared_direct_async_in[0]
# sr_clk_n_in: Q3 sdr clk_n ?
# sr_clk_in: Q3 sdr clk

    create_clock -name tx_clk           -period $clk_period [get_ports aib43]
    create_clock -name tx_clk_n         -period $clk_period [get_ports aib42] -waveform " [expr $clk_period/2] $clk_period "
    create_clock -name pma_core_clkin   -period $clk_period [get_ports aib57]
    create_clock -name pld_sclk         -period $clk_period [get_ports aib58]
    create_clock -name pma_core_clkin_n -period $clk_period [get_ports aib59] -waveform " [expr $clk_period/2] $clk_period "
    create_clock -name core_clk         -period $clk_period [get_ports aib72]

    create_clock -name sr_clk_in   -period $clk_period [get_ports aib83]
    create_clock -name sr_clk_n_in -period $clk_period -waveform "  [expr $clk_period/2] $clk_period " [get_ports aib82]
    
    #create_clock -name pma_aib_tx_clk   -period $clk_period [get_ports ihssi_pma_aib_tx_clk]
    #create_clock -name pma_aib_tx_clk_n -period $clk_period -waveform "  [expr $clk_period/2] $clk_period " [get_ports ihssi_pma_aib_tx_clk]

# Generated clocks DCC output DCC_Helper output
if {$scan_en} {
    create_generated_clock -name dcc_output_clk -multiply_by 1 -duty_cycle 50 \
        -source [get_ports iatpg_scan_clk_in0] \
        [get_pins -hierarchical $alias_hier(dcc_helper)/ckout]
} else {
    # Generated clocks DCC output DCC_Helper output
    create_generated_clock -name dcc_output_clk -multiply_by 1 -duty_cycle 50 \
        -source [get_ports ihssi_rx_transfer_clk] \
        [get_pins -hierarchical $alias_hier(dcc_helper)/ckout]
}

# BCA: Data-to-data checks to support DLL coarse and fine controls arriving synchronously
# with respect to each other for the DLL.  This relies on there being a "no change" window
# within the phase interpolator that allows changes on sp/sn to occur only when the clock is
# high.
set Nsp 7
set Nbk 64
for {set pnum 0} {$pnum < 2} {incr pnum} {
   for {set bkind 0} {$bkind < $Nbk} {incr bkind} {
      set_max_delay -from tx_clk -to $alias_hier(dll_dly_$pnum)/bk[$bkind] [expr 3*$clk_period]
   }
   for {set i 0} {$i < $Nsp} {incr i} {
      set_max_delay -from tx_clk -to $alias_hier(dll_interpolator_$pnum)/sp[$i] [expr 3*$clk_period]
      set_max_delay -from tx_clk -to $alias_hier(dll_interpolator_$pnum)/sn[$i] [expr 3*$clk_period]
      for {set bkind 0} {$bkind < $Nbk} {incr bkind} {
        set_data_check -hold -from $alias_hier(dll_dly_$pnum)/bk[$bkind] \
            -to $alias_hier(dll_interpolator_$pnum)/sp[$i] [expr -$clk_period/2 + 0.1]
        set_data_check -setup -from $alias_hier(dll_dly_$pnum)/bk[$bkind] \
            -to $alias_hier(dll_interpolator_$pnum)/sp[$i] [expr $clk_period/2 - 0.1]
      }
   }
}

if {$dcc_en} {
  # Create trace-through clocks for 1time delay line when dcc is enabled
  # BCA Note: Even though the 1time clock waveforms in reality are not divide by 1,
  # modeling them with division larger than one results in the tool thinking that
  # there is no window in which a signal in the original clock domain can transition
  # and not end up in the region of the waveform (dlyin being low) where the
  # constraints say that changes aren't allowed.
  # Note that we used a definition similar to dcc_output_clk (multiply, set
  # duty cycle) since otherwise the tool complained about not knowing
  # how to propagate falling edges and therefore ignored any source latency.
  create_generated_clock -name dcc_1time_launch_clk -add -multiply_by 1 \
      -master_clock adapt2aib_clk -duty_cycle 50 \
      -source [get_pins $alias_hier(dlyline_full_ff)/clk] \
      [get_pins $alias_hier(dlyline_full_ff)/q]
  create_generated_clock -name dcc_1time_measure_clk -add -multiply_by 1 \
      -master_clock adapt2aib_clk -duty_cycle 50 \
      -source [get_pins $alias_hier(mindly_full_ff)/clk] \
      [get_pins $alias_hier(mindly_full_ff)/q]

  # BCA: Data-to-data checks to support fine and coarse delay controls arriving synchronously
  # with respect to each other for the DCC
  set lens [list full half]
    foreach len $lens {
        for {set i 0} {$i < $Nsp} {incr i} {
          set_max_delay -from adapt2aib_clk -to $alias_hier(dcc_dly_${len}_intp)/sp[$i] [expr 3*$clk_period]
          set_max_delay -from adapt2aib_clk -to $alias_hier(dcc_dly_${len}_intp)/sn[$i] [expr 3*$clk_period]
        }
        for {set lind 0} {$lind < 4} {incr lind} {
          for {set bkind 0} {$bkind < $Nbk} {incr bkind} {
              set_max_delay -from adapt2aib_clk -to  $alias_hier(dcc_dly_${len}_$lind)/bk[$bkind] [expr 3*$clk_period]
              for {set i 0} {$i < $Nsp} {incr i} {
                  set_data_check -hold -from  $alias_hier(dcc_dly_${len}_$lind)/bk[$bkind] \
                    -to $alias_hier(dcc_dly_${len}_intp)/sp[$i] [expr -$clk_period/2 + 0.1]
                  set_data_check -setup -from $alias_hier(dcc_dly_${len}_$lind)/bk[$bkind] \
                    -to $alias_hier(dcc_dly_${len}_intp)/sp[$i] [expr $clk_period/2 - 0.1]
              }
          }
        }
    }

    # Create generated clocks off of the self-lock assertion counter in both the DLL And the DCC,
    # due to later flops using this signal as their clock. The first register is reg[2]
    for {set i 2} {$i < 10} {incr i} {
        create_generated_clock -name dcc_sl_assertion_div_${i} -add \
            -divide_by [expr 2**($i+1)] -master_clock adapt2aib_clk \
            -source [get_pins $alias_hier(dcc_sl_div_flops)[$i]/clk] \
            [get_pins $alias_hier(dcc_sl_div_flops)[$i]/q]

        create_generated_clock -name dll_sl_assertion_div_${i} -add \
            -divide_by [expr 2**($i+1)] -master_clock tx_clk \
            -source [get_pins $alias_hier(dll_sl_div_flops)[$i]/clk] \
            [get_pins $alias_hier(dll_sl_div_flops)[$i]/q]
    }
}

# Create clock domains
set jtag_clk_domain         [list [get_clocks {ijtag_clkdr_in_chain_clk}]]
set scan_clk_domain         [list [get_clocks {iatpg_bsr0_scan_shift_clk iatpg_bsr1_scan_shift_clk iatpg_bsr2_scan_shift_clk iatpg_bsr3_scan_shift_clk iatpg_scan_clk_in0 iatpg_scan_clk_in1}]]
set adapt2aib_clk_domain    [list [get_clocks {adapt2aib_clk dcc_output_clk rx_pma_div2_clk}]]
set aib2adapt_clk_domain    [list [get_clocks {
        tx_clk_n tx_clk
        tx_pma_div2_clk tx_pma_clk
    }]]
# Removed generated aib2adapt_ssr_clk
set sdr_clk_domain          [list [get_clocks {
       osc_clkin_clk
       adapt2aib_ssr_clk
       sr_clk_in sr_clk_n_in
    }]]

#-----------------------------------------------------------------------------
# False path, modes, and set_case_analysis constraints
#-----------------------------------------------------------------------------

# Don't check paths to scan chains, jtag each other
set_false_path -from $jtag_clk_domain -to [concat $scan_clk_domain $adapt2aib_clk_domain $aib2adapt_clk_domain $sdr_clk_domain]
set_false_path -from $scan_clk_domain -to [concat $jtag_clk_domain $adapt2aib_clk_domain $aib2adapt_clk_domain $sdr_clk_domain]
set_false_path -from $adapt2aib_clk_domain -to [concat $jtag_clk_domain $scan_clk_domain $aib2adapt_clk_domain $sdr_clk_domain]
set_false_path -from $aib2adapt_clk_domain -to [concat $jtag_clk_domain $scan_clk_domain $adapt2aib_clk_domain $sdr_clk_domain]
set_false_path -from $sdr_clk_domain  -to [concat $jtag_clk_domain $scan_clk_domain $adapt2aib_clk_domain $aib2adapt_clk_domain]

# False Path for the configuration registers
set_false_path -through [get_ports r_aib_csr_ctrl*]
set_false_path -through [get_ports r_aib_dprio_ctrl*]

# False path full delay line control signals
# Interpolator sn/sp paths
set dcc_full_interps [list \
    xaibcr3_top/xrxdatapath_rx/x1591/I82/I0/I0/I0/I57/x142 \
    xaibcr3_top/xrxdatapath_rx/x1591/I82/I0/I0/I1/x142 \
]
foreach full_interp $dcc_full_interps {
    set_false_path -to $full_interp/sn[*]
    set_false_path -to $full_interp/sp[*]
}
# Delay line bk paths
set dcc_full_dlylines [list \
    xaibcr3_top/xrxdatapath_rx/x1591/I82/I0/I0/I0/I58/I10 \
    xaibcr3_top/xrxdatapath_rx/x1591/I82/I0/I0/I0/I58/I9 \
    xaibcr3_top/xrxdatapath_rx/x1591/I82/I0/I0/I0/I58/I1 \
    xaibcr3_top/xrxdatapath_rx/x1591/I82/I0/I0/I0/I58/I8 \
]
foreach dcc_full_dlyline $dcc_full_dlylines {
    set_false_path -to $dcc_full_dlyline/bk[*]
}

############
# Case Analysis of scan pin (note that they are active low)
set_case_analysis [expr !$scan_en] [get_ports iatpg_scan_mode_n]
set_case_analysis [expr !$scan_en] [get_ports iatpg_scan_shift_n]

# These two signals should be dll_dcc_dft_en ??
# csr_reg_str6 in str_align.v selects between oaibdftcore2dll<2:0> and idll_lock_req
set_case_analysis $dft_en [get_ports r_aib_csr_ctrl_26[6]]
# DCC DFT/FUNC mode en (1) selects DFT mode
set_case_analysis $dft_en [get_ports r_aib_csr_ctrl_17[0]]

# This is the dcc bypass DISABLE signal (in other words, 1 to enable the DCC)
set_case_analysis $dcc_en [get_ports r_aib_dprio_ctrl_3[3]]
# This is rb_cont_cal (for DCC), let's be more conservative and not statically set this
set_case_analysis $dcc_en [get_ports r_aib_dprio_ctrl_3[5]]
# Setting this to 1 takes the PCS clock (clkin_dist) after the first DLL variable delay line, 0 means before
# According to page 77 of FS_CR3_AIB_IO spec, this is set to 0 for all functional modes probably
set_case_analysis 0 [get_ports r_aib_csr_ctrl_18[2]]

# jtag_clksel 1 activates the jtag mode
set_case_analysis $jtag_en [get_ports jtag_clksel]
#####################################

# Disable redundancy mode
for {set i 0} {$i < 8} {incr i} {
   for {set j 0} {$j < 12} {incr j} {
       set_case_analysis 0 [get_ports r_aib_csr_ctrl_${j}\[$i\]]
   }
}

set buffs [filter libcell [find / -libcell aibcr3_buffx1_top] [find / -instance *]]
foreach buff $buffs {
    if {$jtag_en} { set_mode jtag_en $buff
    } else { set_mode functional $buff }


    # Also constrain dist_clk and strbclk maximum skew, this is not captured by
    # the buffx1 .lib file
    # BCA: Switched to/from clocks from Ayar constraints to make consistent with PAR1
    # set_clock_latency constraints
    set_data_check -setup -rise_from $buff/istrbclk_in0 \
        -rise_to $buff/iclkin_dist_in0 -$strb_to_dist_max_late_skew
    # BCA - to make consistent with PAR1, changing -$strb_to_dist... to +$strb_to_dist...
    set_data_check -hold -rise_from $buff/istrbclk_in0 \
        -rise_to $buff/iclkin_dist_in0 $strb_to_dist_max_early_skew

    # No timing paths should end at buffer iopad
    set_false_path -to $buff/iopad

    # Ignore paths from aib88, which is the redundant SDR clock, because no redundancy support
    set_false_path -from aib88 -to $buff/iclkin_dist_in0
}


# Conditional False paths section Need if else conditions based on mode variables to exercise/false path specific paths in reudundancy,
# scan, func and jtag modes

# False paths to the DLL gray coder retimers: code_valid, sm_grey, sm_igray, dll_reset_n
# These must be false paths because the DLL delay line delay is variable, and it is impossible
# for these to be met under all conditions
# More generally: is it true that ANY delay paths to the dll_strobe_clk domain be a false path?


set dll_dly_retiming_pins [concat \
        sm_grey[*] \
        sm_igray[*] \
        code_valid \
        dll_reset_n \
    ]

foreach pin $dll_dly_retiming_pins {
    set_false_path -hold -from [get_clocks tx_clk] -through [get_pins $alias_hier(dll_dly_retimer)/$pin]
    set_false_path -hold -from [get_clocks tx_clk] -through [get_pins $alias_hier(dll_dly_mimic_retimer)/$pin]
    set_multicycle_path -setup 1 -through [get_pins $alias_hier(dll_dly_retimer)/$pin]
    set_multicycle_path -setup 1 -through [get_pins $alias_hier(dll_dly_mimic_retimer)/$pin]
}

#-----------------------------------------------------------------------------
# Clock Properties
#-----------------------------------------------------------------------------
# Will need different uncertainities for SDR and DDR clocks
set_clock_uncertainty $clk_uncertainty [get_clocks]

# BCA: Removed redundancy clock
#set_clock_uncertainty $dll_clk_uncertainty -setup [get_clocks [list dll_strobe_clk]]
#set_clock_uncertainty $dll_clk_uncertainty -hold [get_clocks [list dll_strobe_clk]]

set_clock_uncertainty $dcc_clk_uncertainty -setup [get_clocks [list dcc_output_clk]]
set_clock_uncertainty $dcc_clk_uncertainty -hold [get_clocks [list dcc_output_clk]]

# Intrinsix Note: Remove the create_clock for all clock sources coming from or through adapter
# -----------------------------------------------------------------------------------

#-----------------------------------------------------------------------------
# Pin Constraints
#-----------------------------------------------------------------------------
# Input/Output delays

# Set aib input pin times
foreach aib_io [array names aib_map] {
    set val $aib_map($aib_io)
    set quad [lindex $val 1]
    set row [lindex $val 2]
    set col [lindex $val 3]
    set bt [lindex $val 4]
    set red_bump [lindex $val 6]
    set inst [lindex $val 8]

    # These are the high-speed receive data
    if {$quad == "q2"} {
        set_input_delay [expr $clk_period*0.0] [get_ports $aib_io] -clock [get_clocks virtual_aib_clock]
        set_false_path -hold -from [get_ports $aib_io] -to $inst
    } elseif {$quad == "q1"} {
        set_output_delay [expr $clk_period*0.0] [get_ports $aib_io] -clock [get_clocks virtual_aib_clock]
        set_false_path -hold -to [get_ports $aib_io]
    } else {
        set_false_path -hold -from [get_ports $aib_io]
        set_false_path -hold -to [get_ports $aib_io]
    }
    set_false_path -hold -from [get_ports $aib_io] -to $scan_clk_domain
    set_false_path -hold -to [get_ports $aib_io] -from $scan_clk_domain
}

# Set delays for the adapter2aib (rx) data
set_input_delay -max [expr $clk_period/2 + $adapt2aib_insertion] \
    [get_ports ihssi_rx_data_out*] -clock [get_clocks adapt2aib_clk]
set_input_delay -min $adapt2aib_insertion \
    [get_ports ihssi_rx_data_out*] -clock [get_clocks adapt2aib_clk]

# Set delays for the aib2adapter (tx) data, that clock tree is deep so it's "max" delay is 0 due to likely high clock skew
# BCA: commenting out all redundancy mode clocks
# foreach clk {aib2adapt_clk aib2adapt_clk_r} {
foreach clk {tx_clk} {
    set_output_delay -max $aib2adapt_insertion_max \
        [get_ports ohssi_tx_data_in*] -clock [get_clocks $clk] -add_delay
    set_output_delay -min $aib2adapt_insertion_min \
        [get_ports ohssi_tx_data_in*] -clock [get_clocks $clk] -add_delay
}

# Set delays for aib2adapt SSR outputs, need to skew the minimum delay lower (to a negative number usually)
# due to large clock insertion delay in the adapter
set aib2adapt_ssr_outputs [concat \
        ohssi_avmm2_data_in* \
        ohssi_avmm1_data_in* \
        ohssi_ssr_data_in \
        ohssi_ssr_load_in \
    ]

foreach output $aib2adapt_ssr_outputs {
   set_output_delay -max $aib2adapt_insertion_max \
      [get_ports $output] -clock sr_clk_n_in -add_delay
   set_output_delay -min $aib2adapt_insertion_min \
      [get_ports $output] -clock sr_clk_n_in -add_delay
}

# Set SSR inputs / outputs
set_input_delay -max [expr $clk_period / 2] [get_ports ihssi_ssr_data_out] -clock [get_clocks adapt2aib_ssr_clk]
set_input_delay -min 0 [get_ports ihssi_ssr_data_out*] -clock [get_clocks adapt2aib_ssr_clk]

set_input_delay -max [expr $clk_period / 2] [get_ports ihssi_ssr_load_out] -clock [get_clocks adapt2aib_ssr_clk]
set_input_delay -min 0 [get_ports ihssi_ssr_load_out] -clock [get_clocks adapt2aib_ssr_clk]

# False path / multicycle path checks from AIB pins to #jtag clk domain
set_false_path -from [get_ports aib*] -to $jtag_clk_domain

# Port Groups to be constrained
set cfg_inputs [filter -regexp direction in [find / -port r_aib*]]
set ojtag_outputs [filter -regexp direction out [find / -port ojtag*]]
set ijtag_inputs [filter -regexp direction in [find / -port *ijtag*]]
set dft_inputs [filter -regexp direction in  [find / -port iaibdft*]]
set dft_outputs [filter -regexp direction in  [find / -port oaibdft*]]
set unused_ports [concat \
    ohssi_adapter_rx_pld_rst_n \
    ohssi_adapter_tx_pld_rst_n \
    [find / -port idirectout_data_in_chain*] \
    [find / -port ishared_direct_async_in[*]] \
    [find / -port oshared_direct_async_out[*]] \
    [find / -port odirectout_data_out_chain*] \
    ihssi_dcc_req \
    ihssi_avmm1_data_out \
    ihssi_avmm2_data_out \
    ihssi_fsr_data_out \
    ihssi_fsr_load_out \
    ohssi_fsr_data_in \
    ohssi_fsr_load_in \
    ihssi_pld_8g_rxelecidle \
    ohssi_pcs_rx_pld_rst_n \
    ohssi_pcs_tx_pld_rst_n \
    ohssi_pld_pma_rxpma_rstb \
    ohssi_pld_pma_txdetectrx \
    ohssi_pld_pma_txpma_rstb \
    ohssirx_dcc_done \
    ored_idataselb_out_chain1 \
    ored_idataselb_out_chain2 \
    ored_shift_en_out_chain1 \
    ored_shift_en_out_chain2 \
    otxen_out_chain1 \
    otxen_out_chain2 \
    ired_idataselb_in_chain1 \
    ired_idataselb_in_chain2 \
    ired_shift_en_in_chain1 \
    ired_shift_en_in_chain2 \
    irstb \
    ihssi_pld_pma_pfdmode_lock \
    ihssi_pld_pma_rxpll_lock \
    ihssi_pld_rx_hssi_fifo_latency_pulse \
    ihssi_pld_tx_hssi_fifo_latency_pulse \
    ohssi_tx_dcd_cal_done \
    ohssi_tx_dll_lock \
    ihssi_tx_dcd_cal_req \
    ihssi_tx_dll_lock_req \
]



# TODO: Many more unconstrained input / output ports
set_false_path -through [concat $dft_inputs $dft_outputs]
set_false_path -through [concat $cfg_inputs]
set_false_path -through $unused_ports

#BCA - set false path to synchronizers
set_false_path -to [get_pins xaibcr3_top/xrxdatapath_rx/x1591/I82/I1/xsync*/*/*/*/d]
set_false_path -to [get_pins xaibcr3_top/xtxdatapath_tx/x982/I1/xsync*/*/*/*/d]

set_false_path -hold -through iatpg_scan_rst_n
set_multicycle_path -setup 2 -through iatpg_scan_rst_n

set_false_path -hold -through jtag_rstb
set_multicycle_path -setup 2 -through jtag_rstb

# BCA: Don't touch nets (AIB ports are directly recreated from lower level)
foreach_in_collection aib_ports [get_ports aib*] {
  set_dont_touch [get_nets -segments [get_object_name $aib_ports]]
}
# BCA: Don't touch manual clock tree nets
set_dont_touch [get_nets -segments -of_objects [get_pins xaibcr3_top/xtxdatapath_tx/x982/x46/buf_main_0/clkout]]
set_dont_touch [get_nets -segments -of_objects [get_pins xaibcr3_top/xtxdatapath_tx/x982/x41/buf_main_0/clkout]]
set_dont_touch [get_nets -segments -of_objects [get_pins xaibcr3_top/xrxdatapath_rx/xclktree/buf_main_0/clkout]]

# Constrain feedthrough paths. Goal is 30MHz JTAG frequency in 24-channel design
set_max_delay 0.6 -from [get_ports ijtag_clkdr_in_chain] \
    -to [get_ports ojtag_clkdr_out_chain]

#-----------------------------------------------------------------------------
# DRV constraints
#-----------------------------------------------------------------------------

# Set range of input transition times
set_input_transition -max 0.1 [all_inputs]
set_input_transition -min 0.001 [all_inputs]

set_input_transition -max 0.1 [get_ports aib*]
set_input_transition -min 0.001 [get_ports aib*]

set_max_transition 0.040 [all_inputs]
set_max_capacitance 0.010 [all_inputs]

# Set defaults for signals we care less about to be a lot higher
set_max_transition 0.100 [concat $cfg_inputs $ijtag_inputs]
set_max_capacitance 0.030 [concat $cfg_inputs $ijtag_inputs]

# Make sure all output transitions are < 40 ps given a pin load of 20 fF
set_max_transition 0.040 [all_outputs]
set_load -pin_load 0.020 [all_outputs]
# Non critical outputs transitions
set_max_transition 0.100 [concat $ojtag_outputs]




