integer i_m1, i_s1;
parameter WR_CYCLE   = 2000;
parameter RD_CYCLE   = 2000;
parameter FWD_CYCLE  = 1000;


always #(WR_CYCLE/2)   wr_clk   = ~wr_clk;
always #(RD_CYCLE/2)   rd_clk   = ~rd_clk;
always #(FWD_CYCLE/2)  fwd_clk  = ~fwd_clk;

  initial begin
    begin
      status = "Reset DUT";
      $display("\n////////////////////////////////////////////////////////////////////////////");
      $display("%0t: Get into Main initial", $time);
      $display("////////////////////////////////////////////////////////////////////////////\n");
      reset_duts ();
      $display("\n////////////////////////////////////////////////////////////////////////////");
      $display("%0t: Finish reset_duts", $time);
      $display("////////////////////////////////////////////////////////////////////////////\n");

      $display("\n////////////////////////////////////////////////////////////////////////////");
      $display("\n////////////////////////////////////////////////////////////////////////////");
      $display("\n//                                                                       ///");
      $display("%0t: set to 2xFIFO mode for ms -> sl and sl -> ms 24 channel testing", $time);
      $display("%0t: Master is 2.0 AIB model in Gen1 mode", $time);
      $display("%0t: Slave is 1.0 FPGA", $time);
      $display("\n//                                                                       ///");
      $display("%0t: No dbi enabled", $time);
      $display("////////////////////////////////////////////////////////////////////////////\n");

 
      for (i_m1=0; i_m1<24; i_m1++) begin
          avmm_if_m1.cfg_write({i_m1,11'h208}, 4'hf, 32'h0600_0000);
          avmm_if_m1.cfg_write({i_m1,11'h210}, 4'hf, 32'h0000_000b);      
          avmm_if_m1.cfg_write({i_m1,11'h218}, 4'hf, 32'h60a1_0000);
          avmm_if_m1.cfg_write({i_m1,11'h21c}, 4'hf, 32'h0000_0000);
          avmm_if_m1.cfg_write({i_m1,11'h31c}, 4'hf, 32'h0000_0000);
          avmm_if_m1.cfg_write({i_m1,11'h320}, 4'hf, 32'h0000_0000);
          avmm_if_m1.cfg_write({i_m1,11'h324}, 4'hf, 32'h0000_0000);
          avmm_if_m1.cfg_write({i_m1,11'h328}, 4'hf, 32'h0000_0000);

      end

      ms1_tx_fifo_mode = 2'b01;
      sl1_tx_fifo_mode = 2'b01;
      ms1_rx_fifo_mode = 2'b01;
      sl1_rx_fifo_mode = 2'b01;
      ms1_tx_markbit   = 5'b00001;
      sl1_tx_markbit   = 5'b00001;
      ms1_gen1         = 1'b0;
      sl1_gen1         = 1'b1;

      run_for_n_pkts_ms1 = 40;
      run_for_n_pkts_sl1 = 40;

      $display("\n////////////////////////////////////////////////////////////////////////////");
      $display("%0t: Performing duts_wakeup", $time);
      $display("////////////////////////////////////////////////////////////////////////////\n");

      duts_wakeup ();
      status = "Waiting for link up";

      $display("\n////////////////////////////////////////////////////////////////////////////");
      $display("%0t: Waiting for link up", $time);
      $display("////////////////////////////////////////////////////////////////////////////\n");

      link_up ();
      status = "Starting data transmission";

      $display("\n////////////////////////////////////////////////////////////////////////////");
      $display("%0t: Starting data transmission", $time);
      $display("////////////////////////////////////////////////////////////////////////////\n");
      
//    init_wa_toggle ();
      fork
         ms1_gen1toaib1_f2f_xmit ();
         sl1_aib1togen1_f2f_xmit ();
         ms1_gen1_fifomod_rcv ();
         sl1_aib1_fifomod_rcv ();
      join

      status = "Finishing data transmission";
      Finish ();
    end
  end
