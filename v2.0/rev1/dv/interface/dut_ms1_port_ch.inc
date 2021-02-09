    .iopad_tx(m1_iopad_tx),
    .iopad_rx(m1_iopad_rx),
    .iopad_ns_rcv_clkb(m1_iopad_ns_rcv_clkb), 
    .iopad_ns_rcv_clk(m1_iopad_ns_rcv_clk),
    .iopad_ns_fwd_clk(m1_iopad_ns_fwd_clk), 
    .iopad_ns_fwd_clkb(m1_iopad_ns_fwd_clkb),
    .iopad_ns_sr_clk(m1_iopad_ns_sr_clk), 
    .iopad_ns_sr_clkb(m1_iopad_ns_sr_clkb),
    .iopad_ns_sr_load(m1_iopad_ns_sr_load), 
    .iopad_ns_sr_data(m1_iopad_ns_sr_data),
    .iopad_ns_mac_rdy(m1_iopad_ns_mac_rdy), 
    .iopad_ns_adapter_rstn(m1_iopad_ns_adapter_rstn),
    .iopad_spare1(m1_iopad_spare1), 
    .iopad_spare0(m1_iopad_spare0),
    .iopad_fs_rcv_clkb(m1_iopad_fs_rcv_clkb), 
    .iopad_fs_rcv_clk(m1_iopad_fs_rcv_clk),
    .iopad_fs_fwd_clkb(m1_iopad_fs_fwd_clkb), 
    .iopad_fs_fwd_clk(m1_iopad_fs_fwd_clk),
    .iopad_fs_sr_clkb(m1_iopad_fs_sr_clkb), 
    .iopad_fs_sr_clk(m1_iopad_fs_sr_clk),
    .iopad_fs_sr_load(m1_iopad_fs_sr_load), 
    .iopad_fs_sr_data(m1_iopad_fs_sr_data),
    .iopad_fs_mac_rdy(m1_iopad_fs_mac_rdy), 
    .iopad_fs_adapter_rstn(m1_iopad_fs_adapter_rstn),

    //IO pads, AUX channel
//  .iopad_device_detect(device_detect),
//  .iopad_device_detect_copy(device_detectrdcy),
//  .iopad_por(por),
//  .iopad_por_copy(por_copy),

    //Control/status from/to MAC 
    .data_in_f(intf_m1.data_in_f[319:0]),
    .data_out_f(intf_m1.data_out_f[319:0]), 
    .data_in(intf_m1.data_in[79:0]), //output data to pad
    .data_out(intf_m1.data_out[79:0]), 

    .m_ns_fwd_clk(intf_m1.m_ns_fwd_clk), //output data clock
    .m_ns_rcv_clk(intf_m1.m_ns_rcv_clk),
    .m_fs_rcv_clk(intf_m1.m_fs_rcv_clk),
    .m_fs_fwd_clk(intf_m1.m_fs_fwd_clk),

    .m_wr_clk(intf_m1.m_wr_clk),
    .m_rd_clk(intf_m1.m_rd_clk),

    .ns_adapter_rstn(intf_m1.ns_adapter_rstn),
    .ns_mac_rdy(intf_m1.ns_mac_rdy),
    .fs_mac_rdy(intf_m1.fs_mac_rdy),

    .i_conf_done(intf_m1.i_conf_done),
    .ms_rx_dcc_dll_lock_req(intf_m1.ms_rx_dcc_dll_lock_req),
    .ms_tx_dcc_dll_lock_req(intf_m1.ms_tx_dcc_dll_lock_req),
    .sl_rx_dcc_dll_lock_req(1'b1),
    .sl_tx_dcc_dll_lock_req(1'b1),
    .ms_tx_transfer_en(intf_m1.ms_tx_transfer_en),
    .ms_rx_transfer_en(intf_m1.ms_rx_transfer_en),
    .sl_tx_transfer_en(intf_m1.sl_tx_transfer_en),
    .sl_rx_transfer_en(intf_m1.sl_rx_transfer_en),
    .sr_ms_tomac(intf_m1.ms_sideband),
    .sr_sl_tomac(intf_m1.sl_sideband),
    .m_rxfifo_align_done(intf_m1.m_rxfifo_align_done),
    .wa_error(intf_m1.wa_error),
    .wa_error_cnt(intf_m1.wa_error_cnt),
    .dual_mode_select(1'b1),
    .m_gen2_mode(1'b1),
    .por(por),
    .i_osc_clk(intf_m1.i_osc_clk),   //Only for master mode

    //AVMM interface
    .i_channel_id(6'h0),
    .i_cfg_avmm_clk(avmm_if_m1.clk),
    .i_cfg_avmm_rst_n(avmm_if_m1.rst_n),
    .i_cfg_avmm_addr(avmm_if_m1.address),
    .i_cfg_avmm_byte_en(avmm_if_m1.byteenable),
    .i_cfg_avmm_read(avmm_if_m1.read),
    .i_cfg_avmm_write(avmm_if_m1.write),
    .i_cfg_avmm_wdata(avmm_if_m1.writedata),

    .o_cfg_avmm_rdatavld(avmm_if_m1.readdatavalid),
    .o_cfg_avmm_rdata(avmm_if_m1.readdata),
    .o_cfg_avmm_waitreq(avmm_if_m1.waitrequest),


    //Aux channel signals from MAC
//  .m_por_ovrd(intf_m1.m_por_ovrd),
//  .m_device_detect(intf_m1.m_device_detect),
//  .m_device_detect_ovrd(1'b0),
//  .m_power_on_reset_i(1'b0),
//  .m_power_on_reset(),

    //JTAG ports
    .jtag_clkdr_in(1'b0),
    .scan_out(),
    .jtag_intest(1'b0),
    .jtag_mode_in(1'b0),
    .jtag_rstb(1'b0),
    .jtag_rstb_en(1'b0),
    .jtag_weakpdn(1'b0),
    .jtag_weakpu(1'b0),
    .jtag_tx_scanen_in(1'b0),
    .scan_in(1'b0),

//Redundancy control signals
//`include "redundancy_ctrl_sim.vh"

    .sl_external_cntl_26_0(27'b0),
    .sl_external_cntl_30_28(3'b0),
    .sl_external_cntl_57_32(26'b0),

    .ms_external_cntl_4_0(5'b0),
    .ms_external_cntl_65_8(58'b0),

    .vccl_aib(1'b1),
    .vssl_aib(1'b0) 
