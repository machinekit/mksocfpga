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

entity MakeQCounters is
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
		UseProbe: boolean);
	Port (
		ibus : in std_logic_vector(BusWidth -1 downto 0) := (others => 'Z');
		obusint : out std_logic_vector(BusWidth -1 downto 0) := (others => 'Z');
		Aint: in std_logic_vector(AddrWidth -1 downto 2);
		readstb : in std_logic;
		writestb : in std_logic;
		CoreDataOut :  out std_logic_vector(IOWidth-1 downto 0) := (others => 'Z');
		IOBitsCorein :  in std_logic_vector(IOWidth-1 downto 0) := (others => '0');
		clklow : in std_logic;
		clkmed : in std_logic;
		clkhigh : in std_logic;
		Probe : inout std_logic;
		RateSources: out std_logic_vector(4 downto 0) := (others => 'Z');
		rates: out std_logic_vector (4 downto 0)
	);

end MakeQCounters;


architecture dataflow of MakeQCounters is

-- Signals

-- I/O port related signals
	signal RefCountBus : std_logic_vector(PWMRefWidth-1 downto 0);

	begin

	makeqcounters: if QCounters >0 generate
	signal LoadQCounter: std_logic_vector(QCounters-1 downto 0);
	signal ReadQCounter: std_logic_vector(QCounters-1 downto 0);
	signal LoadQCounterCCR: std_logic_vector(QCounters-1 downto 0);
	signal ReadQCounterCCR: std_logic_vector(QCounters-1 downto 0);
	signal QuadA: std_logic_vector(QCounters-1 downto 0);
	signal QuadB: std_logic_vector(QCounters-1 downto 0);
	signal Index: std_logic_vector(QCounters -1 downto 0);
	signal IndexMask: std_logic_vector(QCounters -1 downto 0);
	signal QCounterSel : std_logic;
	signal QCounterCCRSel : std_logic;
	signal LoadTSDiv : std_logic;
	signal ReadTSDiv : std_logic;
	signal ReadTS : std_logic;
	signal TimeStampBus: std_logic_vector(15 downto 0);
	signal LoadQCountRate : std_logic;
	signal QCountFilterRate : std_logic;

	begin
		timestampx: entity work.timestamp
			port map(
				ibus => ibus(15 downto 0),
				obus => obusint(15 downto 0),
				loadtsdiv => LoadTSDiv ,
				readts => ReadTS,
				readtsdiv =>ReadTSDiv,
				tscount => TimeStampBus,
				clk => clklow
			);

		qcountratex: entity work.qcounterate
			generic map (clock => ClockLow) -- default encoder clock is 16 MHz
			port map(
				ibus => ibus(11 downto 0),
				loadRate => LoadQCountRate,
				rateout => QcountFilterRate,
				clk => clklow
			);

		nuseprobe1: if not UseProbe generate
			makequadcounters: for i in 0 to QCounters-1 generate
				qcounterx: entity work.qcounter
				generic map (
					buswidth => BusWidth
				)
				port map (
					obus => obusint,
					ibus => ibus,
					quada => QuadA(i),
					quadb => QuadB(i),
					index => Index(i),
					loadccr => LoadQcounterCCR(i),
					readccr => ReadQcounterCCR(i),
					readcount => ReadQcounter(i),
					countclear => LoadQcounter(i),
					timestamp => TimeStampBus,
					indexmask => IndexMask(i),
					filterrate => QCountFilterRate,
					clk =>	clklow
				);
			end generate makequadcounters;
		end generate nuseprobe1;

		useprobe1: if UseProbe generate
			makequadcountersp: for i in 0 to QCounters-1 generate
				qcounterx: entity work.qcounterp
				generic map (
					buswidth => BusWidth
				)
				port map (
					obus => obusint,
					ibus => ibus,
					quada => QuadA(i),
					quadb => QuadB(i),
					index => Index(i),
					loadccr => LoadQcounterCCR(i),
					readccr => ReadQcounterCCR(i),
					readcount => ReadQcounter(i),
					countclear => LoadQcounter(i),
					timestamp => TimeStampBus,
					indexmask => IndexMask(i),
					probe => Probe,
					filterrate => QCountFilterRate,
					clk =>	clklow
				);
			end generate makequadcountersp;
		end generate useprobe1;

		QCounterDecodeProcess : process (Aint,Readstb,writestb,QCounterSel, QCounterCCRSel)
		begin
			if Aint(AddrWidth-1 downto 8) = QCounterAddr then	 --  QCounter select
				QCounterSel <= '1';
			else
				QCounterSel <= '0';
			end if;
			if Aint(AddrWidth-1 downto 8) = QCounterCCRAddr then	 --  QCounter CCR register select
				QCounterCCRSel <= '1';
			else
				QCounterCCRSel <= '0';
			end if;
			if Aint(AddrWidth-1 downto 8) = TSDivAddr and writestb = '1' then	 --
				LoadTSDiv <= '1';
			else
				LoadTSDiv <= '0';
			end if;
			if Aint(AddrWidth-1 downto 8) = TSDivAddr and readstb = '1' then	 --
				ReadTSDiv <= '1';
			else
				ReadTSDiv <= '0';
			end if;
			if Aint(AddrWidth-1 downto 8) = TSAddr and readstb = '1' then	 --
				ReadTS <= '1';
			else
				ReadTS <= '0';
			end if;
			if Aint(AddrWidth-1 downto 8) = QCRateAddr and writestb = '1' then	 --
				LoadQCountRate <= '1';
			else
				LoadQCountRate <= '0';
			end if;
			LoadQCounter <= OneOfNDecode(QCounters,QCounterSel,writestb,Aint(7 downto 2));  -- 64 max
			ReadQCounter <= OneOfNDecode(QCounters,QCounterSel,Readstb,Aint(7 downto 2));
			LoadQCounterCCR <= OneOfNDecode(QCounters,QCounterCCRSel,writestb,Aint(7 downto 2));
			ReadQCounterCCR <= OneOfNDecode(QCounters,QCounterCCRSel,Readstb,Aint(7 downto 2));
		end process QCounterDecodeProcess;

		DoQCounterPins: process(IOBitsCorein)
		begin
			for i in 0 to IOWidth -1 loop				-- loop through all the external I/O pins
				if ThePinDesc(i)(15 downto 8) = QCountTag then
					case (ThePinDesc(i)(7 downto 0)) is	--secondary pin function
						when QCountQAPin =>
							QuadA(conv_integer(ThePinDesc(i)(23 downto 16))) <= IOBitsCorein(i);
						when QCountQBPin =>
							QuadB(conv_integer(ThePinDesc(i)(23 downto 16))) <= IOBitsCorein(i);
						when QCountIdxPin =>
							Index(conv_integer(ThePinDesc(i)(23 downto 16))) <= IOBitsCorein(i);
						when QCountIdxMaskPin =>
							IndexMask(conv_integer(ThePinDesc(i)(23 downto 16))) <= IOBitsCorein(i);
						when QCountProbePin =>
							Probe <= IOBitsCorein(i);	-- only 1 please!
						when others => null;
					end case;
				end if;
			end loop;
		end process;

	end generate makeqcounters;

end dataflow;
