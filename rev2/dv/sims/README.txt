===================================================================
This directory contains examples of how to use the AIB open source.
===================================================================

sim_phasecom: Master one channel loopback simulation with phase compensation fifo.
The file c3aib_master.sv (and the underlying c3aibadapt_wrap.v) still uses the Open Source v1 
names i_rx_elane_data/clk and o_tx_elane_data/clk instead of the preferred v2 names data_in 
and data_out.
How to run:
1) cd sim_phasecom
2) ./run_compile (to compile and run) or ./run_compile run (to run previously compiled code)
