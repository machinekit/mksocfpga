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
--     are met=>
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

library ieee;
use ieee.STD_LOGIC_1164.all;
use ieee.numeric_std.all;

library STD;
use STD.textio.all;

entity firmware_id is
  generic(
    ADDR_WIDTH : integer := 9;
    DATA_WIDTH : integer := 32
  );
  port (
    clk     : in  std_logic;
    re      : in  std_logic;
    radd    : in  std_logic_vector(ADDR_WIDTH - 1 downto 0);
    dout    : out std_logic_vector(DATA_WIDTH - 1 downto 0)
  );
end firmware_id;

architecture beh of firmware_id is
  attribute rom_style : string;
  type mem_type is array ( (2**ADDR_WIDTH) - 1 downto 0 ) of std_logic_vector(DATA_WIDTH - 1 downto 0);
  signal rom_data : std_logic_vector(DATA_WIDTH - 1 downto 0);
  signal rom_addr : std_logic_vector(ADDR_WIDTH - 1 downto 0);

  impure function hx_to_int(c : character) return integer is
    variable res : integer := 0;
  begin
        if(c = '1') then
          res := 1;
        elsif (c = '2') then
          res := 2;
        elsif (c = '3') then
          res := 3;
        elsif (c = '4') then
          res := 4;
        elsif (c = '5') then
          res := 5;
        elsif (c = '6') then
          res := 6;
        elsif (c = '7') then
          res := 7;
        elsif (c = '8') then
          res := 8;
        elsif (c = '9') then
          res := 9;
        elsif (c = 'A' or c = 'a') then
          res := 10;
        elsif (c = 'B' or c = 'b') then
          res := 11;
        elsif (c = 'C' or c = 'c') then
          res := 12;
        elsif (c = 'D' or c = 'd') then
          res := 13;
        elsif (c = 'E' or c = 'e') then
          res := 14;
        elsif (c = 'F' or c = 'f') then
          res := 15;
        else
          res := 0;
        end if;
        return res;
  end function;

  impure function hxstr_to_stdvec(s : string) return std_logic_vector is
    variable res : std_logic_vector(DATA_WIDTH - 1 downto 0) := (others => '0');
    variable place : integer := 0;
  begin
      -- The string is a hex number with only whitespace around it
      for i in s'range loop
        if (s(i) = ' ') then
          exit;
        else
          res := res(27 downto 0) & std_logic_vector(to_unsigned(hx_to_int(s(i)), 4));
        end if;
      end loop;     
      return res;
  end function;

  impure function parse_add(s : string) return std_logic_vector is
    variable res : std_logic_vector(DATA_WIDTH - 1 downto 0) := (others => '0');
    variable add_s : string(s'range);
  begin
    -- Clear the address value string
    for j in add_s'range loop
      add_s(j) := ' ';
    end loop;

    -- Address is before the ':'
    for j in s'range loop
      if(s(j) = ':') then
        exit;
      else
        add_s(j) := s(j);
      end if;
    end loop;

    res := hxstr_to_stdvec(add_s);
    return res;
  end function;

  impure function parse_data(s : string) return std_logic_vector is
    variable res : std_logic_vector(DATA_WIDTH - 1 downto 0) := (others => '0');
    variable dat_s : string(s'range);
    variable indata : boolean := false;
    variable i : integer := 1;
  begin
    -- Clear the address value string
    for j in dat_s'range loop
      dat_s(j) := ' ';
    end loop;

    -- Data is after the ':'
    for j in s'range loop
      if(indata = true) then
        if(s(j) = ' ') then
          exit;
        else
          dat_s(i) := s(j);
          i := i + 1;
        end if;
      elsif(s(j) = ':') then
        indata := true;
        next;
      end if;
    end loop;
    res := hxstr_to_stdvec(dat_s);
    return res;
  end function;

  -- This removes all whitespace from the current line
  function strip_ws(s : string) return string is
    variable res : string (s'range);
    variable i : positive := 1;
  begin
    -- Initialize the result string
    for j in res'range loop
      res(j) := ' ';
    end loop;

    -- Loop over the string and copy the data
    for j in s'range loop
      if (s(j) = ';') then
        exit;
      elsif (s(j) /= ' ' and s(j) /= HT and s(j) /= CR and s(j) /= LF and s(j) /= VT) then
        res(i) := s(j);
        i := i + 1;
      end if;
    end loop;
    return res;
  end function;
  
  impure function InitFromFile (fname : string) return mem_type is
    file infile : text open read_mode is fname;
    variable curLine : line;
    variable lineContent : string (1 to 50);
    variable linenows : string (lineContent'range);
    variable tmpint : integer;
    variable depth : integer;
    variable incont : boolean := false;
    variable add : std_logic_vector(ADDR_WIDTH - 1 downto 0);
    variable dat : std_logic_vector(DATA_WIDTH - 1 downto 0);
    variable c : character;
    variable eof_n : boolean;
    variable sing_com : boolean := false;
    variable inmulti : boolean := false;

    -- Initialize everything to zero's. Then overwrite from the mif
    variable romd : mem_type; -- := (others => (others => '0'));
  begin    
    while not endfile(infile) loop
      -- Read the new line
      readline(infile, curLine);
      sing_com := false;
      
      -- When this is in procedure, Vivado won't synthesize...
      -- Read an entire line into a string
      for i in lineContent'range loop
        lineContent(i) := ' ';
      end loop;   

      for i in lineContent'range loop
        read(curLine, c, eof_n);
        if(inmulti = false) then
            if (c = '-') then
                if(sing_com = true) then
                    lineContent(i - 1) := ' ';
                    exit;
                else
                    sing_com := true;
                end if;
            elsif (c = '%') then
                inmulti := true;
                next;
            else
                sing_com := false;    
            end if; 
            
            -- End of command?
            if (c = ';') then
                exit;
            end if;
            
            lineContent(i) := c;
        else
            if( c = '%') then
                inmulti := false;
            end if;
        end if;
        if not eof_n then
          exit;
        end if;   
      end loop;  
   
      -- Strip out the whitespace
      linenows := strip_ws(lineContent);
      -- Now parse the string
      if (incont = true) then
        if (linenows(1 to 3) = "END") then
          incont := false;
        else
          -- Data line to be read. Format is
          -- Address:Data in the radix specified (hex only)
          add := parse_add(linenows)(ADDR_WIDTH - 1 downto 0);
          dat := parse_data(linenows);
          romd(to_integer(unsigned(add))) := dat;
        end if;
      else
        if (linenows(1) = ' ') then
          next;
        elsif (linenows(1 to 6) = "WIDTH=") then
            next;
          --Doesn't synthesize in Vivado
          --tmpint := integer'value(linenows(7 to linenows'right));
          --assert (tmpint = DATA_WIDTH)
          -- report "Data width incorrect: " & integer'image(tmpint)
          --  severity failure; 
        elsif (linenows(1 to 6) = "DEPTH=") then
          next;
          --depth := integer'value(linenows(7 to linenows'high));
        elsif (linenows(1 to 14) = "ADDRESS_RADIX=") then
          assert linenows(15 to 17) = "HEX"
            report "ADDRESS_RADIX is not HEX. Found: " & linenows(15 to 17)
            severity failure;
        elsif (linenows(1 to 11) = "DATA_RADIX=") then
          assert linenows(12 to 14) = "HEX"
            report "DATA_RADIX is not HEX. Found: " & linenows(12 to 14)
            severity failure;
        elsif (linenows(1 to 12) = "CONTENTBEGIN") then
          incont := true;
        end if;
      end if;
    end loop;
    return romd;
  end function;

  signal buf : mem_type := InitFromFile("firmware_id.mif");
  attribute rom_style of buf : signal is "block";
begin
  dout <= rom_data when (re = '1') else (others=>'Z');

  process(clk)
  begin
    if(rising_edge(clk)) then
      rom_data <= buf(to_integer(unsigned(radd)));
    end if;
  end process;

end beh;
