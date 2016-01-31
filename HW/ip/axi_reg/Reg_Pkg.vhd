-- Copyright (C) 2015, Charles Steinkuehler
-- <charles AT steinkuehler DOT net>
-- All rights reserved
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
--         * Neither the name of the copyright holder nor the names of its
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

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

package Reg_Pkg is

    -- Handy data types
    subtype NIBBLE_T        is std_logic_vector(  3 downto 0);
    subtype BYTE_T          is std_logic_vector(  7 downto 0);
    subtype WORD_T          is std_logic_vector( 15 downto 0);
    subtype DWORD_T         is std_logic_vector( 31 downto 0);
    subtype QWORD_T         is std_logic_vector( 63 downto 0);
    subtype DQWORD_T        is std_logic_vector(127 downto 0);

    type    NIBBLE_A        is array (natural range <>) of NIBBLE_T;
    type    BYTE_A          is array (natural range <>) of BYTE_T;
    type    WORD_A          is array (natural range <>) of WORD_T;
    type    DWORD_A         is array (natural range <>) of DWORD_T;
    type    QWORD_A         is array (natural range <>) of QWORD_T;
    type    DQWORD_A        is array (natural range <>) of DQWORD_T;

    -------------------------
    -- Register Interfaces --
    -------------------------

    -- Generic single register write interface
    type RegWr_T is record
        data    : QWORD_T;
        be      : std_logic_vector(7 downto 0);
        we      : std_logic;
    end record RegWr_T;
    type RegWr_A is array (natural range <>) of RegWr_T;

    -- Generic register write interface (entire register space)
    -- 256 individual 64-bit registers
    type RegWrA_T is record
        data    : QWORD_T;
        be      : std_logic_vector(7 downto 0);
        we      : std_logic_vector(255 downto 0);
        addr    : std_logic_vector(7 downto 0);
        wren    : std_logic;
        sel     : std_logic;
    end record RegWrA_T;

    -- FIFO style interface that doesn't need decodes or full address space
    -- ie: do a burst write to sequential addresses to write lots of data to
    --     a single destination like a transmit FIFO
    type FIFORegWrA_T is record
        data    : QWORD_T;
        be      : std_logic_vector(7 downto 0);
        addr    : std_logic_vector(1 downto 0);
        wren    : std_logic;
        sel     : std_logic;
    end record FIFORegWrA_T;

    -- Array of register readback values
    type RegRd_A is array (natural range <>) of QWORD_T;

    -- Calculate the number of bits required to represent a given value
    function NumBits    (val : integer) return integer;

end package Reg_Pkg;

package body Reg_Pkg is

    -- Calculate the number of bits required to represent a given value
    function NumBits(val : integer) return integer is
        variable result : integer;
    begin
        if val=0 then
            result := 0;
        else
            result  := natural(ceil(log2(real(val))));
        end if;
        return result;
    end;

end package body Reg_Pkg;
