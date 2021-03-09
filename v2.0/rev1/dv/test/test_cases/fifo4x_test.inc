integer i_m1, i_s1;
parameter WR_CYCLE   = 2000;
parameter RD_CYCLE   = 2000;


always #(WR_CYCLE/2)   wr_clk   = ~wr_clk;

always #(RD_CYCLE/2)   rd_clk   = ~rd_clk;


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
            avmm_if_m1.cfg_write({i_m1,11'h208}, 4'hf, 32'h0600_0000);
            avmm_if_m1.cfg_write({i_m1,11'h210}, 4'hf, 32'h0000_0045);      
            avmm_if_m1.cfg_write({i_m1,11'h218}, 4'hf, 32'h60c8_0000);
            avmm_if_m1.cfg_write({i_m1,11'h21c}, 4'hf, 32'h0000_0000);

        end
        for (i_s1=0; i_s1<24; i_s1++) begin
            avmm_if_s1.cfg_write({i_s1,11'h208}, 4'hf, 32'h0600_0000);
            avmm_if_s1.cfg_write({i_s1,11'h210}, 4'hf, 32'h0000_0045);
            avmm_if_s1.cfg_write({i_s1,11'h218}, 4'hf, 32'h60c8_0000);
            avmm_if_s1.cfg_write({i_s1,11'h21c}, 4'hf, 32'h0000_0000);
        end
      join

      ms1_tx_fifo_mode = 2'b10;
      sl1_tx_fifo_mode = 2'b10;
      ms1_rx_fifo_mode = 2'b10;
      sl1_rx_fifo_mode = 2'b10;

      run_for_n_pkts_ms1 = 4;
      run_for_n_pkts_sl1 = 4;

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
      
      init_wa_toggle ();
      fork
         ms1_data_xmit_fifo ();
         ms1_data_rcv_fifo ();
         sl1_data_xmit_fifo ();
         sl1_data_rcv_fifo ();
      join

      status = "Finishing data transmission";
      Finish ();
    end
  end
