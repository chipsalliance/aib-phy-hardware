# Begin_DVE_Session_Save_Info
# DVE full session
# Saved on Tue Jul 14 18:25:06 2020
# Designs open: 1
#   V1: vcdplus.vpd
# Toplevel windows open: 1
# 	TopLevel.1
#   Source.1: top.dut.u_c3aibadapt_wrap.c3aibadapt.adapt_rxchnl.rx_datapath
#   Wave.1: 29 signals
#   Group count = 4
#   Group ms signal count = 9
#   Group slave signal count = 2
#   Group Group1 signal count = 12
#   Group Drivers: V1:top.dut.u_c3aibadapt_wrap.c3aibadapt.adapt_rxchnl.rx_datapath.wm_data[79:0]@11119840000 signal count = 6
# End_DVE_Session_Save_Info

# DVE version: P-2019.06-SP2-5_Full64
# DVE build date: May 26 2020 20:43:45


#<Session mode="Full" path="/data/juzhang/aib_phy_hardware/rev1/how2use/sim_sl2ms_lpbk_2e/loopbk_2e.tcl" type="Debug">

gui_set_loading_session_type Post
gui_continuetime_set

# Close design
if { [gui_sim_state -check active] } {
    gui_sim_terminate
}
gui_close_db -all
gui_expr_clear_all

# Close all windows
gui_close_window -type Console
gui_close_window -type Wave
gui_close_window -type Source
gui_close_window -type Schematic
gui_close_window -type Data
gui_close_window -type DriverLoad
gui_close_window -type List
gui_close_window -type Memory
gui_close_window -type HSPane
gui_close_window -type DLPane
gui_close_window -type Assertion
gui_close_window -type CovHier
gui_close_window -type CoverageTable
gui_close_window -type CoverageMap
gui_close_window -type CovDetail
gui_close_window -type Local
gui_close_window -type Stack
gui_close_window -type Watch
gui_close_window -type Group
gui_close_window -type Transaction



# Application preferences
gui_set_pref_value -key app_default_font -value {Helvetica,10,-1,5,50,0,0,0,0,0}
gui_src_preferences -tabstop 8 -maxbits 24 -windownumber 1
#<WindowLayout>

# DVE top-level session


# Create and position top-level window: TopLevel.1

if {![gui_exist_window -window TopLevel.1]} {
    set TopLevel.1 [ gui_create_window -type TopLevel \
       -icon $::env(DVE)/auxx/gui/images/toolbars/dvewin.xpm] 
} else { 
    set TopLevel.1 TopLevel.1
}
gui_show_window -window ${TopLevel.1} -show_state normal -rect {{246 145} {1969 1010}}

# ToolBar settings
gui_set_toolbar_attributes -toolbar {TimeOperations} -dock_state top
gui_set_toolbar_attributes -toolbar {TimeOperations} -offset 0
gui_show_toolbar -toolbar {TimeOperations}
gui_hide_toolbar -toolbar {&File}
gui_set_toolbar_attributes -toolbar {&Edit} -dock_state top
gui_set_toolbar_attributes -toolbar {&Edit} -offset 0
gui_show_toolbar -toolbar {&Edit}
gui_hide_toolbar -toolbar {CopyPaste}
gui_set_toolbar_attributes -toolbar {&Trace} -dock_state top
gui_set_toolbar_attributes -toolbar {&Trace} -offset 0
gui_show_toolbar -toolbar {&Trace}
gui_hide_toolbar -toolbar {TraceInstance}
gui_hide_toolbar -toolbar {BackTrace}
gui_set_toolbar_attributes -toolbar {&Scope} -dock_state top
gui_set_toolbar_attributes -toolbar {&Scope} -offset 0
gui_show_toolbar -toolbar {&Scope}
gui_set_toolbar_attributes -toolbar {&Window} -dock_state top
gui_set_toolbar_attributes -toolbar {&Window} -offset 0
gui_show_toolbar -toolbar {&Window}
gui_set_toolbar_attributes -toolbar {Signal} -dock_state top
gui_set_toolbar_attributes -toolbar {Signal} -offset 0
gui_show_toolbar -toolbar {Signal}
gui_set_toolbar_attributes -toolbar {Zoom} -dock_state top
gui_set_toolbar_attributes -toolbar {Zoom} -offset 0
gui_show_toolbar -toolbar {Zoom}
gui_set_toolbar_attributes -toolbar {Zoom And Pan History} -dock_state top
gui_set_toolbar_attributes -toolbar {Zoom And Pan History} -offset 0
gui_show_toolbar -toolbar {Zoom And Pan History}
gui_set_toolbar_attributes -toolbar {Grid} -dock_state top
gui_set_toolbar_attributes -toolbar {Grid} -offset 0
gui_show_toolbar -toolbar {Grid}
gui_hide_toolbar -toolbar {Simulator}
gui_hide_toolbar -toolbar {Interactive Rewind}
gui_hide_toolbar -toolbar {Testbench}

# End ToolBar settings

# Docked window settings
set Console.1 [gui_create_window -type Console -parent ${TopLevel.1} -dock_state bottom -dock_on_new_line true -dock_extent 179]
gui_set_window_pref_key -window ${Console.1} -key dock_width -value_type integer -value -1
gui_set_window_pref_key -window ${Console.1} -key dock_height -value_type integer -value 179
gui_set_window_pref_key -window ${Console.1} -key dock_offset -value_type integer -value 0
gui_update_layout -id ${Console.1} {{left 0} {top 0} {width 271} {height 179} {dock_state bottom} {dock_on_new_line true}}
set DriverLoad.1 [gui_create_window -type DriverLoad -parent ${TopLevel.1} -dock_state bottom -dock_on_new_line false -dock_extent 180]
gui_set_window_pref_key -window ${DriverLoad.1} -key dock_width -value_type integer -value 150
gui_set_window_pref_key -window ${DriverLoad.1} -key dock_height -value_type integer -value 180
gui_set_window_pref_key -window ${DriverLoad.1} -key dock_offset -value_type integer -value 0
gui_update_layout -id ${DriverLoad.1} {{left 0} {top 0} {width 1451} {height 179} {dock_state bottom} {dock_on_new_line false}}
#### Start - Readjusting docked view's offset / size
set dockAreaList { top left right bottom }
foreach dockArea $dockAreaList {
  set viewList [gui_ekki_get_window_ids -active_parent -dock_area $dockArea]
  foreach view $viewList {
      if {[lsearch -exact [gui_get_window_pref_keys -window $view] dock_width] != -1} {
        set dockWidth [gui_get_window_pref_value -window $view -key dock_width]
        set dockHeight [gui_get_window_pref_value -window $view -key dock_height]
        set offset [gui_get_window_pref_value -window $view -key dock_offset]
        if { [string equal "top" $dockArea] || [string equal "bottom" $dockArea]} {
          gui_set_window_attributes -window $view -dock_offset $offset -width $dockWidth
        } else {
          gui_set_window_attributes -window $view -dock_offset $offset -height $dockHeight
        }
      }
  }
}
#### End - Readjusting docked view's offset / size
gui_sync_global -id ${TopLevel.1} -option true

# MDI window settings
set HSPane.1 [gui_create_window -type {HSPane}  -parent ${TopLevel.1}]
if {[gui_get_shared_view -id ${HSPane.1} -type Hier] == {}} {
        set Hier.1 [gui_share_window -id ${HSPane.1} -type Hier]
} else {
        set Hier.1  [gui_get_shared_view -id ${HSPane.1} -type Hier]
}

gui_show_window -window ${HSPane.1} -show_state maximized
gui_update_layout -id ${HSPane.1} {{show_state maximized} {dock_state undocked} {dock_on_new_line false} {child_hier_colhier 1051} {child_hier_coltype 653} {child_hier_colpd 0} {child_hier_col1 0} {child_hier_col2 1} {child_hier_col3 -1}}
set DLPane.1 [gui_create_window -type {DLPane}  -parent ${TopLevel.1}]
if {[gui_get_shared_view -id ${DLPane.1} -type Data] == {}} {
        set Data.1 [gui_share_window -id ${DLPane.1} -type Data]
} else {
        set Data.1  [gui_get_shared_view -id ${DLPane.1} -type Data]
}

gui_show_window -window ${DLPane.1} -show_state maximized
gui_update_layout -id ${DLPane.1} {{show_state maximized} {dock_state undocked} {dock_on_new_line false} {child_data_colvariable 1073} {child_data_colvalue 300} {child_data_coltype 494} {child_data_col1 0} {child_data_col2 1} {child_data_col3 2}}
set Source.1 [gui_create_window -type {Source}  -parent ${TopLevel.1}]
gui_show_window -window ${Source.1} -show_state maximized
gui_update_layout -id ${Source.1} {{show_state maximized} {dock_state undocked} {dock_on_new_line false}}
set Wave.1 [gui_create_window -type {Wave}  -parent ${TopLevel.1}]
gui_show_window -window ${Wave.1} -show_state maximized
gui_update_layout -id ${Wave.1} {{show_state maximized} {dock_state undocked} {dock_on_new_line false} {child_wave_left 465} {child_wave_right 1253} {child_wave_colname 317} {child_wave_colvalue 144} {child_wave_col1 0} {child_wave_col2 1}}

# End MDI window settings

gui_set_env TOPLEVELS::TARGET_FRAME(Source) ${TopLevel.1}
gui_set_env TOPLEVELS::TARGET_FRAME(Schematic) ${TopLevel.1}
gui_set_env TOPLEVELS::TARGET_FRAME(PathSchematic) ${TopLevel.1}
gui_set_env TOPLEVELS::TARGET_FRAME(Wave) ${TopLevel.1}
gui_set_env TOPLEVELS::TARGET_FRAME(List) none
gui_set_env TOPLEVELS::TARGET_FRAME(Memory) ${TopLevel.1}
gui_set_env TOPLEVELS::TARGET_FRAME(DriverLoad) none
gui_update_statusbar_target_frame ${TopLevel.1}

#</WindowLayout>

#<Database>

# DVE Open design session: 

if { ![gui_is_db_opened -db {vcdplus.vpd}] } {
	gui_open_db -design V1 -file vcdplus.vpd -nosource
}
gui_set_precision 1fs
gui_set_time_units 1ns
#</Database>

# DVE Global setting session: 


# Global: Bus

# Global: Expressions

# Global: Signal Time Shift

# Global: Signal Compare

# Global: Signal Groups
gui_load_child_values {top.s10_wrap.ndut.hdpldadapt.hdpldadapt_rx_chnl.hdpldadapt_rxrst_ctl}
gui_load_child_values {top.dut.u_c3aibadapt_wrap.c3aibadapt.adapt_rxchnl.rxrst_ctl}
gui_load_child_values {top.dut.u_c3aibadapt_wrap.c3aibadapt.adapt_txchnl}
gui_load_child_values {top.dut.u_c3aibadapt_wrap.c3aibadapt.adapt_txchnl.tx_datapath.txdp_fifo}
gui_load_child_values {top.dut.u_c3aibadapt_wrap}
gui_load_child_values {top.s10_wrap.ndut.hdpldadapt.hdpldadapt_tx_chnl.hdpldadapt_txrst_ctl}
gui_load_child_values {top.s10_wrap}
gui_load_child_values {top.s10_wrap.ndut.aibnd_top_wrp}
gui_load_child_values {top.dut.u_c3aibadapt_wrap.c3aibadapt.adapt_rxchnl.rx_datapath.rxdp_fifo}


set _session_group_31 ms
gui_sg_create "$_session_group_31"
set ms "$_session_group_31"

gui_sg_addsignal -group "$_session_group_31" { top.dut.i_adpt_hard_rst_n top.dut.u_c3aibadapt_wrap.i_cfg_avmm_clk top.dut.u_c3aibadapt_wrap.i_cfg_avmm_addr top.dut.u_c3aibadapt_wrap.i_cfg_avmm_write top.dut.u_c3aibadapt_wrap.i_cfg_avmm_wdata top.dut.u_c3aibadapt_wrap.o_ehip_init_status top.dut.u_c3aibadapt_wrap.ms_sideband top.dut.u_c3aibadapt_wrap.c3aibadapt.adapt_txchnl.txrst_ctl.tx_rst_sm_cs top.dut.u_c3aibadapt_wrap.c3aibadapt.adapt_rxchnl.rxrst_ctl.rx_rst_sm_cs }
gui_set_radix -radix {state} -signals {V1:top.dut.u_c3aibadapt_wrap.c3aibadapt.adapt_txchnl.txrst_ctl.tx_rst_sm_cs}
gui_set_radix -radix {state} -signals {V1:top.dut.u_c3aibadapt_wrap.c3aibadapt.adapt_rxchnl.rxrst_ctl.rx_rst_sm_cs}

set _session_group_32 slave
gui_sg_create "$_session_group_32"
set slave "$_session_group_32"

gui_sg_addsignal -group "$_session_group_32" { top.s10_wrap.ndut.hdpldadapt.hdpldadapt_tx_chnl.hdpldadapt_txrst_ctl.tx_rst_sm_cs top.s10_wrap.ndut.hdpldadapt.hdpldadapt_rx_chnl.hdpldadapt_rxrst_ctl.rx_rst_sm_cs }
gui_set_radix -radix {state} -signals {V1:top.s10_wrap.ndut.hdpldadapt.hdpldadapt_tx_chnl.hdpldadapt_txrst_ctl.tx_rst_sm_cs}
gui_set_radix -radix {state} -signals {V1:top.s10_wrap.ndut.hdpldadapt.hdpldadapt_rx_chnl.hdpldadapt_rxrst_ctl.rx_rst_sm_cs}

set _session_group_33 Group1
gui_sg_create "$_session_group_33"
set Group1 "$_session_group_33"

gui_sg_addsignal -group "$_session_group_33" { top.dut.u_c3aibadapt_wrap.c3aibadapt.adapt_txchnl.tx_datapath.txdp_fifo.rd_clk top.dut.u_c3aibadapt_wrap.c3aibadapt.adapt_txchnl.txclk_ctl.tx_clock_tx_transfer_div2_clk top.s10_wrap.tx_parallel_data top.s10_wrap.ndut.aibnd_top_wrp.aib_fabric_rx_data_in top.s10_wrap.ndut.aibnd_top_wrp.aib_fabric_tx_data_out top.dut.u_c3aibadapt_wrap.c3aibadapt.i_aib_tx_data top.dut.u_c3aibadapt_wrap.c3aibadapt.adapt_txchnl.aib_hssi_tx_data_lpbk top.dut.u_c3aibadapt_wrap.c3aibadapt.adapt_rxchnl.rx_datapath.wm_data top.dut.u_c3aibadapt_wrap.c3aibadapt.adapt_rxchnl.rx_datapath.fifo_data_in top.dut.u_c3aibadapt_wrap.c3aibadapt.adapt_rxchnl.rx_datapath.rxdp_fifo.aib_hssi_rx_data_out top.dut.u_c3aibadapt_wrap.c3aibadapt.adapt_rxchnl.rx_datapath.rxdp_fifo.wr_clk top.dut.u_c3aibadapt_wrap.c3aibadapt.adapt_rxchnl.rx_datapath.r_rx_adapter_lpbk_mode }

set _session_group_34 {Drivers: V1:top.dut.u_c3aibadapt_wrap.c3aibadapt.adapt_rxchnl.rx_datapath.wm_data[79:0]@11119840000}
gui_sg_create "$_session_group_34"
set {Drivers: V1:top.dut.u_c3aibadapt_wrap.c3aibadapt.adapt_rxchnl.rx_datapath.wm_data[79:0]@11119840000} "$_session_group_34"

gui_sg_addsignal -group "$_session_group_34" { top.dut.u_c3aibadapt_wrap.c3aibadapt.adapt_rxchnl.rx_datapath.wm_data top.dut.u_c3aibadapt_wrap.c3aibadapt.adapt_rxchnl.rx_datapath.tx_fifo_data_lpbk top.dut.u_c3aibadapt_wrap.c3aibadapt.adapt_rxchnl.rx_datapath.r_rx_adapter_lpbk_mode top.dut.u_c3aibadapt_wrap.c3aibadapt.adapt_rxchnl.rx_datapath.r_rx_aib_lpbk_en {top.dut.u_c3aibadapt_wrap.c3aibadapt.adapt_rxchnl.rx_datapath.word_marker_data[38:0]} {top.dut.u_c3aibadapt_wrap.c3aibadapt.adapt_rxchnl.rx_datapath.word_marker_data[77:39]} }

# Global: Highlighting
gui_highlight_signals -color #00ff00 {{top.dut.u_c3aibadapt_wrap.c3aibadapt.adapt_rxchnl.rx_datapath.tx_fifo_data_lpbk[79:0]}}

# Global: Stack
gui_change_stack_mode -mode list

# Post database loading setting...

# Restore C1 time
gui_set_time -C1_only 11121.210919



# Save global setting...

# Wave/List view global setting
gui_cov_show_value -switch false

# Close all empty TopLevel windows
foreach __top [gui_ekki_get_window_ids -type TopLevel] {
    if { [llength [gui_ekki_get_window_ids -parent $__top]] == 0} {
        gui_close_window -window $__top
    }
}
gui_set_loading_session_type noSession
# DVE View/pane content session: 


# Hier 'Hier.1'
gui_show_window -window ${Hier.1}
gui_list_set_filter -id ${Hier.1} -list { {Package 1} {All 0} {Process 1} {VirtPowSwitch 0} {UnnamedProcess 1} {UDP 0} {Function 1} {Block 1} {SrsnAndSpaCell 0} {OVA Unit 1} {LeafScCell 1} {LeafVlgCell 1} {Interface 1} {LeafVhdCell 1} {$unit 1} {NamedBlock 1} {Task 1} {VlgPackage 1} {ClassDef 1} {VirtIsoCell 0} }
gui_list_set_filter -id ${Hier.1} -text {*}
gui_hier_list_init -id ${Hier.1}
gui_change_design -id ${Hier.1} -design V1
catch {gui_list_expand -id ${Hier.1} top}
catch {gui_list_expand -id ${Hier.1} top.dut}
catch {gui_list_expand -id ${Hier.1} top.dut.u_c3aibadapt_wrap}
catch {gui_list_select -id ${Hier.1} {top.dut.u_c3aibadapt_wrap.c3aibadapt}}
gui_view_scroll -id ${Hier.1} -vertical -set 2789
gui_view_scroll -id ${Hier.1} -horizontal -set 0

# Data 'Data.1'
gui_list_set_filter -id ${Data.1} -list { {Buffer 0} {Input 1} {Others 0} {Linkage 0} {Output 0} {LowPower 0} {Parameter 0} {All 0} {Aggregate 0} {LibBaseMember 1} {Event 0} {Assertion 0} {Constant 0} {Interface 0} {BaseMembers 1} {Signal 0} {$unit 0} {Inout 0} {Variable 0} }
gui_list_set_filter -id ${Data.1} -text {*}
gui_list_show_data -id ${Data.1} {top.dut.u_c3aibadapt_wrap.c3aibadapt}
gui_view_scroll -id ${Data.1} -vertical -set 0
gui_view_scroll -id ${Data.1} -horizontal -set 0
gui_view_scroll -id ${Hier.1} -vertical -set 2789
gui_view_scroll -id ${Hier.1} -horizontal -set 0

# Source 'Source.1'
gui_src_value_annotate -id ${Source.1} -switch false
gui_set_env TOGGLE::VALUEANNOTATE 0
gui_open_source -id ${Source.1}  -replace -active top.dut.u_c3aibadapt_wrap.c3aibadapt.adapt_rxchnl.rx_datapath /data/juzhang/aib_phy_hardware/rev1/aib_lib/c3aibadapt/rtl/c3aibadapt_rxchnl/c3aibadapt_rxdp.v
gui_src_value_annotate -id ${Source.1} -switch true
gui_set_env TOGGLE::VALUEANNOTATE 1
gui_view_scroll -id ${Source.1} -vertical -set 5250
gui_src_set_reusable -id ${Source.1}

# View 'Wave.1'
gui_wv_sync -id ${Wave.1} -switch false
set groupExD [gui_get_pref_value -category Wave -key exclusiveSG]
gui_set_pref_value -category Wave -key exclusiveSG -value {false}
set origWaveHeight [gui_get_pref_value -category Wave -key waveRowHeight]
gui_list_set_height -id Wave -height 25
set origGroupCreationState [gui_list_create_group_when_add -wave]
gui_list_create_group_when_add -wave -disable
gui_marker_create -id ${Wave.1} C2 13575.431873
gui_marker_set_ref -id ${Wave.1}  C1
gui_wv_zoom_timerange -id ${Wave.1} 11092.417797 11124.418525
gui_list_add_group -id ${Wave.1} -after {New Group} {ms}
gui_list_add_group -id ${Wave.1} -after {New Group} {slave}
gui_list_add_group -id ${Wave.1} -after {New Group} {Group1}
gui_list_add_group -id ${Wave.1} -after {New Group} {{Drivers: V1:top.dut.u_c3aibadapt_wrap.c3aibadapt.adapt_rxchnl.rx_datapath.wm_data[79:0]@11119840000}}
gui_list_expand -id ${Wave.1} top.dut.u_c3aibadapt_wrap.o_ehip_init_status
gui_list_select -id ${Wave.1} {top.dut.u_c3aibadapt_wrap.c3aibadapt.adapt_txchnl.txclk_ctl.tx_clock_tx_transfer_div2_clk }
gui_seek_criteria -id ${Wave.1} {Any Edge}



gui_set_env TOGGLE::DEFAULT_WAVE_WINDOW ${Wave.1}
gui_set_pref_value -category Wave -key exclusiveSG -value $groupExD
gui_list_set_height -id Wave -height $origWaveHeight
if {$origGroupCreationState} {
	gui_list_create_group_when_add -wave -enable
}
if { $groupExD } {
 gui_msg_report -code DVWW028
}
gui_list_set_filter -id ${Wave.1} -list { {Buffer 1} {Input 1} {Others 1} {Linkage 1} {Output 1} {Parameter 1} {All 1} {Aggregate 1} {LibBaseMember 1} {Event 1} {Assertion 1} {Constant 1} {Interface 1} {BaseMembers 1} {Signal 1} {$unit 1} {Inout 1} {Variable 1} }
gui_list_set_filter -id ${Wave.1} -text {*}
gui_list_set_insertion_bar  -id ${Wave.1} -group Group1  -item {top.dut.u_c3aibadapt_wrap.c3aibadapt.adapt_rxchnl.rx_datapath.r_rx_adapter_lpbk_mode[1:0]} -position below

gui_marker_move -id ${Wave.1} {C1} 11121.210919
gui_view_scroll -id ${Wave.1} -vertical -set 423
gui_show_grid -id ${Wave.1} -enable false

# DriverLoad 'DriverLoad.1'
gui_get_drivers -session -id ${DriverLoad.1} -signal top.dut.m_ns_rcv_clk -time 0 -starttime 2006.62
gui_get_drivers -session -id ${DriverLoad.1} -signal {top.s10_wrap.ndut.hdpldadapt.hdpldadapt_rx_chnl.hdpldadapt_rxrst_ctl.rx_rst_sm_cs[2:0]} -time 0 -starttime 2006.62
gui_get_drivers -session -id ${DriverLoad.1} -signal {top.s10_wrap.ndut.hdpldadapt.hdpldadapt_tx_chnl.hdpldadapt_txrst_ctl.tx_rst_sm_cs[2:0]} -time 0 -starttime 2006.62
gui_get_drivers -session -id ${DriverLoad.1} -signal {top.dut.u_c3aibadapt_wrap.c3aibadapt.adapt_txchnl.txrst_ctl.tx_rst_sm_cs[2:0]} -time 10690.24 -starttime 11141.113236
gui_get_drivers -session -id ${DriverLoad.1} -signal top.dut.u_c3aibadapt_wrap.c3aibadapt.adapt_txchnl.txrst_ctl.sync_tx_align_done -time 0 -starttime 11141.113236
gui_get_drivers -session -id ${DriverLoad.1} -signal top.dut.u_c3aibadapt_wrap.c3aibadapt.adapt_txchnl.txrst_ctl.align_done -time 0 -starttime 11141.113236
gui_get_drivers -session -id ${DriverLoad.1} -signal top.dut.u_c3aibadapt_wrap.c3aibadapt.adapt_txchnl.tx_datapath.rd_en_reg -time 0 -starttime 11141.113236
gui_get_drivers -session -id ${DriverLoad.1} -signal top.dut.u_c3aibadapt_wrap.c3aibadapt.adapt_txchnl.tx_datapath.txdp_fifo.rd_clk -time 0 -starttime 11141.113236
gui_get_drivers -session -id ${DriverLoad.1} -signal top.dut.u_c3aibadapt_wrap.c3aibadapt.adapt_txchnl.tx_datapath.tx_clock_fifo_rd_clk -time 0 -starttime 11141.113236
gui_get_drivers -session -id ${DriverLoad.1} -signal {top.dut.u_c3aibadapt_wrap.c3aibadapt.adapt_txchnl.txclk_ctl.tx_fifo_rd_clk_sel[1:0]} -time 166 -starttime 10503.84
gui_get_drivers -session -id ${DriverLoad.1} -signal {top.dut.u_c3aibadapt_wrap.c3aibadapt.adapt_txchnl.txclk_ctl.r_tx_fifo_rd_clk_sel[1:0]} -time 166 -starttime 10503.84
gui_get_drivers -session -id ${DriverLoad.1} -signal {top.dut.u_c3aibadapt_wrap.c3aibadapt.adapt_avmm.avmm1.adapt_avmm1_config.adapt_hwcfg_dec.i_tx_fifo_rd_clk_sel[1:0]} -time 166 -starttime 10503.84
gui_get_drivers -session -id ${DriverLoad.1} -signal top.dut.u_c3aibadapt_wrap.c3aibadapt.adapt_rxchnl.rx_datapath.wr_clk -time 0 -starttime 11121.210919
gui_get_drivers -session -id ${DriverLoad.1} -signal top.dut.u_c3aibadapt_wrap.c3aibadapt.adapt_rxchnl.rx_datapath.rx_clock_fifo_wr_clk -time 0 -starttime 11121.210919
gui_get_drivers -session -id ${DriverLoad.1} -signal top.dut.u_c3aibadapt_wrap.c3aibadapt.adapt_rxchnl.rxclk_ctl.q1_rx_clock_fifo_wr_clk -time 0 -starttime 11121.210919
gui_get_drivers -session -id ${DriverLoad.1} -signal {top.dut.u_c3aibadapt_wrap.c3aibadapt.adapt_rxchnl.rx_datapath.wm_data[79:0]} -time 11119.84 -starttime 11121.210919
# Restore toplevel window zorder
# The toplevel window could be closed if it has no view/pane
if {[gui_exist_window -window ${TopLevel.1}]} {
	gui_set_active_window -window ${TopLevel.1}
	gui_set_active_window -window ${Wave.1}
}
#</Session>

