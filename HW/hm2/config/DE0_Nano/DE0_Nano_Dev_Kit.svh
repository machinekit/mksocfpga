`ifndef _HeaderIncluded
`define _HeaderIncluded
// DE0-Nano card specific info
	parameter ClockHigh			= 200000000;	// 200 MHz
	parameter ClockMed			= 100000000;	// 100 MHz
	parameter ClockLow			=  50000000;	//  50 MHz
	parameter BoardNameLow		= 32'h41524554;		// "TERA"
	parameter BoardNameHigh		= 32'h4E304544;		// "DE0N"
	parameter FPGASize			= 9;			// Reported as 32-bit value in IDROM.vhd (9 matches Mesanet value for 5i25)
											//   FIXME: Figure out Mesanet encoding and put something sensible here
	parameter FPGAPins			= 144;			// Reported as 32-bit value in IDROM.vhd
											//   Maximum of 144 pindesc entries currently hard-coded in IDROM.vhd
	parameter IOPorts			= 4;			// Number of external ports (DE0-Nano_DB25 can have 2 on each 40-pin expansion header)
	parameter IOWidth			= 68;			// Number of total I/O pins = IOPorts * PortWidth
	parameter PortWidth			= 17;			// Number of I/O pins per port: 17 per DB25
	parameter LIOWidth			= 6;			// Number of local I/Os (used for on-board serial-port on Mesanet cards)
	parameter LEDCount			= 4;			// Number of LEDs
	parameter SepClocks			= "true";			// Deprecated
	parameter OneWS				= "true";			// Deprecated
	parameter BusWidth			= 32;
	parameter AddrWidth			= 16;

	parameter GPIOWidth 		= 36;
	parameter NumGPIO 			= 2;
	parameter MuxGPIOIOWidth 	= IOWidth/NumGPIO;
`endif //_HeaderIncluded