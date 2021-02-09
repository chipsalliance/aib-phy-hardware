# Makefile for AIB external loopback simulation
PWD = $(shell pwd)
export RTL_ROOT=${PWD}/../../../rtl
export V2COM_ROOT=${RTL_ROOT}/v2_common
export V1M_ROOT=${RTL_ROOT}/v1_master
export V1S_ROOT=${RTL_ROOT}/v1_slave
export AYAR_RTL=${V2COM_ROOT}/armod
export BC_RTL=${V2COM_ROOT}/dig/bc_mod
export BC_ANA=${V2COM_ROOT}/ana
RTL  = -f ../../flist/aib_defines.cf   -f ../../flist/ms_v1.cf
SVTB = ./top.sv ./dut_io.sv ./test.sv
SEED = 1

default: test

test:	compile run

test_verdi:	compile_verdi run_verdi

compile:
	vcs +lint=TFIPC-L -l vcs.log -sverilog +v2k -full64 +vcs+vcdpluson -timescale=1ps/1ps +define+VCS+BEHAVIORAL+TIMESCALE_EN  $(RTL) $(SVTB)

compile_verdi:
	vcs +lint=TFIPC-L -sverilog -l vcs.log -kdb -debug_access+all +v2k -full64 +vcs+vcdpluson -timescale=1ps/1ps +define+VCS+BEHAVIORAL+TIMESCALE_EN $(RTL) $(SVTB)

run:
	./simv -l sim.log +ntb_random_seed=$(SEED)

run_verdi:
	./simv -l sim.log -verdi +ntb_random_seed=$(SEED)

dve:
	dve &

clean:
	rm -rf simv* csrc* *.fsdb* *.vpd *.log verdiLog *.rc *.conf ucli.key
