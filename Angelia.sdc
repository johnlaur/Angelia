# Angelia.sdc
# 10 April 2014, Joe Martin K5SO


#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3


#**************************************************************
# Create Clock (base clocks, external to the FPGA)
#**************************************************************

create_clock -name PHY_CLK125 		-period 8.000 	[get_ports {PHY_CLK125}]
create_clock -name LTC2208_122MHz 	-period 8.138 	[get_ports {LTC2208_122MHz}]
create_clock -name LTC2208_122MHz_2 	-period 8.138 	[get_ports {LTC2208_122MHz_2}]
create_clock -name OSC_10MHZ 		-period 100.000 [get_ports {OSC_10MHZ}]
create_clock -name _122MHz 		-period 8.138 	[get_ports {_122MHz}]
create_clock -name PHY_RX_CLOCK 	-period 40.000 	[get_ports {PHY_RX_CLOCK}]

# virtual clocks for clocking data into the FPGA using clocks that are external to the FPGA
create_clock -name virt_PHY_CLK125 	-period 8.000
create_clock -name virt_PHY_RX_CLOCK 	-period 40.000
create_clock -name virt_122MHz 		-period 8.138
create_clock -name virt_122MHz_2 	-period 8.138


derive_pll_clocks

derive_clock_uncertainty


#**************************************************************
# Create Generated Clock
#**************************************************************

create_generated_clock -name {Angelia_clk_lrclk_gen:clrgen|BCLK} -source [get_ports {LTC2208_122MHz}] -divide_by 40 [get_registers {Angelia_clk_lrclk_gen:clrgen|BCLK}] 
create_generated_clock -name {spc[2]} -source [get_registers {Angelia_clk_lrclk_gen:clrgen|BCLK}] -divide_by 8 -master_clock {Angelia_clk_lrclk_gen:clrgen|BCLK} [get_registers {spc[2]}] 
create_generated_clock -name {PHY_RX_CLOCK_2} -source [get_ports {PHY_RX_CLOCK}] -divide_by 2 -master_clock {PHY_RX_CLOCK} [get_registers {PHY_RX_CLOCK_2}] 
create_generated_clock -name {Attenuator:Attenuator_ADC1|clk_2} -source [get_pins {PLL_IF_inst|altpll_component|auto_generated|pll1|inclk[0]}] -multiply_by 1 [get_registers {Attenuator:Attenuator_ADC1|clk_2}]
create_generated_clock -name {Attenuator:Attenuator_ADC2|clk_2} -source [get_pins {PLL_IF_inst|altpll_component|auto_generated|pll1|inclk[0]}] -multiply_by 1 [get_registers {Attenuator:Attenuator_ADC2|clk_2}]
create_generated_clock -name sidetone:sidetone_inst|sidetone_clock -source PHY_CLK125 -divide_by 690 sidetone:sidetone_inst|sidetone_clock
create_generated_clock -name pro_count[2] -source [get_pins {PLL_IF_inst|altpll_component|auto_generated|pll1|clk[3]}] -divide_by 8 pro_count[2]


#**************************************************************
# Set Clock Groups
#**************************************************************

set_clock_groups -asynchronous  -group { \
					LTC2208_122MHz \
					LTC2208_122MHz_2 \
					_122MHz \
					PLL_IF_inst|altpll_component|auto_generated|pll1|clk[0] \
					PLL_IF_inst|altpll_component|auto_generated|pll1|clk[1] \
					PLL_IF_inst|altpll_component|auto_generated|pll1|clk[2] \
					Angelia_clk_lrclk_gen:clrgen|BCLK \
					spc[2] \
					Attenuator:Attenuator_ADC1|clk_2 \
					Attenuator:Attenuator_ADC2|clk_2 \
					pro_count[2] \ 
					sidetone:sidetone_inst|sidetone_clock \
				       } \
				-group { \
					PHY_RX_CLOCK \
					PHY_RX_CLOCK_2 \
					PHY_CLK125 \
				       } \
				-group {OSC_10MHZ \
					PLL2_inst|altpll_component|auto_generated|pll1|clk[0] \
				       } \
				-group {EXT_OSC_10MHZ \
					PLL3_inst|altpll_component|auto_generated|pll1|clk[0]}
					


#**************************************************************
# Set Input Delay
#**************************************************************

set_input_delay -add_delay -max -clock virt_PHY_RX_CLOCK 1.000 {PHY_CLK125 PHY_MDIO PHY_RX[*] RX_DV PHY_INT_N ASMI_interface:ASMI_int_inst|ASMI:ASMI_inst|ASMI_altasmi_parallel_cv82:ASMI_altasmi_parallel_cv82_component|cycloneii_asmiblock2~ALTERA_DATA0}
set_input_delay -add_delay -min -clock virt_PHY_RX_CLOCK -1.000 {PHY_CLK125 PHY_MDIO PHY_RX[*] RX_DV PHY_INT_N ASMI_interface:ASMI_int_inst|ASMI:ASMI_inst|ASMI_altasmi_parallel_cv82:ASMI_altasmi_parallel_cv82_component|cycloneii_asmiblock2~ALTERA_DATA0}

set_input_delay -add_delay -max -clock virt_122MHz 1.000 {ADCMISO ANT_TUNE CDOUT INA[*] INA_2[*] IO4 IO5 IO6 IO7 IO8 KEY_DASH KEY_DOT OVERFLOW OVERFLOW_2 PTT SO SPI_SDI MODE2}
set_input_delay -add_delay -min -clock virt_122MHz -1.000 {ADCMISO ANT_TUNE CDOUT INA[*] INA_2[*] IO4 IO5 IO6 IO7 IO8 KEY_DASH KEY_DOT OVERFLOW OVERFLOW_2 PTT SO SPI_SDI MODE2}



#**************************************************************
# Set Output Delay
#**************************************************************

set_output_delay -add_delay -max -clock PHY_CLK125 1.500 {PHY_MDIO PHY_TX[*] PHY_TX_EN PHY_TX_CLOCK PHY_MDC ASMI_interface:ASMI_int_inst|ASMI:ASMI_inst|ASMI_altasmi_parallel_cv82:ASMI_altasmi_parallel_cv82_component|cycloneii_asmiblock2~ALTERA_SCE ASMI_interface:ASMI_int_inst|ASMI:ASMI_inst|ASMI_altasmi_parallel_cv82:ASMI_altasmi_parallel_cv82_component|cycloneii_asmiblock2~ALTERA_SDO ASMI_interface:ASMI_int_inst|ASMI:ASMI_inst|ASMI_altasmi_parallel_cv82:ASMI_altasmi_parallel_cv82_component|cycloneii_asmiblock2~ALTERA_DCLK}
set_output_delay -add_delay -min -clock PHY_CLK125 -0.500 {PHY_MDIO PHY_TX[*] PHY_TX_EN PHY_TX_CLOCK PHY_MDC ASMI_interface:ASMI_int_inst|ASMI:ASMI_inst|ASMI_altasmi_parallel_cv82:ASMI_altasmi_parallel_cv82_component|cycloneii_asmiblock2~ALTERA_SCE ASMI_interface:ASMI_int_inst|ASMI:ASMI_inst|ASMI_altasmi_parallel_cv82:ASMI_altasmi_parallel_cv82_component|cycloneii_asmiblock2~ALTERA_SDO ASMI_interface:ASMI_int_inst|ASMI:ASMI_inst|ASMI_altasmi_parallel_cv82:ASMI_altasmi_parallel_cv82_component|cycloneii_asmiblock2~ALTERA_DCLK}
 
set_output_delay -add_delay -max -clock _122MHz 1.000 [get_ports {ADCCLK ADCMOSI ATTN_CLK ATTN_CLK_2 ATTN_DATA ATTN_DATA_2  ATTN_LE ATTN_LE_2  CBCLK CDIN CLRCIN CLRCOUT CMCLK CS DACD[*] DEBUG_LED* DITH DITH_2 FPGA_PLL FPGA_PTT J15_5 J15_6 MICBIAS_ENABLE MICBIAS_SELECT MIC_SIG_SELECT MOSI NCONFIG PTT_SELECT RAND RAND_2 SCK SI SPI_SCK SPI_SDO SSCK Status_LED USEROUT* nADCCS nCS DAC_ALC}]
set_output_delay -add_delay -min -clock _122MHz -1.000 [get_ports {ADCCLK ADCMOSI ATTN_CLK ATTN_CLK_2 ATTN_DATA ATTN_DATA_2 ATTN_LE ATTN_LE_2 CBCLK CDIN CLRCIN CLRCOUT CMCLK CS DACD[*] DEBUG_LED* DITH DITH_2 FPGA_PLL FPGA_PTT J15_5 J15_6 MICBIAS_ENABLE MICBIAS_SELECT MIC_SIG_SELECT MOSI NCONFIG PTT_SELECT RAND RAND_2 SCK SI SPI_SCK SPI_SDO SSCK Status_LED USEROUT* nADCCS nCS DAC_ALC}]



#**************************************************************************************
# Set Maximum Delay (for setup or recovery; low-level, over-riding timing adjustments)
#**************************************************************************************

set_max_delay -from _122MHz -to _122MHz 15

set_max_delay -from Angelia_clk_lrclk_gen:clrgen|BCLK -to PLL_IF_inst|altpll_component|auto_generated|pll1|clk[0] 17
set_max_delay -from Angelia_clk_lrclk_gen:clrgen|BCLK -to _122MHz 16

set_max_delay -from Attenuator:Attenuator_ADC1|clk_2 -to _122MHz 18
set_max_delay -from Attenuator:Attenuator_ADC1|clk_2 -to PLL_IF_inst|altpll_component|auto_generated|pll1|clk[0] 4

set_max_delay -from Attenuator:Attenuator_ADC2|clk_2 -to _122MHz 14
set_max_delay -from Attenuator:Attenuator_ADC2|clk_2 -to PLL_IF_inst|altpll_component|auto_generated|pll1|clk[0] 4

set_max_delay -from PLL_IF_inst|altpll_component|auto_generated|pll1|clk[0] -to LTC2208_122MHz 48

set_max_delay -from LTC2208_122MHz -to LTC2208_122MHz 16
set_max_delay -from LTC2208_122MHz -to PLL_clocks_inst|altpll_component|auto_generated|pll1|clk[2] 9
set_max_delay -from LTC2208_122MHz -to PLL_IF_inst|altpll_component|auto_generated|pll1|clk[0] 10

set_max_delay -from LTC2208_122MHz_2 -to LTC2208_122MHz 16
set_max_delay -from LTC2208_122MHz_2 -to LTC2208_122MHz_2 11
set_max_delay -from LTC2208_122MHz_2 -to PLL_IF_inst|altpll_component|auto_generated|pll1|clk[0] 8

set_max_delay -from PLL_clocks_inst|altpll_component|auto_generated|pll1|clk[0] -to PHY_CLK125 17
set_max_delay -from PLL_clocks_inst|altpll_component|auto_generated|pll1|clk[0] -to _122MHz 31
set_max_delay -from PLL_clocks_inst|altpll_component|auto_generated|pll1|clk[1] -to _122MHz 28
set_max_delay -from PLL_clocks_inst|altpll_component|auto_generated|pll1|clk[1] -to PHY_CLK125 18

set_max_delay -from PLL_clocks_inst|altpll_component|auto_generated|pll1|clk[1] -to PLL_IF_inst|altpll_component|auto_generated|pll1|clk[0] 13

set_max_delay -from PLL_clocks_inst|altpll_component|auto_generated|pll1|clk[2] -to PLL_IF_inst|altpll_component|auto_generated|pll1|clk[0] 22
set_max_delay -from PLL_clocks_inst|altpll_component|auto_generated|pll1|clk[2] -to PLL_IF_inst|altpll_component|auto_generated|pll1|clk[2] 16

set_max_delay -from PLL_IF_inst|altpll_component|auto_generated|pll1|clk[0] -to Attenuator:Attenuator_ADC1|clk_2 10
set_max_delay -from PLL_IF_inst|altpll_component|auto_generated|pll1|clk[0] -to Attenuator:Attenuator_ADC2|clk_2 3
set_max_delay -from PLL_IF_inst|altpll_component|auto_generated|pll1|clk[0] -to PLL_IF_inst|altpll_component|auto_generated|pll1|clk[1] 7
# was 11
set_max_delay -from PLL_IF_inst|altpll_component|auto_generated|pll1|clk[0] -to PLL_IF_inst|altpll_component|auto_generated|pll1|clk[2] 112
set_max_delay -from PLL_IF_inst|altpll_component|auto_generated|pll1|clk[0] -to _122MHz 17
set_max_delay -from PLL_IF_inst|altpll_component|auto_generated|pll1|clk[0] -to LTC2208_122MHz_2 5
set_max_delay -from PLL_IF_inst|altpll_component|auto_generated|pll1|clk[0] -to pro_count[2] 11
set_max_delay -from PLL_IF_inst|altpll_component|auto_generated|pll1|clk[0] -to PLL_clocks_inst|altpll_component|auto_generated|pll1|clk[2] 10
set_max_delay -from PLL_IF_inst|altpll_component|auto_generated|pll1|clk[0] -to LTC2208_122MHz 50

set_max_delay -from PLL_IF_inst|altpll_component|auto_generated|pll1|clk[2] -to _122MHz 12
# new
set_max_delay -from PLL_IF_inst|altpll_component|auto_generated|pll1|clk[2] -to pro_count[2] 7

set_max_delay -from pro_count[2] -to PLL_IF_inst|altpll_component|auto_generated|pll1|clk[2] 16
set_max_delay -from pro_count[2] -to PLL_IF_inst|altpll_component|auto_generated|pll1|clk[0] 14
set_max_delay -from pro_count[2] -to _122MHz 21
set_max_delay -from pro_count[2] -to sidetone:sidetone_inst|sidetone_clock 12
set_max_delay -from pro_count[2] -to LTC2208_122MHz 14
set_max_delay -from pro_count[2] -to Attenuator:Attenuator_ADC1|clk_2 8
set_max_delay -from pro_count[2] -to Attenuator:Attenuator_ADC2|clk_2 8

set_max_delay -from sidetone:sidetone_inst|sidetone_clock -to LTC2208_122MHz 17

set_max_delay -from spc[2] -to _122MHz 31

set_max_delay -from virt_122MHz -to pro_count[2] 15
set_max_delay -from virt_122MHz -to PLL_IF_inst|altpll_component|auto_generated|pll1|clk[0] 15
set_max_delay -from virt_122MHz -to PLL_clocks_inst|altpll_component|auto_generated|pll1|clk[0] 4
# new
set_max_delay -from virt_122MHz -to PLL_IF_inst|altpll_component|auto_generated|pll1|clk[2] 12
set_max_delay -from virt_122MHz -to _122MHz 13
set_max_delay -from virt_122MHz -to Attenuator:Attenuator_ADC2|clk_2 7
set_max_delay -from virt_122MHz -to Attenuator:Attenuator_ADC1|clk_2 7

set_max_delay -from virt_PHY_RX_CLOCK -to PLL_IF_inst|altpll_component|auto_generated|pll1|clk[0] 11


#************************************************************************************
# Set Minimum Delay (for hold or removal; low-level, over-riding timing adjustments)
#************************************************************************************

set_min_delay -from _122MHz -to _122MHz -2

set_min_delay -from Attenuator:Attenuator_ADC1|clk_2 -to PLL_IF_inst|altpll_component|auto_generated|pll1|clk[0] -2
set_min_delay -from Attenuator:Attenuator_ADC2|clk_2 -to PLL_IF_inst|altpll_component|auto_generated|pll1|clk[0] -2

set_min_delay -from LTC2208_122MHz -to LTC2208_122MHz -2
# was -9
set_min_delay -from LTC2208_122MHz -to spc[2] -10

set_min_delay -from LTC2208_122MHz_2 -to LTC2208_122MHz -2
set_min_delay -from LTC2208_122MHz_2 -to LTC2208_122MHz_2 -2

set_min_delay -from PLL_IF_inst|altpll_component|auto_generated|pll1|clk[0] -to Attenuator:Attenuator_ADC1|clk_2 -3
set_min_delay -from PLL_IF_inst|altpll_component|auto_generated|pll1|clk[0] -to Attenuator:Attenuator_ADC2|clk_2 -5
set_min_delay -from PLL_IF_inst|altpll_component|auto_generated|pll1|clk[0] -to PLL_IF_inst|altpll_component|auto_generated|pll1|clk[1] -2
set_min_delay -from PLL_IF_inst|altpll_component|auto_generated|pll1|clk[0] -to PLL_IF_inst|altpll_component|auto_generated|pll1|clk[2] -5
set_min_delay -from PLL_IF_inst|altpll_component|auto_generated|pll1|clk[0] -to LTC2208_122MHz -5
set_min_delay -from PLL_IF_inst|altpll_component|auto_generated|pll1|clk[0] -to LTC2208_122MHz_2 -6
set_min_delay -from PLL_IF_inst|altpll_component|auto_generated|pll1|clk[0] -to spc[2] -14
set_min_delay -from PLL_IF_inst|altpll_component|auto_generated|pll1|clk[0] -to pro_count[2] -3
set_min_delay -from PLL_IF_inst|altpll_component|auto_generated|pll1|clk[0] -to _122MHz -3

#was -9
set_min_delay -from pro_count[2] -to spc[2] -10

set_min_delay -from sidetone:sidetone_inst|sidetone_clock -to LTC2208_122MHz -6

set_min_delay -from virt_122MHz -to PLL_clocks_inst|altpll_component|auto_generated|pll1|clk[0] -6
set_min_delay -from virt_122MHz -to spc[2] -2

