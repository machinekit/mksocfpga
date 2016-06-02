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
--     COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
--     INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
--     BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
--     LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
--     CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
--     LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
--     ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
--     POSSIBILITY OF SUCH DAMAGE.
--
-- This is a module specifically created to remove some debounce and OR/AND
-- logic from a HAL configuration file. 

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity jdcb_io is
	generic (
		NUM_IO_BITS	: integer	:= 32;
		NUM_DEB_STAGES : integer := 10 -- Number of stages of debounce before output is latched
	);
	port (
	    clk : in std_logic; -- Expect 100MHz clock here
	    IO_IN : in std_logic_vector(NUM_IO_BITS - 1 downto 0); -- from pins 
        IO_OUT : out std_logic_vector(NUM_IO_BITS - 1 downto 0) -- to io port
	);
end jdcb_io;

architecture arch_imp of jdcb_io is
    signal sw_probe_deb : std_logic;
    signal aux2_in_deb : std_logic;
    signal lim_deb : std_logic_vector(3 downto 0);
    signal deb_clk : std_logic := '0';
    signal half_period : unsigned(23 downto 0) := x"0030D4";
    signal timer_cnt: unsigned(23 downto 0) := x"000000";
    
    component inp_deb
    	generic (
            NUM_STAGES : integer
        );
        port (
            clk				             : in std_logic;
	        input						 : in std_logic;
	        output      				 : out std_logic 
        );
    end component;	
begin
    IO_OUT(15 downto 0) <= IO_IN(15 downto 0); -- motor pins no extra logic
    IO_OUT(16) <= (IO_IN(4) OR IO_IN(8)); -- M2 & M3 motors combined fault signal
    IO_OUT(20 downto 17) <= NOT(lim_deb(3 downto 0)); -- Limits get debounced, and inverted
    IO_OUT(23 downto 21) <= IO_IN(23 downto 21);
    IO_OUT(24) <= NOT(IO_IN(24));  -- Z-probe input is not debounced, but inverted
    IO_OUT(25) <= NOT(aux2_in_deb);  -- AUXIN2 gets debounced, and inverted
    IO_OUT(26) <= NOT(sw_probe_deb); -- debounce switch z probe
    IO_OUT(27) <= NOT(IO_IN(27));  -- E-Stop input is not debounced, but inverted
    IO_OUT(28) <= NOT(IO_IN(28));  -- Torch Break input is not debounced, but inverted
    IO_OUT(29) <= (NOT(IO_IN(27)) OR (NOT(IO_IN(28)) AND NOT(IO_IN(30))));  -- Logical E-Stop
    IO_OUT(30) <= (NOT(IO_IN(24)) OR NOT(sw_probe_deb)); -- combined z-probe signal
    IO_OUT(31) <= IO_IN(31);

    gen_lim : for i in 0 to 3 generate
        limx: inp_deb 
        generic map (NUM_STAGES => NUM_DEB_STAGES)
        port map (
            clk => deb_clk,
            input => IO_IN(i+17),
            output => lim_deb(i)
        );
    end generate gen_lim;

    sw_pr: inp_deb 
        generic map (NUM_STAGES => NUM_DEB_STAGES)
        port map (
            clk => deb_clk,
            input => IO_IN(26),
            output => sw_probe_deb
        );
        
    ax2_deb: inp_deb 
        generic map (NUM_STAGES => NUM_DEB_STAGES)
        port map (
            clk => deb_clk,
            input => IO_IN(25),
            output => aux2_in_deb
        );
        
    clkdiv : process (clk, timer_cnt)
    begin
        if rising_edge(clk) then
            if timer_cnt <= x"000001" then
                timer_cnt <= half_period;
                deb_clk <= NOT(deb_clk);
            else
                timer_cnt <= timer_cnt - 1;
            end if;
        end if; -- (clk)
    end process;
      
end arch_imp;

