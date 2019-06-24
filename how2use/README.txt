README.txt
March 25, 2019

==================================================================
This directory contains examples of how to use AIB opensource core.
===================================================================

sim_aib_top: 24 channel loopback simulation. vcs supported 
How to run:
1) cd sim_aib_top
2) make

This example shows:
1) How to configurate 24 channels registers through avmm interface.
2) How to do externally loopback test. See detail connection described below.
3) DLL/DCC was bypassed (static). A minimum static delay is programmed
4) Traffic are generated and tested independently for all 24 channels.


/*///////////////////////////////////////////////////////////////////////////
   aib[19:0]  loopback to aib[39:20]  --transfer data    -> receiving data
   aib[41:40] loopback to aib[43:42]  --transfer clk     -> receiving clk
   aib[85:84] loopback to aib[83:82]  --transfer sr_clk  -> receiving sr_clk
   aib[94]    loopback to aib[92]     --ssr_load_out     -> ssr_load_in

   The following pins are tied to high so that the loopback test will work:
   aib[93] -- ssr_data_in
   aib[65] -- adapter_rx_pld_rst_n
   aib[61] -- adapter_tx_pld_rst_n

*///////////////////////////////////////////////////////////////////////////

sim_aib_top_ncsim: 24 channel loopback simulation with ncsim. 
How to run:
1) cd sim_aib_top_ncsim
2) ./runnc 
This example is similar with sim_aib_top except:
1) ncsim command script provided.  To run the simulation,
2) This loopback test does not bypass DCC/DLL (Dynamic).

sim_phasecom: one channel loopback simulation of enabling phase compensation fifo.
c3aibadapt_wrap.v is modified to pull the 78 bit input/output data along with the 500MHz clock.
This file is stored in sim_phasecom directory.
How to run:
1) cd sim_phasecom
2) make

sim_dcc: Take sim_phasecom as base. Make tx_pam_clk/rx_pma_clk to 40/60 duty cycle distortion.
This test show how DCC works and can correct the duty cycle to almost 50/50.
aibcr3_dcc_helper.v has some delay added to show the little pulse at rising and falling edge for the last 
DFF that generates the dcc clock. Without the change, the function still works but on DVE waveform, the pulse 
disappear. This file is stored in sim_dcc directory.
How to run:
1) cd sim_dcc
2) make

sim_mod2mod: This test show how master model works with slave model.
How to run:
1) cd sim_mod2mod
2) ./runsim
3) ./simv