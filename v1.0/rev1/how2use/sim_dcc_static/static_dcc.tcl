# Begin_DVE_Session_Save_Info
# DVE view(Wave.1 ) session
# Saved on Tue Jul 7 20:19:57 2020
# Toplevel windows open: 1
# 	TopLevel.1
#   Wave.1: 23 signals
# End_DVE_Session_Save_Info

# DVE version: P-2019.06-SP1-1_Full64
# DVE build date: Oct 22 2019 21:07:43


#<Session mode="View" path="/data/juzhang/aib_phy_hardware/rev1/how2use/sim_dcc_static/static_dcc.tcl" type="Debug">

#<Database>

gui_set_time_units 1ns
#</Database>

# DVE View/pane content session: 

# Begin_DVE_Session_Save_Info (Wave.1)
# DVE wave signals session
# Saved on Tue Jul 7 20:19:57 2020
# 23 signals
# End_DVE_Session_Save_Info

# DVE version: P-2019.06-SP1-1_Full64
# DVE build date: Oct 22 2019 21:07:43


#Add ncecessay scopes
gui_load_child_values {top.dut.u_c3aibadapt_wrap.xaibcr3_top_wrp.xaibcr3_top.xrxdatapath_rx.x1591.I82.I1}
gui_load_child_values {top.dut.u_c3aibadapt_wrap.c3aibadapt.adapt_avmm.avmm1.adapt_avmm1_config.adapt_usr_csr}
gui_load_child_values {top.dut.u_c3aibadapt_wrap.xaibcr3_top_wrp.xaibcr3_top.xrxdatapath_rx}

gui_set_time_units 1ns

set _wave_session_group_1 {dcc correction}
if {[gui_sg_is_group -name "$_wave_session_group_1"]} {
    set _wave_session_group_1 [gui_sg_generate_new_name]
}
set Group1 "$_wave_session_group_1"

gui_sg_addsignal -group "$_wave_session_group_1" { {V1:top.dut.u_c3aibadapt_wrap.i_rx_pma_clk} {V1:top.dut.u_c3aibadapt_wrap.xaibcr3_top_wrp.xaibcr3_top.xrxdatapath_rx.x1591.clk_dcd} {V1:top.dut.u_c3aibadapt_wrap.xaibcr3_top_wrp.xaibcr3_top.xrxdatapath_rx.x1591.clk_dcc} {V1:top.dut.u_c3aibadapt_wrap.xaibcr3_top_wrp.xaibcr3_top.xrxdatapath_rx.x1591.dcc_done} }

set _wave_session_group_2 Group2
if {[gui_sg_is_group -name "$_wave_session_group_2"]} {
    set _wave_session_group_2 [gui_sg_generate_new_name]
}
set Group2 "$_wave_session_group_2"

gui_sg_addsignal -group "$_wave_session_group_2" { {V1:top.dut.u_c3aibadapt_wrap.xaibcr3_top_wrp.xaibcr3_top.xrxdatapath_rx.x1591.csr_reg[50]} {V1:top.dut.u_c3aibadapt_wrap.xaibcr3_top_wrp.xaibcr3_top.xrxdatapath_rx.x1591.I82.I1.csr_reg} {V1:top.dut.u_c3aibadapt_wrap.c3aibadapt.adapt_avmm.avmm1.adapt_avmm1_config.adapt_hwcfg_dec.o_aib_csr_ctrl_28} {V1:top.dut.u_c3aibadapt_wrap.c3aibadapt.adapt_avmm.avmm1.adapt_avmm1_config.adapt_hwcfg_dec.r_ifctl_hwcfg_aib_en} {V1:top.dut.u_c3aibadapt_wrap.xaibcr3_top_wrp.xaibcr3_top.xrxdatapath_rx.x1591.csr_reg} {V1:top.dut.u_c3aibadapt_wrap.xaibcr3_top_wrp.xaibcr3_top.xrxdatapath_rx.x1591.I82.I1.rb_ctl_static} {V1:top.dut.u_c3aibadapt_wrap.i_cfg_avmm_write} {V1:top.dut.u_c3aibadapt_wrap.i_cfg_avmm_wdata} {V1:top.dut.u_c3aibadapt_wrap.i_cfg_avmm_addr} }
gui_set_radix -radix {hex} -signals {V1:top.dut.u_c3aibadapt_wrap.xaibcr3_top_wrp.xaibcr3_top.xrxdatapath_rx.x1591.I82.I1.rb_ctl_static}
gui_set_radix -radix {unsigned} -signals {V1:top.dut.u_c3aibadapt_wrap.xaibcr3_top_wrp.xaibcr3_top.xrxdatapath_rx.x1591.I82.I1.rb_ctl_static}

set _wave_session_group_3 {dcc enable}
if {[gui_sg_is_group -name "$_wave_session_group_3"]} {
    set _wave_session_group_3 [gui_sg_generate_new_name]
}
set Group3 "$_wave_session_group_3"

gui_sg_addsignal -group "$_wave_session_group_3" { {V1:top.dut.u_c3aibadapt_wrap.xaibcr3_top_wrp.xaibcr3_top.xrxdatapath_rx.rb_dcc_byp_dprio} {V1:top.dut.u_c3aibadapt_wrap.xaibcr3_top_wrp.xaibcr3_top.xrxdatapath_rx.rb_dcc_en_dprio} }

set _wave_session_group_4 {dcc static setting}
if {[gui_sg_is_group -name "$_wave_session_group_4"]} {
    set _wave_session_group_4 [gui_sg_generate_new_name]
}
set Group4 "$_wave_session_group_4"

gui_sg_addsignal -group "$_wave_session_group_4" { {V1:top.dut.u_c3aibadapt_wrap.xaibcr3_top_wrp.xaibcr3_top.xrxdatapath_rx.x1591.csr_reg[17]} {V1:top.dut.u_c3aibadapt_wrap.xaibcr3_top_wrp.xaibcr3_top.xrxdatapath_rx.x1591.I82.I1.rb_ctlsel} {V1:top.dut.u_c3aibadapt_wrap.xaibcr3_top_wrp.xaibcr3_top.xrxdatapath_rx.x1591.I82.I1.rb_ctl_static} }
gui_set_radix -radix {hex} -signals {V1:top.dut.u_c3aibadapt_wrap.xaibcr3_top_wrp.xaibcr3_top.xrxdatapath_rx.x1591.I82.I1.rb_ctl_static}
gui_set_radix -radix {unsigned} -signals {V1:top.dut.u_c3aibadapt_wrap.xaibcr3_top_wrp.xaibcr3_top.xrxdatapath_rx.x1591.I82.I1.rb_ctl_static}

set _wave_session_group_5 Group3
if {[gui_sg_is_group -name "$_wave_session_group_5"]} {
    set _wave_session_group_5 [gui_sg_generate_new_name]
}
set Group5 "$_wave_session_group_5"

gui_sg_addsignal -group "$_wave_session_group_5" { {V1:top.dut.u_c3aibadapt_wrap.c3aibadapt.adapt_avmm.avmm1.adapt_avmm1_config.adapt_usr_csr.r_aibdprio0_aib_dprio0_ctrl_3} }

set _wave_session_group_6 Group4
if {[gui_sg_is_group -name "$_wave_session_group_6"]} {
    set _wave_session_group_6 [gui_sg_generate_new_name]
}
set Group6 "$_wave_session_group_6"

gui_sg_addsignal -group "$_wave_session_group_6" { {V1:top.dut.u_c3aibadapt_wrap.xaibcr3_top_wrp.xaibcr3_top.xrxdatapath_rx.rb_dcc_byp} {V1:top.dut.u_c3aibadapt_wrap.xaibcr3_top_wrp.xaibcr3_top.xrxdatapath_rx.rb_dcc_byp_dprio} {V1:top.dut.u_c3aibadapt_wrap.xaibcr3_top_wrp.xaibcr3_top.xrxdatapath_rx.rb_dcc_byp_inv} {V1:top.dut.u_c3aibadapt_wrap.xaibcr3_top_wrp.xaibcr3_top.xrxdatapath_rx.x1591.dcc_done_byp} }
if {![info exists useOldWindow]} { 
	set useOldWindow true
}
if {$useOldWindow && [string first "Wave" [gui_get_current_window -view]]==0} { 
	set Wave.1 [gui_get_current_window -view] 
} else {
	set Wave.1 [lindex [gui_get_window_ids -type Wave] 0]
if {[string first "Wave" ${Wave.1}]!=0} {
gui_open_window Wave
set Wave.1 [ gui_get_current_window -view ]
}
}

set groupExD [gui_get_pref_value -category Wave -key exclusiveSG]
gui_set_pref_value -category Wave -key exclusiveSG -value {false}
set origWaveHeight [gui_get_pref_value -category Wave -key waveRowHeight]
gui_list_set_height -id Wave -height 25
set origGroupCreationState [gui_list_create_group_when_add -wave]
gui_list_create_group_when_add -wave -disable
gui_marker_create -id ${Wave.1} C2 4981.4
gui_marker_set_ref -id ${Wave.1}  C1
gui_wv_zoom_timerange -id ${Wave.1} 4978.092039 4988.134916
gui_list_add_group -id ${Wave.1} -after {New Group} [list ${Group1}]
gui_list_add_group -id ${Wave.1} -after {New Group} [list ${Group2}]
gui_list_add_group -id ${Wave.1} -after {New Group} [list ${Group3}]
gui_list_add_group -id ${Wave.1} -after {New Group} [list ${Group4}]
gui_list_add_group -id ${Wave.1} -after {New Group} [list ${Group5}]
gui_list_add_group -id ${Wave.1} -after {New Group} [list ${Group6}]
gui_list_collapse -id ${Wave.1} ${Group3}
gui_list_collapse -id ${Wave.1} ${Group5}
gui_list_collapse -id ${Wave.1} ${Group6}
gui_list_select -id ${Wave.1} {top.dut.u_c3aibadapt_wrap.xaibcr3_top_wrp.xaibcr3_top.xrxdatapath_rx.x1591.I82.I1.rb_ctl_static }
gui_seek_criteria -id ${Wave.1} {Any Edge}


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
gui_list_set_insertion_bar  -id ${Wave.1} -group ${Group2}  -item {top.dut.u_c3aibadapt_wrap.i_cfg_avmm_addr[16:0]} -position below

gui_marker_move -id ${Wave.1} {C1} 4980.4
gui_view_scroll -id ${Wave.1} -vertical -set 0
gui_show_grid -id ${Wave.1} -enable false
#</Session>

