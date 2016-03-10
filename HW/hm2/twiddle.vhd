
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.MATH_REAL.ALL;

--
-- Copyright (C) 2010, Peter C. Wallace, Mesa Electronics
-- http://www.mesanet.com
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

use work.log2.all;
use work.decodedstrobe.all;	
use work.oneofndecode.all;	

entity twiddle is
	generic (
		InterfaceRegs : integer;		-- must be power of 2 max 64
		InputBits : integer;				-- max 32
		Outputbits : integer;			-- max 32
		BaseClock : integer
			);
   port ( 
		clk : in std_logic;
		ibus : in std_logic_vector(31 downto 0);
      obus : out std_logic_vector(31 downto 0);
		hloadcommand : in std_logic;
		hreadcommand : in std_logic;
		hloaddata : in std_logic;
		hreaddata : in std_logic;           
		regraddr : in std_logic_vector(log2(InterfaceRegs) -1 downto 0);
		regwaddr : in std_logic_vector(log2(InterfaceRegs) -1 downto 0);
		hloadregs : in std_logic;
		hreadregs : in std_logic;
		ibits : in std_logic_vector(InputBits -1 downto 0);
		obits : out std_logic_vector(OutputBits -1 downto 0);
		testbit : out std_logic
		);
end twiddle;

architecture Behavioral of twiddle is


signal iabus: std_logic_vector(10 downto 0);
signal idbus: std_logic_vector(15 downto 0); 
signal mradd: std_logic_vector(11 downto 0);
signal mwadd: std_logic_vector(11 downto 0); 
signal mobus: std_logic_vector(7 downto 0);
signal mwrite: std_logic;      
signal mread: std_logic;	
			
-- data memory partitioning--			
signal muxedmibus: std_logic_vector(7 downto 0); 	-- the data input path to the processor 
signal ramdata: std_logic_vector(7 downto 0); 		-- and its sources
signal iodata: std_logic_vector(7 downto 0); 

signal ioradd: std_logic_vector(11 downto 0);

signal writedram: std_logic;

-- host interface signals
signal hcommandreg: std_logic_vector(15 downto 0);
alias  romwrena : std_logic is hcommandreg(14); -- if high, reset CPU and allow read/write CPU ROM access
signal hdatareg: std_logic_vector(7 downto 0); 
signal lloadcommand: std_logic;
signal lreadcommandl: std_logic;
signal lreadcommandh: std_logic;
signal ldatareg: std_logic_vector(7 downto 0); 
signal lloaddata: std_logic;
signal lreaddata: std_logic;
signal romdata: std_logic_vector(15 downto 0); 
signal loadrom: std_logic;

-- interface RAM 8-32 shim signals
signal hibus32: std_logic_vector(31 downto 0);
signal libus32: std_logic_vector(31 downto 0);
signal lobus32: std_logic_vector(31 downto 0);
signal lobus24: std_logic_vector(23 downto 0);
signal libuslatch: std_logic_vector(31 downto 8);
signal latchtop24: std_logic;
signal writeiram: std_logic;
signal lwriteiram: std_logic;
signal lreadiram: std_logic;

-- ioport signals
signal oport: std_logic_vector(OutputBits -1 downto 0);				-- the output port
signal oportbuf: std_logic_vector(OutputBits -1 downto 0);			-- the output port buffer


signal writeoport: std_logic;
signal writeoportbuf: std_logic;
signal updatefrombuf: std_logic;

signal readoport: std_logic;

signal iportbuf: std_logic_vector(InputBits -1 downto 0) := (others => '1');			-- the input port buffer
signal readiportbuf: std_logic;
signal readiport: std_logic;

signal sampleinputs: std_logic;

-- debug test bit out
signal ltestbit: std_logic;
signal lsettestbit: std_logic;
signal lclrtestbit: std_logic;


-- timer signals

constant defaulttimerrate : integer := integer(round(real(65536.0*10000000.0/real(BaseClock)))); -- 10 MHz default timer rate

signal lreadtimerl: std_logic;
signal lreadtimerh: std_logic;
signal lwritetimerl: std_logic;
signal lwritetimerh: std_logic;
signal timerrate: std_logic_vector(15 downto 0) := conv_std_logic_vector(defaulttimerrate,16);
signal timeracc: std_logic_vector(15 downto 0);
signal timerlatch: std_logic_vector(7 downto 0);
signal timercount: std_logic_vector(15 downto 0);
alias timermsb: std_logic is timeracc(15);
signal oldtimermsb: std_logic;

-- doorbell signals
signal doorbellreg: std_logic_vector(InterfaceRegs-1 downto 0); 
signal readdoorbell: std_logic;
signal cleardoorbell: std_logic;
 
-- baseclock signals
signal lreadclock: std_logic;
signal baseclockslv: std_logic_vector(31 downto 0);
begin

	processor: entity work.DumbAss8sqw	
	port map (
		clk		 => clk,
		reset	  => romwrena,
		iabus	  =>  iabus,		  -- program address bus
		idbus	  =>  idbus,		  -- program data bus		 
		mradd	  =>  mradd,		  -- memory read address
		mwadd	  =>  mwadd,		  -- memory write address
		mibus	  =>  muxedmibus,	  
		-- memory data in bus	  
		mobus	  =>  mobus,		  -- memory data out bus
		mwrite  =>  mwrite,		  -- memory write signal	
      mread   =>  mread		     -- memory read signal	
--		carryflg  =>				  -- carry flag
		);

  twiddlerom: entity work.twidrom 
  port map(
		addra => hcommandreg(9 downto 0),		-- 1k (x16) till we run out of space
		addrb => iabus(9 downto 0),
		clk  => clk,
		dina  => ibus(15 downto 0),
		douta => romdata,
		doutb => idbus,
		wea	=> loadrom
	 );
	 
	DataRam : entity work.dpram 
	generic map (
		width => 8,
		depth => 512
				)
	port map(
		addra => mwadd(8 downto 0),
		addrb => mradd(8 downto 0),
		clk  => clk,
		dina  => mobus,
--		douta => 
		doutb => ramdata,
		wea	=> writedram
	 );	 

	interfaceramout: entity work.dpram
	generic map (
		width => 32,
		depth => InterFaceRegs
				)
	port map(
		addra => mwadd(log2(InterfaceRegs) +1 downto 2),
		addrb => regraddr,
		clk  => clk,
		dina  => lobus32,
--		douta => 
		doutb => hibus32,
		wea	=> writeiram
		); 

	interfaceramin: entity work.dpram
	generic map (
		width => 32,
		depth => InterFaceRegs 
				)
	port map(
		addra => regwaddr, 
		addrb => mradd(log2(InterfaceRegs) +1 downto 2),
		clk  => clk,
		dina  => ibus,
--		douta => 
		doutb => libus32,
		wea	=> hloadregs
		); 


	iobus:  process(clk,ioradd,ramdata, iodata)
	begin
		if rising_edge(clk) then
			ioradd <= mradd;
		end if;
		
		if ioradd(10) = '0' then
			muxedmibus <= ramdata;		 		-- RAM is 0,3FF and 800,BFF (only 512B now)
		else
			muxedmibus <= iodata;				-- I/O space is 400,7FF and C00,FFF
		end if;
		
	end process iobus;		


	hostinterface : process (clk, hloaddata, romwrena, hreadcommand,
	                         hreaddata, ldatareg, romdata, lreadcommandl, 
									 lreadcommandh, hcommandreg, lreaddata, hdatareg, ltestbit)
	begin
		-- first the writes
		if rising_edge(clk) then
			-- first host writes 
			if hloadcommand = '1' then
				hcommandreg <= ibus(15 downto 0);
			end if;	

			if hloaddata = '1' then 
				hdatareg <= ibus(7 downto 0);
			end if;	

			-- next local writes and sync logic 
			if lloadcommand = '1' then
				hcommandreg <= (others => '0');
			end if;	

			if lloaddata = '1' then 
				ldatareg <= mobus;				
			end if;	
			
			if lsettestbit = '1' then
				ltestbit <= '1';
			end if;	

			if lclrtestbit = '1' then
				ltestbit <= '0';
			end if;	

		end if; -- clk
		
		if hloaddata = '1' and romwrena = '1' then		-- write data to rom on host datareg writes
			loadrom <= '1';
		else
			loadrom <= '0';
		end if;
		
		-- then the reads
		-- first the host reads
		obus <= (others => 'Z');
		if hreaddata = '1' then
			if romwrena = '0' then							-- normally just read the data register
				obus(7 downto 0)  <= ldatareg;
				obus(31 downto 8) <= (others => '0');	
			else
				obus(15 downto 0) <= romdata;				-- but if romwrena set, read the ROM data
				obus(31 downto 16) <=(others => '0');
			end if;
		end if;	
		if hreadcommand = '1' then
			obus(15 downto 0) <= hcommandreg;			-- host readback command reg
			obus(31 downto 16) <=(others => '0');
		end if;
		
		iodata <= (others => 'Z');
		if lreadcommandl= '1' then
			iodata <= hcommandreg(7 downto 0);
		end if;
		if lreadcommandh = '1' then
			iodata <= hcommandreg(15 downto 8);
		end if;
		
		if lreaddata = '1' then
			iodata <= hdatareg;
		end if;
		
		
		testbit <= ltestbit;
	end process hostinterface;	

	WidthShim : process (clk, lreadiram, ioradd, libus32, libuslatch, 
	                     hreadregs, hibus32, mwadd, lwriteiram, mobus, lobus24)
	begin
		-- first the writes
		-- local to host
		if rising_edge(clk) then
			if writeiram = '1' then
				lobus24 <= (others => '0');						-- clear the latch after write to RAM
			end if;
			if lwriteiram = '1' then
				case mwadd(1 downto 0) is
					when "00" => lobus24(7 downto 0)   <= mobus;
					when "01" => lobus24(15 downto 8)  <= mobus;
					when "10" => lobus24(23 downto 16) <= mobus;
					when others => null;
				end case;
			end if;	
			if latchtop24 = '1' then
				libuslatch <= libus32(31 downto 8);
			end if;
		end if; -- clk
		writeiram <= decodedstrobe(mwadd(1 downto 0),"11",lwriteiram);		
		lobus32 <= mobus & lobus24;
		-- then the reads
		iodata <= (others => 'Z');
		latchtop24 <= '0';
		if lreadiram = '1' then
			if ioradd(1 downto 0) = "00" then					-- on a local read we read the bottom 8 bits
				iodata <=  libus32(7 downto 0);
				latchtop24 <= '1';									-- and signal to latch the other 24
			end if;														-- so we sample all 32 bits at once					
			case ioradd(1 downto 0) is
				when "01" => iodata <=  libuslatch(15 downto 8);
				when "10" => iodata <=  libuslatch(23 downto 16);
				when "11" => iodata <=  libuslatch(31 downto 24);
				when others => null;
			end case;
		end if;
		obus <= (others => 'Z');
		if hreadregs = '1' then
			obus <= hibus32;
		end if;	
	end process WidthShim;
	
	onebyteout: if (OutputBits < 9) and (OutputBits >0) generate
		Oport8 : process(clk,ioradd,readoport,oport)
		begin
			if rising_edge(clk) then
				if writeoport = '1' then
					oport <= mobus(OutputBits-1 downto 0);
				end if;	
				if writeoportbuf = '1' then
					oportbuf <= mobus(OutputBits-1 downto 0);
				end if;	
				if updatefrombuf = '1' then
					oport <= oportbuf;
				end if;		
			end if;
			iodata <= (others => 'Z');
			if readoport = '1' then
				iodata(OutputBits-1 downto 0) <= oport;
			end if;	
		end process;		
	end generate;		
		
	twobyteout: if (OutputBits > 8) and (OutputBits < 17) generate
		Oport16 : process(clk,ioradd,readoport,oport)
		begin
			if rising_edge(clk) then
				if writeoport = '1' then
					case mwadd(0) is
						when '0' => 
							oport(7 downto 0) <= mobus;
						when '1' => 
							oport(OutputBits-1 downto 8) <= mobus(OutputBits-9 downto 0);
						when others => 
							null;
					end case;	
				end if;	
				if writeoportbuf = '1' then
					case mwadd(0) is
						when '0' => 
							oportbuf(7 downto 0) <= mobus;
						when '1' => 
							oportbuf(OutputBits-1 downto 8) <= mobus(OutputBits-9 downto 0);
						when others => 
							null;
					end case;		
				end if;	
				if updatefrombuf = '1' then
					oport <= oportbuf;
				end if;		
			end if;
			iodata <= (others => 'Z');
			if readoport = '1' then
				case ioradd(0) is
					when '0' => 
						iodata <= oport(7 downto 0);
					when '1' => 
						iodata(OutputBits-9 downto 0) <= oport(OutputBits-1 downto 8);
					when others => 
						null;
				end case;
			end if;	
		end process;		
	end generate;			

	threebyteout: if (OutputBits > 16) and (OutputBits < 25) generate
		Oport24 : process(clk,ioradd,readoport,oport)
		begin
			if rising_edge(clk) then
				if writeoport = '1' then
					case mwadd(1 downto 0) is
						when "00" => 
							oport(7 downto 0) <= mobus;
						when "01" => 
							oport(15 downto 8) <= mobus;
						when "10" => 
							oport(OutputBits-1 downto 16) <= mobus(OutputBits-17 downto 0);
						when others => 
							null;
					end case;	
				end if;	
				if writeoportbuf = '1' then
					case mwadd(1 downto 0) is
						when "00" => 
							oportbuf(7 downto 0) <= mobus;
						when "01" => 
							oportbuf(15 downto 8) <= mobus;
						when "10" => 
							oportbuf(OutputBits-1 downto 16) <= mobus(OutputBits-17 downto 0);
						when others => 
							null;
					end case;
				end if;	
				if updatefrombuf = '1' then
					oport <= oportbuf;
				end if;		
			end if;
			iodata <= (others => 'Z');
			if readoport = '1' then
				case ioradd(1 downto 0) is
					when "00" => 
						iodata <= oport(7 downto 0);
					when "01" => 
						iodata <= oport(15 downto 8);
					when "10" => 
						iodata(OutputBits-17 downto 0) <= oport(OutputBits-1 downto 16);
					when others => 
						null;
				end case;
			end if;	
		end process;		
	end generate;			

	fourbyteout: if (OutputBits > 24) and (OutputBits < 33)generate		-- max 32 bits
		Oport32 : process(clk,ioradd,readoport,oport)
		begin
			if rising_edge(clk) then
				if writeoport = '1' then
					case mwadd(1 downto 0) is
						when "00" => 
							oport(7 downto 0) <= mobus;
						when "01" => 
							oport(15 downto 8) <= mobus;
						when "10" => 
							oport(23 downto 16) <= mobus;
						when "11" => 
							oport(OutputBits-1 downto 24) <= mobus(OutputBits-25 downto 0);
						when others => 
							null;
					end case;	
				end if;	
				if writeoportbuf = '1' then
					case mwadd(1 downto 0) is
						when "00" => 
							oportbuf(7 downto 0) <= mobus;
						when "01" => 
							oportbuf(15 downto 8) <= mobus;
						when "10" => 
							oportbuf(23 downto 16) <= mobus;
						when "11" => 
							oportbuf(OutputBits-1 downto 24) <= mobus(OutputBits-25 downto 0);
						when others => 
							null;
					end case;
				end if;	
				if updatefrombuf = '1' then
					oport <= oportbuf;
				end if;		
			end if;
			iodata <= (others => 'Z');
			if readoport = '1' then
				case ioradd(1 downto 0) is
					when "00" => 
						iodata <= oport(7 downto 0);
					when "01" => 
						iodata <= oport(15 downto 8);
					when "10" => 
						iodata <= oport(23 downto 16);
					when "11" => 
						iodata(OutputBits-25 downto 0) <= oport(OutputBits-1 downto 24);
					when others => 
						null;
				end case;
			end if;	
		end process;		
	end generate;			
		
	onebytein : if (InputBits < 9) and (InputBits > 0) generate
		iport8: process(ibits,clk,readiport, ioradd, readiportbuf, iportbuf)
		begin
			if rising_edge(clk) then
				if sampleinputs = '1' then
					iportbuf <= ibits;
				end if;
			end if;		
			iodata <= (others => 'Z');
			if readiport = '1' then
				iodata(InputBits-1 downto 0) <= ibits;
			end if;
			if readiportbuf = '1' then
				iodata(InputBits-1 downto 0) <= iportbuf;
			end if;	
		end process;
	end generate;
	
	twobytein : if (InputBits >8) and (InputBits < 17) generate
		iport16: process(ibits,clk,readiport, ioradd, readiportbuf, iportbuf)
		begin
			if rising_edge(clk) then
				if sampleinputs = '1' then
					iportbuf <= ibits;
				end if;
			end if;		
			iodata <= (others => 'Z');
			if readiport = '1' then
				case ioradd(0) is
					when '0' =>
						iodata <= ibits(7 downto 0);
					when '1' =>
						iodata(InputBits-9 downto 0) <= ibits(InputBits-1 downto 8);
					when others =>
						null;
				end case;	
			end if;
			if readiportbuf = '1' then
				case ioradd(0) is
					when '0' =>
						iodata <= iportbuf(7 downto 0);
					when '1' =>
						iodata(InputBits-9 downto 0) <= iportbuf(InputBits-1 downto 8);
					when others =>
						null;
				end case;	
			end if;	
		end process;
	end generate;	
	
	threebytein : if (InputBits >16) and (InputBits < 25) generate
		iport24: process(ibits,clk,readiport, ioradd, readiportbuf, iportbuf)
		begin
			if rising_edge(clk) then
				if sampleinputs = '1' then
					iportbuf <= ibits;
				end if;
			end if;		
			iodata <= (others => 'Z');
			if readiport = '1' then
				case ioradd(1 downto 0) is
					when "00" =>
						iodata <= ibits(7 downto 0);
					when "01" =>
						iodata <= ibits(15 downto 8);
					when "10" =>
						iodata(InputBits-17 downto 0) <= ibits(InputBits-1 downto 16);
					when others =>
						null;
				end case;	
			end if;
			if readiportbuf = '1' then
				case ioradd(1 downto 0) is
					when "00" =>
						iodata <= iportbuf(7 downto 0);
					when "01" =>
						iodata <= iportbuf(15 downto 8);
					when "10" =>
						iodata(InputBits-17 downto 0) <= iportbuf(InputBits-1 downto 16);
					when others =>
						null;
				end case;	
			end if;	
		end process;
	end generate;	

	fourbytein : if (InputBits >24) and (InputBits < 33) generate
		iport24: process(ibits,clk,readiport, ioradd, readiportbuf, iportbuf)
		begin
			if rising_edge(clk) then
				if sampleinputs = '1' then
					iportbuf <= ibits;
				end if;
			end if;		
			iodata <= (others => 'Z');
			if readiport = '1' then
				case ioradd(1 downto 0) is
					when "00" =>
						iodata <= ibits(7 downto 0);
					when "01" =>
						iodata <= ibits(15 downto 8);
					when "10" =>
						iodata <= ibits(23 downto 16);
					when "11" =>
						iodata(InputBits-25 downto 0) <= ibits(InputBits-1 downto 24);
					when others =>
						null;
				end case;	
			end if;
			if readiportbuf = '1' then
				case ioradd(1 downto 0) is
					when "00" =>
						iodata <= iportbuf(7 downto 0);
					when "01" =>
						iodata <= iportbuf(15 downto 8);
					when "10" =>
						iodata <= iportbuf(23 downto 16);
					when "11" =>
						iodata(InputBits-25 downto 0) <= iportbuf(InputBits-1 downto 24);
					when others =>
						null;
				end case;	
			end if;	
		end process;
	end generate;	
	
	getclock : process (ioradd,lreadclock)
	begin
		baseclockslv <= conv_std_logic_vector(BaseClock,32);
		iodata <= (others => 'Z');
		if lreadclock = '1' then
			case ioradd(1 downto 0) is
				when "00" => iodata <=  baseclockslv(7 downto 0);
				when "01" => iodata <=  baseclockslv(15 downto 8);
				when "10" => iodata <=  baseclockslv(23 downto 16);
				when "11" => iodata <=  baseclockslv(31 downto 24);
				when others => null;
			end case;
		end if;
	end process;	

	atimer: process(clk,lreadtimerl,lreadtimerh,
	                timeracc, timerlatch,timercount)
	begin
		if rising_edge(clk) then
			if lwritetimerl = '1' then
				timerrate(7 downto 0) <= mobus;
			end if;	
			if lwritetimerh = '1' then
				timerrate(15 downto 8) <= mobus;
			end if;	
			timeracc <= timeracc + timerrate;
			oldtimermsb <= timermsb;
			if lreadtimerl = '1' then
				timerlatch <= timercount(15 downto 8);
			end if;	
			if timermsb = '0' and oldtimermsb = '1' then
				timercount <= timercount +1;
			end if;	
		end if;
		iodata <= (others => 'Z');
		if lreadtimerl = '1' then
			iodata <= timercount(7 downto 0);
		end if;
		if lreadtimerh = '1' then
			iodata <= timerlatch;
		end if;
	end process;					
	
	adoorbell : process (clk,ioradd,doorbellreg)			-- host to ucontroller doorbell (1 bit per interface reg)
	begin																	-- set when host writes interface reg, cleared by ucontroller
		if rising_edge(clk) then
			for i in 0 to InterfaceRegs-1 loop
				if mwadd((log2(InterfaceRegs))+1 downto 2) = i then
					if cleardoorbell = '1' then
						doorbellreg(i) <= '0';
					end if;
				end if;
			end loop;
			for i in 0 to InterfaceRegs-1 loop		-- note priorty of host writes
				if regwaddr = i then
					if hloadregs = '1' then
						doorbellreg(i) <= '1';
					end if;
				end if;
			end loop;		
		end if; -- clk
		iodata <= (others => 'Z');
		for i in 0 to InterfaceRegs-1 loop
			if ioradd((log2(InterfaceRegs))+1 downto 2) = i then
				if readdoorbell = '1' then
					iodata(0) <= doorbellreg(i);
					iodata(7 downto 1) <= (others => '0');
				end if;
			end if;
		end loop;
	end process;
				
						

	
	LocalDecode: process (mwadd,mradd,ioradd,mread,mwrite)
	begin
		writedram				<=	decodedStrobe(mwadd(11 downto 9),"000",mwrite);		-- bottom 512 bytes

		lloadcommand    		<= decodedstrobe(mwadd,x"400",mwrite);
		lreadcommandl    		<= decodedstrobe(ioradd,x"400",mread);
		lreadcommandh    		<= decodedstrobe(ioradd,x"401",mread);
		lloaddata       		<= decodedstrobe(mwadd,x"402",mwrite);
		lreaddata       		<= decodedstrobe(ioradd,x"402",mread);
		

		lsettestbit     		<= decodedstrobe(mwadd,x"420",mwrite);
		lclrtestbit     		<= decodedstrobe(mwadd,x"421",mwrite);
		
		lreadtimerl				<=	decodedstrobe(ioradd,x"422",mread);
		lreadtimerh				<=	decodedstrobe(ioradd,x"423",mread);
		lwritetimerl			<=	decodedstrobe(mwadd,x"422",mwrite);
		lwritetimerh			<=	decodedstrobe(mwadd,x"423",mwrite);

		lreadclock				<=	decodedstrobe(ioradd(11 downto 4),x"43",mread);

		
		lwriteiram       		<= decodedstrobe(mwadd(11 downto 8),x"6",mwrite);		-- 256 bytes max
		lreadiram       		<= decodedstrobe(ioradd(11 downto 8),x"6",mread);
		
		readdoorbell			<= decodedstrobe(ioradd(11 downto 8),x"7",mread);		
		cleardoorbell       	<= decodedstrobe(mwadd(11 downto 8),x"7",mwrite);		-- 256 bytes max

		writeoport				<= decodedstrobe(mwadd(11 downto 4),x"48",mwrite);		
		readoport       		<= decodedstrobe(ioradd(11 downto 4),x"48",mread);
		writeoportbuf			<= decodedstrobe(mwadd(11 downto 4),x"49",mwrite);	
		updatefrombuf			<= decodedstrobe(mwadd(11 downto 4),x"4A",mwrite);	
		
		readiport       		<= decodedstrobe(ioradd(11 downto 4),x"4B",mread);
		readiportbuf       	<= decodedstrobe(ioradd(11 downto 4),x"4C",mread);
		sampleinputs       	<= decodedstrobe(mwadd(11 downto 4),x"4D",mwrite);	


	end process LocalDecode;

	
	looseends: process (oport, ltestbit)
	begin
	 	obits  <= oport;
		testbit <= ltestbit;
	end process looseends;	
	
end Behavioral;

