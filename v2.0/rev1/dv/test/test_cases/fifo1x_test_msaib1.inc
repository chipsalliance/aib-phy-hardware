integer i_m1, i_s1;
parameter WR_CYCLE   = 1000;
parameter RD_CYCLE   = 1000;
parameter FWD_CYCLE  = 1000;

always #(WR_CYCLE/2)   ms_wr_clk   = ~ms_wr_clk;
always #(RD_CYCLE/2)   ms_rd_clk   = ~ms_rd_clk;
always #(FWD_CYCLE/2)  ms_fwd_clk  = ~ms_fwd_clk;

always #(WR_CYCLE/2)   sl_wr_clk   = ~sl_wr_clk;
always #(RD_CYCLE/2)   sl_rd_clk   = ~sl_rd_clk;
always #(FWD_CYCLE/2)  sl_fwd_clk  = ~sl_fwd_clk;


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
      $display("%0t: set to 1xFIFO mode for ms -> sl and sl -> ms 24 channel testing", $time);
      $display("%0t: slave is 2.0 AIB model in Gen1 mode with 1xFIFO 40 bit", $time);
      $display("%0t: master is AIB 1.0 Reg mode 40 bit", $time);
      $display("\n//                                                                       ///");
      $display("%0t: No dbi enabled", $time);
      $display("////////////////////////////////////////////////////////////////////////////\n");

 
      for (i_m1=0; i_m1<24; i_m1++) begin
          avmm_if_m1.cfg_write({i_m1,11'h208}, 4'hf, 32'h0278_0204);
          avmm_if_m1.cfg_write({i_m1,11'h20c}, 4'hf, 32'h0000_0282);
          avmm_if_m1.cfg_write({i_m1,11'h210}, 4'hf, 32'h0287_1f00);
          avmm_if_m1.cfg_write({i_m1,11'h214}, 4'hf, 32'h0000_80c3);
          avmm_if_m1.cfg_write({i_m1,11'h218}, 4'hf, 32'h4700_8004);
          avmm_if_m1.cfg_write({i_m1,11'h21c}, 4'hf, 32'h0000_0024);
          avmm_if_m1.cfg_write({i_m1,11'h220}, 4'hf, 32'he388_c00a);
          avmm_if_m1.cfg_write({i_m1,11'h224}, 4'hf, 32'h3012_7f38);
          avmm_if_m1.cfg_write({i_m1,11'h228}, 4'hf, 32'h0000_7451);
          avmm_if_m1.cfg_write({i_m1,11'h230}, 4'hf, 32'h38f6_007b);
          avmm_if_m1.cfg_write({i_m1,11'h2fc}, 4'hf, 32'h000f_0000);
          avmm_if_m1.cfg_write({i_m1,11'h310}, 4'hf, 32'h000f_0000);
          avmm_if_m1.cfg_write({i_m1,11'h318}, 4'hf, 32'h0010_0f86);
          avmm_if_m1.cfg_write({i_m1,11'h31c}, 4'hf, 32'h0000_0f80);
          avmm_if_m1.cfg_write({i_m1,11'h32c}, 4'hf, 32'h5555_a019);
          avmm_if_m1.cfg_write({i_m1,11'h330}, 4'hf, 32'h0040_0082);
          avmm_if_m1.cfg_write({i_m1,11'h334}, 4'hf, 32'hbf0f_b000);
          avmm_if_m1.cfg_write({i_m1,11'h338}, 4'hf, 32'h0002_a9e1);
          avmm_if_m1.cfg_write({i_m1,11'h33c}, 4'hf, 32'h00ff_fff0);
          avmm_if_m1.cfg_write({i_m1,11'h340}, 4'hf, 32'h7f1c_0000);
          avmm_if_m1.cfg_write({i_m1,11'h344}, 4'hf, 32'h0000_1c00);

      end

      for (i_s1=0; i_s1<24; i_s1++) begin
          avmm_if_s1.cfg_write({i_s1,11'h208}, 4'hf, 32'h0600_0000);
          avmm_if_s1.cfg_write({i_s1,11'h210}, 4'hf, 32'h0000_0000);
          avmm_if_s1.cfg_write({i_s1,11'h218}, 4'hf, 32'h4000_0000);
          avmm_if_s1.cfg_write({i_s1,11'h21c}, 4'hf, 32'h0000_0000);
          avmm_if_s1.cfg_write({i_s1,11'h31c}, 4'hf, 32'h0000_0000);
          avmm_if_s1.cfg_write({i_s1,11'h320}, 4'hf, 32'h0000_0000);
          avmm_if_s1.cfg_write({i_s1,11'h324}, 4'hf, 32'h0000_0000);
          avmm_if_s1.cfg_write({i_s1,11'h328}, 4'hf, 32'h0000_0000);
      end

      ms1_tx_fifo_mode = 2'b11;
      sl1_tx_fifo_mode = 2'b00;
      ms1_rx_fifo_mode = 2'b11;
      sl1_rx_fifo_mode = 2'b00;
      ms1_tx_markbit   = 5'b00000;
      sl1_tx_markbit   = 5'b00000;
      ms1_gen1         = 1'b0;           
      sl1_gen1         = 1'b1;           //AIB2.0 model

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
         ms1_aib1togen1_reg2fifo1x_xmit();
         sl1_gen1toaib1_fifo1x_reg_xmit();
         ms1_aib1_regmod_rcv ();
         sl1_gen1_fifomod_rcv ();
      join

      status = "Finishing data transmission";
      Finish ();
    end
  end
