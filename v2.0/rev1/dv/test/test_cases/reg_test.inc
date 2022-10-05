parameter WR_CYCLE   = 500;
parameter RD_CYCLE   = 500;
parameter FWD_CYCLE  = 500;

always #(WR_CYCLE/2)   ms_wr_clk   = ~ms_wr_clk;
always #(RD_CYCLE/2)   ms_rd_clk   = ~ms_rd_clk;
always #(FWD_CYCLE/2)  ms_fwd_clk  = ~ms_fwd_clk;

always #(WR_CYCLE/2)   sl_wr_clk   = ~sl_wr_clk;
always #(RD_CYCLE/2)   sl_rd_clk   = ~sl_rd_clk;
always #(FWD_CYCLE/2)  sl_fwd_clk  = ~sl_fwd_clk;


integer i_m1, i_s1;

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
      $display("%0t: set to reg mode for ms -> sl and sl -> ms", $time);
      $display("\n//                                                                       ///");
      $display("%0t: No dbi enabled", $time);
      $display("////////////////////////////////////////////////////////////////////////////\n");

      fork
 
        for (i_m1=0; i_m1<24; i_m1++) begin
            avmm_if_m1.cfg_write({i_m1,11'h208}, 4'hf, 32'h0600_0000);
            avmm_if_m1.cfg_write({i_m1,11'h210}, 4'hf, 32'h0000_0006);      
            avmm_if_m1.cfg_write({i_m1,11'h218}, 4'hf, 32'h6060_0000);
        `ifdef MS_AIB_BCA 
         //1. During configuration phase, set vcalcode_ovrd bit of calvref register. BCA only
            avmm_if_m1.cfg_write({i_m1,11'h33C}, 4'hf, 32'h4000_0000);
        `endif
        end
        for (i_s1=0; i_s1<24; i_s1++) begin
            avmm_if_s1.cfg_write({i_s1,11'h208}, 4'hf, 32'h0600_0000);
            avmm_if_s1.cfg_write({i_s1,11'h210}, 4'hf, 32'h0000_0006);
            avmm_if_s1.cfg_write({i_s1,11'h218}, 4'hf, 32'h6060_0000);
        `ifdef SL_AIB_BCA 
         //1. During configuration phase, set vcalcode_ovrd bit of calvref register. BCA only
            avmm_if_s1.cfg_write({i_s1,11'h33C}, 4'hf, 32'h4000_0000);
        `endif
        end
      join

      run_for_n_pkts_ms1 = 4;
      run_for_n_pkts_sl1 = 4;

      $display("\n////////////////////////////////////////////////////////////////////////////");
      $display("%0t: Performing duts_wakeup", $time);
      $display("////////////////////////////////////////////////////////////////////////////\n");

      duts_wakeup ();
      status = "Waiting for link up";

      $display("\n////////////////////////////////////////////////////////////////////////////");
      $display("%0t: Waiting for Phase Adjust Work around if use BCA, Skip otherwise", $time);
      $display("////////////////////////////////////////////////////////////////////////////\n");
      
      fork
       `ifdef MS_AIB_BCA 
          ms_phase_adjust_wrkarnd ();
       `endif
       `ifdef SL_AIB_BCA
          sl_phase_adjust_wrkarnd ();
       `endif
      join

      $display("\n////////////////////////////////////////////////////////////////////////////");
      $display("%0t: Waiting for link up", $time);
      $display("////////////////////////////////////////////////////////////////////////////\n");

      link_up ();
      status = "Starting data transmission";

      $display("\n////////////////////////////////////////////////////////////////////////////");
      $display("%0t: Starting data transmission", $time);
      $display("////////////////////////////////////////////////////////////////////////////\n");
      
      fork
         ms1_aib2_reg2reg_xmit ();
         sl1_aib2_reg2reg_xmit ();
         ms1_aib2_regmod_rcv ();
         sl1_aib2_regmod_rcv();
      join

      status = "Finishing data transmission";
      Finish ();
    end
  end
