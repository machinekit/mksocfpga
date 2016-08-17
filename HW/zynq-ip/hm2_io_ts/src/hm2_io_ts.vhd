-- Copyright (C) 2016, Devin Hughes, JD Squared
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
--     COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANitsY DIRECT, INDIRECT,
--     INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
--     BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
--     LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
--     CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
--     LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
--     ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
--     POSSIBILITY OF SUCH DAMAGE.
--
-- Tristate buffer implementation for hm2 io 

library ieee;
use ieee.std_logic_1164.all;

entity hm2_io_ts is
	generic (
		WIDTH	: integer	:= 36
	);
	port (
	    ddr_bits : in std_logic_vector(WIDTH - 1 downto 0); -- The data direction of the pins
	    odr_bits : in std_logic_vector(WIDTH - 1 downto 0); -- The ODR mode of the pins
	    o_bits : in std_logic_vector(WIDTH - 1 downto 0); -- Outputs from HM2
	    i_bits : out std_logic_vector(WIDTH - 1 downto 0); -- Drives HM2 input pins
        iobits : inout std_logic_vector(WIDTH - 1 downto 0) -- To io port pins
	);
end hm2_io_ts;

architecture arch_imp of hm2_io_ts is
begin    
    process(ddr_bits, odr_bits, o_bits, iobits)
    begin
        for i in 0 to WIDTH - 1 loop
            if(ddr_bits(i) = '1') then
                i_bits(i) <= o_bits(i);
                if(odr_bits(i) = '1') then
                    if(o_bits(i) = '1') then
                        iobits(i) <= 'Z';
                    else
                        iobits(i) <= '0';
                    end if;    
                else
                    iobits(i) <= o_bits(i);
                end if;
            else
                i_bits(i) <= iobits(i);
                iobits(i) <= 'Z';
            end if;
        end loop;
    end process;
end arch_imp;
