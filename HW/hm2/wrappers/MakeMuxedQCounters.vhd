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

entity MakeMuxedQCounters is
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

end MakeMuxedQCounters;


architecture dataflow of MakeMuxedQCounters is

-- Signals

-- I/O port related signals
	signal RefCountBus : std_logic_vector(PWMRefWidth-1 downto 0);

	begin
	makemuxedqcounters: if MuxedQCounters >0 generate
	signal LoadMuxedQCounter: std_logic_vector(MuxedQCounters-1 downto 0);
	signal ReadMuxedQCounter: std_logic_vector(MuxedQCounters-1 downto 0);
	signal LoadMuxedQCounterCCR: std_logic_vector(MuxedQCounters-1 downto 0);
	signal ReadMuxedQCounterCCR: std_logic_vector(MuxedQCounters-1 downto 0);
	signal MuxedQuadA: std_logic_vector(MuxedQCounters/2 -1 downto 0); -- 2 should be muxdepth constant?
	signal MuxedQuadB: std_logic_vector(MuxedQCounters/2 -1 downto 0);
	signal MuxedIndex: std_logic_vector(MuxedQCounters/2 -1 downto 0);
	signal MuxedIndexMask: std_logic_vector(MuxedQCounters -1 downto 0);
	signal MuxedIndexMaskMIM: std_logic_vector(MuxedQCountersMIM/2 -1 downto 0);
	signal DemuxedIndexMask: std_logic_vector(MuxedQCountersMIM -1 downto 0);
	signal DeMuxedQuadA: std_logic_vector(MuxedQCounters -1 downto 0);
	signal DeMuxedQuadB: std_logic_vector(MuxedQCounters -1 downto 0);
	signal DeMuxedIndex: std_logic_vector(MuxedQCounters -1 downto 0);
	signal MuxedQCounterSel : std_logic;
	signal MuxedQCounterCCRSel : std_logic;
	signal MuxedProbe : std_logic; -- only 1!
	signal LoadMuxedTSDiv : std_logic;
	signal ReadMuxedTSDiv : std_logic;
	signal ReadMuxedTS : std_logic;
	signal MuxedTimeStampBus: std_logic_vector(15 downto 0);
	signal LoadMuxedQCountRate : std_logic;
	signal MuxedQCountFilterRate : std_logic;
	signal PrePreMuxedQctrSel : std_logic_vector(1 downto 0);
	signal PreMuxedQctrSel : std_logic_vector(1 downto 0);
	signal MuxedQCtrSel : std_logic_vector(1 downto 0);
	signal PreMuxedQCtrSampleTime : std_logic_vector(1 downto 0);
	signal MuxedQCtrSampleTime : std_logic_vector(1 downto 0);
	signal MuxedQCountDeskew : std_logic_vector(3 downto 0);
	begin
		timestampx: entity work.timestamp
			port map(
				ibus => ibus(15 downto 0),
				obus => obusint(15 downto 0),
				loadtsdiv => LoadMuxedTSDiv,
				readts => ReadMuxedTS,
				readtsdiv => ReadMuxedTSDiv,
				tscount => MuxedTimeStampBus,
				clk => clklow
			);
		qcountratemx: entity work.qcounteratesk
			generic map (clock => ClockLow) -- default is ~8MHz
			port map(
				ibus => ibus(31 downto 0),
				loadRate => LoadMuxedQCountRate,
				rateout => MuxedQcountFilterRate,
				deskewout => MuxedQCountDeskew,
				clk => clklow
			);
		qcountermuxdeskew: entity work.srl16delay
			generic map ( width => 2)
			port map (
			   clk => clklow,
				dlyin => PrePreMuxedQCtrSel,
				dlyout => PreMuxedQCtrSampleTime,
				delay => MuxedQCountDeskew
			);

		nuseprobe2: if not UseMuxedProbe generate
			makemuxedquadcounters: for i in 0 to MuxedQCounters-1 generate
				qcounterx: entity work.qcounter
				generic map (
					BusWidth => BusWidth
				)
				port map (
					obus => obusint,
					ibus => ibus,
					quada => DemuxedQuadA(i),
					quadb => DemuxedQuadB(i),
					index => DemuxedIndex(i),
					loadccr => LoadMuxedQcounterCCR(i),
					readccr => ReadMuxedQcounterCCR(i),
					readcount => ReadMuxedQcounter(i),
					countclear => LoadMuxedQcounter(i),
					timestamp => MuxedTimeStampBus,
					indexmask => MuxedIndexMask(i),
					filterrate => MuxedQCountFilterRate,
					clk =>	clklow
				);
			end generate makemuxedquadcounters;
		end generate nuseprobe2;

		useprobe2: if UseMuxedProbe generate
			makemuxedquadcountersp: for i in 0 to MuxedQCounters-1 generate
				qcounterx: entity work.qcounterp
				generic map (
					BusWidth => BusWidth
				)
				port map (
					obus => obusint,
					ibus => ibus,
					quada => DemuxedQuadA(i),
					quadb => DemuxedQuadB(i),
					index => DemuxedIndex(i),
					loadccr => LoadMuxedQcounterCCR(i),
					readccr => ReadMuxedQcounterCCR(i),
					readcount => ReadMuxedQcounter(i),
					countclear => LoadMuxedQcounter(i),
					timestamp => MuxedTimeStampBus,
					indexmask => MuxedIndexMask(i),
					probe => Probe,
					filterrate => MuxedQCountFilterRate,
					clk =>	clklow
				);
			end generate makemuxedquadcountersp;
		end generate useprobe2;

		nuseprobe3: if not UseMuxedProbe generate
			makemuxedquadcountersmim: for i in 0 to MuxedQCountersMIM-1 generate
				qcounterx: entity work.qcounter
				generic map (
					BusWidth => BusWidth
				)
				port map (
					obus => obusint,
					ibus => ibus,
					quada => DemuxedQuadA(i),
					quadb => DemuxedQuadB(i),
					index => DemuxedIndex(i),
					loadccr => LoadMuxedQcounterCCR(i),
					readccr => ReadMuxedQcounterCCR(i),
					readcount => ReadMuxedQcounter(i),
					countclear => LoadMuxedQcounter(i),
					timestamp => MuxedTimeStampBus,
					indexmask => DeMuxedIndexMask(i),
					filterrate => MuxedQCountFilterRate,
					clk =>	clklow
				);
			end generate makemuxedquadcountersmim;
		end generate nuseprobe3;

		useprobe3: if UseMuxedProbe generate
			makemuxedquadcountersmimp: for i in 0 to MuxedQCountersMIM-1 generate
				qcounterx: entity work.qcounterp
				generic map (
					BusWidth => BusWidth
				)
				port map (
					obus => obusint,
					ibus => ibus,
					quada => DemuxedQuadA(i),
					quadb => DemuxedQuadB(i),
					index => DemuxedIndex(i),
					loadccr => LoadMuxedQcounterCCR(i),
					readccr => ReadMuxedQcounterCCR(i),
					readcount => ReadMuxedQcounter(i),
					countclear => LoadMuxedQcounter(i),
					timestamp => MuxedTimeStampBus,
					indexmask => DeMuxedIndexMask(i),
					probe => Probe,
					filterrate => MuxedQCountFilterRate,
					clk =>	clklow
				);
			end generate makemuxedquadcountersmimp;
		end generate useprobe3;

		MuxedQCounterDecodeProcess : process (Aint,Readstb,writestb,MuxedQCounterSel, MuxedQCounterCCRSel)
		begin
			if Aint(AddrWidth-1 downto 8) = MuxedQCounterAddr then	 --  QCounter select
				MuxedQCounterSel <= '1';
			else
				MuxedQCounterSel <= '0';
			end if;
			if Aint(AddrWidth-1 downto 8) = MuxedQCounterCCRAddr then	 --  QCounter CCR register select
				MuxedQCounterCCRSel <= '1';
			else
				MuxedQCounterCCRSel <= '0';
			end if;
			if Aint(AddrWidth-1 downto 8) = MuxedTSDivAddr and writestb = '1' then	 --
				LoadMuxedTSDiv <= '1';
			else
				LoadMuxedTSDiv <= '0';
			end if;
			if Aint(AddrWidth-1 downto 8) = MuxedTSDivAddr and readstb = '1' then	 --
				ReadMuxedTSDiv <= '1';
			else
				ReadMuxedTSDiv <= '0';
			end if;
			if Aint(AddrWidth-1 downto 8) = MuxedTSAddr and readstb = '1' then	 --
				ReadMuxedTS <= '1';
			else
				ReadMuxedTS <= '0';
			end if;
			if Aint(AddrWidth-1 downto 8) = MuxedQCRateAddr and writestb = '1' then	 --
				LoadMuxedQCountRate <= '1';
			else
				LoadMuxedQCountRate <= '0';
			end if;
			LoadMuxedQCounter <= OneOfNDecode(MuxedQCounters,MuxedQCounterSel,writestb,Aint(7 downto 2));  -- 64 max
			ReadMuxedQCounter <= OneOfNDecode(MuxedQCounters,MuxedQCounterSel,Readstb,Aint(7 downto 2));
			LoadMuxedQCounterCCR <= OneOfNDecode(MuxedQCounters,MuxedQCounterCCRSel,writestb,Aint(7 downto 2));
			ReadMuxedQCounterCCR <= OneOfNDecode(MuxedQCounters,MuxedQCounterCCRSel,Readstb,Aint(7 downto 2));
		end process MuxedQCounterDecodeProcess;

		DoMuxedQCounterPins: process(IOBitsCorein,MuxedQCtrSel)
		begin
			for i in 0 to IOWidth -1 loop				-- loop through all the external I/O pins
				if ThePinDesc(i)(15 downto 8) = MuxedQCountTag then
					case (ThePinDesc(i)(7 downto 0)) is	--secondary pin function
						when MuxedQCountQAPin =>
							MuxedQuadA(conv_integer(ThePinDesc(i)(23 downto 16))) <= IOBitsCorein(i);
						when MuxedQCountQBPin =>
							MuxedQuadB(conv_integer(ThePinDesc(i)(23 downto 16))) <= IOBitsCorein(i);
						when MuxedQCountIdxPin =>
							MuxedIndex(conv_integer(ThePinDesc(i)(23 downto 16))) <= IOBitsCorein(i);
						when MuxedQCountIdxMaskPin =>
							MuxedIndexMask(conv_integer(ThePinDesc(i)(23 downto 16))) <= IOBitsCorein(i);
						when MuxedQCountProbePin =>
							MuxedProbe <= IOBitsCorein(i); -- only 1 please!
						when others => null;
					end case;
				end if;
				if ThePinDesc(i)(15 downto 8) = MuxedQCountSelTag then
					case(ThePinDesc(i)(7 downto 0)) is	--secondary pin function
						when MuxedQCountSel0Pin =>
							CoreDataOut(i) <= MuxedQCtrSel(0);
						when MuxedQCountSel1Pin =>
							CoreDataOut(i) <= MuxedQCtrSel(1);
						when others => null;
					end case;
				end if;
			end loop;
		end process;

		EncoderDeMux: process(clklow)
		begin
			if rising_edge(clklow) then
				if MuxedQCountFilterRate = '1' then
					PrePreMuxedQCtrSel <= PrePreMuxedQCtrSel + 1;
				end if;
				PreMuxedQCtrSel <= PrePreMuxedQCtrSel;
				MuxedQCtrSel <= PreMuxedQCtrSel;		-- the external mux pin
				MuxedQCtrSampleTime <= PreMuxedQCtrSampleTime;
				for i in 0 to ((MuxedQCounters/2) -1) loop -- just 2 deep for now
					if PreMuxedQCtrSampleTime(0) = '1' and MuxedQCtrSampleTime(0) = '0' then	-- latch the even inputs
						DeMuxedQuadA(2*i) <= MuxedQuadA(i);
						DeMuxedQuadB(2*i) <= MuxedQuadB(i);
						DeMuxedIndex(2*i) <= MuxedIndex(i);
					end if;
					if PreMuxedQCtrSampleTime(0) = '0' and MuxedQCtrSampleTime(0) = '1' then	-- latch the odd inputs
						DeMuxedQuadA(2*i+1) <= MuxedQuadA(i);
						DeMuxedQuadB(2*i+1) <= MuxedQuadB(i);
						DeMuxedIndex(2*i+1) <= MuxedIndex(i);
					end if;
				end loop;
			end if; -- clk
		end process;

	end generate makemuxedqcounters;


end dataflow;
