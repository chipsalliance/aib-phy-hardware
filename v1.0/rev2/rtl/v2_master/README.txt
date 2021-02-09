README.txt
January 29, 2020

===========================================================
Revision history:
Version 1.0: Initial release
===========================================================


Included in this package are Master AIB top level RTL of Chiplet2:

c3aibadapt_wrap
└── rtl
    ├── aib_top_v2m.v             -- The RTL top level delivery. instantiated c3aibadapt_wrap_top.v and aux
    ├── c3aibadapt_wrap_top.v     -- 24 AIB master channel. Instantiated c3aibadapt_wrap.v
    ├── c3aibadapt_wrap.v         -- Single AIB master channel
    └── aib_top_wrapper_v2m.sv    -- An optional wrapper file that instantiate aib_top_v2m.v and mapped ports 
                                     to match AIB specification. Can be used in simulation when integrating 
                                     multi-chiplet for the more unified interface.    
    
===========================================================
File list for compilation:
===========================================================
For RTL compilation of v2_master, the compilation file list is located at:
../../dv/flist/
aib_defines.cf
aibcr3_buffx1_top.cf
aib_analog.cf
aibcr3_cmn.cf
aibcr3_top_wrp.cf
c3aibadapt_wrap.cf
ms_v2.cf
