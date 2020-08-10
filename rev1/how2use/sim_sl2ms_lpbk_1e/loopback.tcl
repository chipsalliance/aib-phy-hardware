# Begin_DVE_Session_Save_Info
# DVE full session
# Saved on Tue Jul 14 15:56:24 2020
# Designs open: 1
#   V1: vcdplus.vpd
# Toplevel windows open: 1
# 	TopLevel.1
#   Source.1: top.dut.u_c3aibadapt_wrap.c3aibadapt.adapt_avmm.avmm1.adapt_avmm1_config.adapt_usr_csr
#   Wave.1: 12 signals
#   Group count = 1
#   Group Group1 signal count = 12
# End_DVE_Session_Save_Info

# DVE version: P-2019.06-SP2-5_Full64
# DVE build date: May 26 2020 20:43:45


#<Session mode="Full" path="/data/juzhang/aib_phy_hardware/rev1/how2use/sim_sl2ms_lpbk/loopback.tcl" type="Debug">

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
gui_show_window -window ${TopLevel.1} -show_state normal -rect {{127 195} {1801 989}}

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
set Console.1 [gui_create_window -type Console -parent ${TopLevel.1} -dock_state bottom -dock_on_new_line true -dock_extent 119]
gui_set_window_pref_key -window ${Console.1} -key dock_width -value_type integer -value -1
gui_set_window_pref_key -window ${Console.1} -key dock_height -value_type integer -value 119
gui_set_window_pref_key -window ${Console.1} -key dock_offset -value_type integer -value 0
gui_update_layout -id ${Console.1} {{left 0} {top 0} {width 271} {height 179} {dock_state bottom} {dock_on_new_line true}}
set DriverLoad.1 [gui_create_window -type DriverLoad -parent ${TopLevel.1} -dock_state bottom -dock_on_new_line false -dock_extent 180]
gui_set_window_pref_key -window ${DriverLoad.1} -key dock_width -value_type integer -value 150
gui_set_window_pref_key -window ${DriverLoad.1} -key dock_height -value_type integer -value 180
gui_set_window_pref_key -window ${DriverLoad.1} -key dock_offset -value_type integer -value 0
gui_update_layout -id ${DriverLoad.1} {{left 0} {top 0} {width 1402} {height 179} {dock_state bottom} {dock_on_new_line false}}
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
gui_update_layout -id ${HSPane.1} {{show_state maximized} {dock_state undocked} {dock_on_new_line false} {child_hier_colhier 1036} {child_hier_coltype 638} {child_hier_colpd 0} {child_hier_col1 0} {child_hier_col2 1} {child_hier_col3 -1}}
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
gui_update_layout -id ${Wave.1} {{show_state maximized} {dock_state undocked} {dock_on_new_line false} {child_wave_left 451} {child_wave_right 1218} {child_wave_colname 317} {child_wave_colvalue 130} {child_wave_col1 0} {child_wave_col2 1}}

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
gui_load_child_values {top.s10_wrap}


set _session_group_2 Group1
gui_sg_create "$_session_group_2"
set Group1 "$_session_group_2"

gui_sg_addsignal -group "$_session_group_2" { top.s10_wrap.tx_parallel_data top.s10_wrap.rx_parallel_data top.dut.u_c3aibadapt_wrap.c3aibadapt.adapt_rxchnl.rx_datapath.r_rx_aib_lpbk_en top.dut.u_c3aibadapt_wrap.c3aibadapt.adapt_rxchnl.rx_datapath.r_rx_adapter_lpbk_mode top.dut.u_c3aibadapt_wrap.c3aibadapt.adapt_rxchnl.aib_hssi_rx_data_out top.dut.u_c3aibadapt_wrap.c3aibadapt.adapt_rxchnl.aib_hssi_tx_data_lpbk_reg top.dut.u_c3aibadapt_wrap.c3aibadapt.adapt_rxchnl.rx_clock_reset_fifo_rd_clk top.dut.u_c3aibadapt_wrap.c3aibadapt.aib_hssi_tx_data_lpbk top.dut.u_c3aibadapt_wrap.c3aibadapt.adapt_rxchnl.rxclk_ctl.rx_fifo_rd_clk_sel top.dut.u_c3aibadapt_wrap.c3aibadapt.adapt_rxchnl.r_rx_fifo_mode top.dut.u_c3aibadapt_wrap.c3aibadapt.adapt_avmm.avmm1.adapt_avmm1_config.adapt_usr_csr.r_dprio0_rx_fifo_mode top.dut.u_c3aibadapt_wrap.c3aibadapt.adapt_avmm.avmm1.adapt_avmm1_config.adapt_usr_csr.r_dprio0_tx_chnl_dp_map_mode }

# Global: Highlighting

# Global: Stack
gui_change_stack_mode -mode list

# Post database loading setting...

# Restore C1 time
gui_set_time -C1_only 3002.5



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
catch {gui_list_expand -id ${Hier.1} top.dut.u_c3aibadapt_wrap.c3aibadapt}
catch {gui_list_expand -id ${Hier.1} top.dut.u_c3aibadapt_wrap.c3aibadapt.adapt_rxchnl}
catch {gui_list_select -id ${Hier.1} {top.dut.u_c3aibadapt_wrap.c3aibadapt.adapt_rxchnl.rx_datapath}}
gui_view_scroll -id ${Hier.1} -vertical -set 2995
gui_view_scroll -id ${Hier.1} -horizontal -set 0

# Data 'Data.1'
gui_list_set_filter -id ${Data.1} -list { {Buffer 0} {Input 1} {Others 0} {Linkage 0} {Output 0} {LowPower 0} {Parameter 0} {All 0} {Aggregate 0} {LibBaseMember 1} {Event 0} {Assertion 0} {Constant 0} {Interface 0} {BaseMembers 1} {Signal 0} {$unit 0} {Inout 0} {Variable 0} }
gui_list_set_filter -id ${Data.1} -text {*}
gui_list_show_data -id ${Data.1} {top.dut.u_c3aibadapt_wrap.c3aibadapt.adapt_rxchnl.rx_datapath}
gui_view_scroll -id ${Data.1} -vertical -set 0
gui_view_scroll -id ${Data.1} -horizontal -set 0
gui_view_scroll -id ${Hier.1} -vertical -set 2995
gui_view_scroll -id ${Hier.1} -horizontal -set 0

# Source 'Source.1'
gui_src_value_annotate -id ${Source.1} -switch false
gui_set_env TOGGLE::VALUEANNOTATE 0
gui_open_source -id ${Source.1}  -replace -active top.dut.u_c3aibadapt_wrap.c3aibadapt.adapt_avmm.avmm1.adapt_avmm1_config.adapt_usr_csr /data/juzhang/aib_phy_hardware/rev1/aib_lib/c3aibadapt/rtl/c3aibadapt_avmm/c3aibadapt_usr_csr.v
gui_src_value_annotate -id ${Source.1} -switch true
gui_set_env TOGGLE::VALUEANNOTATE 1
gui_view_scroll -id ${Source.1} -vertical -set 6885
gui_src_set_reusable -id ${Source.1}

# View 'Wave.1'
gui_wv_sync -id ${Wave.1} -switch false
set groupExD [gui_get_pref_value -category Wave -key exclusiveSG]
gui_set_pref_value -category Wave -key exclusiveSG -value {false}
set origWaveHeight [gui_get_pref_value -category Wave -key waveRowHeight]
gui_list_set_height -id Wave -height 25
set origGroupCreationState [gui_list_create_group_when_add -wave]
gui_list_create_group_when_add -wave -disable
gui_marker_create -id ${Wave.1} C2 3007.5
gui_marker_set_ref -id ${Wave.1}  C1
gui_wv_zoom_timerange -id ${Wave.1} 0 3652.5
gui_list_add_group -id ${Wave.1} -after {New Group} {Group1}
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
gui_list_set_insertion_bar  -id ${Wave.1} -group Group1  -position in

gui_marker_move -id ${Wave.1} {C1} 3002.5
gui_view_scroll -id ${Wave.1} -vertical -set 0
gui_show_grid -id ${Wave.1} -enable false

# DriverLoad 'DriverLoad.1'
gui_get_drivers -session -id ${DriverLoad.1} -signal {top.dut.u_c3aibadapt_wrap.c3aibadapt.aib_hssi_tx_data_lpbk[39:0]} -time 3001.37 -starttime 3002.5
gui_get_drivers -session -id ${DriverLoad.1} -signal {top.dut.u_c3aibadapt_wrap.c3aibadapt.adapt_txchnl.aib_hssi_tx_data_in[39:0]} -time 3001.37 -starttime 3002.5
gui_get_drivers -session -id ${DriverLoad.1} -signal {top.dut.u_c3aibadapt_wrap.c3aibadapt.adapt_rxchnl.aib_hssi_tx_data_lpbk_reg[39:0]} -time 3001.37 -starttime 3002.5
gui_get_drivers -session -id ${DriverLoad.1} -signal top.dut.u_c3aibadapt_wrap.c3aibadapt.adapt_rxchnl.rx_clock_reset_fifo_rd_clk -time 3001.37 -starttime 3002.5
gui_get_drivers -session -id ${DriverLoad.1} -signal top.dut.u_c3aibadapt_wrap.c3aibadapt.adapt_rxchnl.rxclk_ctl.rx_clock_fifo_rd_clk_mux -time 3001.37 -starttime 3002.5
gui_get_drivers -session -id ${DriverLoad.1} -signal top.dut.u_c3aibadapt_wrap.c3aibadapt.adapt_rxchnl.rxclk_ctl.tx_aib_transfer_clk -time 3001.37 -starttime 3002.5
gui_get_drivers -session -id ${DriverLoad.1} -signal {top.dut.u_c3aibadapt_wrap.c3aibadapt.adapt_rxchnl.aib_hssi_tx_data_lpbk_reg[39:0]} -time 3001.37 -starttime 3002.5
gui_get_drivers -session -id ${DriverLoad.1} -signal {top.dut.u_c3aibadapt_wrap.c3aibadapt.adapt_rxchnl.r_rx_fifo_mode[1:0]} -time 0 -starttime 3002.5
gui_get_drivers -session -id ${DriverLoad.1} -signal {top.dut.u_c3aibadapt_wrap.c3aibadapt.adapt_avmm.avmm1.adapt_avmm1_config.adapt_hwcfg_dec.i_rx_fifo_mode[1:0]} -time 0 -starttime 3002.5
# Restore toplevel window zorder
# The toplevel window could be closed if it has no view/pane
if {[gui_exist_window -window ${TopLevel.1}]} {
	gui_set_active_window -window ${TopLevel.1}
	gui_set_active_window -window ${Wave.1}
}
#</Session>

