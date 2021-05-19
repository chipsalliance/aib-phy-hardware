integer i_m1, i_s1;
parameter WR_CYCLE   = 2000;
parameter RD_CYCLE   = 2000;
parameter FWD_CYCLE  = 500;

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
      $display("%0t: set to 4xFIFO mode for ms -> sl and sl -> ms, 24 channel testing", $time);
      $display("\n//                                                                       ///");
      $display("%0t: No dbi enabled", $time);
      $display("////////////////////////////////////////////////////////////////////////////\n");

      fork
 
        for (i_m1=0; i_m1<24; i_m1++) begin
            avmm_if_m1.cfg_write({i_m1,11'h208}, 2'h3, 16'h0000);
            avmm_if_m1.cfg_write({i_m1,11'h20a}, 2'h3, 16'h0600);
            avmm_if_m1.cfg_write({i_m1,11'h210}, 2'h3, 16'h0025);
            avmm_if_m1.cfg_write({i_m1,11'h212}, 2'h3, 16'h0000);
            avmm_if_m1.cfg_write({i_m1,11'h218}, 2'h3, 16'h0000);
            avmm_if_m1.cfg_write({i_m1,11'h21a}, 2'h3, 16'h60c4);
            avmm_if_m1.cfg_write({i_m1,11'h21c}, 2'h3, 16'h0000);
            avmm_if_m1.cfg_write({i_m1,11'h21e}, 2'h3, 16'h0000);
            avmm_if_m1.cfg_write({i_m1,11'h31c}, 2'h3, 16'h0000);
            avmm_if_m1.cfg_write({i_m1,11'h31e}, 2'h3, 16'h0000);
            avmm_if_m1.cfg_write({i_m1,11'h320}, 2'h3, 16'h0000);
            avmm_if_m1.cfg_write({i_m1,11'h322}, 2'h3, 16'h0000);
            avmm_if_m1.cfg_write({i_m1,11'h324}, 2'h3, 16'h0000);
            avmm_if_m1.cfg_write({i_m1,11'h326}, 2'h3, 16'h0000);
            avmm_if_m1.cfg_write({i_m1,11'h328}, 2'h3, 16'h0000);
            avmm_if_m1.cfg_write({i_m1,11'h32a}, 2'h3, 16'h0000);
        end
        for (i_s1=0; i_s1<24; i_s1++) begin
            avmm_if_s1.cfg_write({i_s1,11'h208}, 2'h3, 16'h0000);
            avmm_if_s1.cfg_write({i_s1,11'h20a}, 2'h3, 16'h0600);
            avmm_if_s1.cfg_write({i_s1,11'h210}, 2'h3, 16'h0025);
            avmm_if_s1.cfg_write({i_s1,11'h212}, 2'h3, 16'h0000);
            avmm_if_s1.cfg_write({i_s1,11'h218}, 2'h3, 16'h0000);
            avmm_if_s1.cfg_write({i_s1,11'h21a}, 2'h3, 16'h60c4);
            avmm_if_s1.cfg_write({i_s1,11'h21c}, 2'h3, 16'h0000);
            avmm_if_s1.cfg_write({i_s1,11'h21e}, 2'h3, 16'h0000);
            avmm_if_s1.cfg_write({i_s1,11'h31c}, 2'h3, 16'h0000);
            avmm_if_s1.cfg_write({i_s1,11'h31e}, 2'h3, 16'h0000);
            avmm_if_s1.cfg_write({i_s1,11'h320}, 2'h3, 16'h0000);
            avmm_if_s1.cfg_write({i_s1,11'h322}, 2'h3, 16'h0000);
            avmm_if_s1.cfg_write({i_s1,11'h324}, 2'h3, 16'h0000);
            avmm_if_s1.cfg_write({i_s1,11'h326}, 2'h3, 16'h0000);
            avmm_if_s1.cfg_write({i_s1,11'h328}, 2'h3, 16'h0000);
            avmm_if_s1.cfg_write({i_s1,11'h32a}, 2'h3, 16'h0000);

        end
      join

      ms1_tx_fifo_mode = 2'b10;
      sl1_tx_fifo_mode = 2'b10;
      ms1_rx_fifo_mode = 2'b10;
      sl1_rx_fifo_mode = 2'b10;
      ms1_tx_markbit   = 5'b00100;
      sl1_tx_markbit   = 5'b00100;
      ms1_gen1 = 1'b0;
      sl1_gen1 = 1'b0;
      ms1_lpbk = 1'b0;
      sl1_lpbk = 1'b0;
      ms1_dbi_en = 1'b0;
      sl1_dbi_en = 1'b0;

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

      fork
         ms1_aib2_f2f_s_xmit ();
         ms1_aib2_fifomod_rcv ();
         sl1_aib2_f2f_s_xmit ();
         sl1_aib2_fifomod_rcv ();
      join

      status = "Finishing data transmission";
      Finish ();
    end
  end
