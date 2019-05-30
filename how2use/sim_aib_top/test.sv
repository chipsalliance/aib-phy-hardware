// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. All rights reserved
// This tests shows how to test 24 channel AIB (all channels are independent)
// in loopback mode. DCC/DLL are bypassed. The delay setting is static
// 03/13/2019
// ==========================================================================

program automatic test (dut_io.TB dut);

    int err_count;
    int run_for_n_pkts;
    logic [5:0] chan_id;        
    logic [39:0] xmit_q [$];
    logic [31:0] read_data_reg;        
    //========================================================================
    //========================================================================
    // Main

    initial
      begin
	 // $vpdpluson;
	  run_for_n_pkts = 1000;
          chan_id = 0;
          reset_sequence (); 

          wait_xfer_ready     ();
          $display ("[%t] Xfer Ready", $time);
          $display ("[%t] start AIB chiplet standalone loopback testing by running %d packets", $time, run_for_n_pkts);
	  fork
	      data_xmit ();
	      data_rcv  ();
	  join
	  $display ("[%t] ######### Debug: All Tasks are finished normally #############", $time);
	  //if (slv_sb.is_empty ())
	  Finish ();
      end

    //******************************************************************************
    //  Reset Tasks
    //******************************************************************************
    task reset_sequence ();
        int random_dly_cycle;
        
	begin
	    dut.i_adpt_hard_rst_n <= 1'b0;
            dut.i_cfg_avmm_rst_n  <= 1'b0;
            
            err_count <= 0;

            //cfg_avmm_clk domain
	    dut.cb_cfg_avmm.i_channel_id      <= 0;
	    dut.cb_cfg_avmm.i_cfg_avmm_write  <= 0;
	    dut.cb_cfg_avmm.i_cfg_avmm_read   <= 0;
	    dut.cb_cfg_avmm.i_cfg_avmm_addr   <= 0;
	    dut.cb_cfg_avmm.i_cfg_avmm_byte_en<= 0;
	    dut.cb_cfg_avmm.i_cfg_avmm_wdata  <= 0;
            dut.cb_cfg_avmm.i_adpt_cfg_rdatavld <= 0;
            dut.cb_cfg_avmm.i_adpt_cfg_rdata    <= 0;
            dut.cb_cfg_avmm.i_adpt_cfg_waitreq  <= 0;
            
	    // cb_rx_pma
            dut.cb_rx_pma.i_rx_pma_data <= 0;
            
	    // cb_osc
	    dut.cb_osc.i_chnl_ssr <= 0;
            
	    $display("\n////////////////////////////////////////////////////////////////////////////");
	    $display("%0t: System Reset", $time);
	    $display("////////////////////////////////////////////////////////////////////////////\n");
	    random_dly_cycle = ({$random} % 50) + 5;     
	    repeat (random_dly_cycle) @ (posedge top.i_osc_clk);
	    $display("%0t: %m: de-asserting configuration reset and start configuration setup", $time);
            dut.i_cfg_avmm_rst_n  <= 1'b1;
            configuration_setup(6'h0);

            $display ("[%t] start configuration", $time);
            while (chan_id < 24) begin
                configuration_setup(chan_id);
                $display ("[%t] config AIB channel [%d] \n", $time, chan_id);
                configuration_read(chan_id);
                chan_id++;
            end


            $display ("[%t] Done configuration", $time);
            
	    repeat (random_dly_cycle) @ (posedge top.i_osc_clk);            
	    dut.i_adpt_hard_rst_n <= 1'b1;
	    $display("%0t: %m: de-asserting adapter hard reset", $time);

            //force the dcd cal request
            random_dly_cycle = ({$random} % 50) + 5;
            repeat (10*random_dly_cycle) @ (posedge top.i_osc_clk);

	end
    endtask // Reset

    task cfg_avmm_write (input [5:0]  chan_num,  //avmm base address
                         input [10:0] addr,
                         input [ 3:0] be,
                         input [31:0] wdata
                         );
        begin
            @(posedge top.i_cfg_avmm_clk);
            dut.cb_cfg_avmm.i_cfg_avmm_write <= 1'b1;
            dut.cb_cfg_avmm.i_cfg_avmm_addr  <= {chan_num, addr};
            dut.cb_cfg_avmm.i_cfg_avmm_byte_en <= be;
            dut.cb_cfg_avmm.i_cfg_avmm_wdata <= wdata;
            repeat (3) @(posedge top.i_cfg_avmm_clk);
            dut.cb_cfg_avmm.i_cfg_avmm_write <= 1'b0;
        end

    endtask

    task cfg_avmm_read  (input  [5:0]  chan_num,  //avmm base address
                         input  [10:0] addr,
                         input  [ 3:0] be,
                         output [31:0] rdata
                         );
        begin
            @(posedge top.i_cfg_avmm_clk);
            dut.cb_cfg_avmm.i_cfg_avmm_read <= 1'b1;
            dut.cb_cfg_avmm.i_cfg_avmm_addr  <= {chan_num, addr};
            dut.cb_cfg_avmm.i_cfg_avmm_byte_en <= be;
            repeat (3) @(posedge top.i_cfg_avmm_clk);
            @(posedge top.o_cfg_avmm_rdatavld);
            rdata = top.o_cfg_avmm_rdata;
            $display("READ_MM: address %x =  %x", addr, rdata);
//          @(negedge top.o_cfg_avmm_rdatavld);
            dut.cb_cfg_avmm.i_cfg_avmm_read <= 1'b0;
        end

    endtask


    //************************************************
    // task to setup the configuration
    //************************************************
    task configuration_setup (input [5:0] chan_num);
        begin
            repeat (30) @(posedge top.i_cfg_avmm_clk);    //wait some clock cycles for adapter to be stable
    //      configuration_read;
            cfg_avmm_write(chan_num, 11'h204, 4'hf, 32'h0000_0000);
            cfg_avmm_write(chan_num, 11'h208, 4'hf, 32'h0278_0204);
            cfg_avmm_write(chan_num, 11'h20c, 4'hf, 32'h0000_0282);
            cfg_avmm_write(chan_num, 11'h210, 4'hf, 32'h0287_1f00);
            cfg_avmm_write(chan_num, 11'h214, 4'hf, 32'h0000_80c3); 
            cfg_avmm_write(chan_num, 11'h218, 4'hf, 32'h4700_8004);
            cfg_avmm_write(chan_num, 11'h21c, 4'hf, 32'h0000_0024);
            cfg_avmm_write(chan_num, 11'h220, 4'hf, 32'he388_c00a);
            cfg_avmm_write(chan_num, 11'h224, 4'hf, 32'h3012_7f38);
            cfg_avmm_write(chan_num, 11'h228, 4'hf, 32'h0000_7451);
            cfg_avmm_write(chan_num, 11'h22c, 4'hf, 32'h0000_0000);
//          cfg_avmm_write(chan_num, 11'h230, 4'hf, 32'h38f6_007b); //DLL not bypass
//          cfg_avmm_write(chan_num, 11'h230, 4'hf, 32'h00f6_047b); //DLL bypass, disable
            cfg_avmm_write(chan_num, 11'h230, 4'hf, 32'h00f6_0400); //DLL bypass, disable. Least static delay setting
            cfg_avmm_write(chan_num, 11'h234, 4'hf, 32'h0000_0000);
            cfg_avmm_write(chan_num, 11'h238, 4'hf, 32'h0000_0000);
            cfg_avmm_write(chan_num, 11'h23c, 4'hf, 32'h0000_0000);
            cfg_avmm_write(chan_num, 11'h240, 4'hf, 32'h0000_0000);
            cfg_avmm_write(chan_num, 11'h2fc, 4'hf, 32'h000f_0000);
            cfg_avmm_write(chan_num, 11'h300, 4'hf, 32'h0000_0000);
            cfg_avmm_write(chan_num, 11'h304, 4'hf, 32'h0000_0000);
            cfg_avmm_write(chan_num, 11'h308, 4'hf, 32'h0000_0000);
            cfg_avmm_write(chan_num, 11'h30c, 4'hf, 32'h0000_0000);
            cfg_avmm_write(chan_num, 11'h310, 4'hf, 32'h000f_0000);
            cfg_avmm_write(chan_num, 11'h314, 4'hf, 32'h0000_000e);
            cfg_avmm_write(chan_num, 11'h318, 4'hf, 32'h0010_0f86);
            cfg_avmm_write(chan_num, 11'h31c, 4'hf, 32'h0000_0f80);
            cfg_avmm_write(chan_num, 11'h320, 4'hf, 32'h0000_0000);
            cfg_avmm_write(chan_num, 11'h324, 4'hf, 32'h0000_0000);
            cfg_avmm_write(chan_num, 11'h328, 4'hf, 32'h0000_0000);
            cfg_avmm_write(chan_num, 11'h32c, 4'hf, 32'h5555_a019);
            
            cfg_avmm_write(chan_num, 11'h330, 4'hf, 32'h0040_0082); //Bit 21 is idatdll_str_align_stconfig_new_dll[2] msb static delay
      //    cfg_avmm_write(chan_num, 11'h334, 4'hf, 32'hbf0f_b000); /DCC not bypass 
            cfg_avmm_write(chan_num, 11'h334, 4'hf, 32'hbf0f_9000); //DCC bypass
            cfg_avmm_write(chan_num, 11'h338, 4'hf, 32'h0002_a9e1);
       //   cfg_avmm_write(chan_num, 11'h33c, 4'hf, 32'h00ff_fff0);
            cfg_avmm_write(chan_num, 11'h33c, 4'hf, 32'h00ff_fff4);   
            cfg_avmm_write(chan_num, 11'h340, 4'hf, 32'h7f1c_0000);
            cfg_avmm_write(chan_num, 11'h344, 4'hf, 32'h0000_1c00);
            cfg_avmm_write(chan_num, 11'h348, 4'hf, 32'h0000_0000);
            cfg_avmm_write(chan_num, 11'h34c, 4'hf, 32'h0000_0000);
            cfg_avmm_write(chan_num, 11'h350, 4'hf, 32'h0000_0000);
            cfg_avmm_write(chan_num, 11'h354, 4'hf, 32'h0000_0000);
            
        end
    endtask
    task configuration_read (input [5:0] chan_num);
        begin
            repeat (10) @(posedge top.i_cfg_avmm_clk);    //wait some clock cycles for adapter to be stable
            cfg_avmm_read(chan_num, 11'h204, 4'hf, read_data_reg);
            cfg_avmm_read(chan_num, 11'h208, 4'hf, read_data_reg);
            cfg_avmm_read(chan_num, 11'h20c, 4'hf, read_data_reg);
            cfg_avmm_read(chan_num, 11'h210, 4'hf, read_data_reg);
            cfg_avmm_read(chan_num, 11'h214, 4'hf, read_data_reg);
            cfg_avmm_read(chan_num, 11'h218, 4'hf, read_data_reg);
            cfg_avmm_read(chan_num, 11'h21c, 4'hf, read_data_reg);
            cfg_avmm_read(chan_num, 11'h220, 4'hf, read_data_reg);
        end
    endtask


    //***************************************************
    // Wait for transfer ready before start pumping data
    //***************************************************
    task wait_xfer_ready();
    //  wait (top.dut.c3aibadapt.adapt_rxchnl.rxrst_ctl.sr_fabric_rx_transfer_en);
        wait (top.u_aib_top.u_c3aibadapt_wrap_top.u_c3aibadapt_0.c3aibadapt.adapt_txchnl.txrst_ctl.sync_aib_hssi_tx_dll_lock);
        
    endtask
    //************************************************
    // task below generates data on RX path to DUT
    //************************************************
    
    task data_xmit ();
	static int pkts_gen = 0;
	bit [39:0] data;
	
        while (pkts_gen < run_for_n_pkts) begin
	    data = $random;
	    $display ("[%t] Generating data[%d] = %x \n", $time, pkts_gen, data);
            
	    @(posedge top.i_rx_pma_clk);
	    dut.cb_rx_pma.i_rx_pma_data <= data;
            xmit_q.push_back(data);
            pkts_gen++;
        end
    endtask

    //*************************************************
    // task to check data received on TX side
    //*************************************************
    task data_rcv ();
        bit [39:0] data_exp = 0;
        static int pkts_rcvd = 0;
        begin
            while(pkts_rcvd < run_for_n_pkts) begin
                @ (posedge top.i_tx_pma_clk);
                if (top.o_tx_pma_data_24ch != 0) begin
                    $display ("[%t] Receiving data[%d] = %x \n", $time, pkts_rcvd, top.o_tx_pma_data_24ch);
                    data_exp = xmit_q.pop_front();
                    pkts_rcvd++;
                    if (top.o_tx_pma_data_24ch != {24{data_exp}}) begin
                        err_count++;
                        $display ("[%t]DATA COMPARE ERROR: received = %x | expected = %x\n", $time, top.o_tx_pma_data_24ch, data_exp);
                    end   
                end
            end
            if (xmit_q.size() != 0) //check if all the data are received
              $display("[%t]ERROR: Tramit Queue Not Empty, still %d data left\n", $time, xmit_q.size());
            
        end
    endtask // mstr_req_rcv
        


    //---------------------------------------------------------------
    // Finish

    task Finish ();
	begin
	    $display("%0t: %m: finishing simulation..", $time);
	    repeat (100) @(posedge top.i_osc_clk);
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

endprogram // test
    
