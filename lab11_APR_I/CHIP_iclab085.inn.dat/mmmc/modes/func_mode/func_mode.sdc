###############################################################
#  Generated by:      Cadence Innovus 20.15-s105_1
#  OS:                Linux x86_64(Host ID ee06)
#  Generated on:      Mon Dec 19 21:11:05 2022
#  Design:            CHIP
#  Command:           routeDesign -globalDetail
###############################################################
current_design CHIP
create_clock [get_ports {clk}]  -name clk -period 9.000000 -waveform {0.000000 4.500000}
set_propagated_clock  [get_ports {clk}]
set_load -pin_load -max  0.05  [get_ports {out_valid}]
set_load -pin_load -min  0.05  [get_ports {out_valid}]
set_load -pin_load -max  0.05  [get_ports {out_value}]
set_load -pin_load -min  0.05  [get_ports {out_value}]
set_input_delay -add_delay 4.5 -clock [get_clocks {clk}] [get_ports {in_valid}]
set_input_delay -add_delay 0 -clock [get_clocks {clk}] [get_ports {rst_n}]
set_input_delay -add_delay 4.5 -clock [get_clocks {clk}] [get_ports {matrix_size[1]}]
set_input_delay -add_delay 4.5 -clock [get_clocks {clk}] [get_ports {i_mat_idx}]
set_input_delay -add_delay 4.5 -clock [get_clocks {clk}] [get_ports {matrix}]
set_input_delay -add_delay 4.5 -clock [get_clocks {clk}] [get_ports {w_mat_idx}]
set_input_delay -add_delay 4.5 -clock [get_clocks {clk}] [get_ports {matrix_size[0]}]
set_input_delay -add_delay 4.5 -clock [get_clocks {clk}] [get_ports {in_valid2}]
set_output_delay -add_delay 4.5 -clock [get_clocks {clk}] [get_ports {out_value}]
set_output_delay -add_delay 4.5 -clock [get_clocks {clk}] [get_ports {out_valid}]
