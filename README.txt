README.txt
January 29, 2020

===========================================================
Revision history:
Revision 1.0: Initial release
Revision 2.0: open source AIB release: Multi-die AIBs design
Version  2.0: AIB 2.0 Feb. 9, 2021
Revision 1.0: AIB 2.0 Model and DV
===========================================================


============================================================
Included in this package are : 
revision 1 open source AIB release : 
                   Moved from https://github.com/intel/aib-phy-hardware 
The original structure is as follow:
                                 aib_phy_hardware
                                 ├── aib_lib
                                 ├── docs
                                 ├── how2use
                                 ├── maib_rtl
                                 ├── ndsimslv
See README.txt under rev1 and subdirectory for detail. 
For existing user, the design and simulation directory and contents are kept same.
For new user, start with rev1 for quck ramp up.

============================================================
revision 2 open source AIB release: Multi-die AIBs design 
For advanced user, rev2 served as example IPs and their interactive simulation
in the multi-die system.
============================================================
Main directory structures (Read README.txt files in the sub directory for detail
============================================================

aib_phy_hardware
├── docs
│   └── archive
├── rev1              -- Originally from opensource release https://github.com/intel/aib-phy-hardware
│   ├── aib_lib
│   ├── how2use
│   ├── maib_rtl
│   ├── ndsimslv
│   └── rtl
└── rev2              --  Multi-die AIBs design (for advanced user reference) 
    ├── dv            --  System Verilog DV to be released in the future.
    │   ├── flist     --  File lists for multi-die AIB IPs.
    │   ├── sims      --  Compilation directory. VCS is supported for now.
    └── rtl           -- For the detail of the rtl release, see README.txt in this directory
        ├── v1_master
        ├── v1_slave
        ├── v2_common
        ├── v2_master
        └── v2_slave

============================================================

===========================================================
Version 2.0 open source AIB Gen 2.0
Previous revision 1.0 and revision 2.0 pushed down to version 1.0.
===========================================================

aib_phy_hardware
├── docs
│   └── archive
├── v1.0
│   ├── rev1             -- Previous rev1
│   │   ├── aib_lib
│   │   ├── how2use
│   │   ├── maib_rtl
│   │   ├── ndsimslv
│   │   └── rtl
│   └── rev2             -- Previous rev2 as above
│       ├── constraints
│       ├── dv
│       └── rtl
└── v2.0
    └── rev1             -- AIB model for AIB 2.0 Specification
        ├── dv           -- System Verilog Verification Suite
        └── rtl          -- Behavior RTL model
