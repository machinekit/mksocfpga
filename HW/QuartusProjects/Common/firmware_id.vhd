-- Copyright (C) 2016, Charles Steinkuehler
-- charles at steinkuehler.net
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
--   * Redistributions of source code must retain the above copyright
--     notice, this list of conditions and the following disclaimer.
--
--   * Redistributions in binary form must reproduce the above
--     copyright notice, this list of conditions and the following
--     disclaimer in the documentation and/or other materials
--     provided with the distribution.
--
--   * Neither the name of Mesa Electronics nor the names of its
--     contributors may be used to endorse or promote products
--     derived from this software without specific prior written
--     permission.
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

library altera_mf;
use altera_mf.altera_mf_components.all;

entity firmware_id is
    port (
        clk     : in  std_logic;
        re      : in  std_logic;
        radd    : in  std_logic_vector( 8 downto 0);
        dout    : out std_logic_vector(31 downto 0)
        );
end firmware_id;

architecture arch of firmware_id is
    signal rom_data : std_logic_vector(31 downto 0);
begin

    -- Use the Altera ram function configured to match the hm2 IDROM behavior:
    --   Read address is delayed one clock (registered on input in the altsyncram)
    --   Read data is asynchronously read out after the one clock address delay
    fwid_rom : altsyncram
    generic map (
        address_aclr_a          => "NONE",
        clock_enable_input_a    => "BYPASS",
        clock_enable_output_a   => "BYPASS",
        init_file               => "firmware_id.mif",
        intended_device_family  => "Cyclone V",
        lpm_hint                => "ENABLE_RUNTIME_MOD=NO",
        lpm_type                => "altsyncram",
        numwords_a              => 512,
        operation_mode          => "ROM",
        outdata_aclr_a          => "NONE",
        outdata_reg_a           => "UNREGISTERED",
        widthad_a               => 9,
        width_a                 => 32,
        width_byteena_a         => 1 )
    port map (
        address_a               => radd,
        clock0                  => clk,
        q_a                     => rom_data );

    dout <= rom_data when re='1' else (others=>'Z');

end arch;