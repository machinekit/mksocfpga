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

entity MakeHm2Dpllmods is
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
		Aint : in std_logic_vector(AddrWidth -1 downto 2);
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

end MakeHm2Dpllmods;


architecture dataflow of MakeHm2Dpllmods is

-- Signals

-- I/O port related signals
	signal RefCountBus : std_logic_vector(PWMRefWidth-1 downto 0);
-- Timer related signals
	signal DPLLTimers: std_logic_vector(3 downto 0);
	signal DPLLRefOut: std_logic;

	begin

	makehm2dpllmod:  if HM2DPLLs >0  generate
	signal LoadDPLLBaseRate: std_logic;
	signal ReadDPLLBaseRate: std_logic;
	signal LoadDPLLPhase: std_logic;
	signal ReadDPLLPhase: std_logic;
	signal LoadDPLLControl0: std_logic;
	signal ReadDPLLControl0: std_logic;
	signal LoadDPLLControl1: std_logic;
	signal ReadDPLLControl1: std_logic;
	signal LoadDPLLTimers12: std_logic;
	signal ReadDPLLTimers12: std_logic;
	signal LoadDPLLTimers34: std_logic;
	signal ReadDPLLTimers34: std_logic;
	signal ReadSyncDPLL: std_logic;
	signal WriteSyncDPLL: std_logic;
	signal DPLLSyncIn: std_logic;

	begin
		hm2dpll: entity work.HM2DPLL
		port  map (
			clk => clklow,
			ibus => ibus,
			obus => obusint,
			loadbaserate => LoadDPLLBaseRate,
			readbaserate => ReadDPLLBaseRate,
			loadphase => LoadDPLLPhase,
			readphase => ReadDPLLPhase,
			loadcontrol0 => LoadDPLLControl0,
			readcontrol0 => ReadDPLLControl0,
			loadcontrol1 => LoadDPLLControl1,
			readcontrol1 => ReadDPLLControl1,
			loadtimers12 => LoadDPLLTimers12,
			readtimers12 => ReadDPLLTimers12,
			loadtimers34 => LoadDPLLTimers34,
			readtimers34 => ReadDPLLTimers34,
			syncwrite => WriteSyncDPLL,
			syncread	=> ReadSyncDPLL,
			syncin => DPLLSyncIn,
			timerout => DPLLTimers,
			refout	=> DPLLRefOut
		);
		HM2DPLLDecodeProcess : process (Aint,Readstb,writestb,DPLLTimers,RateSources,DPLLRefOut)
		begin
			if Aint(AddrWidth-1 downto 8) = HM2DPLLBaseRateAddr and writestb = '1' then	 --
				LoadDPLLBaseRate <= '1';
			else
				LoadDPLLBaseRate <= '0';
			end if;
			if Aint(AddrWidth-1 downto 8) = HM2DPLLBaseRateAddr and readstb = '1' then	 --
				ReadDPLLBaseRate <= '1';
			else
				ReadDPLLBaseRate <= '0';
			end if;

			if Aint(AddrWidth-1 downto 8) = HM2PhaseErrAddr and writestb = '1' then	 --
				LoadDPLLPhase <= '1';
			else
				LoadDPLLPhase <= '0';
			end if;
			if Aint(AddrWidth-1 downto 8) = HM2PhaseErrAddr and readstb = '1' then	 --
				ReadDPLLPhase <= '1';
			else
				ReadDPLLPhase <= '0';
			end if;

			if Aint(AddrWidth-1 downto 8) = HM2DPLLControl0Addr and writestb = '1' then	 --
				LoadDPLLControl0 <= '1';
			else
				LoadDPLLControl0 <= '0';
			end if;
			if Aint(AddrWidth-1 downto 8) = HM2DPLLControl0Addr and readstb = '1' then	 --
				ReadDPLLControl0 <= '1';
			else
				ReadDPLLControl0 <= '0';
			end if;

			if Aint(AddrWidth-1 downto 8) = HM2DPLLControl1Addr and writestb = '1' then	 --
				LoadDPLLControl1 <= '1';
			else
				LoadDPLLControl1 <= '0';
			end if;
			if Aint(AddrWidth-1 downto 8) = HM2DPLLControl1Addr and readstb = '1' then	 --
				ReadDPLLControl1 <= '1';
			else
				ReadDPLLControl1 <= '0';
			end if;

			if Aint(AddrWidth-1 downto 8) = HM2DPLLTimer12Addr and writestb = '1' then	 --
				LoadDPLLTimers12 <= '1';
			else
				LoadDPLLTimers12 <= '0';
			end if;
			if Aint(AddrWidth-1 downto 8) = HM2DPLLTimer12Addr and readstb = '1' then	 --
				ReadDPLLTimers12 <= '1';
			else
				ReadDPLLTimers12 <= '0';
			end if;

			if Aint(AddrWidth-1 downto 8) = HM2DPLLTimer34Addr and writestb = '1' then	 --
				LoadDPLLTimers34 <= '1';
			else
				LoadDPLLTimers34 <= '0';
			end if;
			if Aint(AddrWidth-1 downto 8) = HM2DPLLTimer34Addr and readstb = '1' then	 --
				ReadDPLLTimers34 <= '1';
			else
				ReadDPLLTimers34 <= '0';
			end if;

			if Aint(AddrWidth-1 downto 8) = HM2DPLLSyncAddr and writestb = '1' then	 --
				WriteSyncDPLL <= '1';
			else
				WriteSyncDPLL <= '0';
			end if;
			if Aint(AddrWidth-1 downto 8) = HM2DPLLSyncAddr and readstb = '1' then	 --
				ReadSyncDPLL <= '1';
			else
				ReadSyncDPLL <= '0';
			end if;
			RateSources <= DPLLTimers&DPLLRefOut;
			rates <= RateSources;
		end process HM2DPLLDecodeProcess;

		DoHM2DPLLPins: process(DPLLTimers,DPLLRefOut)
		begin
			for i in 0 to IOWidth -1 loop				-- loop through all the external I/O pins
				if ThePinDesc(i)(15 downto 8) = HM2DPLLTag then 	-- this hideous masking of pinnumbers/vs pintype is why they should be separate bytes, maybe IDROM type 4...
					case (ThePinDesc(i)(7 downto 0)) is
						when HM2DPLLSyncInPin =>
							DPLLSyncIn <= IOBitsCorein(i);
						when HM2DPLLRefOutPin =>
							CoreDataOut(i) <= DPLLRefOut;
						when HM2DPLLTimer1Pin =>
							CoreDataOut(i) <= DPLLTimers(0);
						when HM2DPLLTimer2Pin =>
							CoreDataOut(i) <= DPLLTimers(1);
						when HM2DPLLTimer3Pin =>
							CoreDataOut(i) <= DPLLTimers(2);
						when HM2DPLLTimer4Pin =>
							CoreDataOut(i) <= DPLLTimers(3);
						when others => null;

					end case;
				end if;
			end loop;
		end process;
	end generate;

end dataflow;
