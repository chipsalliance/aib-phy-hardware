// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
  
  task reset_duts ();
    begin
         $display("\n////////////////////////////////////////////////////////////////////////////");
         $display("%0t: Into task reset_dut", $time);
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

         intf_s1.i_conf_done     = 1'b0;
         intf_s1.ns_mac_rdy      = '0;
         intf_s1.ns_adapter_rstn = '0;
         intf_s1.sl_rx_dcc_dll_lock_req = '0;
         intf_s1.sl_tx_dcc_dll_lock_req = '0;

         intf_m1.i_conf_done = 1'b0;
         intf_m1.ns_mac_rdy      = '0;
         intf_m1.ns_adapter_rstn = '0;
         intf_m1.ms_rx_dcc_dll_lock_req = '0;
         intf_m1.ms_tx_dcc_dll_lock_req = '0;
         #100ns;

         intf_m1.m_por_ovrd = 1'b1;   
         intf_s1.m_device_detect_ovrd = 1'b0;
         intf_s1.i_m_power_on_reset = 1'b0;

         intf_m1.data_in = {TOTAL_CHNL_NUM{80'b0}};
         intf_s1.data_in = {TOTAL_CHNL_NUM{80'b0}};

         intf_m1.data_in_f = {TOTAL_CHNL_NUM{320'b0}};
         intf_s1.data_in_f = {TOTAL_CHNL_NUM{320'b0}};

         intf_m1.gen1_data_in = {TOTAL_CHNL_NUM{40'b0}};

         intf_m1.gen1_data_in_f = {TOTAL_CHNL_NUM{320'b0}};
         intf_s1.gen1_data_in_f = {TOTAL_CHNL_NUM{80'b0}};

         #100ns;
         intf_s1.i_m_power_on_reset = 1'b1;
         $display("\n////////////////////////////////////////////////////////////////////////////");
         $display("%0t: Follower (Slave) power_on_reset asserted", $time);
         $display("////////////////////////////////////////////////////////////////////////////\n");

         #200ns;
         intf_s1.i_m_power_on_reset = 1'b0;
         $display("\n////////////////////////////////////////////////////////////////////////////");
         $display("%0t: Follower (Slave)  power_on_reset de-asserted", $time);
         $display("////////////////////////////////////////////////////////////////////////////\n");

         #200ns;
         avmm_if_m1.rst_n = 1'b1;
         avmm_if_s1.rst_n = 1'b1;

         #100ns;
         $display("%0t: %m: de-asserting configuration reset and start configuration setup", $time);
    end
  endtask

  task duts_wakeup ();
     begin
          intf_m1.i_conf_done = 1'b1;
          intf_s1.i_conf_done = 1'b1;

          intf_m1.ns_mac_rdy = {TOTAL_CHNL_NUM{1'b1}}; 
          intf_s1.ns_mac_rdy = {TOTAL_CHNL_NUM{1'b1}}; 

          #1000ns;
          intf_m1.ns_adapter_rstn = {TOTAL_CHNL_NUM{1'b1}};
          intf_s1.ns_adapter_rstn = {TOTAL_CHNL_NUM{1'b1}};
          #1000ns;
          intf_s1.sl_rx_dcc_dll_lock_req = {TOTAL_CHNL_NUM{1'b1}};
          intf_s1.sl_tx_dcc_dll_lock_req = {TOTAL_CHNL_NUM{1'b1}};

          intf_m1.ms_rx_dcc_dll_lock_req = {TOTAL_CHNL_NUM{1'b1}};
          intf_m1.ms_tx_dcc_dll_lock_req = {TOTAL_CHNL_NUM{1'b1}};
     end
  endtask

////////////////////////////////////////////////////////
/* AIB2.0 MS <-> AIB2.0 SL  in register mode 80b <-80b*/
///////////////////////////////////////////////////
  task ms1_aib2_reg2reg_xmit ();
        static int pkts_gen = 0;
        bit [(320*24-1):0] data_320;
        bit [(80*24-1):0] data;
        integer i;
        while (pkts_gen < run_for_n_pkts_ms1) begin
            data_320 = tx_data_gen(2'b11, 1'b1, 1'b0);
            for (i=0; i<24; i++) begin
              data[(i*80) +: 80] = data_320[(i*320) +: 80];
            end
            $display ("[%t] ms1 Generating data[%d] = %x \n", $time, pkts_gen, data);
            @(posedge intf_m1.m_ns_fwd_clk[0]);
            intf_m1.data_in <= data;
            sl1_rcv_80b_q.push_back(data);
            pkts_gen++;
        end
  endtask

  task sl1_aib2_reg2reg_xmit ();
        static int pkts_gen = 0;
        bit [(320*24-1):0] data_320;
        bit [(80*24-1):0] data;
        integer i;
        while (pkts_gen < run_for_n_pkts_sl1) begin
            data_320 = tx_data_gen(2'b11, 1'b1, 1'b0);
            for (i=0; i<24; i++) begin
              data[(i*80) +: 80] = data_320[(i*320) +: 80];
            end
            $display ("[%t] sl1 Generating data[%d] = %x \n", $time, pkts_gen, data);
            @(posedge intf_s1.m_ns_fwd_clk[0]);
            intf_s1.data_in <= data;
            ms1_rcv_80b_q.push_back(data);
            pkts_gen++;
        end
  endtask
////////////////////////////////////////////////////////////////
/* AIB2.0 Send data from master side with FIFO mode Symmetric */
//           FIFO1x <-> FIFO1x
//           FIFO2x <-> FIFO2x
//           FIFO4x <-> FIFO4x
////////////////////////////////////////////////////////////////
  task ms1_aib2_f2f_s_xmit ();
        static int pkts_gen = 0;
        bit [320*24-1:0] din = 0;
        bit [320*24-1:0] exp_din = 0;
        while (pkts_gen < run_for_n_pkts_ms1) begin
            din = tx_data_gen(sl1_rx_fifo_mode, 1'b1, 1'b0);
            $display ("[%t] ms1 Generating data[%d] = %x \n", $time, pkts_gen, din);
            @(posedge intf_m1.m_wr_clk);
            intf_m1.data_in_f <=  din;
            sl1_rcv_320b_q.push_back(din);
            pkts_gen++;
        end
  endtask

  task sl1_aib2_f2f_s_xmit ();
        static int pkts_gen = 0;
        bit [320*24-1:0] din = 0;
        bit [320*24-1:0] exp_din = 0;
        while (pkts_gen < run_for_n_pkts_sl1) begin
            din = tx_data_gen(ms1_rx_fifo_mode, 1'b1, 1'b0);
            $display ("[%t] ms1 Generating data[%d] = %x \n", $time, pkts_gen, din);
            @(posedge intf_s1.m_wr_clk);
            intf_s1.data_in_f <=  din;
            ms1_rcv_320b_q.push_back(din);
            pkts_gen++;
        end
  endtask
////////////////////////////////////////////////////////////////
/* AIB2.0 Send data from master side with FIFO mode aymmetric */
//           FIFO2x <-> FIFO4x
//           FIFO4x <-> FIFO2x
// In this mode, user needs to insert marker at transmit side
// in order for receiver side to detect properly. 
////////////////////////////////////////////////////////////////
  task ms1_aib2_usr_f2to4_xmit ();
        static int pkts_gen = 0;
        static int mrk_gen = 0;
        bit [320*24-1:0] din = 0;
        bit [320*24-1:0] exp_din = 0;

        while (mrk_gen < 4) begin
          @(posedge intf_m1.m_wr_clk);
              intf_m1.data_in_f = usrmod_mrkgen(2'b01, 2'b10, 1'b0, 1'b0);
          @(posedge intf_m1.m_wr_clk);
              intf_m1.data_in_f = usrmod_mrkgen(2'b01, 2'b10, 1'b1, 1'b0);
          mrk_gen++;
        end

        while (pkts_gen < run_for_n_pkts_ms1) begin
            din = tx_data_gen(sl1_rx_fifo_mode, 1'b1, 1'b0);
            $display ("[%t] ms1 Generating data[%d] = %x \n", $time, pkts_gen, din);
            @(posedge intf_m1.m_wr_clk);
            intf_m1.data_in_f =  din;
            usrmod_datgen(din, 2'b01, 2'b10, 1'b0);
            usrmod_datgen(din, 2'b01, 2'b10, 1'b1);
            sl1_rcv_320b_q.push_back(din);
            pkts_gen++;
        end
  endtask

  task ms1_aib2_usr_f4to2_xmit ();
        static int pkts_gen = 0;
        static int mrk_gen = 0;
        bit [320*24-1:0] din = 0;
        bit [320*24-1:0] exp_din = 0;

        while (mrk_gen < 4) begin
          @(posedge intf_m1.m_wr_clk);
              intf_m1.data_in_f = usrmod_mrkgen(2'b10, 2'b01, 1'b0, 1'b0);
          mrk_gen++;
        end
        while (pkts_gen < run_for_n_pkts_ms1) begin
            din = tx_data_gen(sl1_rx_fifo_mode, 1'b1, 1'b0);
            $display ("[%t] ms1 Generating data[%d] = %x \n", $time, pkts_gen, din);
            @(posedge intf_m1.m_wr_clk);
            intf_m1.data_in_f =  din;
            sl1_rcv_320b_q.push_back(din);
            pkts_gen++;
        end
  endtask

////////////////////////////////////////////////////////////////
/* AIB2.0 Gen1  Master FPGA AIB1.0 Slave */
//           FIFO2x AIB2.0 Gen1 <-> FIFO2x AIB1.0
////////////////////////////////////////////////////////////////
  task ms1_gen1toaib1_f2f_xmit ();
        static int pkts_gen = 0;
        static int mrk_gen = 0;
        integer j;
        bit [320*24-1:0] din = 0;
        bit [80*24-1:0]  din_80b = 0;

        while (mrk_gen < 4) begin
          @(posedge intf_m1.m_wr_clk);
              intf_m1.data_in_f = usrmod_mrkgen(2'b10, 2'b01, 1'b0, 1'b1);
          mrk_gen++;
        end
        while (pkts_gen < run_for_n_pkts_ms1) begin
            din = tx_data_gen(sl1_rx_fifo_mode, 1'b1, 1'b1);
            for (j=0; j<24; j++) begin
               din_80b[(j*80) +: 80] = din[(j*320) +: 80];
            end 
            $display ("[%t] ms1 Generating data[%d] = %x \n", $time, pkts_gen, din_80b);
            @(negedge intf_m1.m_wr_clk);
            intf_m1.data_in_f =  din;
            sl1_rcv_80b_q.push_back(din_80b);
            pkts_gen++;
        end
  endtask

////////////////////////////////////////////////////////////////
/* AIB2.0 Gen1  Master FPGA AIB1.0 Slave */
//           FIFO2x AIB2.0 Gen1 <-> FIFO2x AIB1.0
////////////////////////////////////////////////////////////////
  task sl1_aib1togen1_f2f_xmit ();
        static int pkts_gen = 0;
        static int mrk_gen = 0;
        integer j;
        bit [320*24-1:0] din = 0;
        bit [80*24-1:0]  din_80b = 0;
        bit [320*24-1:0] exp_din = 0;

        while (mrk_gen < 4) begin
          @(negedge intf_s1.m_wr_clk);
              intf_s1.gen1_data_in_f = usrmod_mrkgen(2'b10, 2'b01, 1'b0, 1'b1);
          mrk_gen++;
        end
        while (pkts_gen < run_for_n_pkts_sl1) begin
            din = tx_data_gen(ms1_rx_fifo_mode, 1'b0, 1'b1);
            for (j=0; j<24; j++) begin
               din_80b[(j*80) +: 80] = din[(j*320) +: 80];
            end
            $display ("[%t] sl1 Generating data[%d] = %x \n", $time, pkts_gen, din_80b);
            @(negedge intf_s1.m_wr_clk);
            intf_s1.gen1_data_in_f =  din_80b;
            ms1_rcv_320b_q.push_back(din);
            pkts_gen++;
        end
  endtask

////////////////////////////////////////////////////////////////
/* AIB1.0 Master to AIB2.0 Gen1 FIFO2x Slave */
//          REG Mode AIB1.0  <-> FIFO2x AIB2.0 Gen1
////////////////////////////////////////////////////////////////
  task ms1_aib1togen1_reg2fifo_xmit ();
        static int pkts_gen = 0;
        static int mrk_gen = 0;
        integer j;
        bit [320*24-1:0] din = 0;
        bit [40*24-1:0]  din_40b_lo = 0;
        bit [40*24-1:0]  din_40b_hi = 0;
        bit [320*24-1:0] exp_din = 0;

        while (mrk_gen < 8) begin
          @(posedge intf_m1.m_ns_fwd_clk);
              intf_m1.gen1_data_in = {24{40'h0}};
          @(posedge intf_s1.m_ns_fwd_clk);
              intf_m1.gen1_data_in = {24{1'b1, 39'h0}};
          mrk_gen++;
        end
        while (pkts_gen < run_for_n_pkts_ms1) begin
            din = tx_data_gen(sl1_rx_fifo_mode, 1'b0, 1'b1);
            for (j=0; j<24; j++) begin
               din_40b_hi[(j*40) +: 40] = din[(j*320+40) +: 40];
               din_40b_lo[(j*40) +: 40] = din[(j*320) +: 40];
            end
            $display ("[%t] sl1 Generating data[%d] = %x \n", $time, pkts_gen, din_40b_lo);
            $display ("[%t] sl1 Generating data[%d] = %x \n", $time, pkts_gen, din_40b_hi);
            @(posedge intf_m1.m_ns_fwd_clk);
            intf_m1.gen1_data_in =  din_40b_lo;
            @(posedge intf_m1.m_ns_fwd_clk);
            intf_m1.gen1_data_in =  din_40b_hi;
            sl1_rcv_320b_q.push_back(din);
            pkts_gen++;
        end
  endtask

////////////////////////////////////////////////////////////////
//  Gen1 FIFO2x Slave to AIB1.0 master */
//  FIFO2x AIB2.0 Gen1 <-> REG Mode AIB1.0
////////////////////////////////////////////////////////////////
  task sl1_gen1toaib1_fifo2reg_xmit ();
        static int pkts_gen = 0;
        static int mrk_gen = 0;
        integer j;
        bit [320*24-1:0] din = 0;
        bit [40*24-1:0]  din_40b_hi = 0;
        bit [40*24-1:0]  din_40b_lo = 0;
        bit [320*24-1:0] exp_din = 0;

        while (pkts_gen < run_for_n_pkts_sl1) begin
            din = tx_data_gen(2'b01, 1'b1, 1'b1);
            for (j=0; j<24; j++) begin
               din_40b_hi[(j*40) +: 40] = din[(j*320+40) +: 40];
               din_40b_lo[(j*40) +: 40] = din[(j*320) +: 40];
            end
            $display ("[%t] sl1 Generating data[%d] = %x \n", $time, pkts_gen, din);
            @(posedge intf_s1.m_wr_clk);
            intf_s1.data_in_f =  din;
            ms1_rcv_40b_q.push_back(din_40b_lo);
            ms1_rcv_40b_q.push_back(din_40b_hi);
            pkts_gen++;
        end
  endtask


////////////////////////////////////////////
/* Use default mark position here bit 77 */
////////////////////////////////////////////
  function [320*24-1:0] usrmod_mrkgen(input [1:0] xmit_fifo_mode, input [1:0] rcv_fifo_mode, input cycle_num, input gen1_mode);
    integer j;
    begin
      for (j=0; j<24; j++) begin
         case (rcv_fifo_mode)
           2'b01: begin                    //rcv is 2xFIFO
                    if (xmit_fifo_mode == 2'b10) begin  //2xFIFO -> 4xFIFO
                       if (cycle_num == 1'b0)    //First cycle
                           usrmod_mrkgen[(j*320) +: 320] = {162'h0, 1'b1, 157'h0};  
                       else if (gen1_mode == 1'b1)
                           usrmod_mrkgen[(j*320) +: 320] = {240'h0, 1'b1, 79'h0};
                       else
                           usrmod_mrkgen[(j*320) +: 320] = 320'h0;
                    end
                  end
           2'b10: begin
                    if (xmit_fifo_mode == 2'b01) begin  //4xFIFO -> 2xFIFO
                        usrmod_mrkgen[(j*320) +: 320] = {2'h0, 1'b1, 77'h0, 80'h0, 2'h0, 1'b1, 77'h0, 80'h0};
                    end
                  end
           default: usrmod_mrkgen[(j*320) +: 320] = 320'h0; 
         endcase
       end
      end
    endfunction

    function [320*24-1:0] usrmod_datgen(input [320*24-1:0] din, input [1:0] xmit_fifo_mode, input [1:0] rcv_fifo_mode, input cycle_num);
    integer j;
    begin
      for (j=0; j<24; j++) begin
         case (rcv_fifo_mode)
           2'b01: begin                    //rcv is 2xFIFO
                    if (xmit_fifo_mode == 2'b10) begin  //2xFIFO -> 4xFIFO
                       if (cycle_num == 1'b0)    //First cycle
                           usrmod_datgen[(j*320) +: 320] = {160'h0, din[(j*320+160) +: 160]};
                       else
                           usrmod_datgen[(j*320) +: 320] = {160'h0, din[(j*320) +: 160]};
                    end
                  end
           2'b10: usrmod_datgen[(j*320) +: 320] = 320'h0; 
           default: usrmod_datgen[(j*320) +: 320] = 320'h0;
         endcase
       end
     end
    endfunction
 
//////////////////////////////////////////////////////////////////////////
/* generate traffic based on the targeted receiver side */
// Included transfer mode:
// AIB2      <-> AIB2 symmetric (Reg, FIFO1x, FIFO2x, FIFO4x)
// AIB2      <-> AIB2 asymmetric (FIFO2x <-> FIFO4x)
// AIB2 Gen1 <-> AIB1 
// The generated traffic will push into queue for receiver side comparason
//////////////////////////////////////////////////////////
  function [320*24-1:0] tx_data_gen(input [1:0] rcv_fifo_mode, input aib2_die, input gen1_mode);
     bit [320*24-1:0] data= 0;
     integer i,j;
     begin
      for (i=0; i<24; i++) begin
              data[(i*320) +: 320] = {$random,$random,$random,$random, $random,
                                      $random,$random,$random,$random, $random};
       end

       for (j=0; j<24; j++) begin
         if (aib2_die == 1'b1) begin
           if (gen1_mode == 1'b1) begin
             case (rcv_fifo_mode)
               2'b00, 2'b11: tx_data_gen[(j*320) +: 320] = data[(j*320) +: 320] & {280'h0, {40{1'b1}}}; 
               2'b01:        tx_data_gen[(j*320) +: 320] = {240'h0, 1'b1, data[(j*320+40) +: 39], 1'b0, data[(j*320) +: 39]}; 
               default:      tx_data_gen[(j*320) +: 320] = 320'h0;
             endcase
           end else begin
             case (rcv_fifo_mode)
               2'b00, 2'b11: tx_data_gen[(j*320) +: 320] = data[(j*320) +: 320] & {240'h0, {80{1'b1}}};
               2'b01:        tx_data_gen[(j*320) +: 320] = data[(j*320) +: 320] & {160'h0, {160{1'b1}}}; 
               2'b10:        tx_data_gen[(j*320) +: 320] = data[(j*320) +: 320]; 
             endcase 
           end
         end else begin
           case (rcv_fifo_mode)
             2'b00, 2'b11: tx_data_gen[(j*320) +: 320] = data[(j*320) +: 320] & {280'h0, {40{1'b1}}};
             2'b01:        tx_data_gen[(j*320) +: 320] = {240'h0, 1'b1, data[(j*320+40) +: 39], 1'b0, data[(j*320) +: 39]};
             default:      tx_data_gen[(j*320) +: 320] = 320'h0;
           endcase
        end
     end
   end
  endfunction
/******************************************************************/
/******* markbit = 5'b00001 is for Gen1 mode only *****************/
/******************************************************************/
  function [320*24-1:0] compare_eq_320b (input [320*24-1:0] din, input [320*24-1:0] exp_d, input [1:0] fifo_mode, input [4:0] markbit);
     integer i;
     bit [320*24-1:0] rcv_d_mod, exp_d_mod;
     begin
        case (fifo_mode)
          2'b00: begin 
                   for (i=0; i<24; i++) begin
                     rcv_d_mod [(i*320) +: 320] = {240'h0, din[(i*320) +: 80]}; 
                   end
                 end
          2'b01: begin
                   for (i=0; i<24; i++)
                   case (markbit) 
                    5'b10000:  begin 
                                  rcv_d_mod[(i*320) +: 320] ={din[((i+1)*320-1) -: 160], 
                                                         1'b1,           din[158+i*320], din[157+i*320], din[156+i*320], din[(i*320+155) -: 76],    
                                                         1'b0,           din[78+i*320],  din[77+i*320],  din[76+i*320],  din[(i*320+75)  -: 76]};
                                  exp_d_mod[(i*320) +: 320] = {160'h0, exp_d[i*320  +: 160]};
                               end
                    5'b01000:  begin 
                                  rcv_d_mod[(i*320) +: 320] ={din[((i+1)*320-1) -: 160], 
                                                         din[159+i*320], 1'b1,           din[157+i*320], din[156+i*320], din[(i*320+155) -: 76],                       
                                                         din[79+i*320],  1'b0,           din[77+i*320],  din[76+i*320],  din[(i*320+75)  -: 76]};
                                  exp_d_mod[(i*320) +: 320] = {160'h0, exp_d[i*320  +: 160]};
                               end
                    5'b00100:  begin 
                                  rcv_d_mod[(i*320) +: 320] ={din[((i+1)*320-1) -: 160], 
                                                         din[159+i*320], din[158+i*320], 1'b1,           din[156+i*320], din[(i*320+155) -: 76],                       
                                                         din[79+i*320],  din[78+i*320],  1'b0,           din[76+i*320],  din[(i*320+75)  -: 76]};
                                  exp_d_mod[(i*320) +: 320] = {160'h0, exp_d[i*320  +: 160]};
                               end
                    5'b00010:  begin 
                                  rcv_d_mod[(i*320) +: 320] ={160'h0, 
                                                         din[159+i*320], din[158+i*320], din[157+i*320], 1'b1,           din[(i*320+155) -: 76],                       
                                                         din[79+i*320],  din[78+i*320],  din[77+i*320],  1'b0,           din[(i*320+75)  -: 76]};
                                  exp_d_mod[(i*320) +: 320] = {160'h0, exp_d[i*320  +: 160]};
                               end
                    5'b00001:  begin 
                                  rcv_d_mod[(i*320) +: 320] = {240'h0, 1'b1, din[(i*320+40)  +: 39], 1'b0, din[(i*320)  +: 39]};
                                  exp_d_mod[(i*320) +: 320] = {240'h0, exp_d[i*320  +: 80]};
                               end
                   endcase
                 end
          2'b10: begin
                   for (i=0; i<24; i++)
                   case (markbit) 
                    5'b10000:  rcv_d_mod[(i*320) +: 320] ={1'b1,           din[318+i*320], din[317+i*320], din[316+i*320], din[(i*320+315) -: 76], 
                                                           1'b0,           din[238+i*320], din[237+i*320], din[236+i*320], din[(i*320+235) -: 76],
                                                           1'b0,           din[158+i*320], din[157+i*320], din[156+i*320], din[(i*320+155) -: 76],                       
                                                           1'b0,           din[78+i*320],  din[77+i*320],  din[76+i*320],  din[(i*320+75)  -: 76]};
                    5'b01000:  rcv_d_mod[(i*320) +: 320] ={din[319+i*320], 1'b1,           din[317+i*320], din[316+i*320], din[(i*320+315) -: 76],        
                                                           din[239+i*320], 1'b0,           din[237+i*320], din[236+i*320], din[(i*320+235) -: 76],
                                                           din[159+i*320], 1'b0,           din[157+i*320], din[156+i*320], din[(i*320+155) -: 76], 
                                                           din[79+i*320],  1'b0,           din[77+i*320],  din[76+i*320],  din[(i*320+75)  -: 76]};
                    5'b00100:  rcv_d_mod[(i*320) +: 320] ={din[319+i*320], din[318+i*320], 1'b1,           din[316+i*320], din[(i*320+315) -: 76],        
                                                           din[239+i*320], din[238+i*320], 1'b0,           din[236+i*320], din[(i*320+235) -: 76],
                                                           din[159+i*320], din[158+i*320], 1'b0,           din[156+i*320], din[(i*320+155) -: 76], 
                                                           din[79+i*320],  din[78+i*320],  1'b0,           din[76+i*320],  din[(i*320+75)  -: 76]};
                    5'b00010:  rcv_d_mod[(i*320) +: 320] ={din[319+i*320], din[318+i*320], din[317+i*320], 1'b1,           din[(i*320+315) -: 76],        
                                                           din[239+i*320], din[238+i*320], din[237+i*320], 1'b0,           din[(i*320+235) -: 76],
                                                           din[159+i*320], din[158+i*320], din[157+i*320], 1'b0,           din[(i*320+155) -: 76], 
                                                           din[79+i*320],  din[78+i*320],  din[77+i*320],  1'b0,           din[(i*320+75)  -: 76]};
                  endcase
                  exp_d_mod = exp_d;
                 end
          2'b11: rcv_d_mod={24{320'h0}};
        endcase

        compare_eq_320b = rcv_d_mod ^ exp_d_mod;
     end

  endfunction

////////////////////////////////////////////////////////
/* AIB2.0 MS <-> AIB2.0 SL  in register mode 80b <-80b*/
///////////////////////////////////////////////////

  task ms1_aib2_regmod_rcv ();  //reg mode. Received data is transmitting from slave 
        bit [(80*24-1):0] data_exp = 0;
        static int pkts_rcvd = 0;
        begin
            while(pkts_rcvd < (run_for_n_pkts_sl1)) begin
                @ (posedge intf_m1.m_fs_fwd_clk);
                if (intf_m1.data_out[79:0] !== 0) begin
                    $display ("[%t] ms1 Receiving data[%d] = %x \n", $time, pkts_rcvd, intf_m1.data_out);
                    data_exp = ms1_rcv_80b_q.pop_front();
                    pkts_rcvd++;
                    if (intf_m1.data_out !== data_exp) begin
                        err_count++;
                        $display ("[%t] ms1 DATA COMPARE ERROR: received = %x | expected = %x\n", $time, intf_m1.data_out, data_exp);
                    end
                end
            end
            if (ms1_rcv_80b_q.size() !== 0) //check if all the data are received
              $display("[%t]ERROR: sl1 Tramit Queue Not Empty, still %d data left\n", $time, ms1_rcv_80b_q.size());

        end
  endtask 

  task sl1_aib2_regmod_rcv ();     //Received data is transmitting from master
        static bit [(80*24-1): 0] data_exp = 0;
        static int pkts_rcvd = 0;
        begin
            while(pkts_rcvd < (run_for_n_pkts_ms1)) begin
                @ (negedge intf_s1.m_fs_fwd_clk[0]);
                if (intf_s1.data_out[79:0] !== 0) begin
                    $display ("[%t] sl1  Receiving data[%d] = %x \n", $time, pkts_rcvd, intf_s1.data_out);
                    data_exp = sl1_rcv_80b_q.pop_front();
                    pkts_rcvd++;
                    if (intf_s1.data_out!== data_exp) begin
                        err_count++;
                        $display ("[%t]DATA COMPARE ERROR: received = %x | expected = %x\n", $time, intf_s1.data_out, data_exp);
                    end
                end
            end
            if (sl1_rcv_80b_q.size() !== 0) //check if all the data are received
              $display("[%t]ERROR: sl1 Tramit Queue Not Empty, still %d data left\n", $time, sl1_rcv_80b_q.size());

        end
  endtask

  task ms1_aib1_regmod_rcv ();  //reg mode. Received data is transmitting from slave
        bit [(40*24-1):0] data_exp = 0;
        static int pkts_rcvd = 0;
        begin
            while(pkts_rcvd < (2*run_for_n_pkts_sl1)) begin
                @ (negedge intf_m1.m_fs_fwd_clk);
                if (intf_m1.gen1_data_out[38:0] !== 0) begin
                    $display ("[%t] ms1 Receiving data[%d] = %x \n", $time, pkts_rcvd, intf_m1.gen1_data_out);
                    data_exp = ms1_rcv_40b_q.pop_front();
                    pkts_rcvd++;
                    if (intf_m1.gen1_data_out !== data_exp) begin
                        err_count++;
                        $display ("[%t] ms1 DATA COMPARE ERROR: received = %x | expected = %x\n", $time, intf_m1.gen1_data_out, data_exp);
                    end
                end
            end
            if (ms1_rcv_40b_q.size() !== 0) //check if all the data are received
              $display("[%t]ERROR: sl1 Tramit Queue Not Empty, still %d data left\n", $time, ms1_rcv_40b_q.size());

        end
  endtask

////////////////////////////////////////////////////////////////
/* AIB2.0 Receiver data master/slave side with FIFO mode Symmetric */
//           FIFO1x <-> FIFO1x
//           FIFO2x <-> FIFO2x
//           FIFO4x <-> FIFO4x
////////////////////////////////////////////////////////////////


  task ms1_aib2_fifomod_rcv ();   
        bit [320*24-1:0] data_exp = 0;
        bit [320*24-1:0] data_rcvd = 0;
        bit [320*24-1:0] eq_chk = 0;
        static int pkts_rcvd = 0;
        begin
            while(pkts_rcvd < (run_for_n_pkts_ms1)) begin
                @ (negedge intf_m1.m_rd_clk);
                data_rcvd = intf_m1.data_out_f;
                if (din_rcv_vld(data_rcvd[319:0], ms1_rx_fifo_mode, ms1_gen1)) begin
                    $display ("[%t] ms1 Receiving data[%d] = %x \n", $time, pkts_rcvd, data_rcvd);
                    data_exp = ms1_rcv_320b_q.pop_front();
                    pkts_rcvd++;
                    eq_chk = compare_eq_320b(data_rcvd, data_exp, ms1_rx_fifo_mode, sl1_tx_markbit);
                    if ((|eq_chk) !== 1'b1) begin
                        err_count++;
                        $display ("[%t] ms1 DATA COMPARE ERROR: received = %x | expected = %x\n", $time, intf_m1.data_out_f, data_exp);
                        $display ("[%t] ms1 DATA COMPARE ERROR: checksum  =  %x\n", $time, eq_chk);
                    end
                end
            end
            if (ms1_rcv_320b_q.size() != 0) //check if all the data are received
              $display("[%t]ERROR: sl1 Tramit Queue Not Empty, still %d data left\n", $time, ms1_rcv_320b_q.size());

        end
  endtask

  task sl1_aib2_fifomod_rcv ();
        bit [320*24-1:0] data_exp = 0;
        bit [320*24-1:0] data_rcvd = 0;
        bit [320*24-1:0] eq_chk = 0;
        static int pkts_rcvd = 0;
        begin
            while(pkts_rcvd < (run_for_n_pkts_sl1)) begin
                @ (posedge intf_s1.m_rd_clk);
                data_rcvd = intf_s1.data_out_f;
                if (din_rcv_vld(data_rcvd[319:0], sl1_rx_fifo_mode, sl1_gen1)) begin
                    $display ("[%t] sl1 Receiving data[%d] = %x \n", $time, pkts_rcvd, data_rcvd);
                    data_exp = sl1_rcv_320b_q.pop_front();
                    pkts_rcvd++;
                    eq_chk = compare_eq_320b(data_rcvd, data_exp, sl1_rx_fifo_mode, ms1_tx_markbit);
                    if (|eq_chk !== 1'b1) begin
                        err_count++;
                        $display ("[%t] sl1 DATA COMPARE ERROR: received = %x | expected = %x\n", $time, intf_s1.data_out_f, data_exp);
                        $display ("[%t] sl1 DATA COMPARE ERROR: checksum  =  %x\n", $time, eq_chk);
                    end
                end
            end
            if (sl1_rcv_320b_q.size() != 0) //check if all the data are received
              $display("[%t]ERROR: sl1 Tramit Queue Not Empty, still %d data left\n", $time, sl1_rcv_320b_q.size());
        end
  endtask

////////////////////////////////////////////////////////////////
/* AIB2.0 Gen1 Receiver data master/slave side with FIFO mode Symmetric */
//           FIFO2x <-> FIFO2x
////////////////////////////////////////////////////////////////

  task ms1_gen1_fifomod_rcv ();
        bit [320*24-1:0] data_exp = 0;
        bit [320*24-1:0] data_rcvd = 0;
        bit [320*24-1:0] eq_chk = 0;
        static int pkts_rcvd = 0;
        begin
            while(pkts_rcvd < (run_for_n_pkts_ms1)) begin
                @ (negedge intf_m1.m_rd_clk);
                data_rcvd = intf_m1.data_out_f & {24{240'h0, {80{1'b1}}}};
                if (data_rcvd[38:0] != 39'h0) begin
                    $display ("[%t] ms1 Receiving data[%d] = %x \n", $time, pkts_rcvd, data_rcvd);
                    data_exp = ms1_rcv_320b_q.pop_front();
                    pkts_rcvd++;
                    eq_chk = data_rcvd ^ data_exp;
                    if ((|eq_chk) == 1'b1) begin
                        err_count++;
                        $display ("[%t] ms1 DATA COMPARE ERROR: received = %x | expected = %x\n", $time, data_rcvd, data_exp);
                        $display ("[%t] ms1 DATA COMPARE ERROR: checksum  =  %x\n", $time, eq_chk);
                    end
                end
            end
            if (ms1_rcv_320b_q.size() != 0) //check if all the data are received
              $display("[%t]ERROR: sl1 Tramit Queue Not Empty, still %d data left\n", $time, ms1_rcv_320b_q.size());

        end
  endtask

  task sl1_gen1_fifomod_rcv ();
        bit [320*24-1:0] data_exp = 0;
        bit [320*24-1:0] data_rcvd = 0;
        bit [320*24-1:0] eq_chk = 0;
        static int pkts_rcvd = 0;
        begin
            while(pkts_rcvd < (run_for_n_pkts_ms1/2)) begin
                @ (negedge intf_s1.m_rd_clk);
                data_rcvd = intf_s1.data_out_f & {24{240'h0, {80{1'b1}}}};
                if (data_rcvd[38:0] != 39'h0) begin
                    $display ("[%t] sl1 Receiving data[%d] = %x \n", $time, pkts_rcvd, data_rcvd);
                    data_exp = sl1_rcv_320b_q.pop_front();
                    pkts_rcvd++;
                    eq_chk = data_rcvd ^ data_exp;
                    if ((|eq_chk) == 1'b1) begin
                        err_count++;
                        $display ("[%t] sl1 DATA COMPARE ERROR: received = %x | expected = %x\n", $time, data_rcvd, data_exp);
                        $display ("[%t] sl1 DATA COMPARE ERROR: checksum  =  %x\n", $time, eq_chk);
                    end
                end
            end
            if (sl1_rcv_320b_q.size() != 0) //check if all the data are received
              $display("[%t]ERROR: sl1 Tramit Queue Not Empty, still %d data left\n", $time, sl1_rcv_320b_q.size());

        end
  endtask

  task sl1_aib1_fifomod_rcv ();
        bit [80*24-1:0] data_exp = 0;
        bit [80*24-1:0] data_rcvd = 0;
        bit [80*24-1:0] eq_chk = 0;
        static int pkts_rcvd = 0;
        begin
            while(pkts_rcvd < (run_for_n_pkts_sl1)) begin
                @ (posedge intf_s1.m_rd_clk);
                data_rcvd = intf_s1.gen1_data_out_f;
                if (data_rcvd[38:0] != 39'h0) begin
                    $display ("[%t] sl1 Receiving data[%d] = %x \n", $time, pkts_rcvd, data_rcvd);
                    data_exp = sl1_rcv_80b_q.pop_front();
                    pkts_rcvd++;
                    eq_chk = compare_eq_320b(data_rcvd, data_exp, sl1_rx_fifo_mode, sl1_tx_markbit);
                    eq_chk = data_rcvd ^ data_exp; 
                    if ((|eq_chk) == 1'b1) begin
                        err_count++;
                        $display ("[%t] sl1 DATA COMPARE ERROR: received = %x | expected = %x\n", $time, data_rcvd, data_exp);
                        $display ("[%t] sl1 DATA COMPARE ERROR: checksum  =  %x\n", $time, eq_chk);

                    end
                end
            end
            if (sl1_rcv_320b_q.size() != 0) //check if all the data are received
              $display("[%t]ERROR: sl1 Tramit Queue Not Empty, still %d data left\n", $time, sl1_rcv_320b_q.size());

        end
  endtask


  function [319:0] din_rcv_vld(input[319:0] data, input [1:0] fifo_mode, input gen1_mode);
     begin
        case (fifo_mode)
          2'b00:  if (gen1_mode == 1'b1)
	             din_rcv_vld = (data[38:0]  !== 0);
		  else 
	             din_rcv_vld = (data[79:0]  !== 0);
          2'b01:  if (gen1_mode == 1'b1)
                     din_rcv_vld = (data[38:0] !== 0);
                  else
                     din_rcv_vld = (data[155:0] !== 0); //For AIB Gen2, top 4 bit can be programmable marker bit.

          2'b10:  din_rcv_vld = (data[315:0] !== 0); //For AIB Gen2, top 4 bit can be programmable marker bit.
          2'b11:  din_rcv_vld = (data[79:0]  !== 0); //
        endcase
     end
  endfunction


  task link_up (); 
       begin
         wait (intf_s1.ms_tx_transfer_en == {TOTAL_CHNL_NUM{1'b1}});
         wait (intf_s1.sl_tx_transfer_en == {TOTAL_CHNL_NUM{1'b1}});
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
