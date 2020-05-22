add wave -position insertpoint \
sim:/mux/which \
sim:/mux/input_0 \
sim:/mux/input_1 \
sim:/mux/output \

force -freeze sim:/mux/which 0 0, 1 {150 ns} -r 300
force -freeze sim:/mux/input_0 32'h0000000F 0
force -freeze sim:/mux/input_1 32'hFFFFFFFF 0
run 500 ns