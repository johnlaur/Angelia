# NOTE: When using -name <value> the value is what you want to call it for use in the sdc file.
# for example, we can refer to the clock [get_ports LTC2208_122MHz]  as just LTC2208_122MHz
# if you don't give a -name then use the full name of the clock.

# [get_ports <name>] assigns the name of a clock connected to an FPGA input PIN

# you can set clock frequency in MHz rather than using nS by placing MHz after the period value.


create_clock -period 122.88MHz    [get_ports LTC2208_122MHz]  			-name LTC2208_122MHz
create_clock -period 122.88MHz    [get_ports LTC2208_122MHz_2]  		-name LTC2208_122MHz_2
create_clock -period 122.88MHz    _122MHz
create_clock -period 10.000MHz    [get_ports OSC_10MHZ] 					-name OSC_10MHZ
create_clock -period 125.00MHz    [get_ports PHY_CLK125] 				-name PHY_CLK125
create_clock -period  25.00MHz    [get_ports CLK_25MHZ] 					-name CLK_25MHZ
create_clock -period  25.00MHz    [get_ports PHY_RX_CLOCK] 				-name PHY_RX_CLOCK
create_clock -period  12.50MHz    Rx_MAC:Rx_MAC_inst|PHY_100T_state 	-name Rx_MAC_state
create_clock -period  24.00MHz    Attenuator:Attenuator_inst|clk_2  	-name Attenuator_clk

derive_pll_clocks

derive_clock_uncertainty

set_clock_groups -asynchronous -group {OSC_10MHZ PLL2_inst|altpll_component|auto_generated|pll1|clk[0]} \
                               -group {PLL_IF_inst|altpll_component|auto_generated|pll1|clk[1] \
													PLL_IF_inst|altpll_component|auto_generated|pll1|clk[2] }\
										 -group {PLL_IF_inst|altpll_component|auto_generated|pll1|clk[0]} \
										 -group {PHY_CLK125 PLL_clocks_inst|altpll_component|auto_generated|pll1|clk[0]  \
													PLL_clocks_inst|altpll_component|auto_generated|pll1|clk[1]  \
													PLL_clocks_inst|altpll_component|auto_generated|pll1|clk[2] } \
										 -group {PLL_inst|altpll_component|auto_generated|pll1|clk[0]} \
										 -group {CLK_25MHZ} \
										 -group {Rx_MAC_state} \
										 -group {LTC2208_122MHz} \
										 -group {LTC2208_122MHz_2} \
										 -group {_122MHz} \
										 -group {Attenuator_clk} 

										 
# Add internally generated clocks - for an inverted clock creat a clock using the -invert option 
create_generated_clock -divide_by 40 -source [get_ports LTC2208_122MHz]  			Hermes_clk_lrclk_gen:clrgen|BCLK
create_generated_clock -divide_by 4  -source Hermes_clk_lrclk_gen:clrgen|BCLK 	spc[1]
create_generated_clock -divide_by 2  -source PHY_RX_CLOCK  PHY_RX_CLOCK_2
create_generated_clock -source PLL_clocks_inst|altpll_component|auto_generated|pll1|clk[1]  -invert PHY_TX_CLOCK


set_false_path -from {cdc_sync:freq*|sigb[*]}  -to {C122_sync_phase_word[*][*]}
set_false_path -from {cdc_sync:freq*|sigb[*]}  -to {C122_sync_phase_word_Tx[*]}
set_false_path -from PLL_IF_inst|altpll_component|auto_generated|pll1|clk[0] -to spc[1]
set_false_path -from LTC2208_122MHz -to spc[1]
# note multiple targets in the next line
set_false_path -from PHY_RX_CLOCK_2 -to {PLL_IF_inst|altpll_component|auto_generated|pll1|clk[0]  LTC2208_122MHz}
set_false_path -from [get_clocks {PHY_CLK125}] -to [get_clocks {PHY_RX_CLOCK}]
set_false_path -from [get_clocks {Angelia_clk_lrclk_gen:clrgen|BCLK}] -to [get_clocks {PLL_IF_inst|altpll_component|auto_generated|pll1|clk[*]}]

#set multicycle paths
set_multicycle_path -from {cicint:cic_*|*} -to {*} -setup -end 2
set_multicycle_path -from {cicint:cic_*|*} -to {*} -hold -end 1
set_multicycle_path -from {SP_fifo:SPF|dcfifo_mixed_widths:dcfifo_mixed_widths_component|dcfifo_juj1:auto_generated|*} -to {SP_fifo:SPF|dcfifo_mixed_widths:*} -setup -end 2
set_multicycle_path -from {SP_fifo:SPF|dcfifo_mixed_widths:dcfifo_mixed_widths_component|dcfifo_juj1:auto_generated|*} -to {SP_fifo:SPF|dcfifo_mixed_widths:*} -hold  -end 1
set_multicycle_path -from {receiver:receiver_inst*|*} -to {receiver:receiver_inst*|*} -setup -end 2
set_multicycle_path -from {receiver:receiver_inst*|*} -to {receiver:receiver_inst*|*} -hold  -end 1
set_multicycle_path -from {cdc_sync:freq*|sigb[*]~_Duplicate_2} -to {C122_freq_*[*]} -setup -end 2
set_multicycle_path -from {cdc_sync:freq*|sigb[*]~_Duplicate_2} -to {C122_freq_*[*]} -hold -end 1
set_multicycle_path -from {cdc_sync:rate|sigb[*]} -to {receiver:receiver_inst*|varcic:varcic_inst_*|out_data[*]} -setup -end 2
set_multicycle_path -from {cdc_sync:rate|sigb[*]} -to {receiver:receiver_inst*|varcic:varcic_inst_*|out_data[*]} -hold -end 1
set_multicycle_path -from {C122_LPF_freq[*]} -to {LPF_select:Alex_LPF_select|LPF[*]} -setup -end 2
set_multicycle_path -from {C122_LPF_freq[*]} -to {LPF_select:Alex_LPF_select|LPF[*]} -hold -end 1


# set input delays
set_input_delay -clock { PHY_CLK125 } 2 [get_ports {RX_DV}]
set_input_delay -clock { PHY_CLK125 } 2 [get_ports {PHY_RX[*]}]
set_input_delay -clock { PHY_CLK125 } 2 [get_ports {INA[*]}]


# set output delays
set_output_delay -clock { PHY_TX_CLOCK } 2 [get_ports {PHY_TX_CLOCK}]
set_output_delay -clock { PHY_TX_CLOCK } 2 [get_ports {PHY_TX_EN}]
set_output_delay -clock { PHY_TX_CLOCK } 2 [get_ports {PHY_TX[*]}]