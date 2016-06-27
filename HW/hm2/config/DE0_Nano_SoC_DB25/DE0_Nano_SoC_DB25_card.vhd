library IEEE;
use IEEE.std_logic_1164.all;  -- defines std_logic types
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Copyright (C) 2016, Charles Steinkuehler (charles@steinkuehler.net)
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
package DE0_Nano_SoC_DB25_card is
    -- DE0-Nano card specific info
    constant ClockHigh      : integer := 200000000;                             -- 200 MHz
    constant ClockMed       : integer := 100000000;                             -- 100 MHz
    constant ClockLow       : integer :=  50000000;                             --  50 MHz
    constant BoardNameLow   : std_Logic_Vector(31 downto 0) := x"41524554";     -- "TERA"
    constant BoardNameHigh  : std_Logic_Vector(31 downto 0) := x"4E304544";     -- "DE0N"
    constant FPGASize       : integer := 9;                                     -- Reported as 32-bit value in IDROM.vhd (9 matches Mesanet value for 5i25)
                                                                                --   FIXME: Figure out Mesanet encoding and put something sensible here
    constant FPGAPins       : integer := 144;                                   -- Reported as 32-bit value in IDROM.vhd
                                                                                --   Maximum of 144 pindesc entries currently hard-coded in IDROM.vhd
    constant IOPorts        : integer := 4;                                     -- Number of external ports (DE0-Nano_DB25 can have 2 on each 40-pin expansion header)
    constant IOWidth        : integer := 68;                                    -- Number of total I/O pins = IOPorts * PortWidth
    constant PortWidth      : integer := 17;                                    -- Number of I/O pins per port: 17 per DB25
    constant LIOWidth       : integer := 0;                                     -- Number of local I/Os (used for on-board serial-port on Mesanet cards)
    constant LEDCount       : integer := 4;                                     -- Number of LEDs
    constant SepClocks      : boolean := true;                                  -- Deprecated
    constant OneWS          : boolean := true;                                  -- Deprecated
    constant buswidth       : integer := 32;
    constant addrwidth      : integer := 16;
end package DE0_Nano_SoC_DB25_card;
