
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
use work.NumberOfModules.all;
use work.MaxInputPinsPerModule.all;

entity MakeIOPorts is
	generic (
		ThePinDesc: PinDescType := PinDesc;
		TheModuleID: ModuleIDType := ModuleID;
		IDROMType: integer;
-- 		SepClocks: boolean;
-- 		OneWS: boolean;
		OffsetToModules: integer;
		OffsetToPinDesc: integer;
		ClockHigh: integer;
		ClockLow: integer;
		BoardNameLow : std_Logic_Vector(31 downto 0);
		BoardNameHigh : std_Logic_Vector(31 downto 0);
		FPGASize: integer;
		FPGAPins: integer;
		IOPorts: integer;
		IOWidth: integer;
		PortWidth: integer;
		InstStride0: integer;
		InstStride1: integer;
		RegStride0: integer;
		RegStride1: integer;
--
--		ClockMed: integer;
		BusWidth: integer;
		AddrWidth: integer;
--		STEPGENs: integer;
--		StepGenTableWidth: integer;
--		UseStepGenPreScaler: boolean;
--		UseStepgenIndex: boolean;
--		UseStepgenProbe: boolean;
--		timersize: integer;			-- = ~480 usec at 33 MHz, ~320 at 50 Mhz
--		asize: integer;
--		rsize: integer;
--		PWMGens: integer;
--		PWMRefWidth  : integer;
-- 		UsePWMEnas : boolean;
--		QCounters: integer;
--		UseMuxedProbe: boolean;
--		UseProbe: boolean;
		UseWatchDog: boolean;
		UseDemandModeDMA: boolean;
		UseIRQlogic: boolean;
		LEDCount: integer);
	Port (
-- 		inbus : in std_logic_vector(BusWidth -1 downto 0) := (others => 'Z');
		ibustop : in std_logic_vector(BusWidth -1 downto 0);
		ibusint : out std_logic_vector(BusWidth -1 downto 0) := (others => 'Z');
		obustop : out std_logic_vector(BusWidth -1 downto 0);
 		obusint : in std_logic_vector(BusWidth -1 downto 0);
		addr : in std_logic_vector(AddrWidth -1 downto 2);
 		Aint : out std_logic_vector(AddrWidth -1 downto 2);
		readstb : in std_logic;
		writestb : in std_logic;
		iobitsouttop :  out std_logic_vector(IOWidth-1 downto 0) := (others => 'Z');
		iobitsintop :  in std_logic_vector(IOWidth-1 downto 0) := (others => 'Z');
		IOBitsCorein :  out std_logic_vector(IOWidth-1 downto 0);
		CoreDataOut :  in std_logic_vector(IOWidth-1 downto 0) := (others => '0');
--		iobitstop :  inout std_logic_vector(IOWidth-1 downto 0) := (others => '0');
--		AltData :  inout std_logic_vector(IOWidth-1 downto 0) := (others => '0');
		clklow : in std_logic;
		clkmed : in std_logic;
		clkhigh : in std_logic;
		Probe : inout std_logic;
		demandmode: out std_logic;
		intirq: out std_logic;
		dreq: out std_logic;
		RateSources: std_logic_vector(4 downto 0) := (others => 'Z');
		LEDS: out std_logic_vector(ledcount-1 downto 0)
	);

end MakeIOPorts;


architecture dataflow of MakeIOPorts is

--- IDRom
	constant FWIDs: integer := NumberOfModules(TheModuleID,FWIDTag);
	constant NDRQs: integer := NumberOfModules(TheModuleID,DAQFIFOTag); -- + any other drq sources that are used

	constant DAQFIFOs: integer := NumberOfModules(TheModuleID,DAQFIFOTag);
	constant DAQFIFOWidth: integer := MaxInputPinsPerModule(ThePinDesc,DAQFIFOTag); -- until I find a per instance way of doing this

-- Signals
    signal Adr: std_logic_vector(AddrWidth -1 downto 2);
	signal LoadIDROM: std_logic;
	signal ReadIDROM: std_logic;

	signal LoadIDROMWEn: std_logic;
	signal ReadIDROMWEn: std_logic;

	signal IDROMWEn: std_logic_vector(0 downto 0);
	signal ROMAdd: std_logic_vector(7 downto 0);

	signal ReadFWID: std_logic;

	signal PortSel: std_logic;

-- I/O port related signals
--	signal RefCountBus : std_logic_vector(PWMRefWidth-1 downto 0);
	signal LoadPortCmd: std_logic_vector(IOPorts -1 downto 0);
	signal ReadPortCmd: std_logic_vector(IOPorts -1 downto 0);

	signal DDRSel: std_logic;
	signal LoadDDRCmd: std_logic_vector(IOPorts -1 downto 0);
	signal ReadDDRCmd: std_logic_vector(IOPorts -1 downto 0);
	signal AltDataSrcSel: std_logic;
	signal LoadAltDataSrcCmd: std_logic_vector(IOPorts -1 downto 0);
	signal OpenDrainModeSel: std_logic;
	signal LoadOpenDrainModeCmd: std_logic_vector(IOPorts -1 downto 0);
	signal OutputInvSel: std_logic;
	signal LoadOutputInvCmd: std_logic_vector(IOPorts -1 downto 0);

--- Watchdog related signals
	signal LoadWDTime : std_logic;
	signal ReadWDTime : std_logic;
	signal LoadWDStatus : std_logic;
	signal ReadWDStatus : std_logic;
	signal WDCookie: std_logic;
	signal WDBite : std_logic;
	signal WDLatchedBite : std_logic;

--- LED related signals
	signal LoadLEDS : std_logic;

--- Demand mode DMA related signals
	signal LoadDMDMAMode: std_logic;
	signal ReadDMDMAMode: std_logic;
	signal DRQSources: std_logic_vector(NDRQs -1 downto 0);

--- ID related signals
	signal ReadID : std_logic;

	begin

	obustop <= obusint;
	ibusint <= ibustop;
	IOBitsCorein <= iobitsintop;

	ahosmotid : entity work.hostmotid
	generic map (
		buswidth => BusWidth,
		cookie => Cookie,
		namelow => HostMotNameLow ,
		namehigh => HostMotNameHigh,
		idromoffset => IDROMOffset
	)
	port map (
		readid => ReadID,
		addr => addr(3 downto 2),
		obus => obustop
	);

	makeoports: for i in 0 to IOPorts -1 generate
		oportx: entity work.WordPR
		generic map (
			size => PortWidth,
			buswidth => BusWidth
			)
		port map (
			clear => WDBite,
			clk => clklow,
			ibus => ibustop,
			obus => obustop,
			loadport => LoadPortCmd(i),
			loadddr => LoadDDRCmd(i),
			loadaltdatasrc => LoadAltDataSrcCmd(i),
			loadopendrainmode => LoadOpenDrainModeCmd(i),
			loadinvert => LoadOutputInvCmd(i),
			readddr => ReadDDRCmd(i),
			portdata => iobitsouttop((((i+1)*PortWidth) -1) downto (i*PortWidth)),
			altdata => CoreDataOut((((i+1)*PortWidth) -1) downto (i*PortWidth))
			);
	end generate;

	makeiports: for i in 0 to IOPorts -1 generate
		iportx: entity work.WordRB
		generic map (
			size => PortWidth,
			buswidth => BusWidth
		)
		port map (
		obus => obustop,
		readport => ReadPortCmd(i),
		portdata => iobitsintop((((i+1)*PortWidth) -1) downto (i*PortWidth))
 		);
	end generate;

	PortDecode: process (Adr,readstb,writestb,PortSel, DDRSel, AltDataSrcSel, OpenDrainModeSel, OutputInvSel)
	begin

		LoadPortCMD <= OneOfNDecode(IOPorts,PortSel,writestb,Adr(4 downto 2)); -- 8 max
		ReadPortCMD <= OneOfNDecode(IOPorts,PortSel,readstb,Adr(4 downto 2));
		LoadDDRCMD <= OneOfNDecode(IOPorts,DDRSel,writestb,Adr(7 downto 2));
		ReadDDRCMD <= OneOfNDecode(IOPorts,DDRSel,readstb,Adr(7 downto 2));

		LoadAltDataSrcCMD <= OneOfNDecode(IOPorts,AltDataSrcSel,writestb,Adr(4 downto 2));
		LoadOpenDrainModeCMD <= OneOfNDecode(IOPorts,OpenDrainModeSel,writestb,Adr(4 downto 2));
		LoadOutputInvCMD <= OneOfNDecode(IOPorts,OutputInvSel,writestb,Adr(4 downto 2));

	end process PortDecode;

	makewatchdog: if UseWatchDog generate
		wdogabittus: entity work.watchdog
		generic map ( buswidth => BusWidth)

		port map (
			clk => clklow,
			ibus => ibustop,
			obus => obustop,
			loadtime => LoadWDTime,
			readtime => ReadWDTime,
			loadstatus=> LoadWDStatus,
			readstatus=> ReadWDStatus,
			cookie => WDCookie,
			wdbite => WDBite,
			wdlatchedbite => WDLatchedBite
			);
		end generate;

	makedrqlogic: if UseDemandModeDMA generate
		somolddrqlogic: entity work.dmdrqlogic
		generic map( ndrqs => NDRQs )
		port map(
			clk => clklow,
			ibus => ibustop,
			obus => obustop,
			loadmode => LoadDMDMAMode,
			readmode => ReadDMDMAMode,
			drqsources => DRQSources,
			dreqout => dreq,					-- passed directly to top
			demandmode => demandmode		-- passed directly to top
			);
		end generate;

	makenodrqlogic: if not UseDemandModeDMA generate
		dreq <= '0';							-- passed directly to top
		demandmode <= '0';					-- passed directly to top
	end generate;

	makeirqlogic: if UseIRQlogic generate
	signal LoadIRQStatus : std_logic;
	signal ReadIrqStatus : std_logic;
	signal ClearIRQ : std_logic;
	begin
	somoldirqlogic: entity work.irqlogics
		generic map(
			buswidth =>  BusWidth
				)
		port map (
			clk => clklow,
			ibus => ibustop,
         obus =>  obustop,
         loadstatus => LoadIRqStatus,
         readstatus => ReadIRqStatus,
         clear =>  ClearIRQ,
         ratesource => RateSources, -- DPLL timer channels, channel 4 is refout
         int => INTIRQ);

		IRQDecodePRocess: process(Adr,readstb,writestb)
		begin
			if Adr(15 downto 8) = IRQStatusAddr and writestb = '1' then	 --
				LoadIRQStatus <= '1';
			else
				LoadIRQStatus <= '0';
			end if;
			if Adr(15 downto 8) = IRQStatusAddr and readstb = '1' then	 --
				ReadIrqStatus <= '1';
			else
				ReadIrqStatus <= '0';
			end if;
			if Adr(15 downto 8) = ClearIRQAddr and writestb = '1' then	 --
				ClearIRQ <= '1';
			else
				ClearIRQ <= '0';
			end if;
		end process;

	end generate;

	IDROMWP : entity work.boutreg
 		generic map (
			size => 1,
			buswidth => BusWidth,
			invert => false
			)
		port map (
            clk  => clklow,
            ibus => ibustop,
            obus => obustop,
            load => LoadIDROMWEn,
            read => ReadIDROMWEn,
            clear => '0',
            dout => IDROMWen
		);

	IDROM : entity work.IDROM
		generic map (
			idromtype => IDROMType,
			offsettomodules => OffsetToModules,
			offsettopindesc => OffsetToPinDesc,
			boardnamelow => BoardNameLow,
			boardnameHigh => BoardNameHigh,
			fpgasize => FPGASize,
			fpgapins => FPGAPins,
			ioports => IOPorts,
			iowidth => IOWidth,
			portwidth => PortWidth,
			clocklow => ClockLow,
			clockhigh => ClockHigh,
			inststride0 => InstStride0,
			inststride1 => InstStride1,
			regstride0 => RegStride0,
			regstride1 => RegStride1,
			pindesc => ThePinDesc,
			moduleid => TheModuleID)
		port map (
			clk  => clklow,
			we   => LoadIDROM,
			re   => ReadIDROM,
			radd => addr(9 downto 2),
			wadd => Adr(9 downto 2),
			din  => ibustop,
			dout => obustop
		);

	makeFWID : if FWIDs > 0 generate
	begin
		FirmwareID : entity work.firmware_id
			port map (
				clk  => clklow,
				re   => ReadFWID,
				radd => addr(10 downto 2),
				dout => obustop
			);
	end generate;

   LooseEnds: process(Adr,clklow)
	begin
		if rising_edge(clklow) then
			Adr <= addr;
			Aint <= addr;
		end if;
	end process;

	Decode: process(Adr,writestb, IDROMWEn, readstb)
	begin
		-- basic multi decodes are at 256 byte increments (64 longs)
		-- first decode is 256 x 32 ID ROM
		-- these need to all be updated to the decoded strobe function instead of if_then_else

		if (Adr(15 downto 10) = IDROMAddr(7 downto 2)) and writestb = '1' and IDROMWEn = "1" then	 -- 400 Hex
			LoadIDROM <= '1';
		else
			LoadIDROM <= '0';
		end if;
		if (Adr(15 downto 10) = IDROMAddr(7 downto 2)) and readstb = '1' then	 --
			ReadIDROM <= '1';
		else
			ReadIDROM <= '0';
		end if;

		if Adr(15 downto 8) = PortAddr then  -- basic I/O port select
			PortSel <= '1';
		else
			PortSel <= '0';
		end if;

		if Adr(15 downto 8) = DDRAddr then	 -- DDR register select
			DDRSel <= '1';
		else
			DDRSel <= '0';
		end if;

		if Adr(15 downto 8) = AltDataSrcAddr then  -- Alt data source register select
			AltDataSrcSel <= '1';
		else
			AltDataSrcSel <= '0';
		end if;

		if Adr(15 downto 8) = OpenDrainModeAddr then	 --  OpenDrain  register select
			OpendrainModeSel <= '1';
		else
			OpenDrainModeSel <= '0';
		end if;

		if Adr(15 downto 8) = OutputInvAddr then	 --  IO invert register select
			OutputInvSel <= '1';
		else
			OutputInvSel <= '0';
		end if;

		if Adr(15 downto 8) = ReadIDAddr and readstb = '1' then	 --
			ReadID <= '1';
		else
			ReadID <= '0';
		end if;

		if Adr(15 downto 8) = WatchdogTimeAddr and readstb = '1' then	 --
			ReadWDTime <= '1';
		else
			ReadWDTime <= '0';
		end if;
		if Adr(15 downto 8) = WatchdogTimeAddr and writestb = '1' then	 --
			LoadWDTime <= '1';
		else
			LoadWDTime <= '0';
		end if;

		if Adr(15 downto 8) = WatchdogStatusAddr and readstb = '1' then	 --
			ReadWDStatus <= '1';
		else
			ReadWDStatus <= '0';
		end if;
		if Adr(15 downto 8) = WatchdogStatusAddr and writestb = '1' then	 --
			LoadWDStatus <= '1';
		else
			LoadWDStatus <= '0';
		end if;

		if Adr(15 downto 8) = WatchdogCookieAddr and writestb = '1' then	 --
			WDCookie <= '1';
		else
			WDCookie <= '0';
		end if;

		if Adr(15 downto 8) = DMDMAModeAddr and writestb = '1' then	 --
			LoadDMDMAMode <= '1';
		else
			LoadDMDMAMode <= '0';
		end if;

		if Adr(15 downto 8) = DMDMAModeAddr and readstb = '1' then	 --
			ReadDMDMAMode <= '1';
		else
			ReadDMDMAMode <= '0';
		end if;

		if Adr(15 downto 8) = IDROMWEnAddr and writestb = '1' then	 --
			LoadIDROMWEn <= '1';
		else
			LoadIDROMWEn <= '0';
		end if;

		if Adr(15 downto 8) = IDROMWEnAddr and readstb = '1' then	 --
			ReadIDROMWEn <= '1';
		else
			ReadIDROMWEn <= '0';
		end if;

		if Adr(15 downto 8) = LEDAddr and writestb = '1' then	 --
			LoadLEDs <= '1';
		else
			LoadLEDs <= '0';
		end if;

		--  Firmware ID ProtoBuf Message : 2K Bytes
		if Adr(15 downto 11) = FWIDAddr(7 downto 3) and readstb = '1' then
			ReadFWID <= '1';
		else
			ReadFWID <= '0';
		end if;

	end process;

	dotieupint: if not UseIRQLogic generate
		tieupint : process(clklow)
		begin
			INTIRQ <= '1';
		end process;
	end generate;

	drqrouting: if UseDemandModeDMA generate

	end generate;

	LEDReg : entity work.boutreg
	generic map (
		size => LEDCount,
		BusWidth => LEDCount,
		invert => true)
	port map (
		clk  => clklow,
		ibus => ibustop(BusWidth-1 downto BusWidth-LEDCount),
		obus => obustop(BusWidth-1 downto BusWidth-LEDCount),
		load => LoadLEDs,
		read => '0',
		clear => '0',
		dout => LEDS
		);

--
-- 	makedaqfifomod:  if DAQFIFOs >0  generate
-- 	signal ReadDAQFIFO: std_logic_vector(DAQFIFOs-1 downto 0);
-- 	signal ReadDAQFIFOCount: std_logic_vector(DAQFIFOs-1 downto 0);
-- 	signal ClearDAQFIFO: std_logic_vector(DAQFIFOs-1 downto 0);
-- 	signal LoadDAQFIFOMode: std_logic_vector(DAQFIFOs-1 downto 0);
-- 	signal ReadDAQFIFOMode: std_logic_vector(DAQFIFOs-1 downto 0);
-- 	signal PushDAQFIFOFrac: std_logic_vector(DAQFIFOs-1 downto 0);
-- 	type DAQFIFODataType is array(DAQFIFOs-1 downto 0) of std_logic_vector(DAQFIFOWidth-1 downto 0);
-- 	signal DAQFIFOData: DAQFIFODataType;
-- 	signal DAQFIFOFull: std_logic_vector(DAQFIFOs-1 downto 0);
-- 	signal DAQFIFOStrobe: std_logic_vector(DAQFIFOs-1 downto 0);
-- 	signal DAQFIFODataSel : std_logic;
-- 	signal DAQFIFOCountSel : std_logic;
-- 	signal DAQFIFOModeSel : std_logic;
-- 	signal DAQFIFOReq: std_logic_vector(DAQFIFOs-1 downto 0);
-- 	begin
-- 		DRQSources <= DAQFIFOReq;			-- this will grow as other demand mode DMA sources are added
-- 		makedaqfifos: for i in 0 to DAQFIFOs -1 generate
-- 			adaqfifo: entity work.DAQFIFO16				-- need to parametize width
-- 			generic map (
-- 				depth => 2048									-- this needs to be in module header
-- 				)
-- 			port  map (
-- 				clk => clklow,
-- 				ibus => ibustop,
-- 				obus => obustop,
-- 				readfifo => ReadDAQFIFO(i),
-- 				readfifocount => ReadDAQFIFOCount(i),
-- 				clearfifo =>  ClearDAQFIFO(i),
-- 				loadmode =>  LoadDAQFIFOMode(i),
-- 				readmode =>  ReadDAQFIFOMode(i) ,
-- 				pushfrac =>  PushDAQFIFOFrac(i),
-- 				daqdata =>   DAQFIFOData(i),
-- 				daqfull =>   DAQFIFOFull(i),
-- 				daqreq => 	 DAQFIFOReq(i),
-- 				daqstrobe => DAQFIFOStrobe(i)
-- 				);
-- 		end generate;
--
-- 		DAQFIFODecodeProcess : process (Adr,Readstb,writestb,DAQFIFODataSel,DAQFIFOCountSel,DAQFIFOModeSel)
-- 		begin
-- 			if Adr(15 downto 8) = DAQFIFODataAddr then
-- 				DAQFIFODataSel <= '1';
-- 			else
-- 				DAQFIFODataSel <= '0';
-- 			end if;
-- 			if Adr(15 downto 8) = DAQFIFOCountAddr then
-- 				DAQFIFOCountSel <= '1';
-- 			else
-- 				DAQFIFOCountSel <= '0';
-- 			end if;
-- 			if Adr(15 downto 8) = DAQFIFOModeAddr then
-- 				DAQFIFOModeSel <= '1';
-- 			else
-- 				DAQFIFOModeSel <= '0';
-- 			end if;
-- 			ReadDAQFIFO <= OneOfNDecode(DAQFIFOs,DAQFIFODataSel,Readstb,Adr(7 downto 6));	-- 16 addresses per fifo to allow burst reads
-- 			PushDAQFIFOFrac <= OneOfNDecode(DAQFIFOs,DAQFIFODataSel,writestb,Adr(5 downto 2));
-- 			ReadDAQFIFOCount <= OneOfNDecode(DAQFIFOs,DAQFIFOCountSel,Readstb,Adr(5 downto 2));
-- 			ClearDAQFIFO <= OneOfNDecode(DAQFIFOs,DAQFIFOCountSel,writestb,Adr(5 downto 2));
-- 			ReadDAQFIFOMode <= OneOfNDecode(DAQFIFOs,DAQFIFOModeSel,Readstb,Adr(5 downto 2));
-- 			LoadDAQFIFOMode <= OneOfNDecode(DAQFIFOs,DAQFIFOModeSel,writestb,Adr(5 downto 2));
-- 		end process DAQFIFODecodeProcess;
--
-- 		DoDAQFIFOPins: process(DAQFIFOFull, iobitsintop)
-- 		begin
-- 			for i in 0 to IOWidth -1 loop				-- loop through all the external I/O pins
-- 				if ThePinDesc(i)(15 downto 8) = DAQFIFOTag then 	-- this hideous masking of pinnumbers/vs pintype is why they should be separate bytes, maybe IDROM type 4...
-- 					if (ThePinDesc(i)(7 downto 0) and x"C0") = x"00" then 	-- DAQ data matches 0X .. 3X
-- 						DAQFIFOData(conv_integer(ThePinDesc(i)(23 downto 16)))(conv_integer(ThePinDesc(i)(5 downto 0))-1) <= iobitsintop(i);		-- 16 max ports
-- 					end if;
-- 					if ThePinDesc(i)(7 downto 0) = DAQFIFOStrobePin then
-- 						 DAQFIFOStrobe(conv_integer(ThePinDesc(i)(23 downto 16))) <= iobitsintop(i);
-- 					end if;
-- 					if ThePinDesc(i)(7 downto 0) = DAQFIFOFullPin then
-- 						AltData(i) <= DAQFIFOFull(conv_integer(ThePinDesc(i)(23 downto 16)));
-- 					end if;
-- 				end if;
-- 			end loop;
-- 		end process;
-- --
-- 	end generate;

end dataflow;
