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

entity MakePWMgens is
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
		CoreDataOut :  inout std_logic_vector(IOWidth-1 downto 0) := (others => 'Z');
		IOBitsCorein :  inout std_logic_vector(IOWidth-1 downto 0) := (others => '0');
		clklow : in std_logic;
		clkmed : in std_logic;
		clkhigh : in std_logic;
		Probe : inout std_logic;
		RateSources: out std_logic_vector(4 downto 0) := (others => 'Z');
		rates: out std_logic_vector (4 downto 0)
	);

end MakePWMgens;


architecture dataflow of MakePWMgens is

-- Signals

-- I/O port related signals
	signal RefCountBus : std_logic_vector(PWMRefWidth-1 downto 0);

	begin
	makepwms:  if PWMGens > 0 generate
	signal LoadPWMVal: std_logic_vector(PWMGens -1 downto 0);
	signal LoadPWMCR: std_logic_vector(PWMGens -1 downto 0);
	signal PWMGenOutA: std_logic_vector(PWMGens -1 downto 0);
	signal PWMGenOutB: std_logic_vector(PWMGens -1 downto 0);
	signal PWMGenOutC: std_logic_vector(PWMGens -1 downto 0);
	signal NumberOfPWMS : integer;
	signal LoadPWMRate : std_logic;
	signal LoadPDMRate : std_logic;
	signal PDMRate : std_logic;
	signal PWMValSel : std_logic;
	signal PWMCRSel : std_logic;
	signal LoadPWMEnas: std_logic;
	signal ReadPWMEnas: std_logic;
	begin
		pwmref : entity work.pwmrefh
		generic map (
			buswidth => 16,
			refwidth => PWMRefWidth			-- Normally 13	for 12,11,10, and 9 bit PWM resolutions = 25KHz,50KHz,100KHz,200KHz max. Freq
			)
		port map (
			clk => clklow,
			hclk => clkhigh,
			refcount	=> RefCountBus,
			ibus => ibus(15 downto 0),
			pdmrate => PDMRate,
			pwmrateload => LoadPWMRate,
			pdmrateload => LoadPDMRate
			);
	makepwmena:  if  UsePWMEnas generate
		PWMEnaReg : entity work.boutreg
			generic map (
				size => PWMGens,
				buswidth => BusWidth,
				invert => true			-- Must be true! got changed to false somehow
				)
			port map (
				clk  => clklow,
				ibus => ibus,
				obus => obusint,
				load => LoadPWMEnas,
				read => ReadPWMEnas,
				clear => '0',
				dout => PWMGenOutC
				);
		end generate makepwmena;

	makepwmgens : for i in 0 to PWMGens-1 generate
		pwmgenx: entity work.pwmpdmgenh
		generic map (
			buswidth => BusWidth,
			refwidth => PWMRefWidth			-- Normally 13 for 12,11,10, and 9 bit PWM resolutions = 25KHz,50KHz,100KHz,200KHz max. Freq
			)
		port map (
			clk => clklow,
			hclk => clkhigh,
			refcount	=> RefCountBus,
			ibus => ibus,
			loadpwmval => LoadPWMVal(i),
			pcrloadcmd => LoadPWMCR(i),
			pdmrate => PDMRate,
			pwmouta => PWMGenOutA(i),
			pwmoutb => PWMGenOutB(i)
			);
		end generate;

		PWMDecodeProcess : process (Aint,Readstb,writestb,PWMValSel, PWMCRSel)
		begin
			if Aint(AddrWidth-1 downto 8) = PWMRateAddr and writestb = '1' then	 --
				LoadPWMRate <= '1';
			else
				LoadPWMRate <= '0';
			end if;
			if Aint(AddrWidth-1 downto 8) = PDMRateAddr and writestb = '1' then	 --
				LoadPDMRate <= '1';
			else
				LoadPDMRate <= '0';
			end if;
			if Aint(AddrWidth-1 downto 8) = PWMEnasAddr and writestb = '1' then	 --
				LoadPWMEnas <= '1';
			else
				LoadPWMEnas <= '0';
			end if;
			if Aint(AddrWidth-1 downto 8) = PWMEnasAddr and readstb = '1' then	 --
				ReadPWMEnas <= '1';
			else
				ReadPWMEnas <= '0';
			end if;
			if Aint(AddrWidth-1 downto 8) = PWMValAddr then	 --  PWMVal select
				PWMValSel <= '1';
			else
				PWMValSel <= '0';
			end if;
			if Aint(AddrWidth-1 downto 8) = PWMCRAddr then	 --  PWM mode register select
				PWMCRSel <= '1';
			else
				PWMCRSel <= '0';
			end if;
			LoadPWMVal <= OneOfNDecode(PWMGENs,PWMValSel,writestb,Aint(7 downto 2)); -- 64 max
			LoadPWMCR <= OneOfNDecode(PWMGENs,PWMCRSel,writestb,Aint(7 downto 2));
		end process PWMDecodeProcess;

		DoPWMPins: process(PWMGenOutA,PWMGenOutB,PWMGenOutC)
		begin
			for i in 0 to IOWidth -1 loop				-- loop through all the external I/O pins
				if ThePinDesc(i)(15 downto 8) = PWMTag then
					case (ThePinDesc(i)(7 downto 0)) is	--secondary pin function
						when PWMAOutPin =>
							CoreDataOut(i) <= PWMGENOutA(conv_integer(ThePinDesc(i)(23 downto 16)));
						when PWMBDirPin =>
							CoreDataOut(i) <= PWMGENOutB(conv_integer(ThePinDesc(i)(23 downto 16)));
						when PWMCEnaPin =>
							CoreDataOut(i) <= PWMGENOutC(conv_integer(ThePinDesc(i)(23 downto 16)));
						when others => null;
					end case;
				end if;
			end loop;
		end process;
	end generate makepwms;

end dataflow;
