## Advanced Interface Bus (AIB) PHY
This repository contains the RTL and cell models for the AIB interface.  See the [AIB Spec](https://github.com/chipsalliance/AIB-specification/blob/master/AIB_Specification%202_0_DRAFT3.pdf) and [AIB Usage Note](https://github.com/chipsalliance/aib-phy-hardware/blob/master/docs/AIB_Usage_Note_v1_2_1.pdf) for information about AIB.

January 29, 2020, Version 1.0 (Initial release of the rev1 and rev2)

## Revision 1 (rev1)
The rev1 open source AIB release is the same as the original moved from https://github.com/intel/aib-phy-hardware.

The rev1 directory structure is:                                    
```aib_phy_hardware
    ├── aib_lib
    ├── docs
    ├── how2use
    ├── maib_rtl
    ├── ndsimslv
```
See README.txt under rev1 and subdirectories for detail.                  
The design and simulation directories and contents are the same as previously released.
New users should start with rev1 for quickest ramp up.                                   

## Revision 2 (rev2)
Rev2 has multi-die AIB instances and test benches recommended for advanced users.

Main directory structure is below.  Read the README.txt files in the subdirectories for details.

```aib_phy_hardware
├── docs
│   └── archive
└── rev2              --  Multi-die AIBs design (for advanced user reference)
    ├── dv            --  System Verilog DV to be released in the future.
    │   ├── flist     --  File lists for multi-die AIB IPs.
    │   ├── sims      --  Compilation directory. VCS is supported for now.
    └── rtl           --  For the detail of the rtl release, see README.txt in this directory
        ├── v1_master
        ├── v1_slave
        ├── v2_common
        ├── v2_master
        └── v2_slave

## Version 2.0 (rev1)
Feb. 09, 2021, Version 2.0 (Initial release of the AIB 2.0 Model and DV)
Previous revision 1.0 and revision 2.0 pushed down to version 1.0.

## Version 2.0 (rev1.1)
June 02, 2022 (Added MAIB 1.1 model and its DV suite)
Main directory structure is below.  Read the README.txt files in the subdirectories for details.

```aib-phy-hardware
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
    ├── rev1           -- AIB model for AIB 2.0 Specification
    │   ├── dv         -- System Verilog Verification Suite
    │   └── rtl        -- Behavior RTL model
    ├── rev1.1         -- MAIB 1.1
        ├── dv
        └── rtl        -- MAIB 1.1 model
```

