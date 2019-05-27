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

entity MakeBSPIs is
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
        BSPICSWidth: integer);
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

end MakeBSPIs;


architecture dataflow of MakeBSPIs is

-- Signals

-- I/O port related signals

    begin
    makebspimod:  if BSPIs >0  generate
    signal LoadBSPIData: std_logic_vector(BSPIs -1 downto 0);
    signal ReadBSPIData: std_logic_vector(BSPIs -1 downto 0);
    signal LoadBSPIDescriptor: std_logic_vector(BSPIs -1 downto 0);
    signal ReadBSPIFIFOCOunt: std_logic_vector(BSPIs -1 downto 0);
    signal ClearBSPIFIFO: std_logic_vector(BSPIs -1 downto 0);
    signal BSPIClk: std_logic_vector(BSPIs -1 downto 0);
    signal BSPIIn: std_logic_vector(BSPIs -1 downto 0);
    signal BSPIOut: std_logic_vector(BSPIs -1 downto 0);
    signal BSPIFrame: std_logic_vector(BSPIs -1 downto 0);
    signal BSPIDataSel : std_logic;
    signal BSPIFIFOCountSel : std_logic;
    signal BSPIDescriptorSel : std_logic;
    type BSPICSType is array(BSPIs-1 downto 0) of std_logic_vector(BSPICSWidth-1 downto 0);
    signal BSPICS : BSPICSType;
    begin
        makebspis: for i in 0 to BSPIs -1 generate
            bspi: entity work.BufferedSPI
            generic map (
                cswidth => BSPICSWidth,
                gatedcs => false)
            port map (
                clk  => clklow,
                ibus => ibus,
                obus => obusint,
                addr => Aint(5 downto 2),
                hostpush => LoadBSPIData(i),
                hostpop => ReadBSPIData(i),
                loaddesc => LoadBSPIDescriptor(i),
                loadasend => '0',
                clear => ClearBSPIFIFO(i),
                readcount => ReadBSPIFIFOCount(i),
                spiclk => BSPIClk(i),
                spiin => BSPIIn(i),
                spiout => BSPIOut(i),
                spiframe => BSPIFrame(i),
                spicsout => BSPICS(i)
                );
        end generate;

        BSPIDecodeProcess : process (Aint,readstb,writestb,BSPIDataSel,BSPIFIFOCountSel,BSPIDescriptorSel)
        begin
            if Aint(15 downto 8) = BSPIDataAddr then	 --  BSPI data register select
                BSPIDataSel <= '1';
            else
                BSPIDataSel <= '0';
            end if;
            if Aint(15 downto 8) = BSPIFIFOCountAddr then	 --  BSPI FIFO count register select
                BSPIFIFOCountSel <= '1';
            else
                BSPIFIFOCountSel <= '0';
            end if;
            if Aint(15 downto 8) = BSPIDescriptorAddr then	 --  BSPI channel descriptor register select
                BSPIDescriptorSel <= '1';
            else
                BSPIDescriptorSel <= '0';
            end if;
            LoadBSPIData <= OneOfNDecode(BSPIs,BSPIDataSel,writestb,Aint(7 downto 6)); -- 4 max
            ReadBSPIData <= OneOfNDecode(BSPIs,BSPIDataSel,readstb,Aint(7 downto 6));
            LoadBSPIDescriptor<= OneOfNDecode(BSPIs,BSPIDescriptorSel,writestb,Aint(5 downto 2));
            ReadBSPIFIFOCOunt <= OneOfNDecode(BSPIs,BSPIFIFOCountSel,readstb,Aint(5 downto 2));
            ClearBSPIFIFO <= OneOfNDecode(BSPIs,BSPIFIFOCountSel,writestb,Aint(5 downto 2));
        end process BSPIDecodeProcess;

        DoBSPIPins: process(BSPIFrame, BSPIOut, BSPIClk, BSPICS, IOBitsCorein)
        begin
            for i in 0 to IOWidth -1 loop				-- loop through all the external I/O pins
                if ThePinDesc(i)(15 downto 8) = BSPITag then
                    case (ThePinDesc(i)(7 downto 0)) is	--secondary pin function, drop MSB
                        when BSPIFramePin =>
                            CoreDataOut(i) <= BSPIFrame(conv_integer(ThePinDesc(i)(23 downto 16)));
                        when BSPIOutPin =>
                            CoreDataOut(i) <= BSPIOut(conv_integer(ThePinDesc(i)(23 downto 16)));
                        when BSPIClkPin =>
                            CoreDataOut(i) <= BSPIClk(conv_integer(ThePinDesc(i)(23 downto 16)));
                        when BSPIInPin =>
                            BSPIIn(conv_integer(ThePinDesc(i)(23 downto 16))) <= IOBitsCorein(i);
                        when others =>
                        CoreDataOut(i) <= BSPICS(conv_integer(ThePinDesc(i)(23 downto 16)))(conv_integer(ThePinDesc(i)(6 downto 0))-5);
                        -- magic foo, magic foo, what on earth does it do?
                        -- (this needs to written more clearly!)
                    end case;
                end if;
            end loop;
        end process;
    end generate makebspimod;

end dataflow;
