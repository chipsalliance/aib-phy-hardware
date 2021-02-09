# Makefile for AIB external loopback simulation
RTL= ./c3aibadapt_wrap.f
SVTB= ./top.sv ./dut_io.sv ./test.sv
SEED= 1

default: test

test:	compile run

compile:
	vcs -sverilog +v2k -full64 +vcs+vcdpluson -timescale=1ps/1ps +define+VCS+BEHAVIORAL+TIMESCALE_EN -f $(RTL) $(SVTB)

run:
	./simv -l sim.log +ntb_random_seed=$(SEED)

dve:
	dve &

clean:
	rm -rf simv* csrc* *.vpd *.log
