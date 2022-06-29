README.txt
June 25, 2022

============================================================
============================================================

Included in this package are:
1. Dual mode AIB 2.0 BCA hard macro 
2. MAIB rev1.1
2. SystemVerilog DV suites of the stack. 
   a) Reuse rev1 TB and test case.
   b) Follower can be replaced by MAIB rev1.1 (AIB 1.0) or BCA Slave mode (AIB2.0 or Gen1)
   c) Leader can be replaced by BCA Master mode (AIB2.0 or Gen1)
   d) Basic data path configurations tests are provided.

===========================================================
Revision history:
Version 1.0: Initial release
For detail how to run these test, see README.txt under aib-phy-hardware/v2.0/rev1.1/dv/sims
============================================================
Files included:
============================================================
README.txt           - This file

============================================================


rev1.1
├── README.txt
├── dv
│   ├── flist
│   │   ├── AIB2.0_RTL_filelist.f
│   │   ├── hdpldadapt.f
│   │   ├── maib_rev1.1.cf
│   │   ├── maib_rev1.1_aux.cf
│   │   └── tb_rtl.cf             -- TB file list. Re-use rev1.0 testbench
│   ├── interface
│   │   ├── dut_ms1_bca.inc
│   │   ├── dut_s1_maib_rev1.1.inc
│   │   └── dut_sl1_bca.inc
│   ├── sims
│   │   ├── README.txt            -- For how to run rev1.1, see this file
│   │   ├── run_compile_bca
│   │   ├── run_compile_bca2s1
│   │   ├── run_compile_bca_ncsim
│   │   ├── run_compile_m1bca
│   │   ├── run_compile_m2s1
│   │   ├── sim_input.tcl
│   │   └── test.inc -> ../../../rev1/dv/test/test_cases/fifo4x_fslpbk_test.inc
│   └── test
│       └── data        -- Programming of MAIB 1.1
└── rtl
    ├── bca             -- BCA file list
    │   ├── AIB2.0_RTL_filelist.f
    │   ├── README_RTL.txt
    │   ├── ana_models
    │   ├── behavior
    │   └── src
    └── maib_rev1.1
        ├── maib_ch.v
        ├── maib_lib_sim_model.v
        ├── maib_top_96pin.sv
        ├── module_list
        └── ndaibadapt_wrap.v

