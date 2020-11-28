## Generated SDC file "sdram_top.out.sdc"

## Copyright (C) 1991-2013 Altera Corporation
## Your use of Altera Corporation's design tools, logic functions 
## and other software and tools, and its AMPP partner logic 
## functions, and any output files from any of the foregoing 
## (including device programming or simulation files), and any 
## associated documentation or information are expressly subject 
## to the terms and conditions of the Altera Program License 
## Subscription Agreement, Altera MegaCore Function License 
## Agreement, or other applicable license agreement, including, 
## without limitation, that your use is for the sole purpose of 
## programming logic devices manufactured by Altera and sold by 
## Altera or its authorized distributors.  Please refer to the 
## applicable agreement for further details.


## VENDOR  "Altera"
## PROGRAM "Quartus II"
## VERSION "Version 13.0.0 Build 156 04/24/2013 SJ Full Version"

## DATE    "Sat Nov 21 14:02:02 2020"

##
## DEVICE  "EP2C8T144C6"
##


#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3



#**************************************************************
# Create Clock
#**************************************************************

create_clock -name {altera_reserved_tck} -period 100.000 -waveform { 0.000 50.000 } [get_ports {altera_reserved_tck}]
create_clock -name {clock} -period 37.037 -waveform { 0.000 18.000 } [get_ports { clock }]
create_clock -name {sclk} -period 9.972 -waveform { 0.000 5.000 } [get_pins { sdram_pll_inst|altpll_component|pll|clk[0] }]


#**************************************************************
# Create Generated Clock
#**************************************************************



#**************************************************************
# Set Clock Latency
#**************************************************************

set_clock_latency -source   4.000 [get_clocks {sclk}]


#**************************************************************
# Set Clock Uncertainty
#**************************************************************



#**************************************************************
# Set Input Delay
#**************************************************************



#**************************************************************
# Set Output Delay
#**************************************************************

set_output_delay -add_delay  -clock [get_clocks {sclk}]  4.000 [get_ports {sdram_addr[0]}]
set_output_delay -add_delay  -clock [get_clocks {sclk}]  4.000 [get_ports {sdram_addr[1]}]
set_output_delay -add_delay  -clock [get_clocks {sclk}]  4.000 [get_ports {sdram_addr[2]}]
set_output_delay -add_delay  -clock [get_clocks {sclk}]  4.000 [get_ports {sdram_addr[3]}]
set_output_delay -add_delay  -clock [get_clocks {sclk}]  4.000 [get_ports {sdram_addr[4]}]
set_output_delay -add_delay  -clock [get_clocks {sclk}]  4.000 [get_ports {sdram_addr[5]}]
set_output_delay -add_delay  -clock [get_clocks {sclk}]  4.000 [get_ports {sdram_addr[6]}]
set_output_delay -add_delay  -clock [get_clocks {sclk}]  4.000 [get_ports {sdram_addr[7]}]
set_output_delay -add_delay  -clock [get_clocks {sclk}]  4.000 [get_ports {sdram_addr[8]}]
set_output_delay -add_delay  -clock [get_clocks {sclk}]  4.000 [get_ports {sdram_addr[9]}]
set_output_delay -add_delay  -clock [get_clocks {sclk}]  4.000 [get_ports {sdram_addr[10]}]
set_output_delay -add_delay  -clock [get_clocks {sclk}]  4.000 [get_ports {sdram_addr[11]}]
set_output_delay -add_delay  -clock [get_clocks {sclk}]  4.000 [get_ports {sdram_bank[0]}]
set_output_delay -add_delay  -clock [get_clocks {sclk}]  4.000 [get_ports {sdram_bank[1]}]
set_output_delay -add_delay  -clock [get_clocks {sclk}]  4.000 [get_ports {sdram_cas_n}]
set_output_delay -add_delay  -clock [get_clocks {sclk}]  4.000 [get_ports {sdram_clk}]
set_output_delay -add_delay  -clock [get_clocks {sclk}]  4.000 [get_ports {sdram_dq[0]}]
set_output_delay -add_delay  -clock [get_clocks {sclk}]  4.000 [get_ports {sdram_dq[1]}]
set_output_delay -add_delay  -clock [get_clocks {sclk}]  4.000 [get_ports {sdram_dq[2]}]
set_output_delay -add_delay  -clock [get_clocks {sclk}]  4.000 [get_ports {sdram_dq[3]}]
set_output_delay -add_delay  -clock [get_clocks {sclk}]  4.000 [get_ports {sdram_dq[4]}]
set_output_delay -add_delay  -clock [get_clocks {sclk}]  4.000 [get_ports {sdram_dq[5]}]
set_output_delay -add_delay  -clock [get_clocks {sclk}]  4.000 [get_ports {sdram_dq[6]}]
set_output_delay -add_delay  -clock [get_clocks {sclk}]  4.000 [get_ports {sdram_dq[7]}]
set_output_delay -add_delay  -clock [get_clocks {sclk}]  4.000 [get_ports {sdram_dq[8]}]
set_output_delay -add_delay  -clock [get_clocks {sclk}]  4.000 [get_ports {sdram_dq[9]}]
set_output_delay -add_delay  -clock [get_clocks {sclk}]  4.000 [get_ports {sdram_dq[10]}]
set_output_delay -add_delay  -clock [get_clocks {sclk}]  4.000 [get_ports {sdram_dq[11]}]
set_output_delay -add_delay  -clock [get_clocks {sclk}]  4.000 [get_ports {sdram_dq[12]}]
set_output_delay -add_delay  -clock [get_clocks {sclk}]  4.000 [get_ports {sdram_dq[13]}]
set_output_delay -add_delay  -clock [get_clocks {sclk}]  4.000 [get_ports {sdram_dq[14]}]
set_output_delay -add_delay  -clock [get_clocks {sclk}]  4.000 [get_ports {sdram_dq[15]}]
set_output_delay -add_delay  -clock [get_clocks {sclk}]  4.000 [get_ports {sdram_dqm[0]}]
set_output_delay -add_delay  -clock [get_clocks {sclk}]  4.000 [get_ports {sdram_dqm[1]}]
set_output_delay -add_delay  -clock [get_clocks {sclk}]  4.000 [get_ports {sdram_ras_n}]
set_output_delay -add_delay  -clock [get_clocks {sclk}]  4.000 [get_ports {sdram_we_n}]


#**************************************************************
# Set Clock Groups
#**************************************************************

set_clock_groups -asynchronous -group [get_clocks {altera_reserved_tck}] 


#**************************************************************
# Set False Path
#**************************************************************



#**************************************************************
# Set Multicycle Path
#**************************************************************



#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************

