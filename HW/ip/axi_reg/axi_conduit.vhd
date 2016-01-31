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


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity axi_conduit is
    generic (
        AUTO_CLOCK_CLOCK_RATE : string := "-1"
    );
    port (
        clk             : in  std_logic                     := '0';             --   clock.clk
        reset           : in  std_logic                     := '0';             --   reset.reset

        axs_s0_awid     : in  std_logic_vector(13 downto 0) := (others => '0'); --  axi_in.awid
        axs_s0_awaddr   : in  std_logic_vector(13 downto 0) := (others => '0'); --        .awaddr
        axs_s0_awlen    : in  std_logic_vector(7 downto 0)  := (others => '0'); --        .awlen
        axs_s0_awsize   : in  std_logic_vector(2 downto 0)  := (others => '0'); --        .awsize
        axs_s0_awburst  : in  std_logic_vector(1 downto 0)  := (others => '0'); --        .awburst
        axs_s0_awvalid  : in  std_logic                     := '0';             --        .awvalid
        axs_s0_awready  : out std_logic;                                        --        .awready
        axs_s0_wdata    : in  std_logic_vector(31 downto 0) := (others => '0'); --        .wdata
        axs_s0_wstrb    : in  std_logic_vector(3 downto 0)  := (others => '0'); --        .wstrb
        axs_s0_wvalid   : in  std_logic                     := '0';             --        .wvalid
        axs_s0_wready   : out std_logic;                                        --        .wready
        axs_s0_bid      : out std_logic_vector(13 downto 0);                    --        .bid
        axs_s0_bvalid   : out std_logic;                                        --        .bvalid
        axs_s0_bready   : in  std_logic                     := '0';             --        .bready
        axs_s0_arid     : in  std_logic_vector(13 downto 0) := (others => '0'); --        .arid
        axs_s0_araddr   : in  std_logic_vector(13 downto 0) := (others => '0'); --        .araddr
        axs_s0_arlen    : in  std_logic_vector(7 downto 0)  := (others => '0'); --        .arlen
        axs_s0_arsize   : in  std_logic_vector(2 downto 0)  := (others => '0'); --        .arsize
        axs_s0_arburst  : in  std_logic_vector(1 downto 0)  := (others => '0'); --        .arburst
        axs_s0_arvalid  : in  std_logic                     := '0';             --        .arvalid
        axs_s0_arready  : out std_logic;                                        --        .arready
        axs_s0_rdata    : out std_logic_vector(31 downto 0);                    --        .rdata
        axs_s0_rlast    : out std_logic;                                        --        .rlast
        axs_s0_rvalid   : out std_logic;                                        --        .rvalid
        axs_s0_rready   : in  std_logic                     := '0';             --        .rready
        axs_s0_rid      : out std_logic_vector(13 downto 0);                    --        .rid

        clk_o           : out std_logic;
        reset_o         : out std_logic;

        axs_s1_awid     : out std_logic_vector(13 downto 0);                    -- axi_out.awid
        axs_s1_awaddr   : out std_logic_vector(13 downto 0);                    --        .awaddr
        axs_s1_awlen    : out std_logic_vector(7 downto 0);                     --        .awlen
        axs_s1_awsize   : out std_logic_vector(2 downto 0);                     --        .awsize
        axs_s1_awburst  : out std_logic_vector(1 downto 0);                     --        .awburst
        axs_s1_awvalid  : out std_logic;                                        --        .awvalid
        axs_s1_awready  : in  std_logic                     := '0';             --        .awready
        axs_s1_wdata    : out std_logic_vector(31 downto 0);                    --        .wdata
        axs_s1_wstrb    : out std_logic_vector(3 downto 0);                     --        .wstrb
        axs_s1_wvalid   : out std_logic;                                        --        .wvalid
        axs_s1_wready   : in  std_logic                     := '0';             --        .wready
        axs_s1_bid      : in  std_logic_vector(13 downto 0) := (others => '0'); --        .bid
        axs_s1_bvalid   : in  std_logic                     := '0';             --        .bvalid
        axs_s1_bready   : out std_logic;                                        --        .bready
        axs_s1_arid     : out std_logic_vector(13 downto 0);                    --        .arid
        axs_s1_araddr   : out std_logic_vector(13 downto 0);                    --        .araddr
        axs_s1_arlen    : out std_logic_vector(7 downto 0);                     --        .arlen
        axs_s1_arsize   : out std_logic_vector(2 downto 0);                     --        .arsize
        axs_s1_arburst  : out std_logic_vector(1 downto 0);                     --        .arburst
        axs_s1_arvalid  : out std_logic;                                        --        .arvalid
        axs_s1_arready  : in  std_logic                     := '0';             --        .arready
        axs_s1_rid      : in  std_logic_vector(13 downto 0)  := (others => '0');--        .rid
        axs_s1_rdata    : in  std_logic_vector(31 downto 0) := (others => '0'); --        .rdata
        axs_s1_rlast    : in  std_logic                     := '0';             --        .rlast
        axs_s1_rvalid   : in  std_logic                     := '0';             --        .rvalid
        axs_s1_rready   : out std_logic                                         --        .rready
    );
end entity axi_conduit;

architecture rtl of axi_conduit is
begin

    clk_o           <= clk;
    reset_o         <= reset;

    axs_s0_arready  <= axs_s1_arready ;
    axs_s0_bid      <= axs_s1_bid     ;
    axs_s0_awready  <= axs_s1_awready ;
    axs_s0_bvalid   <= axs_s1_bvalid  ;
    axs_s0_rvalid   <= axs_s1_rvalid  ;
    axs_s0_wready   <= axs_s1_wready  ;
    axs_s0_rdata    <= axs_s1_rdata   ;
    axs_s0_rid      <= axs_s1_rid     ;
    axs_s0_rlast    <= axs_s1_rlast   ;

    axs_s1_awid     <= axs_s0_awid    ;
    axs_s1_awaddr   <= axs_s0_awaddr  ;
    axs_s1_awlen    <= axs_s0_awlen   ;
    axs_s1_awsize   <= axs_s0_awsize  ;
    axs_s1_awburst  <= axs_s0_awburst ;
    axs_s1_awvalid  <= axs_s0_awvalid ;
    axs_s1_wdata    <= axs_s0_wdata   ;
    axs_s1_wstrb    <= axs_s0_wstrb   ;
    axs_s1_wvalid   <= axs_s0_wvalid  ;
    axs_s1_bready   <= axs_s0_bready  ;
    axs_s1_arid     <= axs_s0_arid    ;
    axs_s1_araddr   <= axs_s0_araddr  ;
    axs_s1_arlen    <= axs_s0_arlen   ;
    axs_s1_arsize   <= axs_s0_arsize  ;
    axs_s1_arburst  <= axs_s0_arburst ;
    axs_s1_arvalid  <= axs_s0_arvalid ;
    axs_s1_rready   <= axs_s0_rready  ;

end architecture rtl; -- of axi_conduit
