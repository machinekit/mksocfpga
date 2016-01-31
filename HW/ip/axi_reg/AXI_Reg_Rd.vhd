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

use work.Reg_Pkg.all;

library lpm;
use lpm.lpm_components.all;

library altera_mf;
use altera_mf.altera_mf_components.all;

entity AXI_Reg_Rd_E is
    generic (
        latency         : integer := 3 );
    port (
        clk             : in  std_logic;
        rst             : in  std_logic;

        -- Read Address Channel
        axi_arid        : in  std_logic_vector(13 downto 0);
        axi_araddr      : in  std_logic_vector(13 downto 0);
        axi_arlen       : in  std_logic_vector(7 downto 0);
        axi_arsize      : in  std_logic_vector(2 downto 0);
        axi_arburst     : in  std_logic_vector(1 downto 0);
        axi_arvalid     : in  std_logic;
        axi_arready     : out std_logic;

        -- Read Data Channel
        axi_rid         : out std_logic_vector(13 downto 0);
        axi_rdata       : out std_logic_vector(31 downto 0);
        axi_rlast       : out std_logic;
        axi_rvalid      : out std_logic;
        axi_rready      : in  std_logic;

        -- Register read data
        Bank1RegRd      : in  RegRd_A(255 downto 0);
        Bank2RegRd      : in  RegRd_A(255 downto 0) );

end AXI_Reg_Rd_E;

architecture arch of AXI_Reg_Rd_E is

    constant C_PRE_READ_CYCLES : integer := 3;

    signal start        : std_logic;
    signal a_busy       : std_logic;
    signal p_busy       : std_logic;
    signal p_done       : std_logic;
    signal p_cnt        : unsigned(numbits(latency+1)-1 downto 0);
    signal d_busy       : std_logic;
    signal d_done       : std_logic;

    signal tx_id        : std_logic_vector(13 downto 0);
    signal tx_addr      : unsigned(13 downto 0);
    signal tx_addr_nxt  : unsigned(13 downto 0);
    signal addr_inc     : unsigned(13 downto 0);
    signal addr_wrap    : unsigned(13 downto 0);
    signal addr_mask    : unsigned(13 downto 0);
    signal addr_align   : unsigned(13 downto 0);
    signal tx_len       : unsigned(7 downto 0);
    signal tx_size      : std_logic_vector(2 downto 0);
    signal tx_burst     : std_logic_vector(1 downto 0);
    signal tx_data      : std_logic_vector(31 downto 0);

    signal num_bytes    : unsigned(3 downto 0);

    signal lpm_mx_addr  : std_logic_vector(9 downto 0);
    signal lpm_mx_data  : std_logic_2D(1023 downto 0, 31 downto 0);
    signal lpm_mx_rden  : std_logic;

begin
    axi_arready <= '1' when a_busy='0' else '0';

    axi_rid     <= tx_id;
    axi_rdata   <= tx_data;
    axi_rlast   <= d_done;
    axi_rvalid  <= d_busy;

    with tx_burst select
    tx_addr_nxt <= tx_addr      when b"00",     -- Fixed-address burst
                   addr_inc     when b"01",     -- Normal sequential memory
                   addr_wrap    when b"10",     -- Cache line burst
                   tx_addr      when others;    -- Reserved

    with tx_size select
    num_bytes   <= x"1" when b"000",
                   x"2" when b"001",
                   x"4" when b"010",
                   x"4" when others;

    with tx_size select
    addr_mask   <= (                   others=>'1') when b"000",
                   (0 downto 0 => '0', others=>'1') when b"001",
                   (1 downto 0 => '0', others=>'1') when b"010",
                   (1 downto 0 => '0', others=>'1') when others;

    addr_align  <= tx_addr and addr_mask;
    addr_inc    <= addr_align + num_bytes;

    --FIXME: AXI burst wrapping is complex...ignore for now.
    addr_wrap   <= addr_inc;

                
    start   <= '1' when axi_arvalid='1' and a_busy='0' else '0';

    process(clk)
    begin
        if rising_edge(clk) then
            if rst='1' then
                a_busy      <= '0';
                p_busy      <= '0';
                p_done      <= '0';
                p_cnt       <= (others=>'0');
                d_busy      <= '0';
                d_done      <= '0';

                tx_id       <= (others=>'0');
                tx_addr     <= (others=>'0');
                tx_len      <= (others=>'0');
                tx_size     <= (others=>'0');
                tx_burst    <= (others=>'0');
            else
                -- Transaction state machine:
                -- idle -> pre-read -> data -> idle
                if start='1' then
                    a_busy  <= '1';
                    d_busy  <= '0';
                elsif p_done='1' then
                    d_busy  <= '1';
                elsif d_done='1' and axi_rready='1' then
                    a_busy  <= '0';
                    d_busy  <= '0';
                end if;

                if start='1' then
                    p_cnt   <= to_unsigned(C_PRE_READ_CYCLES, p_cnt'length);
                elsif p_cnt /= 0 then
                    p_cnt   <= p_cnt - 1;
                end if;

                if start='1' then
                    p_busy  <= '1';
                elsif p_done='1' or p_cnt = 0 then
                    p_busy  <= '0';
                end if;

                if start='1' and C_PRE_READ_CYCLES = 1 then
                    p_done  <= '1';
                elsif p_cnt=2 then
                    p_done  <= '1';
                else
                    p_done  <= '0';
                end if;

                if p_done='1' and tx_len=0 then
                    d_done  <= '1';
                elsif d_busy='1' and tx_len=1 and axi_rready='1' then
                    d_done  <= '1';
                -- Keep d_done set until the last word actually transfers
                elsif d_done='1' and axi_rready='0' then
                    d_done  <= '1';
                else
                    d_done  <= '0';
                end if;

                if start='1' then
                    tx_id       <= axi_arid;
                    tx_size     <= axi_arsize;
                    tx_burst    <= axi_arburst;
                end if;

                if start='1' then
                    tx_addr     <= unsigned(axi_araddr);
                    tx_len      <= unsigned(axi_arlen);
                elsif p_busy='1' then
                    tx_addr     <= tx_addr_nxt;
                elsif d_busy='1' and axi_rready='1' then
                    tx_addr     <= tx_addr_nxt;
                    if tx_len /= 0 then
                        tx_len      <= tx_len - 1;
                    end if;
                end if;

            end if;
        end if;
    end process;

    -- Map DMA and Register readback channels to 2D LPM input bus
    mx_data : for index in 255 downto 0 generate
    begin
        -- VHDL cannot access a slice of a 2D array, so assign each bit individually
        bitsL : for bit in 31 downto 0 generate
        begin
            lpm_mx_data((index * 2)      , bit) <= Bank1RegRd (index)(bit);
            lpm_mx_data((index * 2) + 512, bit) <= Bank2RegRd(index)(bit);
        end generate;
        bitsH : for bit in 31 downto 0 generate
        begin
            lpm_mx_data((index * 2) +   1, bit) <= Bank1RegRd (index)(bit + 32);
            lpm_mx_data((index * 2) + 513, bit) <= Bank2RegRd(index)(bit + 32);
        end generate;
    end generate;

    lpm_mx_addr <= std_logic_vector(resize(tx_addr(tx_addr'left downto 2),lpm_mx_addr'length));
    lpm_mx_rden <= '1' when p_busy='1' or (d_busy='1' and axi_rready='1') else '0';

    rd_mx : lpm_mux
    generic map (
        LPM_WIDTH       => 32,
        LPM_SIZE        => 1024,
        LPM_WIDTHS      => 10,
        LPM_PIPELINE    => latency )
    port map (
        clock   => clk,
        clken   => lpm_mx_rden,
        data    => lpm_mx_data,
        sel     => lpm_mx_addr,

        result  => tx_data );

end arch;
