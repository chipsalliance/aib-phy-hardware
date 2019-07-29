README.txt
FEB 4, 2019

============================================================
============================================================

Included in this package are:
1. c3aib rtl (RTL implementation of AIB interface with no timing constrain file supplied) 
2. CHIP AIB model. Based on AIB spec 1.0.
3. Slave FPGA AIB model
4. Base Test bench master c3aib connect to FPGA AIB or AIB model
5. Test examples with different configurations 
===========================================================
Revision history:
Version 1.0: Initial release

============================================================
Files included:
============================================================
README.txt           - This file

============================================================
Directory structure:

docs
 |-- AIB_Intel_Specification_1_0_version1.pdf AIB Secification. User should read this document first.
 |-- USERGUIDE.txt        - Detail description of the test bench and CHIP AIB model top level ports.

rtl: AIB model files   This models implementation follows AIB_Intel_Specification_1_0_version1.pdf.
 |-aib.v               - AIB model top level.
 |-*.v and *.sv        - AIB model sub-level files.
 |-redundancy_ctrl.vh  - Redundancy Input control ports definition

aib_lib: c3aib files
 |-- c3aibadapt_wrap
     |-- rtl  -- top level clear text
        |-- c3aibadapt_wrap
 |--aibcr3_lib, aibcr3pnr_lib, c3aibadapt, c3dfx, and c3lib. They are related library and rtl. 

maib_rtl: FPGA AIB models if user want to interop c3aib with FPGA through AIB interface.

ndsimslv: simulation test bench and file list
 |-top.sv                 - Test bench file.
 |-multidie.f             - Simulation file list, include test bench and all AIB model files.
                            See README.txt for detail in this directory.
how2use:  example design and testbench
 |-README.txt
 |-sim_aib_top            - Test bench show 24 channel external loopback test.
 |-sim_aib_top_ncsim      - Test bench show 24 channel external loopback test with ncsim.
 |-sim_phasecom           - Test one channel loopback simulation of enabling phase compensation fifo
 |-sim_dcc                - This test show how DCC works and can correct the duty cycle to almost 50/50 from 40/60
 |-sim_sl2ms_lpbk         - 1 channel connects with FPGA AIB model loopback test. See README.txt in this directory for detail. 
 |-sim_mod2mod            - Model to Model test. This test show how master model works with slave model
maib_rtl: Stratix 10 MAIB rtl
============================================================
How to compile and run simulation (VCS)
============================================================
cd ndsimslv
./runsim 
./simv

To view waveform: (the waveform dump file is vcdplus.vpd)
dve -full64

VCS version used: M-2017.03-SP2/linux64

============================================================
How to compile and run simulation (Cadence ncsim)
============================================================
./runnc

============================================================
How to compile and run simulation (Mentor Questasim)
============================================================
./runvsim

