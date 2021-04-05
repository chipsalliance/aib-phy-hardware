// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 

  task reset_duts ();
    begin
         $display("\n////////////////////////////////////////////////////////////////////////////");
         $display("%0t: Into task reset_dut", $time);
         $display("////////////////////////////////////////////////////////////////////////////\n");


         $display("\n////////////////////////////////////////////////////////////////////////////");
         $display("%0t:  task reset master and slave csr", $time);
         $display("////////////////////////////////////////////////////////////////////////////\n");

         top_tb.err_count = 0;
         avmm_if_m1.rst_n = 1'b0;
         avmm_if_m1.address = '0;
         avmm_if_m1.write = 1'b0;
         avmm_if_m1.read  = 1'b0;
         avmm_if_m1.writedata = '0;
         avmm_if_m1.byteenable = '0;
         avmm_if_s1.rst_n = 1'b0;
         avmm_if_s1.address = '0;
         avmm_if_s1.write = 1'b0;
         avmm_if_s1.read  = 1'b0;
         avmm_if_s1.writedata = '0;
         avmm_if_s1.byteenable = '0;

         intf_s1.por = 1'b1;
         intf_s1.i_conf_done = 1'b0;
         intf_s1.ns_mac_rdy      = '0;
         intf_s1.ns_adapter_rstn = '0;
         intf_s1.sl_rx_dcc_dll_lock_req = '0;
         intf_s1.sl_tx_dcc_dll_lock_req = '0;

         intf_m1.por = 1'b1;
         intf_m1.i_conf_done = 1'b0;
         intf_m1.ns_mac_rdy      = '0;
         intf_m1.ns_adapter_rstn = '0;
         intf_m1.ms_rx_dcc_dll_lock_req = '0;
         intf_m1.ms_tx_dcc_dll_lock_req = '0;

         intf_m1.data_in[79:0] = 80'b0;
         intf_s1.data_in[79:0] = 80'b0;
         intf_m1.data_in_f[319:0] = 320'b0;
         intf_s1.data_in_f[319:0] = 320'b0;

         #100ns;

         avmm_if_m1.rst_n = 1'b1;
         avmm_if_s1.rst_n = 1'b1;

         #100ns;
         $display("%0t: %m: de-asserting configuration reset and start configuration setup", $time);



  //     intf_m1.m_por_ovrd = 1'b1;   //Check with Wei regarding the polarity      
  //     intf_s1.m_device_detect_ovrd = 1'b0;
  //     intf_s1.m_power_on_reset = 1'b0;
         #100ns;
         intf_s1.por = 1'b0;
         $display("\n////////////////////////////////////////////////////////////////////////////");
         $display("%0t:  slave power on  de-asserted", $time);
         $display("////////////////////////////////////////////////////////////////////////////\n");

         #200ns;
         intf_m1.por = 1'b0;
         $display("\n////////////////////////////////////////////////////////////////////////////");
         $display("%0t: master power_on_reset de-asserted", $time);
         $display("////////////////////////////////////////////////////////////////////////////\n");
    end
  endtask

  task duts_wakeup ();
     begin
          intf_m1.i_conf_done = 1'b1;
          intf_s1.i_conf_done = 1'b1;

          intf_m1.ns_mac_rdy = 1'b1; 
          intf_s1.ns_mac_rdy = 1'b1; 

          #1000ns;
          intf_m1.ns_adapter_rstn = 1'b1;
          intf_s1.ns_adapter_rstn = 1'b1;
          #1000ns;
          intf_s1.sl_rx_dcc_dll_lock_req = 1'b1;
          intf_s1.sl_tx_dcc_dll_lock_req = 1'b1;

          intf_m1.ms_rx_dcc_dll_lock_req = 1'b1;
          intf_m1.ms_tx_dcc_dll_lock_req = 1'b1;


     end
  endtask

  task init_wa_toggle ();
       static int toggle_gen = 0;
        bit [79:0] data = 0;

        while (toggle_gen < run_for_n_wa_cycle) begin
            $display ("[%t] ms1 Generating data[%d] for naddar alignemnt  = %x \n", $time, toggle_gen, data);

            @(posedge intf_m1.m_ns_fwd_clk);
            intf_m1.data_in[39:0] <= data;
            toggle_gen++;
            data[39] = ~data[39];
        end
  endtask
///////////////////////////////////////////////////
/* Send data from master side with register mode */
///////////////////////////////////////////////////

  task ms1_data_xmit ();      //Reg mode
        static int pkts_gen = 0;
        bit [79:0] data = 0;
        while (pkts_gen < run_for_n_pkts_ms1) begin
            data[79:0] = {$random, $random, $random};
            $display ("[%t] ms1 Generating data[%d] = %x \n", $time, pkts_gen, data);

            @(posedge intf_m1.m_ns_fwd_clk);
            intf_m1.data_in[79:0] <= data;
            ms1_xmit_q.push_back(data);
            pkts_gen++;
        end
  endtask


///////////////////////////////////////////////////
/* Send data from master side with FIFO mode */
///////////////////////////////////////////////////

  task ms1_data_xmit_fifo ();
        static int pkts_gen = 0;
        bit [319:0] data = 0;
        bit [319:0] din = 0;
        bit [319:0] exp_din = 0;
        while (pkts_gen < run_for_n_pkts_ms1) begin
            din = fifo_din(ms1_tx_fifo_mode);
            $display ("[%t] ms1 Generating data[%d] = %x \n", $time, pkts_gen, din);
            exp_din = sb_data(din, ms1_tx_fifo_mode, ms1_tx_markbit);
            @(posedge intf_m1.m_wr_clk);
            intf_m1.data_in_f[319:0] =  din;
            ms1_xmit_f_q.push_back(exp_din);
            pkts_gen++;
        end
  endtask

  function [319:0] fifo_din(input [1:0] fifo_mode);
     bit [319:0] data= 0;
     begin
        data[319:160] = {$random, $random, $random, $random, $random};
        data[159:0] = {$random, $random, $random, $random, $random};

        case (fifo_mode) 
          2'b00: fifo_din ={240'h0, data[79:0]};
          2'b01: fifo_din ={160'h0, data[159:0]};
          2'b10: fifo_din =data[319:0];
          2'b11: fifo_din ={320'h0};
        endcase
     end

  endfunction

  function [319:0] sb_data(input [319:0] din, input [1:0] fifo_mode, input [4:0] markbit);
     begin
        case (fifo_mode)
          2'b00: sb_data =din;
          2'b01: case (markbit)
                   5'b10000: sb_data ={din[319:160], 1'b1,     din[158], din[157], din[156], din[155:80], 
                                                     1'b0,     din[78],  din[77],  din[76],  din[75:0]}; 
                   5'b01000: sb_data ={din[319:160], din[159], 1'b1,     din[157], din[156], din[155:80], 
                                                     din[79],  1'b0,     din[77],  din[76],  din[75:0]}; 
                   5'b00100: sb_data ={din[319:160], din[159], din[158], 1'b1,     din[156], din[155:80], 
                                                     din[79],  din[78],  1'b0,     din[76],  din[75:0]}; 
                   5'b00010: sb_data ={din[319:160], din[159], din[158], din[157], 1'b1,     din[155:80], 
                                                     din[79],  din[78],  din[77],  1'b0,     din[75:0]}; 
                   5'b00001: sb_data ={din[319:80],  1'b1,     din[78:40], 
                                                     1'b0,     din[38:0]}; 
                 endcase
          2'b10: case (markbit)
                   5'b10000: sb_data ={1'b1,     din[318], din[317], din[316], din[315:240], 
                                       1'b0,     din[238], din[237], din[236], din[235:160],
                                       1'b0,     din[158], din[157], din[156], din[155:80], 
                                       1'b0,     din[78],  din[77],  din[76],  din[75:0]}; 
                   5'b01000: sb_data ={din[319], 1'b1,     din[317], din[316], din[315:240], 
                                       din[239], 1'b0,     din[237], din[236], din[235:160],
                                       din[159], 1'b0,     din[157], din[156], din[155:80],
                                       din[79],  1'b0,     din[77],  din[76],  din[75:0]};
                   5'b00100: sb_data ={din[319], din[318], 1'b1,     din[316], din[315:240], 
                                       din[239], din[238], 1'b0,     din[236], din[235:160],
                                       din[159], din[158], 1'b0,     din[156], din[155:80],
                                       din[79],  din[78],  1'b0,     din[76],  din[75:0]};
                   5'b00010: sb_data ={din[319], din[318], din[317], 1'b1,     din[315:240], 
                                       din[239], din[238], din[237], 1'b0,     din[235:160],
                                       din[159], din[158], din[157], 1'b0,     din[155:80],
                                       din[79],  din[78],  din[77],  1'b0,     din[75:0]};
                   endcase
          2'b11: sb_data ={320'h0};
        endcase
     end

  endfunction


//////////////////////////////////////////////////
/* Send data from slave side with register mode */
//////////////////////////////////////////////////
  task sl1_data_xmit ();  //reg mode
        static int pkts_gen = 0;
        bit [79:0] data = 0;
        while (pkts_gen < run_for_n_pkts_sl1) begin
            data[79:0] = {$random, $random, $random};
            $display ("[%t] sl1 Generating data[%d] = %x \n", $time, pkts_gen, data);

            @(posedge intf_s1.m_ns_fwd_clk);
            intf_s1.data_in[79:0] <= data;
            sl1_xmit_q.push_back(data);
            pkts_gen++;
        end
  endtask

//////////////////////////////////////////////////
/* Send data from slave side with FIFO mode */
//////////////////////////////////////////////////
  task sl1_data_xmit_fifo ();
        static int pkts_gen = 0;
        bit [319:0] data = 0;
        bit [319:0] din = 0;
        bit [319:0] exp_din = 0;
        while (pkts_gen < run_for_n_pkts_sl1) begin
            din = fifo_din(sl1_tx_fifo_mode);
            $display ("[%t] sl1 Generating data[%d] = %x \n", $time, pkts_gen, din);
            exp_din = sb_data(din, sl1_tx_fifo_mode, sl1_tx_markbit);
            @(posedge intf_s1.m_wr_clk);
            intf_s1.data_in_f[319:0] <=  din;
            sl1_xmit_f_q.push_back(exp_din);
            pkts_gen++;
        end
  endtask

////////////////////////////////////////////////////////////////
/* Receive and check data from master side with register mode */
////////////////////////////////////////////////////////////////
  task ms1_data_rcv ();   //reg mode. Received data is transmitting from slave
        bit [79:0] data_exp = 0;
        static int pkts_rcvd = 0;
        begin
            while(pkts_rcvd < (run_for_n_pkts_ms1)) begin
                @ (posedge intf_m1.m_fs_fwd_clk);
                if (intf_m1.data_out[79:0] !== 0) begin
                    $display ("[%t] ms1 Receiving data[%d] = %x \n", $time, pkts_rcvd, intf_m1.data_out);
                    data_exp = sl1_xmit_q.pop_front();
                    pkts_rcvd++;
                    if (intf_m1.data_out !== data_exp) begin
                        err_count++;
                        $display ("[%t] ms1 DATA COMPARE ERROR: received = %x | expected = %x\n", $time, intf_m1.data_out, data_exp);
                    end
                end
            end
            if (sl1_xmit_q.size() != 0) //check if all the data are received
              $display("[%t]ERROR: sl1 Tramit Queue Not Empty, still %d data left\n", $time, sl1_xmit_q.size());

        end
  endtask 

////////////////////////////////////////////////////////////////
/* Receive and check data from master side with FIFO mode */
////////////////////////////////////////////////////////////////
  task ms1_data_rcv_fifo ();   //Received data is transmitting from slave
        bit [319:0] data_exp = 0;
        bit [319:0] data_rcvd = 0;
        static int pkts_rcvd = 0;
        begin
            while(pkts_rcvd < (run_for_n_pkts_ms1)) begin
                @ (posedge intf_m1.m_rd_clk);
                data_rcvd = intf_m1.data_out_f;
                if (din_rcv_vld(data_rcvd, ms1_rx_fifo_mode)) begin
                    $display ("[%t] ms1 Receiving data[%d] = %x \n", $time, pkts_rcvd, data_rcvd);
                    data_exp = sl1_xmit_f_q.pop_front();
                    pkts_rcvd++;
                    if (data_rcvd !== data_exp) begin
                        err_count++;
                        $display ("[%t] ms1 DATA COMPARE ERROR: received = %x | expected = %x\n", $time, intf_m1.data_out_f[79:0], data_exp);
                    end
                end
            end
            if (sl1_xmit_f_q.size() != 0) //check if all the data are received
              $display("[%t]ERROR: sl1 Tramit Queue Not Empty, still %d data left\n", $time, sl1_xmit_q.size());

        end
  endtask

  function [319:0] din_rcv_vld(input[319:0] data, input [1:0] fifo_mode);
     begin
        case (fifo_mode)
          2'b00:  din_rcv_vld = (data[79:0]  !== 0);
          2'b01:  din_rcv_vld = (data[155:0] !== 0);   //For AIB Gen2, top 4 bit can be programmable marker bit
          2'b10:  din_rcv_vld = (data[315:0] !== 0);   //For AIB Gen2, top 4 bit can be programmable marker bit
          2'b11:  din_rcv_vld = (data[79:0]  !== 0);   //AIB1.0 TBD
        endcase
     end

  endfunction


///////////////////////////////////////////////////////////////
/* Receive and check data from slave side with register mode */
///////////////////////////////////////////////////////////////

  task sl1_data_rcv ();   //reg_mode. Received data is transmitting from master
        bit [79:0] data_exp = 0;
        static int pkts_rcvd = 0;
        begin
            while(pkts_rcvd < (run_for_n_pkts_ms1)) begin
                @ (posedge intf_s1.m_fs_fwd_clk);
                if (intf_s1.data_out[79:0] !== 0) begin
                    $display ("[%t] sl1 Receiving data[%d] = %x \n", $time, pkts_rcvd, intf_s1.data_out);
                    data_exp = ms1_xmit_q.pop_front();
                    pkts_rcvd++;
                    if (intf_s1.data_out !== data_exp) begin
                        err_count++;
                        $display ("[%t] sl1 DATA COMPARE ERROR: received = %x | expected = %x\n", $time, intf_s1.data_out, data_exp);
                    end
                end
            end
            if (ms1_xmit_q.size() != 0) //check if all the data are received
              $display("[%t]ERROR: sl1 Tramit Queue Not Empty, still %d data left\n", $time, ms1_xmit_q.size());

        end
  endtask

///////////////////////////////////////////////////////////////
/* Receive and check data from slave side with FIFO mode */
///////////////////////////////////////////////////////////////

  task sl1_data_rcv_fifo ();   //Received data is transmitting from master 
        bit [319:0] data_exp = 0;
        bit [319:0] data_rcvd = 0;
        static int pkts_rcvd = 0;
        begin
            while(pkts_rcvd < (run_for_n_pkts_ms1)) begin
                @ (posedge intf_s1.m_rd_clk); 
                data_rcvd = intf_s1.data_out_f;
                if (din_rcv_vld(data_rcvd, sl1_rx_fifo_mode)) begin
                    $display ("[%t] sl1 Receiving data[%d] = %x \n", $time, pkts_rcvd, data_rcvd);
                    data_exp = ms1_xmit_f_q.pop_front();
                    pkts_rcvd++;
                    if (data_rcvd !== data_exp) begin
                        err_count++;
                        $display ("[%t] sl1 DATA COMPARE ERROR: received = %x | expected = %x\n", $time, intf_m1.data_out_f[79:0], data_exp);
                    end
                end
            end
            if (ms1_xmit_f_q.size() != 0) //check if all the data are received
              $display("[%t]ERROR: sl1 Tramit Queue Not Empty, still %d data left\n", $time, ms1_xmit_q.size());

        end
  endtask



  task link_up (); 
       begin
         wait (intf_s1.ms_tx_transfer_en == 1'b1);
         wait (intf_s1.sl_tx_transfer_en == 1'b1);
          
       end
  endtask


  task Finish ();
        begin
            $display("%0t: %m: finishing simulation..", $time);
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
