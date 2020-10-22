This test shows how to connect 24 channel in loopback mode and run simulation. DCC/DLL bypassed



		     +------------------+
		     |                  |
		     |                TX|-------+
		     |    v1_master     |       |
		     |                RX<-------+
		     |                  |
		     |	     ns_fwd_clk |-------+
		     |                  |       |
		     |       fs_fwd_clk <-------+
                     |                  |
                     +------------------+
                         Chiplet


Directory
=========

|--- README.txt                -- This file
|--- Makefile
|--- top.sv                    -- test toplevel
|--- dut_io.sv
|--- test.sv                   -- testbench

How to run
==========

1. set up vcs environment
2. make
    + compiles and runs simulation (1000 pkts)

    + if simulation is successful you will see this output

[           287386200] ######### Debug: All Tasks are finished normally #############
287386200: top.t.Finish: finishing simulation..

////////////////////////////////////////////////////////////////////////////
288385000: Simulation ended, ERROR count: 0
////////////////////////////////////////////////////////////////////////////

+++++++++++++++++++++++++++++++++

TEST PASSED!!!!!!!!!!!

+++++++++++++++++++++++++++++++++

3. to analyze results use vpd file (for example, load it in dve)
