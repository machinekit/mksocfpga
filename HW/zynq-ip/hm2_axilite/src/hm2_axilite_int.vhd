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

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity hm2_axilite_int is
	generic (
		C_S_AXI_DATA_WIDTH	: integer	:= 32;		-- Width of S_AXI data bus
		C_S_AXI_ADDR_WIDTH	: integer	:= 16 		-- Width of S_AXI address bus
	);
	port (
		-- Generic 32-bit bus signals --
		-- The addr signal takes the MSbs from the AXI addr bus and passes them on
		-- clipping the bottom two lsbs.
		ADDR : out std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 2);
		-- These names are backwards from their logical direction so
		-- we can have a 1:1 mapping with the hostmot2 component
		IBUS : out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		OBUS : in std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		READSTB : out std_logic;
		WRITESTB : out std_logic;
        
		-- AXI Signals --
		-- Global Clock Signal
		S_AXI_aclk : in std_logic;
		-- Global Reset Signal. This Signal is Active LOW
		S_AXI_aresetn : in std_logic;
		-- Write address (issued by master, acceped by Slave)
		S_AXI_awaddr : in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		-- Write channel Protection type. This signal indicates the
		-- privilege and security level of the transaction, and whether
		-- the transaction is a data access or an instruction access.
		S_AXI_awprot : in std_logic_vector(2 downto 0);
		-- Write address valid. This signal indicates that the master signaling
		-- valid write address and control information.
		S_AXI_awvalid : in std_logic;
		-- Write address ready. This signal indicates that the slave is ready
		-- to accept an address and associated control signals.
		S_AXI_awready : out std_logic;
		-- Write data (issued by master, acceped by Slave)
		S_AXI_wdata : in std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		-- Write strobes. This signal indicates which byte lanes hold
		-- valid data. There is one write strobe bit for each eight
		-- bits of the write data bus.
		S_AXI_wstrb : in std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
		-- Write valid. This signal indicates that valid write
		-- data and strobes are available.
		S_AXI_wvalid : in std_logic;
		-- Write ready. This signal indicates that the slave
		-- can accept the write data.
		S_AXI_wready : out std_logic;
		-- Write response. This signal indicates the status
		-- of the write transaction.
		S_AXI_bresp : out std_logic_vector(1 downto 0);
		-- Write response valid. This signal indicates that the channel
		-- is signaling a valid write response.
		S_AXI_bvalid : out std_logic;
		-- Response ready. This signal indicates that the master
		-- can accept a write response.
		S_AXI_bready : in std_logic;
		-- Read address (issued by master, acceped by Slave)
		S_AXI_araddr : in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		-- Protection type. This signal indicates the privilege
		-- and security level of the transaction, and whether the
		-- transaction is a data access or an instruction access.
		S_AXI_arprot : in std_logic_vector(2 downto 0);
		-- Read address valid. This signal indicates that the channel
		-- is signaling valid read address and control information.
		S_AXI_arvalid : in std_logic;
		-- Read address ready. This signal indicates that the slave is
		-- ready to accept an address and associated control signals.
		S_AXI_arready : out std_logic;
		-- Read data (issued by slave)
		S_AXI_rdata : out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		-- Read response. This signal indicates the status of the
		-- read transfer.
		S_AXI_rresp : out std_logic_vector(1 downto 0);
		-- Read valid. This signal indicates that the channel is
		-- signaling the required read data.
		S_AXI_rvalid : out std_logic;
		-- Read ready. This signal indicates that the master can
		-- accept the read data and response information.
		S_AXI_rready : in std_logic
	);
end hm2_axilite_int;

architecture arch_imp of hm2_axilite_int is
	-- Internal state signals
	type sm_type is (idle, buf_read, reading, buf_write, writing);
	signal current_state, next_state : sm_type;
	signal read_done : std_logic;
	signal write_done : std_logic;
	signal buffering : std_logic;
	signal write_go : std_logic;
	signal read_go : std_logic;

	-- Latched address and strobe for hm2 interface
	signal latched_addr	: std_logic_vector(C_S_AXI_ADDR_WIDTH-3 downto 0);
	signal read_enable : std_logic;
	signal write_enable : std_logic;

	-- AXI4LITE signals
	signal axi_awready	: std_logic;
	signal axi_wready	: std_logic;
	signal axi_bresp	: std_logic_vector(1 downto 0);
	signal axi_bvalid	: std_logic;
	signal axi_arready	: std_logic;
	signal axi_rdata	: std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal axi_rresp	: std_logic_vector(1 downto 0);
	signal axi_rvalid	: std_logic;

begin
	-- The generic bus interface has two data busses. Just link them
	-- with the AXI counterparts
	IBUS <= S_AXI_wdata;	-- The AXI write bus is the input bus for the hm2
	ADDR <= latched_addr;	-- Pass out the latched address to the hm2

    -- hm2 has it's own address latch also. This signal burns a clock to sync
    buffering <= '1' when (current_state = buf_read or current_state = buf_write) else '0';

    write_go <= '1' when (axi_awready = '0' and axi_wready = '0' and S_AXI_awvalid = '1' and S_AXI_wvalid = '1') else '0';
	read_go <= '1' when (axi_arready = '0' and S_AXI_arvalid = '1') else '0';
	
	-- Slave register read enable is asserted when valid address is available
	-- and the slave is ready to accept the read address.
	READSTB <= read_enable;
	-- Slave register write enable is asserted when valid address is available
	-- and the slave is ready to write the valid data
	WRITESTB <= write_enable;

	S_AXI_awready	<= axi_awready;
	S_AXI_wready	<= axi_wready;
	S_AXI_bresp	<= axi_bresp;
	S_AXI_bvalid	<= axi_bvalid;
	S_AXI_arready	<= axi_arready;
	S_AXI_rdata	<= axi_rdata;
	S_AXI_rresp	<= axi_rresp;
	S_AXI_rvalid	<= axi_rvalid;

	-- Slave is ready to latch address when it's in the idle state and
	-- there is valid data on both address and data bus for read or write
	-- The address ready strobe is only asserted for one clock
	latch_address : process (S_AXI_aclk, current_state, read_go, write_go)
	begin
		if (rising_edge(S_AXI_aclk)) then
			if (S_AXI_aresetn = '0') then
				latched_addr <= (others => '0');
			else
				if(current_state = idle) then
					if (read_go = '1') then
						latched_addr <= S_AXI_araddr(15 downto 2);	-- Latch the address from the read bus
					elsif (write_go = '1') then
						latched_addr <= S_AXI_awaddr(15 downto 2); -- Latch the address from the write bus
					end if;
				end if;
			end if;
		end if;
	end process;
	
	rcont : process( S_AXI_aclk, S_AXI_aresetn, read_go, buffering)
	begin
	   if (rising_edge(S_AXI_aclk)) then
	       if(S_AXI_aresetn = '0') then
                axi_arready <= '0';
           elsif(read_go = '1' and buffering = '1') then
                axi_arready <= '1';  -- Indicate we have accepted the valid address
	       else
	           axi_arready <= '0';
	       end if;
	   end if;
	end process;
	
	wcont : process( S_AXI_aclk, S_AXI_aresetn, write_go, buffering)
	begin
	   if (rising_edge(S_AXI_aclk)) then
	       if(S_AXI_aresetn = '0') then
                axi_wready <= '0';
                axi_awready <= '0';
	       elsif(write_go = '1' and buffering = '1') then
	           axi_wready <= '1';
	           axi_awready <= '1';
	       else
	           axi_wready <= '0';
               axi_awready <= '0';
           end if;
	   end if;
	end process;

	-- Latch the read data from the hm2 device before presenting it to the
	-- AXI layer, and generate the correct response data. Doesn't seem to be an
	-- error indicator from hm2, so all response codes are 'OKAY'. Reading an invalid
	-- register should mimic the behavior of an unwrapped hm2
	read_enable <= axi_arready and S_AXI_arvalid and (not axi_rvalid) and (not buffering);
	read_done <= axi_rvalid and S_AXI_rready;
	process( S_AXI_aclk, read_enable, read_done ) is
	begin
		if (rising_edge (S_AXI_aclk)) then
			if (S_AXI_aresetn = '0') then
				axi_rdata <= (others => '0');
				axi_rvalid <= '0';
				axi_rresp <= "00"; -- 'OKAY' response by default
			else
				if (read_enable = '1') then
					axi_rdata <= OBUS;     -- register read data
					axi_rvalid <= '1';
					axi_rresp <= "00";
				elsif (read_done = '1') then
					axi_rvalid <= '0'; -- Read was accepted by master
				end if;
			end if;
		end if;
	end process;

	-- Implement write response logic generation
	-- The write response and response valid signals are asserted by the slave
	-- when axi_wready, S_AXI_wvalid, axi_wready and S_AXI_wvalid are asserted.
	-- This marks the acceptance of address and indicates the status of
	-- write transaction. Doesn't seem to be an
	-- error indicator from hm2, so all response codes are 'OKAY'. Reading an invalid
	-- register should mimic the behavior of an unwrapped hm2
	write_enable <= axi_awready and S_AXI_awvalid and axi_wready and S_AXI_wvalid and (not buffering);
	write_done <= S_AXI_bready and axi_bvalid;
	process (S_AXI_aclk, S_AXI_aresetn, write_enable, write_done)
	begin
		if rising_edge(S_AXI_aclk) then
			if (S_AXI_aresetn = '0') then
				axi_bvalid <= '0';
				axi_bresp <= "00";
			else
				if (write_enable = '1' and axi_bvalid = '0') then
					axi_bvalid <= '1';
					axi_bresp  <= "00";
				elsif (write_done = '1') then   -- check if bready is asserted while bvalid is high)
					axi_bvalid <= '0';            -- (there is a possibility that bready is always asserted high)
				end if;
			end if;
		end if;
	end process;

	-- Process simply moves to the next state or resets to the original state
	update_state : process (S_AXI_aclk, S_AXI_aresetn)
	begin
		if (rising_edge(S_AXI_aclk)) then
			if (S_AXI_aresetn = '0') then
				current_state <= idle;
			else
				current_state <= next_state;
			end if;
		end if;
	end process;

	-- Read and write transactions are processed in a
	-- first-come-first-served manner. If a read/write is
	-- in process and a write/read is requested, the write/read
	-- will be processed after the running read/write is completed.
	calc_state : process(current_state, S_AXI_arvalid, S_AXI_awvalid, write_done, read_done, write_go, read_go)
	begin
		case current_state is
			when idle =>
				next_state <= idle; 	-- Default back to idle state
				if (read_go = '1') then	-- Read has precedence over write
					next_state <= buf_read;
				elsif (write_go = '1') then
					next_state <= buf_write;
				end if;
			when buf_read =>
			     next_state <= reading;	
			when reading =>
				next_state <= reading;
				if (read_done = '1') then
					next_state <= idle;
				end if;
			when buf_write =>
			     next_state <= writing;
			when writing =>
				next_state <= writing;
				if (write_done = '1') then
					next_state <= idle;
				end if;
			when others => next_state <= idle;
		end case;
	end process;

end arch_imp;
