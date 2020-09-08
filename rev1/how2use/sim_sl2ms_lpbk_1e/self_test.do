onerror resume
vlib work
do vlog.do
vsim -t 1ps top
add log -r vsim:/top/*
add wave dut/*
run -a
quit
