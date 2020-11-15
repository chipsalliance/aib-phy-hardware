// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 


wire [79:0] pld_rx_fabric_data_out;
wire        rx_clkout;
wire        sl_m_fs_fwd_clk;

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


                       .tx_parallel_data(tx_parallel_data),      // pld_tx_fabric_data_in
                       .rx_parallel_data(rx_parallel_data),     // pld_rx_fabric_data_out
                       .tx_coreclkin(tx_coreclkin), // pld_tx_clk1_rowclk or pld_tx_clk1_dcm
                       .m_ns_fwd_clk(sl_m_ns_fwd_clk),
                       .tx_clkout(tx_clkout), // pld_pcs_tx_clk_out1_dcm
                       .rx_coreclkin(rx_coreclkin), // pld_rx_clk1_dcm
                       .rx_clkout(rx_clkout), // pld_pcs_rx_clk_out1_dcm
                       .m_fs_fwd_clk(sl_m_fs_fwd_clk),
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

