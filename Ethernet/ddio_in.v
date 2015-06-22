// megafunction wizard: %ALTDDIO_IN%
// GENERATION: STANDARD
// VERSION: WM1.0
// MODULE: ALTDDIO_IN 

// ============================================================
// File Name: ddio_in.v
// Megafunction Name(s):
// 			ALTDDIO_IN
//
// Simulation Library Files(s):
// 			altera_mf
// ============================================================
// ************************************************************
// THIS IS A WIZARD-GENERATED FILE. DO NOT EDIT THIS FILE!
//
// 11.1 Build 259 01/25/2012 SP 2 SJ Web Edition
// ************************************************************


//Copyright (C) 1991-2011 Altera Corporation
//Your use of Altera Corporation's design tools, logic functions 
//and other software and tools, and its AMPP partner logic 
//functions, and any output files from any of the foregoing 
//(including device programming or simulation files), and any 
//associated documentation or information are expressly subject 
//to the terms and conditions of the Altera Program License 
//Subscription Agreement, Altera MegaCore Function License 
//Agreement, or other applicable license agreement, including, 
//without limitation, that your use is for the sole purpose of 
//programming logic devices manufactured by Altera and sold by 
//Altera or its authorized distributors.  Please refer to the 
//applicable agreement for further details.


// synopsys translate_off
`timescale 1 ps / 1 ps
// synopsys translate_on
module ddio_in (
	datain,
	inclock,
	dataout_h,
	dataout_l);

	input	[4:0]  datain;
	input	  inclock;
	output	[4:0]  dataout_h;
	output	[4:0]  dataout_l;

	wire [4:0] sub_wire0;
	wire [4:0] sub_wire1;
	wire [4:0] dataout_h = sub_wire0[4:0];
	wire [4:0] dataout_l = sub_wire1[4:0];

	altddio_in	ALTDDIO_IN_component (
				.datain (datain),
				.inclock (inclock),
				.dataout_h (sub_wire0),
				.dataout_l (sub_wire1),
				.aclr (1'b0),
				.aset (1'b0),
				.inclocken (1'b1),
				.sclr (1'b0),
				.sset (1'b0));
	defparam
		ALTDDIO_IN_component.intended_device_family = "Cyclone III",
		ALTDDIO_IN_component.invert_input_clocks = "ON",
		ALTDDIO_IN_component.lpm_hint = "UNUSED",
		ALTDDIO_IN_component.lpm_type = "altddio_in",
		ALTDDIO_IN_component.power_up_high = "OFF",
		ALTDDIO_IN_component.width = 5;


endmodule

// ============================================================
// CNX file retrieval info
// ============================================================
// Retrieval info: LIBRARY: altera_mf altera_mf.altera_mf_components.all
// Retrieval info: PRIVATE: INTENDED_DEVICE_FAMILY STRING "Cyclone III"
// Retrieval info: CONSTANT: INTENDED_DEVICE_FAMILY STRING "Cyclone III"
// Retrieval info: CONSTANT: INVERT_INPUT_CLOCKS STRING "ON"
// Retrieval info: CONSTANT: LPM_HINT STRING "UNUSED"
// Retrieval info: CONSTANT: LPM_TYPE STRING "altddio_in"
// Retrieval info: CONSTANT: POWER_UP_HIGH STRING "OFF"
// Retrieval info: CONSTANT: WIDTH NUMERIC "5"
// Retrieval info: USED_PORT: datain 0 0 5 0 INPUT NODEFVAL "datain[4..0]"
// Retrieval info: CONNECT: @datain 0 0 5 0 datain 0 0 5 0
// Retrieval info: USED_PORT: dataout_h 0 0 5 0 OUTPUT NODEFVAL "dataout_h[4..0]"
// Retrieval info: CONNECT: dataout_h 0 0 5 0 @dataout_h 0 0 5 0
// Retrieval info: USED_PORT: dataout_l 0 0 5 0 OUTPUT NODEFVAL "dataout_l[4..0]"
// Retrieval info: CONNECT: dataout_l 0 0 5 0 @dataout_l 0 0 5 0
// Retrieval info: USED_PORT: inclock 0 0 0 0 INPUT_CLK_EXT NODEFVAL "inclock"
// Retrieval info: CONNECT: @inclock 0 0 0 0 inclock 0 0 0 0
// Retrieval info: GEN_FILE: TYPE_NORMAL ddio_in.v TRUE FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL ddio_in.qip TRUE FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL ddio_in.bsf TRUE TRUE
// Retrieval info: GEN_FILE: TYPE_NORMAL ddio_in_inst.v FALSE TRUE
// Retrieval info: GEN_FILE: TYPE_NORMAL ddio_in_bb.v FALSE TRUE
// Retrieval info: GEN_FILE: TYPE_NORMAL ddio_in.inc TRUE TRUE
// Retrieval info: GEN_FILE: TYPE_NORMAL ddio_in.cmp TRUE TRUE
// Retrieval info: GEN_FILE: TYPE_NORMAL ddio_in.ppf TRUE FALSE
// Retrieval info: LIB_FILE: altera_mf
