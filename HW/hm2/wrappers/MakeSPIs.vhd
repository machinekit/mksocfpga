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

entity MakeSPIs is
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
		SPIs: integer);
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

end MakeSPIs;


architecture dataflow of MakeSPIs is

-- Signals

-- I/O port related signals

	begin
	makespimod:  if SPIs >0  generate
	signal LoadSPIBitCount: std_logic_vector(SPIs -1 downto 0);
	signal LoadSPIBitRate: std_logic_vector(SPIs -1 downto 0);
	signal LoadSPIData: std_logic_vector(SPIs -1 downto 0);
	signal ReadSPIData: std_logic_vector(SPIs -1 downto 0);
	signal ReadSPIBitCOunt: std_logic_vector(SPIs -1 downto 0);
	signal ReadSPIBitRate: std_logic_vector(SPIs -1 downto 0);
	signal SPIClk: std_logic_vector(SPIs -1 downto 0);
	signal SPIIn: std_logic_vector(SPIs -1 downto 0);
	signal SPIOut: std_logic_vector(SPIs -1 downto 0);
	signal SPIFrame: std_logic_vector(SPIs -1 downto 0);
	signal SPIDAV: std_logic_vector(SPIs -1 downto 0);
	signal SPIBitCountSel : std_logic;
	signal SPIBitrateSel : std_logic;
	signal SPIDataSel : std_logic;

	begin
		makespis: for i in 0 to SPIs -1 generate
			aspi: entity work.SimpleSPI
			generic map (
				BusWidth => BusWidth)
			port map (
				clk  => clklow,
				ibus => ibus,
				obus => obusint,
				loadbitcount => LoadSPIBitCount(i),
				loadbitrate => LoadSPIBitRate(i),
				loaddata => LoadSPIData(i),
				readdata => ReadSPIData(i),
				readbitcount => ReadSPIBitCOunt(i),
				readbitrate => ReadSPIBitRate(i),
				spiclk => SPIClk(i),
				spiin => SPIIn(i),
				spiout => SPIOut(i),
				spiframe => SPIFrame(i),
				davout => SPIDAV(i)
				);
		end generate ;

		SPIDecodeProcess : process (Aint,Readstb,writestb,SPIDataSel,SPIBitCountSel,SPIBitRateSel)
		begin
			if Aint(AddrWidth-1 downto 8) = SPIDataAddr then	 --  SPI data register select
				SPIDataSel <= '1';
			else
				SPIDataSel <= '0';
			end if;
			if Aint(AddrWidth-1 downto 8) = SPIBitCountAddr then	 --  SPI bit count register select
				SPIBitCountSel <= '1';
			else
				SPIBitCountSel <= '0';
			end if;
			if Aint(AddrWidth-1 downto 8) = SPIBitrateAddr then	 --  SPI bit rate register select
				SPIBitrateSel <= '1';
			else
				SPIBitrateSel <= '0';
			end if;
			LoadSPIData <= OneOfNDecode(SPIs,SPIDataSel,writestb,Aint(5 downto 2)); -- 16 max
			ReadSPIData <= OneOfNDecode(SPIs,SPIDataSel,Readstb,Aint(5 downto 2));
			LoadSPIBitCount <= OneOfNDecode(SPIs,SPIBitCountSel,writestb,Aint(5 downto 2));
			ReadSPIBitCount <= OneOfNDecode(SPIs,SPIBitCountSel,Readstb,Aint(5 downto 2));
			LoadSPIBitRate <= OneOfNDecode(SPIs,SPIBitRateSel,writestb,Aint(5 downto 2));
			ReadSPIBitRate <= OneOfNDecode(SPIs,SPIBitRateSel,Readstb,Aint(5 downto 2));
		end process SPIDecodeProcess;

		DoSPIPins: process(SPIFrame,SPIOut,SPIClk)
		begin
			for i in 0 to IOWidth -1 loop				-- loop through all the external I/O pins
				if ThePinDesc(i)(15 downto 8) = SPITag then
					case (ThePinDesc(i)(7 downto 0)) is	--secondary pin function, drop MSB
						when SPIFramePin =>
							IOBitsCorein(i) <= SPIFrame(conv_integer(ThePinDesc(i)(23 downto 16)));
						when SPIOutPin =>
							IOBitsCorein(i) <= SPIOut(conv_integer(ThePinDesc(i)(23 downto 16)));
						when SPIClkPin =>
							IOBitsCorein(i) <= SPIClk(conv_integer(ThePinDesc(i)(23 downto 16)));
						when SPIInPin =>
							SPIIn(conv_integer(ThePinDesc(i)(23 downto 16))) <= IOBitsCorein(i);
						when others => null;
					end case;
				end if;
			end loop;
		end process;
	end generate makespimod;

end dataflow;
