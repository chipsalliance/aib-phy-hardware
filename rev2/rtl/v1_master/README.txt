README.txt
January 29, 2020

===========================================================
Revision history:
Version 1.0: Initial release
===========================================================


Included in this directory are  west Master AIB top level RTL and submodules

c3aibadapt_wrap
└── rtl
    ├── aib_top.v                 -- The RTL top level delivery. instantiated c3aibadapt_wrap_top.v and aux
    ├── c3aibadapt_wrap_top.v     -- 24 AIB master channel. Instantiated c3aibadapt_wrap.v
    ├── c3aibadapt_wrap.v         -- Single AIB master channel
    ├── aib_top_wrapper_v1m.sv    -- An optional wrapper file that instantiate aib_top_v2m.v and mapped ports
                                     to match AIB specification. Can be used in simulation when integrating
                                     multi-chiplet for the more unified interface.
===========================================================
File list for compilation:
===========================================================
For RTL compilation of v2_master, the compilation file list is located at:
../../dv/flist/
ms_v1.cf
