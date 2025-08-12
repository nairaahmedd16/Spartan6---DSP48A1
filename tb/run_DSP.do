vlib work
vlog DSP_TB.v
vsim -voptargs=+acc work.DSP_tb
add wave *
run -all
#quit -sim