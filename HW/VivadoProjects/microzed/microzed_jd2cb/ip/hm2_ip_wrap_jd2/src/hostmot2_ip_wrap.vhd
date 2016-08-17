-- Copyright (C) 2016, Devin Hughes, JD Squared
-- http=>
--
-- This program is is licensed under a disjunctive dual license giving you
-- the choice of one of the two following sets of free software/open source
-- licensing terms=>
--
--    * GNU General Public License (GPL), version 2.0 or later
--    * 3-clause BSD License
--
--
-- The GNU GPL License=>
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
-- The 3-clause BSD License=>
--
--     Redistribution and use in source and binary forms, with or without
--     modification, are permitted provided that the following conditions
--     are met=>
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
-- Disclaimer=>
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

-- Xilinx IP packager does not like custom types in the configurable
-- parameters, i.e., the generic statement. This wrapper simply passes
-- the static configuration that is not GUI customizable to the HostMot2
-- module without exposing it at the top level.

library ieee;
use IEEE.std_logic_1164.all;
-- Select pin package here
use work.PIN_JD2CB_34.all;
-- Need the IDROMConst for the board names
use work.IDROMConst.all;

entity HostMot2_ip_wrap is
  generic
  (
  IDROMType: integer := 3;
   SepClocks: boolean := true;
  OneWS: boolean := true;
  UseStepGenPrescaler : boolean := true;
  UseIRQLogic: boolean := true;
  PWMRefWidth: integer := 13;
  UseWatchDog: boolean := true;
  OffsetToModules: integer := 64;
  OffsetToPinDesc: integer := 448;
  ClockHigh: integer := ClockHigh25;
  ClockMed: integer := ClockMed25;
  ClockLow: integer := ClockMed20;
  FPGASize: integer := 9;
  FPGAPins: integer := 144;
  IOPorts: integer := 2;
  IOWidth: integer := 32;
  LIOWidth: integer := 6;
  PortWidth: integer := 17;
  BusWidth: integer := 32;
  AddrWidth: integer := 16;
  InstStride0: integer := 4;
  InstStride1: integer := 64;
  RegStride0: integer := 256;
  RegStride1: integer := 256;
  LEDCount: integer := 2
  );
  port
  (
   -- Generic 32  bit bus interface signals --

  ibus: in std_logic_vector(buswidth -1 downto 0);
  obus: out std_logic_vector(buswidth -1 downto 0);
  addr: in std_logic_vector(addrwidth -1 downto 2);
  readstb: in std_logic;
  writestb: in std_logic;
  clklow: in std_logic;
  clkmed: in std_logic;
  clkhigh: in std_logic;
  interrupt: out std_logic;
  dreq: out std_logic;
  demandmode: out std_logic;
  iobits: inout std_logic_vector (iowidth -1 downto 0);
  liobits: inout std_logic_vector (liowidth -1 downto 0);
  rates: out std_logic_vector (4 downto 0);
  leds: out std_logic_vector(ledcount-1 downto 0)
  );
end HostMot2_ip_wrap;

architecture arch of HostMot2_ip_wrap is
begin
  the_hm2 : entity work.HostMot2
    generic map (
      ThePinDesc => PinDesc,
      TheModuleID=> ModuleID,
      IDROMType => IDROMType,
      SepClocks => SepClocks,
      OneWS => OneWS,
      UseStepGenPrescaler => UseStepGenPrescaler,
      UseIRQLogic => UseIRQLogic,
      PWMRefWidth => PWMRefWidth,
      UseWatchDog => UseWatchDog,
      OffsetToModules => OffsetToModules,
      OffsetToPinDesc => OffsetToPinDesc,
      ClockHigh => ClockHigh,
      ClockMed => ClockMed,
      ClockLow => ClockLow,
      BoardNameLow => BoardNameMesa,
      BoardNameHigh => x"4243444A",
      FPGASize => FPGASize,
      FPGAPins => FPGAPins,
      IOPorts => IOPorts,
      IOWidth => IOWidth,
      LIOWidth => LIOWidth,
      PortWidth => PortWidth,
      BusWidth => BusWidth,
      AddrWidth => AddrWidth,
      InstStride0 => InstStride0,
      InstStride1 => InstStride1,
      RegStride0 => RegStride0,
      RegStride1 => RegStride1,
      LEDCount => LEDCount
    )
    port map (
      ibus => ibus,
      obus => obus,
      addr => addr,
      readstb => readstb,
      writestb => writestb,
      clklow => clklow,
      clkmed => clkmed,
      clkhigh => clkhigh,
      int => interrupt,
      dreq => dreq,
      demandmode => demandmode,
      iobits => iobits,
      liobits => liobits,
      rates => rates,
      leds => leds
    );
end arch;
