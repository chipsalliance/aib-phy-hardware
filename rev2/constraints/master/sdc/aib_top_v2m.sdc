# SPDX-License-Identifier: Apache-2.0
# Copyright 2019 Blue Cheetah Analog Design, Inc.

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set_units -capacitance 1.0pF
set_units -time 1.0ns

# 1GHz system clock
set NS_FWD_CLK_PERIOD 1.0
set NS_FWD_CLK_DIV2_PERIOD 2.0
set RCV_CLK_PERIOD 1.0
set FS_FWD_CLK_PERIOD 1.0
set FS_FWD_CLK_DIV2_PERIOD 2.0
set WRITE_CLK_PERIOD 2.0
set READ_CLK_PERIOD 2.0
set clk_period 1.0
# Target for these is 30 MHz, but we relaxed to 22 MHz
set SCAN_CLK_PERIOD     45.455
set jtag_clk_period     45.455
#AVMM clock frequency target is 125MHz, but we relaxed to 100 MHz
set AVMM_CLK_PERIOD     10.0
set clk_uncertainty 0.050
if {$mode=="jtag_en"} {
  set AIB_OSC_PERIOD          $SCAN_CLK_PERIOD
} else {
  set AIB_OSC_PERIOD          $clk_period
}

#===============================
# AIB clocks
#===============================
foreach chan {0 1 2 3 4 5} {
create_clock -name tx_clk_m0_ch${chan}           -period $clk_period [get_ports m0_ch${chan}_aib[43]]
create_clock -name tx_clk_m0_ch${chan}_n         -period $clk_period [get_ports m0_ch${chan}_aib[42]] -waveform " [expr $clk_period/2] $clk_period "
create_clock -name pma_core_clkin_m0_ch${chan}   -period $clk_period [get_ports m0_ch${chan}_aib[57]]
create_clock -name pld_sclk_m0_ch${chan}         -period $clk_period [get_ports m0_ch${chan}_aib[58]]
create_clock -name pma_core_clkin_m0_ch${chan}_n -period $clk_period [get_ports m0_ch${chan}_aib[59]] -waveform " [expr $clk_period/2] $clk_period "
create_clock -name core_clk_m0_ch${chan}         -period $clk_period [get_ports m0_ch${chan}_aib[72]]
create_clock -name sr_clk_in_m0_ch${chan}        -period $clk_period [get_ports m0_ch${chan}_aib[83]]
create_clock -name sr_clk_n_in_m0_ch${chan}      -period $clk_period -waveform "  [expr $clk_period/2] $clk_period " [get_ports m0_ch${chan}_aib[82]]

create_clock -name tx_clk_m1_ch${chan}           -period $clk_period [get_ports m1_ch${chan}_aib[43]]
create_clock -name tx_clk_m1_ch${chan}_n         -period $clk_period [get_ports m1_ch${chan}_aib[42]] -waveform " [expr $clk_period/2] $clk_period "
create_clock -name pma_core_clkin_m1_ch${chan}   -period $clk_period [get_ports m1_ch${chan}_aib[57]]
create_clock -name pld_sclk_m1_ch${chan}         -period $clk_period [get_ports m1_ch${chan}_aib[58]]
create_clock -name pma_core_clkin_m1_ch${chan}_n -period $clk_period [get_ports m1_ch${chan}_aib[59]] -waveform " [expr $clk_period/2] $clk_period "
create_clock -name core_clk_m1_ch${chan}         -period $clk_period [get_ports m1_ch${chan}_aib[72]]
create_clock -name sr_clk_in_m1_ch${chan}        -period $clk_period [get_ports m1_ch${chan}_aib[83]]
create_clock -name sr_clk_n_in_m1_ch${chan}      -period $clk_period -waveform "  [expr $clk_period/2] $clk_period " [get_ports m1_ch${chan}_aib[82]]

create_clock -name tx_clk_m2_ch${chan}           -period $clk_period [get_ports m2_ch${chan}_aib[43]]
create_clock -name tx_clk_m2_ch${chan}_n         -period $clk_period [get_ports m2_ch${chan}_aib[42]] -waveform " [expr $clk_period/2] $clk_period "
create_clock -name pma_core_clkin_m2_ch${chan}   -period $clk_period [get_ports m2_ch${chan}_aib[57]]
create_clock -name pld_sclk_m2_ch${chan}         -period $clk_period [get_ports m2_ch${chan}_aib[58]]
create_clock -name pma_core_clkin_m2_ch${chan}_n -period $clk_period [get_ports m2_ch${chan}_aib[59]] -waveform " [expr $clk_period/2] $clk_period "
create_clock -name core_clk_m2_ch${chan}         -period $clk_period [get_ports m2_ch${chan}_aib[72]]
create_clock -name sr_clk_in_m2_ch${chan}        -period $clk_period [get_ports m2_ch${chan}_aib[83]]
create_clock -name sr_clk_n_in_m2_ch${chan}      -period $clk_period -waveform "  [expr $clk_period/2] $clk_period " [get_ports m2_ch${chan}_aib[82]]

create_clock -name tx_clk_m3_ch${chan}           -period $clk_period [get_ports m3_ch${chan}_aib[43]]
create_clock -name tx_clk_m3_ch${chan}_n         -period $clk_period [get_ports m3_ch${chan}_aib[42]] -waveform " [expr $clk_period/2] $clk_period "
create_clock -name pma_core_clkin_m3_ch${chan}   -period $clk_period [get_ports m3_ch${chan}_aib[57]]
create_clock -name pld_sclk_m3_ch${chan}         -period $clk_period [get_ports m3_ch${chan}_aib[58]]
create_clock -name pma_core_clkin_m3_ch${chan}_n -period $clk_period [get_ports m3_ch${chan}_aib[59]] -waveform " [expr $clk_period/2] $clk_period "
create_clock -name core_clk_m3_ch${chan}         -period $clk_period [get_ports m3_ch${chan}_aib[72]]
create_clock -name sr_clk_in_m3_ch${chan}        -period $clk_period [get_ports m3_ch${chan}_aib[83]]
create_clock -name sr_clk_n_in_m3_ch${chan}      -period $clk_period -waveform "  [expr $clk_period/2] $clk_period " [get_ports m3_ch${chan}_aib[82]]
}
#================================
foreach chan {0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23}  {
create_clock [get_ports m_ns_rcv_clk[${chan}]] -name ns_rcv_clk_ch${chan} -period $RCV_CLK_PERIOD
create_clock [get_ports m_ns_fwd_clk[${chan}]] -name ns_fwd_clk_ch${chan} -period $NS_FWD_CLK_PERIOD
create_clock [get_ports m_ns_fwd_div2_clk[${chan}]] -name ns_fwd_div2_clk_ch${chan} -period $NS_FWD_CLK_DIV2_PERIOD
create_clock [get_ports m_wr_clk[${chan}]] -name wr_clk_ch${chan} -period $WRITE_CLK_PERIOD
create_clock [get_ports m_rd_clk[${chan}]] -name rd_clk_ch${chan} -period $READ_CLK_PERIOD
}
create_clock [get_ports i_osc_clk] -name osc_clk -period $AIB_OSC_PERIOD
create_clock [get_ports i_cfg_avmm_clk] -name avmm_clk -period $AVMM_CLK_PERIOD
create_clock [get_ports i_scan_clk] -name ATPG_scan_clk -period $SCAN_CLK_PERIOD
create_clock [get_ports i_jtag_clkdr] -name jtag_clk -period $jtag_clk_period

###########Create Generated Clocks========================
#Create Generated Clock for "fs_fwd_clk"
for {set i 0} {$i<4} {incr i} {
   for {set j 0} {$j<6} {incr j} {
    set k [expr $i*6 + $j]
     create_generated_clock -name fs_fwd_clk_ch${k} -divide_by 1 \
     -source [get_pin u_c3aibadapt_wrap_top/u_c3aibadapt_${k}/io_aib43] \
     [get_pin u_c3aibadapt_wrap_top/u_c3aibadapt_${k}/o_tx_transfer_clk]
   }
  }

create_generated_clock -name aux_clk -divide_by 1 \
  -source [get_ports i_osc_clk] [get_pin aibcr3aux_top_master/osc_clkout]

#########################
#Clock Properties
########################
foreach chan {0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23}  {
set_clock_uncertainty $clk_uncertainty [get_clocks ns_rcv_clk_ch${chan}]
set_clock_uncertainty $clk_uncertainty [get_clocks ns_fwd_clk_ch${chan}]
set_clock_uncertainty $clk_uncertainty [get_clocks ns_fwd_div2_clk_ch${chan}]
set_clock_uncertainty $clk_uncertainty [get_clocks fs_fwd_clk_ch${chan}]
set_clock_uncertainty $clk_uncertainty [get_clocks wr_clk_ch${chan}]
set_clock_uncertainty $clk_uncertainty [get_clocks rd_clk_ch${chan}]
}
set_clock_uncertainty $clk_uncertainty [get_clocks osc_clk]
set_clock_uncertainty $clk_uncertainty [get_clocks avmm_clk]
set_clock_uncertainty $clk_uncertainty [get_clocks ATPG_scan_clk]
set_clock_uncertainty $clk_uncertainty [get_clocks aux_clk]
set_clock_uncertainty $clk_uncertainty [get_clocks jtag_clk]

foreach chan {0 1 2 3 4 5} {
set_clock_uncertainty $clk_uncertainty [get_clocks tx_clk_m0_ch${chan}]
set_clock_uncertainty $clk_uncertainty [get_clocks tx_clk_m0_ch${chan}_n]
set_clock_uncertainty $clk_uncertainty [get_clocks pma_core_clkin_m0_ch${chan}]
set_clock_uncertainty $clk_uncertainty [get_clocks pma_core_clkin_m0_ch${chan}_n]
set_clock_uncertainty $clk_uncertainty [get_clocks pld_sclk_m0_ch${chan}]
set_clock_uncertainty $clk_uncertainty [get_clocks sr_clk_in_m0_ch${chan}]
set_clock_uncertainty $clk_uncertainty [get_clocks sr_clk_n_in_m0_ch${chan}]
set_clock_uncertainty $clk_uncertainty [get_clocks core_clk_m0_ch${chan}]

set_clock_uncertainty $clk_uncertainty [get_clocks tx_clk_m1_ch${chan}]
set_clock_uncertainty $clk_uncertainty [get_clocks tx_clk_m1_ch${chan}_n]
set_clock_uncertainty $clk_uncertainty [get_clocks pma_core_clkin_m1_ch${chan}]
set_clock_uncertainty $clk_uncertainty [get_clocks pma_core_clkin_m1_ch${chan}_n]
set_clock_uncertainty $clk_uncertainty [get_clocks pld_sclk_m1_ch${chan}]
set_clock_uncertainty $clk_uncertainty [get_clocks sr_clk_in_m1_ch${chan}]
set_clock_uncertainty $clk_uncertainty [get_clocks sr_clk_n_in_m1_ch${chan}]
set_clock_uncertainty $clk_uncertainty [get_clocks core_clk_m1_ch${chan}]

set_clock_uncertainty $clk_uncertainty [get_clocks tx_clk_m2_ch${chan}]
set_clock_uncertainty $clk_uncertainty [get_clocks tx_clk_m2_ch${chan}_n]
set_clock_uncertainty $clk_uncertainty [get_clocks pma_core_clkin_m2_ch${chan}]
set_clock_uncertainty $clk_uncertainty [get_clocks pma_core_clkin_m2_ch${chan}_n]
set_clock_uncertainty $clk_uncertainty [get_clocks pld_sclk_m2_ch${chan}]
set_clock_uncertainty $clk_uncertainty [get_clocks sr_clk_in_m2_ch${chan}]
set_clock_uncertainty $clk_uncertainty [get_clocks sr_clk_n_in_m2_ch${chan}]
set_clock_uncertainty $clk_uncertainty [get_clocks core_clk_m2_ch${chan}]

set_clock_uncertainty $clk_uncertainty [get_clocks tx_clk_m3_ch${chan}]
set_clock_uncertainty $clk_uncertainty [get_clocks tx_clk_m3_ch${chan}_n]
set_clock_uncertainty $clk_uncertainty [get_clocks pma_core_clkin_m3_ch${chan}]
set_clock_uncertainty $clk_uncertainty [get_clocks pma_core_clkin_m3_ch${chan}_n]
set_clock_uncertainty $clk_uncertainty [get_clocks pld_sclk_m3_ch${chan}]
set_clock_uncertainty $clk_uncertainty [get_clocks sr_clk_in_m3_ch${chan}]
set_clock_uncertainty $clk_uncertainty [get_clocks sr_clk_n_in_m3_ch${chan}]
set_clock_uncertainty $clk_uncertainty [get_clocks core_clk_m3_ch${chan}]
}


set func_clocks {ns_fwd_clk_ch0  ns_fwd_div2_clk_ch0  fs_fwd_clk_ch0  wr_clk_ch0  rd_clk_ch0  ns_rcv_clk_ch0 \
		 ns_fwd_clk_ch1  ns_fwd_div2_clk_ch1  fs_fwd_clk_ch1   wr_clk_ch1  rd_clk_ch1  ns_rcv_clk_ch1 \
		 ns_fwd_clk_ch2  ns_fwd_div2_clk_ch2  fs_fwd_clk_ch2   wr_clk_ch2  rd_clk_ch2  ns_rcv_clk_ch2 \
		 ns_fwd_clk_ch3  ns_fwd_div2_clk_ch3  fs_fwd_clk_ch3   wr_clk_ch3  rd_clk_ch3  ns_rcv_clk_ch3 \
		 ns_fwd_clk_ch4  ns_fwd_div2_clk_ch4  fs_fwd_clk_ch4   wr_clk_ch4  rd_clk_ch4  ns_rcv_clk_ch4 \
		 ns_fwd_clk_ch5  ns_fwd_div2_clk_ch5  fs_fwd_clk_ch5   wr_clk_ch5  rd_clk_ch5  ns_rcv_clk_ch5 \
		 ns_fwd_clk_ch6  ns_fwd_div2_clk_ch6  fs_fwd_clk_ch6   wr_clk_ch6  rd_clk_ch6  ns_rcv_clk_ch6 \
		 ns_fwd_clk_ch7  ns_fwd_div2_clk_ch7  fs_fwd_clk_ch7   wr_clk_ch7  rd_clk_ch7  ns_rcv_clk_ch7 \
		 ns_fwd_clk_ch8  ns_fwd_div2_clk_ch8  fs_fwd_clk_ch8   wr_clk_ch8  rd_clk_ch8  ns_rcv_clk_ch8 \
		 ns_fwd_clk_ch9  ns_fwd_div2_clk_ch9  fs_fwd_clk_ch9   wr_clk_ch9  rd_clk_ch9  ns_rcv_clk_ch9 \
		 ns_fwd_clk_ch10 ns_fwd_div2_clk_ch10 fs_fwd_clk_ch10  wr_clk_ch10 rd_clk_ch10 ns_rcv_clk_ch10 \
		 ns_fwd_clk_ch11 ns_fwd_div2_clk_ch11 fs_fwd_clk_ch11  wr_clk_ch11 rd_clk_ch11 ns_rcv_clk_ch11 \
		 ns_fwd_clk_ch12 ns_fwd_div2_clk_ch12 fs_fwd_clk_ch12  wr_clk_ch12 rd_clk_ch12 ns_rcv_clk_ch12 \
		 ns_fwd_clk_ch13 ns_fwd_div2_clk_ch13 fs_fwd_clk_ch13  wr_clk_ch13 rd_clk_ch13 ns_rcv_clk_ch13 \
		 ns_fwd_clk_ch14 ns_fwd_div2_clk_ch14 fs_fwd_clk_ch14  wr_clk_ch14 rd_clk_ch14 ns_rcv_clk_ch14 \
		 ns_fwd_clk_ch15 ns_fwd_div2_clk_ch15 fs_fwd_clk_ch15  wr_clk_ch15 rd_clk_ch15 ns_rcv_clk_ch15 \
		 ns_fwd_clk_ch16 ns_fwd_div2_clk_ch16 fs_fwd_clk_ch16  wr_clk_ch16 rd_clk_ch16 ns_rcv_clk_ch16 \
		 ns_fwd_clk_ch17 ns_fwd_div2_clk_ch17 fs_fwd_clk_ch17  wr_clk_ch17 rd_clk_ch17 ns_rcv_clk_ch17 \
		 ns_fwd_clk_ch18 ns_fwd_div2_clk_ch18 fs_fwd_clk_ch18  wr_clk_ch18 rd_clk_ch18 ns_rcv_clk_ch18 \
		 ns_fwd_clk_ch19 ns_fwd_div2_clk_ch19 fs_fwd_clk_ch19  wr_clk_ch19 rd_clk_ch19 ns_rcv_clk_ch19 \
		 ns_fwd_clk_ch20 ns_fwd_div2_clk_ch20 fs_fwd_clk_ch20  wr_clk_ch20 rd_clk_ch20 ns_rcv_clk_ch20 \
		 ns_fwd_clk_ch21 ns_fwd_div2_clk_ch21 fs_fwd_clk_ch21  wr_clk_ch21 rd_clk_ch21 ns_rcv_clk_ch21 \
		 ns_fwd_clk_ch22 ns_fwd_div2_clk_ch22 fs_fwd_clk_ch22  wr_clk_ch22 rd_clk_ch22 ns_rcv_clk_ch22 \
		 ns_fwd_clk_ch23 ns_fwd_div2_clk_ch23 fs_fwd_clk_ch23  wr_clk_ch23 rd_clk_ch23 ns_rcv_clk_ch23}

set aib_clocks {tx_clk_m0_ch0            tx_clk_m1_ch0            tx_clk_m2_ch0            tx_clk_m3_ch0  \
		tx_clk_m0_ch0_n          tx_clk_m1_ch0_n          tx_clk_m2_ch0_n          tx_clk_m3_ch0_n \
		pma_core_clkin_m0_ch0    pma_core_clkin_m1_ch0    pma_core_clkin_m2_ch0    pma_core_clkin_m3_ch0 \
		pma_core_clkin_m0_ch0_n  pma_core_clkin_m1_ch0_n  pma_core_clkin_m2_ch0_n  pma_core_clkin_m3_ch0_n \
		pld_sclk_m0_ch0          pld_sclk_m1_ch0          pld_sclk_m2_ch0          pld_sclk_m3_ch0 \
		sr_clk_in_m0_ch0         sr_clk_in_m1_ch0         sr_clk_in_m2_ch0         sr_clk_in_m3_ch0 \
		sr_clk_n_in_m0_ch0       sr_clk_n_in_m1_ch0       sr_clk_n_in_m2_ch0       sr_clk_n_in_m3_ch0 \
		core_clk_m0_ch0          core_clk_m1_ch0          core_clk_m2_ch0          core_clk_m3_ch0 \
		tx_clk_m0_ch1            tx_clk_m1_ch1            tx_clk_m2_ch1            tx_clk_m3_ch1  \
		tx_clk_m0_ch1_n          tx_clk_m1_ch1_n          tx_clk_m2_ch1_n          tx_clk_m3_ch1_n \
		pma_core_clkin_m0_ch1    pma_core_clkin_m1_ch1    pma_core_clkin_m2_ch1    pma_core_clkin_m3_ch1 \
		pma_core_clkin_m0_ch1_n  pma_core_clkin_m1_ch1_n  pma_core_clkin_m2_ch1_n  pma_core_clkin_m3_ch1_n \
		pld_sclk_m0_ch1          pld_sclk_m1_ch1          pld_sclk_m2_ch1          pld_sclk_m3_ch1 \
		sr_clk_in_m0_ch1         sr_clk_in_m1_ch1         sr_clk_in_m2_ch1         sr_clk_in_m3_ch1 \
		sr_clk_n_in_m0_ch1       sr_clk_n_in_m1_ch1       sr_clk_n_in_m2_ch1       sr_clk_n_in_m3_ch1 \
		core_clk_m0_ch1          core_clk_m1_ch1          core_clk_m2_ch1          core_clk_m3_ch1 \
		tx_clk_m0_ch2            tx_clk_m1_ch2            tx_clk_m2_ch2            tx_clk_m3_ch2  \
		tx_clk_m0_ch2_n          tx_clk_m1_ch2_n          tx_clk_m2_ch2_n          tx_clk_m3_ch2_n \
		pma_core_clkin_m0_ch2    pma_core_clkin_m1_ch2    pma_core_clkin_m2_ch2    pma_core_clkin_m3_ch2 \
		pma_core_clkin_m0_ch2_n  pma_core_clkin_m1_ch2_n  pma_core_clkin_m2_ch2_n  pma_core_clkin_m3_ch2_n \
		pld_sclk_m0_ch2          pld_sclk_m1_ch2          pld_sclk_m2_ch2          pld_sclk_m3_ch2 \
		sr_clk_in_m0_ch2         sr_clk_in_m1_ch2         sr_clk_in_m2_ch2         sr_clk_in_m3_ch2 \
		sr_clk_n_in_m0_ch2       sr_clk_n_in_m1_ch2       sr_clk_n_in_m2_ch2       sr_clk_n_in_m3_ch2 \
		core_clk_m0_ch2          core_clk_m1_ch2          core_clk_m2_ch2          core_clk_m3_ch2 \
		tx_clk_m0_ch3            tx_clk_m1_ch3            tx_clk_m2_ch3            tx_clk_m3_ch3  \
		tx_clk_m0_ch3_n          tx_clk_m1_ch3_n          tx_clk_m2_ch3_n          tx_clk_m3_ch3_n \
		pma_core_clkin_m0_ch3    pma_core_clkin_m3_ch1    pma_core_clkin_m2_ch3    pma_core_clkin_m3_ch3 \
		pma_core_clkin_m0_ch3_n  pma_core_clkin_m3_ch1_n  pma_core_clkin_m2_ch3_n  pma_core_clkin_m3_ch3_n \
		pld_sclk_m0_ch3          pld_sclk_m1_ch3          pld_sclk_m2_ch3          pld_sclk_m3_ch3 \
		sr_clk_in_m0_ch3         sr_clk_in_m1_ch3         sr_clk_in_m2_ch3         sr_clk_in_m3_ch3 \
		sr_clk_n_in_m0_ch3       sr_clk_n_in_m1_ch3       sr_clk_n_in_m2_ch3       sr_clk_n_in_m3_ch3 \
		core_clk_m0_ch3          core_clk_m1_ch3          core_clk_m2_ch3          core_clk_m3_ch3 \
		tx_clk_m0_ch4            tx_clk_m1_ch4            tx_clk_m2_ch4            tx_clk_m3_ch4  \
		tx_clk_m0_ch4_n          tx_clk_m1_ch4_n          tx_clk_m2_ch4_n          tx_clk_m3_ch4_n \
		pma_core_clkin_m0_ch4    pma_core_clkin_m1_ch4    pma_core_clkin_m2_ch4    pma_core_clkin_m3_ch4 \
		pma_core_clkin_m0_ch4_n  pma_core_clkin_m1_ch4_n  pma_core_clkin_m2_ch4_n  pma_core_clkin_m3_ch4_n \
		pld_sclk_m0_ch4          pld_sclk_m1_ch4          pld_sclk_m2_ch4          pld_sclk_m3_ch4 \
		sr_clk_in_m0_ch4         sr_clk_in_m1_ch4         sr_clk_in_m2_ch4         sr_clk_in_m3_ch4 \
		sr_clk_n_in_m0_ch4       sr_clk_n_in_m1_ch14      sr_clk_n_in_m2_ch4       sr_clk_n_in_m3_ch4 \
		core_clk_m0_ch4          core_clk_m1_ch4          core_clk_m2_ch4          core_clk_m3_ch4 \
		tx_clk_m0_ch5            tx_clk_m1_ch5            tx_clk_m2_ch5            tx_clk_m3_ch5  \
		tx_clk_m0_ch5_n          tx_clk_m1_ch5_n          tx_clk_m2_ch5_n          tx_clk_m3_ch5_n \
		pma_core_clkin_m0_ch5    pma_core_clkin_m1_ch5    pma_core_clkin_m2_ch5    pma_core_clkin_m3_ch5 \
		pma_core_clkin_m0_ch5_n  pma_core_clkin_m1_ch5_n  pma_core_clkin_m2_ch5_n  pma_core_clkin_m3_ch5_n \
		pld_sclk_m0_ch5          pld_sclk_m1_ch5          pld_sclk_m2_ch5          pld_sclk_m3_ch5 \
		sr_clk_in_m0_ch5         sr_clk_in_m1_ch5         sr_clk_in_m2_ch5         sr_clk_in_m3_ch5 \
		sr_clk_n_in_m0_ch5       sr_clk_n_in_m1_ch5       sr_clk_n_in_m2_ch5       sr_clk_n_in_m3_ch5 \
		core_clk_m0_ch5          core_clk_m1_ch5          core_clk_m2_ch5          core_clk_m3_ch5  }


set daisy_clocks { avmm_clk osc_clk \
                   ATPG_scan_clk  aux_clk }

# False path between JTAG and other clocks
set_false_path -from jtag_clk -to $func_clocks
set_false_path -from $func_clocks -to jtag_clk

set_false_path -from jtag_clk -to $aib_clocks
set_false_path -from $aib_clocks -to jtag_clk

set_false_path -from jtag_clk -to $daisy_clocks
set_false_path -from $daisy_clocks -to jtag_clk

#  channel ID is a constant!
set_false_path -through  [get_ports {ns_adapter_rstn i_cfg_avmm_rst_n i_jtag_rstb}]

# Ignore timing from AIB ports
set_false_path -from [get_ports m*_ch*_aib*]

# BCA: These are asynchronous, essentially DC signals, so just make sure they have a constraint.
set_max_delay 1.0 -to [get_ports sl_sideband*]
set_max_delay 6.5 -to [get_ports ms_sideband*]
set_max_delay 6.5 -to [get_ports ms_rx_transfer_en*]
set_max_delay 6.5 -to [get_ports ms_tx_transfer_en*]
set_max_delay 1.0 -to [get_ports sl_rx_transfer_en*]
set_max_delay 1.0 -to [get_ports sl_tx_transfer_en*]

#####################################
###Clock Grouping
#####################################
set_clock_groups -asynchronous -name ASYNC_GRP     \
                               -group {tx_clk_m0_ch0 tx_clk_m0_ch0_n fs_fwd_clk_ch0 } \
                               -group {pma_core_clkin_m0_ch0 pma_core_clkin_m0_ch0_n} \
                               -group {sr_clk_in_m0_ch0 sr_clk_n_in_m0_ch0} \
                               -group pld_sclk_m0_ch0  \
                               -group core_clk_m0_ch0  \
                               -group {tx_clk_m0_ch1 tx_clk_m0_ch1_n fs_fwd_clk_ch1 } \
                               -group {pma_core_clkin_m0_ch1 pma_core_clkin_m0_ch1_n} \
                               -group {sr_clk_in_m0_ch1 sr_clk_n_in_m0_ch1} \
                               -group pld_sclk_m0_ch1 \
                               -group core_clk_m0_ch1 \
                               -group {tx_clk_m0_ch2 tx_clk_m0_ch2_n fs_fwd_clk_ch2 } \
                               -group {pma_core_clkin_m0_ch2 pma_core_clkin_m0_ch2_n} \
                               -group {sr_clk_in_m0_ch2 sr_clk_n_in_m0_ch2} \
                               -group pld_sclk_m0_ch2 \
                               -group core_clk_m0_ch2 \
                               -group {tx_clk_m0_ch3 tx_clk_m0_ch3_n fs_fwd_clk_ch3 } \
                               -group {pma_core_clkin_m0_ch3 pma_core_clkin_m0_ch3_n} \
                               -group {sr_clk_in_m0_ch3 sr_clk_n_in_m0_ch3} \
                               -group pld_sclk_m0_ch3 \
                               -group core_clk_m0_ch3 \
                               -group {tx_clk_m0_ch4 tx_clk_m0_ch4_n fs_fwd_clk_ch4 } \
                               -group {pma_core_clkin_m0_ch4 pma_core_clkin_m0_ch4_n} \
                               -group {sr_clk_in_m0_ch4 sr_clk_n_in_m0_ch4} \
                               -group pld_sclk_m0_ch4 \
                               -group core_clk_m0_ch4 \
                               -group {tx_clk_m0_ch5 tx_clk_m0_ch5_n fs_fwd_clk_ch5 } \
                               -group {pma_core_clkin_m0_ch5 pma_core_clkin_m0_ch5_n} \
                               -group {sr_clk_in_m0_ch5 sr_clk_n_in_m0_ch5} \
                               -group pld_sclk_m0_ch5 \
                               -group core_clk_m0_ch5 \
                               -group {tx_clk_m1_ch0 tx_clk_m1_ch0_n fs_fwd_clk_ch6 } \
                               -group {pma_core_clkin_m1_ch0 pma_core_clkin_m1_ch0_n} \
                               -group {sr_clk_in_m1_ch0 sr_clk_n_in_m1_ch0} \
                               -group pld_sclk_m1_ch0 \
                               -group core_clk_m1_ch0 \
                               -group {tx_clk_m1_ch1 tx_clk_m1_ch1_n fs_fwd_clk_ch7 } \
                               -group {pma_core_clkin_m1_ch1 pma_core_clkin_m1_ch1_n} \
                               -group {sr_clk_in_m1_ch1 sr_clk_n_in_m1_ch1} \
                               -group pld_sclk_m1_ch1 \
                               -group core_clk_m1_ch1 \
                               -group {tx_clk_m1_ch2 tx_clk_m1_ch2_n fs_fwd_clk_ch8 } \
                               -group {pma_core_clkin_m1_ch2 pma_core_clkin_m1_ch2_n} \
                               -group {sr_clk_in_m1_ch2 sr_clk_n_in_m1_ch2} \
                               -group pld_sclk_m1_ch2 \
                               -group core_clk_m1_ch2 \
                               -group {tx_clk_m1_ch3 tx_clk_m1_ch3_n fs_fwd_clk_ch9 } \
                               -group {pma_core_clkin_m1_ch3 pma_core_clkin_m1_ch3_n} \
                               -group {sr_clk_in_m1_ch3 sr_clk_n_in_m1_ch3} \
                               -group pld_sclk_m1_ch3 \
                               -group core_clk_m1_ch3 \
                               -group {tx_clk_m1_ch4 tx_clk_m1_ch4_n fs_fwd_clk_ch10 } \
                               -group {pma_core_clkin_m1_ch4 pma_core_clkin_m1_ch4_n} \
                               -group {sr_clk_in_m1_ch4 sr_clk_n_in_m1_ch4} \
                               -group pld_sclk_m1_ch4 \
                               -group core_clk_m1_ch4 \
                               -group {tx_clk_m1_ch5 tx_clk_m1_ch5_n fs_fwd_clk_ch11 } \
                               -group {pma_core_clkin_m1_ch5 pma_core_clkin_m1_ch5_n} \
                               -group {sr_clk_in_m1_ch5 sr_clk_n_in_m1_ch5} \
                               -group pld_sclk_m1_ch5 \
                               -group core_clk_m1_ch5 \
                               -group {tx_clk_m2_ch0 tx_clk_m2_ch0_n fs_fwd_clk_ch12 } \
                               -group {pma_core_clkin_m2_ch0 pma_core_clkin_m2_ch0_n} \
                               -group {sr_clk_in_m2_ch0 sr_clk_n_in_m2_ch0} \
                               -group pld_sclk_m2_ch0 \
                               -group core_clk_m2_ch0 \
                               -group {tx_clk_m2_ch1 tx_clk_m2_ch1_n fs_fwd_clk_ch13 } \
                               -group {pma_core_clkin_m2_ch1 pma_core_clkin_m2_ch1_n} \
                               -group {sr_clk_in_m2_ch1 sr_clk_n_in_m2_ch1} \
                               -group pld_sclk_m2_ch1 \
                               -group core_clk_m2_ch1 \
                               -group {tx_clk_m2_ch2 tx_clk_m2_ch2_n fs_fwd_clk_ch14 } \
                               -group {pma_core_clkin_m2_ch2 pma_core_clkin_m2_ch2_n} \
                               -group {sr_clk_in_m2_ch2 sr_clk_n_in_m2_ch2} \
                               -group pld_sclk_m2_ch2 \
                               -group core_clk_m2_ch2 \
                               -group {tx_clk_m2_ch3 tx_clk_m2_ch3_n fs_fwd_clk_ch15 } \
                               -group {pma_core_clkin_m2_ch3 pma_core_clkin_m2_ch3_n} \
                               -group {sr_clk_in_m2_ch3 sr_clk_n_in_m2_ch3} \
                               -group pld_sclk_m2_ch3 \
                               -group core_clk_m2_ch3 \
                               -group {tx_clk_m2_ch4 tx_clk_m2_ch4_n fs_fwd_clk_ch16 } \
                               -group {pma_core_clkin_m2_ch4 pma_core_clkin_m2_ch4_n} \
                               -group {sr_clk_in_m2_ch4 sr_clk_n_in_m2_ch4} \
                               -group pld_sclk_m2_ch4 \
                               -group core_clk_m2_ch4 \
                               -group {tx_clk_m2_ch5 tx_clk_m2_ch5_n fs_fwd_clk_ch17 } \
                               -group {pma_core_clkin_m2_ch5 pma_core_clkin_m2_ch5_n} \
                               -group {sr_clk_in_m2_ch5 sr_clk_n_in_m2_ch5} \
                               -group pld_sclk_m2_ch5 \
                               -group core_clk_m2_ch5 \
                               -group {tx_clk_m3_ch0 tx_clk_m3_ch0_n fs_fwd_clk_ch18 } \
                               -group {pma_core_clkin_m3_ch0 pma_core_clkin_m3_ch0_n} \
                               -group {sr_clk_in_m3_ch0 sr_clk_n_in_m3_ch0} \
                               -group pld_sclk_m3_ch0 \
                               -group core_clk_m3_ch0 \
                               -group {tx_clk_m3_ch1 tx_clk_m3_ch1_n fs_fwd_clk_ch19 } \
                               -group {pma_core_clkin_m3_ch1 pma_core_clkin_m3_ch1_n} \
                               -group {sr_clk_in_m3_ch1 sr_clk_n_in_m3_ch1} \
                               -group pld_sclk_m3_ch1 \
                               -group core_clk_m3_ch1 \
                               -group {tx_clk_m3_ch2 tx_clk_m3_ch2_n fs_fwd_clk_ch20 } \
                               -group {pma_core_clkin_m3_ch2 pma_core_clkin_m3_ch2_n} \
                               -group {sr_clk_in_m3_ch2 sr_clk_n_in_m3_ch2} \
                               -group pld_sclk_m3_ch2 \
                               -group core_clk_m3_ch2 \
                               -group {tx_clk_m3_ch3 tx_clk_m3_ch3_n fs_fwd_clk_ch21 } \
                               -group {pma_core_clkin_m3_ch3 pma_core_clkin_m3_ch3_n} \
                               -group {sr_clk_in_m3_ch3 sr_clk_n_in_m3_ch3} \
                               -group pld_sclk_m3_ch3 \
                               -group core_clk_m3_ch3 \
                               -group {tx_clk_m3_ch4 tx_clk_m3_ch4_n fs_fwd_clk_ch22 } \
                               -group {pma_core_clkin_m3_ch4 pma_core_clkin_m3_ch4_n} \
                               -group {sr_clk_in_m3_ch4 sr_clk_n_in_m3_ch4} \
                               -group pld_sclk_m3_ch4 \
                               -group core_clk_m3_ch4 \
                               -group {tx_clk_m3_ch5 tx_clk_m3_ch5_n fs_fwd_clk_ch23 } \
                               -group {pma_core_clkin_m3_ch5 pma_core_clkin_m3_ch5_n} \
                               -group {sr_clk_in_m3_ch5 sr_clk_n_in_m3_ch5} \
                               -group pld_sclk_m3_ch5 \
                               -group core_clk_m3_ch5 \
                               -group {ns_fwd_clk_ch0 ns_fwd_div2_clk_ch0} \
                               -group { ns_rcv_clk_ch0} \
                               -group wr_clk_ch0 \
                               -group rd_clk_ch0 \
                               -group {ns_fwd_clk_ch1 ns_fwd_div2_clk_ch1} \
                               -group {ns_rcv_clk_ch1} \
                               -group wr_clk_ch1 \
                               -group rd_clk_ch1 \
                               -group {ns_fwd_clk_ch2 ns_fwd_div2_clk_ch2} \
                               -group {ns_rcv_clk_ch2} \
                               -group wr_clk_ch2 \
                               -group rd_clk_ch2 \
                               -group {ns_fwd_clk_ch3 ns_fwd_div2_clk_ch3} \
                               -group {ns_rcv_clk_ch3} \
                               -group wr_clk_ch3 \
                               -group rd_clk_ch3 \
                               -group {ns_fwd_clk_ch4 ns_fwd_div2_clk_ch4} \
                               -group {ns_rcv_clk_ch4} \
                               -group wr_clk_ch4 \
                               -group rd_clk_ch4 \
                               -group {ns_fwd_clk_ch5 ns_fwd_div2_clk_ch5} \
                               -group {ns_rcv_clk_ch5} \
                               -group wr_clk_ch5 \
                               -group rd_clk_ch5 \
                               -group {ns_fwd_clk_ch6 ns_fwd_div2_clk_ch6} \
                               -group {ns_rcv_clk_ch6} \
                               -group wr_clk_ch6 \
                               -group rd_clk_ch6 \
                               -group {ns_fwd_clk_ch7 ns_fwd_div2_clk_ch7} \
                               -group {ns_rcv_clk_ch7} \
                               -group wr_clk_ch7 \
                               -group rd_clk_ch7 \
                               -group {ns_fwd_clk_ch8 ns_fwd_div2_clk_ch8} \
                               -group {ns_rcv_clk_ch8} \
                               -group wr_clk_ch8 \
                               -group rd_clk_ch8 \
                               -group {ns_fwd_clk_ch9 ns_fwd_div2_clk_ch9} \
                               -group {ns_rcv_clk_ch9} \
                               -group wr_clk_ch9 \
                               -group rd_clk_ch9 \
                               -group {ns_fwd_clk_ch10 ns_fwd_div2_clk_ch10} \
                               -group {ns_rcv_clk_ch10} \
                               -group wr_clk_ch10 \
                               -group rd_clk_ch10 \
                               -group {ns_fwd_clk_ch11 ns_fwd_div2_clk_ch11} \
                               -group {ns_rcv_clk_ch11} \
                               -group wr_clk_ch11 \
                               -group rd_clk_ch11 \
                               -group {ns_fwd_clk_ch12 ns_fwd_div2_clk_ch12} \
                               -group {ns_rcv_clk_ch12} \
                               -group wr_clk_ch12 \
                               -group rd_clk_ch12 \
                               -group {ns_fwd_clk_ch13 ns_fwd_div2_clk_ch13} \
                               -group {ns_rcv_clk_ch13} \
                               -group wr_clk_ch13 \
                               -group rd_clk_ch13 \
                               -group {ns_fwd_clk_ch14 ns_fwd_div2_clk_ch14} \
                               -group {ns_rcv_clk_ch14} \
                               -group wr_clk_ch14 \
                               -group rd_clk_ch14 \
                               -group {ns_fwd_clk_ch15 ns_fwd_div2_clk_ch15} \
                               -group {ns_rcv_clk_ch15} \
                               -group wr_clk_ch15 \
                               -group rd_clk_ch15 \
                               -group {ns_fwd_clk_ch16 ns_fwd_div2_clk_ch16} \
                               -group {ns_rcv_clk_ch16} \
                               -group wr_clk_ch16 \
                               -group rd_clk_ch16 \
                               -group {ns_fwd_clk_ch17 ns_fwd_div2_clk_ch17} \
                               -group {ns_rcv_clk_ch17} \
                               -group wr_clk_ch17 \
                               -group rd_clk_ch17 \
                               -group {ns_fwd_clk_ch18 ns_fwd_div2_clk_ch18} \
                               -group {ns_rcv_clk_ch18} \
                               -group wr_clk_ch18 \
                               -group rd_clk_ch18 \
                               -group {ns_fwd_clk_ch19 ns_fwd_div2_clk_ch19} \
                               -group {ns_rcv_clk_ch19} \
                               -group wr_clk_ch19 \
                               -group rd_clk_ch19 \
                               -group {ns_fwd_clk_ch20 ns_fwd_div2_clk_ch20} \
                               -group {ns_rcv_clk_ch20} \
                               -group wr_clk_ch20 \
                               -group rd_clk_ch20 \
                               -group {ns_fwd_clk_ch21 ns_fwd_div2_clk_ch21} \
                               -group {ns_rcv_clk_ch21} \
                               -group wr_clk_ch21 \
                               -group rd_clk_ch21 \
                               -group {ns_fwd_clk_ch22 ns_fwd_div2_clk_ch22} \
                               -group {ns_rcv_clk_ch22} \
                               -group wr_clk_ch22 \
                               -group rd_clk_ch22 \
                               -group {ns_fwd_clk_ch23 ns_fwd_div2_clk_ch23} \
                               -group {ns_rcv_clk_ch23} \
                               -group wr_clk_ch23 \
                               -group rd_clk_ch23 \
                               -group avmm_clk \
                               -group ATPG_scan_clk

set_false_path -from i_conf_done

########################################
# Ports and Grouping
########################################
set AVMM1_SYNC_INPUT [ list \
i_cfg_avmm_read \
i_cfg_avmm_addr[*] \
i_cfg_avmm_byte_en[*] \
i_cfg_avmm_write \
i_cfg_avmm_wdata[*] \
]

set AVMM1_SYNC_OUTPUT [ list \
o_cfg_avmm_waitreq \
o_cfg_avmm_rdata[*] \
o_cfg_avmm_rdatavld \
]

set JTAG_SYNC_INPUT [ list \
i_jtag_clksel \
i_jtag_intest  \
i_jtag_mode \
i_jtag_tdi \
i_jtag_tx_scanen \
i_jtag_weakpdn \
i_jtag_weakpu \
]
set JTAG_SYNC_OUTPUT [ list \
o_jtag_tdo \
]

########################################
# Input & Output Delays(Max delay 80% & Min Delay 0)
########################################
# Intel spec is 800ps of external delay
set external_delay 0.8
set no_of_ch 24
set data_width 78

set data_width_ch [expr $no_of_ch * $data_width]

  for {set i 0} {$i<$data_width_ch} {incr i} {
   set j [expr int ([expr $i/$data_width])]
    set_input_delay -max $external_delay -clock [get_clocks wr_clk_ch${j}]  [get_ports data_in[$i]]
    set_input_delay -min 0 -clock [get_clocks wr_clk_ch${j}] [get_ports data_in[$i]]

    set_output_delay -max $external_delay -clock [get_clocks rd_clk_ch${j}] [get_ports data_out[$i]]
    set_output_delay -min 0 -clock [get_clocks rd_clk_ch${j}] [get_ports data_out[$i]]
  }

  for {set i 0} {$i<$no_of_ch} {incr i} {
    set_output_delay -max $external_delay -clock [get_clocks rd_clk_ch${i}] [get_ports m_rxfifo_align_done[$i]]
    set_output_delay -min 0 -clock [get_clocks rd_clk_ch${i}] [get_ports m_rxfifo_align_done[$i]]
  }

set data_width_reg 40
set data_width_reg_ch [expr $no_of_ch * $data_width_reg]

  for {set i 0} {$i<$data_width_reg_ch} {incr i} {
   set j [expr int ([expr $i/$data_width_reg])]
    set_input_delay -max 0.65 -clock [get_clocks ns_fwd_clk_ch${j}] [get_ports data_in_reg_mode[$i]]
    set_input_delay -min 0.1 -clock [get_clocks ns_fwd_clk_ch${j}] [get_ports data_in_reg_mode[$i]]

    set_output_delay -max 0.45 -clock [get_clocks fs_fwd_clk_ch${j}] [get_ports data_out_reg_mode[$i]]
    set_output_delay -min 0 -clock [get_clocks fs_fwd_clk_ch${j}] [get_ports data_out_reg_mode[$i]]

  }

foreach myport $AVMM1_SYNC_INPUT {
  puts "Set IO Delay   $myport"
  set_input_delay  -max $external_delay -clock [get_clocks avmm_clk] $myport ;
  set_input_delay  -min 0 -clock [get_clocks avmm_clk] $myport	;
}

foreach myport $AVMM1_SYNC_OUTPUT {
  puts "Set IO Delay   $myport"
  set_output_delay -max $external_delay -clock [get_clocks avmm_clk] $myport ;
  set_output_delay -min 0 -clock [get_clocks avmm_clk] $myport	;
}

foreach myport $JTAG_SYNC_INPUT {
  puts "Set IO Delay   $myport"
  set_input_delay  -max $external_delay -clock [get_clocks jtag_clk] $myport ;
  set_input_delay  -min 0 -clock [get_clocks jtag_clk] $myport	;
}

foreach myport $JTAG_SYNC_OUTPUT {
  puts "Set IO Delay   $myport"
  set_output_delay -max $external_delay -clock [get_clocks jtag_clk] $myport ;
  set_output_delay -min 0 -clock [get_clocks jtag_clk] $myport	;
}

for {set i 0} {$i < $no_of_ch} {incr i} {
  set_dont_touch [get_nets -segments -of_objects [get_pins u_c3aibadapt_wrap_top/u_c3aibadapt_$i/i_adpt_cfg_rdata[*]]]
}

set_max_delay 3.0 -from [get_ports {i_test_scan_en i_test_scan_mode}]

# DRV
set_input_transition -min 0.001 [all_inputs]
set_input_transition -max 0.100 [all_inputs]

set_max_transition 0.100 [all_inputs]
set_max_capacitance 0.010 [all_inputs]
# Set defaults for signals we care less about to be higher
set_max_transition 0.100 [all_outputs]
set_load -pin_load 0.020 [all_outputs]
