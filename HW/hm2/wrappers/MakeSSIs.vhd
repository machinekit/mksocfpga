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

entity MakeSSSIs is
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
        SSSIs: integer);
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

end MakeSSSIs;


architecture dataflow of MakeSSSIs is

-- Signals

-- I/O port related signals

    begin

	makesssimod:  if SSSIs >0  generate
	signal LoadSSSIData0: std_logic_vector(SSSIs -1 downto 0);
	signal ReadSSSIData0: std_logic_vector(SSSIs -1 downto 0);
	signal ReadSSSIData1: std_logic_vector(SSSIs -1 downto 0);
	signal LoadSSSIControl: std_logic_vector(SSSIs -1 downto 0);
	signal ReadSSSIControl: std_logic_vector(SSSIs -1 downto 0);
	signal SSSIClk: std_logic_vector(SSSIs -1 downto 0);
	signal SSSIData: std_logic_vector(SSSIs -1 downto 0);
	signal SSSIBusyBits: std_logic_vector(SSSIs -1 downto 0);
	signal SSSIDAVBits: std_logic_vector(SSSIs -1 downto 0);
	signal SSSIDataSel0 : std_logic;
	signal SSSIDataSel1 : std_logic;
	signal SSSIControlSel : std_logic;
	signal GlobalPStartSSSI : std_logic;
	signal GlobalSSSIBusySel : std_logic;
	signal GlobalTStartSSSI : std_logic;
		begin
		makesssis: for i in 0 to SSSIs -1 generate
			sssi: entity work.SimpleSSI
			port  map (
				clk => clklow,
--				ibus => ibusint,
				obus => obusint,
				loadcontrol => LoadSSSIControl(i),
				lstart => LoadSSSIData0(i),
				pstart => GlobalPstartSSSI,
				timers => RateSources,
				readdata0 => ReadSSSIData0(i),
				readdata1 => ReadSSSIData1(i),
				readcontrol => ReadSSSIControl(i),
				busyout => SSSIBusyBits(i),
				davout => SSSIDAVBits(i),
				ssiclk => SSSIClk(i),
				ssidata => SSSIData(i)
				);
		end generate;

		SSSIDecodeProcess : process (Aint,Readstb,writestb,SSSIDataSel0,GlobalSSSIBusySel,
		                             SSSIBusyBits,SSSIDAvBits,SSSIDataSel1,SSSIControlSel)
		begin
			if Aint(AddrWidth-1 downto 8) = SSSIDataAddr0 then	 --  SSSI data register select 0
				SSSIDataSel0 <= '1';
			else
				SSSIDataSel0 <= '0';
			end if;
			if Aint(AddrWidth-1 downto 8) = SSSIDataAddr1 then	 --  SSSI data register select 1
				SSSIDataSel1 <= '1';
			else
				SSSIDataSel1 <= '0';
			end if;

			if Aint(AddrWidth-1 downto 8) = SSSIControlAddr then	 --  SSSI control register select
				SSSIControlSel <= '1';
			else
				SSSIControlSel <= '0';
			end if;
			if Aint(AddrWidth-1 downto 8) = SSSIGlobalPStartAddr and writestb = '1' then	 --
				GlobalPStartSSSI <= '1';
			else
				GlobalPStartSSSI <= '0';
			end if;
			if Aint(AddrWidth-1 downto 8) = SSSIGlobalPStartAddr and readstb = '1' then	 --
				GlobalSSSIBusySel <= '1';
			else
				GlobalSSSIBusySel <= '0';
			end if;
			LoadSSSIData0 <= OneOfNDecode(SSSIs,SSSIDataSel0,writestb,Aint(7 downto 2)); -- 64 max
			ReadSSSIData0 <= OneOfNDecode(SSSIs,SSSIDataSel0,Readstb,Aint(7 downto 2));
			ReadSSSIData1 <= OneOfNDecode(SSSIs,SSSIDataSel1,Readstb,Aint(7 downto 2));
			LoadSSSIControl <= OneOfNDecode(SSSIs,SSSIControlSel,writestb,Aint(7 downto 2));
			ReadSSSIControl <= OneOfNDecode(SSSIs,SSSIControlSel,Readstb,Aint(7 downto 2));
			obusint <= (others => 'Z');
			if GlobalSSSIBusySel = '1' then
				obusint(SSSIs -1 downto 0) <= SSSIBusyBits;
				obusint(31 downto SSSIs) <= (others => '0');
			end if;
		end process SSSIDecodeProcess;

		DoSSIPins: process(SSSIClk, IOBitsCorein,SSSIDavBits)
		begin
			for i in 0 to IOWidth -1 loop				-- loop through all the external I/O pins
				if ThePinDesc(i)(15 downto 8) = SSSITag then 	-- this hideous masking of pinnumbers/vs pintype is why they should be separate bytes, maybe IDROM type 4...
					case (ThePinDesc(i)(7 downto 0)) is	--secondary pin function, drop MSB
						when SSSIClkPin =>
							IOBitsCorein(i) <= SSSIClk(conv_integer(ThePinDesc(i)(23 downto 16)));
						when SSSIClkEnPin =>
							IOBitsCorein(i) <= '0';		-- for RS-422 daughtercards that have drive enables
						when SSSIDAVPin =>
							IOBitsCorein(i) <= SSSIDAVBits(conv_integer(ThePinDesc(i)(23 downto 16)));
						when SSSIDataPin =>
							SSSIData(conv_integer(ThePinDesc(i)(23 downto 16))) <= IOBitsCorein(i);
						when others => null;
					end case;
				end if;
			end loop;
		end process;
    end generate makesssimod;

end dataflow;
