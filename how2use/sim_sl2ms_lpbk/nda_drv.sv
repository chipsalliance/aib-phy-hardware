// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. All rights reserved

    logic [2:0] csr_config;
    logic [2:0] csr_in;
    logic       nfrzdrv_in;
    logic       csr_rdy_in;
    logic       usermode_in;
    logic       sl_ns_mac_rdy;

    reg   csr_clk_in = 1'b0;
    reg   pld_rx_clk1_rowclk = 1'b0;
    reg   pld_rx_clk2_rowclk = 1'b0;
    reg   pld_tx_clk1_rowclk = 1'b0;
    reg   pld_tx_clk2_rowclk = 1'b0;
    reg   pld_rx_clk1_dcm = 1'b0;
    reg   pld_rx_clk2_dcm = 1'b0;
    reg   pld_tx_clk1_dcm = 1'b0;
    reg   pld_tx_clk2_dcm = 1'b0;


    //clock gen
    //Default set value
    initial
      begin
        run_for_n_pkts = 20;
        csr_rdy_in     = 1'b0;
        sl_ns_mac_rdy  = 1'b0;
        pld_adapter_tx_pld_rst_n = 1'b0;
        pld_adapter_rx_pld_rst_n = 1'b0;
        pld_tx_dll_lock_req = 1'b0;
        pld_rx_dll_lock_req = 1'b0;
//      dut.i_adpt_hard_rst_n = 1'b0;
        #1000ns;
        sl_ns_mac_rdy = 1'b1;
        csr_rdy_in     = 1'b1;
    //  @(dut.i_adpt_hard_rst_n)
    //  dut.i_adpt_hard_rst_n = 1'b1;
        #1000ns;
        pld_adapter_rx_pld_rst_n = 1'b1;
        pld_adapter_tx_pld_rst_n = 1'b1;
        pld_tx_dll_lock_req = 1'b1;
        pld_rx_dll_lock_req = 1'b1;
        #1000ns;
         // wait_xfer_ready     ();

        $display ("[%t] Xfer Ready", $time);

        $display ("[%t] start AIB chiplet standalone loopback testing by running %d packets", $time, run_for_n_pkts);
        fork
              data_xmit ();
              data_rcv  ();
        join
        $display ("[%t] ######### Debug: All Tasks are finished normally #############", $time);
        Finish ();

      end  //initial begin

    task data_xmit ();
        static int pkts_gen = 0;
        static bit [79:0] data = 0;
        data[39] = 1'b0;
        data[79] = 1'b1;


        while (pkts_gen < run_for_n_pkts) begin
            data[31:0] =  $urandom_range(32'hffff_ffff,0);
            data[38:32] = $urandom_range(7'h7f,0);
            data[71:40] = $urandom_range(32'hffff_ffff,0);
            data[78:72] = $urandom_range(7'h7f,0);
            $display ("[%t] Generating data[%d] = %x \n", $time, pkts_gen, data);

            @(posedge tx_coreclkin);
            tx_parallel_data <= data;
            xmit_q.push_back(data);
            pkts_gen++;
        end
    endtask

    task data_rcv ();
        static bit [79:0] data_exp = 0;
        static int pkts_rcvd = 0;
        begin
            while(pkts_rcvd < run_for_n_pkts) begin
                @ (posedge rx_coreclkin);
                if (rx_parallel_data[38:0] != 0) begin
                    $display ("[%t] Receiving data[%d] = %x \n", $time, pkts_rcvd, rx_parallel_data);
                    data_exp = xmit_q.pop_front();
                    pkts_rcvd++;
                    if (rx_parallel_data!= data_exp) begin
                        err_count++;
                        $display ("[%t]DATA COMPARE ERROR: received = %x | expected = %x\n", $time, rx_parallel_data, data_exp);
                    end
                end
            end
            if (xmit_q.size() != 0) //check if all the data are received
              $display("[%t]ERROR: Tramit Queue Not Empty, still %d data left\n", $time, xmit_q.size());

        end
    endtask // mstr_req_rcv

    task Finish ();
        begin
            $display("%0t: %m: finishing simulation..", $time);
            repeat (100) @(posedge rx_coreclkin);
            $display("\n////////////////////////////////////////////////////////////////////////////");
            $display("%0t: Simulation ended, ERROR count: %0d", $time, err_count);
            $display("////////////////////////////////////////////////////////////////////////////\n");
            if (err_count == 0) begin
                $display("+++++++++++++++++++++++++++++++++\n");
                $display("TEST PASSED!!!!!!!!!!!\n");
                $display("+++++++++++++++++++++++++++++++++\n");
            end
            $finish;
        end
    endtask




  //Nadder Adapter Forces
  initial begin  // {
    @ (csr_rdy_in)

     //MAIB Configuration
     //
     force `NDADAPT_RTB.hdpldadapt_avmm.hdpldadapt_avmm1.hdpldadapt_avmm1_config.hdpldadapt_avmm1_dprio_mapping.aib_csr_ctrl[463:0]       = 464'h0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_1c00_7f1c_0000_0000_0004_0002_45c3_3f07_b000_0040_0002_0000_2619_0000_0000_0000_0000_0000_0000;
     force `NDADAPT_RTB.hdpldadapt_avmm.hdpldadapt_avmm1.hdpldadapt_avmm1_config.hdpldadapt_avmm1_dprio_mapping.aib_dprio_ctrl[39:0]      = 40'h400;  //Bit 10 is dll bypass.
     force `NDADAPT_RTB.hdpldadapt_avmm.hdpldadapt_avmm1.hdpldadapt_avmm1_config.hdpldadapt_avmm1_dprio_mapping.avmm1_csr_ctrl[55:0]      = 56'h07_ff00_3000_f800;
     force `NDADAPT_RTB.hdpldadapt_avmm.hdpldadapt_avmm1.hdpldadapt_avmm1_config.hdpldadapt_avmm1_dprio_mapping.avmm1_dprio_ctrl[7:0]     = 8'h0;
     force `NDADAPT_RTB.hdpldadapt_avmm.hdpldadapt_avmm1.hdpldadapt_avmm1_config.hdpldadapt_avmm1_dprio_mapping.avmm2_csr_ctrl[55:0]      = 56'h07_ff00_3000_f800;
     force `NDADAPT_RTB.hdpldadapt_avmm.hdpldadapt_avmm1.hdpldadapt_avmm1_config.hdpldadapt_avmm1_dprio_mapping.avmm2_dprio_ctrl[7:0]     = 8'h0;
     force `NDADAPT_RTB.hdpldadapt_avmm.hdpldadapt_avmm1.hdpldadapt_avmm1_config.hdpldadapt_avmm1_dprio_mapping.avmm_csr_ctrl[55:0]       = 56'h00_0018_0000_0300;
     force `NDADAPT_RTB.hdpldadapt_avmm.hdpldadapt_avmm1.hdpldadapt_avmm1_config.hdpldadapt_avmm1_dprio_mapping.avmm_res_csr_ctrl[7:0]    = 8'h0;
//bit 164 r_rx_hrdrst_user_ctl_en bit 164 to overwrite reset for fifo due to dead FSM
//   force `NDADAPT_RTB.hdpldadapt_avmm.hdpldadapt_avmm1.hdpldadapt_avmm1_config.hdpldadapt_avmm1_dprio_mapping.rx_chnl_dprio_ctrl[167:0] = 168'hc8_17c8_c905_6c42_0040_4040_4c00_0303_0018_ca82_cf01;
     //bit 140 r_rx_fifo_wr_clk_sel for rx fifo source clock sel. bit 38 Loopback enable
     force `NDADAPT_RTB.hdpldadapt_avmm.hdpldadapt_avmm1.hdpldadapt_avmm1_config.hdpldadapt_avmm1_dprio_mapping.rx_chnl_dprio_ctrl[167:0] = 168'hd8_17c8_c905_6c42_0040_4040_4c00_0303_0018_ca82_4f01;
     force `NDADAPT_RTB.hdpldadapt_avmm.hdpldadapt_avmm1.hdpldadapt_avmm1_config.hdpldadapt_avmm1_dprio_mapping.sr_dprio_ctrl[23:0]       = 24'h0;
//   force `NDADAPT_RTB.hdpldadapt_avmm.hdpldadapt_avmm1.hdpldadapt_avmm1_config.hdpldadapt_avmm1_dprio_mapping.tx_chnl_dprio_ctrl[135:0] = 136'h2c_e086_11c5_00ce_2308_00cb_0300_6a22_ee00;
     // bit 122 r_tx_hrdrst_user_ctl_en to set to 1 to over write fifo reset by reset fsm
     // have to set r_tx_fifo_rd_clk_sel[1:0]  bit 111:110 to 2'b10 to get clock pld_tx_clk2_dcm 
     force `NDADAPT_RTB.hdpldadapt_avmm.hdpldadapt_avmm1.hdpldadapt_avmm1_config.hdpldadapt_avmm1_dprio_mapping.tx_chnl_dprio_ctrl[135:0] = 136'h2c_e486_91c5_00ce_2308_008b_0300_6a22_ee00;

     force `NDADAPT_RTB.hdpldadapt_avmm.r_rx_async_pld_pma_ltd_b_rst_val          = 1'b0;
//   force `NDADAPT_RTB.hdpldadapt_avmm.hdpldadapt_avmm1.hdpldadapt_avmm1_config.hdpldadapt_avmm1_dprio_mapping.avmm_csr_ctrl[17] = 1'b1;  //r_sr_reserbits_in_en
     force `NDADAPT_RTB.hdpldadapt_avmm.hdpldadapt_avmm1.hdpldadapt_avmm1_config.hdpldadapt_avmm1_dprio_mapping.avmm_csr_ctrl[18] = 1'b1;  //r_sr_reserbits_out_en
     //force `NDADAPT_RTB.hdpldadapt_sr.r_sr_reserbits_in_en = 1'b1;
     //force `NDADAPT_RTB.hdpldadapt_sr.r_sr_reserbits_out_en = 1'b1;
  end

