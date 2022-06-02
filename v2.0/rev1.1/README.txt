README.txt
April. 19, 2022

============================================================
============================================================

Included in this package are:
1. MAIB rev1.1
2. SystemVerilog DV suites of the stack. 
   a) Reuse rev1 TB and test case.
   b) Follower can be replaced by MAIB rev1.1 (AIB 1.0) 
   c) Leader (AIB2.0 Gen1)
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
│   │   └── tb_rtl.cf                  -- TB file list. Re-use rev1.0 testbench
│   ├── interface
│   │   └── dut_s1_maib_rev1.1.inc
│   ├── sims
│   │   ├── README.txt                 -- For how to run rev1.1, see this file
│   │   ├── run_compile_m2s1           -- run script
│   │   └── test.inc -> ../../../rev1/dv/test/test_cases/fifo2x_test_slaib1.inc
│   └── test
│       └── data
│           └── maib_prog_rev1.1.inc   -- Programming of MAIB 1.1
└── rtl
    └── maib_rev1.1
        ├── maib_ch.v
        ├── maib_lib_sim_model.v        -- MAIB rev 1.1 model
        ├── maib_top_96pin.sv
        └── ndaibadapt_wrap.v

