
Description
===========

This tests shows how to test single channel with chiplet (c3) and slave(s10) with loopback on master side.
DCC/DLL are bypassed

Test bench(top.sv) description
==============================

c3aib c3aib_master and (CHIP AIB(aib) model or s10aib FPGA aib model) are instantiated in the test bench.
the left side as slave, the right side is c3aib.
Both clocks and data are supplied at the slave side. c3aib was properly configured in loopback mode and
release the reset. No transfer clocks and data supplied at master side.




                                                           (data loopback at master side)
  random        +------------+ 	       	       	       	   +------------+
  data   tx---->|            |				   |          rx|----->
	        |            <----------------------------->            |     | 
  data	 rx<----|   s10aib   |                    	   |   c3aib  tx|<----+
  checker       |            |          	       	   |            |
	        |            |				   |            |
	        +------------+				   +------------+
                    slave                                       master


Directory
=========

|--- README.txt                -- This file
|--- Makefile
|--- top.sv                    -- test toplevel
|--- dut_io.sv
|--- test.sv                   -- testbench
|--- c3aib_master.sv           -- master
|--- s10aib.v                  -- slave
|--- {nda_drv.v,nda_port.v     -- test files included in top.sv
      ndut_declare.v,
      ndut_default.v}
|--- ndut_io.sv                -- optional slave io

      
How to run
==========

1. set up vcs environment
2. make
    + compiles and runs simulation (1000 pkts)

    + if simulation is successful you will see this output

[          3152500000] ######### Debug: All Tasks are finished normally #############
3152500000: top.Finish: finishing simulation..

////////////////////////////////////////////////////////////////////////////
3652500000: Simulation ended, ERROR count: 0
////////////////////////////////////////////////////////////////////////////

+++++++++++++++++++++++++++++++++

TEST PASSED!!!!!!!!!!!

+++++++++++++++++++++++++++++++++

3. to analyze results use vpd file (for example, load it in dve)



						      o
