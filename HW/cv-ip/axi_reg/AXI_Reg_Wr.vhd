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

entity AXI_Reg_Wr_E is
    port (
        clk             : in  std_logic;
        rst             : in  std_logic;

        -- Write Address Channel
        axi_awid        : in  std_logic_vector(13 downto 0);                    -- axs_s1_awid
        axi_awaddr      : in  std_logic_vector(13 downto 0);                    -- axs_s1_awaddr
        axi_awlen       : in  std_logic_vector(7 downto 0);                     -- axs_s1_awlen
        axi_awsize      : in  std_logic_vector(2 downto 0);                     -- axs_s1_awsize
        axi_awburst     : in  std_logic_vector(1 downto 0);                     -- axs_s1_awburst
      --axi_awlock      : in  std_logic_vector(1 downto 0);
      --axi_awcache     : in  std_logic_vector(3 downto 0);
      --axi_awprot      : in  std_logic_vector(2 downto 0);
        axi_awvalid     : in  std_logic;                                        -- axs_s1_awvalid
        axi_awready     : out std_logic                     := 'X';             -- axs_s1_awready

        -- Write Data Channel
        axi_wdata       : in  std_logic_vector(31 downto 0);                    -- axs_s1_wdata
        axi_wstrb       : in  std_logic_vector(3 downto 0);                     -- axs_s1_wstrb
      --axi_wlast       : in  std_logic;
        axi_wvalid      : in  std_logic;                                        -- axs_s1_wvalid
        axi_wready      : out std_logic                     := 'X';             -- axs_s1_wready

        -- Write Response Channel
        axi_bid         : out std_logic_vector(13 downto 0) := (others => 'X'); -- axs_s1_bid
      --axi_bresp       : out std_logic_vector(1 downto 0);
        axi_bvalid      : out std_logic                     := 'X';             -- axs_s1_bvalid
        axi_bready      : in  std_logic;                                        -- axs_s1_bready

        -- Register write interface
        --   2 banks of 256 register
        --   1 FIFO style burst write port
        Bank1RegWr      : out RegWrA_T;
        Bank2RegWr      : out RegWrA_T;
        FIFORegWr       : out FIFORegWrA_T );

end AXI_Reg_Wr_E;

architecture arch of AXI_Reg_Wr_E is

    signal txa_busy     : std_logic;
    signal txd_busy     : std_logic;
    signal tx_done      : std_logic;

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

    signal num_bytes    : unsigned(3 downto 0);

    signal wr_addr      : unsigned(13 downto 0);
    signal wr_data      : std_logic_vector(31 downto 0);
    signal wr_be        : std_logic_vector(3 downto 0);
    signal wr_ena       : std_logic;

    signal reg_addr     : std_logic_vector(7 downto 0);
    signal reg_data     : std_logic_vector(63 downto 0);
    signal reg_be       : std_logic_vector(7 downto 0);
    signal reg_wren     : std_logic;
    signal reg_we_ena   : std_logic;
    signal reg_we       : std_logic_vector(511 downto 0);
    signal dma_sel      : std_logic;
    signal reg_sel      : std_logic;
    signal fifo_sel     : std_logic;

begin
    axi_awready <= '1' when txa_busy='0' else '0';
    axi_wready  <= '1' when txd_busy='1' else '0';
    axi_bid     <= tx_id;
    axi_bvalid  <= tx_done;

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


    process(clk)
    begin
        if rising_edge(clk) then
            if rst='1' then
                txa_busy    <= '0';
                txd_busy    <= '0';
                tx_done     <= '0';

                tx_id       <= (others=>'0');
                tx_addr     <= (others=>'0');
                tx_len      <= (others=>'0');
                tx_size     <= (others=>'0');
                tx_burst    <= (others=>'0');

                wr_addr     <= (others=>'0');
                wr_data     <= (others=>'0');
                wr_be       <= (others=>'0');
            else
                -- Start of write transaction
                if axi_awvalid='1' and txa_busy='0' then
                    txd_busy    <= '1';
                    tx_id       <= axi_awid;
                    tx_addr     <= unsigned(axi_awaddr);
                    tx_len      <= unsigned(axi_awlen);
                    tx_size     <= axi_awsize;
                    tx_burst    <= axi_awburst;
                -- Last data transfer
                elsif txd_busy='1' and axi_wvalid='1' and tx_len=0 then
                    txd_busy    <= '0';
                -- Generic data transfer
                elsif txd_busy='1' and axi_wvalid='1' then
                    tx_addr     <= tx_addr_nxt;
                    tx_len      <= tx_len - 1;
                end if;

                -- Data phase transfers
                if txd_busy='1' and axi_wvalid='1' then
                    wr_addr     <= tx_addr;
                    wr_data     <= axi_wdata;
                    wr_be       <= axi_wstrb;
                    wr_ena      <= '1';
                else
                    wr_ena      <= '0';
                end if;

                -- Start of write transaction
                if axi_awvalid='1' and txa_busy='0' then
                    txa_busy    <= '1';
                -- End of data phase, send write response
                elsif txd_busy='1' and axi_wvalid='1' and tx_len=0 then
                    txa_busy    <= '0';
                    tx_done     <= '1';
                  --axi_bresp   <= b00=OK, b01=EXOK, b10=Slave Error, b11=Decode Error
                -- Write response accepted, we're done here
                elsif tx_done='1' and axi_bready='1' then
                    txa_busy    <= '0';
                    tx_done     <= '0';
                end if;

            end if;
        end if;
    end process;

    -- Register generation of actual register write signals
    process(clk)
    begin
        if rising_edge(clk) then
            if rst='1' then
                reg_addr    <= (others=>'0');
                reg_data    <= (others=>'0');
                reg_be      <= (others=>'0');
                reg_wren    <= '0';
                dma_sel     <= '0';
                reg_sel     <= '0';
                fifo_sel    <= '0';
            else
                -- Convert byte write address to 64-bit QWORD address
                reg_addr    <= std_logic_vector(resize(wr_addr(wr_addr'left downto 3),reg_addr'length));

                reg_data    <= wr_data & wr_data;

                if wr_addr(2)='0' then
                    reg_be(3 downto 0)  <= wr_be;
                    reg_be(7 downto 4)  <= (others=>'0');
                else
                    reg_be(3 downto 0)  <= (others=>'0');
                    reg_be(7 downto 4)  <= wr_be;
                end if;

                reg_wren    <= wr_ena;

                if wr_addr(12)='0' then
                    if wr_addr(11)='0' then
                        dma_sel     <= '1';
                        reg_sel     <= '0';
                        fifo_sel    <= '0';
                    else
                        dma_sel     <= '0';
                        reg_sel     <= '1';
                        fifo_sel    <= '0';
                    end if;
                else
                    dma_sel     <= '0';
                    reg_sel     <= '0';
                    fifo_sel    <= '1';
                end if;

            end if;
        end if;
    end process;

    Bank1RegWr.addr   <= reg_addr;
    Bank1RegWr.data   <= reg_data;
    Bank1RegWr.be     <= reg_be;
    Bank1RegWr.we     <= reg_we(255 downto 0);
    Bank1RegWr.wren   <= reg_wren;
    Bank1RegWr.sel    <= dma_sel;

    Bank2RegWr.addr  <= reg_addr;
    Bank2RegWr.data  <= reg_data;
    Bank2RegWr.be    <= reg_be;
    Bank2RegWr.we    <= reg_we(511 downto 256);
    Bank2RegWr.wren  <= reg_wren;
    Bank2RegWr.sel   <= reg_sel;

    FIFORegWr.addr  <= reg_addr(1 downto 0);
    FIFORegWr.data  <= reg_data;
    FIFORegWr.be    <= reg_be;
    FIFORegWr.wren  <= reg_wren;
    FIFORegWr.sel   <= fifo_sel;

    reg_we_ena  <= '1' when wr_ena='1' and wr_addr(12)='0' else '0';                

    reg_we_decode : lpm_decode
        generic map (
            LPM_PIPELINE    => 1,
            LPM_WIDTH       => 9,
            LPM_DECODES     => 512)
        port map(
            clock   => clk,
            data    => std_logic_vector(wr_addr(11 downto 3)),
            enable  => reg_we_ena,
            eq      => reg_we);

end arch;
