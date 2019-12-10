// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. All rights reserved

`ifdef S10_MODEL

wire [79:0] pld_rx_fabric_data_out;
wire        rx_clkout;

s10aib s10_wrap (
                       .iopad_ns_mac_rdy(ms_iopad_fs_mac_rdy),
                       .iopad_fs_mac_rdy(ms_iopad_ns_mac_rdy),
                       .iopad_ns_adapter_rstn(ms_iopad_fs_adapter_rstn),
                       .iopad_fs_adapter_rstn(ms_iopad_ns_adapter_rstn),

                       .iopad_tx(ms_iopad_rx),
                       .iopad_ns_fwd_clk(ms_iopad_fs_fwd_clk), 
                       .iopad_ns_fwd_clkb(ms_iopad_fs_fwd_clkb), 
                       .iopad_ns_rcv_clk(ms_iopad_fs_rcv_clk),
                       .iopad_ns_rcv_clkb(ms_iopad_fs_rcv_clkb),


                       .iopad_rx(ms_iopad_tx),
                       .iopad_fs_fwd_clk(ms_iopad_ns_fwd_clk), 
                       .iopad_fs_fwd_clkb(ms_iopad_ns_fwd_clkb),
                       .iopad_fs_fwd_div2_clk(ms_iopad_ns_fwd_div2_clk),
                       .iopad_fs_fwd_div2_clkb(ms_iopad_ns_fwd_div2_clkb),
                       .iopad_fs_rcv_clk(ms_iopad_ns_rcv_clk), 
                       .iopad_fs_rcv_clkb(ms_iopad_ns_rcv_clkb),
                       .iopad_fs_rcv_div2_clk(ms_iopad_ns_rcv_div2_clk),
                       .iopad_fs_rcv_div2_clkb(ms_iopad_ns_rcv_div2_clkb),

                       .iopad_ns_sr_data(ms_iopad_fs_sr_data),
                       .iopad_ns_sr_load(ms_iopad_fs_sr_load),
                       .iopad_ns_sr_clk(ms_iopad_fs_sr_clk),
                       .iopad_ns_sr_clkb(ms_iopad_fs_sr_clkb),


                       .iopad_fs_sr_clk(ms_iopad_ns_sr_clk),
                       .iopad_fs_sr_clkb(ms_iopad_ns_sr_clkb),
                       .iopad_fs_sr_data(ms_iopad_ns_sr_data),
                       .iopad_fs_sr_load(ms_iopad_ns_sr_load),
                       .iopad_unused_aib45,
                       .iopad_unused_aib46,
                       .iopad_unused_aib47,
                       .iopad_unused_aib50,
                       .iopad_unused_aib51,
                       .iopad_unused_aib52,
                       .iopad_unused_aib58,
                       .iopad_unused_aib60,
                       .iopad_unused_aib61,
                       .iopad_unused_aib62,
                       .iopad_unused_aib63,
                       .iopad_unused_aib64,
                       .iopad_unused_aib66,
                       .iopad_unused_aib67,
                       .iopad_unused_aib68,
                       .iopad_unused_aib69,
                       .iopad_unused_aib70,
                       .iopad_unused_aib71,
                       .iopad_unused_aib72,
                       .iopad_unused_aib73,
                       .iopad_unused_aib74,
                       .iopad_unused_aib75,
                       .iopad_unused_aib76,
                       .iopad_unused_aib77,
                       .iopad_unused_aib78,
                       .iopad_unused_aib79,
                       .iopad_unused_aib80,
                       .iopad_unused_aib81,
                       .iopad_unused_aib88,
                       .iopad_unused_aib89,
                       .iopad_unused_aib90,
                       .iopad_unused_aib91,


                       .tx_parallel_data(pld_rx_fabric_data_out),      // pld_tx_fabric_data_in
                       .rx_parallel_data(pld_rx_fabric_data_out),     // pld_rx_fabric_data_out
                       .tx_coreclkin(rx_clkout), // pld_tx_clk1_rowclk or pld_tx_clk1_dcm
                       .tx_clkout(), // pld_pcs_tx_clk_out1_dcm
                       .rx_coreclkin(rx_clkout), // pld_rx_clk1_dcm
                       .rx_clkout(rx_clkout), // pld_pcs_rx_clk_out1_dcm
                       .config_done(csr_rdy_in),
                       .fs_mac_rdy(fs_mac_rdy),      //(use c3 pld_pma_clkdiv_rx_user pin). Drive by Master
                       .ns_mac_rdy(sl_ns_mac_rdy), //nd pld_pma_rxpma_rstb. This signal should be high before ns_adapter_rstn go high.
                       .ns_adapter_rstn(pld_adapter_rx_pld_rst_n), //Reset Main adapter and pass over to the fs. 

                       .sl_rx_dcc_dll_lock_req(pld_rx_dll_lock_req),
                       .sl_tx_dcc_dll_lock_req(pld_tx_dll_lock_req),
                       .ms_rx_transfer_en(),
                       .ms_tx_transfer_en(),
                       .sl_rx_transfer_en(),
                       .sl_tx_transfer_en(),
                       .ms_sideband(),
                       .sl_sideband());          
`else

wire [19:0] sl_dataout0,sl_dataout1;

    parameter DATAWIDTH      = 20;
    aib #(.DATAWIDTH(DATAWIDTH))  slave (
                       .iopad_tx(ms_iopad_rx),
                       .iopad_rx(ms_iopad_tx),
                       .iopad_ns_rcv_clkb(ms_iopad_fs_rcv_clkb), 
                       .iopad_ns_rcv_clk(ms_iopad_fs_rcv_clk),
                       .iopad_ns_fwd_clk(ms_iopad_fs_fwd_clk), 
                       .iopad_ns_fwd_clkb(ms_iopad_fs_fwd_clkb),
                       .iopad_ns_sr_clk(ms_iopad_fs_sr_clk), 
                       .iopad_ns_sr_clkb(ms_iopad_fs_sr_clkb),
                       .iopad_ns_sr_load(ms_iopad_fs_sr_load), 
                       .iopad_ns_sr_data(ms_iopad_fs_sr_data),
                       .iopad_ns_mac_rdy(ms_iopad_fs_mac_rdy), 
                       .iopad_ns_adapter_rstn(ms_iopad_fs_adapter_rstn),
                       .iopad_spare1(), 
                       .iopad_spare0(),
                       .iopad_fs_rcv_clkb(ms_iopad_ns_rcv_clkb), 
                       .iopad_fs_rcv_clk(ms_iopad_ns_rcv_clk),
                       .iopad_fs_fwd_clkb(ms_iopad_ns_fwd_clkb), 
                       .iopad_fs_fwd_clk(ms_iopad_ns_fwd_clk),
                       .iopad_fs_sr_clkb(ms_iopad_ns_sr_clkb), 
                       .iopad_fs_sr_clk(ms_iopad_ns_sr_clk),
                       .iopad_fs_sr_load(ms_iopad_ns_sr_load), 
                       .iopad_fs_sr_data(ms_iopad_ns_sr_data),
                       .iopad_fs_mac_rdy(ms_iopad_ns_mac_rdy), 
                       .iopad_fs_adapter_rstn(ms_iopad_ns_adapter_rstn),

                       .iopad_device_detect(device_detect),
                       .iopad_device_detect_copy(device_detectrdcy),
                       .iopad_por(),
                       .iopad_por_copy(),

                       .data_in({sl_dataout1[19:0],sl_dataout0[19:0]}), //output data to pad
                       .data_out({sl_dataout1[19:0],sl_dataout0[19:0]}), //input data from pad
                       .m_ns_fwd_clk(rx_clkout), //output data clock
                       .m_fs_rcv_clk(),
                       .m_fs_fwd_clk(rx_clkout),
                       .m_ns_rcv_clk(),

                       .ms_ns_adapter_rstn(pld_adapter_tx_pld_rst_n),
                       .sl_ns_adapter_rstn(pld_adapter_tx_pld_rst_n),
                       .ms_ns_mac_rdy(pld_adapter_rx_pld_rst_n),
                       .sl_ns_mac_rdy(pld_adapter_rx_pld_rst_n),
                       .fs_mac_rdy(),

                       .ms_config_done(1'b1),
                       .ms_rx_dcc_dll_lock_req(1'b0),
                       .ms_tx_dcc_dll_lock_req(1'b0),
                       .sl_config_done(pld_adapter_rx_pld_rst_n),
                       .sl_rx_dcc_dll_lock_req(pld_rx_dll_lock_req),
                       .sl_tx_dcc_dll_lock_req(pld_tx_dll_lock_req),
                       .ms_tx_transfer_en(),
                       .ms_rx_transfer_en(),
                       .sl_tx_transfer_en(),
                       .sl_rx_transfer_en(),
                       .sr_ms_tomac(),
                       .sr_sl_tomac(),
                       .ms_nsl(1'b0),
                   
                       .iddren(1'b1),
                       .idataselb(1'b0), //output async data selection
                       .itxen(1'b1), //data tx enable
                       .irxen(3'b111),//data input enable
                   
                       .m_por_ovrd(1'b0),
                       .m_device_detect_ovrd(1'b0),
                       .m_power_on_reset_i(pld_adapter_rx_pld_rst_n),
                       .m_device_detect(),
                       .m_power_on_reset(),
                   
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
                   `include "redundancy_ctrl_sim.vh"
                       .sl_external_cntl_26_0({1'b1,26'b0}),
                       .sl_external_cntl_30_28(3'b0),
                       .sl_external_cntl_57_32(26'b0),

                       .ms_external_cntl_4_0(5'b0),
                       .ms_external_cntl_65_8(58'b0),

                       .vccl_aib(1'b1),
                       .vssl_aib(1'b0));
`endif
