library IEEE;
use IEEE.std_logic_1164.all;  -- defines std_logic types
use IEEE.std_logic_ARITH.ALL;
use IEEE.std_logic_UNSIGNED.ALL;

-- Copyright 2016 - 2017 (C)  Michael Brown Holotronic
-- holotronic.dk

-- This file is created for Machinekit intended use
library pin;
use pin.Pintypes.all;
use work.IDROMConst.all;

use work.oneofndecode.all;
use work.InputPinsPerModule.all;
use work.log2.all;

entity MakeSSerials is
    generic (
        ThePinDesc: PinDescType := PinDesc;
        ClockHigh: integer;
        ClockMed: integer;
        ClockLow: integer;
        BusWidth: integer;
        AddrWidth: integer;
        IOWidth: integer;
        STEPGENs: integer;
        StepGenTableWidth: integer;
        UseStepGenPreScaler: boolean;
        UseStepgenIndex: boolean;
        UseStepgenProbe: boolean;
        timersize: integer;			-- = ~480 usec at 33 MHz, ~320 at 50 Mhz
        asize: integer;
        rsize: integer;
        HM2DPLLs: integer;
        MuxedQCounters: integer;
        MuxedQCountersMIM: integer;
        PWMGens: integer;
        PWMRefWidth  : integer;
        UsePWMEnas : boolean;
        TPPWMGens : integer;
        QCounters: integer;
        UseMuxedProbe: boolean;
        UseProbe: boolean;
        SPIs: integer;
        BSPIs: integer;
        BSPICSWidth: integer;
        DBSPIs: integer;
        DBSPICSWidth: integer;
        SSerials: integer;
        MaxUARTSPerSSerial: integer);
    Port (
        ibus : in std_logic_vector(BusWidth -1 downto 0) := (others => 'Z');
        obusint : out std_logic_vector(BusWidth -1 downto 0) := (others => 'Z');
        Aint: in std_logic_vector(AddrWidth -1 downto 2);
        readstb : in std_logic;
        writestb : in std_logic;
        CoreDataOut :  inout std_logic_vector(IOWidth-1 downto 0) := (others => 'Z');
        IOBitsCorein :  inout std_logic_vector(IOWidth-1 downto 0) := (others => '0');
        clklow : in std_logic;
        clkmed : in std_logic;
        clkhigh : in std_logic;
        Probe : inout std_logic;
        RateSources: out std_logic_vector(4 downto 0) := (others => 'Z');
        rates: out std_logic_vector (4 downto 0)
    );

end MakeSSerials;


architecture dataflow of MakeSSerials is

-- Signals
type  SSerialType is array(0 to 3) of integer;
constant UARTSPerSSerial: SSerialType :=(
(InputPinsPerModule(ThePinDesc,SSerialTag,0)),
(InputPinsPerModule(ThePinDesc,SSerialTag,1)),
(InputPinsPerModule(ThePinDesc,SSerialTag,2)),
(InputPinsPerModule(ThePinDesc,SSerialTag,3)));

-- I/O port related signals

    begin

	makesserialmod:  if SSerials >0  generate
	signal LoadSSerialCommand: std_logic_vector(SSerials -1 downto 0);
	signal ReadSSerialCommand: std_logic_vector(SSerials -1 downto 0);
	signal LoadSSerialData: std_logic_vector(SSerials -1 downto 0);
	signal ReadSSerialData: std_logic_vector(SSerials -1 downto 0);
	signal LoadSSerialRAM0: std_logic_vector(SSerials -1 downto 0);
	signal ReadSSerialRAM0: std_logic_vector(SSerials -1 downto 0);
	signal LoadSSerialRAM1: std_logic_vector(SSerials -1 downto 0);
	signal ReadSSerialRAM1: std_logic_vector(SSerials -1 downto 0);
	signal LoadSSerialRAM2: std_logic_vector(SSerials -1 downto 0);
	signal ReadSSerialRAM2: std_logic_vector(SSerials -1 downto 0);
	signal LoadSSerialRAM3: std_logic_vector(SSerials -1 downto 0);
	signal ReadSSerialRAM3: std_logic_vector(SSerials -1 downto 0);
	type  SSerialRXType is array(SSerials-1 downto 0) of std_logic_vector(MaxUARTsPerSSerial-1 downto 0);
	signal SSerialRX: SSerialRXType;
	type  SSerialTXType is array(SSerials-1 downto 0) of std_logic_vector(MaxUARTsPerSSerial-1 downto 0);
	signal SSerialTX: SSerialTXType;
	type  SSerialTXEnType is array(SSerials-1 downto 0) of std_logic_vector(MaxUARTsPerSSerial-1 downto 0);
	signal SSerialTXEn: SSerialTXEnType;
	signal SSerialTestBits: std_logic_vector(SSerials -1 downto 0);
	signal SSerialCommandSel: std_logic;
	signal SSerialDataSel: std_logic;
	signal SSerialRAMSel0: std_logic;
	signal SSerialRAMSel1: std_logic;
	signal SSerialRAMSel2: std_logic;
	signal SSerialRAMSel3: std_logic;
	begin
		makesserials: for i in 0 to SSerials -1 generate
			asserial: entity work.sserialwa
			generic map (
				Ports => UARTSPerSSerial(i),
				InterfaceRegs => UARTSPerSSerial(i),	-- must be power of 2
				BaseClock => ClockMed,
				NeedCRC8 => true
			)
			port map(
				clk  => clklow,
				clkmed => clkmed,
				ibus  => ibus,
				obus  => obusint,
				hloadcommand  => LoadSSerialCommand(i),
				hreadcommand  => ReadSSerialCommand(i),
				hloaddata  => LoadSSerialData(i),
				hreaddata  => ReadSSerialData(i),
				regaddr  =>  Aint(log2(UARTSPerSSerial(i))+1 downto 2),
				hloadregs0  => LoadSSerialRAM0(i),
				hreadregs0  => ReadSSerialRAM0(i),
				hloadregs1  => LoadSSerialRAM1(i),
				hreadregs1  => ReadSSerialRAM1(i),
				hloadregs2  => LoadSSerialRAM2(i),
				hreadregs2  => ReadSSerialRAM2(i),
				hloadregs3  => LoadSSerialRAM3(i),
				hreadregs3  => ReadSSerialRAM3(i),
				rxserial  =>  SSerialRX(i)(UARTSPerSSerial(i) -1 downto 0),
				txserial  =>  SSerialTX(i)(UARTSPerSSerial(i) -1 downto 0),
				txenable  =>  SSerialTXEn(i)(UARTSPerSSerial(i) -1 downto 0),
				testbit  =>   SSerialTestBits(i)
				);
		end generate;

		SSerialDecodeProcess : process (Aint,Readstb,writestb,SSerialCommandSel,SSerialDataSel,
		                                SSerialRAMSel0,SSerialRAMSel1,SSerialRAMSel2,SSerialRAMSel3)
		begin
			if Aint(AddrWidth-1 downto 8) = SSerialCommandAddr then
				SSerialCommandSel <= '1';
			else
				SSerialCommandSel <= '0';
			end if;
			if Aint(AddrWidth-1 downto 8) = SSerialDataAddr then
				SSerialDataSel <= '1';
			else
				SSerialDataSel <= '0';
			end if;
			if Aint(AddrWidth-1 downto 8) = SSerialRAMAddr0 then
				SSerialRAMSel0 <= '1';
			else
				SSerialRAMSel0 <= '0';
			end if;
			if Aint(AddrWidth-1 downto 8) = SSerialRAMAddr1 then
				SSerialRAMSel1 <= '1';
			else
				SSerialRAMSel1 <= '0';
			end if;
			if Aint(AddrWidth-1 downto 8) = SSerialRAMAddr2 then
				SSerialRAMSel2 <= '1';
			else
				SSerialRAMSel2 <= '0';
			end if;
			if Aint(AddrWidth-1 downto 8) = SSerialRAMAddr3 then
				SSerialRAMSel3 <= '1';
			else
				SSerialRAMSel3 <= '0';
			end if;
			LoadSSerialCommand <= OneOfNDecode(SSerials,SSerialCommandSel,writestb,Aint(7 downto 6));
			ReadSSerialCommand <= OneOfNDecode(SSerials,SSerialCommandSel,Readstb,Aint(7 downto 6));
			LoadSSerialData <= OneOfNDecode(SSerials,SSerialDataSel,writestb,Aint(7 downto 6));
			ReadSSerialData <= OneOfNDecode(SSerials,SSerialDataSel,Readstb,Aint(7 downto 6));
			LoadSSerialRam0 <= OneOfNDecode(SSerials,SSerialRAMSel0,writestb,Aint(7 downto 6)); 	-- 16 addresses per SSerial RAM max, this implies 4 max sserials
			ReadSSerialRam0 <= OneOfNDecode(SSerials,SSerialRAMSel0,Readstb,Aint(7 downto 6)); 	-- 16 addresses per SSerial RAM max, this implies 4 max sserials
			LoadSSerialRam1 <= OneOfNDecode(SSerials,SSerialRAMSel1,writestb,Aint(7 downto 6)); 	-- 16 addresses per SSerial RAM max, this implies 4 max sserials
			ReadSSerialRam1 <= OneOfNDecode(SSerials,SSerialRAMSel1,Readstb,Aint(7 downto 6)); 	-- 16 addresses per SSerial RAM max
			LoadSSerialRam2 <= OneOfNDecode(SSerials,SSerialRAMSel2,writestb,Aint(7 downto 6)); 	-- 16 addresses per SSerial RAM max
			ReadSSerialRam2 <= OneOfNDecode(SSerials,SSerialRAMSel2,Readstb,Aint(7 downto 6)); 	-- 16 addresses per SSerial RAM max
			LoadSSerialRam3 <= OneOfNDecode(SSerials,SSerialRAMSel3,writestb,Aint(7 downto 6)); 	-- 16 addresses per SSerial RAM max
			ReadSSerialRam3 <= OneOfNDecode(SSerials,SSerialRAMSel3,Readstb,Aint(7 downto 6)); 	-- 16 addresses per SSerial RAM max
        report "Max UARTS per sserial " & integer'image(MaxUARTSPerSSerial);
        report "UARTS per sserial 0 " &  integer 'image(UARTSPerSSerial(0));
        report "UARTS per sserial 1 " &  integer 'image(UARTSPerSSerial(1));
        report "UARTS per sserial 2 " &  integer 'image(UARTSPerSSerial(2));
        report "UARTS per sserial 3 " &  integer 'image(UARTSPerSSerial(3));


		end process SSerialDecodeProcess;

		DoSSerialPins: process(SSerialTX, SSerialTXEn, SSerialTestBits, IOBitsCorein)
		begin
			for i in 0 to IOWidth -1 loop				-- loop through all the external I/O pins
				if ThePinDesc(i)(15 downto 8) = SSerialTag then 	-- this hideous masking of pinnumbers/vs pintype is why they should be separate bytes, maybe IDROM type 4...
					if (ThePinDesc(i)(7 downto 0) and x"F0") = x"80" then 	-- txouts match 8X
						CoreDataOut(i) <=   SSerialTX(conv_integer(ThePinDesc(i)(23 downto 16)))(conv_integer(ThePinDesc(i)(3 downto 0))-1);	-- 16 max ports
					end if;
					if (ThePinDesc(i)(7 downto 0) and x"F0") = x"90" then 	-- txens match 9X
						CoreDataOut(i) <= not SSerialTXEn(conv_integer(ThePinDesc(i)(23 downto 16)))(conv_integer(ThePinDesc(i)(3 downto 0))-1); 	-- 16 max ports
					end if;
					if (ThePinDesc(i)(7 downto 0) and x"F0") = x"00" then 	-- rxins match 0X
						SSerialRX(conv_integer(ThePinDesc(i)(23 downto 16)))(conv_integer(ThePinDesc(i)(3 downto 0))-1) <= IOBitsCorein(i);		-- 16 max ports
					end if;
					if ThePinDesc(i)(7 downto 0) = SSerialTestPin then
						CoreDataOut(i) <= SSerialTestBits(i);
					end if;
				end if;
			end loop;
		end process;
    end generate makesserialmod;

end dataflow;
