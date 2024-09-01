vlib work 

vlog DSP.v Reg_Mux.v DSP_tb.v

vsim -voptargs=+acc work.DSP_tb

add wave *

run -all
