/***********************************************************
*
*	Angelia
*
************************************************************/


//
//  HPSDR - High Performance Software Defined Radio
//
//  Angelia code. 
//
//  This program is free software; you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation; either version 2 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program; if not, write to the Free Software
//  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

// (C) Phil Harman VK6APH/VK6PH, Kirk Weedman KD7IRS  2006, 2007, 2008, 2009, 2010, 2011, 2012, 2013, 2014, 2015 


/*
	2015 Jun 20 - First release with 4 receivers.  Number of receivers can be set using NR

					
 
		
		

					**** IMPORTANT: Prevent Quartus merging PLLs! *****


	

*/

module Angelia(
	//clock PLL
  input _122MHz,                 //122.88MHz from VCXO
  input  OSC_10MHZ,              //10MHz reference in 
  output FPGA_PLL,               //122.88MHz VCXO contol voltage

  //attenuator (DAT-31-SP+)
  output ATTN_DATA,              //data for input attenuator
  output ATTN_DATA_2,
  output ATTN_CLK,               //clock for input attenuator
  output ATTN_CLK_2, 
  output ATTN_LE,                //Latch enable for input attenuator
  output ATTN_LE_2,

  //rx adc (LTC2208)
  input  [15:0]INA,              //samples from LTC2208
  input  [15:0]INA_2,            //samples from LTC2208 #2
  input  LTC2208_122MHz,         //122.88MHz from LTC2208_122MHz pin 
  input  LTC2208_122MHz_2,       //122.88MHz from #2 LTC2208_122MHz pin 
  input  OVERFLOW,               //high indicates LTC2208 have overflow
  input  OVERFLOW_2,             //high indicates LTC2208 have overflow
  output RAND,            			//high turns ramdom on
  output RAND_2,          			//high turns ramdom on
  output PGA,            			//high turns LTC2208 internal preamp on
  output PGA_2,          			//high turns LTC2208 internal preamp on
  output DITH,            			//high turns LTC2208 dither on 
  output DITH_2,          			//high turns LTC2208 dither on 
  output SHDN,            			//x shuts LTC2208 off
  output SHDN_2,          			//x shuts LTC2208 off

  //tx adc (AD9744ARU)
  output reg  DAC_ALC,          //sets Tx DAC output level
  output reg signed [13:0]DACD,  //Tx DAC data bus
  
  //audio codec (TLV320AIC23B)
  output CBCLK,               
  output CLRCIN, 
  output CLRCOUT,
  output CDIN,                   
  output CMCLK,                  //Master Clock to TLV320 
  output CMODE,                  //sets TLV320 mode - I2C or SPI
  output nCS,                    //chip select on TLV320
  output MOSI,                   //SPI data for TLV320
  output SSCK,                   //SPI clock for TLV320
  input  CDOUT,                  //Mic data from TLV320  
  
  //phy rgmii (KSZ9021RL)
  output [3:0]PHY_TX,
  output PHY_TX_EN,              //PHY Tx enable
  output PHY_TX_CLOCK,           //PHY Tx data clock
  input  [3:0]PHY_RX,     
  input  RX_DV,                 //PHY has data flag
  input  PHY_RX_CLOCK,           //PHY Rx data clock
  input  PHY_CLK125,             //125MHz clock from PHY PLL
  input  PHY_INT_N,              //interrupt (n.c.)
  output PHY_RESET_N,
  input  CLK_25MHZ,              //25MHz clock (n.c.)  
  
	//phy mdio (KSZ9021RL)
	inout  PHY_MDIO,               //data line to PHY MDIO
	output PHY_MDC,                //2.5MHz clock to PHY MDIO
  
	//eeprom (25AA02E48T-I/OT)
	output 	SCK, 							// clock on MAC EEPROM
	output 	SI,							// serial in on MAC EEPROM
	input   	SO, 							// SO on MAC EEPROM
	output  	CS,							// CS on MAC EEPROM
	
  //eeprom (M25P16VMW6G)  
  output NCONFIG,                //when high causes FPGA to reload from eeprom EPCS16	
  
  //12 bit adc's (ADC78H90CIMT)
  output ADCMOSI,                
  output ADCCLK,
  input  ADCMISO,
  output nADCCS, 
 
  //alex/apollo spi
  output SPI_SDO,                //SPI data to Alex or Apollo 
//  input  SPI_SDI,                //SPI data from Apollo 
  output SPI_SCK,                //SPI clock to Alex or Apollo 
  output J15_5,                  //SPI Rx data load strobe to Alex / Apollo enable
  output J15_6,                  //SPI Tx data load strobe to Alex / Apollo ~reset 
  
  //misc. i/o
  input  PTT,                    //PTT active low
  input  KEY_DOT,                //dot input from J11
  input  KEY_DASH,               //dash input from J11
  output FPGA_PTT,               //high turns Q4 on for PTTOUT
  input  MODE2,                  //jumper J13 on Angelia, 1 if removed
  input  ANT_TUNE,               //atu
  output IO1,                    //high to mute AF amp    
  input  IO2,                    //PTT, used by Apollo 
  
  //user digital inputs
  input  IO4,                    
  input  IO5,
  input  IO6,
  input  IO8,
  
  //user outputs
  output USEROUT0,               
  output USEROUT1,
  output USEROUT2,
  output USEROUT3,
  output USEROUT4,
  output USEROUT5,
  output USEROUT6,
  
    //debug led's
  output Status_LED,      
  output DEBUG_LED1,             
  output DEBUG_LED2,
  output DEBUG_LED3,
  output DEBUG_LED4,
  output DEBUG_LED5,
  output DEBUG_LED6,
  output DEBUG_LED7,
  output DEBUG_LED8,
  output DEBUG_LED9,
  output DEBUG_LED10,
  
	// RAM
  output wire RAM_A0,
  output wire RAM_A1,
  output wire RAM_A2,
  output wire RAM_A3,
  output wire RAM_A4,
  output wire RAM_A5,
  output wire RAM_A6,
  output wire RAM_A7,
  output wire RAM_A8,
  output wire RAM_A9,
  output wire RAM_A10,
  output wire RAM_A11,
  output wire RAM_A12,
  output wire RAM_A13  
);

assign USEROUT0 = Open_Collector[1];					
assign USEROUT1 = Open_Collector[2];   				
assign USEROUT2 = Open_Collector[3];  					
assign USEROUT3 = Open_Collector[4];  		
assign USEROUT4 = Open_Collector[5]; 
assign USEROUT5 = Open_Collector[6]; 
assign USEROUT6 = Open_Collector[7]; 

assign RAM_A0  = 0;
assign RAM_A1  = 0;
assign RAM_A2  = 0;
assign RAM_A3  = 0;
assign RAM_A4  = 0;
assign RAM_A5  = 0;
assign RAM_A6  = 0;
assign RAM_A7  = 0;
assign RAM_A8  = 0;
assign RAM_A9  = 0;
assign RAM_A10  = 0;
assign RAM_A11  = 0;
assign RAM_A12  = 0;
assign RAM_A13  = 0;

assign PGA = 0;								// 1 = gain of 3dB, 0 = gain of 0dB
assign PGA_2 = 0;
assign SHDN = 1'b0;				   		// normal LTC2208 operation
assign SHDN_2 = 1'b0;

assign NCONFIG = IP_write_done || reset_FPGA;

wire speed = 1'b1; // high for 1000T
// enable AF Amp
assign  IO1 = 1'b0;  						// low to enable, high to mute

localparam NR = 4; // number of receivers to implement

parameter M_TPD   = 4;
parameter IF_TPD  = 2;

localparam board_type = 8'h03;		  	// 00 for Metis, 01 for Hermes, 02 for Griffin, 03 for Angelia, and 05 for Orion
parameter  Angelia_version = 8'd91;		// FPGA code version

//--------------------------------------------------------------
// Reset Lines - C122_rst, IF_rst, SPI_Alex_reset
//--------------------------------------------------------------

wire  IF_rst;
wire SPI_Alex_rst;
wire C122_rst;
wire SPI_clk;
	
assign IF_rst = (network_state < 4'h8);  // hold IF_clk code in reset until Ethernet code is running.


// transfer IF_rst to 122.88MHz clock domain to generate C122_rst
cdc_sync #(1)
	reset_C122 (.siga(IF_rst), .rstb(0), .clkb(_122MHz), .sigb(C122_rst)); // 122.88MHz clock domain reset
	
cdc_sync #(1)
	reset_Alex (.siga(IF_rst), .rstb(0), .clkb(SPI_clk), .sigb(SPI_Alex_rst));  // SPI_clk domain reset
	
//---------------------------------------------------------
//		CLOCKS
//---------------------------------------------------------

wire C122_clk = LTC2208_122MHz;
wire C122_clk_2 = LTC2208_122MHz_2;
wire CLRCLK;
assign CLRCIN  = CLRCLK;
assign CLRCOUT = CLRCLK;


wire 	IF_locked;
wire C122_cbrise;

// Generate CMCLK (12.288MHz), CBCLK(3.072MHz) and CLRCLK (48kHz) from 122.88MHz using PLL
// NOTE: CBCLK is generated at 180 degress so that LRCLK occurs on negative edge of BCLK 
PLL_IF PLL_IF_inst (.inclk0(_122MHz), .c0(CMCLK), .c1(CBCLK), .c2(CLRCLK),  .c3(), .locked(IF_locked));

pulsegen pulse  (.sig(CBCLK), .rst(IF_rst), .clk(!CMCLK), .pulse(C122_cbrise));  // pulse on rising edge of BCLK for Rx/Tx frequency calculations

//-----------------------------------------------------------------------------
//                           network module
//-----------------------------------------------------------------------------
wire [4:0] network_state;
wire speed_1Gbit;
wire clock_12_5MHz;
wire [7:0] network_status;
wire rx_clock;
wire tx_clock;
wire udp_rx_active;
wire [7:0] udp_rx_data;
wire udp_tx_active;
wire [47:0] local_mac;	
wire broadcast;
wire [15:0] udp_tx_length;
wire [7:0] udp_tx_data;
wire udp_tx_request;
wire udp_tx_enable;
wire set_ip;
wire IP_write_done;	
wire static_ip_assigned;
wire dhcp_timeout;
wire dhcp_success;
wire dhcp_failed;
wire icmp_rx_enable;
	
network network_inst (

	// inputs
  .speed(speed),	
  .udp_tx_request(udp_tx_request),
  .udp_tx_data(udp_tx_data),  
  .set_ip(set_ip),
  .assign_ip(assign_ip),
  .port_ID(port_ID), 
  
  // outputs
  .clock_12_5MHz(clock_12_5MHz),
  .rx_clock(rx_clock),
  .tx_clock(tx_clock),
  .broadcast(broadcast),
  .udp_rx_active(udp_rx_active),
  .udp_rx_data(udp_rx_data),
  .udp_tx_length(udp_tx_length),
  .udp_tx_active(udp_tx_active),
  .local_mac(local_mac),
  .udp_tx_enable(udp_tx_enable), 
  .IP_write_done(IP_write_done),
  .icmp_rx_enable(icmp_rx_enable),   // test for ping bug
  .to_port(to_port),   					// UDP port the PC is sending to

	// status outputs
  .speed_1Gbit(speed_1Gbit),	
  .network_state(network_state),	
  .network_status(network_status),
  .static_ip_assigned(static_ip_assigned),
  .dhcp_timeout(dhcp_timeout),
  .dhcp_success(dhcp_success),
  .dhcp_failed(dhcp_failed),  

  //make hardware pins available inside this module
  .MODE2(1'b1),
  .PHY_TX(PHY_TX),
  .PHY_TX_EN(PHY_TX_EN),            
  .PHY_TX_CLOCK(PHY_TX_CLOCK),         
  .PHY_RX(PHY_RX),     
  .PHY_DV(RX_DV),    					// use PHY_DV to be consistent with Metis            
  .PHY_RX_CLOCK(PHY_RX_CLOCK),         
  .PHY_CLK125(PHY_CLK125),           
  .PHY_INT_N(PHY_INT_N),            
  .PHY_RESET_N(PHY_RESET_N),
  .PHY_MDIO(PHY_MDIO),             
  .PHY_MDC(PHY_MDC),
  .SCK(SCK),                  
  .SI(SI),                   
  .SO(SO), 				
  .CS(CS)
  );


//-----------------------------------------------------------------------------
//                          sdr receive
//-----------------------------------------------------------------------------
wire sending_sync;
wire discovery_reply;
wire pc_send;
wire debug;
wire seq_error;
wire erase_ACK;
wire EPCS_FIFO_enable;
wire erase;	
wire send_more;
wire send_more_ACK;
wire set_up;
wire [31:0] assign_ip;
wire [15:0]to_port;
wire [31:0] PC_seq_number;				// sequence number sent by PC when programming


sdr_receive sdr_receive_inst(
	//inputs 
	.rx_clock(rx_clock),
	.udp_rx_data(udp_rx_data),
	.udp_rx_active(udp_rx_active),
	.sending_sync(sending_sync),
	.broadcast(broadcast),
	.erase_ACK(erase_done_ACK),		// set when erase command acknowledged back to PC
	.EPCS_wrused(EPCS_wrused),
	.local_mac(local_mac),
	.to_port(to_port),
	
	//outputs
	.discovery_reply(discovery_reply),
	.seq_error(seq_error),
	.erase(erase),
	.num_blocks(num_blocks),
	.EPCS_FIFO_enable(EPCS_FIFO_enable),
	.set_ip(set_ip),
	.assign_ip(assign_ip),
	.sequence_number(PC_seq_number)
	);
			        


//-----------------------------------------------------------------------------
//                               sdr rx, tx & IF clock domain transfers
//-----------------------------------------------------------------------------
wire run_sync;
wire wideband_sync;
wire discovery_reply_sync;

// transfer tx clock domain signals to rx clock domain
sync sync_inst1(.clock(rx_clock), .sig_in(udp_tx_active), .sig_out(sending_sync)); 
// transfer rx clock domain signals to tx clock domain  
sync sync_inst5(.clock(tx_clock), .sig_in(discovery_reply), .sig_out(discovery_reply_sync)); 
sync sync_inst6(.clock(tx_clock), .sig_in(run), .sig_out(run_sync)); 
sync sync_inst7(.clock(tx_clock), .sig_in(wideband), .sig_out(wideband_sync));



//-----------------------------------------------------------------------------
//                          sdr send
//-----------------------------------------------------------------------------

wire [7:0] port_ID;
wire [7:0]Mic_data;
wire mic_fifo_rdreq;
wire [7:0]Rx_data[0:NR-1];
wire fifo_ready[0:NR-1];
wire fifo_rdreq[0:NR-1];

sdr_send #(board_type, NR) sdr_send_inst(
	//inputs
	.tx_clock(tx_clock),
	.udp_tx_active(udp_tx_active),
	.discovery(discovery_reply_sync),
	.run(run_sync),
	.wideband(wideband_sync),
	.sp_data_ready(sp_data_ready),
	.sp_fifo_rddata(sp_fifo_rddata),		// **** why the odd name - use spectrum_data ?
	.local_mac(local_mac),
	.code_version(Angelia_version),
	.Rx_data(Rx_data),						// Rx I&Q data to send to PHY
	.udp_tx_enable(udp_tx_enable),
	.erase_done(erase_done | erase),    // send ACK when erase command received and when erase complete
	.send_more(send_more),
	.Mic_data(Mic_data),						// mic data to send to PHY
	.fifo_ready(fifo_ready),				// data available in Rx fifo
	.mic_fifo_ready(mic_fifo_ready),		// data avaiable in mic fifo
	.CC_data_ready(CC_data_ready),      // C&C data availble 
	.CC_data(CC_data),
	.sequence_number(PC_seq_number),		// sequence number to send when programming and requesting more data
	.samples_per_frame(samples_per_frame),
	.tx_length(tx_length),
	
	//outputs
	.udp_tx_data(udp_tx_data),
	.udp_tx_length(udp_tx_length),
	.udp_tx_request(udp_tx_request),
	.fifo_rdreq(fifo_rdreq),				// high to indicate read from Rx fifo required
	.sp_fifo_rdreq	(sp_fifo_rdreq	),		// high to indicate read from spectrum fifo required
	.erase_done_ACK(erase_done_ACK),		
   .send_more_ACK(send_more_ACK),
	.port_ID(port_ID),
	.mic_fifo_rdreq(mic_fifo_rdreq),		// high to indicate read from mic fifo required
	.CC_ack(CC_ack),							// ack to CC_encoder that send request received
	.WB_ack(WB_ack)							// ack to WB controller that send request received					
	 ); 		

//---------------------------------------------------------
// 		Set up TLV320 using SPI 
//---------------------------------------------------------


TLV320_SPI TLV (.clk(CMCLK), .CMODE(CMODE), .nCS(nCS), .MOSI(MOSI), .SSCK(SSCK), .boost(Mic_boost), .line(Line_In), .line_in_gain(Line_In_Gain));

//-------------------------------------------------------------------------
//			Determine number of I&Q samples per frame when in Sync or Mux mode
//-------------------------------------------------------------------------

reg [15:0] samples_per_frame[0:NR-1];
reg [15:0] tx_length[0:NR-1];				// calculate length of Tx packet here rather then do it at high speed in the Ethernet code. 

generate
genvar j;

for (j = 0 ; j < NR; j++)
	begin:q

		always @ (*)
		
		case (SyncRx[j][0] + SyncRx[j][1] + SyncRx[j][2] + SyncRx[j][3] + SyncRx[j][4] + SyncRx[j][5] + SyncRx[j][6] + SyncRx[j][7])

		0,1,6:
			begin 
				samples_per_frame[j] <= 16'd238;  // 1 Rx per frame =  1428/6, 2 = 1428/12, 7 = 1248/42
				tx_length[j] <= 16'd1444;
			end 
		2:	begin 
				samples_per_frame[j] <= 16'd237;  // 3 1422/18
			   tx_length[j] <= 16'd1438;
			end
		3:	begin 
				samples_per_frame[j] <= 16'd236;  // 4 1416/24
				tx_length[j] <= 16'd1432;
			end
		4:	begin
				samples_per_frame[j] <= 16'd235;  // 5 1410/30
				tx_length[j] <= 16'd1426;
			end
		5:	begin 
				samples_per_frame[j] <= 16'd234;  // 6 1404/36
				tx_length[j] <= 16'd1420;
			end 
		7:	begin	
				samples_per_frame[j] <= 16'd232;  // 8 1392/48
				tx_length[j] <= 16'd1408;
			end
		default: begin	
						samples_per_frame[j] <= 16'd238;
						tx_length[j] <= 16'd1444;
					end 
		endcase
	
	end

endgenerate


//------------------------------------------------------------------------
//   Rx(n)_fifo  (2k Bytes) Dual clock FIFO - Altera Megafunction (dcfifo)
//------------------------------------------------------------------------

/*
	  
						   +-------------------+
     Rx(n)_fifo_data	|data[7:0]		wrful| Rx(n)_fifo_full
						   |				        |
	  Rx(n)_fifo_wreq	|wreq		           | 
						   |					     |
		     C122_clk	|>wrclk	wrused[9:0]| 
						   +-------------------+
     fifo_rdreq[n]	|rdreq		  q[7:0]| Rx_data[n]
						   |					     |
	     tx_clock		|>rdclk		        | 
						   |		 rdusedw[10:0]| Rx(n)_used  (0 to 2047 bytes)
						   +-------------------+
						   |                   |
   Rx(n)_fifo_clr OR |aclr               |
	 IF_rst	OR !run	+-------------------+
		
    

*/

wire 			Rx_fifo_wreq[0:NR-1];
wire  [7:0] Rx_fifo_data[0:NR-1];
wire        Rx_fifo_full[0:NR-1];
wire [10:0] Rx_used[0:NR-1];
wire        Rx_fifo_clr[0:NR-1];


generate
genvar d;

for (d = 0 ; d < NR; d++)
	begin:p

		Rx_fifo Rx0_fifo_inst(.wrclk (C122_clk),.rdreq (fifo_rdreq[d]),.rdclk (tx_clock),.wrreq (Rx_fifo_wreq[d]), 
							 .data (Rx_fifo_data[d]), .q (Rx_data[d]), .wrfull(Rx_fifo_full[d]),
							 .rdusedw(Rx_used[d]), .aclr (IF_rst | Rx_fifo_clr[d] | !run ));

		// Convert 48 bit Rx I&Q data (24bit I, 24 bit Q) into 8 bits to feed Tx FIFO. Only run if EnableRx0_7[0] is set.
		// If Sync[n] enabled then select the data from the receiver to be synchronised.
		// Do this by using C122_SyncRx(n) to select the required receiver I & Q data.

		Rx_fifo_ctrl #(NR) Rx0_fifo_ctrl_inst( .reset(!run || !EnableRx0_7[d] ), .clock(C122_clk),
													.spd_rdy(strobe[d]), .fifo_full(Rx_fifo_full[d]), .Rx_number(d),
													.wrenable(Rx_fifo_wreq[d]), .data_out(Rx_fifo_data[d]), .fifo_clear(Rx_fifo_clr[d]),
													.Sync_data_in_I(rx_I), .Sync_data_in_Q(rx_Q), .Sync(C122_SyncRx[d]));
													
		assign  fifo_ready[d] = (Rx_used[d] > 11'd1427) ? 1'b1 : 1'b0;  // used to signal that fifo has enough data to send to PC

	end
endgenerate

											  
//------------------------------------------------------------------------
//   Mic_fifo  (1024 words) Dual clock FIFO - Altera Megafunction (dcfifo)
//------------------------------------------------------------------------

/*
						   +-------------------+
         mic_data 	|data[15:0]	  wrfull| 
						   |				        |
		mic_data_ready	|wrreq		        |
						   |					     |
				 CBCLK	|>wrclk	           | 
						   +-------------------+
   mic_fifo_rdreq		|rdreq		  q[7:0]| Mic_data
						   |					     |
	     tx_clock		|>rdclk		        | 
						   |		 rdusedw[11:0]| mic_rdused* (0 to 2047 bytes)
						   +-------------------+
			            |                   |
	         !run  	|aclr               |
				         +-------------------+
							
		* additional bit added so not zero when full.
		LSByte of input data is output first
	
*/

wire [11:0]	mic_rdused; 
							  
Mic_fifo Mic_fifo_inst(.wrclk (CBCLK),.rdreq (mic_fifo_rdreq),.rdclk (tx_clock),.wrreq (mic_data_ready), 
							  .data (mic_data), .q (Mic_data), .wrfull(),
                       .rdusedw(mic_rdused), .aclr(!run)); 

wire mic_fifo_ready = mic_rdused > 12'd1439 ? 1'b1 : 1'b0;		// used to indicate that fifo has enough data to send to PC.					  
							  
//----------------------------------------------
//		Get mic data from  TLV320 in I2S format 
//---------------------------------------------- 

wire [15:0] mic_data;
wire mic_data_ready;

mic_I2S mic_I2S_inst (.clock(CBCLK), .CLRCLK(CLRCLK), .in(CDOUT), .mic_data(mic_data), .ready(mic_data_ready));

	 
//------------------------------------------------
//   SP_fifo  (16384 words) dual clock FIFO
//------------------------------------------------

/*
        The spectrum data FIFO is 16 by 16384 words long on the input.
        Output is in Bytes for easy interface to the PHY code
        NB: The output flags are only valid after a read/write clock has taken place

       
							   SP_fifo
						+--------------------+
  Wideband_source |data[15:0]	   wrfull| sp_fifo_wrfull
						|				         |
	sp_fifo_wrreq	|wrreq	     wrempty| sp_fifo_wrempty
						|				         |
			C122_clk	|>wrclk              | 
						+--------------------+
	sp_fifo_rdreq	|rdreq		   q[7:0]| sp_fifo_rddata
						|                    | 
						|				         |
		 tx_clock	|>rdclk		         | 
						|		               | 
						+--------------------+
						|                    |
	   !wideband   |aclr                |
		      	   |                    |
	    				+--------------------+
		
*/

wire  sp_fifo_rdreq;
wire [7:0]sp_fifo_rddata;
wire sp_fifo_wrempty;
wire sp_fifo_wrfull;
wire sp_fifo_wrreq;


//-----------------------------------------------------------------------------
//   Wideband Spectrum Data 
//-----------------------------------------------------------------------------

//	When sp_fifo_wrempty fill fifo with 'user selected' # words of consecutive ADC samples.
// Pass sp_data_ready to sdr_send to indicate that data is available.
// Reset fifo when !wideband so the data always starts at a known state.
// The time between fifo fills is set by the user (0-255mS). . The number of  samples sent per UDP frame is set by the user
// (default to 1024) as is the sample size (defaults to 16 bits).
// The number of frames sent, per fifo fill, is set by the user - currently set at 8 i.e. 4,096 samples. 


wire have_sp_data;

wire wideband = (Wideband_enable[0] | Wideband_enable[1]);  							// enable Wideband data if either selected
wire [15:0] Wideband_source = Wideband_enable[0] ? temp_ADC[0] : temp_ADC[1];	// select Wideband data source ADC0 or ADC1

SP_fifo  SPF (.aclr(!wideband), .wrclk (C122_clk), .rdclk(tx_clock), 
             .wrreq (sp_fifo_wrreq), .data (Wideband_source), .rdreq (sp_fifo_rdreq),
             .q(sp_fifo_rddata), .wrfull(sp_fifo_wrfull), .wrempty(sp_fifo_wrempty)); 	
				 
sp_rcv_ctrl SPC (.clk(C122_clk), .reset(0), .sp_fifo_wrempty(sp_fifo_wrempty),
                 .sp_fifo_wrfull(sp_fifo_wrfull), .write(sp_fifo_wrreq), .have_sp_data(have_sp_data));	
				 
// **** TODO: change number of samples in FIFO (presently 16k) based on user selection **** 


// wire [:0] update_rate = 100T ?  12500 : 125000; // **** TODO: need to change counter target when run at 100T.
wire [17:0] update_rate = 125000;

reg  sp_data_ready;
reg [24:0]wb_counter;
wire WB_ack;

always @ (posedge tx_clock)	
begin
	if (wb_counter == (Wideband_update_rate * update_rate)) begin	  // max delay 255mS
		wb_counter <= 25'd0;
		if (have_sp_data & wideband) sp_data_ready <= 1'b1;	  
	end
	else begin 
			wb_counter <= wb_counter + 25'd1;
			if (WB_ack) sp_data_ready <= 0;  // wait for confirmation that request has been seen
	end
end	


//----------------------------------------------------
//   					Rx_Audio_fifo
//----------------------------------------------------

/*
							  Rx_Audio_fifo (4k) 
							
								+--------------------+
				 audio_data |data[31:0]	  wrfull | Audio_full
								|				         |
	Rx_Audio_fifo_wrreq	|wrreq				   |
								|					      |									    
				 rx_clock	|>wrclk	 		      |
								+--------------------+								
	  get_audio_samples  |rdreq		  q[31:0]| LR_data 
								|					      |					  			
								|   		            | 
								|            rdempty | Audio_empty 							
				    CBCLK	|>rdclk              |    
								+--------------------+								
								|                    |
		  !run OR IF_rst  |aclr                |								
								+--------------------+	
								
	Only request audio samples if fifo not empty 						
*/

wire Rx_Audio_fifo_wrreq;
wire  [31:0] temp_LR_data;
wire  [31:0] LR_data;
wire get_audio_samples;  // request audio samples at 48ksps
wire Audio_full;
wire Audio_empty;
wire get_samples;
wire [31:0]audio_data;

Rx_Audio_fifo Rx_Audio_fifo_inst(.wrclk (rx_clock),.rdreq (get_audio_samples),.rdclk (CBCLK),.wrreq(Rx_Audio_fifo_wrreq), 
				   .data (audio_data),.q (LR_data),	.aclr(IF_rst | !run), .wrfull(Audio_full), .rdempty(Audio_empty));
					 
// Manage Rx Audio data to feed to Audio FIFO  - parameter is port #
byte_to_32bits #(1028) Audio_byte_to_32bits_inst
			(.clock(rx_clock), .run(run), .udp_rx_active(udp_rx_active), .udp_rx_data(udp_rx_data), .to_port(to_port),
			 .fifo_wrreq(Rx_Audio_fifo_wrreq), .data_out(audio_data), .sequence_error(), .full(Audio_full));
			
// select sidetone when CW key active and sidetone_level is not zero else Rx audio.
wire [31:0] Rx_audio = CW_PTT && (sidetone_level != 0) ? {prof_sidetone, prof_sidetone}  : LR_data; 													 
													 
// send receiver audio to TLV320 in I2S format
audio_I2S audio_I2S_inst (.BCLK(CBCLK), .empty(Audio_empty), .LRCLK(CLRCLK), .data_in(Rx_audio), .data_out(CDIN), .get_data(get_audio_samples)); 


//----------------------------------------------------
//   					Tx1_IQ_fifo
//----------------------------------------------------

/*
							   Tx1_IQ_fifo (4k) 
							
								+--------------------+
			 Tx1_IQ_data   |data[47:0]	         | 
								|				         |
			Tx1_fifo_wrreq |wrreq				   |
								|					      |									    
				 rx_clock	|>wrclk	 		      |
								+--------------------+								
	               req1  |rdreq		  q[47:0]| C122_IQ1_data
								|					      |					  			
								|   		            | 
								|                    | 							
				  _122MHz	|>rdclk              | 	    
								+--------------------+								
								|                    |
		  !run | IF_rst   |aclr                |								
								+--------------------+	
								
*/

wire Tx1_fifo_wrreq;
wire [47:0]C122_IQ1_data;
wire [47:0]Tx1_IQ_data;

Tx1_IQ_fifo Tx1_IQ_fifo_inst(.wrclk (rx_clock),.rdreq (req1),.rdclk (_122MHz),.wrreq(Tx1_fifo_wrreq), 
					 .data (Tx1_IQ_data), .q(C122_IQ1_data), .aclr(!run | IF_rst));
					 
// Manage Tx I&Q data to feed to Tx  - parameter is port #
byte_to_48bits #(1029) IQ_byte_to_48bits_inst
			(.clock(rx_clock), .run(run), .udp_rx_active(udp_rx_active), .udp_rx_data(udp_rx_data), .to_port(to_port),
			 .fifo_wrreq(Tx1_fifo_wrreq), .data_out(Tx1_IQ_data), .sequence_error());					 

// Ensure I&Q data is zero if not trasmitting
wire [47:0] IQ_Tx_data = FPGA_PTT ? C122_IQ1_data : 48'b0; 													
													
//--------------------------------------------------------------------------
//			EPCS16 Erase and Program code 
//--------------------------------------------------------------------------

/*
					    EPCS_fifo (1k bytes) 
					
					    +-------------------+
	  udp_rx_data   |data[7:0]	         | 
					    |				         |
 EPCS_FIFO_enable  |wrreq		         | 
					    |					      |									    
	    rx_clock	 |>wrclk wrusedw[9:0]| EPCS_wrused
					    +-------------------+								
	   EPCS_rdreq   |rdreq		  q[7:0] | EPCS_data
					    |					      |					  			
			     	    |   		            |  
			          |                   | 							
     clock_12_5MHz |>rdclk rdusedw[9:0]| EPCS_Rx_used	    
					    +-------------------+								
					    |                   |
			  IF_rst  |aclr               |								
					    +-------------------+						
*/

wire [7:0]EPCS_data;
wire [9:0]EPCS_Rx_used;
wire  EPCS_rdreq;
wire [31:0] num_blocks;  
wire EPCS_full;
wire [9:0] EPCS_wrused;


EPCS_fifo EPCS_fifo_inst(.wrclk (rx_clock),.rdreq (EPCS_rdreq),.rdclk (clock_12_5MHz),.wrreq(EPCS_FIFO_enable),  
                .data (udp_rx_data),.q (EPCS_data), .rdusedw(EPCS_Rx_used), .aclr(IF_rst), .wrusedw(EPCS_wrused));

//----------------------------
// 			ASMI Interface
//----------------------------
wire busy;				 // drives LED
wire erase_done;
wire erase_done_ACK;
wire reset_FPGA;

ASMI_interface  ASMI_int_inst(.clock(clock_12_5MHz), .busy(busy), .erase(erase), .erase_ACK(erase_ACK), .IF_PHY_data(EPCS_data), 
							 .IF_Rx_used(EPCS_Rx_used), .rdreq(EPCS_rdreq), .erase_done(erase_done), .num_blocks(num_blocks),
							 .send_more(send_more), .send_more_ACK(send_more_ACK), .erase_done_ACK(erase_done_ACK), .NCONFIG(reset_FPGA)); 
							 
//--------------------------------------------------------------------------------------------
//  	Iambic CW Keyer
//--------------------------------------------------------------------------------------------

wire keyout;

// parameter is clock speed in kHz.
iambic #(48) iambic_inst (.clock(CLRCLK), .cw_speed(keyer_speed),  .iambic(iambic), .keyer_mode(keyer_mode), .weight(keyer_weight), 
                          .letter_space(keyer_spacing), .dot_key(!KEY_DOT | Dot), .dash_key(!KEY_DASH | Dash),
								  .CWX(CWX), .paddle_swap(key_reverse), .keyer_out(keyout));
						  
//--------------------------------------------------------------------------------------------
//  	Calculate  Raised Cosine profile for sidetone and CW envelope when internal CW selected 
//--------------------------------------------------------------------------------------------

wire CW_char;
assign CW_char = (keyout & internal_CW & run);		// set if running, internal_CW is enabled and either CW key is active
wire [15:0] CW_RF;
wire [15:0] profile;
wire CW_PTT;

profile profile_sidetone (.clock(CLRCLK), .CW_char(CW_char), .profile(profile),  .delay(8'd0));
profile profile_CW       (.clock(CLRCLK), .CW_char(CW_char), .profile(CW_RF),    .delay(RF_delay), .hang(hang), .PTT(CW_PTT));

//--------------------------------------------------------
//			Generate CW sidetone with raised cosine profile
//--------------------------------------------------------	
wire signed [15:0] prof_sidetone;
sidetone sidetone_inst( .clock(CLRCLK), .enable(sidetone), .tone_freq(tone_freq), .sidetone_level(sidetone_level), .CW_PTT(CW_PTT),
                        .prof_sidetone(prof_sidetone),  .profile(profile));	
				
				
//-------------------------------------------------------
//		De-ramdomizer
//--------------------------------------------------------- 

/*

 A Digital Output Randomizer is fitted to the LTC2208. This complements bits 15 to 1 if 
 bit 0 is 1. This helps to reduce any pickup by the A/D input of the digital outputs. 
 We need to de-ramdomize the LTC2208 data if this is turned on. 
 
*/

reg [15:0]temp_ADC[0:1];
reg [15:0] temp_DACD; // for pre-distortion Tx tests

always @ (posedge C122_clk) 
begin 
	 temp_DACD <= {DACD, 2'b00}; // make DACD 16-bits, use high bits for DACD
   if (RAND) begin	// RAND set so de-ramdomize
		if (INA[0]) temp_ADC[0] <= {~INA[15:1],INA[0]};
		else temp_ADC[0] <= INA;
	end
   else temp_ADC[0] <= INA;  // not set so just copy data	 
		
	if (RAND_2) begin
		if (INA_2[0]) temp_ADC[1] <= {~INA_2[15:1], INA_2[0]};
		else temp_ADC[1] <= INA_2;	
	end
	else temp_ADC[1] <= INA_2;
	
end 



//---------------------------------------------------------
//		Convert frequency to phase word 
//---------------------------------------------------------

/*	
     Calculates  ratio = fo/fs = frequency/122.88Mhz where frequency is in MHz
	 Each calculation should take no more than 1 CBCLK

	 B scalar multiplication will be used to do the F/122.88Mhz function
	 where: F * C = R
	 0 <= F <= 65,000,000 hz
	 C = 1/122,880,000 hz
	 0 <= R < 1

	 This method will use a 32 bit by 32 bit multiply to obtain the answer as follows:
	 1. F will never be larger than 65,000,000 and it takes 26 bits to hold this value. This will
		be a B0 number since we dont need more resolution than 1 Hz - i.e. fractions of a hertz.
	 2. C is a constant.  Notice that the largest value we could multiply this constant by is B26
		and have a signed value less than 1.  Multiplying again by B31 would give us the biggest
		signed value we could hold in a 32 bit number.  Therefore we multiply by B57 (26+31).
		This gives a value of M2 = 1,172,812,403 (B57/122880000)
	 3. Now if we multiply the B0 number by the B57 number (M2) we get a result that is a B57 number.
		This is the result of the desire single 32 bit by 32 bit multiply.  Now if we want a scaled
		32 bit signed number that has a range -1 <= R < 1, then we want a B31 number.  Thus we shift
		the 64 bit result right 32 bits (B57 -> B31) or merely select the appropriate bits of the
		64 bit result. Sweet!  However since R is always >= 0 we will use an unsigned B32 result
*/

//------------------------------------------------------------------------------
//                 All DSP code is in the Receiver module
//------------------------------------------------------------------------------

wire       [31:0] C122_frequency_HZ [0:NR-1];   // frequency control bits for CORDIC
reg       [31:0] C122_frequency_HZ_Tx;
reg       [31:0] C122_last_freq [0:NR-1];
reg       [31:0] C122_last_freq_Tx;
reg       [31:0] C122_sync_phase_word [0:NR-1];
reg       [31:0] C122_sync_phase_word_Tx;
wire      [63:0] C122_ratio [0:NR-1];
wire      [63:0] C122_ratio_Tx;
wire      [23:0] rx_I [0:NR-1];
wire      [23:0] rx_Q [0:NR-1];
wire             strobe [0:NR-1];
wire      [15:0] C122_SampleRate[0:NR-1]; 
wire       [7:0] C122_RxADC[0:NR-1];
wire       [7:0] C122_SyncRx[0:NR-1];
wire      [31:0] C122_phase_word[0:NR-1]; 
wire [15:0] select_input_RX[0:NR-1];		// set receiver module input sources
reg 		 			frequency_change[0:NR-1];  // bit set when frequency of Rx[n] changes

localparam M2 = 32'd1172812403;  // B57 = 2^57.   M2 = B57/122880000
localparam M3 = 32'd16777216; 	// used in the phase word calc to properly round the result 

generate
  genvar c;
  for (c = 0; c < NR; c++) // calc freq phase word for NR freqs 
   begin: MDC 
	
	// move Rx_frequency[c]  into C122 clock domain - NOTE: not using strobe version of cdc_sync
	cdc_sync #(32) Rx_freq 
	(.siga(Rx_frequency[c]), .rstb(C122_rst), .clkb(C122_clk), .sigb(C122_frequency_HZ[c]));

   // Note: We add 1/2 M2 (M3) so that we end up with a rounded 32 bit integer below.
    assign C122_ratio[c] = C122_frequency_HZ[c] * M2 + M3; // B0 * B57 number = B57 number 

    always @ (posedge C122_clk) 
    begin
      if (C122_cbrise) // time between C122_cbrise is enough for ratio calculation to settle
      begin
		  C122_last_freq[c] <= C122_frequency_HZ[c];
        if (C122_last_freq[c] != C122_frequency_HZ[c]) begin    // frequency changed)
          C122_sync_phase_word[c] <= C122_ratio[c][56:25]; // B57 -> B32 number since R is always >= 0 
			 frequency_change[c] <= 1'b1;
		  end 
		  else frequency_change[c] <= 0;
      end	
    end

//assign phase word for Rx1 depending upon whether common_Merc_freq is asserted
//assign Rx1_phase_word = common_Merc_freq ? C122_sync_phase_word[0] : C122_sync_phase_word[1];

	// Move RxADC[n] to C122 clock domain
	cdc_sync_strobe #(16) ADC_select
	(.siga(RxADC[c]), .rstb(C122_rst), .strobe(Rx_data_ready), .clkb(C122_clk), .sigb(C122_RxADC[c])); 

	// Select Rx(c) input, either ADC(c) or DAC 
	assign select_input_RX[c] = C122_RxADC[c] == 8'd2 ? temp_DACD : (C122_RxADC[c] == 8'd1 ? temp_ADC[1] : temp_ADC[0]); 
	
	// Move Rx[n] sample rate to C122 clock domain
	cdc_sync_strobe #(16) S_rate
	(.siga(RxSampleRate[c]), .rstb(C122_rst), .strobe(Rx_data_ready), .clkb(C122_clk), .sigb(C122_SampleRate[c])); 

	receiver2 receiver_inst(   
	//control
	.clock(C122_clk),
	.sample_rate(C122_SampleRate[c]),
	//.frequency(C122_sync_phase_word[c]), 
	.frequency(C122_phase_word[c]), 
	.out_strobe(strobe[c]),
	//input
	.in_data(select_input_RX[c]),
	//output
	.out_data_I(rx_I[c]),
	.out_data_Q(rx_Q[c])
	);
	
	// Move SyncRx[n] into C122 clock domain
	cdc_sync_strobe #(8) SyncRx_inst
	(.siga(SyncRx[c]), .rstb(C122_rst), .strobe(Rx_data_ready), .clkb(C122_clk), .sigb(C122_SyncRx[c])); 	
	
  end
endgenerate
				


/*  
	Synchronous and Multiplexed  Receivers
	
	NOTE: The sampling rate of all Synchronous or Multiplexed receivers must be the same 
	and is the responsibility of the PC Control program to ensure this.  
	
	Receivers that are connected to a base receiver, either Synchronised or Multiplexed, are 
	usually disabled so they are not also sent from an Ethernet port. It is the responsibility
	of the PC Control program to ensure this.
	
	The selection code will allow unsuitable or unnecessary receiver combinations e.g. 
	Rx0 + Rx0 or  Rx0 + Rx1 and Rx1 + Rx0. It is the responsibility of the PC Control program
	to prevent this.
	
	There is no special provision for PureSignal operation.  For PureSignal use, the PC Control program is responsible
	for setting the sampling rates, selecting DAC data as the source for one receiver and selecting 
	either Synchronous or Multiplex operation of the RF and DAC receivers. 
	
	Synchronous Receivers: (where a number of receivers each use the same phase word)

	The maximum number of synchronised receivers is equal to the number of ADCs.	
	
	The receiver frequencies are received in Rx_frequency[n] and then moved into the C122
	clock domain as C122_frequency_HZ[n].
	
	This is then converted to a phase word,  as C122_sync_phase_word[n],  and passed to each 
	receiver as C122_phase_word[n].
	
	For synchronous receivers, if [7:0]C122_SyncRx[n] is > 0 then Rx[n] is synchronised 
	with another receiver(s). The bit(s) set indicate which receiver(s) are synchronised
	e.g. bit[0] = Rx0, bit[1] = Rx1........bit[7] = Rx7.
	
	All receivers phase words will be set to the phase word of the base receiver.
	
	If [7:0]C122_SyncRx[n] is = 0 then there are no synchronous	receivers and 
	C122_phase_word[n] = C122_sync_phase_word[n].
	
	Multiplexed Receivers: (where a number of receivers are multiplexed over the one Ethernet port
	and may or may not be at a common frequency)
	
	The maximum number of Multiplexed receivers is equal to the number of receivers. 
	
	For multiplexed receivers if Mux bit n is set then Rx(n) is multiplexed 
	with another receiver(s). C122_SyncRx[n] bits [7:0] when set indicate which receiver(s) are multiplexed 
	together e.g. bit[0] = Rx0, bit[1] = Rx1........bit[7] = Rx7.

*/

reg [$clog2(NR):0] f,g;

always @ (posedge C122_clk) 
	begin 
	
		// Check if Mux[n] set, if so then set  receiver to its  selected phase word.
		// else check if receiver is synced to another and set phase word
		// else set is selected phase word.
		
		for (g = 0; g < NR; g++) begin:b
		
			begin 
				for (f = 0; f < NR; f++) begin: a 
					if (C122_SyncRx[g][f] && !C122_Mux[g]) C122_phase_word[f] <= C122_sync_phase_word[g];	// bit test.
					else C122_phase_word[g] <= C122_sync_phase_word[g];
				end
			end
		 end 
		
	end

// calc frequency phase word for Tx
// assign C122_ratio_Tx = C122_frequency_HZ_Tx * M2 +M3;
// Note: We add 1/2 M2 (M3) so that we end up with a rounded 32 bit integer below.
assign C122_ratio_Tx = C122_frequency_HZ_Tx * M2 + M3; 

always @ (posedge _122MHz)
begin
  if (C122_cbrise)
  begin
    C122_last_freq_Tx <= C122_frequency_HZ_Tx;
	 if (C122_last_freq_Tx != C122_frequency_HZ_Tx)
	  C122_sync_phase_word_Tx <= C122_ratio_Tx[56:25];
  end
end



//---------------------------------------------------------
//    ADC SPI interface 
//---------------------------------------------------------

wire [11:0] AIN1;  // FWD_power
wire [11:0] AIN2;  // REV_power
wire [11:0] AIN3;  // User 1
wire [11:0] AIN4;  // User 2
wire [11:0] AIN5;  // holds 12 bit ADC value of Forward Voltage detector.
wire [11:0] AIN6;  // holds 12 bit ADC of 13.8v measurement 

Angelia_ADC ADC_SPI(.clock(CBCLK), .SCLK(ADCCLK), .nCS(nADCCS), .MISO(ADCMISO), .MOSI(ADCMOSI),
				   .AIN1(AIN1), .AIN2(AIN2), .AIN3(AIN3), .AIN4(AIN4), .AIN5(AIN5), .AIN6(AIN6));	
				   

wire Alex_SPI_SDO;
wire Alex_SPI_SCK;
wire SPI_TX_LOAD;
wire SPI_RX_LOAD;

assign SPI_SDO = Alex_SPI_SDO;		// select which module has control of data
assign SPI_SCK = Alex_SPI_SCK;		// and clock for serial data transfer
assign J15_5   = SPI_RX_LOAD;			// Alex Rx_load or Apollo Reset
assign J15_6   = SPI_TX_LOAD;      // Alex Tx_load or Apollo Enable 


	
				   
//---------------------------------------------------------
//                 Transmitter code 
//---------------------------------------------------------	

//---------------------------------------------------------
//  Interpolate by 640 CIC filter
//---------------------------------------------------------

//For interpolation, the growth in word size is  Celi(log2(R^(M-1))
//so for 5 stages and R = 640  = log2(640^4) = 37.28 so use 38

wire req1;
//wire [19:0] y1_r, y1_i; 
wire [15:0] y2_r, y2_i;

CicInterpM5 #(.RRRR(640), .IBITS(24), .OBITS(16), .GBITS(38)) in2 ( _122MHz, 1'd1, req1, IQ_Tx_data[47:24], IQ_Tx_data[23:0], y2_r, y2_i);

	
//------------------------------------------------------
//    CORDIC NCO 
//---------------------------------------------------------

// Code rotates input at set frequency and produces I & Q 


wire signed [14:0] C122_cordic_i_out; 
wire signed [31:0] C122_phase_word_Tx;

wire signed [15:0] I;
wire signed [15:0] Q;

// if in VNA mode use the Rx[0] phase word for the Tx
assign C122_phase_word_Tx = VNA ? C122_sync_phase_word[0] : C122_sync_phase_word_Tx;
assign                  I =  VNA ? 16'd19274 : (CW_PTT ? CW_RF : y2_i);   	// select VNA or CW mode if active. Set CORDIC for max DAC output
assign                  Q = (VNA | CW_PTT)  ? 16'd0 : y2_r; 					// taking into account CORDICs gain i.e. 0x7FFF/1.7


// NOTE:  I and Q inputs reversed to give correct sideband out 

cpl_cordic #(.OUT_WIDTH(16))
 		cordic_inst (.clock(_122MHz), .frequency(C122_phase_word_Tx), .in_data_I(I),			
		.in_data_Q(Q), .out_data_I(C122_cordic_i_out), .out_data_Q());		
			 	 
/* 
  We can use either the I or Q output from the CORDIC directly to drive the DAC.

    exp(jw) = cos(w) + j sin(w)

  When multplying two complex sinusoids f1 and f2, you get only f1 + f2, no
  difference frequency.

      Z = exp(j*f1) * exp(j*f2) = exp(j*(f1+f2))
        = cos(f1 + f2) + j sin(f1 + f2)
*/

// the CORDIC output is stable on the negative edge of the clock

always @ (negedge _122MHz)
	DACD <= C122_cordic_i_out[13:0];   //gain of 4


//------------------------------------------------------------
//  Set Power Output 
//------------------------------------------------------------

// PWM DAC to set drive current to DAC. PWM_count increments 
// using rx_clock. If the count is less than the drive 
// level set by the PC then DAC_ALC will be high, otherwise low.  

reg [7:0] PWM_count;
always @ (posedge rx_clock)
begin 
	PWM_count <= PWM_count + 1'b1;
	if (Drive_Level >= PWM_count)
		DAC_ALC <= 1'b1;
	else 
		DAC_ALC <= 1'b0;
end 


//---------------------------------------------------------
//              Decode Command & Control data
//---------------------------------------------------------

wire         mode;     			// normal or Class E PA operation 
wire         Attenuator;		// selects input attenuator setting, 1 = 20dB, 0 = 0dB 
wire  [31:0] frequency[0:NR-1]; 	// Tx, Rx1, Rx2, Rx3, Rx4, Rx5, Rx6, Rx7
wire         IF_duplex;
wire   [7:0] Drive_Level; 		// Tx drive level
wire         Mic_boost;			// Mic boost 0 = 0dB, 1 = 20dB
wire         Line_In;				// Selects input, mic = 0, line = 1
wire			 common_Merc_freq;		// when set forces Rx2 freq to Rx1 freq
wire   [4:0] Line_In_Gain;		// Sets Line-In Gain value (00000=-32.4 dB to 11111=+12 dB in 1.5 dB steps)
wire         Apollo;				// Selects Alex (0) or Apollo (1)
wire   [4:0] Attenuator0;			// 0-31 dB Heremes attenuator value
wire			 TR_relay_disable;		// Alex T/R relay disable option
wire	 [4:0] Attenuator1;		// attenuation setting for input attenuator 2 (input atten for ADC2), 0-31 dB
wire         internal_CW;			// set when internal CW generation selected
wire   [7:0] sidetone_level;		// 0 - 100, sets internal sidetone level
wire 			 sidetone;				// Sidetone enable, 0 = off, 1 = on
wire   [7:0] RF_delay;				// 0 - 255, sets delay in mS from CW Key activation to RF out
wire   [9:0] hang;					// 0 - 1000, sets delay in mS from release of CW Key to dropping of PTT
wire  [11:0] tone_freq;				// 200 to 1000 Hz, sets sidetone frequency.
wire         key_reverse;		   // reverse CW keyes if set
wire   [5:0] keyer_speed; 			// CW keyer speed 0-60 WPM
wire         keyer_mode;			// 0 = Mode A, 1 = Mode B
wire 			 iambic;					// 0 = external/straight/bug  1 = iambic
wire   [7:0] keyer_weight;			// keyer weight 33-66
wire         keyer_spacing;		// 0 = off, 1 = on
wire   [4:0] atten0_on_Tx;			// ADC0 attenuation value to use when Tx is active
wire   [4:0] atten1_on_Tx;			// ADC1 attenuation value to use when Tx is active
wire  [31:0] Rx_frequency[0:NR-1];	// Rx(n) receive frequency
wire  [31:0] Tx0_frequency;		// Tx0 transmit frequency
wire  [31:0] Alex_data;				// control data to Alex board
wire         run;						// set when run active 
wire 		    PC_PTT;					// set when PTT from PC active
wire 	 [7:0] dither;					// Dither for ADC0[0], ADC1[1]...etc
wire   [7:0] random;					// Random for ADC0[0], ADC1[1]...etc
wire   [7:0] RxADC[0:NR-1];			// ADC or DAC that Rx(n) is connected to
wire 	[15:0] RxSampleRate[0:NR-1];	// Rxn Sample rate 48/96/192 etc
wire 			 Alex_data_ready;		// indicates Alex data available
wire         Rx_data_ready;		// indicates Rx_specific data available
wire   [7:0] Mux;						// Rx in mux mode when bit set, [0] = Rx0, [1] = Rx1 etc 
wire   [7:0] SyncRx[0:NR-1];			// bit set selects Rx to sync or mux with
wire 	 [7:0] EnableRx0_7;			// Rx enabled when bit set, [0] = Rx0, [1] = Rx1 etc
wire  [15:0] Rx_Specific_port;	// 
wire  [15:0] Tx_Specific_port;
wire  [15:0] High_Prioirty_from_PC_port;
wire  [15:0] High_Prioirty_to_PC_port;			
wire  [15:0] Rx_Audio_port;
wire  [15:0] Tx_IQ_port;
wire  [15:0] Rx0_port;
wire  [15:0] Mic_port;
wire  [15:0] Wideband_ADC0_port;
wire   [7:0] Wideband_enable;					// [0] set enables ADC0, [1] set enables ADC1
wire  [15:0] Wideband_samples_per_packet;				
wire   [7:0] Wideband_sample_size;
wire   [7:0] Wideband_update_rate;
wire  [15:0] Envelope_PWM_max;
wire  [15:0] Envelope_PWM_min;
wire   [7:0] Open_Collector;
wire   [7:0] User_Outputs;
wire   [7:0] Mercury_Attenuator;	
wire 			 CWX;						// CW keyboard from PC 
wire         Dot;						// CW dot key from PC
wire         Dash;					// CW dash key from PC]
wire freq_data_ready;


//wire         Time_stamp;
//wire         VITA_49;				
wire         VNA;									// Selects VNA mode when set. 
//wire   [7:0] Atlas_bus;
//wire     [7:0] _10MHz_reference,
wire         PA_enable;
//wire         Apollo_enable;	
wire   [7:0] Alex_enable;			
wire         data_ready;	


General_CC #(1024) General_CC_inst // parameter is port number  ***** this data is in rx_clock domain *****
			(
				// inputs
				.clock(rx_clock),
				.to_port(to_port),
				.udp_rx_active(udp_rx_active),
				.udp_rx_data(udp_rx_data),
				// outputs
			   .Rx_Specific_port(Rx_Specific_port),
				.Tx_Specific_port(Tx_Specific_port),
				.High_Prioirty_from_PC_port(High_Prioirty_from_PC_port),
				.High_Prioirty_to_PC_port(High_Prioirty_to_PC_port),			
				.Rx_Audio_port(Rx_Audio_port),
				.Tx_IQ_port(Tx_IQ_port),
				.Rx0_port(Rx0_port),
				.Mic_port(Mic_port),
				.Wideband_ADC0_port(Wideband_ADC0_port),
				.Wideband_enable(Wideband_enable),
				.Wideband_samples_per_packet(Wideband_samples_per_packet),				
				.Wideband_sample_size(Wideband_sample_size),
				.Wideband_update_rate(Wideband_update_rate),
			//	.Envelope_PWM_max(Envelope_PWM_max),
			//	.Envelope_PWM_min(Envelope_PWM_min),
			//	.Time_stamp(Time_stamp),
			//	.VITA_49(VITA_49),				
				.VNA(VNA),
				//.Atlas_bus(),
				//._10MHz_reference(),
				.PA_enable(PA_enable),
			//	.Apollo_enable(Apollo_enable),	
				.Alex_enable(Alex_enable),			
				.data_ready(data_ready)					
				);



High_Priority_CC #(1027, NR) High_Priority_CC_inst  // parameter is port number 1027  ***** this data is in rx_clock domain *****
			(
				// inputs
				.clock(rx_clock),
				.to_port(to_port),
				.udp_rx_active(udp_rx_active),
				.udp_rx_data(udp_rx_data),
				// outputs
			   .run(run),
				.PC_PTT(PC_PTT),
				.CWX(CWX),
				.Dot(Dot),
				.Dash(Dash),
				.Rx_frequency(Rx_frequency),
				.Tx0_frequency(Tx0_frequency),
				.Alex_data(Alex_data),
				.drive_level(Drive_Level),
				.Attenuator0(Attenuator0),
				.Attenuator1(Attenuator1),
				.Open_Collector(Open_Collector),			// open collector outputs on Angelia
			//	.User_Outputs(),
			//	.Mercury_Attenuator(),	
				.Alex_data_ready(Alex_data_ready)
			);

assign FPGA_PTT = (PC_PTT | CW_PTT | debounce_PTT); // CW_PTT is used when internal CW is selected

Tx_specific_CC #(1026)Tx_specific_CC_inst //   // parameter is port number  ***** this data is in rx_clock domain *****
			( 	
				// inputs
				.clock (rx_clock),
				.to_port (to_port),
				.udp_rx_active (udp_rx_active),
				.udp_rx_data (udp_rx_data),
				// outputs
				.EER() ,
				.internal_CW (internal_CW),
				.key_reverse (key_reverse), 
				.iambic (iambic),					
				.sidetone (sidetone), 			
				.keyer_mode (keyer_mode), 		
				.keyer_spacing(keyer_spacing),
				.break_in(), 						
				.sidetone_level(sidetone_level), 
				.tone_freq(tone_freq), 
				.keyer_speed(keyer_speed),	
				.keyer_weight(keyer_weight),
				.hang(hang), 
				.RF_delay(RF_delay),
				.Line_In(Line_In),
				.Line_In_Gain(Line_In_Gain),
				.Mic_boost(Mic_boost),
				.Angelia_atten_Tx1(atten1_on_Tx),
				.Angelia_atten_Tx0(atten0_on_Tx)	

			);

			
Rx_specific_CC #(1025, NR) Rx_specific_CC_inst // parameter is port number  *** not all data is in correct clock domain
			( 	
				// inputs
				.clock(rx_clock),
				.to_port(to_port),
				.udp_rx_active(udp_rx_active),
				.udp_rx_data(udp_rx_data),
				// outputs
				.dither(dither),
				.random(random),
				.RxSampleRate(RxSampleRate),
				.RxADC(RxADC),	
				.SyncRx(SyncRx),
				.EnableRx0_7(EnableRx0_7),
				.Rx_data_ready(Rx_data_ready),
				.Mux(Mux)
			);			
			
assign  RAND   = random[0];        		//high turns random on
assign  RAND_2 = random[1]; 
assign  DITH   = dither[0];      		//high turns LTC2208 dither on 
assign  DITH_2 = dither[1]; 		

// transfer C&C data in rx_clock domain, on strobe, into relevant clock domains
cdc_sync_strobe #(32) Tx1_freq 
 (.siga(Tx0_frequency), .rstb(C122_rst), .strobe(Alex_data_ready), .clkb(_122MHz), .sigb(C122_frequency_HZ_Tx)); // transfer Tx1 frequency

// move Alex date ready to C122 clock domain
wire C122_Alex_data_ready;
cdc_sync #(1) alex 
 (.siga(Alex_data_ready), .rstb(C122_rst),.clkb(_122MHz), .sigb(C122_Alex_data_ready)); // transfer Tx1 frequency
 

// move Alex data into CBCLK domain if  Alex enabled 
wire  [31:0] SPI_Alex_data;
wire  SPI_Alex_data_ready;

wire Alex_ready = Alex_enable[0] ? Alex_data_ready : 1'b0;

cdc_sync_strobe #(32) SPI_Alex 
 (.siga(Alex_data), .rstb(IF_rst), .clkb(CBCLK), .strobe(Alex_ready), .sigb(SPI_Alex_data));
 
cdc_sync_strobe #(1) SPI_Alex_ready
 (.siga(Alex_data_ready), .rstb(IF_rst), .clkb(CBCLK),  .strobe(Alex_ready), .sigb(SPI_Alex_data_ready));
 
// move Mux data into C122_clk domain
wire [7:0]C122_Mux;
cdc_sync_strobe #(8) Mux_inst 
 (.siga(Mux), .rstb(C122_rst), .strobe(Rx_data_ready), .clkb(C122_clk), .sigb(C122_Mux)); 
 

//------------------------------------------------------------
//  			High Priority to PC C&C Encoder 
//------------------------------------------------------------

// All input data is transfered to tx_clock domain in the encoder

wire CC_ack;
wire CC_data_ready;
wire [15:0] CC_data[0:56];
 
CC_encoder #(50, NR) CC_encoder_inst (				// 50mS update rate
					//	inputs
					.clock(tx_clock),					// tx_clock  125MHz
					.ACK (CC_ack),
					.PTT (FPGA_PTT),
					.Dot (debounce_DOT),
					.Dash(debounce_DASH),
					.frequency_change(frequency_change),
					.ADC0_overload (OVERFLOW),
					.ADC1_overload (OVERFLOW_2),
					.Exciter_power ({4'b0,AIN5}),			
					.FWD_power ({4'b0,AIN1}),
					.REV_power ({4'b0,AIN2}),
					.Supply_volts ({4'b0,AIN6}),  
					.User_ADC1 (16'b0),
					.User_ADC2 (16'b0),
					.User_IO (4'b0),
							
					//	outputs
					.CC_data (CC_data),
					.ready (CC_data_ready)
				);
							
 
 
 
//------------------------------------------------------------
//  Angelia on-board attenuators 
//------------------------------------------------------------

// set the two input attenuators
wire [4:0] atten0;
wire [4:0] atten1;

assign atten0 = FPGA_PTT ? atten0_on_Tx : Attenuator0;
assign atten1 = FPGA_PTT ? atten1_on_Tx : Attenuator1; 

Attenuator Attenuator_ADC0 (.clk(CMCLK), .data(atten0), .ATTN_CLK(ATTN_CLK),   .ATTN_DATA(ATTN_DATA),   .ATTN_LE(ATTN_LE));
Attenuator Attenuator_ADC1 (.clk(CMCLK), .data(atten1), .ATTN_CLK(ATTN_CLK_2), .ATTN_DATA(ATTN_DATA_2), .ATTN_LE(ATTN_LE_2));


//----------------------------------------------
//		Alex SPI interface
//----------------------------------------------

SPI Alex_SPI_Tx (.reset (IF_rst), .Alex_data(SPI_Alex_data), .data_ready(SPI_Alex_data_ready), .SPI_data(Alex_SPI_SDO),
                 .SPI_clock(Alex_SPI_SCK), .Tx_load_strobe(SPI_TX_LOAD),
                 .Rx_load_strobe(SPI_RX_LOAD), .spi_clock(CBCLK));	

//---------------------------------------------------------
//  Debounce inputs - active low
//---------------------------------------------------------

wire debounce_PTT;    // debounced button
wire debounce_DOT;
wire debounce_DASH;

debounce de_PTT	(.clean_pb(debounce_PTT),  .pb(!PTT), .clk(CMCLK));
debounce de_DOT	(.clean_pb(debounce_DOT),  .pb(!KEY_DOT), .clk(CMCLK));
debounce de_DASH	(.clean_pb(debounce_DASH), .pb(!KEY_DASH), .clk(CMCLK));

//-------------------------------------------------------
//    PLLs 
//---------------------------------------------------------


/* 
	Divide the 10MHz reference and 122.88MHz clock to give 80kHz signals.
	Apply these to an EXOR phase detector. If the 10MHz reference is not
	present the EXOR output will be a 80kHz square wave. When passed through 
	the loop filter this will provide a dc level of (3.3/2)v which will
	set the 122.88MHz VCXO to its nominal frequency.
	The selection of the internal or external 10MHz reference for the PLL
	is made using a PCB jumper.

*/

wire ref_80khz; 
wire osc_80khz;
 

// Use a PLL to divide 10MHz clock to 80kHz
C10_PLL PLL2_inst (.inclk0(OSC_10MHZ), .c0(ref_80khz), .locked());

// Use a PLL to divide 122.88MHz clock to 80kHz	as backup in case 10MHz source is not present							
C122_PLL PLL_inst (.inclk0(_122MHz), .c0(osc_80khz), .locked());	
	
//Apply to EXOR phase detector 
assign FPGA_PLL = ref_80khz ^ osc_80khz; 

//-----------------------------------------------------------
//  LED Control  
//-----------------------------------------------------------

/*
	LEDs:  
	
	DEBUG_LED1  	- Lights when an Ethernet broadcast is detected
	DEBUG_LED2  	- Lights when traffic to the boards MAC address is detected
	DEBUG_LED3  	- Lights when detect a received sequence error or ASMI is busy
	DEBUG_LED4 		- Displays state of PHY negotiations - fast flash if no Ethernet connection, slow flash if 100T and on if 1000T
	DEBUG_LED5		- Lights when the PHY receives Ethernet traffic
	DEBUG_LED6  	- Lights when the PHY transmits Ethernet traffic
	DEBUG_LED7  	- Displays state of DHCP negotiations or static IP - on if ACK, slow flash if NAK, fast flash if time out 
					     and long then short flash if static IP
	DEBUG_LED8  	- Lights when sync (0x7F7F7F) received from PC
	DEBUG_LED9  	- Lights when a Metis discovery packet is received
	DEBUG_LED10 	- Lights when a Metis discovery packet reply is sent	
	
	Status_LED	    - Flashes once per second
	
	A LED is flashed for the selected period on the positive edge of the signal.
	If the signal period is greater than the LED period the LED will remain on.


*/

parameter half_second = 2_500_000; // at 12.288MHz clock rate

// LED0 = fast flash if no Ethernet connection, slow flash if 100T, on if 1000T
// and swap between fast and slow flash if not full duplex

// flash LED1 for ~ 0.2 second whenever rgmii_rx_active
Led_flash Flash_LED1(.clock(CMCLK), .signal(network_status[2]), .LED(DEBUG_LED1), .period(half_second)); 	

// flash LED2 for ~ 0.2 second whenever the PHY transmits
Led_flash Flash_LED2(.clock(CMCLK), .signal(network_status[1]), .LED(DEBUG_LED2), .period(half_second)); 
//assign RAM_A2 = 1'b1; // turn the LED off for now. 	

// flash LED3 for ~0.2 seconds whenever ip_rx_enable
Led_flash Flash_LED3(.clock(CMCLK), .signal(network_status[1]), .LED(DEBUG_LED3), .period(half_second));
// flash LED4 for ~0.2 seconds whenever traffic to the boards MAC address is received 
Led_flash Flash_LED4(.clock(CMCLK), .signal(network_status[0]), .LED(DEBUG_LED4), .period(half_second));

// flash LED5 for ~0.2 seconds whenever udp_rx_enable
// Led_flash Flash_LED5(.clock(CMCLK), .signal(network_status[3]), .LED(DEBUG_LED5), .period(half_second));

// LED6 = on if ACK, slow flash if NAK, fast flash if time out and swap between fast and slow 
// if using a static IP address
// flash LED7 for ~0.2 seconds whenever udp_rx_active
Led_flash Flash_LED7(.clock(CMCLK), .signal(network_status[4]), .LED(DEBUG_LED7), .period(half_second));

// flash LED8 for ~0.2 seconds whenever we detect a Metis discovery request
Led_flash Flash_LED8(.clock(CMCLK), .signal(discovery_reply), .LED(DEBUG_LED8), .period(half_second));

// flash LED9 for ~0.2 seconds whenever we respond to a Metis discovery request
//Led_flash Flash_LED9(.clock(CMCLK), .signal(discovery_respond), .LED(DEBUG_LED9), .period(half_second));   // Rx_Audio_fifo_wrreq

// flash LED9 for ~0.2 seconds when
//Led_flash Flash_LED9(.clock(CMCLK), .signal(Audio_empty & run & get_audio_samples), .LED(DEBUG_LED9), .period(half_second)); 

// flash LED10 for ~0.2 seconds when 
//Led_flash Flash_LED10(.clock(CMCLK), .signal(Audio_full & run), .LED(DEBUG_LED10), .period(half_second));  
Led_flash Flash_LED10(.clock(CMCLK), .signal(Rx_fifo_clr[0]), .LED(DEBUG_LED10), .period(half_second)); 

//Led_flash Flash_LED10(.clock(CMCLK), .signal(Rx_fifo_full[0]|Rx_fifo_full[1]|Rx_fifo_full[2]|Rx_fifo_full[3]|Rx_fifo_full[4]|Rx_fifo_full[5]), .LED(DEBUG_LED10), .period(half_second));

//assign DEBUG_LED10 = !C122_SyncRx[0][1];
assign DEBUG_LED9  = !C122_SyncRx[0][2];






//Flash Heart beat LED
reg [26:0]HB_counter;
always @(posedge PHY_CLK125) HB_counter = HB_counter + 1'b1;
assign Status_LED = HB_counter[25];  // Blink



//------------------------------------------------------------
//   Multi-state LED Control   - code in Led_control is for active LOW LEDs
//------------------------------------------------------------

parameter clock_speed = 12_288_000; // 12.288MHz clock 

// display state of PHY negotiations  - fast flash if no Ethernet connection, slow flash if 100T, on if 1000T
// and swap between fast and slow flash if not full duplex
Led_control #(clock_speed) Control_LED0(.clock(CMCLK), .on(network_status[6]), .fast_flash(~network_status[5] || ~network_status[6]),
										.slow_flash(network_status[5]), .vary(~network_status[7]), .LED(DEBUG_LED5));  
										
// display state of DHCP negotiations - on if success, slow flash if fail, fast flash if time out and swap between fast and slow 
// if using a static IP address
Led_control # (clock_speed) Control_LED1(.clock(CMCLK), .on(dhcp_success), .slow_flash(dhcp_failed & !dhcp_timeout),
										.fast_flash(dhcp_timeout), .vary(static_ip_assigned), .LED(DEBUG_LED6));	

endmodule 



