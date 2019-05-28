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

entity MakeDBSPIs is
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
        DBSPICSWidth: integer);
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

end MakeDBSPIs;


architecture dataflow of MakeDBSPIs is

-- Signals

-- I/O port related signals

    begin
    makedbspimod:  if DBSPIs >0  generate
    signal LoadDBSPIData: std_logic_vector(DBSPIs -1 downto 0);
    signal ReadDBSPIData: std_logic_vector(DBSPIs -1 downto 0);
    signal LoadDBSPIDescriptor: std_logic_vector(DBSPIs -1 downto 0);
    signal ReadDBSPIFIFOCount: std_logic_vector(DBSPIs -1 downto 0);
    signal ClearDBSPIFIFO: std_logic_vector(DBSPIs -1 downto 0);
    signal DBSPIClk: std_logic_vector(DBSPIs -1 downto 0);
    signal DBSPIIn: std_logic_vector(DBSPIs -1 downto 0);
    signal DBSPIOut: std_logic_vector(DBSPIs -1 downto 0);
    type DBSPICSType is array(DBSPIs-1 downto 0) of std_logic_vector(DBSPICSWidth-1 downto 0);
    signal DBSPICS : DBSPICSType;
    signal DBSPIDataSel : std_logic;
    signal DBSPIFIFOCountSel : std_logic;
    signal DBSPIDescriptorSel : std_logic;
    begin
        makedbspis: for i in 0 to DBSPIs -1 generate
            bspi: entity work.BufferedSPI
            generic map (
                cswidth => DBSPICSWidth,
                gatedcs => true
                )
            port map (
                clk  => clklow,
                ibus => ibus,
                obus => obusint,
                addr => Aint(5 downto 2),
                hostpush => LoadDBSPIData(i),
                hostpop => ReadDBSPIData(i),
                loaddesc => LoadDBSPIDescriptor(i),
                loadasend => '0',
                clear => ClearDBSPIFIFO(i),
                readcount => ReadDBSPIFIFOCount(i),
                spiclk => DBSPIClk(i),
                spiin => DBSPIIn(i),
                spiout => DBSPIOut(i),
                spicsout => DBSPICS(i)
                );
        end generate;

        DBSPIDecodeProcess : process (Aint,Readstb,writestb,DBSPIDataSel,DBSPIFIFOCountSel,DBSPIDescriptorSel)
        begin
            if Aint(15 downto 8) = DBSPIDataAddr then	 --  DBSPI data register select
                DBSPIDataSel <= '1';
            else
                DBSPIDataSel <= '0';
            end if;
            if Aint(15 downto 8) = DBSPIFIFOCountAddr then	 --  DBSPI FIFO count register select
                DBSPIFIFOCountSel <= '1';
            else
                DBSPIFIFOCountSel <= '0';
            end if;
            if Aint(15 downto 8) = DBSPIDescriptorAddr then	 --  DBSPI channel descriptor register select
                DBSPIDescriptorSel <= '1';
            else
                DBSPIDescriptorSel <= '0';
            end if;
            LoadDBSPIData <= OneOfNDecode(DBSPIs,DBSPIDataSel,writestb,Aint(7 downto 6)); -- 4 max
            ReadDBSPIData <= OneOfNDecode(DBSPIs,DBSPIDataSel,Readstb,Aint(7 downto 6));
            LoadDBSPIDescriptor<= OneOfNDecode(DBSPIs,DBSPIDescriptorSel,writestb,Aint(5 downto 2));
            ReadDBSPIFIFOCount <= OneOfNDecode(DBSPIs,DBSPIFIFOCountSel,Readstb,Aint(5 downto 2));
            ClearDBSPIFIFO <= OneOfNDecode(DBSPIs,DBSPIFIFOCountSel,writestb,Aint(5 downto 2));
        end process DBSPIDecodeProcess;

        DoDBSPIPins: process(DBSPIOut, DBSPIClk, DBSPICS, IOBitsCorein)
        begin
            for i in 0 to IOWidth -1 loop				-- loop through all the external I/O pins
                if ThePinDesc(i)(15 downto 8) = DBSPITag then
                    case (ThePinDesc(i)(7 downto 0)) is	--secondary pin function, drop MSB
                        when DBSPIOutPin =>
                            CoreDataOut(i) <= DBSPIOut(conv_integer(ThePinDesc(i)(23 downto 16)));
                        when DBSPIClkPin =>
                            CoreDataOut(i) <= DBSPIClk(conv_integer(ThePinDesc(i)(23 downto 16)));
                        when DBSPIInPin =>
                            DBSPIIn(conv_integer(ThePinDesc(i)(23 downto 16))) <= IOBitsCorein(i);
                        when others =>
                            CoreDataOut(i) <= DBSPICS(conv_integer(ThePinDesc(i)(23 downto 16)))(conv_integer(ThePinDesc(i)(6 downto 0))-5);
                        -- magic foo, magic foo, what on earth does it do?
                            -- (this needs to written more clearly!)
                    end case;
                end if;
            end loop;
        end process;

    end generate makedbspimod;

end dataflow;
