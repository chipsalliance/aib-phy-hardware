rm -rf INCA_libs

export RTL_ROOT="$(pwd)/../../rtl"
export V1M_ROOT="$RTL_ROOT"

irun -sv -timescale 1ps/1ps -f ../flist/ms.cf -f ../flist/tb_rtl_ch.cf -access rwc -input sim_input.tcl
