set AIB_LIB ../../aib_lib
set MODEL_RTL ../../rtl 

vlog +acc -sv $AIB_LIB/c3lib/rtl/defines/c3lib_dv_defines.sv +incdir+$AIB_LIB/c3lib/rtl/defines
vlog +acc -sv $AIB_LIB/c3dfx/rtl/defines/c3dfx.vh +incdir+$AIB_LIB/c3dfx/rtl/defines

## pointer to standalone DCC - DCC, c3 and DLL pnr block
vlog +acc -sv $AIB_LIB/aibcr3_lib/rtl/aibcr3_dcc_8ph_intp.v
vlog +acc  $AIB_LIB/aibcr3_lib/rtl/aibcr3_dcc_crsdlyline.v
vlog +acc  $AIB_LIB/aibcr3_lib/rtl/aibcr3_dcc_dll.v
vlog +acc  $AIB_LIB/aibcr3_lib/rtl/aibcr3_dcc_dlyline64.v
vlog +acc  $AIB_LIB/aibcr3_lib/rtl/aibcr3_dcc_dlyline.v
vlog +acc  $AIB_LIB/aibcr3_lib/rtl/aibcr3_dcc_dly.v
vlog +acc  $AIB_LIB/aibcr3_lib/rtl/aibcr3_dcc_gry2thm64.v
vlog +acc  $AIB_LIB/aibcr3_lib/rtl/aibcr3_dcc_helper.v
vlog +acc  $AIB_LIB/aibcr3_lib/rtl/aibcr3_dcc_interpolator.v
vlog +acc  $AIB_LIB/aibcr3_lib/rtl/aibcr3_dcc_phasedet.v
vlog +acc  $AIB_LIB/aibcr3_lib/rtl/aibcr3_dcc_top.v
vlog +acc  $AIB_LIB/aibcr3_lib/rtl/aibcr3_dll_custom.v
vlog +acc  $AIB_LIB/aibcr3_lib/rtl/aibcr3_dll_lock_dly.v
vlog +acc  $AIB_LIB/aibcr3_lib/rtl/aibcr3_dlycell_dcc.v
vlog +acc  $AIB_LIB/aibcr3_lib/rtl/aibcr3_svt16_scdffcdn_cust.v
vlog +acc  $AIB_LIB/aibcr3_lib/rtl/aibcr3_svt16_scdffsdn_cust.v
vlog +acc  $AIB_LIB/aibcr3_lib/rtl/aibcr3_ulvt16_2xarstsyncdff1_b2.v
vlog +acc  $AIB_LIB/aibcr3_lib/rtl/aibcr3_ulvt16_dffcdn_cust.v
vlog +acc  $AIB_LIB/aibcr3_lib/rtl/aibcr3_io_cmos_nand_x64.v

##aibcr3 model

vlog +acc -sv $AIB_LIB/aibcr3_lib/rtl/aibcr3_top_wrp.v

## this section is for strobe align circuits

vlog +acc -sv $AIB_LIB/aibcr3_lib/rtl/aibcr3_str_align.v
vlog +acc -sv $AIB_LIB/aibcr3_lib/rtl/aibcr3_clktree_mimic.v
vlog +acc -sv $AIB_LIB/aibcr3_lib/rtl/aibcr3_clktree.v
vlog +acc -sv $AIB_LIB/aibcr3_lib/rtl/aibcr3_cmos_nand_x64.v 
vlog +acc -sv $AIB_LIB/aibcr3_lib/rtl/aibcr3_dll_8ph_intp.v
vlog +acc -sv $AIB_LIB/aibcr3_lib/rtl/aibcr3_dll_dlyline64.v
vlog +acc -sv $AIB_LIB/aibcr3_lib/rtl/aibcr3_dll_gry2thm64.v
vlog +acc -sv $AIB_LIB/aibcr3_lib/rtl/aibcr3_dll_ibkmux.v
vlog +acc -sv $AIB_LIB/aibcr3_lib/rtl/aibcr3_dlycell_dll.v 
vlog +acc -sv $AIB_LIB/aibcr3_lib/rtl/aibcr3_dlycell_dll_c.v

## other aibcr models
vlog +acc  $AIB_LIB/aibcr3_lib/rtl/aibcr3_scan_iomux.v
vlog +acc  $AIB_LIB/aibcr3_lib/rtl/aibcr3_2to4dec.v
vlog +acc  $AIB_LIB/aibcr3_lib/rtl/aibcr3_analog.v
vlog +acc  $AIB_LIB/aibcr3_lib/rtl/aibcr3_avmm1.v
vlog +acc  $AIB_LIB/aibcr3_lib/rtl/aibcr3_avmm2.v
vlog +acc  $AIB_LIB/aibcr3_lib/rtl/aibcr3_buffx1_top.v
vlog +acc  $AIB_LIB/aibcr3_lib/rtl/aibcr3_buffx1.v
vlog +acc  $AIB_LIB/aibcr3_lib/rtl/aibcr3_clktree_avmm_mimic.v
vlog +acc  $AIB_LIB/aibcr3_lib/rtl/aibcr3_clktree_avmm_pcs.v
vlog +acc  $AIB_LIB/aibcr3_lib/rtl/aibcr3_clktree_avmm.v
vlog +acc  $AIB_LIB/aibcr3_lib/rtl/aibcr3_clktree_pcs.v
vlog +acc  $AIB_LIB/aibcr3_lib/rtl/aibcr3_cmos_fine_dly.v
vlog +acc  $AIB_LIB/aibcr3_lib/rtl/aibcr3_cmos_nand_x1.v
vlog +acc  $AIB_LIB/aibcr3_lib/rtl/aibcr3_io_ip8phs.v
vlog +acc  $AIB_LIB/aibcr3_lib/rtl/aibcr3_digital.v
vlog +acc  $AIB_LIB/aibcr3_lib/rtl/aibcr3_inv_split_align.v
vlog +acc  $AIB_LIB/aibcr3_lib/rtl/aibcr3_lvshift.v
vlog +acc  $AIB_LIB/aibcr3_lib/rtl/aibcr3_preclkbuf.v
vlog +acc  $AIB_LIB/aibcr3_lib/rtl/aibcr3_quadph_code_gen.v
vlog +acc  $AIB_LIB/aibcr3_lib/rtl/aibcr3_rxanlg.v
vlog +acc  $AIB_LIB/aibcr3_lib/rtl/aibcr3_rxdatapath_rx.v
vlog +acc  $AIB_LIB/aibcr3_lib/rtl/aibcr3_rxdig.v
vlog +acc  $AIB_LIB/aibcr3_lib/rtl/aibcr3_top.v
vlog +acc  $AIB_LIB/aibcr3_lib/rtl/aibcr3_txanlg.v
vlog +acc  $AIB_LIB/aibcr3_lib/rtl/aibcr3_txdatapath_tx.v
vlog +acc  $AIB_LIB/aibcr3_lib/rtl/aibcr3_txdig.v
vlog +acc  $AIB_LIB/aibcr3_lib/rtl/aibcr3_nd2d0_custom.v
vlog +acc  $AIB_LIB/aibcr3_lib/rtl/aibcr3_split_align.v
vlog +acc  $AIB_LIB/aibcr3_lib/rtl/structured.v

## NEW for converted RTL (removed logic cells)

vlog +acc -sv $AIB_LIB/aibcr3_lib/rtl/aibcr3_ff_r.v
vlog +acc -sv $AIB_LIB/aibcr3_lib/rtl/aibcr3_ff_p.v
vlog +acc -sv $AIB_LIB/aibcr3_lib/rtl/aibcr3_ff_rp.v
vlog +acc -sv $AIB_LIB/aibcr3_lib/rtl/aibcr3_latch.v


## NEW REL3.5

vlog +acc -sv $AIB_LIB/aibcr3_lib/rtl/aibcr3_red_custom_dig.v
vlog +acc -sv $AIB_LIB/aibcr3_lib/rtl/aibcr3_str_ff.v
vlog +acc -sv $AIB_LIB/aibcr3_lib/rtl/aibcr3_sync_ff.v


##newly added

vlog +acc -sv $AIB_LIB/aibcr3_lib/rtl/aibcr3_dcc_top_dummy.v
vlog +acc -sv $AIB_LIB/aibcr3_lib/rtl/aibcr3_esd.v


##NEW REL4.0

vlog +acc -sv $AIB_LIB/aibcr3_lib/rtl/aibcr3_str_ioload.v
vlog +acc -sv $AIB_LIB/aibcr3_lib/rtl/aibcr3_red_custom_dig2.v
vlog +acc -sv $AIB_LIB/aibcr3_lib/rtl/aibcr3_red_clkmux2.v
vlog +acc -sv $AIB_LIB/aibcr3_lib/rtl/aibcr3_red_clkmux3.v
vlog +acc -sv $AIB_LIB/aibcr3_lib/rtl/aibcr3_lvshift_lospeed.v
vlog +acc -sv $AIB_LIB/aibcr3_lib/rtl/aibcr3_lvshift_diff.v
vlog +acc -sv $AIB_LIB/aibcr3_lib/rtl/aibcr3_triinv_dig.v
vlog +acc -sv $AIB_LIB/aibcr3_lib/rtl/aibcr3_interface.v
vlog +acc -sv $AIB_LIB/aibcr3_lib/rtl/aibcr3_rambit_buf.v
vlog +acc -sv $AIB_LIB/aibcr3_lib/rtl/aibcr3_signal_buf.v
vlog +acc -sv $AIB_LIB/aibcr3_lib/rtl/aibcr3_data_buf.v
vlog +acc -sv $AIB_LIB/aibcr3_lib/rtl/aibcr3_rxdat_mimic.v
vlog +acc -sv $AIB_LIB/aibcr3_lib/rtl/aibcr3_txdat_mimic.v


vlog +acc -sv $AIB_LIB/aibcr3_lib/rtl/aibcr3_dcc_dly_rep.v
vlog +acc -sv $AIB_LIB/aibcr3_lib/rtl/aibcr3_dly_mimic.v
vlog +acc -sv $AIB_LIB/aibcr3_lib/rtl/aibcr3_io_cmos_8ph_interpolator_rep.v
vlog +acc -sv $AIB_LIB/aibcr3_lib/rtl/aibcr3_io_cmos_8ph_interpolator.v
vlog +acc -sv $AIB_LIB/aibcr3_lib/rtl/aibcr3_io_nand_delay_line_min_rep.v

##copied models due to io_common_custom ND and CR conflict

vlog +acc -sv $AIB_LIB/aibcr3_lib/rtl/aibcr3_io_cmos_nand_x1.v
vlog +acc -sv $AIB_LIB/aibcr3_lib/rtl/aibcr3_io_cmos_nand_x128.v
vlog +acc -sv $AIB_LIB/aibcr3_lib/rtl/aibcr3_io_nand_delay_line_min.v
vlog +acc -sv $AIB_LIB/aibcr3_lib/rtl/aibcr3_io_nand_x128_delay_line.v

##NEW REL4.5
vlog +acc -sv $AIB_LIB/aibcr3_lib/rtl/aibcr3_clkmux2.v


##NEW REL4.5 (replacing syncronizer- 3rd party cell issue)

vlog +acc -sv $AIB_LIB/aibcr3_lib/rtl/aibcr3_sync_2ff.v
vlog +acc -sv $AIB_LIB/aibcr3_lib/rtl/aibcr3_sync_3ff.v

##custom alias model

vlog +acc -sv $AIB_LIB/aibcr3_lib/rtl/aibcr3_aliasv.v
vlog +acc -sv $AIB_LIB/aibcr3_lib/rtl/aibcr3_aliasd.v


vlog +acc -sv $AIB_LIB/aibcr3_lib/rtl/aibcr3_ulvt16_dffsdn_cust.v

## custom esd cells used outside of aibio and aibaux. sits in xcvrcntl
vlog +acc -sv $AIB_LIB/aibcr3_lib/rtl/aibcr3_opio_esd.v
vlog +acc -sv $AIB_LIB/aibcr3_lib/rtl/aibcr3_anaio_esd.v

## update for conformal
vlog +acc -sv $AIB_LIB/aibcr3_lib/rtl/aibcr3_dlycell_dcc_rep.v

vlog +acc -sv $AIB_LIB/c3lib/rtl/basic/pulse_stretch/cdclib_pulse_stretch.sv

vlog +acc -sv $AIB_LIB/c3lib/rtl/avmm/c3_avmm_rdl_intf.sv
vlog +acc -sv $AIB_LIB/c3lib/rtl/avmm/c3lib_cfgcsr_fastslow_pulse_meta.sv
vlog +acc -sv $AIB_LIB/c3lib/rtl/avmm/c3lib_cfgcsr_slowfast_pulse_meta.sv
vlog +acc -sv $AIB_LIB/c3lib/rtl/avmm/c3lib_avmm_pulse_cross.sv

vlog +acc -sv $AIB_LIB/c3lib/rtl/cdc/async_fifo/c3lib_async_fifo.sv

vlog +acc -sv $AIB_LIB/c3lib/rtl/cdc/bit_synchronizer/c3lib_bitsync.sv
vlog +acc -sv $AIB_LIB/c3lib/rtl/cdc/bit_synchronizer/c3lib_sync2_lvt_bitsync.sv
vlog +acc -sv $AIB_LIB/c3lib/rtl/cdc/bit_synchronizer/c3lib_sync2_ulvt_bitsync.sv
vlog +acc -sv $AIB_LIB/c3lib/rtl/cdc/bit_synchronizer/c3lib_sync3_ulvt_bitsync.sv
vlog +acc -sv $AIB_LIB/c3lib/rtl/cdc/gray_code/c3lib_bintogray.sv
vlog +acc -sv $AIB_LIB/c3lib/rtl/cdc/gray_code/c3lib_graytobin.sv
vlog +acc -sv $AIB_LIB/c3lib/rtl/cdc/level_synchronizer/c3lib_lvlsync.sv
vlog +acc -sv $AIB_LIB/c3lib/rtl/cdc/reset_synchronizer/c3lib_rstsync.sv
vlog +acc -sv $AIB_LIB/c3lib/rtl/cdc/vector_synchronizer/c3lib_vecsync.sv
vlog +acc -sv $AIB_LIB/c3lib/rtl/cdc/vector_synchronizer/c3lib_vecsync_handshake.sv
vlog +acc -sv $AIB_LIB/c3lib/rtl/cdc/glitch_free_mux/c3lib_gf_clkmux.sv

vlog +acc -sv $AIB_LIB/c3lib/rtl/ctn/clock_buf/c3lib_ckinv_ctn.sv
vlog +acc -sv $AIB_LIB/c3lib/rtl/ctn/clock_buf/c3lib_ckbuf_ctn.sv
vlog +acc -sv $AIB_LIB/c3lib/rtl/ctn/clock_buf/c3lib_ckand2_ctn.sv
vlog +acc -sv $AIB_LIB/c3lib/rtl/ctn/clock_gater/c3lib_ckg_async_posedge_ctn.sv
vlog +acc -sv $AIB_LIB/c3lib/rtl/ctn/clock_gater/c3lib_ckg_negedge_ctn.sv
vlog +acc -sv $AIB_LIB/c3lib/rtl/ctn/clock_gater/c3lib_ckg_posedge_ctn.sv
vlog +acc -sv $AIB_LIB/c3lib/rtl/ctn/clock_mux/c3lib_mux2_ctn.sv
vlog +acc -sv $AIB_LIB/c3lib/rtl/ctn/clock_mux/c3lib_mux3_ctn.sv
vlog +acc -sv $AIB_LIB/c3lib/rtl/ctn/clock_mux/c3lib_mux4_ctn.sv
vlog +acc -sv $AIB_LIB/c3lib/rtl/ctn/clock_divider/c3lib_ckdiv2_ctn.sv
vlog +acc -sv $AIB_LIB/c3lib/rtl/ctn/clock_divider/c3lib_ckdiv4_ctn.sv
vlog +acc -sv $AIB_LIB/c3lib/rtl/ctn/clock_divider/c3lib_ckdiv8_ctn.sv

vlog +acc -sv $AIB_LIB/c3lib/rtl/lcell/c3lib_and2_lcell.sv
vlog +acc -sv $AIB_LIB/c3lib/rtl/lcell/c3lib_buf_lcell.sv
vlog +acc -sv $AIB_LIB/c3lib/rtl/lcell/c3lib_mux2_lcell.sv
vlog +acc -sv $AIB_LIB/c3lib/rtl/lcell/c3lib_nand2_lcell.sv
vlog +acc -sv $AIB_LIB/c3lib/rtl/lcell/c3lib_or2_lcell.sv
vlog +acc -sv $AIB_LIB/c3lib/rtl/lcell/c3lib_tie_bus_lcell.sv
vlog +acc -sv $AIB_LIB/c3lib/rtl/lcell/c3lib_tieh_lcell.sv
vlog +acc -sv $AIB_LIB/c3lib/rtl/lcell/c3lib_tiel_lcell.sv
vlog +acc -sv $AIB_LIB/c3lib/rtl/lcell/c3lib_mtieh_lcell.sv
vlog +acc -sv $AIB_LIB/c3lib/rtl/lcell/c3lib_mtiel_lcell.sv
vlog +acc -sv $AIB_LIB/c3lib/rtl/lcell/c3lib_dff_scan_lcell.sv

vlog +acc -sv $AIB_LIB/c3lib/rtl/ecc/c3lib_ecc_dec_c39_d32.sv
vlog +acc -sv $AIB_LIB/c3lib/rtl/ecc/c3lib_ecc_dec_c88_d80.sv
vlog +acc -sv $AIB_LIB/c3lib/rtl/ecc/c3lib_ecc_enc_d32_c39.sv
vlog +acc -sv $AIB_LIB/c3lib/rtl/ecc/c3lib_ecc_enc_d80_c88.sv

vlog +acc -sv $AIB_LIB/c3lib/rtl/primitives/c3lib_sync2_reset_lvt_gate.sv
vlog +acc -sv $AIB_LIB/c3lib/rtl/primitives/c3lib_sync2_reset_ulvt_gate.sv
vlog +acc -sv $AIB_LIB/c3lib/rtl/primitives/c3lib_sync3_reset_ulvt_gate.sv
vlog +acc -sv $AIB_LIB/c3lib/rtl/primitives/c3lib_sync2_set_lvt_gate.sv
vlog +acc -sv $AIB_LIB/c3lib/rtl/primitives/c3lib_sync2_set_ulvt_gate.sv
vlog +acc -sv $AIB_LIB/c3lib/rtl/primitives/c3lib_sync3_set_ulvt_gate.sv
vlog +acc -sv $AIB_LIB/c3lib/rtl/primitives/c3lib_tie0_svt_1x.sv
vlog +acc -sv $AIB_LIB/c3lib/rtl/primitives/c3lib_tie1_svt_1x.sv
vlog +acc -sv $AIB_LIB/c3lib/rtl/primitives/c3lib_mtie0_ds.sv
vlog +acc -sv $AIB_LIB/c3lib/rtl/primitives/c3lib_mtie1_ds.sv
vlog +acc -sv $AIB_LIB/c3lib/rtl/primitives/c3lib_or2_svt_2x.sv
vlog +acc -sv $AIB_LIB/c3lib/rtl/primitives/c3lib_nand2_svt_2x.sv
vlog +acc -sv $AIB_LIB/c3lib/rtl/primitives/c3lib_mux2_svt_2x.sv
vlog +acc -sv $AIB_LIB/c3lib/rtl/primitives/c3lib_ckmux4_ulvt_gate.sv
vlog +acc -sv $AIB_LIB/c3lib/rtl/primitives/c3lib_ckmux4_lvt_gate.sv
vlog +acc -sv $AIB_LIB/c3lib/rtl/primitives/c3lib_ckinv_lvt_12x.sv
vlog +acc -sv $AIB_LIB/c3lib/rtl/primitives/c3lib_ckinv_svt_8x.sv
vlog +acc -sv $AIB_LIB/c3lib/rtl/primitives/c3lib_ckg_lvt_8x.sv
vlog +acc -sv $AIB_LIB/c3lib/rtl/primitives/c3lib_ckbuf_lvt_4x.sv
vlog +acc -sv $AIB_LIB/c3lib/rtl/primitives/c3lib_buf_svt_4x.sv
vlog +acc -sv $AIB_LIB/c3lib/rtl/primitives/c3lib_and2_svt_2x.sv
vlog +acc -sv $AIB_LIB/c3lib/rtl/primitives/c3lib_and2_svt_4x.sv
vlog +acc -sv $AIB_LIB/c3lib/rtl/primitives/c3lib_dff0_reset_lvt_2x.sv
vlog +acc -sv $AIB_LIB/c3lib/rtl/primitives/c3lib_dff0_set_lvt_2x.sv
vlog +acc -sv $AIB_LIB/c3lib/rtl/primitives/c3lib_dff0_scan_reset_svt_2x.sv
vlog +acc -sv $AIB_LIB/c3lib/rtl/primitives/c3lib_sync_metastable_behav_gate.sv

vlog $AIB_LIB/c3dfx/rtl/defines/c3dfx.vh $AIB_LIB/c3dfx/rtl/tcm/c3dfx_tcm_wrap.sv 
#vlog $AIB_LIB/c3dfx/rtl/defines/c3dfx.vh $AIB_LIB/c3dfx/rtl/tcm/c3dfx_tcm_wrap.sv +incdir+$AIB_LIB/c3dfx/rtl/defines
vlog +acc -sv $AIB_LIB/c3dfx/rtl/tcm/c3dfx_tcm.sv
vlog $AIB_LIB/c3dfx/rtl/defines/c3dfx.vh $AIB_LIB/c3aibadapt/rtl/c3aibadapt.v
vlog +acc -sv $AIB_LIB/c3aibadapt/rtl/c3aibadapt_avmm/c3aibadapt_avmm1_async.v
vlog $AIB_LIB/c3dfx/rtl/defines/c3dfx.vh $AIB_LIB/c3aibadapt/rtl/c3aibadapt_avmm/c3aibadapt_avmm1clk_ctl.v
vlog +acc -sv $AIB_LIB/c3aibadapt/rtl/c3aibadapt_avmm/c3aibadapt_avmm1_config.v
vlog +acc -sv $AIB_LIB/c3aibadapt/rtl/c3aibadapt_avmm/c3aibadapt_hwcfg_dec.v
vlog +acc -sv $AIB_LIB/c3aibadapt/rtl/c3aibadapt_avmm/c3aibadapt_cfg_csr.v
vlog +acc -sv $AIB_LIB/c3aibadapt/rtl/c3aibadapt_avmm/c3aibadapt_usr_csr.v
vlog +acc -sv $AIB_LIB/c3aibadapt/rtl/c3aibadapt_avmm/c3aibadapt_avmm1_transfer.v
vlog $AIB_LIB/c3dfx/rtl/defines/c3dfx.vh $AIB_LIB/c3aibadapt/rtl/c3aibadapt_avmm/c3aibadapt_avmm1.v
vlog +acc -sv $AIB_LIB/c3aibadapt/rtl/c3aibadapt_avmm/c3aibadapt_avmm2_async.v
vlog +acc -sv $AIB_LIB/c3aibadapt/rtl/c3aibadapt_avmm/c3aibadapt_avmm2clk_ctl.v
vlog +acc -sv $AIB_LIB/c3aibadapt/rtl/c3aibadapt_avmm/c3aibadapt_avmm2_config.v
vlog +acc -sv $AIB_LIB/c3aibadapt/rtl/c3aibadapt_avmm/c3aibadapt_avmm2_transfer.v
vlog +acc -sv $AIB_LIB/c3aibadapt/rtl/c3aibadapt_avmm/c3aibadapt_avmm2.v
vlog +acc -sv $AIB_LIB/c3aibadapt/rtl/c3aibadapt_avmm/c3aibadapt_avmm_async.v
vlog +acc -sv $AIB_LIB/c3aibadapt/rtl/c3aibadapt_avmm/c3aibadapt_cfg_rdmux.v
vlog +acc -sv $AIB_LIB/c3aibadapt/rtl/c3aibadapt_avmm/c3aibadapt_avmmclk_dcg.v
vlog +acc -sv $AIB_LIB/c3aibadapt/rtl/c3aibadapt_avmm/c3aibadapt_avmmclk_gate.v
vlog +acc -sv $AIB_LIB/c3aibadapt/rtl/c3aibadapt_avmm/c3aibadapt_avmm_cmdbuilder.sv
vlog +acc -sv $AIB_LIB/c3aibadapt/rtl/c3aibadapt_avmm/c3aibadapt_avmm_dec_arb.sv
vlog +acc -sv $AIB_LIB/c3aibadapt/rtl/c3aibadapt_avmm/c3aibadapt_avmm_decode.sv
vlog +acc -sv $AIB_LIB/c3aibadapt/rtl/c3aibadapt_avmm/c3aibadapt_avmm_rdfifo.v
vlog +acc -sv $AIB_LIB/c3aibadapt/rtl/c3aibadapt_avmm/c3aibadapt_avmmrst_ctl.v
vlog +acc -sv $AIB_LIB/c3aibadapt/rtl/c3aibadapt_avmm/c3aibadapt_avmm_usr32_exp.sv
vlog $AIB_LIB/c3dfx/rtl/defines/c3dfx.vh $AIB_LIB/c3aibadapt/rtl/c3aibadapt_avmm/c3aibadapt_avmm.v
vlog +acc -sv $AIB_LIB/c3aibadapt/rtl/c3aibadapt_avmm/c3aibadapt_hrdrst_clkctl.v
vlog +acc -sv $AIB_LIB/c3aibadapt/rtl/c3aibadapt_avmm/c3aibadapt_hrdrst_rstctrl.v
vlog +acc -sv $AIB_LIB/c3aibadapt/rtl/c3aibadapt_cmn/c3aibadapt_cmn_async_capture_bit.v
vlog +acc -sv $AIB_LIB/c3aibadapt/rtl/c3aibadapt_cmn/c3aibadapt_cmn_async_capture_bus.v
vlog +acc -sv $AIB_LIB/c3aibadapt/rtl/c3aibadapt_cmn/c3aibadapt_cmn_clkand2.v
vlog +acc -sv $AIB_LIB/c3aibadapt/rtl/c3aibadapt_cmn/c3aibadapt_cmn_clkgate_high.v
vlog +acc -sv $AIB_LIB/c3aibadapt/rtl/c3aibadapt_cmn/c3aibadapt_cmn_clkgate.v
vlog +acc -sv $AIB_LIB/c3aibadapt/rtl/c3aibadapt_cmn/c3aibadapt_cmn_clkinv.v
vlog +acc -sv $AIB_LIB/c3aibadapt/rtl/c3aibadapt_cmn/c3aibadapt_cmn_clkmux2_cell.v
vlog +acc -sv $AIB_LIB/c3aibadapt/rtl/c3aibadapt_cmn/c3aibadapt_cmn_clkmux2.v
vlog +acc -sv $AIB_LIB/c3aibadapt/rtl/c3aibadapt_cmn/c3aibadapt_cmn_cp_comp_cntr.v
vlog +acc -sv $AIB_LIB/c3aibadapt/rtl/c3aibadapt_cmn/c3aibadapt_cmn_cp_dist_dw.v
vlog +acc -sv $AIB_LIB/c3aibadapt/rtl/c3aibadapt_cmn/c3aibadapt_cmn_cp_dist_pair_dw.v
vlog +acc -sv $AIB_LIB/c3aibadapt/rtl/c3aibadapt_cmn/c3aibadapt_cmn_cp_dist_pair.v
vlog +acc -sv $AIB_LIB/c3aibadapt/rtl/c3aibadapt_cmn/c3aibadapt_cmn_cp_dist.v
vlog +acc -sv $AIB_LIB/c3aibadapt/rtl/c3aibadapt_cmn/c3aibadapt_cmn_dft_clk_ctlr.v
vlog +acc -sv $AIB_LIB/c3aibadapt/rtl/c3aibadapt_cmn/c3aibadapt_cmn_latency_measure.v
vlog +acc -sv $AIB_LIB/c3aibadapt/rtl/c3aibadapt_cmn/c3aibadapt_cmn_occ_clkgate.v
vlog +acc -sv $AIB_LIB/c3aibadapt/rtl/c3aibadapt_cmn/c3aibadapt_cmn_occ_enable_logic.v
vlog +acc -sv $AIB_LIB/c3aibadapt/rtl/c3aibadapt_cmn/c3aibadapt_cmn_occ_gray_cntr.v
vlog +acc -sv $AIB_LIB/c3aibadapt/rtl/c3aibadapt_cmn/c3aibadapt_cmn_occ_test_ctlregs.v
vlog +acc -sv $AIB_LIB/c3aibadapt/rtl/c3aibadapt_cmn/c3aibadapt_cmn_parity_checker.v
vlog +acc -sv $AIB_LIB/c3aibadapt/rtl/c3aibadapt_cmn/c3aibadapt_cmn_parity_gen.v
vlog +acc -sv $AIB_LIB/c3aibadapt/rtl/c3aibadapt_cmn/c3aibadapt_cmn_pulse_stretch.v
vlog +acc -sv $AIB_LIB/c3aibadapt/rtl/c3aibadapt_cmn/c3aibadapt_cmn_dprio_status_sync_regs.v
vlog +acc -sv $AIB_LIB/c3aibadapt/rtl/c3aibadapt_cmn/c3aibadapt_cmn_shadow_status_regs.v
vlog +acc -sv $AIB_LIB/c3aibadapt/rtl/c3aibadapt_rxchnl/c3aibadapt_rxasync_capture.v
vlog +acc -sv $AIB_LIB/c3aibadapt/rtl/c3aibadapt_rxchnl/c3aibadapt_rxasync_direct.v
vlog +acc -sv $AIB_LIB/c3aibadapt/rtl/c3aibadapt_rxchnl/c3aibadapt_rxasync_rsvd_capture.v
vlog +acc -sv $AIB_LIB/c3aibadapt/rtl/c3aibadapt_rxchnl/c3aibadapt_rxasync_rsvd_update.v
vlog +acc -sv $AIB_LIB/c3aibadapt/rtl/c3aibadapt_rxchnl/c3aibadapt_rxasync_update.v
vlog +acc -sv $AIB_LIB/c3aibadapt/rtl/c3aibadapt_rxchnl/c3aibadapt_rxasync.v
vlog +acc -sv $AIB_LIB/c3aibadapt/rtl/c3aibadapt_rxchnl/c3aibadapt_rxchnl_testbus.v
vlog +acc -sv $AIB_LIB/c3aibadapt/rtl/c3aibadapt_rxchnl/c3aibadapt_rxchnl.v
vlog $AIB_LIB/c3dfx/rtl/defines/c3dfx.vh $AIB_LIB/c3aibadapt/rtl/c3aibadapt_rxchnl/c3aibadapt_rxclk_ctl.v
vlog +acc -sv $AIB_LIB/c3aibadapt/rtl/c3aibadapt_rxchnl/c3aibadapt_rxclk_gate.v
vlog +acc -sv $AIB_LIB/c3aibadapt/rtl/c3aibadapt_rxchnl/c3aibadapt_rxdp_asn.v
vlog +acc -sv $AIB_LIB/c3aibadapt/rtl/c3aibadapt_rxchnl/c3aibadapt_rxdp_async_fifo.v
vlog +acc -sv $AIB_LIB/c3aibadapt/rtl/c3aibadapt_rxchnl/c3aibadapt_rxdp_cp_bond.v
vlog +acc -sv $AIB_LIB/c3aibadapt/rtl/c3aibadapt_rxchnl/c3aibadapt_rxdp_del_sm.v
vlog +acc -sv $AIB_LIB/c3aibadapt/rtl/c3aibadapt_rxchnl/c3aibadapt_rxdp_fifo_ptr.v
vlog +acc -sv $AIB_LIB/c3aibadapt/rtl/c3aibadapt_rxchnl/c3aibadapt_rxdp_fifo_ram.v
vlog +acc -sv $AIB_LIB/c3aibadapt/rtl/c3aibadapt_rxchnl/c3aibadapt_rxdp_fifo.v
vlog +acc -sv $AIB_LIB/c3aibadapt/rtl/c3aibadapt_rxchnl/c3aibadapt_rxdp_map.v
vlog +acc -sv $AIB_LIB/c3aibadapt/rtl/c3aibadapt_rxchnl/c3aibadapt_rx_dprio.v
vlog +acc -sv $AIB_LIB/c3aibadapt/rtl/c3aibadapt_rxchnl/c3aibadapt_rxdp_rxeq_sm.v
vlog +acc -sv $AIB_LIB/c3aibadapt/rtl/c3aibadapt_rxchnl/c3aibadapt_rxdp_txeq_sm.v
vlog +acc -sv $AIB_LIB/c3aibadapt/rtl/c3aibadapt_rxchnl/c3aibadapt_rxdp_txeq.v
vlog +acc -sv $AIB_LIB/c3aibadapt/rtl/c3aibadapt_rxchnl/c3aibadapt_rxdp.v
vlog +acc -sv $AIB_LIB/c3aibadapt/rtl/c3aibadapt_rxchnl/c3aibadapt_rxrst_ctl.v
vlog +acc -sv $AIB_LIB/c3aibadapt/rtl/c3aibadapt_sr/c3aibadapt_fsr_in.v
vlog +acc -sv $AIB_LIB/c3aibadapt/rtl/c3aibadapt_sr/c3aibadapt_fsr_out.v
vlog +acc -sv $AIB_LIB/c3aibadapt/rtl/c3aibadapt_sr/c3aibadapt_sr_async_capture_bit.v
vlog +acc -sv $AIB_LIB/c3aibadapt/rtl/c3aibadapt_sr/c3aibadapt_sr_async_capture_bus.v
vlog +acc -sv $AIB_LIB/c3aibadapt/rtl/c3aibadapt_sr/c3aibadapt_srclk_ctl.v
vlog +acc -sv $AIB_LIB/c3aibadapt/rtl/c3aibadapt_sr/c3aibadapt_sr_in_bit.v
vlog +acc -sv $AIB_LIB/c3aibadapt/rtl/c3aibadapt_sr/c3aibadapt_sr_out_bit.v
vlog +acc -sv $AIB_LIB/c3aibadapt/rtl/c3aibadapt_sr/c3aibadapt_srrst_ctl.v
vlog +acc -sv $AIB_LIB/c3aibadapt/rtl/c3aibadapt_sr/c3aibadapt_sr_sm.v
vlog +acc -sv $AIB_LIB/c3aibadapt/rtl/c3aibadapt_sr/c3aibadapt_sr.v
vlog +acc -sv $AIB_LIB/c3aibadapt/rtl/c3aibadapt_sr/c3aibadapt_ssr_in.v
vlog +acc -sv $AIB_LIB/c3aibadapt/rtl/c3aibadapt_sr/c3aibadapt_ssr_out.v
vlog +acc -sv $AIB_LIB/c3aibadapt/rtl/c3aibadapt_txchnl/c3aibadapt_async_update.v
vlog +acc -sv $AIB_LIB/c3aibadapt/rtl/c3aibadapt_txchnl/c3aibadapt_hip_async_capture.v
vlog +acc -sv $AIB_LIB/c3aibadapt/rtl/c3aibadapt_txchnl/c3aibadapt_hip_async_update.v
vlog +acc -sv $AIB_LIB/c3aibadapt/rtl/c3aibadapt_txchnl/c3aibadapt_txasync_capture.v
vlog +acc -sv $AIB_LIB/c3aibadapt/rtl/c3aibadapt_txchnl/c3aibadapt_txasync_direct.v
vlog +acc -sv $AIB_LIB/c3aibadapt/rtl/c3aibadapt_txchnl/c3aibadapt_txasync_rsvd_capture.v
vlog +acc -sv $AIB_LIB/c3aibadapt/rtl/c3aibadapt_txchnl/c3aibadapt_txasync_rsvd_update.v
vlog +acc -sv $AIB_LIB/c3aibadapt/rtl/c3aibadapt_txchnl/c3aibadapt_txasync_update.v
vlog +acc -sv $AIB_LIB/c3aibadapt/rtl/c3aibadapt_txchnl/c3aibadapt_txasync.v
vlog +acc -sv $AIB_LIB/c3aibadapt/rtl/c3aibadapt_txchnl/c3aibadapt_txchnl_testbus.v
vlog +acc -sv $AIB_LIB/c3aibadapt/rtl/c3aibadapt_txchnl/c3aibadapt_txchnl.v
vlog +acc -sv $AIB_LIB/c3aibadapt/rtl/c3aibadapt_txchnl/c3aibadapt_txclk_ctl.v
vlog +acc -sv $AIB_LIB/c3aibadapt/rtl/c3aibadapt_txchnl/c3aibadapt_txclk_gate.v
vlog +acc -sv $AIB_LIB/c3aibadapt/rtl/c3aibadapt_txchnl/c3aibadapt_txdp_async_fifo.v
vlog +acc -sv $AIB_LIB/c3aibadapt/rtl/c3aibadapt_txchnl/c3aibadapt_txdp_cp_bond.v
vlog +acc -sv $AIB_LIB/c3aibadapt/rtl/c3aibadapt_txchnl/c3aibadapt_txdp_fifo_ptr.v
vlog +acc -sv $AIB_LIB/c3aibadapt/rtl/c3aibadapt_txchnl/c3aibadapt_txdp_fifo_ram.v
vlog +acc -sv $AIB_LIB/c3aibadapt/rtl/c3aibadapt_txchnl/c3aibadapt_txdp_fifo.v
vlog +acc -sv $AIB_LIB/c3aibadapt/rtl/c3aibadapt_txchnl/c3aibadapt_txdp_map.v
vlog +acc -sv $AIB_LIB/c3aibadapt/rtl/c3aibadapt_txchnl/c3aibadapt_tx_dprio.v
vlog +acc -sv $AIB_LIB/c3aibadapt/rtl/c3aibadapt_txchnl/c3aibadapt_txdp.v
vlog +acc -sv $AIB_LIB/c3aibadapt/rtl/c3aibadapt_txchnl/c3aibadapt_txdp_word_align.v
vlog +acc -sv $AIB_LIB/c3aibadapt/rtl/c3aibadapt_txchnl/c3aibadapt_txrst_ctl.v

vlog +acc -sv $AIB_LIB/aibcr3pnr_lib/rtl/aibcr3pnr_redundancy.v
vlog +acc -sv $AIB_LIB/aibcr3pnr_lib/rtl/aibcr3pnr_jtag_bscan.v
vlog +acc -sv $AIB_LIB/aibcr3pnr_lib/rtl/aibcr3pnr_bsr_red_wrap.v

vlog +acc -sv $AIB_LIB/aibcr3pnr_lib/rtl/aibcr3pnr_half_cycle_code_gen.v
vlog +acc -sv $AIB_LIB/aibcr3pnr_lib/rtl/aibcr3pnr_self_lock_assertion.v
vlog +acc -sv $AIB_LIB/aibcr3pnr_lib/rtl/aibcr3pnr_dll_ctrl.v
vlog +acc -sv $AIB_LIB/aibcr3pnr_lib/rtl/aibcr3pnr_dll_core.v
vlog +acc -sv $AIB_LIB/aibcr3pnr_lib/rtl/aibcr3pnr_dll_pnr.v
vlog +acc -sv $AIB_LIB/aibcr3pnr_lib/rtl/aibcr3pnr_rstsync.sv

vlog  $AIB_LIB/c3dfx/rtl/defines/c3dfx.vh $AIB_LIB/c3dfx/rtl/tcb/c3dfx_aibadaptwrap_tcb.sv
vlog +acc $AIB_LIB/c3dfx/rtl/defines/c3dfx.vh $AIB_LIB/c3aibadapt_wrap/rtl/c3aibadapt_wrap.v

vlog +acc -sv ./ndaibadapt_wrap.v
vlog +acc -sv ./hdpldadapt.v

vlog +acc -sv $MODEL_RTL/aib_dcc.v
vlog +acc -sv $MODEL_RTL/aib_aux_channel.v
vlog +acc -sv $MODEL_RTL/aib_bitsync.v
vlog +acc -sv $MODEL_RTL/aib_bsr_red_wrap.v
vlog +acc -sv $MODEL_RTL/aib_buffx1_top.v
vlog +acc -sv $MODEL_RTL/aib_io_buffer.sv
vlog +acc -sv $MODEL_RTL/aib_ioring.v
vlog +acc -sv $MODEL_RTL/aib_jtag_bscan.v
vlog +acc -sv $MODEL_RTL/aib_mux21.v
vlog +acc -sv $MODEL_RTL/aib_osc_clk.sv
vlog +acc -sv $MODEL_RTL/aib_redundancy.v
vlog +acc -sv $MODEL_RTL/aib_rstnsync.v
vlog +acc -sv $MODEL_RTL/aib_sm.v
vlog +acc -sv $MODEL_RTL/aib_sr_ms.v
vlog +acc -sv $MODEL_RTL/aib_sr_sl.v
vlog +acc  $MODEL_RTL/dll.sv
vlog +acc -sv $MODEL_RTL/aib_channel.v
vlog +acc -sv $MODEL_RTL/aib.v
#vlog +acc -sv ./dut_io.sv  
vlog +acc -sv ./hdpldadapt.v  
#vlog +acc -sv ./nda_drv.sv  
vlog +acc -sv ./ndaibadapt_wrap.v  
#vlog +acc -sv ./nda_port.sv  
vlog +acc -sv ./ndut_declare.sv  
#vlog +acc -sv ./ndut_default.sv  
vlog +acc -sv ./ndut_io.sv  
vlog +acc -sv ./test.sv  
vlog +acc -sv ./dut_io.sv ./top.sv +incdir+$AIB_LIB/c3dfx/rtl/defines
