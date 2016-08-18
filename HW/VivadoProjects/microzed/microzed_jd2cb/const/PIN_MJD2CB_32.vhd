library IEEE;
use IEEE.std_logic_1164.all;  -- defines std_logic types
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Copyright (C) 2007, Peter C. Wallace, Mesa Electronics
-- http://www.mesanet.com
--
-- Ported to MicroZED JD2CB board: Copyright (C) 2016, Devin Hughes, JD Squared
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

use work.IDROMConst.all;

package PIN_MJD2CB_32 is
	constant ModuleID : ModuleIDType :=(
                (HM2DPLLTag,	x"00",	ClockLowTag,	x"01",	HM2DPLLBaseRateAddr&PadT,	HM2DPLLNumRegs,		x"00",	HM2DPLLMPBitMask),
		(WatchDogTag,	x"00",	ClockLowTag,	x"01",	WatchDogTimeAddr&PadT,		WatchDogNumRegs,		x"00",	WatchDogMPBitMask),
		(IOPortTag,		x"00",	ClockLowTag,	x"02",	PortAddr&PadT,					IOPortNumRegs,			x"00",	IOPortMPBitMask),
		(StepGenTag,	x"02",	ClockLowTag,	x"04",	StepGenRateAddr&PadT,		StepGenNumRegs,		x"00",	StepGenMPBitMask),
		(FWIDTag,     x"00",  ClockLowTag,    	x"01",  FWIDAddr&PadT,        				FWIDNumRegs,          x"00",  FWIDMPBitMask),
		(NullTag,		x"00",	NullTag,			x"00",	NullAddr&PadT,					x"00",					x"00",	x"00000000"),
		(NullTag,		x"00",	NullTag,			x"00",	NullAddr&PadT,					x"00",					x"00",	x"00000000"),
		(NullTag,		x"00",	NullTag,			x"00",	NullAddr&PadT,					x"00",					x"00",	x"00000000"),
		(NullTag,		x"00",	NullTag,			x"00",	NullAddr&PadT,					x"00",					x"00",	x"00000000"),
		(NullTag,		x"00",	NullTag,			x"00",	NullAddr&PadT,					x"00",					x"00",	x"00000000"),
		(NullTag,		x"00",	NullTag,			x"00",	NullAddr&PadT,					x"00",					x"00",	x"00000000"),
		(NullTag,		x"00",	NullTag,			x"00",	NullAddr&PadT,					x"00",					x"00",	x"00000000"),
		(NullTag,		x"00",	NullTag,			x"00",	NullAddr&PadT,					x"00",					x"00",	x"00000000"),
		(NullTag,		x"00",	NullTag,			x"00",	NullAddr&PadT,					x"00",					x"00",	x"00000000"),
		(NullTag,		x"00",	NullTag,			x"00",	NullAddr&PadT,					x"00",					x"00",	x"00000000"),
		(NullTag,		x"00",	NullTag,			x"00",	NullAddr&PadT,					x"00",					x"00",	x"00000000"),
		(NullTag,		x"00",	NullTag,			x"00",	NullAddr&PadT,					x"00",					x"00",	x"00000000"),
		(NullTag,		x"00",	NullTag,			x"00",	NullAddr&PadT,					x"00",					x"00",	x"00000000"),
		(NullTag,		x"00",	NullTag,			x"00",	NullAddr&PadT,					x"00",					x"00",	x"00000000"),
		(NullTag,		x"00",	NullTag,			x"00",	NullAddr&PadT,					x"00",					x"00",	x"00000000"),
		(NullTag,		x"00",	NullTag,			x"00",	NullAddr&PadT,					x"00",					x"00",	x"00000000"),
		(NullTag,		x"00",	NullTag,			x"00",	NullAddr&PadT,					x"00",					x"00",	x"00000000"),
		(NullTag,		x"00",	NullTag,			x"00",	NullAddr&PadT,					x"00",					x"00",	x"00000000"),
		(NullTag,		x"00",	NullTag,			x"00",	NullAddr&PadT,					x"00",					x"00",	x"00000000"),
		(NullTag,		x"00",	NullTag,			x"00",	NullAddr&PadT,					x"00",					x"00",	x"00000000"),
		(NullTag,		x"00",	NullTag,			x"00",	NullAddr&PadT,					x"00",					x"00",	x"00000000"),
		(NullTag,		x"00",	NullTag,			x"00",	NullAddr&PadT,					x"00",					x"00",	x"00000000"),
		(NullTag,		x"00",	NullTag,			x"00",	NullAddr&PadT,					x"00",					x"00",	x"00000000"),
		(NullTag,		x"00",	NullTag,			x"00",	NullAddr&PadT,					x"00",					x"00",	x"00000000"),
		(NullTag,		x"00",	NullTag,			x"00",	NullAddr&PadT,					x"00",					x"00",	x"00000000"),
		(NullTag,		x"00",	NullTag,			x"00",	NullAddr&PadT,					x"00",					x"00",	x"00000000"),
		(NullTag,		x"00",	NullTag,			x"00",	NullAddr&PadT,					x"00",					x"00",	x"00000000")
		);


	constant PinDesc : PinDescType :=(
-- 	Base func  sec unit sec func 	 sec pin					-- external Conn
	IOPortTag & x"00" & NullTag & NullPin,			-- I/O 00   PIN 36 M1-FB GPIO
	IOPortTag & x"00" & StepGenTag & StepGenStepPin,	-- I/O 01   PIN 38 M1-STP
	IOPortTag & x"00" & StepGenTag & StepGenDirPin,       	-- I/O 02   PIN 42 M1-DIR
	IOPortTag & x"00" & NullTag & NullPin,			-- I/O 03   PIN 44 M1-EN GPIO

        IOPortTag & x"00" & NullTag & NullPin,			-- I/O 04   PIN 48 M2-FB GPIO
        IOPortTag & x"01" & StepGenTag & StepGenStepPin,        -- I/O 05   PIN 50 M2-STP
        IOPortTag & x"01" & StepGenTag & StepGenDirPin,         -- I/O 06   PIN 54 M2-DIR
        IOPortTag & x"00" & NullTag & NullPin,                  -- I/O 07   PIN 56 M2-EN GPIO

        IOPortTag & x"00" & NullTag & NullPin,                  -- I/O 08   PIN 62 M3-FB GPIO
        IOPortTag & x"02" & StepGenTag & StepGenStepPin,        -- I/O 09   PIN 64 M3-STP
        IOPortTag & x"02" & StepGenTag & StepGenDirPin,         -- I/O 10   PIN 68 M3-DIR
        IOPortTag & x"00" & NullTag & NullPin,                  -- I/O 11   PIN 70 M3-EN GPIO

        IOPortTag & x"00" & NullTag & NullPin,                  -- I/O 12   PIN 74 M4-FB GPIO
        IOPortTag & x"03" & StepGenTag & StepGenStepPin,        -- I/O 13   PIN 76 M4-STP
        IOPortTag & x"00" & NullTag & NullPin,                  -- I/O 14   PIN 82 M4-EN GPIO
        IOPortTag & x"03" & StepGenTag & StepGenDirPin,         -- I/O 15   PIN 84 M4-DIR

        IOPortTag & x"00" & NullTag & NullPin,                  -- I/O 16   PIN 35 GPIO

        IOPortTag & x"00" & NullTag & NullPin,                  -- I/O 17   PIN 82-2 LIM1 GPIO
        IOPortTag & x"00" & NullTag & NullPin,                  -- I/O 18   PIN 84-2 LIM2 GPIO
        IOPortTag & x"00" & NullTag & NullPin,                  -- I/O 19   PIN 88-2 LIM3 GPIO
        IOPortTag & x"00" & NullTag & NullPin,                  -- I/O 20   PIN 90-2 LIM4 GPIO

        IOPortTag & x"00" & NullTag & NullPin,                  -- I/O 21   PIN 55-2 Z-PROBE-MC GPIO
        IOPortTag & x"00" & NullTag & NullPin,                  -- I/O 22   PIN 61-2 MOT-POWER GPIO
        IOPortTag & x"00" & NullTag & NullPin,                  -- I/O 23   PIN 63-2 AUXOUT1 GPIO
        IOPortTag & x"00" & NullTag & NullPin,                  -- I/O 24   PIN 67-2 Z-PROBE GPIO
        IOPortTag & x"00" & NullTag & NullPin,                  -- I/O 25   PIN 69-2 AUXIN2 GPIO
        IOPortTag & x"00" & NullTag & NullPin,                  -- I/O 26   PIN 73-2 AUXIN1 GPIO
        IOPortTag & x"00" & NullTag & NullPin,                  -- I/O 27   PIN 75-2 ESTOP GPIO
        IOPortTag & x"00" & NullTag & NullPin,                  -- I/O 28   PIN 83-2 TORCH-BREAK GPIO

        IOPortTag & x"00" & NullTag & NullPin,                  -- I/O 29   PIN 36-2 GPIO
        IOPortTag & x"00" & NullTag & NullPin,                  -- I/O 30   PIN 38-2 GPIO
        IOPortTag & x"00" & NullTag & NullPin,                  -- I/O 31   PIN 42-2 GPIO
        emptypin, emptypin,

		emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin, -- added for 34 pin 5I25
		emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,


		emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin, -- added for IDROM v3
		emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,

		emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,
		emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,
		emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,
		emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,
		emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,
		emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,
		emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,
		emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,
		emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,
		emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin);

end package PIN_MJD2CB_32;
