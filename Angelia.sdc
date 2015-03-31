## Generated SDC file "Angelia.sdc"

## Copyright (C) 1991-2012 Altera Corporation
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
## VERSION "Version 12.1 Build 177 11/07/2012 SJ Web Edition"

## Created by Joe Martin K5SO

## DATE    "Thu Apr 08 13:23:28 2013"

##
## DEVICE  "EP4CE115F29C8"
##


#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3



#**************************************************************
# Create Clock
#**************************************************************

create_clock -name {PHY_CLK125} -period 125.000MHz [get_ports {PHY_CLK125}]
create_clock -name {LTC2208_122MHz} -period 122.880MHz [get_ports {LTC2208_122MHz}]
create_clock -name {LTC2208_122MHz_2} -period 122.880MHz  [get_ports {LTC2208_122MHz_2}]
create_clock -name {OSC_10MHZ} -period 10.000MHz [get_ports {OSC_10MHZ}]
create_clock -name {_122MHz} -period 122.880MHz [get_ports {_122MHz}]
create_clock -name {PHY_RX_CLOCK} -period 25.000MHz [get_ports {PHY_RX_CLOCK}]
create_clock -name {Attenuator:Attenuator_inst|clk_2} -period 24.000MHz [get_registers {Attenuator:Attenuator_inst|clk_2}]
create_clock -name {Attenuator:Attenuator_ADC1|clk_2} -period 24.000MHz [get_registers {Attenuator:Attenuator_ADC1|clk_2}]
create_clock -name {Attenuator:Attenuator_ADC2|clk_2} -period 24.000MHz [get_registers {Attenuator:Attenuator_ADC2|clk_2}]

derive_pll_clocks

derive_clock_uncertainty


#**************************************************************
# Create Generated Clock
#**************************************************************
create_generated_clock -divide_by 2 -source PHY_RX_CLOCK -name PHY_RX_CLOCK_2  [get_registers {PHY_RX_CLOCK_2}]
create_generated_clock -name {Angelia_clk_lrclk_gen:clrgen|BCLK} -source [get_ports {LTC2208_122MHz}] -divide_by 40 [get_registers {Angelia_clk_lrclk_gen:clrgen|BCLK}] 
create_generated_clock -divide_by 8  -source Angelia_clk_lrclk_gen:clrgen|BCLK 	[get_registers {spc[2]}]

#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************



#**************************************************************
# Set Input Delay
#**************************************************************



#**************************************************************
# Set Output Delay
#**************************************************************



#**************************************************************
# Set Clock Groups
#**************************************************************
set_clock_groups -asynchronous 	-group {spc[2]} \
				       {Angelia_clk_lrclk_gen:clrgen|BCLK} \
				-group {PHY_RX_CLOCK_2} \
				-group {PLL_IF_inst|altpll_component|auto_generated|pll1|clk[0]} \
				-group {PLL_IF_inst|altpll_component|auto_generated|pll1|clk[2]} \
				-group {PLL_IF_inst|altpll_component|auto_generated|pll1|clk[1]}



#**************************************************************
# Set False Path
#**************************************************************



#**************************************************************
# Set Multicycle Path
#**************************************************************
set_multicycle_path -from LTC2208_122MHz -to * -setup 2
set_multicycle_path -from LTC2208_122MHz -to * -hold 1
#
set_multicycle_path -from LTC2208_122MHz_2 -to * -setup 2
set_multicycle_path -from LTC2208_122MHz_2 -to * -hold 1
#
set_multicycle_path -from _122MHz -to * -setup 2
set_multicycle_path -from _122MHz -to * -hold 1
#
set_multicycle_path -from PLL_IF_inst|altpll_component|auto_generated|pll1|clk[0] -to * -setup 2
set_multicycle_path -from PLL_IF_inst|altpll_component|auto_generated|pll1|clk[0] -to * -hold 1
#
set_multicycle_path -from PLL_IF_inst|altpll_component|auto_generated|pll1|clk[1] -to * -setup 4
set_multicycle_path -from PLL_IF_inst|altpll_component|auto_generated|pll1|clk[1] -to * -hold 3
#
set_multicycle_path -from PLL_IF_inst|altpll_component|auto_generated|pll1|clk[2] -to * -setup 3
set_multicycle_path -from PLL_IF_inst|altpll_component|auto_generated|pll1|clk[2] -to * -hold 2
#
#set_multicycle_path -from Attenuator:Attenuator_inst|clk_2 -to * -setup 4
#set_multicycle_path -from Attenuator:Attenuator_inst|clk_2 -to * -hold 3
#
set_multicycle_path -from PHY_RX_CLOCK_2 -to * -setup 2
set_multicycle_path -from PHY_RX_CLOCK_2 -to * -hold 1
#
set_multicycle_path -from Attenuator:Attenuator_inst|clk_2 -to * -setup 3
set_multicycle_path -from Attenuator:Attenuator_inst|clk_2 -to * -hold 2
#
#set_multicycle_path -from Attenuator:Attenuator_ADC1|clk_2 -to * -setup 4
#set_multicycle_path -from Attenuator:Attenuator_ADC1|clk_2 -to * -hold 3
#
#set_multicycle_path -from Attenuator:Attenuator_ADC2|clk_2 -to * -setup 4
#set_multicycle_path -from Attenuator:Attenuator_ADC2|clk_2 -to * -hold 3


#**************************************************************
# Set Maximum Delay
#**************************************************************
set_max_delay -from Attenuator:Attenuator_inst|clk_2 -to PLL_IF_inst|altpll_component|auto_generated|pll1|clk[0] 10
set_max_delay -from Attenuator:Attenuator_ADC1|clk_2 -to * 10
set_max_delay -from Attenuator:Attenuator_ADC2|clk_2 -to * 10
set_max_delay -from reset -to * 20
set_max_delay -from * -to Led_flash:Flash_LED3|counter[*] 15
set_max_delay -from * -to Led_flash:Flash_LED6|counter[*] 15
set_max_delay -from * -to Led_flash:Flash_LED10|counter[*] 15
set_max_delay -from * -to Led_flash:Flash_LED3|LED 15
set_max_delay -from * -to Led_flash:Flash_LED6|LED 15
set_max_delay -from * -to Led_flash:Flash_LED10|LED 15


#**************************************************************
# Set Minimum Delay
#**************************************************************
set_min_delay -from Attenuator:Attenuator_inst|clk_2 -to PLL_IF_inst|altpll_component|auto_generated|pll1|clk[0] -5
set_min_delay -from Attenuator:Attenuator_ADC1|clk_2 -to * -5
set_min_delay -from Attenuator:Attenuator_ADC2|clk_2 -to * -5
set_min_delay -from reset -to * -5
set_min_delay -from * -to Led_flash:Flash_LED3|counter[*] -5
set_min_delay -from * -to Led_flash:Flash_LED6|counter[*] -5
set_min_delay -from * -to Led_flash:Flash_LED10|counter[*] -5
set_min_delay -from * -to Led_flash:Flash_LED3|LED -5
set_min_delay -from * -to Led_flash:Flash_LED6|LED -5
set_min_delay -from * -to Led_flash:Flash_LED10|LED -5


#**************************************************************
# Set Input Transition
#**************************************************************

