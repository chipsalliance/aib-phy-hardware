// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 

program automatic test (dut_io.TB dut);

    int err_count;
    int run_for_n_pkts;
    int run_for_n_wa_cycle;
        
    logic [39:0] xmit_q [$];
    logic [31:0] read_data_reg;
        
    // Main

    initial
      begin
	 // $vpdpluson;
	  run_for_n_pkts = 10;
	  reset_sequence ();

//        wait_xfer_ready     ();
         // $display ("[%t] Xfer Ready", $time);
    //    $display ("[%t] start AIB chiplet standalone loopback testing by running %d packets", $time, run_for_n_pkts);
 //       init_wa_toggle ();
 //  fork
 //      data_xmit ();
 //      data_rcv  ();
 //  join
//	  $display ("[%t] ######### Debug: All Tasks are finished normally #############", $time);
	  //if (slv_sb.is_empty ())
          //configuration_read;
//	  Finish ();
          #100000ns;
      end

    //******************************************************************************
    //  Reset Tasks
    //******************************************************************************
    task reset_sequence ();
        int random_dly_cycle;
        
	begin
	    dut.i_adpt_hard_rst_n <= 1'b0;
            dut.i_cfg_avmm_rst_n  <= 1'b0;
            dut.ns_mac_rdy <= 1'b0;
            
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
            configuration_setup();
            $display ("[%t] Done configuration", $time);
            dut.ns_mac_rdy <= 1'b1; 
            $display ("[%t] ns_mac_rdy is up. Clock should be stable prior to this", $time);
	    repeat (random_dly_cycle) @ (posedge top.i_cfg_avmm_clk);            
	    dut.i_adpt_hard_rst_n <= 1'b1;
	    $display("%0t: %m: de-asserting adapter hard reset", $time);

            //
            random_dly_cycle = ({$random} % 50) + 5;
            repeat (10*random_dly_cycle) @ (posedge top.i_osc_clk);

	end
    endtask // Reset

    task cfg_avmm_write (input [10:0] addr,
                         input [ 3:0] be,
                         input [31:0] wdata
                         );
        begin
            @(posedge top.i_cfg_avmm_clk);
            dut.cb_cfg_avmm.i_cfg_avmm_write <= 1'b1;
            dut.cb_cfg_avmm.i_cfg_avmm_addr  <= {6'h0, addr};
            dut.cb_cfg_avmm.i_cfg_avmm_byte_en <= be;
            dut.cb_cfg_avmm.i_cfg_avmm_wdata <= wdata;
            repeat (3) @(posedge top.i_cfg_avmm_clk);
            dut.cb_cfg_avmm.i_cfg_avmm_write <= 1'b0;
        end

    endtask
/*
    task cfg_avmm_read  (input  [10:0] addr,
                         input  [ 3:0] be,
                         output [31:0] rdata
                         );
        begin
            @(posedge top.i_cfg_avmm_clk);
            dut.cb_cfg_avmm.i_cfg_avmm_read <= 1'b1;
            dut.cb_cfg_avmm.i_cfg_avmm_addr  <= {6'h0, addr};
            dut.cb_cfg_avmm.i_cfg_avmm_byte_en <= be;
            repeat (3) @(posedge top.i_cfg_avmm_clk);
            @(posedge top.o_cfg_avmm_rdatavld);
            rdata = top.o_cfg_avmm_rdata;
            $display("READ_MM: address %x =  %x", addr, rdata);
            @(negedge top.o_cfg_avmm_rdatavld);
            dut.cb_cfg_avmm.i_cfg_avmm_read <= 1'b0;
        end

    endtask
*/

    task cfg_avmm_read  (input  [10:0] addr,
                         input  [ 3:0] be,
                         output [31:0] rdata
                         );
        begin
            @(posedge top.i_cfg_avmm_clk);
            dut.cb_cfg_avmm.i_cfg_avmm_read <= 1'b1;
            dut.cb_cfg_avmm.i_cfg_avmm_addr  <= {6'h0, addr};
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
    task configuration_setup;
        begin
            repeat (10) @(posedge top.i_cfg_avmm_clk);    //wait some clock cycles for adapter to be stable
            //configuration_read;
            cfg_avmm_write(11'h204, 4'hf, 32'h0000_0000);
            cfg_avmm_write(11'h208, 4'hf, 32'h0a78_0202);
            cfg_avmm_write(11'h20c, 4'hf, 32'h0000_0282);
            cfg_avmm_write(11'h210, 4'hf, 32'h0287_9f07);
            cfg_avmm_write(11'h214, 4'hf, 32'h0000_0003); //choose rx_fifo_rd_clk_sel to be div2 tx_transfer_clk 
            cfg_avmm_write(11'h218, 4'hf, 32'h6ea0_8002);
            cfg_avmm_write(11'h21c, 4'hf, 32'h0100_8025); //turn on bit 24 for enable aib_lpbk_mode, bit 15:14 if 1, 1x mode, if 2, 2xmode, 3, loopback before tx fifo.
            cfg_avmm_write(11'h220, 4'hf, 32'he388_c0ca);
            cfg_avmm_write(11'h224, 4'hf, 32'h0032_aee8); //bit 18:16 is rx_fifo_rd_clk_sel[2:0] here to set 4 so that tx_aib_transfer_clk is selected. 15:13 is write clock
            cfg_avmm_write(11'h228, 4'hf, 32'h0000_0651);
            cfg_avmm_write(11'h22c, 4'hf, 32'h0000_0000);
            cfg_avmm_write(11'h230, 4'hf, 32'h38f6_007b);
            cfg_avmm_write(11'h234, 4'hf, 32'h0000_0000);
            cfg_avmm_write(11'h238, 4'hf, 32'h0000_0000);
            cfg_avmm_write(11'h23c, 4'hf, 32'h0000_0000);
            cfg_avmm_write(11'h240, 4'hf, 32'h0000_0000);
            cfg_avmm_write(11'h2fc, 4'hf, 32'h000f_0000);
            cfg_avmm_write(11'h300, 4'hf, 32'h0000_0000);
            cfg_avmm_write(11'h304, 4'hf, 32'h0000_0000);
            cfg_avmm_write(11'h308, 4'hf, 32'h0000_0000);
            cfg_avmm_write(11'h30c, 4'hf, 32'h0000_0000);
            cfg_avmm_write(11'h310, 4'hf, 32'h000f_0000);
//          cfg_avmm_write(11'h314, 4'hf, 32'h0000_000e);
            cfg_avmm_write(11'h314, 4'hf, 32'h0000_0000); //turn off sr_reserved_in_en/out_en sr_parity_en for spec compliance
            cfg_avmm_write(11'h318, 4'hf, 32'h0010_0f82);
            cfg_avmm_write(11'h31c, 4'hf, 32'h0000_0f80);
            cfg_avmm_write(11'h320, 4'hf, 32'h0000_0000);
            cfg_avmm_write(11'h324, 4'hf, 32'h0000_0000);
            cfg_avmm_write(11'h328, 4'hf, 32'h0000_0000);
            cfg_avmm_write(11'h32c, 4'hf, 32'h5555_a019);
            
            cfg_avmm_write(11'h330, 4'hf, 32'h0040_0082);
            cfg_avmm_write(11'h334, 4'hf, 32'hbf0f_b000); 
            cfg_avmm_write(11'h338, 4'hf, 32'h0002_a1e1);
            cfg_avmm_write(11'h33c, 4'hf, 32'h00ff_fff0);
            cfg_avmm_write(11'h340, 4'hf, 32'h7f1c_0000);
            cfg_avmm_write(11'h344, 4'hf, 32'h0000_1c00);
            cfg_avmm_write(11'h348, 4'hf, 32'h0000_0000);
            cfg_avmm_write(11'h34c, 4'hf, 32'h0000_0000);
            cfg_avmm_write(11'h350, 4'hf, 32'h0000_0000);
            cfg_avmm_write(11'h354, 4'hf, 32'h0000_0000);
            
        end
    endtask

    task config_unuse_pin;
        begin
            repeat (10) @(posedge top.i_cfg_avmm_clk);    
        //  cfg_avmm_write(11'h32c, 4'hf, 32'h5555_a099); //Disable AIB 45 set irx_en[2:0] = 3'b010; 32c bit [7]
            cfg_avmm_write(11'h334, 4'hf, 32'hbf0d_b000); //Disable AIB 46 set tx_en = 1'b0; bit 17 
        end
    endtask

    //************************************************
    // task to read back the configuration
    //************************************************
    task configuration_read;
        begin
            repeat (10) @(posedge top.i_cfg_avmm_clk);    //wait some clock cycles for adapter to be stable
            cfg_avmm_read(11'h204, 4'hf, read_data_reg);
            cfg_avmm_read(11'h208, 4'hf, read_data_reg);
            cfg_avmm_read(11'h20c, 4'hf, read_data_reg);
            cfg_avmm_read(11'h210, 4'hf, read_data_reg);
            cfg_avmm_read(11'h214, 4'hf, read_data_reg);
            cfg_avmm_read(11'h218, 4'hf, read_data_reg);
            cfg_avmm_read(11'h21c, 4'hf, read_data_reg);
            cfg_avmm_read(11'h220, 4'hf, read_data_reg);
            cfg_avmm_read(11'h22c, 4'hf, read_data_reg);
            cfg_avmm_read(11'h304, 4'hf, read_data_reg);
            cfg_avmm_write(11'h304, 4'hf, 32'hf537bbfa);
            cfg_avmm_read(11'h304, 4'hf, read_data_reg);
        end
    endtask


endprogram // test
    
