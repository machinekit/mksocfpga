library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;
--
-- Copyright (C) 2016, Devin Hughes, JD Squared
-- http://www.jd2.com
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

entity irqlogics_periodic is
    generic (
			buswidth : integer
			);
	 port (
			clk : in  std_logic;
         ibus : in  std_logic_vector (buswidth-1 downto 0);
         obus : out  std_logic_vector (buswidth-1 downto 0);
         loadstatus : in  std_logic;
         readstatus : in  std_logic;
         loadcontrol : in  std_logic;
         readcontrol : in  std_logic;
         clear : in  std_logic;
         int : out  std_logic);
end irqlogics_periodic;

architecture Behavioral of irqlogics_periodic is

-- The new register layout:
-- Status register: IRQ base address
-- timer enable bit 2, mask bit 1, irq bit 0
-- Control register: IRQ base address + 4
-- Period bits 31..8, Prescale bits 7..0
signal statusreg : std_logic_vector(2 downto 0);
alias timeren: std_logic is statusreg(2);
alias mask : std_logic is statusreg(1);
alias irqff : std_logic is statusreg(0);
signal controlreg : std_logic_vector(31 downto 0);
alias prescale : std_logic_vector(7 downto 0) is controlreg(7 downto 0);
alias period : std_logic_vector(23 downto 0) is controlreg(31 downto 8);
signal counterregs : unsigned(31 downto 0);
alias timer_cnt: unsigned(23 downto 0) is counterregs(31 downto 8);
alias prescale_cnt : unsigned(7 downto 0) is counterregs (7 downto 0);
signal newint : std_logic;

begin
  int <= not (irqff and mask);							-- fixed active low interrupt
  newint <= '1' when (prescale_cnt = x"01" and timer_cnt = x"000001") else '0';

  timerupdate : process (clk, clear, timeren, prescale_cnt, timer_cnt)
  begin
    if rising_edge(clk) then
      if timeren = '1' then
        if prescale_cnt <= x"01" then
          prescale_cnt <= unsigned(prescale);
          if timer_cnt <= x"000001" then
            timer_cnt <= unsigned(period);
          else
            timer_cnt <= timer_cnt - 1;
          end if;
        else
          prescale_cnt <= prescale_cnt - 1;
        end if; -- prescale
      end if; -- timer_cnt
    end if; -- (clk)
  end process;

  regupdate : process (clk,statusreg,irqff,readstatus,loadstatus,readcontrol,loadcontrol,newint)
  begin
      if rising_edge(clk) then
	if loadstatus = '1' then
          statusreg <= ibus(2 downto 0);
        elsif loadcontrol = '1' then
          controlreg <= ibus(31 downto 0);
        end if;
        if newint = '1' then
          irqff <= '1';
        end if;
        if clear = '1' then
          irqff <= '0';
        end if;
      end if; -- (clk)
      obus <= (others => 'Z');
      if readstatus = '1' then
	obus(2 downto 0) <= statusreg;
	obus(31 downto 3) <= (others => '0');
      elsif readcontrol = '1' then
        obus(31 downto 0) <= controlreg;
      end if;
  end process;

end Behavioral;
