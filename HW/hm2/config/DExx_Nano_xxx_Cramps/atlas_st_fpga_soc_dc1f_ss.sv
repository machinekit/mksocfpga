package boardtype;
// DE0-Nano Dev kit and I/O adaptors specific info
//   {STRAIGHT=0,DB25=1} BoardAdaptor;

parameter BoardAdaptor          = 0;
    parameter ClockHigh         = 200000000;    // 200 MHz
    parameter ClockMed          = 100000000;    // 100 MHz
    parameter ClockLow          =  50000000;    //  50 MHz
//    parameter BoardNameLow      = 32'h41524554;        // "TERA"
//    parameter BoardNameHigh     = 32'h4E304544;        // "DE0N"
    parameter BoardNameLow      = 32'h4153454D;        // "MESA"
    parameter BoardNameHigh     = 32'h35324935;        // "5I25"
    parameter FPGASize          = 9;            // Reported as 32-bit value in IDROM.vhd (9 matches Mesanet value for 5i25)
                                                    //   FIXME: Figure out Mesanet encoding and put something sensible here
    parameter FPGAPins          = 144;    // Total Number of available I/O pins for Hostmot2 use Reported as 32-bit value in IDROM.vhd
                                                    // Proposal: On DE0 NANO board Limit to total count of gpios + arduinoconnectors + ltc + adc I/Os
                                            //   Maximum of 144 pindesc entries currently hard-coded in IDROM.vhd
    parameter IOPorts           = 3;            // Number of external ports (DE0-Nano_DB25 can have 2 on each 40-pin expansion header)
    parameter IOWidth           = 72;            // Number of total I/O pins = IOPorts * PortWidth
    parameter PortWidth         = 24;            // Number of I/O pins per port: 17 per DB25
    parameter LIOWidth          = 0;            // Number of local I/Os (used for on-board serial-port on Mesanet cards)
    parameter LEDCount          = 0;            // Number of LEDs
    parameter SepClocks         = "true";            // Deprecated
    parameter OneWS             = "true";            // Deprecated
    parameter BusWidth          = 32;
    parameter AddrWidth         = 16;

    parameter GPIOWidth         = 36;
    parameter NumGPIO           = 2;
    parameter MuxGPIOIOWidth    = IOWidth/NumGPIO;
    parameter MuxLedWidth       = LEDCount/NumGPIO;
    parameter ADC               = "DE0-Nano-SoC";
    parameter Mux_En            = 0;
    parameter Capsense          = 0;
    parameter NumSense          = 4;
                              // Capsense Pins: '{.. etc , Sensor1, Sensor0, charge out}   // GPIO 0-71
    parameter int Capsense_Pins[NumSense:0]   = '{ 40, 39,      38,      37, 36        };
endpackage //_HeaderIncluded
