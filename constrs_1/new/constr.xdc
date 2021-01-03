set_property LOC T20 [get_ports VGA_B[0]]
set_property LOC R20 [get_ports VGA_B[1]]
set_property LOC T22 [get_ports VGA_B[2]]
set_property LOC T23 [get_ports VGA_B[3]]

set_property LOC R22 [get_ports VGA_G[0]]
set_property LOC R23 [get_ports VGA_G[1]]
set_property LOC T24 [get_ports VGA_G[2]]
set_property LOC T25 [get_ports VGA_G[3]]

set_property LOC N21 [get_ports VGA_R[0]]
set_property LOC N22 [get_ports VGA_R[1]]
set_property LOC R21 [get_ports VGA_R[2]]
set_property LOC P21 [get_ports VGA_R[3]]

set_property LOC M22 [get_ports HS]
set_property LOC M21 [get_ports VS]

set_property IOSTANDARD LVCMOS33 [get_ports VGA_B[0]]
set_property IOSTANDARD LVCMOS33 [get_ports VGA_B[1]]
set_property IOSTANDARD LVCMOS33 [get_ports VGA_B[2]]
set_property IOSTANDARD LVCMOS33 [get_ports VGA_B[3]]
set_property IOSTANDARD LVCMOS33 [get_ports VGA_G[0]]
set_property IOSTANDARD LVCMOS33 [get_ports VGA_G[1]]
set_property IOSTANDARD LVCMOS33 [get_ports VGA_G[2]]
set_property IOSTANDARD LVCMOS33 [get_ports VGA_G[3]]
set_property IOSTANDARD LVCMOS33 [get_ports VGA_R[0]]
set_property IOSTANDARD LVCMOS33 [get_ports VGA_R[1]]
set_property IOSTANDARD LVCMOS33 [get_ports VGA_R[2]]
set_property IOSTANDARD LVCMOS33 [get_ports VGA_R[3]]
set_property IOSTANDARD LVCMOS33 [get_ports HS]
set_property IOSTANDARD LVCMOS33 [get_ports VS]

set_property LOC         AC18      [get_ports clk]
set_property IOSTANDARD  LVCMOS18  [get_ports clk]


create_clock -name TM_CLK -period 10 -waveform {0 6.665} [get_ports clk]

#PS2
set_property LOC N18 [get_ports PS2_clk]
set_property LOC M19 [get_ports PS2_data]
set_property IOSTANDARD LVCMOS33 [get_ports PS2_clk]
set_property IOSTANDARD LVCMOS33 [get_ports PS2_data]

#SEGMENT
set_property LOC M24 [get_ports SEGCLK]
set_property LOC M20 [get_ports SEGCLR]
set_property LOC L24 [get_ports SEGDT]
set_property LOC R18 [get_ports SEGEN]

set_property IOSTANDARD LVCMOS33 [get_ports SEGCLK]
set_property IOSTANDARD LVCMOS33 [get_ports SEGCLR]
set_property IOSTANDARD LVCMOS33 [get_ports SEGDT]
set_property IOSTANDARD LVCMOS33 [get_ports SEGEN]

set_property LOC W13             [get_ports rstn]
set_property IOSTANDARD LVCMOS18 [get_ports rstn]