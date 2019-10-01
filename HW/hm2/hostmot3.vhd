library IEEE;
use IEEE.std_logic_1164.all;  -- defines std_logic types
use IEEE.std_logic_ARITH.ALL;
use IEEE.std_logic_UNSIGNED.ALL;
--
-- Copyright (C) 2007, Peter C. Wallace, Mesa Electronics
-- http://www.mesanet.com
--
-- This program is is licensed under a disjunctive dual license giving you
-- the choice of one of the two following sets of free software/open source
-- licensing terms:
--
--    * GNU General Public License (GPL), version 2.0 or later
--    * 3-clause BSD License
--
--
-- The GNU GPL License:
--
--     This program is free software; you can redistribute it and/or modify
--     it under the terms of the GNU General Public License as published by
--     the Free Software Foundation; either version 2 of the License, or
--     (at your option) any later version.
--
--     This program is distributed in the hope that it will be useful,
--     but WITHOUT ANY WARRANTY; without even the implied warranty of
--     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--     GNU General Public License for more details.
--
--     You should have received a copy of the GNU General Public License
--     along with this program; if not, write to the Free Software
--     Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301 USA
--
--
-- The 3-clause BSD License:
--
--     Redistribution and use in source and binary forms, with or without
--     modification, are permitted provided that the following conditions
--     are met:
--
--         * Redistributions of source code must retain the above copyright
--           notice, this list of conditions and the following disclaimer.
--
--         * Redistributions in binary form must reproduce the above
--           copyright notice, this list of conditions and the following
--           disclaimer in the documentation and/or other materials
--           provided with the distribution.
--
--         * Neither the name of Mesa Electronics nor the names of its
--           contributors may be used to endorse or promote products
--           derived from this software without specific prior written
--           permission.
--
--
-- Disclaimer:
--
--     THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
--     "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
--     LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
--     FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
--     COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
--     INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
--     BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
--     LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
--     CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
--     LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
--     ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
--     POSSIBILITY OF SUCH DAMAGE.
--
use work.IDROMConst.all;
use work.log2.all;
use work.decodedstrobe.all;
use work.oneofndecode.all;
use work.IDROMConst.all;
use work.NumberOfModules.all;
use work.MaxPinsPerModule.all;
use work.MaxInputPinsPerModule.all;
use work.InputPinsPerModule.all;
use work.MaxOutputPinsPerModule.all;
use work.MaxIOPinsPerModule.all;
use work.CountPinsInRange.all;
use work.PinExists.all;
use work.ModuleExists.all;

entity HostMot3 is
    generic
    (
        ThePinDesc: PinDescType;
        TheModuleID: ModuleIDType;
        IDROMType: integer;
        SepClocks: boolean;
        OneWS: boolean;
        UseStepGenPrescaler: boolean;
        UseIRQLogic: boolean;
        PWMRefWidth: integer;
        UseWatchDog: boolean;
        OffsetToModules: integer;
        OffsetToPinDesc: integer;
        ClockHigh: integer;
        ClockMed: integer;
        ClockLow: integer;
        BoardNameLow : std_Logic_Vector(31 downto 0);
        BoardNameHigh : std_Logic_Vector(31 downto 0);
        FPGASize: integer;
        FPGAPins: integer;
        IOPorts: integer;
        IOWidth: integer;
        LIOWidth: integer;
        PortWidth: integer;
        BusWidth: integer;
        AddrWidth: integer;
        InstStride0: integer;
        InstStride1: integer;
        RegStride0: integer;
        RegStride1: integer;
        LEDCount: integer
        );
    port
(
    -- Generic 32  bit bus interface signals --

    ibustop: in std_logic_vector(BusWidth -1 downto 0);
    obustop: out std_logic_vector(BusWidth -1 downto 0);
    addr: in std_logic_vector(AddrWidth -1 downto 2);
    readstb: in std_logic;
    writestb: in std_logic;
    clklow: in std_logic;
    clkmed: in std_logic;
    clkhigh: in std_logic;
    intirq: out std_logic;
    dreq: out std_logic;
    demandmode: out std_logic;
    iobitsouttop: out std_logic_vector (IOWidth -1 downto 0) := (others => 'Z');
    iobitsintop: in std_logic_vector (IOWidth -1 downto 0) := (others => 'Z');
    liobits: inout std_logic_vector (lIOWidth -1 downto 0);
    rates: out std_logic_vector (4 downto 0);
    leds: out std_logic_vector(ledcount-1 downto 0)
    );
end HostMot3;



architecture dataflow of HostMot3 is


-- decodes --
--	IDROM related signals
signal Aint: std_logic_vector(AddrWidth -1 downto 2);

signal ibusint: std_logic_vector(BusWidth -1 downto 0);
signal obusint: std_logic_vector(BusWidth -1 downto 0);
signal IOBitsin: std_logic_vector(IOWidth-1 downto 0);
signal CoreDataOut: std_logic_vector(IOWidth-1 downto 0);

    -- Extract the number of modules of each type from the ModuleID
constant StepGens: integer := NumberOfModules(TheModuleID,StepGenTag);
constant QCounters: integer := NumberOfModules(TheModuleID,QCountTag);
constant MuxedQCounters: integer := NumberOfModules(TheModuleID,MuxedQCountTag);			-- non-muxed index mask
constant MuxedQCountersMIM: integer := NumberOfModules(TheModuleID,MuxedQCountMIMTag); -- muxed index mask
constant PWMGens : integer := NumberOfModules(TheModuleID,PWMTag);
constant UsePWMEnas: boolean := PinExists(ThePinDesc,PWMTag,PWMCEnaPin);
constant TPPWMGens : integer := NumberOfModules(TheModuleID,TPPWMTag);
constant SPIs: integer := NumberOfModules(TheModuleID,SPITag);
constant BSPIs: integer := NumberOfModules(TheModuleID,BSPITag);
constant DBSPIs: integer := NumberOfModules(TheModuleID,DBSPITag);
--constant SSSIs: integer := NumberOfModules(TheModuleID,SSSITag);
--constant FAbss: integer := NumberOfModules(TheModuleID,FAbsTag);
--constant BISSs: integer := NumberOfModules(TheModuleID,BISSTag);
--constant UARTs: integer := NumberOfModules(TheModuleID,UARTRTag); -- assumption

--constant PktUARTs: integer := NumberOfModules(TheModuleID,PktUARTRTag); -- assumption
--constant WaveGens: integer := NumberOfModules(TheModuleID,WaveGenTag);
--constant ResolverMods: integer := NumberOfModules(TheModuleID,ResModTag);
constant SSerials: integer := NumberOfModules(TheModuleID,SSerialTag);
-- type  SSerialType is array(0 to 3) of integer;
-- constant UARTSPerSSerial: SSerialType :=(
-- (InputPinsPerModule(ThePinDesc,SSerialTag,0)),
-- (InputPinsPerModule(ThePinDesc,SSerialTag,1)),
-- (InputPinsPerModule(ThePinDesc,SSerialTag,2)),
-- (InputPinsPerModule(ThePinDesc,SSerialTag,3)));
constant MaxUARTSPerSSerial: integer := MaxInputPinsPerModule(ThePinDesc,SSerialTag);
--constant	Twiddlers: integer := NumberOfModules(TheModuleID,TwiddlerTag);
--constant InputsPerTwiddler: integer := MaxInputPinsPerModule(ThePinDesc,TwiddlerTag)+MaxIOPinsPerModule(ThePinDesc,TwiddlerTag);
--constant OutputsPerTwiddler: integer := MaxOutputPinsPerModule(ThePinDesc,TwiddlerTag); -- MaxOutputsPer pin counts I/O pins also
--constant RegsPerTwiddler: integer := 4;	-- until I find a per instance way of doing this
-- constant DAQFIFOs: integer := NumberOfModules(TheModuleID,DAQFIFOTag);
-- constant DAQFIFOWidth: integer := MaxInputPinsPerModule(ThePinDesc,DAQFIFOTag); -- until I find a per instance way of doing this
constant	UseDemandModeDMA: boolean := ModuleExists(TheModuleID,DMDMATag);		-- demand mode DMA must be explicitly included in the module ID
-- constant NDRQs: integer := NumberOfModules(TheModuleID,DAQFIFOTag); -- + any other drq sources that are used
--constant BinOscs: integer := NumberOfModules(TheModuleID,BinOscTag);
--constant BinOscWidth: integer := MaxOutputPinsPerModule(ThePinDesc,BinOscTag);
constant HM2DPLLs: integer := NumberOfModules(TheModuleID,HM2DPLLTag);
--constant ScalerCounters: integer := NumberOfModules(TheModuleID,ScalerCounterTag);

-- extract the needed Stepgen table width from the max pin# used with a stepgen tag
constant StepGenTableWidth: integer := MaxPinsPerModule(ThePinDesc,StepGenTag);
    -- extract how many BSPI CS pins are needed
constant BSPICSWidth: integer := CountPinsInRange(ThePinDesc,BSPITag,BSPICS0Pin,BSPICS7Pin);
    -- extract how many DBSPI CS pins are needed
constant DBSPICSWidth: integer := CountPinsInRange(ThePinDesc,DBSPITag,DBSPICS0Pin,DBSPICS7Pin);

constant UseProbe: boolean := PinExists(ThePinDesc,QCountTag,QCountProbePin);
constant UseMuxedProbe: boolean := PinExists(ThePinDesc,MuxedQCountTag,MuxedQCountProbePin);
constant UseStepgenIndex: boolean := PinExists(ThePinDesc,StepGenTag,StepGenIndexPin);
constant UseStepgenProbe: boolean := PinExists(ThePinDesc,StepGenTag,StepGenProbePin);

-- all these signals should be put in per module components
-- to reduce clutter

-- I/O port related signals

    signal IOBitsCorein :  std_logic_vector(IOWidth-1 downto 0) := (others => '0');

-- qcounter related signals
    signal Probe : std_logic; -- hs probe input for counters,stepgens etc

-- PWM related signals (this is global because its shared by two modules)
    signal RefCountBus : std_logic_vector(PWMRefWidth-1 downto 0);

-- Timer related signals
-- 	signal DPLLTimers: std_logic_vector(3 downto 0);
-- 	signal DPLLRefOut: std_logic;
    signal RateSources: std_logic_vector(4 downto 0);

    function bitreverse(v: in std_logic_vector) -- Thanks: J. Bromley
    return std_logic_vector is
    variable result: std_logic_vector(v'RANGE);
    alias tv: std_logic_vector(v'REVERSE_RANGE) is v;
    begin
        for i in tv'RANGE loop
            result(i) := tv(i);
        end loop;
        return result;
    end;


    begin

    MakeIOPorts : entity work.MakeIOPorts
    generic map (
        ThePinDesc => ThePinDesc,
        TheModuleID => TheModuleID,
        IDROMType => IDROMType,
        OffsetToModules => OffsetToModules,
        OffsetToPinDesc => OffsetToPinDesc,
        ClockHigh => ClockHigh,
        ClockLow => ClockLow,
        BoardNameLow => BoardNameLow,
        BoardNameHigh => BoardNameHigh,
        FPGASize => FPGASize,
        FPGAPins => FPGAPins,
        IOPorts => IOPorts,
        IOWidth => IOWidth,
        PortWidth => PortWidth,
        InstStride0 => InstStride0,
        InstStride1 => InstStride1,
        RegStride0 => RegStride0,
        RegStride1 => RegStride1,
--
--        ClockMed => ClockMed,
        BusWidth  => BusWidth,
        AddrWidth  => AddrWidth,
--        STEPGENs  => STEPGENs,
--        StepGenTableWidth => StepGenTableWidth,
--        UseStepGenPreScaler => UseStepGenPreScaler,
--        UseStepgenIndex => UseStepgenIndex,
--        UseStepgenProbe => UseStepgenProbe,
--        timersize  => 14,
--        asize  => 48,
--        rsize  => 32,
--        PWMGens  => PWMGens,
--        PWMRefWidth  => PWMRefWidth,
--        UsePWMEnas  => UsePWMEnas,
--        QCounters  => QCounters,
--        UseMuxedProbe  => UseMuxedProbe,
--        UseProbe  => UseProbe,
        UseWatchDog  => UseWatchDog,
        UseDemandModeDMA  => UseDemandModeDMA,
        UseIRQlogic  => UseIRQlogic,
        LEDCount  => LEDCount
        )
        port map (
            ibustop			=>	ibustop,
            ibusint			=>	ibusint,
            obustop			=>	obustop,
            obusint			=>	obusint,
            addr			=>	addr,
            Aint			=>	Aint,
            readstb			=>	readstb,
            writestb		=>	writestb,
            iobitsouttop	=>	iobitsouttop,
            iobitsintop		=>	iobitsintop,
            IOBitsCorein	=>	IOBitsCorein,
            CoreDataOut		=>	CoreDataOut,
--			portdata		=>	portdata,
            clklow 			=>	clklow,
            clkmed 			=>	clkmed,
            clkhigh			=>	clkhigh,
            PRobe 			=>	PRobe,
            demandmode		=>	demandmode,		-- passed directly to top
            intirq			=>	intirq,
            dreq			=>	dreq,
            RateSources		=>	RateSources,
            LEDS			=>	leds
        );

GenMakeHm2Dpllmods: if HM2DPLLs >0  generate
    MakeHm2Dpllmods : entity work.MakeHm2Dpllmods
    generic map (
        ThePinDesc => ThePinDesc,
        ClockHigh => ClockHigh,
        ClockMed => ClockMed,
        ClockLow  => ClockLow,
        BusWidth  => BusWidth,
        AddrWidth  => AddrWidth,
        IOWidth  => IOWidth,
        STEPGENs  => STEPGENs,
        StepGenTableWidth => StepGenTableWidth,
        UseStepGenPreScaler => UseStepGenPreScaler,
        UseStepgenIndex => UseStepgenIndex,
        UseStepgenProbe => UseStepgenProbe,
        timersize  => 14,
        asize  => 48,
        rsize  => 32,
        HM2DPLLs => HM2DPLLs,
        MuxedQCounters  => MuxedQCounters,
        MuxedQCountersMIM  => MuxedQCountersMIM,
        PWMGens  => PWMGens,
        PWMRefWidth  => PWMRefWidth,
        UsePWMEnas  => UsePWMEnas,
        TPPWMGens  => TPPWMGens,
        QCounters  => QCounters,
        UseMuxedProbe  => UseMuxedProbe,
        UseProbe  => UseProbe
        )
        port map (
            ibus			=>  ibusint,
            obusint			=>  obusint,
            Aint			=>  Aint,
            readstb			=>  readstb,
            writestb		=>  writestb,
            CoreDataOut		=>  CoreDataOut,
            IOBitsCorein	=>  IOBitsCorein,
            clklow			=>  clklow,
            clkmed			=>  clkmed,
            clkhigh			=>  clkhigh,
            PRobe			=>  PRobe,
            RateSources		=>  RateSources,
            rates			=>  rates
        );
end generate;

GenMakeStepgens: if STEPGENs >0  generate
    MakeStepgens : entity work.MakeStepgens
    generic map (
        ThePinDesc => ThePinDesc,
        ClockHigh => ClockHigh,
        ClockMed => ClockMed,
        ClockLow  => ClockLow,
        BusWidth  => BusWidth,
        AddrWidth  => AddrWidth,
        IOWidth  => IOWidth,
        STEPGENs  => STEPGENs,
        StepGenTableWidth => StepGenTableWidth,
        UseStepGenPreScaler => UseStepGenPreScaler,
        UseStepgenIndex => UseStepgenIndex,
        UseStepgenProbe => UseStepgenProbe,
        timersize  => 14,
        asize  => 48,
        rsize  => 32,
        HM2DPLLs => HM2DPLLs,
        MuxedQCounters  => MuxedQCounters,
        MuxedQCountersMIM  => MuxedQCountersMIM,
        PWMGens  => PWMGens,
        PWMRefWidth  => PWMRefWidth,
        UsePWMEnas  => UsePWMEnas,
        TPPWMGens  => TPPWMGens,
        QCounters  => QCounters,
        UseMuxedProbe  => UseMuxedProbe,
        UseProbe  => UseProbe
        )
        port map (
            ibus			=>	ibusint,
            obusint			=>	obusint,
            Aint			=>	Aint,
            readstb			=>	readstb,
            writestb		=>	writestb,
            CoreDataOut		=>	CoreDataOut,
            IOBitsCorein	=>	IOBitsCorein,
            clklow			=>	clklow,
            clkmed			=>	clkmed,
            clkhigh			=>	clkhigh,
            PRobe			=>  PRobe,
            RateSources		=>  RateSources,
            rates			=>  rates
        );
end generate;

GenMakeQCounters: if QCounters >0  generate
    MakeQCounters : entity work.MakeQCounters
    generic map (
        ThePinDesc => ThePinDesc,
        ClockHigh => ClockHigh,
        ClockMed => ClockMed,
        ClockLow  => ClockLow,
        BusWidth  => BusWidth,
        AddrWidth  => AddrWidth,
        IOWidth  => IOWidth,
        STEPGENs  => STEPGENs,
        StepGenTableWidth => StepGenTableWidth,
        UseStepGenPreScaler => UseStepGenPreScaler,
        UseStepgenIndex => UseStepgenIndex,
        UseStepgenProbe => UseStepgenProbe,
        timersize  => 14,
        asize  => 48,
        rsize  => 32,
        HM2DPLLs => HM2DPLLs,
        MuxedQCounters  => MuxedQCounters,
        MuxedQCountersMIM  => MuxedQCountersMIM,
        PWMGens  => PWMGens,
        PWMRefWidth  => PWMRefWidth,
        UsePWMEnas  => UsePWMEnas,
        TPPWMGens  => TPPWMGens,
        QCounters  => QCounters,
        UseMuxedProbe  => UseMuxedProbe,
        UseProbe  => UseProbe
        )
        port map (
            ibus			=>	ibusint,
            obusint			=>	obusint,
            Aint			=>	Aint,
            readstb			=>	readstb,
            writestb		=>	writestb,
            CoreDataOut		=>	CoreDataOut,
            IOBitsCorein	=>	IOBitsCorein,
            clklow			=>	clklow,
            clkmed			=>	clkmed,
            clkhigh			=>	clkhigh,
            PRobe			=>  PRobe,
            RateSources		=>  RateSources,
            rates			=>  rates
        );
end generate;

GenMakeMuxedQCounters: if MuxedQCounters >0  generate
    MakeMuxedQCounters : entity work.MakeMuxedQCounters
    generic map (
        ThePinDesc => ThePinDesc,
        ClockHigh => ClockHigh,
        ClockMed => ClockMed,
        ClockLow  => ClockLow,
        BusWidth  => BusWidth,
        AddrWidth  => AddrWidth,
        IOWidth  => IOWidth,
        STEPGENs  => STEPGENs,
        StepGenTableWidth => StepGenTableWidth,
        UseStepGenPreScaler => UseStepGenPreScaler,
        UseStepgenIndex => UseStepgenIndex,
        UseStepgenProbe => UseStepgenProbe,
        timersize  => 14,
        asize  => 48,
        rsize  => 32,
        HM2DPLLs => HM2DPLLs,
        MuxedQCounters  => MuxedQCounters,
        MuxedQCountersMIM  => MuxedQCountersMIM,
        PWMGens  => PWMGens,
        PWMRefWidth  => PWMRefWidth,
        UsePWMEnas  => UsePWMEnas,
        TPPWMGens  => TPPWMGens,
        QCounters  => QCounters,
        UseMuxedProbe  => UseMuxedProbe,
        UseProbe  => UseProbe
        )
        port map (
            ibus			=>	ibusint,
            obusint			=>	obusint,
            Aint			=>	Aint,
            readstb			=>	readstb,
            writestb		=>	writestb,
            CoreDataOut		=>	CoreDataOut,
            IOBitsCorein	=>	IOBitsCorein,
            clklow			=>	clklow,
            clkmed			=>	clkmed,
            clkhigh			=>	clkhigh,
            PRobe			=>  PRobe,
            RateSources		=>  RateSources,
            rates			=>  rates
        );
end generate;

GenMakePWMgens: if PWMGens >0  generate
    MakePWMgens : entity work.MakePWMgens
    generic map (
        ThePinDesc => ThePinDesc,
        ClockHigh => ClockHigh,
        ClockMed => ClockMed,
        ClockLow  => ClockLow,
        BusWidth  => BusWidth,
        AddrWidth  => AddrWidth,
        IOWidth  => IOWidth,
        STEPGENs  => STEPGENs,
        StepGenTableWidth => StepGenTableWidth,
        UseStepGenPreScaler => UseStepGenPreScaler,
        UseStepgenIndex => UseStepgenIndex,
        UseStepgenProbe => UseStepgenProbe,
        timersize  => 14,
        asize  => 48,
        rsize  => 32,
        HM2DPLLs => HM2DPLLs,
        MuxedQCounters  => MuxedQCounters,
        MuxedQCountersMIM  => MuxedQCountersMIM,
        PWMGens  => PWMGens,
        PWMRefWidth  => PWMRefWidth,
        UsePWMEnas  => UsePWMEnas,
        TPPWMGens  => TPPWMGens,
        QCounters  => QCounters,
        UseMuxedProbe  => UseMuxedProbe,
        UseProbe  => UseProbe
        )
        port map (
            ibus			=>	ibusint,
            obusint			=>	obusint,
            Aint			=>	Aint,
            readstb			=>	readstb,
            writestb		=>	writestb,
            CoreDataOut		=>	CoreDataOut,
            IOBitsCorein	=>	IOBitsCorein,
            clklow			=>	clklow,
            clkmed			=>	clkmed,
            clkhigh			=>	clkhigh,
            PRobe			=>  PRobe,
            RateSources		=>  RateSources,
            rates			=>  rates
        );
end generate;

GenMakeTPPWMGens: if TPPWMGens >0  generate
    MakeTPPWMGens : entity work.MakeTPPWMGens
    generic map (
        ThePinDesc => ThePinDesc,
        ClockHigh => ClockHigh,
        ClockMed => ClockMed,
        ClockLow  => ClockLow,
        BusWidth  => BusWidth,
        AddrWidth  => AddrWidth,
        IOWidth  => IOWidth,
        STEPGENs  => STEPGENs,
        StepGenTableWidth => StepGenTableWidth,
        UseStepGenPreScaler => UseStepGenPreScaler,
        UseStepgenIndex => UseStepgenIndex,
        UseStepgenProbe => UseStepgenProbe,
        timersize  => 14,
        asize  => 48,
        rsize  => 32,
        HM2DPLLs => HM2DPLLs,
        MuxedQCounters  => MuxedQCounters,
        MuxedQCountersMIM  => MuxedQCountersMIM,
        PWMGens  => PWMGens,
        PWMRefWidth  => PWMRefWidth,
        UsePWMEnas  => UsePWMEnas,
        TPPWMGens  => TPPWMGens,
        QCounters  => QCounters,
        UseMuxedProbe  => UseMuxedProbe,
        UseProbe  => UseProbe
        )
        port map (
            ibus			=>	ibusint,
            obusint			=>	obusint,
            Aint			=>	Aint,
            readstb			=>	readstb,
            writestb		=>	writestb,
            CoreDataOut		=>	CoreDataOut,
            IOBitsCorein	=>	IOBitsCorein,
            clklow			=>	clklow,
            clkmed			=>	clkmed,
            clkhigh			=>	clkhigh,
            PRobe			=>  PRobe,
            RateSources		=>  RateSources,
            rates			=>  rates
        );
end generate;

GenMakeSPIs: if SPIs >0  generate
    MakeSPIs : entity work.MakeSPIs
    generic map (
        ThePinDesc => ThePinDesc,
        ClockHigh => ClockHigh,
        ClockMed => ClockMed,
        ClockLow  => ClockLow,
        BusWidth  => BusWidth,
        AddrWidth  => AddrWidth,
        IOWidth  => IOWidth,
        STEPGENs  => STEPGENs,
        StepGenTableWidth => StepGenTableWidth,
        UseStepGenPreScaler => UseStepGenPreScaler,
        UseStepgenIndex => UseStepgenIndex,
        UseStepgenProbe => UseStepgenProbe,
        timersize  => 14,
        asize  => 48,
        rsize  => 32,
        HM2DPLLs => HM2DPLLs,
        MuxedQCounters  => MuxedQCounters,
        MuxedQCountersMIM  => MuxedQCountersMIM,
        PWMGens  => PWMGens,
        PWMRefWidth  => PWMRefWidth,
        UsePWMEnas  => UsePWMEnas,
        TPPWMGens  => TPPWMGens,
        QCounters  => QCounters,
        UseMuxedProbe  => UseMuxedProbe,
        UseProbe  => UseProbe,
        SPIs  => SPIs
        )
        port map (
            ibus			=>	ibusint,
            obusint			=>	obusint,
            Aint			=>	Aint,
            readstb			=>	readstb,
            writestb		=>	writestb,
            CoreDataOut		=>	CoreDataOut,
            IOBitsCorein	=>	IOBitsCorein,
            clklow			=>	clklow,
            clkmed			=>	clkmed,
            clkhigh			=>	clkhigh,
            PRobe			=>  PRobe,
            RateSources		=>  RateSources,
            rates			=>  rates
        );
end generate;

GenMakeBSPIs: if BSPIs >0  generate
    MakeBSPIs : entity work.MakeBSPIs
    generic map (
        ThePinDesc => ThePinDesc,
        ClockHigh => ClockHigh,
        ClockMed => ClockMed,
        ClockLow  => ClockLow,
        BusWidth  => BusWidth,
        AddrWidth  => AddrWidth,
        IOWidth  => IOWidth,
        STEPGENs  => STEPGENs,
        StepGenTableWidth => StepGenTableWidth,
        UseStepGenPreScaler => UseStepGenPreScaler,
        UseStepgenIndex => UseStepgenIndex,
        UseStepgenProbe => UseStepgenProbe,
        timersize  => 14,
        asize  => 48,
        rsize  => 32,
        HM2DPLLs => HM2DPLLs,
        MuxedQCounters  => MuxedQCounters,
        MuxedQCountersMIM  => MuxedQCountersMIM,
        PWMGens  => PWMGens,
        PWMRefWidth  => PWMRefWidth,
        UsePWMEnas  => UsePWMEnas,
        TPPWMGens  => TPPWMGens,
        QCounters  => QCounters,
        UseMuxedProbe  => UseMuxedProbe,
        UseProbe  => UseProbe,
        SPIs  => SPIs,
        BSPIs  => BSPIs,
        BSPICSWidth  => BSPICSWidth
        )
        port map (
            ibus			=>	ibusint,
            obusint			=>	obusint,
            Aint			=>	Aint,
            readstb			=>	readstb,
            writestb		=>	writestb,
            CoreDataOut		=>	CoreDataOut,
            IOBitsCorein	=>	IOBitsCorein,
            clklow			=>	clklow,
            clkmed			=>	clkmed,
            clkhigh			=>	clkhigh,
            PRobe			=>  PRobe,
            RateSources		=>  RateSources,
            rates			=>  rates
        );
end generate;

GenMakeDBSPIs: if DBSPIs >0  generate
    MakeDBSPIs : entity work.MakeDBSPIs
    generic map (
        ThePinDesc => ThePinDesc,
        ClockHigh => ClockHigh,
        ClockMed => ClockMed,
        ClockLow  => ClockLow,
        BusWidth  => BusWidth,
        AddrWidth  => AddrWidth,
        IOWidth  => IOWidth,
        STEPGENs  => STEPGENs,
        StepGenTableWidth => StepGenTableWidth,
        UseStepGenPreScaler => UseStepGenPreScaler,
        UseStepgenIndex => UseStepgenIndex,
        UseStepgenProbe => UseStepgenProbe,
        timersize  => 14,
        asize  => 48,
        rsize  => 32,
        HM2DPLLs => HM2DPLLs,
        MuxedQCounters  => MuxedQCounters,
        MuxedQCountersMIM  => MuxedQCountersMIM,
        PWMGens  => PWMGens,
        PWMRefWidth  => PWMRefWidth,
        UsePWMEnas  => UsePWMEnas,
        TPPWMGens  => TPPWMGens,
        QCounters  => QCounters,
        UseMuxedProbe  => UseMuxedProbe,
        UseProbe  => UseProbe,
        SPIs  => SPIs,
        BSPIs  => BSPIs,
        BSPICSWidth  => BSPICSWidth,
        DBSPIs  => DBSPIs,
        DBSPICSWidth  => DBSPICSWidth
        )
        port map (
            ibus			=>	ibusint,
            obusint			=>	obusint,
            Aint			=>	Aint,
            readstb			=>	readstb,
            writestb		=>	writestb,
            CoreDataOut		=>	CoreDataOut,
            IOBitsCorein	=>	IOBitsCorein,
            clklow			=>	clklow,
            clkmed			=>	clkmed,
            clkhigh			=>	clkhigh,
            PRobe			=>  PRobe,
            RateSources		=>  RateSources,
            rates			=>  rates
        );
end generate;
--
-- GenMakeSSSIs: if SSSIs >0  generate
--     MakeSSSIs : entity work.MakeSSSIs
--     generic map (
--         ThePinDesc => ThePinDesc,
--         ClockHigh => ClockHigh,
--         ClockMed => ClockMed,
--         ClockLow  => ClockLow,
--         BusWidth  => BusWidth,
--         AddrWidth  => AddrWidth,
--         IOWidth  => IOWidth,
--         STEPGENs  => STEPGENs,
--         StepGenTableWidth => StepGenTableWidth,
--         UseStepGenPreScaler => UseStepGenPreScaler,
--         UseStepgenIndex => UseStepgenIndex,
--         UseStepgenProbe => UseStepgenProbe,
--         timersize  => 14,
--         asize  => 48,
--         rsize  => 32,
--         HM2DPLLs => HM2DPLLs,
--         MuxedQCounters  => MuxedQCounters,
--         MuxedQCountersMIM  => MuxedQCountersMIM,
--         PWMGens  => PWMGens,
--         PWMRefWidth  => PWMRefWidth,
--         UsePWMEnas  => UsePWMEnas,
--         TPPWMGens  => TPPWMGens,
--         QCounters  => QCounters,
--         UseMuxedProbe  => UseMuxedProbe,
--         UseProbe  => UseProbe,
--         SPIs  => SPIs,
--         BSPIs  => BSPIs,
--         BSPICSWidth  => BSPICSWidth,
--         DBSPIs  => DBSPIs,
--         DBSPICSWidth  => DBSPICSWidth,
--         SSSIs  => SSSIs
--         )
--         port map (
--             ibus			=>	ibusint,
--             obusint			=>	obusint,
--             Aint			=>	Aint,
--             readstb			=>	readstb,
--             writestb		=>	writestb,
--             CoreDataOut		=>	CoreDataOut,
--             IOBitsCorein	=>	IOBitsCorein,
--             clklow			=>	clklow,
--             clkmed			=>	clkmed,
--             clkhigh			=>	clkhigh,
--             PRobe			=>  PRobe,
--             RateSources		=>  RateSources,
--             rates			=>  rates
--         );
-- end generate;
--
-- 	makeFAbsmod:  if FAbss >0  generate
-- 	signal LoadFAbsData0: std_logic_vector(FAbss -1 downto 0);
-- 	signal ReadFAbsData0: std_logic_vector(FAbss -1 downto 0);
-- 	signal ReadFAbsData1: std_logic_vector(FAbss -1 downto 0);
-- 	signal ReadFAbsData2: std_logic_vector(FAbss -1 downto 0);
-- 	signal LoadFAbsControl0: std_logic_vector(FAbss -1 downto 0);
-- 	signal LoadFAbsControl1: std_logic_vector(FAbss -1 downto 0);
-- 	signal ReadFAbsControl0: std_logic_vector(FAbss -1 downto 0);
-- 	signal ReadFAbsControl1: std_logic_vector(FAbss -1 downto 0);
-- 	signal LoadFAbsControl2: std_logic_vector(FAbss -1 downto 0);
-- 	signal FAbsBusyBits: std_logic_vector(FAbss -1 downto 0);
-- 	signal FAbsDAVBits: std_logic_vector(FAbss -1 downto 0);
-- 	signal FAbsRequest: std_logic_vector(FAbss -1 downto 0);
-- 	signal FAbsData: std_logic_vector(FAbss -1 downto 0);
-- 	signal FAbsTestClk: std_logic_vector(FAbss -1 downto 0);
-- --- FanucAbs interface related signals
-- 	signal FAbsDataSel0 : std_logic;
-- 	signal FAbsDataSel1 : std_logic;
-- 	signal FAbsDataSel2 : std_logic;
-- 	signal FAbsControlSel0 : std_logic;
-- 	signal FAbsControlSel1 : std_logic;
-- 	signal FAbsControlSel2 : std_logic;
-- 	signal GlobalPStartFAbs : std_logic;
-- 	signal GlobalFAbsBusySel : std_logic;
--
-- 	begin
-- 		makeFAbss: for i in 0 to FAbss -1 generate
-- 			FAbs: entity work.FanucAbs
-- 			generic map (
-- 				Clock => ClockLow
-- 				)
-- 			port  map (
-- 				clk => clklow,
-- 				ibus => ibusint,
-- 				obus => obusint,
-- 				loadcontrol0 => LoadFAbsControl0(i),
-- 				loadcontrol1 => LoadFAbsControl1(i),
-- 				loadcontrol2 => LoadFAbsControl2(i),
-- 				lstart => LoadFabsData0(i),
-- 				pstart => GlobalPstartFAbs,
-- 				timers => RateSources,
-- 				readdata0 => ReadFAbsData0(i),
-- 				readdata1 => ReadFAbsData1(i),
-- 				readdata2 => ReadFAbsData2(i),
-- 				readcontrol0 => ReadFAbsControl0(i),
-- 				readcontrol1 => ReadFAbsControl1(i),
-- 				busyout => FabsBusyBits(i),
-- 				davout => FabsDAVBits(i),
-- 				requestout => FAbsRequest(i),
-- 				rxdata => FAbsData(i),
-- 				testclk => FAbsTestClk(i)
-- 				);
-- 		end generate;
--
-- 		FAbsDecodeProcess : process (Aint,Readstb,writestb,FAbsDataSel0,FAbsDataSel1,FAbsDataSel2,
-- 												FAbsControlSel0,FAbsControlSel1,FAbsControlSel2,
-- 												GlobalFabsBusySel,FAbsBusyBits)
-- 		begin
-- 			if Aint(AddrWidth-1 downto 8) = FAbsDataAddr0 then	 --  FAbs data register select
-- 				FAbsDataSel0 <= '1';
-- 			else
-- 				FAbsDataSel0 <= '0';
-- 			end if;
-- 			if Aint(AddrWidth-1 downto 8) = FAbsDataAddr1 then	 --  FAbs data register select
-- 				FAbsDataSel1 <= '1';
-- 			else
-- 				FAbsDataSel1 <= '0';
-- 			end if;
-- 			if Aint(AddrWidth-1 downto 8) = FAbsDataAddr2 then	 --  FAbs data register select
-- 				FAbsDataSel2 <= '1';
-- 			else
-- 				FAbsDataSel2 <= '0';
-- 			end if;
-- 			if Aint(AddrWidth-1 downto 8) = FAbsControlAddr0 then	 --  FAbs control register 0 select
-- 				FAbsControlSel0 <= '1';
-- 			else
-- 				FAbsControlSel0 <= '0';
-- 			end if;
-- 			if Aint(AddrWidth-1 downto 8) = FAbsControlAddr1 then	 --  FAbs control register 1 select
-- 				FAbsControlSel1 <= '1';
-- 			else
-- 				FAbsControlSel1 <= '0';
-- 			end if;
-- 			if Aint(AddrWidth-1 downto 8) = FAbsDataAddr2 then	 	--  FAbs control register 2 select
-- 				FAbsControlSel2 <= '1';
-- 			else
-- 				FAbsControlSel2 <= '0';
-- 			end if;
-- 			if Aint(AddrWidth-1 downto 8) = FAbsGlobalPStartAddr and writestb = '1' then	 --
-- 				GlobalPStartFAbs <= '1';
-- 			else
-- 				GlobalPStartFAbs <= '0';
-- 			end if;
-- 			if Aint(AddrWidth-1 downto 8) = FAbsGlobalPStartAddr and readstb = '1' then	 --
-- 				GlobalFAbsBusySel <= '1';
-- 			else
-- 				GlobalFAbsBusySel <= '0';
-- 			end if;
-- 			LoadFAbsData0 <= OneOfNDecode(FAbss,FAbsDataSel0,writestb,Aint(7 downto 2)); -- 64 max
-- 			ReadFAbsData0 <= OneOfNDecode(FAbss,FAbsDataSel0,Readstb,Aint(7 downto 2));
-- 			ReadFAbsData1 <= OneOfNDecode(FAbss,FAbsDataSel1,Readstb,Aint(7 downto 2));
-- 			ReadFAbsData2 <= OneOfNDecode(FAbss,FAbsDataSel2,Readstb,Aint(7 downto 2));
-- 			LoadFAbsControl0 <= OneOfNDecode(FAbss,FAbsControlSel0,writestb,Aint(7 downto 2));
-- 			LoadFAbsControl1 <= OneOfNDecode(FAbss,FAbsControlSel1,writestb,Aint(7 downto 2));
-- 			LoadFAbsControl2 <= OneOfNDecode(FAbss,FAbsControlSel2,writestb,Aint(7 downto 2));
-- 			ReadFAbsControl0 <= OneOfNDecode(FAbss,FAbsControlSel0,Readstb,Aint(7 downto 2));
-- 			ReadFAbsControl1 <= OneOfNDecode(FAbss,FAbsControlSel1,Readstb,Aint(7 downto 2));
-- 			obusint <= (others => 'Z');
-- 			if GlobalFabsBusySel = '1' then
-- 				obusint(FAbss -1 downto 0) <= FAbsBusyBits;
-- 				obusint(31 downto FAbss) <= (others => '0');
-- 			end if;
-- 		end process FAbsDecodeProcess;
--
-- 		DoFAbsPins: process(FAbsRequest,FAbsTestClk,IOBitsCorein)
-- 		begin
-- 			for i in 0 to IOWidth -1 loop				-- loop through all the external I/O pins
-- 				if ThePinDesc(i)(15 downto 8) = FAbsTag then 	-- this hideous masking of pinnumbers/vs pintype is why they should be separate bytes, maybe IDROM type 4...
-- 					case (ThePinDesc(i)(7 downto 0)) is	--secondary pin function, drop MSB
-- 						when FAbsRQPin =>
-- 							IOBitsCorein(i) <= FAbsRequest(conv_integer(ThePinDesc(i)(23 downto 16)));
-- 						when FAbsRQEnPin =>
-- 							IOBitsCorein(i) <= '0';		-- for RS-422 daughtercards that have drive enables
-- 						when FAbsTestClkPin =>
-- 							IOBitsCorein(i) <= FAbsTestClk(conv_integer(ThePinDesc(i)(23 downto 16)));
-- 						when FAbsDAVPin =>
-- 							IOBitsCorein(i) <= FAbsDAVBits(conv_integer(ThePinDesc(i)(23 downto 16)));
-- 						when FAbsDataPin =>
-- 							FAbsData(conv_integer(ThePinDesc(i)(23 downto 16))) <= IOBitsCorein(i);
-- 						when others => null;
-- 					end case;
-- 				end if;
-- 			end loop;
-- 		end process;
-- 	end generate;
--
-- 	makebissmod:  if BISSs >0  generate
-- 	signal LoadBISSData: std_logic_vector(BISSs -1 downto 0);
-- 	signal ReadBISSData: std_logic_vector(BISSs -1 downto 0);
-- 	signal LoadBISSControl0: std_logic_vector(BISSs -1 downto 0);
-- 	signal LoadBISSControl1: std_logic_vector(BISSs -1 downto 0);
-- 	signal ReadBISSControl0: std_logic_vector(BISSs -1 downto 0);
-- 	signal ReadBISSControl1: std_logic_vector(BISSs -1 downto 0);
-- 	signal BISSClk: std_logic_vector(BISSs -1 downto 0);
-- 	signal BISSData: std_logic_vector(BISSs -1 downto 0);
-- --- BISS interface related signals
-- 	signal BISSDataSel : std_logic;
-- 	signal BISSControlSel0 : std_logic;
-- 	signal BISSControlSel1 : std_logic;
-- 	signal GlobalPStartBISS : std_logic;
-- 	signal BISSBusyBits: std_logic_vector(BISSs -1 downto 0);
-- 	signal BISSDAVBits: std_logic_vector(BISSs -1 downto 0);
-- 	signal GlobalBISSBusySel : std_logic;
--
--
--
-- 	begin
-- 		makebisss: for i in 0 to BISSs -1 generate
-- 			BISS: entity work.biss
-- 			port  map (
-- 				clk => clklow,
-- 				hclk => clkhigh,
-- 				ibus => ibusint,
-- 				obus => obusint,
-- 				poplifo => ReadBISSData(i),
-- 				lstart => LoadBISSData(i),
-- 				pstart => GlobalPstartBISS,
-- 				timers => RateSources,
-- 				loadcontrol0 => LoadBISSControl0(i),
-- 				loadcontrol1 => LoadBISSControl1(i),
-- 				readcontrol0 => ReadBISSControl0(i),
-- 				readcontrol1 => ReadBISSControl1(i),
-- 				busyout => BISSBusyBits(i),
-- 				davout => BISSDAVBits(i),
-- 				bissclk => BISSClk(i),
-- 				bissdata => BISSData(i)
-- 				);
-- 		end generate;
--
-- 		BISSDecodeProcess : process (Aint,Readstb,writestb,BISSControlSel0,BISSControlSel1,
-- 											  BISSDataSel,GlobalBISSBusySel,BISSBusyBits)
-- 		begin
-- 			if Aint(AddrWidth-1 downto 8) = BISSDataAddr then	 --  BISS data register select
-- 				BISSDataSel <= '1';
-- 			else
-- 				BISSDataSel <= '0';
-- 			end if;
-- 			if Aint(AddrWidth-1 downto 8) = BISSControlAddr0 then	 --  BISS control register select
-- 				BISSControlSel0 <= '1';
-- 			else
-- 				BISSControlSel0 <= '0';
-- 			end if;
-- 			if Aint(AddrWidth-1 downto 8) = BISSControlAddr1 then	 --  BISS control register select
-- 				BISSControlSel1 <= '1';
-- 			else
-- 				BISSControlSel1 <= '0';
-- 			end if;
-- 			if Aint(AddrWidth-1 downto 8) = BISSGlobalPStartAddr and writestb = '1' then	 --
-- 				GlobalPStartBISS <= '1';
-- 			else
-- 				GlobalPStartBISS <= '0';
-- 			end if;
-- 			if Aint(AddrWidth-1 downto 8) = BISSGlobalPStartAddr and readstb = '1' then	 --
-- 				GlobalBISSBusySel <= '1';
-- 			else
-- 				GlobalBISSBusySel <= '0';
-- 			end if;
--
-- 			obusint <= (others => 'Z');
-- 			if GlobalBISSBusySel = '1' then
-- 				obusint(BISSs -1 downto 0) <= BISSBusyBits;
-- 				obusint(31 downto BISSs) <= (others => '0');
-- 			end if;
--
-- 			LoadBISSData <= OneOfNDecode(BISSs,BISSDataSel,writestb,Aint(5 downto 2));
-- 			ReadBISSData <= OneOfNDecode(BISSs,BISSDataSel,Readstb,Aint(5 downto 2));
-- 			LoadBISSControl0 <= OneOfNDecode(BISSs,BISSControlSel0,writestb,Aint(5 downto 2));
-- 			LoadBISSControl1 <= OneOfNDecode(BISSs,BISSControlSel1,writestb,Aint(5 downto 2));
-- 			ReadBISSControl0 <= OneOfNDecode(BISSs,BISSControlSel0,Readstb,Aint(5 downto 2));
-- 			ReadBISSControl1 <= OneOfNDecode(BISSs,BISSControlSel1,Readstb,Aint(5 downto 2));
-- 		end process BISSDecodeProcess;
--
-- 		DoBISSPins: process(BISSClk, IOBitsCorein)
-- 		begin
-- 			for i in 0 to IOWidth -1 loop				-- loop through all the external I/O pins
-- 				if ThePinDesc(i)(15 downto 8) = BISSTag then 	-- this hideous masking of pinnumbers/vs pintype is why they should be separate bytes, maybe IDROM type 4...
-- 					case (ThePinDesc(i)(7 downto 0)) is	--secondary pin function, drop MSB
-- 						when BISSClkPin =>
-- 							IOBitsCorein(i) <= BISSClk(conv_integer(ThePinDesc(i)(23 downto 16)));
-- 						when BISSClkEnPin =>
-- 							IOBitsCorein(i) <= '0';			-- for RS-422 daughtercards that have drive enables
-- 						when BISSDAVPin =>
-- 							IOBitsCorein(i) <= BISSDAVBits(conv_integer(ThePinDesc(i)(23 downto 16)));
-- 						when BISSDataPin =>
-- 							BISSData(conv_integer(ThePinDesc(i)(23 downto 16))) <= IOBitsCorein(i);
-- 						when others => null;
-- 					end case;
-- 				end if;
-- 			end loop;
-- 		end process;
-- 	end generate;

-------------------------------------Standard UART---------------------------------------------------------
---------------------------------------------------------------------------------------------------------
--
-- 	makeuartrmod:  if UARTs >0  generate
-- 	signal LoadUARTRData: std_logic_vector(UARTs -1 downto 0);
-- 	signal LoadUARTRBitRate: std_logic_vector(UARTs -1 downto 0);
-- 	signal ReadUARTRBitrate: std_logic_vector(UARTs -1 downto 0);
-- 	signal ClearUARTRFIFO: std_logic_vector(UARTs -1 downto 0);
-- 	signal ReadUARTRFIFOCount: std_logic_vector(UARTs -1 downto 0);
-- 	signal ReadUARTRModeReg: std_logic_vector(UARTs -1 downto 0);
-- 	signal LoadUARTRModeReg: std_logic_vector(UARTs -1 downto 0);
-- 	signal UARTRFIFOHasData: std_logic_vector(UARTs -1 downto 0);
-- 	signal URData: std_logic_vector(UARTs -1 downto 0);
-- 	signal LoadUARTTData: std_logic_vector(UARTs -1 downto 0);
-- 	signal LoadUARTTBitRate: std_logic_vector(UARTs -1 downto 0);
-- 	signal LoadUARTTModeReg: std_logic_vector(UARTs -1 downto 0);
-- 	signal CLearUARTTFIFO: std_logic_vector(UARTs -1 downto 0);
-- 	signal ReadUARTTFIFOCount: std_logic_vector(UARTs -1 downto 0);
-- 	signal ReadUARTTBitrate: std_logic_vector(UARTs -1 downto 0);
-- 	signal ReadUARTTModeReg: std_logic_vector(UARTs -1 downto 0);
-- 	signal UARTTFIFOEmpty: std_logic_vector(UARTs -1 downto 0);
-- 	signal UTDrvEn: std_logic_vector(UARTs -1 downto 0);
-- 	signal UTData: std_logic_vector(UARTs -1 downto 0);
-- 	signal UARTTDataSel : std_logic;
-- 	signal UARTTBitrateSel : std_logic;
-- 	signal UARTTFIFOCountSel : std_logic;
-- 	signal UARTTModeRegSel : std_logic;
-- 	signal UARTRDataSel : std_logic;
-- 	signal UARTRBitrateSel : std_logic;
-- 	signal UARTRFIFOCountSel : std_logic;
-- 	signal UARTRModeRegSel : std_logic;
--
-- 	begin
-- 		makeuartrs: for i in 0 to UARTs -1 generate
-- 			auarrx: entity work.uartr
-- 			port map (
-- 				clk => clklow,
-- 				ibus => ibusint,
-- 				obus => obusint,
-- 				addr => Aint(3 downto 2),
-- 				popfifo => LoadUARTRData(i),
-- 				loadbitrate => LoadUARTRBitRate(i),
-- 				readbitrate => ReadUARTRBitrate(i),
-- 				clrfifo => ClearUARTRFIFO(i),
-- 				readfifocount => ReadUARTRFIFOCount(i),
-- 				loadmode => LoadUARTRModeReg(i),
-- 				readmode => ReadUARTRModeReg(i),
-- 				fifohasdata => UARTRFIFOHasData(i),
-- 				rxmask => UTDrvEn(i),			-- for half duplex rx mask
-- 				rxdata => URData(i)
-- 				);
-- 		end generate;
--
-- 		UARTRDecodeProcess : process (Aint,Readstb,writestb,UARTRDataSel,UARTRBitRateSel,UARTRFIFOCountSel,UARTRModeRegSel)
-- 		begin
-- 			if Aint(AddrWidth-1 downto 8) = UARTRDataAddr then	 --  UART RX data register select
-- 				UARTRDataSel <= '1';
-- 			else
-- 				UARTRDataSel <= '0';
-- 			end if;
-- 			if Aint(AddrWidth-1 downto 8) = UARTRFIFOCountAddr then	 --  UART RX FIFO count register select
-- 				UARTRFIFOCountSel <= '1';
-- 			else
-- 				UARTRFIFOCountSel <= '0';
-- 			end if;
-- 			if Aint(AddrWidth-1 downto 8) = UARTRBitrateAddr then	 --  UART RX bit rate register select
-- 				UARTRBitrateSel <= '1';
-- 			else
-- 				UARTRBitrateSel <= '0';
-- 			end if;
-- 			if Aint(AddrWidth-1 downto 8) = UARTRModeRegAddr then	 --  UART RX status register select
-- 				UARTRModeRegSel <= '1';
-- 			else
-- 				UARTRModeRegSel <= '0';
-- 			end if;			LoadUARTRData <= OneOfNDecode(UARTs,UARTRDataSel,Readstb,Aint(7 downto 4));
-- 			LoadUARTRBitRate <= OneOfNDecode(UARTs,UARTRBitRateSel,writestb,Aint(7 downto 4));
-- 			ReadUARTRBitrate <= OneOfNDecode(UARTs,UARTRBitRateSel,Readstb,Aint(7 downto 4));
-- 			ClearUARTRFIFO <= OneOfNDecode(UARTs,UARTRFIFOCountSel,writestb,Aint(7 downto 4));
-- 			ReadUARTRFIFOCount <= OneOfNDecode(UARTs,UARTRFIFOCountSel,Readstb,Aint(7 downto 4));
-- 			LoadUARTRModeReg <= OneOfNDecode(UARTs,UARTRModeRegSel,writestb,Aint(7 downto 4));
-- 			ReadUARTRModeReg <= OneOfNDecode(UARTs,UARTRModeRegSel,Readstb,Aint(7 downto 4));
-- 		end process UARTRDecodeProcess;
--
-- 		DoUARTRPins: process(IOBitsCorein)
-- 		begin
-- 			for i in 0 to IOWidth -1 loop				-- loop through all the external I/O pins
-- 				if ThePinDesc(i)(15 downto 8) = UARTRTag then 	-- this hideous masking of pinnumbers/vs pintype is why they should be separate bytes, maybe IDROM type 4...
-- 					if (ThePinDesc(i)(7 downto 0)) = URDataPin then
-- 						URData(conv_integer(ThePinDesc(i)(23 downto 16))) <= IOBitsCorein(i);
-- 					end if;
-- 				end if;
-- 			end loop;
-- 		end process;
--
-- 		DoLocalUARTRPins: process(LIOBits) -- only for 4I90 LIO currently
-- 		begin
-- 			for i in 0 to LIOWidth -1 loop				-- loop through all the local I/O pins
-- 				report("Doing UARTR LIOLoop: "& integer'image(i));
-- 				if ThePinDesc(i+IOWidth)(15 downto 8) = UARTRTag then 	-- GTag (Local I/O starts at end of external I/O)
-- 					if (ThePinDesc(i+IOWidth)(7 downto 0)) = URDataPin then
-- 						URData(conv_integer(ThePinDesc(i+IOWidth)(23 downto 16))) <= LIOBits(i);
-- 						report("Local URDataPin found at LIOBit " & integer'image(i));
-- 					end if;
-- 				end if;
-- 			end loop;
-- 		end process;
--
-- 		makeuarttxs: for i in 0 to UARTs -1 generate
-- 			auartx:  entity work.uartx
-- 			port map (
-- 				clk => clklow,
-- 				ibus => ibusint,
-- 				obus => obusint,
-- 				addr => Aint(3 downto 2),
-- 				pushfifo => LoadUARTTData(i),
-- 				loadbitrate => LoadUARTTBitRate(i),
-- 				readbitrate => ReadUARTTBitrate(i),
-- 				clrfifo => ClearUARTTFIFO(i),
-- 				readfifocount => ReadUARTTFIFOCount(i),
-- 				loadmode => LoadUARTTModeReg(i),
-- 				readmode => ReadUARTTModeReg(i),
-- 				fifoempty => UARTTFIFOEmpty(i),
-- 				txen => '1',
-- 				drven => UTDrvEn(i),
-- 				txdata => UTData(i)
-- 				);
-- 		end generate;
--
-- 		UARTTDecodeProcess : process (Aint,Readstb,writestb,UARTTDataSel,UARTTBitRateSel,UARTTModeRegSel,UARTTFIFOCountSel)
-- 		begin
-- 			if Aint(AddrWidth-1 downto 8) = UARTTDataAddr then	 --  UART TX data register select
-- 				UARTTDataSel <= '1';
-- 			else
-- 				UARTTDataSel <= '0';
-- 			end if;
-- 			if Aint(AddrWidth-1 downto 8) = UARTTFIFOCountAddr then	 --  UART TX FIFO count register select
-- 				UARTTFIFOCountSel <= '1';
-- 			else
-- 				UARTTFIFOCountSel <= '0';
-- 			end if;
-- 			if Aint(AddrWidth-1 downto 8) = UARTTBitrateAddr then	 --  UART TX bit rate register select
-- 				UARTTBitrateSel <= '1';
-- 			else
-- 				UARTTBitrateSel <= '0';
-- 			end if;
-- 			if Aint(AddrWidth-1 downto 8) = UARTTModeRegAddr then	 --  UART TX bit mode register select
-- 				UARTTModeRegSel <= '1';
-- 			else
-- 				UARTTModeRegSel <= '0';
-- 			end if;
-- 			LoadUARTTData <= OneOfNDecode(UARTs,UARTTDataSel,writestb,Aint(7 downto 4));
-- 			LoadUARTTBitRate <= OneOfNDecode(UARTs,UARTTBitRateSel,writestb,Aint(7 downto 4));
-- 			ReadUARTTBitrate <= OneOfNDecode(UARTs,UARTTBitRateSel,Readstb,Aint(7 downto 4));
-- 			LoadUARTTModeReg <= OneOfNDecode(UARTs,UARTTModeRegSel,writestb,Aint(7 downto 4));
-- 				ReadUARTTModeReg <= OneOfNDecode(UARTs,UARTTModeRegSel,Readstb,Aint(7 downto 4));
-- 			ClearUARTTFIFO <= OneOfNDecode(UARTs,UARTTFIFOCountSel,writestb,Aint(7 downto 4));
-- 			ReadUARTTFIFOCount <= OneOfNDecode(UARTs,UARTTFIFOCountSel,Readstb,Aint(7 downto 4));
-- 		end process UARTTDecodeProcess;
--
-- 		DoUARTTPins: process(UTData, UTDrvEn)
-- 		begin
-- 			for i in 0 to IOWidth -1 loop				-- loop through all the external I/O pins
-- 				if ThePinDesc(i)(15 downto 8) = UARTTTag then 	-- this hideous masking of pinnumbers/vs pintype is why they should be separate bytes, maybe IDROM type 4...
-- 					case (ThePinDesc(i)(7 downto 0)) is	--secondary pin function
-- 						when UTDataPin =>
-- 							IOBitsCorein(i) <= UTData(conv_integer(ThePinDesc(i)(23 downto 16)));
-- 						when UTDrvEnPin =>
-- 							IOBitsCorein(i) <=  not UTDrvEn(conv_integer(ThePinDesc(i)(23 downto 16))); -- ExtIO is active low enable
-- 						when others => null;
-- 					end case;
-- 				end if;
-- 			end loop;
-- 		end process;
--
-- 		DoLocalUARTTPins: process(UTData, UTDrvEn)
-- 		begin
-- 			for i in 0 to LIOWidth -1 loop				-- loop through all the local I/O pins
-- 				report("Doing UARTT LIOLoop: "& integer'image(i));
-- 				if ThePinDesc(IOWidth+i)(15 downto 8) = UARTTTag then 	-- this hideous masking of pinnumbers/vs pintype is why they should be separate bytes, maybe IDROM type 4...
-- 					case (ThePinDesc(IOWidth+i)(7 downto 0)) is	--secondary pin function
-- 						when UTDataPin =>
-- 							LIOBits(i) <= UTData(conv_integer(ThePinDesc(IOWidth+i)(23 downto 16)));
-- 							report("Local UTDataPin found at LIOBit " & integer'image(i));
-- 						when UTDrvEnPin =>
-- 							LIOBits(i) <= UTDrvEn(conv_integer(ThePinDesc(IOWidth+i)(23 downto 16))); --LIO is active high enable
-- 							report("Local UTDrvEnPin found at LIOBit " & integer'image(i));
-- 						when others => null;
-- 					end case;
-- 				end if;
-- 			end loop;
-- 		end process;
--
-- 	end generate;

-------------------------------------Packet UART---------------------------------------------------------
---------------------------------------------------------------------------------------------------------
--
-- 	makepktuartrmod:  if PktUARTs >0  generate
-- 	signal ReadPktUARTRData: std_logic_vector(PktUARTs -1 downto 0);
-- 	signal LoadPktUARTRBitRate: std_logic_vector(PktUARTs -1 downto 0);
-- 	signal ReadPktUARTRBitrate: std_logic_vector(PktUARTs -1 downto 0);
-- 	signal ReadPktUARTRFrameCount: std_logic_vector(PktUARTs -1 downto 0);
-- 	signal ReadPktUARTRModeReg: std_logic_vector(PktUARTs -1 downto 0);
-- 	signal LoadPktUARTRModeReg: std_logic_vector(PktUARTs -1 downto 0);
-- 	signal PktURData: std_logic_vector(PktUARTs -1 downto 0);
-- 	signal LoadPktUARTTData: std_logic_vector(PktUARTs -1 downto 0);
-- 	signal LoadPktUARTTFrameCount: std_logic_vector(PktUARTs -1 downto 0);
-- 	signal ReadPktUARTTFrameCount: std_logic_vector(PktUARTs -1 downto 0);
-- 	signal LoadPktUARTTBitRate: std_logic_vector(PktUARTs -1 downto 0);
-- 	signal ReadPktUARTTBitrate: std_logic_vector(PktUARTs -1 downto 0);
-- 	signal LoadPktUARTTModeReg: std_logic_vector(PktUARTs -1 downto 0);
-- 	signal ReadPktUARTTModeReg: std_logic_vector(PktUARTs -1 downto 0);
-- 	signal PktUTDrvEn: std_logic_vector(PktUARTs -1 downto 0);
-- 	signal PktUTData: std_logic_vector(PktUARTs -1 downto 0);
-- 	signal PktUARTTDataSel : std_logic;
-- 	signal PktUARTTBitrateSel : std_logic;
-- 	signal PktUARTTFrameCountSel : std_logic;
-- 	signal PktUARTTModeRegSel : std_logic;
-- 	signal PktUARTRDataSel : std_logic;
-- 	signal PktUARTRBitrateSel : std_logic;
-- 	signal PktUARTRFrameCountSel : std_logic;
-- 	signal PktUARTRModeRegSel : std_logic;
--
-- 	begin
-- 		makepktuartrs: for i in 0 to PktUARTs -1 generate
-- 			pktauarrx: entity work.pktuartr
-- 			generic map (
-- 				MaxFrameSize => 1024 )
-- 			port map (
-- 				clk => clklow,
-- 				ibus => ibusint,
-- 				obus => obusint,
-- 				popdata => ReadPktUARTRData(i),
-- 				poprc => ReadPktUARTRFrameCount(i),
-- 				loadbitrate => LoadPktUARTRBitRate(i),
-- 				readbitrate => ReadPktUARTRBitrate(i),
-- 				loadmode => LoadPktUARTRModeReg(i),
-- 				readmode => ReadPktUARTRModeReg(i),
-- 				rxmask => PktUTDrvEn(i),			-- for half duplex rx mask
-- 				rxdata => PktURData(i)
-- 				);
-- 		end generate;
--
-- 		PktUARTRDecodeProcess : process (Aint,Readstb,writestb,PktUARTRDataSel,PktUARTRBitRateSel,
-- 		                                 PktUARTRFrameCountSel,PktUARTRModeRegSel)
-- 		begin
-- 			if Aint(AddrWidth-1 downto 8) = PktUARTRDataAddr then	 --  PktUART RX data register select
-- 				PktUARTRDataSel <= '1';
-- 			else
-- 				PktUARTRDataSel <= '0';
-- 			end if;
-- 			if Aint(AddrWidth-1 downto 8) = PktUARTRFrameCountAddr then	 --  PktUART RX FIFO count register select
-- 				PktUARTRFrameCountSel <= '1';
-- 			else
-- 				PktUARTRFrameCountSel <= '0';
-- 			end if;
-- 			if Aint(AddrWidth-1 downto 8) = PktUARTRBitrateAddr then	 --  PktUART RX bit rate register select
-- 				PktUARTRBitrateSel <= '1';
-- 			else
-- 				PktUARTRBitrateSel <= '0';
-- 			end if;
-- 			if Aint(AddrWidth-1 downto 8) = PktUARTRModeRegAddr then	 --  PktUART RX status register select
-- 				PktUARTRModeRegSel <= '1';
-- 			else
-- 				PktUARTRModeRegSel <= '0';
-- 			end if;
--
-- 			ReadPktUARTRData <= OneOfNDecode(PktUARTs,PktUARTRDataSel,Readstb,Aint(5 downto 2));
-- 			LoadPktUARTRBitRate <= OneOfNDecode(PktUARTs,PktUARTRBitRateSel,writestb,Aint(5 downto 2));
-- 			ReadPktUARTRBitrate <= OneOfNDecode(PktUARTs,PktUARTRBitRateSel,Readstb,Aint(5 downto 2));
-- 			ReadPktUARTRFrameCount <= OneOfNDecode(PktUARTs,PktUARTRFrameCountSel,Readstb,Aint(5 downto 2));
-- 			LoadPktUARTRModeReg <= OneOfNDecode(PktUARTs,PktUARTRModeRegSel,writestb,Aint(5 downto 2));
-- 			ReadPktUARTRModeReg <= OneOfNDecode(PktUARTs,PktUARTRModeRegSel,Readstb,Aint(5 downto 2));
--
-- 		end process PktUARTRDecodeProcess;
--
-- 		DoPktUARTRPins: process(IOBitsCorein)
-- 		begin
-- 			for i in 0 to IOWidth -1 loop				-- loop through all the external I/O pins
-- 				if ThePinDesc(i)(15 downto 8) = PktUARTRTag then 	-- this hideous masking of pinnumbers/vs pintype is why they should be separate bytes, maybe IDROM type 4...
-- 					if (ThePinDesc(i)(7 downto 0)) = PktURDataPin then
-- 						PktURData(conv_integer(ThePinDesc(i)(23 downto 16))) <= IOBitsCorein(i);
-- 					end if;
-- 				end if;
-- 			end loop;
-- 		end process;
--
-- 		DoLocalPktUARTRPins: process(IOBitsCorein) -- only for 4I90 LIO currently
-- 		begin
-- 			for i in 0 to LIOWidth -1 loop				-- loop through all the local I/O pins
-- 				report("Doing PktUARTR LIOLoop: "& integer'image(i));
-- 				if ThePinDesc(i+IOWidth)(15 downto 8) = PktUARTRTag then 	-- GTag (Local I/O starts at end of external I/O)
-- 					if (ThePinDesc(i+IOWidth)(7 downto 0)) = PktURDataPin then
-- 						PktURData(conv_integer(ThePinDesc(i+IOWidth)(23 downto 16))) <= LIOBits(i);
-- 						report("Local PktURDataPin found at LIOBit " & integer'image(i));
-- 					end if;
-- 				end if;
-- 			end loop;
-- 		end process;
--
-- 		makepktuarttxs: for i in 0 to PktUARTs -1 generate
-- 			apktuartx:  entity work.pktuartx
-- 			generic map (
-- 				MaxFrameSize => 1024 )
-- 			port map (
-- 				clk => clklow,
-- 				ibus => ibusint,
-- 				obus => obusint,
-- 				pushdata => LoadPktUARTTData(i),
-- 				pushsc	=> LoadPktUARTTFrameCount(i),
-- 				readsc   => ReadPktUARTTFrameCount(i),
-- 				loadbitrate => LoadPktUARTTBitRate(i),
-- 				readbitrate => ReadPktUARTTBitrate(i),
-- 				loadmode => LoadPktUARTTModeReg(i),
-- 				readmode => ReadPktUARTTModeReg(i),
-- 				drven => PktUTDrvEn(i),
-- 				txdata => PktUTData(i)
-- 				);
-- 		end generate;
--
-- 		PktUARTTDecodeProcess : process (Aint,readstb,writestb,PktUARTTDataSel,PktUARTTBitRateSel,
-- 													PktUARTTModeRegSel,PktUARTTFrameCountSel)
-- 		begin
-- 			if Aint(AddrWidth-1 downto 8) = PktUARTTDataAddr then	 --  PktUART TX data register select
-- 				PktUARTTDataSel <= '1';
-- 			else
-- 				PktUARTTDataSel <= '0';
-- 			end if;
-- 			if Aint(AddrWidth-1 downto 8) = PktUARTTFrameCountAddr then	 --  PktUART TX FIFO count register select
-- 				PktUARTTFrameCountSel <= '1';
-- 			else
-- 				PktUARTTFrameCountSel <= '0';
-- 			end if;
-- 			if Aint(AddrWidth-1 downto 8) = PktUARTTBitrateAddr then	 --  PktUART TX bit rate register select
-- 				PktUARTTBitrateSel <= '1';
-- 			else
-- 				PktUARTTBitrateSel <= '0';
-- 			end if;
-- 			if Aint(AddrWidth-1 downto 8) = PktUARTTModeRegAddr then	 --  PktUART TX bit mode register select
-- 				PktUARTTModeRegSel <= '1';
-- 			else
-- 				PktUARTTModeRegSel <= '0';
-- 			end if;
-- 			LoadPktUARTTData <= OneOfNDecode(PktUARTs,PktUARTTDataSel,writestb,Aint(5 downto 2));
-- 			LoadPktUARTTFrameCount <= OneOfNDecode(PktUARTs,PktUARTTFrameCountSel,writestb,Aint(5 downto 2));
-- 			ReadPktUARTTFrameCount <= OneOfNDecode(PktUARTs,PktUARTTFrameCountSel,readstb,Aint(5 downto 2));
-- 			LoadPktUARTTBitRate <= OneOfNDecode(PktUARTs,PktUARTTBitRateSel,writestb,Aint(5 downto 2));
-- 			ReadPktUARTTBitrate <= OneOfNDecode(PktUARTs,PktUARTTBitRateSel,Readstb,Aint(5 downto 2));
-- 			LoadPktUARTTModeReg <= OneOfNDecode(PktUARTs,PktUARTTModeRegSel,writestb,Aint(5 downto 2));
-- 			ReadPktUARTTModeReg <= OneOfNDecode(PktUARTs,PktUARTTModeRegSel,Readstb,Aint(5 downto 2));
-- 		end process PktUARTTDecodeProcess;
--
-- 		DoPktUARTTPins: process(PktUTData, PktUTDrvEn)
-- 		begin
-- 			for i in 0 to IOWidth -1 loop				-- loop through all the external I/O pins
-- 				if ThePinDesc(i)(15 downto 8) = PktUARTTTag then 	-- this hideous masking of pinnumbers/vs pintype is why they should be separate bytes, maybe IDROM type 4...
-- 					case (ThePinDesc(i)(7 downto 0)) is	--secondary pin function
-- 						when PktUTDataPin =>
-- 							IOBitsCorein(i) <= PktUTData(conv_integer(ThePinDesc(i)(23 downto 16)));
-- 						when UTDrvEnPin =>
-- 							IOBitsCorein(i) <=  not PktUTDrvEn(conv_integer(ThePinDesc(i)(23 downto 16))); -- ExtIO is active low enable
-- 						when others => null;
-- 					end case;
-- 				end if;
-- 			end loop;
-- 		end process;
--
-- 		DoLocalPktUARTTPins: process(PktUTData, PktUTDrvEn)
-- 		begin
-- 			for i in 0 to LIOWidth -1 loop				-- loop through all the local I/O pins
-- 				report("Doing PktUARTT LIOLoop: "& integer'image(i));
-- 				if ThePinDesc(IOWidth+i)(15 downto 8) = PktUARTTTag then 	-- this hideous masking of pinnumbers/vs pintype is why they should be separate bytes, maybe IDROM type 4...
-- 					case (ThePinDesc(IOWidth+i)(7 downto 0)) is	--secondary pin function
-- 						when PktUTDataPin =>
-- 							LIOBits(i) <= PktUTData(conv_integer(ThePinDesc(IOWidth+i)(23 downto 16)));
-- 							report("Local PktUTDataPin found at LIOBit " & integer'image(i));
-- 						when UTDrvEnPin =>
-- 							LIOBits(i) <= PktUTDrvEn(conv_integer(ThePinDesc(IOWidth+i)(23 downto 16))); --LIO is active high enable
-- 							report("Local PktUTDrvEnPin found at LIOBit " & integer'image(i));
-- 						when others => null;
-- 					end case;
-- 				end if;
-- 			end loop;
-- 		end process;
--
-- 	end generate;
--
-- 	makebinoscmod:  if BinOscs >0  generate
-- 	signal LoadBinOscEna: std_logic_vector(BinOscs -1 downto 0);
-- 	type BinOscOutType is array(BinOscs-1 downto 0) of std_logic_vector(BinOscWidth-1 downto 0);
-- 	signal BinOscOut: BinOscOutType;
-- 	signal LoadBinOscEnaSel: std_logic;
-- 	begin
-- 		makebinoscs: for i in 0 to BinOscs -1 generate
-- 			aBinOsc: entity work.binosc
-- 			generic map (
-- 				width => BinOscWidth
-- 				)
-- 			port map (
-- 				clk => clklow,
-- 				ibus0 => ibusint(0),
-- 				loadena => LoadBinOscEna(i),
-- 				oscout => BinOscOut(i)
-- 				);
-- 		end generate;
--
-- 		BinOscDecodeProcess : process (Aint,writestb,LoadBinOscEnaSel)
-- 		begin
-- 			if Aint(AddrWidth-1 downto 8) = BinOscEnaAddr then	 	--  Charge Pump Power Supply enable decode
-- 				LoadBinOscEnaSel <= '1';
-- 			else
-- 				LoadBinOscEnaSel <= '0';
-- 			end if;
-- 			LoadBinOscEna <= OneOfNDecode(BinOscs,LoadBinOscEnaSel,writestb,Aint(5 downto 2)); -- 16 max
-- 		end process BinOscDecodeProcess;
--
-- 		DoBinOscPins: process(BinOscOut)
-- 		begin
-- 			for i in 0 to IOWidth -1 loop				-- loop through all the external I/O pins
-- 				if ThePinDesc(i)(15 downto 8) = BinOscTag then 	-- this hideous masking of pinnumbers/vs pintype is why they should be separate bytes, maybe IDROM type 4...
-- 					IOBitsCorein(i) <= BinOscOut(conv_integer(ThePinDesc(i)(23 downto 16)))(conv_integer(ThePinDesc(i)(6 downto 0))-1);
-- 					report("External BinOscOutPin found");
-- 				end if;
-- 			end loop;
-- 		end process;
--
-- 		DoLocalBinOscPins: process(BinOscOut) -- only for 4I69 LIO currently
-- 		begin
-- 			for i in 0 to LIOWidth -1 loop				-- loop through all the local I/O pins
-- 				if ThePinDesc(i+IOWidth)(15 downto 8) = BinOscTag then	-- GTag (Local I/O starts at end of external I/O)
-- 					LIOBits(i) <= BinOscOut(conv_integer(ThePinDesc(i+IOWidth)(23 downto 16)))(conv_integer(ThePinDesc(i+IOWIDTH)(6 downto 0))-1);
-- 					report("Local BinOscOutPin found");
-- 				end if;
-- 			end loop;
-- 		end process;
-- 	end generate;
--
-- 	makewavegenmod:  if WaveGens >0  generate
-- 	signal LoadWaveGenRate: std_logic_vector(WaveGens -1 downto 0);
-- 	signal LoadWaveGenLength: std_logic_vector(WaveGens -1 downto 0);
-- 	signal LoadWaveGenPDMRate: std_logic_vector(WaveGens -1 downto 0);
-- 	signal LoadWaveGenTablePtr: std_logic_vector(WaveGens -1 downto 0);
-- 	signal LoadWaveGenTableData: std_logic_vector(WaveGens -1 downto 0);
-- 	signal WavegenPDMA: std_logic_vector(WaveGens -1 downto 0);
-- 	signal WaveGenPDMB: std_logic_vector(WaveGens -1 downto 0);
-- 	signal WaveGenTrigger0: std_logic_vector(WaveGens -1 downto 0);
-- 	signal WaveGenTrigger1: std_logic_vector(WaveGens -1 downto 0);
-- 	signal WaveGenTrigger2: std_logic_vector(WaveGens -1 downto 0);
-- 	signal WaveGenTrigger3: std_logic_vector(WaveGens -1 downto 0);
-- 	signal WaveGenRateSel: std_logic;
-- 	signal WaveGenLengthSel: std_logic;
-- 	signal WaveGenPDMRateSel: std_logic;
-- 	signal WaveGenTablePtrSel: std_logic;
-- 	signal WaveGenTableDataSel: std_logic;
-- 	begin
-- 		makewavegens: for i in 0 to WaveGens -1 generate
-- 			awavegen:  entity work.wavegen
-- 			port map (
-- 				clk => clklow,
-- 				hclk => clkhigh,
-- 				ibus => ibusint,
-- --				obus => obusint,
-- 				loadrate => LoadWaveGenRate(i),
-- 				loadlength => LoadWaveGenLength(i),
-- 				loadpdmrate => LoadWaveGenPDMRate(i),
-- 				loadtableptr => LoadWaveGenTablePtr(i),
-- 				loadtabledata =>LoadWaveGenTableData(i),
-- 				trigger0 => WaveGenTrigger0(i),
-- 				trigger1 => WaveGenTrigger1(i),
-- 				trigger2 => WaveGenTrigger2(i),
-- 				trigger3 => WaveGenTrigger3(i),
-- 				pdmouta => WaveGenPDMA(i),
-- 				pdmoutb => WaveGenPDMB(i)
-- 				);
-- 		end generate;
--
-- 		WaveGenDecodeProcess : process (Aint,Readstb,writestb,WaveGenRateSel,WaveGenLengthSel,
-- 			                             WaveGenPDMRateSel,WaveGenTablePtrSel,WaveGenTableDataSel)
-- 		begin
-- 			if Aint(AddrWidth-1 downto 8) = WaveGenRateAddr then	 --  WaveGen table index rate
-- 				WaveGenRateSel <= '1';
-- 			else
-- 				WaveGenRateSel <= '0';
-- 			end if;
-- 			if Aint(AddrWidth-1 downto 8) = WaveGenLengthAddr then	 --  WaveGen table length
-- 				WaveGenlengthSel <= '1';
-- 			else
-- 				WaveGenlengthSel <= '0';
-- 			end if;
-- 			if Aint(AddrWidth-1 downto 8) = WaveGenPDMRateAddr then	 --  WaveGen PDMRate
-- 				WaveGenPDMRateSel <= '1';
-- 			else
-- 				WaveGenPDMRateSel <= '0';
-- 			end if;
-- 			if Aint(AddrWidth-1 downto 8) = WaveGenTablePtrAddr then	 --  WaveGen TablePtr
-- 				WaveGenTablePtrSel <= '1';
-- 			else
-- 				WaveGenTablePtrSel <= '0';
-- 			end if;
-- 			if Aint(AddrWidth-1 downto 8) = WaveGenTableDataAddr then	 --  WaveGen TableData
-- 				WaveGenTableDataSel <= '1';
-- 			else
-- 				WaveGenTableDataSel <= '0';
-- 			end if;
-- 			LoadWaveGenRate <= OneOfNDecode(WaveGens,WaveGenRateSel,writestb,Aint(5 downto 2));
-- 			LoadWaveGenLength <= OneOfNDecode(WaveGens,WaveGenLengthSel,writestb,Aint(5 downto 2));
-- 			LoadWaveGenPDMRate <= OneOfNDecode(WaveGens,WaveGenPDMRateSel,writestb,Aint(5 downto 2));
-- 			LoadWaveGenTablePtr <= OneOfNDecode(WaveGens,WaveGenTablePtrSel,writestb,Aint(5 downto 2));
-- 			LoadWaveGenTableData <= OneOfNDecode(WaveGens,WaveGenTableDataSel,writestb,Aint(5 downto 2));
-- 		end process WaveGenDecodeProcess;
--
-- 		DoWaveGenPins: process(WaveGenPDMA,WaveGenPDMB, WaveGenTrigger0,
-- 										WaveGenTrigger1, WaveGenTrigger2, WaveGenTrigger3)
-- 		begin
-- 			for i in 0 to IOWidth -1 loop				-- loop through all the external I/O pins
-- 				if ThePinDesc(i)(15 downto 8) = WaveGenTag then 	-- this hideous masking of pinnumbers/vs pintype is why they should be separate bytes, maybe IDROM type 4...
-- 					case (ThePinDesc(i)(7 downto 0)) is	--secondary pin function, drop MSB
-- 						when PDMAOutPin =>
-- 							IOBitsCorein(i) <= WaveGenPDMA(conv_integer(ThePinDesc(i)(23 downto 16)));
-- 						when PDMBOutPin =>
-- 							IOBitsCorein(i) <= WaveGenPDMB(conv_integer(ThePinDesc(i)(23 downto 16)));
-- 						when Trigger0OutPin =>
-- 							IOBitsCorein(i) <= WaveGenTrigger0(conv_integer(ThePinDesc(i)(23 downto 16)));
-- 						when Trigger1OutPin =>
-- 							IOBitsCorein(i) <= WaveGenTrigger1(conv_integer(ThePinDesc(i)(23 downto 16)));
-- 						when Trigger2OutPin =>
-- 							IOBitsCorein(i) <= WaveGenTrigger2(conv_integer(ThePinDesc(i)(23 downto 16)));
-- 						when Trigger3OutPin =>
-- 							IOBitsCorein(i) <= WaveGenTrigger3(conv_integer(ThePinDesc(i)(23 downto 16)));
-- 						when others => null;
-- 					end case;
-- 				end if;
-- 			end loop;
-- 		end process;
-- 	end generate;
--
-- 	makeresolvermod:  if ResolverMods >0  generate
-- 	signal LoadResModCommand: std_logic_vector(ResolverMods -1 downto 0);
-- 	signal ReadResModCommand: std_logic_vector(ResolverMods -1 downto 0);
-- 	signal LoadResModData: std_logic_vector(ResolverMods -1 downto 0);
-- 	signal ReadResModData: std_logic_vector(ResolverMods -1 downto 0);
-- 	signal ReadResModStatus: std_logic_vector(ResolverMods -1 downto 0);
-- 	signal ReadResModVelRam: std_logic_vector(ResolverMods -1 downto 0);
-- 	signal ReadResModPosRam: std_logic_vector(ResolverMods -1 downto 0);
-- 	signal ResModPDMP: std_logic_vector(ResolverMods -1 downto 0);
-- 	signal ResModPDMM: std_logic_vector(ResolverMods -1 downto 0);
-- 	signal ResModSPICS: std_logic_vector(ResolverMods -1 downto 0);
-- 	signal ResModSPIClk: std_logic_vector(ResolverMods -1 downto 0);
-- 	signal ResModSPIDI0: std_logic_vector(ResolverMods -1 downto 0);
-- 	signal ResModSPIDI1: std_logic_vector(ResolverMods -1 downto 0);
-- 	signal ResModPwrEn: std_logic_vector(ResolverMods -1 downto 0);
-- 	signal ResModChan0: std_logic_vector(ResolverMods -1 downto 0);
-- 	signal ResModChan1: std_logic_vector(ResolverMods -1 downto 0);
-- 	signal ResModChan2: std_logic_vector(ResolverMods -1 downto 0);
-- 	signal ResModTestBit: std_logic_vector(ResolverMods -1 downto 0);
-- 	signal ResModCommandSel: std_logic;
-- 	signal ResModDataSel: std_logic;
-- 	signal ResModStatusSel: std_logic;
-- 	signal ResModVelRAMSel: std_logic;
-- 	signal ResModPosRAMSel: std_logic; 	begin
-- 		makeresolvers: for i in 0 to ResolverMods -1 generate
-- 			aresolver: entity work.resolver
-- 			port map(
-- 				clk => clklow,
-- 				ibus => ibusint,
-- 				obus => obusint,
-- 				hloadcommand => LoadResModCommand(i),
-- 				hreadcommand => ReadResModCommand(i),
-- 				hloaddata => LoadResModData(i),
-- 				hreaddata => ReadResModData(i),
-- 				hreadstatus => ReadResModStatus(i),
-- 				regaddr => addr(4 downto 2), 		-- early address for DPRAM access
-- 				readvel => ReadResModVelRam(i),
-- 				readpos => ReadResModPosRam(i),
-- 				testbit => ResModTestBit(i),
-- 				respdmp => ResModPDMP(i),
-- 				respdmm => ResModPDMM(i),
-- 				spics => ResModSPICS(i),
-- 				spiclk => ResModSPIClk(i),
-- 				spidi0 => ResModSPIDI0(i),
-- 				spidi1 => ResModSPIDI1(i),
-- 				pwren => ResModPwrEn(i),
-- 				chan0 => ResModChan0(i),
-- 				chan1 => ResModChan1(i),
-- 				chan2 => ResModChan2(i)
-- 				);
-- 		end generate;
--
--  		ResolverModDecodeProcess : process (Aint,Readstb,writestb,ResModCommandSel,ResModDataSel,ResModVelRAMSel,ResModPosRAMSel)
-- 		begin
-- 			if Aint(AddrWidth-1 downto 8) = ResModCommandAddr then
-- 				ResModCommandSel <= '1';
-- 			else
-- 				ResModCommandSel <= '0';
-- 			end if;
-- 			if Aint(AddrWidth-1 downto 8) = ResModDataAddr then
-- 				ResModDataSel <= '1';
-- 			else
-- 				ResModDataSel <= '0';
-- 			end if;
-- 			if Aint(AddrWidth-1 downto 8) = ResModStatusAddr then
-- 				ResModStatusSel <= '1';
-- 			else
-- 				ResModStatusSel <= '0';
-- 			end if;
-- 			if Aint(AddrWidth-1 downto 8) = ResModVelRAMAddr then
-- 				ResModVelRAMSel <= '1';
-- 			else
-- 				ResModVelRAMSel <= '0';
-- 			end if;
-- 			if Aint(AddrWidth-1 downto 8) = ResModPosRAMAddr then
-- 				ResModPosRAMSel <= '1';
-- 			else
-- 				ResModPosRAMSel <= '0';
-- 			end if;
-- 			LoadResModCommand <= OneOfNDecode(ResolverMods,ResModCommandSel,writestb,Aint(7 downto 6));
-- 			ReadResModCommand <= OneOfNDecode(ResolverMods,ResModCommandSel,Readstb,Aint(7 downto 6));
-- 			LoadResModData <= OneOfNDecode(ResolverMods,ResModDataSel,writestb,Aint(7 downto 6));
-- 			ReadResModData <= OneOfNDecode(ResolverMods,ResModDataSel,Readstb,Aint(7 downto 6));
-- 			ReadResModStatus <= OneOfNDecode(ResolverMods,ResModStatusSel,Readstb,Aint(7 downto 6));
-- 			ReadResModVelRam <= OneOfNDecode(ResolverMods,ResModVelRAMSel,Readstb,Aint(7 downto 6)); -- 16 addresses per resmod
-- 			ReadResModPosRam <= OneOfNDecode(ResolverMods,ResModPosRAMSel,Readstb,Aint(7 downto 6)); -- 16 addresses per resmod
-- 		end process ResolverModDecodeProcess;
--
-- 		DoResModPins: process(ResModPwrEn,ResModChan2,ResModChan1,ResModChan0,
-- 									 ResModSPIClk,ResModSPICS,ResModPDMM,ResModPDMP)
-- 		begin
-- 			for i in 0 to IOWidth -1 loop				-- loop through all the external I/O pins
-- 				if ThePinDesc(i)(15 downto 8) = ResModTag then
-- 					case (ThePinDesc(i)(7 downto 0)) is	--secondary pin function
-- 						when ResModPwrEnPin =>
-- 							IOBitsCorein(i) <= ResModPwrEn(conv_integer(ThePinDesc(i)(23 downto 16)));
-- 						when ResModPDMPPin =>
-- 							IOBitsCorein(i) <= ResModPDMP(conv_integer(ThePinDesc(i)(23 downto 16)));
-- 						when ResModPDMMPin =>
-- 							IOBitsCorein(i) <= ResModPDMM(conv_integer(ThePinDesc(i)(23 downto 16)));
-- 						when ResModChan0Pin =>
-- 							IOBitsCorein(i) <= ResModChan0(conv_integer(ThePinDesc(i)(23 downto 16)));
-- 						when ResModChan1Pin =>
-- 							IOBitsCorein(i) <= ResModChan1(conv_integer(ThePinDesc(i)(23 downto 16)));
-- 						when ResModChan2Pin =>
-- 							IOBitsCorein(i) <= ResModChan2(conv_integer(ThePinDesc(i)(23 downto 16)));
-- 						when ResModSPICSPin =>
-- 							IOBitsCorein(i) <= ResModSPICS(conv_integer(ThePinDesc(i)(23 downto 16)));
-- 						when ResModSPIClkPin =>
-- 							IOBitsCorein(i) <= ResModSPIClk(conv_integer(ThePinDesc(i)(23 downto 16)));
-- 						when ResModTestBitPin =>
-- 							IOBitsCorein(i) <= ResModTestBit(conv_integer(ThePinDesc(i)(23 downto 16)));
-- 						when ResModSPIDI0Pin =>
-- 							ResModSPIDI0(conv_integer(ThePinDesc(i)(23 downto 16))) <= IOBitsCorein(i);
-- 						when ResModSPIDI1Pin =>
-- 							ResModSPIDI1(conv_integer(ThePinDesc(i)(23 downto 16))) <= IOBitsCorein(i);
-- 						when others => null;
-- 					end case;
-- 				end if;
-- 			end loop;
-- 		end process;
-- 	end generate;

GenMakeSSerials: if SSerials >0  generate
    MakeSSerials : entity work.MakeSSerials
    generic map (
        ThePinDesc => ThePinDesc,
        ClockHigh => ClockHigh,
        ClockMed => ClockMed,
        ClockLow  => ClockLow,
        BusWidth  => BusWidth,
        AddrWidth  => AddrWidth,
        IOWidth  => IOWidth,
        STEPGENs  => STEPGENs,
        StepGenTableWidth => StepGenTableWidth,
        UseStepGenPreScaler => UseStepGenPreScaler,
        UseStepgenIndex => UseStepgenIndex,
        UseStepgenProbe => UseStepgenProbe,
        timersize  => 14,
        asize  => 48,
        rsize  => 32,
        HM2DPLLs => HM2DPLLs,
        MuxedQCounters  => MuxedQCounters,
        MuxedQCountersMIM  => MuxedQCountersMIM,
        PWMGens  => PWMGens,
        PWMRefWidth  => PWMRefWidth,
        UsePWMEnas  => UsePWMEnas,
        TPPWMGens  => TPPWMGens,
        QCounters  => QCounters,
        UseMuxedProbe  => UseMuxedProbe,
        UseProbe  => UseProbe,
        SPIs  => SPIs,
        BSPIs  => BSPIs,
        BSPICSWidth  => BSPICSWidth,
        DBSPIs  => DBSPIs,
        DBSPICSWidth  => DBSPICSWidth,
        SSerials  => SSerials,
        MaxUARTSPerSSerial  => MaxUARTSPerSSerial
        )
        port map (
            ibus			=>	ibusint,
            obusint			=>	obusint,
            Aint			=>	Aint,
            readstb			=>	readstb,
            writestb		=>	writestb,
            CoreDataOut		=>	CoreDataOut,
            IOBitsCorein	=>	IOBitsCorein,
            clklow			=>	clklow,
            clkmed			=>	clkmed,
            clkhigh			=>	clkhigh,
            PRobe			=>  PRobe,
            RateSources		=>  RateSources,
            rates			=>  rates
        );
end generate;
--
-- 	maketwiddlermod:  if Twiddlers >0  generate
-- 	signal LoadTwiddlerCommand: std_logic_vector(Twiddlers -1 downto 0);
-- 	signal ReadTwiddlerCommand: std_logic_vector(Twiddlers -1 downto 0);
-- 	signal LoadTwiddlerData: std_logic_vector(Twiddlers -1 downto 0);
-- 	signal ReadTwiddlerData: std_logic_vector(Twiddlers -1 downto 0);
-- 	signal LoadTwiddlerRAM: std_logic_vector(Twiddlers -1 downto 0);
-- 	signal ReadTwiddlerRAM: std_logic_vector(Twiddlers -1 downto 0);
-- 	type  TwiddlerInputType is array(Twiddlers-1 downto 0) of std_logic_vector(InputsPerTwiddler-1 downto 0);
-- 	signal TwiddlerInput: TwiddlerInputType;
-- 	type  TwiddlerOutputType is array(Twiddlers-1 downto 0) of std_logic_vector(OutputsPerTwiddler-1 downto 0);
-- 	signal TwiddlerOutput: TwiddlerOutputType;
-- 	signal TwiddlerCommandSel: std_logic;
-- 	signal TwiddlerDataSel: std_logic;
-- 	signal TwiddlerRAMSel: std_logic;
-- 	begin
-- 		maketwiddlers: for i in 0 to Twiddlers -1 generate
-- 			atwiddler: entity work.twiddle
-- 			generic map (
-- 				InterfaceRegs => RegsPerTwiddler,	-- must be power of 2
-- 				InputBits => InputsPerTwiddler,
-- 				OutputBits => OutputsPerTwiddler,
-- 				BaseClock => ClockLow
-- 			)
-- 			port map(
-- 				clk  => clklow,
-- 				ibus  => ibusint,
-- 				obus  => obusint,
-- 				hloadcommand  => LoadTwiddlerCommand(i),
-- 				hreadcommand  => ReadTwiddlerCommand(i),
-- 				hloaddata  => LoadTwiddlerData(i),
-- 				hreaddata  => ReadTwiddlerData(i),
-- 				regraddr  =>  addr(log2(RegsPerTwiddler)+1 downto 2),	-- early address for DPRAM access
-- 				regwaddr  =>  Aint(log2(RegsPerTwiddler)+1 downto 2),
-- 				hloadregs  => LoadTwiddlerRAM(i),
-- 				hreadregs  => ReadTwiddlerRAM(i),
-- 				ibits  =>  TwiddlerInput(i),
-- 				obits  =>  TwiddlerOutput(i)
-- --				testbit  =>   TwiddlerTestBits(i)
-- 				);
-- 		end generate;
--
-- 		TwiddleDecodeProcess : process (Aint,Readstb,writestb,TwiddlerCommandSel,TwiddlerDataSel,TwiddlerRAMSel)
-- 		begin
-- 			if Aint(AddrWidth-1 downto 8) = TwiddlerCommandAddr then
-- 				TwiddlerCommandSel <= '1';
-- 			else
-- 				TwiddlerCommandSel <= '0';
-- 			end if;
-- 			if Aint(AddrWidth-1 downto 8) = TwiddlerDataAddr then
-- 				TwiddlerDataSel <= '1';
-- 			else
-- 				TwiddlerDataSel <= '0';
-- 			end if;
-- 			if Aint(AddrWidth-1 downto 8) = TwiddlerRAMAddr then
-- 				TwiddlerRAMSel <= '1';
-- 			else
-- 				TwiddlerRAMSel <= '0';
-- 			end if;
-- 			LoadTwiddlerCommand <= OneOfNDecode(Twiddlers,TwiddlerCommandSel,writestb,Aint(5 downto 2));
-- 			ReadTwiddlerCommand <= OneOfNDecode(Twiddlers,TwiddlerCommandSel,Readstb,Aint(5 downto 2));
-- 			LoadTwiddlerData <= OneOfNDecode(Twiddlers,TwiddlerDataSel,writestb,Aint(5 downto 2));
-- 			ReadTwiddlerData <= OneOfNDecode(Twiddlers,TwiddlerDataSel,Readstb,Aint(5 downto 2));
-- 			LoadTwiddlerRam <= OneOfNDecode(Twiddlers,TwiddlerRAMSel,writestb,Aint(7 downto 6)); 	-- 16 addresses per Twiddle RAM max, this implies 4 max Twiddlers
-- 			ReadTwiddlerRam <= OneOfNDecode(Twiddlers,TwiddlerRAMSel,Readstb,Aint(7 downto 6)); 	-- 16 addresses per Twiddle RAM max
-- 		end process TwiddleDecodeProcess;
--
-- 		DoTwiddlerPins: process(TwiddlerOutput)
-- 		begin
-- 			for i in 0 to IOWidth -1 loop				-- loop through all the external I/O pins
-- 				if ThePinDesc(i)(15 downto 8) = TwiddlerTag then 	-- this hideous masking of pinnumbers/vs pintype is why they should be separate bytes, maybe IDROM type 4...
-- 					if (ThePinDesc(i)(7 downto 0) and x"C0") = x"80" then 	-- outs match 8X .. BX
-- 						IOBitsCorein(i) <=   TwiddlerOutput(conv_integer(ThePinDesc(i)(23 downto 16)))(conv_integer(ThePinDesc(i)(5 downto 0))-1);	--  max ports, more than 8 requires adding to IDROM pins
-- 					end if;
-- 					if (ThePinDesc(i)(7 downto 0) and x"C0") = x"00" then 	-- ins match 0X .. 3X
-- 						TwiddlerInput(conv_integer(ThePinDesc(i)(23 downto 16)))(conv_integer(ThePinDesc(i)(5 downto 0))-1) <= IOBitsCorein(i);		-- 16 max ports
-- 					end if;
-- 					if (ThePinDesc(i)(7 downto 0) and x"C0") = x"C0" then 	-- I/Os match CX .. FX
-- 						TwiddlerInput(conv_integer(ThePinDesc(i)(23 downto 16)))(conv_integer(ThePinDesc(i)(5 downto 0))-1) <= IOBitsCorein(i);		-- 16 max ports
-- 						IOBitsCorein(i) <= TwiddlerOutput(conv_integer(ThePinDesc(i)(23 downto 16)))(conv_integer(ThePinDesc(i)(4 downto 0))-1); 	-- 16 max ports
-- 					end if;
-- 				end if;
-- 			end loop;
-- 		end process;
--
-- 	end generate;

-- 	makescalercounters: if ScalerCounters >0 generate -- note scaler counter are in pairs
-- 	signal ReadScalerCount: std_logic_vector(ScalerCounters-1 downto 0);
-- 	signal ReadScalerLatch: std_logic_vector(ScalerCounters-1 downto 0);
-- 	signal SCCountInA: std_logic_vector(ScalerCounters -1 downto 0);
-- 	signal SCCountInB: std_logic_vector(ScalerCounters -1 downto 0);
-- 	signal ScalerCountSel: std_logic;
-- 	signal ScalerLatchSel: std_logic;
-- 	signal ReadScalerTimer: std_logic;
--
-- 	begin
-- 		scalertimerx : entity work.scalertimer
-- 				port map (
-- 					obus => obusint,
-- 					readtimer => ReadScalerTimer,
-- 					clk => clklow
-- 					);
--
-- 		makescalercounters: for i in 0 to ScalerCounters-1 generate
-- 			scalercounterx: entity work.scalercounter
-- 				port map (
-- 					obus => obusint,
-- 					countina => SCCountInA(i),
-- 					countinb => SCCountInB(i),
-- 					readcount => ReadScalerCount(i),
-- 					readlatch => ReadScalerLatch(i),
-- 					latch => ReadScalerTimer,
-- 					clk =>	clklow
-- 				);
-- 		end generate;
--
-- 		DoScalerCounterPins: process(IOBitsCorein)
-- 		begin
-- 			for i in 0 to IOWidth -1 loop				-- loop through all the external I/O pins
-- 				if ThePinDesc(i)(15 downto 8) = ScalerCounterTag then 	-- this hideous masking of pinnumbers/vs pintype is why they should be separate bytes, maybe IDROM type 4...
-- 					if (ThePinDesc(i)(7 downto 0)) = ScalerCounterInA then
-- 						SCCountInA(conv_integer(ThePinDesc(i)(23 downto 16))) <= IOBitsCorein(i);
-- 					end if;
-- 					if (ThePinDesc(i)(7 downto 0)) = ScalerCounterInB then
-- 						SCCountInB(conv_integer(ThePinDesc(i)(23 downto 16))) <= IOBitsCorein(i);
-- 					end if;
-- 				end if;
-- 			end loop;
-- 		end process;
--
-- 		ScalerDecodeProcess : process (Aint,Readstb,ScalerCountSel,ScalerLatchSel)
-- 		begin
-- 			if Aint(AddrWidth-1 downto 8) = ScalerCountAddr then	 --
-- 				ScalerCountSel <= '1';
-- 			else
-- 				ScalerCountSel <= '0';
-- 			end if;
--
-- 			if Aint(AddrWidth-1 downto 8) = ScalerLatchAddr then	 --
-- 				ScalerLatchSel <= '1';
-- 			else
-- 				ScalerLatchSel <= '0';
-- 			end if;
--
-- 			if Aint(AddrWidth-1 downto 8) = ScalerTimerAddr and readstb = '1' then	 --
-- 				ReadScalerTimer <= '1';
-- 			else
-- 				ReadScalerTimer <= '0';
-- 			end if;
--
-- 			ReadScalerCount <= OneOfNDecode(ScalerCounters,ScalerCountSel,readstb,Aint(7 downto 2));
-- 			ReadScalerLatch <= OneOfNDecode(ScalerCounters,ScalerLatchSel,readstb,Aint(7 downto 2));
-- 		end process ScalerDecodeProcess;
--
-- 	end generate;

--   MuxedEncMIM: if  MuxedQCountersMIM > 0 generate
--
--		EncoderDeMuxMIM: process(clklow)
--		begin
--			if rising_edge(clklow) then
--				if MuxedQCountFilterRate = '1' then
--					PreMuxedQCtrSel <= PreMuxedQCtrSel + 1;
--				end if;
--				MuxedQCtrSel <= PreMuxedQCtrSel;
--				for i in 0 to ((MuxedQCounters/2) -1) loop -- just 2 deep for now
--					if PreMuxedQCtrSel(0) = '1' and MuxedQCtrSel(0) = '0' then	-- latch the even inputs
--						DeMuxedQuadA(2*i) <= MuxedQuadA(i);
--						DeMuxedQuadB(2*i) <= MuxedQuadB(i);
--						DeMuxedIndex(2*i) <= MuxedIndex(i);
--						DeMuxedIndexMask(2*i) <= MuxedIndexMask(i);
--					end if;
--					if PreMuxedQCtrSel(0) = '0' and MuxedQCtrSel(0) = '1' then	-- latch the odd inputs
--						DeMuxedQuadA(2*i+1) <= MuxedQuadA(i);
--						DeMuxedQuadB(2*i+1) <= MuxedQuadB(i);
--						DeMuxedIndex(2*i+1) <= MuxedIndex(i);
--						DeMuxedIndexMask(2*i+1) <= MuxedIndexMask(i);
--					end if;
--				end loop;
--			end if; -- clk
--		end process;
--	end generate;


end dataflow;

