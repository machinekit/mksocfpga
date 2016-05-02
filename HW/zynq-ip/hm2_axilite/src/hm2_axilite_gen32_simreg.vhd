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

-- This is a simulated register bank that mimics the generic 32 bit register
-- interface used by the hostmot2 components. Use it in conjuction with the
-- testbench file to validate axi read and write transactions are correctly
-- converted to generic 32 bit bus transactions.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity hm2_axilite_gen32_simreg is
	generic (
		C_S_AXI_DATA_WIDTH	: integer	:= 32;		-- Width of S_AXI data bus
		C_S_AXI_ADDR_WIDTH	: integer	:= 14 		-- Width of S_AXI address bus
	);
	port (
		-- Generic 32-bit bus signals --
    RESETN : in std_logic;
    CLK : in std_logic;
		ADDR : in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		IBUS : in std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		OBUS : out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		READSTB : in std_logic;
		WRITESTB : in std_logic
	);
end hm2_axilite_gen32_simreg;

architecture arch_imp of hm2_axilite_gen32_simreg is
  -- Yes, could be an array but it's just a test component...
  signal slv_reg0 : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
  signal slv_reg1 : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
  signal slv_reg2 : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
  signal slv_reg3 : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
  signal slv_reg4 : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
  signal slv_reg5 : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
  signal slv_reg6 : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
  signal slv_reg7 : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);

  signal A : std_logic_vector(C_S_AXI_ADDR_WIDTH - 1 downto 0);
begin

  process(CLK, addr)
  begin
    if (rising_edge(CLK)) then
        A <= addr;
    end if;
  end process;

  write_mux : process (CLK)
  variable loc_addr : std_logic_vector(2 downto 0);
  begin
    if (rising_edge(CLK)) then
      if (RESETN = '0') then
        slv_reg0 <= (others => '0');
        slv_reg1 <= (others => '0');
        slv_reg2 <= (others => '0');
        slv_reg3 <= (others => '0');
        slv_reg4 <= (others => '0');
        slv_reg5 <= (others => '0');
        slv_reg6 <= (others => '0');
        slv_reg7 <= (others => '0');
      else
        loc_addr := A(4 downto 2);
        if (WRITESTB = '1') then
          case (loc_addr) is
            when b"000" => slv_reg0 <= IBUS;
            when b"001" => slv_reg1 <= IBUS;
            when b"010" => slv_reg2 <= IBUS;
            when b"011" => slv_reg3 <= IBUS;
            when b"100" => slv_reg4 <= IBUS;
            when b"101" => slv_reg5 <= IBUS;
            when b"110" => slv_reg6 <= IBUS;
            when b"111" => slv_reg7 <= IBUS;
            when others =>
              slv_reg0 <= slv_reg0;
              slv_reg1 <= slv_reg1;
              slv_reg2 <= slv_reg2;
              slv_reg3 <= slv_reg3;
              slv_reg4 <= slv_reg4;
              slv_reg5 <= slv_reg5;
              slv_reg6 <= slv_reg6;
              slv_reg7 <= slv_reg7;
          end case;
        end if;
      end if;
    end if;
  end process;

  read_mux : process (ADDR, READSTB, slv_reg0, slv_reg1, slv_reg2, slv_reg3, slv_reg4, slv_reg5, slv_reg6, slv_reg7)
  variable loc_addr : std_logic_vector(2 downto 0);
  begin
    loc_addr := A(4 downto 2);
    if (READSTB = '1') then
      case (loc_addr) is
        when b"000" => OBUS <= slv_reg0;
        when b"001" => OBUS <= slv_reg1;
        when b"010" => OBUS <= slv_reg2;
        when b"011" => OBUS <= slv_reg3;
        when b"100" => OBUS <= slv_reg4;
        when b"101" => OBUS <= slv_reg5;
        when b"110" => OBUS <= slv_reg6;
        when b"111" => OBUS <= slv_reg7;
        when others => OBUS <= (others => '0');
      end case;
    else
      OBUS <= (others => '0');
    end if;
  end process;
end arch_imp;
