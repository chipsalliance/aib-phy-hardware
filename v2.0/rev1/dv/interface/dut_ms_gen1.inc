    .i_adpt_hard_rst_n                  (intf_m1.i_conf_done), 
    .i_cfg_avmm_clk                     (avmm_if_m1.clk), 
    .i_cfg_avmm_rst_n                   (avmm_if_m1.rst_n), 
    .i_cfg_avmm_addr                    (avmm_if_m1.address), 
    .i_cfg_avmm_byte_en                 (avmm_if_m1.byteenable), 
    .i_cfg_avmm_read                    (avmm_if_m1.read), 
    .i_cfg_avmm_write                   (avmm_if_m1.write), 
    .i_cfg_avmm_wdata                   (avmm_if_m1.writedata), 

    .o_cfg_avmm_rdatavld                (avmm_if_m1.readdatavalid),
    .o_cfg_avmm_rdata                   (avmm_if_m1.readdata), 
    .o_cfg_avmm_waitreq                 (avmm_if_m1.waitrequest), 
    
    //Control/status from/to MAC 
    .m_ns_fwd_clk(intf_m1.m_ns_fwd_clk), 
    .m_ns_fwd_div2_clk(intf_m1.m_wr_clk), 
    .m_ns_rcv_clk(intf_m1.m_ns_fwd_clk),
    .m_fs_fwd_clk(intf_m1.m_fs_fwd_clk),
    .m_fs_fwd_div2_clk(),

    .i_chnl_ssr({24{65'h0}}), 

    .data_in(intf_m1.gen1_data_in), //output data to pad
    .data_out(intf_m1.gen1_data_out),

    .o_chnl_ssr(), 

//  .ns_adapter_rstn(intf_m1.ns_adapter_rstn),
//  .ns_mac_rdy(intf_m1.ns_mac_rdy),
    .fs_mac_rdy(intf_m1.fs_mac_rdy),
    .iopad_aib_ch0(m1_iopad_ch0_aib), 
    .iopad_aib_ch1(m1_iopad_ch1_aib), 
    .iopad_aib_ch2(m1_iopad_ch2_aib), 
    .iopad_aib_ch3(m1_iopad_ch3_aib), 
    .iopad_aib_ch4(m1_iopad_ch4_aib), 
    .iopad_aib_ch5(m1_iopad_ch5_aib), 
    .iopad_aib_ch6(m1_iopad_ch6_aib), 
    .iopad_aib_ch7(m1_iopad_ch7_aib), 
    .iopad_aib_ch8(m1_iopad_ch8_aib), 
    .iopad_aib_ch9(m1_iopad_ch9_aib), 
    .iopad_aib_ch10(m1_iopad_ch10_aib),
    .iopad_aib_ch11(m1_iopad_ch11_aib),
    .iopad_aib_ch12(m1_iopad_ch12_aib),
    .iopad_aib_ch13(m1_iopad_ch13_aib),
    .iopad_aib_ch14(m1_iopad_ch14_aib),
    .iopad_aib_ch15(m1_iopad_ch15_aib),
    .iopad_aib_ch16(m1_iopad_ch16_aib),
    .iopad_aib_ch17(m1_iopad_ch17_aib),
    .iopad_aib_ch18(m1_iopad_ch18_aib),
    .iopad_aib_ch19(m1_iopad_ch19_aib),
    .iopad_aib_ch20(m1_iopad_ch20_aib),
    .iopad_aib_ch21(m1_iopad_ch21_aib),
    .iopad_aib_ch22(m1_iopad_ch22_aib),
    .iopad_aib_ch23(m1_iopad_ch23_aib),

    .iopad_device_detect(device_detect),
    .iopad_device_detect_r(),
    .iopad_power_on_reset(por),
    .iopad_power_on_reset_r(por),
    .iopad_unused_aux95_88(),
    .iopad_unused_aux86(),
    .iopad_unused_aux84_76(),
    .iopad_unused_aux73_0(),
    .io_aux_bg_ext_2k(),
    .i_iocsr_rdy_aibaux(intf_m1.i_conf_done), 
    .i_aibaux_por_vccl_ovrd(intf_m1.m_por_ovrd), 


    .i_aibaux_ctrl_bus0(32'h0), 
    .i_aibaux_ctrl_bus1(32'h00500020),        // 2020WW07.4 for osc_clk 
    .i_aibaux_ctrl_bus2(32'h0), 
    .i_aibaux_osc_fuse_trim(10'h0),


    .i_osc_bypclk(intf_m1.i_osc_clk),           // [NOTE] this is not required because v1m has an internal 1Ghz oscillator but to keep it for now

    .o_aibaux_osc_clk(),
    .i_scan_clk                         (1'b0),     
    .i_test_clk_1g                      (1'b0),  
    .i_test_clk_125m                    (1'b0),
    .i_test_clk_250m                    (1'b0),
    .i_test_clk_500m                    (1'b0),
    .i_test_clk_62m                     (1'b0), 

    .i_test_c3adapt_scan_in             ({24{17'h0}}), 
    .i_test_c3adapt_tcb_static_common   (60'h0), 

    .o_test_c3adapt_scan_out            (), 

    .i_jtag_clkdr                       (1'b0), 
    .i_jtag_clksel                      (1'b0), 
    .i_jtag_intest                      (1'b0), 
    .i_jtag_mode                        (1'b0), 
    .i_jtag_rstb                        (1'b1), 
    .i_jtag_rstb_en                     (1'b0), 
    .i_jtag_tx_scan                     (1'b0), 
    .i_jtag_tx_scanen                   (1'b0),
    .i_jtag_weakpdn                     (1'b0),  
    .i_jtag_weakpu                      (1'b0),  

    .i_aibdft2osc                       (3'b0),  
    .o_aibdft2osc                       (),  

    .o_last_bs_out                      (), 
    .m_power_on_reset                   (), 

    .o_osc_monitor                      (), 

    .i_aux_atpg_mode_n                  (1'b1),   
    .i_aux_atpg_pipeline_global_en      (1'b0),  
    .i_aux_atpg_rst_n                   (1'b1),               
    .i_aux_atpg_scan_clk                (1'b0),            
    .i_aux_atpg_scan_in                 (1'b0),             
    .i_aux_atpg_scan_shift_n            (1'b1),        
    .o_aux_atpg_scan_out                ()    

