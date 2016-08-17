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

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity jdcb_ins is
	generic (
		WIDTH	: integer	:= 36;
		NUM_DEB_STAGES : integer := 10 -- Number of stages of debounce before output is latched
	);
	port (
	    clk : in std_logic; -- Expect 100MHz clock here
	    INS : in std_logic_vector(WIDTH - 1 downto 0); -- Raw Inputs
        LOG_INS : out std_logic_vector(WIDTH - 1 downto 0) -- Logic applied inputs
	);
end jdcb_ins;

architecture arch_imp of jdcb_ins is
    signal sw_probe_deb : std_logic;
    signal aux1_in_deb : std_logic;
    signal lim_deb : std_logic_vector(3 downto 0);
    signal deb_clk : std_logic := '0';
    signal half_period : unsigned(15 downto 0) := x"30D4"; -- 4 kHz debounce clock
    signal timer_cnt: unsigned(15 downto 0) := (others => '0');
    signal faults_valid : std_logic;    -- When motors are turned off, ignore amp faults
    signal mtr_pwr_del : std_logic;
begin    

    LOG_INS(0) <= faults_valid AND (NOT(INS(0))); -- motor 1 fault is delayed and inverted
    LOG_INS(3 downto 1) <= INS(3 downto 1);
    LOG_INS(4) <= faults_valid AND (NOT(INS(4))); -- motor 2 fault is delayed and inverted
    LOG_INS(7 downto 5) <= INS(7 downto 5);
    LOG_INS(8) <= faults_valid AND (NOT(INS(8))); -- motor 3 fault is delayed and inverted
    LOG_INS(11 downto 9) <= INS(11 downto 9);
    LOG_INS(12) <= faults_valid AND (NOT(INS(12))); -- motor 4 fault is delayed and inverted
    LOG_INS(15 downto 13) <= INS(15 downto 13);
    LOG_INS(16) <= faults_valid AND (NOT(INS(4)) OR NOT(INS(8))); -- M2 & M3 motors combined fault signal, fault when high
    LOG_INS(20 downto 17) <= NOT(lim_deb(3 downto 0));
    LOG_INS(23 downto 21) <= INS(23 downto 21); -- Generic outputs not touched
    LOG_INS(24) <= NOT(INS(24));  -- Z-probe input is not debounced, but inverted
    LOG_INS(25) <= NOT(aux1_in_deb);  -- AUXIN1 gets debounced, and inverted
    LOG_INS(26) <= NOT(sw_probe_deb); -- debounce switch z probe
    LOG_INS(27) <= NOT(INS(27));  -- E-Stop input is not debounced, but inverted
    LOG_INS(28) <= NOT(INS(28));  -- Torch Break input is not debounced, but inverted
    LOG_INS(29) <= NOT(INS(27)) OR (NOT(INS(28)) AND NOT(INS(30)));  -- Logical E-Stop
    LOG_INS(30) <= INS(30) AND INS(16) AND INS(29) AND INS(31);
    LOG_INS(31) <= NOT(INS(24)) OR NOT(sw_probe_deb); -- combined z-probe signal
    LOG_INS(32) <= faults_valid AND (NOT(INS(32))); -- motor 5 fault is delayed and inverted
    LOG_INS(35 downto 33) <= INS(35 downto 33);  

    faults_valid <= (mtr_pwr_del AND INS(22)); -- don't delay when turning off power

    gen_lim : for i in 0 to 3 generate
        limx: entity work.inp_deb
        generic map (NUM_STAGES => NUM_DEB_STAGES)
        port map (
            clk => deb_clk,
            input => INS(i+17),
            output => lim_deb(i)
        );
    end generate gen_lim;

    sw_pr: entity work.inp_deb
        generic map (NUM_STAGES => NUM_DEB_STAGES)
        port map (
            clk => deb_clk,
            input => INS(26),
            output => sw_probe_deb
        );

    ax2_deb: entity work.inp_deb
        generic map (NUM_STAGES => NUM_DEB_STAGES)
        port map (
            clk => deb_clk,
            input => INS(25),
            output => aux1_in_deb
        );

    motor_pwr_del : entity work.sig_Delay
        generic map(
		    CLOCK_RATE => 100000000,
		    DELAY_TIME_INV => 5,    -- 200 ms delay
            NUM_TIMER_BITS => 32
        )
        port map (
            clk => deb_clk,
            input => INS(22),
            output => mtr_pwr_del
        );

    clkdiv : process (clk, timer_cnt)
    begin
        if rising_edge(clk) then
            if timer_cnt <= x"0001" then
                timer_cnt <= half_period;
                deb_clk <= NOT(deb_clk);
            else
                timer_cnt <= timer_cnt - 1;
            end if;
        end if; -- (clk)
    end process;

end arch_imp;
