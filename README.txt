README.txt
FEB 4, 2019

============================================================
============================================================

Included in this package are:
1. c3aib rtl (RTL implementation of AIB interface) 
2. CHIP AIB model. Based on AIB spec 1.0.
3. Test bench
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

ndsimslv: simulation test bench and file list
 |-top.sv                 - Test bench file.
 |-multidie.f             - Simulation file list, include test bench and all AIB model files.
how2use:  example design and testbench
 |-README.txt
 |-sim_aib_top            - Test bench show 24 channel external loopback test.
 |-sim_aib_top_ncsim      - Test bench show 24 channel external loopback test with ncsim.

============================================================
How to compile and run simulation (VCS)
============================================================
To compile, use the file in:

cd ndsimslv
./runsim

To run simulation:
./simv

To view waveform: (the waveform dump file is vcdplus.vpd)
dve -full64

VCS version used: M-2017.03-SP2/linux64
