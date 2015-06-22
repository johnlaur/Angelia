//
//  HPSDR - High Performance Software Defined Radio
//
//  Metis code. 
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


//  Metis code copyright 2010, 2011, 2012, 2013 Alex Shovkoplyas, VE3NEA.


module rgmii_send (
  input speed_1Gbit, 
  input [7:0] data,
  input tx_enable,   
  output active,  
  output clock, 
  output clock_2_5MHz,
  output clock_12_5MHz,
  
  //hardware pins
  output [3:0]PHY_TX,
  output PHY_TX_EN,              
  output PHY_TX_CLOCK,    
  input  PHY_CLK125,   
  input  PHY_INT_N,              
  output PHY_RESET_N
  );
  

  
  
//-----------------------------------------------------------------------------  
//                              clocks
//-----------------------------------------------------------------------------
wire clock_125_mhz_0_deg, clock_125_mhz_90_deg;
  
tx_pll	tx_pll_inst (
	.inclk0 (PHY_CLK125),
	.c0 (clock_125_mhz_0_deg),
	.c1 (clock_125_mhz_90_deg),
	.c2 (clock_12_5MHz),
	.c4 (clock_2_5MHz)
	);   
   

assign clock = clock_125_mhz_0_deg;
assign PHY_TX_CLOCK = clock_125_mhz_90_deg;


 


 
//-----------------------------------------------------------------------------  
//                            shift reg
//-----------------------------------------------------------------------------
localparam PREAMBLE_BYTES = 64'h55555555555555D5;
localparam PREAMB_LEN = 4'd8;
localparam HI_BIT = 8*PREAMB_LEN - 1;
reg [HI_BIT:0] shift_reg;  
reg [3:0] bytes_left;




  
  
//-----------------------------------------------------------------------------  
//                           state machine
//-----------------------------------------------------------------------------
localparam ST_IDLE = 1, ST_SEND = 2, ST_GAP = 4;
reg [2:0] state = ST_IDLE;


wire sending = tx_enable | (state == ST_SEND);
assign active = sending | (state == ST_GAP);
assign PHY_RESET_N = 1'b1;


always @(posedge clock)
  begin
  if (sending) shift_reg <= {shift_reg[HI_BIT-8:0], data};
  else shift_reg <= PREAMBLE_BYTES;

  case (state)
    ST_IDLE:
      //receiving the first payload byte 
      if (tx_enable) state <= ST_SEND;

    ST_SEND:
      //receiving payload data
      if (tx_enable) bytes_left <= PREAMB_LEN - 4'd1;
      //purging shift register
      else if (bytes_left != 0) bytes_left <= bytes_left - 4'd1;
      //starting inter-frame gap
      else begin bytes_left <= 4'd12; state <= ST_GAP; end
      
    ST_GAP:
      if (bytes_left != 0) bytes_left <= bytes_left - 4'd1;
      else state <= ST_IDLE;
    endcase
  end
  
  



  
//-----------------------------------------------------------------------------  
//                             output
//-----------------------------------------------------------------------------
ddio_out	ddio_out_inst (
	.datain_h({sending, shift_reg[HI_BIT-4 -: 4]}),
	.datain_l({sending, shift_reg[HI_BIT -: 4]}),   
	.outclock(clock),
	.dataout({PHY_TX_EN, PHY_TX})
	);  

   
  
  
endmodule
  