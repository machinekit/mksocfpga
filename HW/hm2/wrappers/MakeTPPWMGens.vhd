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

entity MakeTPPWMGens is
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

end MakeTPPWMGens;


architecture dataflow of MakeTPPWMGens is

-- Signals

-- I/O port related signals
	signal RefCountBus : std_logic_vector(PWMRefWidth-1 downto 0);

	begin
	maketppwmref:  if (TPPWMGens > 0) generate
	signal LoadTPPWMVal: std_logic_vector(TPPWMGens -1 downto 0);
	signal LoadTPPWMENA: std_logic_vector(TPPWMGens -1 downto 0);
	signal ReadTPPWMENA: std_logic_vector(TPPWMGens -1 downto 0);
	signal LoadTPPWMDZ: std_logic_vector(TPPWMGens -1 downto 0);
	signal TPPWMGenOutA: std_logic_vector(TPPWMGens -1 downto 0);
	signal TPPWMGenOutB: std_logic_vector(TPPWMGens -1 downto 0);
	signal TPPWMGenOutC: std_logic_vector(TPPWMGens -1 downto 0);
	signal NTPPWMGenOutA: std_logic_vector(TPPWMGens -1 downto 0);
	signal NTPPWMGenOutB: std_logic_vector(TPPWMGens -1 downto 0);
	signal NTPPWMGenOutC: std_logic_vector(TPPWMGens -1 downto 0);
	signal TPPWMEna: std_logic_vector(TPPWMGens -1 downto 0);
	signal TPPWMFault: std_logic_vector(TPPWMGens -1 downto 0);
	signal TPPWMSample: std_logic_vector(TPPWMGens -1 downto 0);
	signal LoadTPPWMRate : std_logic;
	signal TPRefCountBus : std_logic_vector(10 downto 0);
	signal TPPWMValSel : std_logic;
	signal TPPWMEnaSel : std_logic;
	signal TPPWMDZSel : std_logic;
	begin
		tppwmref : entity work.pwmrefh
		generic map (
			BusWidth => 16,
			refwidth => 11			-- always 11 for TPPWM
			)
		port map (
			clk => clklow,
			hclk => clkhigh,
			refcount	=> TPRefCountBus,
			ibus => ibus(15 downto 0),
			pwmrateload => LoadTPPWMRate,
			pdmrateload => '0'
			);

		maketppwmgens : for i in 0 to TPPWMGens-1 generate
			tppwmgenx: entity work.threephasepwm
			port map (
				clk => clklow,
				hclk => clkhigh,
				refcount => TPRefCountBus,
				ibus => ibus,
				obus => obusint,
				loadpwmreg => LoadTPPWMVal(i),
				loadenareg => LoadTPPWMENA(i),
				readenareg => ReadTPPWMENA(i),
				loaddzreg => LoadTPPWMDZ(i),
				pwmouta => TPPWMGenOutA(i),
				pwmoutb => TPPWMGenOutB(i),
				pwmoutc => TPPWMGenOutC(i),
				npwmouta => NTPPWMGenOutA(i),
				npwmoutb => NTPPWMGenOutB(i),
				npwmoutc => NTPPWMGenOutC(i),
				pwmenaout => TPPWMEna(i),
				pwmfault => TPPWMFault(i),
				pwmsample => TPPWMSample(i)

				);
		end generate;

		TPPWMDecodeProcess : process (Aint,Readstb,writestb,TPPWMValSel, TPPWMEnaSel,TPPWMDZSel)
		begin
			if Aint(AddrWidth-1 downto 8) = TPPWMValAddr then	 --  TPPWMVal select
				TPPWMValSel <= '1';
			else
				TPPWMValSel <= '0';
			end if;
			if Aint(AddrWidth-1 downto 8) = TPPWMEnaAddr then	 --  TPPWM mode register select
				TPPWMEnaSel <= '1';
			else
				TPPWMEnaSel <= '0';
			end if;
			if Aint(AddrWidth-1 downto 8) = TPPWMDZAddr then	 --  TPPWMDZ mode register select
				TPPWMDZSel <= '1';
			else
				TPPWMDZSel <= '0';
			end if;
			if Aint(AddrWidth-1 downto 8) = TPPWMRateAddr and writestb = '1' then	 --
				LoadTPPWMRate <= '1';
			else
				LoadTPPWMRate <= '0';
			end if;
			LoadTPPWMVal <= OneOfNDecode(TPPWMGENs,TPPWMValSel,writestb,Aint(7 downto 2)); -- 64 max
			LoadTPPWMEna <= OneOfNDecode(TPPWMGENs,TPPWMEnaSel,writestb,Aint(7 downto 2));
			ReadTPPWMEna <= OneOfNDecode(TPPWMGENs,TPPWMEnaSel,Readstb,Aint(7 downto 2));
			LoadTPPWMDZ <= OneOfNDecode(TPPWMGENs,TPPWMDZSel,writestb,Aint(7 downto 2));
		end process TPPWMDecodeProcess;

		DoTPPWMPins: process(TPPWMGenOutA,TPPWMGenOutB,TPPWMGenOutC,
									NTPPWMGenOutA,NTPPWMGenOutB,NTPPWMGenOutC,TPPWMEna)
		begin
			for i in 0 to IOWidth -1 loop				-- loop through all the external I/O pins
				if ThePinDesc(i)(15 downto 8) = TPPWMTag then
					case (ThePinDesc(i)(7 downto 0)) is	--secondary pin function
						when TPPWMAOutPin =>
							CoreDataOut(i) <= TPPWMGENOutA(conv_integer(ThePinDesc(i)(23 downto 16)));
						when TPPWMBOutPin =>
							CoreDataOut(i) <= TPPWMGENOutB(conv_integer(ThePinDesc(i)(23 downto 16)));
						when TPPWMCOutPin =>
							CoreDataOut(i) <= TPPWMGENOutC(conv_integer(ThePinDesc(i)(23 downto 16)));
						when NTPPWMAOutPin =>
							CoreDataOut(i) <= NTPPWMGENOutA(conv_integer(ThePinDesc(i)(23 downto 16)));
						when NTPPWMBOutPin =>
							CoreDataOut(i) <= NTPPWMGENOutB(conv_integer(ThePinDesc(i)(23 downto 16)));
						when NTPPWMCOutPin =>
							CoreDataOut(i) <= NTPPWMGENOutC(conv_integer(ThePinDesc(i)(23 downto 16)));
						when TPPWMEnaPin =>
							CoreDataOut(i) <= TPPWMEna(conv_integer(ThePinDesc(i)(23 downto 16)));
						when TPPWMFaultPin =>
							TPPWMFault(conv_integer(ThePinDesc(i)(23 downto 16))) <= IOBitsCorein(i);
						when others => null;
					end case;
				end if;
			end loop;
		end process;
	end generate maketppwmref;

end dataflow;
