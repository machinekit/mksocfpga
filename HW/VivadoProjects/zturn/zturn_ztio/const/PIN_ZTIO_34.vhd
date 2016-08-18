library IEEE;
use IEEE.std_logic_1164.all;  -- defines std_logic types
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Copyright (C) 2007, Peter C. Wallace, Mesa Electronics
-- http://www.mesanet.com
--
-- Ported to MYIR ZTURN IO Carrier board: 
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

package PIN_ZTIO_34 is
	constant ModuleID : ModuleIDType :=(
        (HM2DPLLTag,	x"00",	ClockLowTag,	    x"04",	HM2DPLLBaseRateAddr&PadT,	    HM2DPLLNumRegs,		    x"00",	HM2DPLLMPBitMask),
		(WatchDogTag,	x"00",	ClockLowTag,	    x"01",	WatchDogTimeAddr&PadT,		    WatchDogNumRegs,		x"00",	WatchDogMPBitMask),
		(IOPortTag,		x"00",	ClockLowTag,	    x"02",	PortAddr&PadT,					IOPortNumRegs,			x"00",	IOPortMPBitMask),
		(QcountTag,		x"02",	ClockLowTag, 	    x"02",	QcounterAddr&PadT,			    QCounterNumRegs,		x"00",	QCounterMPBitMask),
		(StepGenTag,	x"02",	ClockLowTag,	    x"08",	StepGenRateAddr&PadT,			StepGenNumRegs,		    x"00",	StepGenMPBitMask),
		(FWIDTag,       x"00",  ClockLowTag,    	x"01",  FWIDAddr&PadT,        			FWIDNumRegs,            x"00",  FWIDMPBitMask),
		(PWMTag,		x"00",	ClockHighTag,		x"03",	PWMValAddr&PadT,				PWMNumRegs,				x"00",	PWMMPBitMask),
		(LEDTag,		x"00",	ClockLowTag,		x"01",	LEDAddr&PadT,					LEDNumRegs,				x"00",	LEDMPBitMask),
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
    -- 	Base func  sec unit sec func 	 sec pin			-- hostmot2 Header Pin Func
		IOPortTag & x"00" & NullTag & NullPin,				-- I/O 00	U20 SW  01   input switch GPIO
		IOPortTag & x"00" & NullTag & NullPin,				-- I/O 01	U20 SW  02   input switch GPIO
		IOPortTag & x"00" & NullTag & NullPin,          	-- I/O 02	U20 SW  03   input switch GPIO
		IOPortTag & x"00" & NullTag & NullPin,				-- I/O 03	U20 SW  04   input switch GPIO
		IOPortTag & x"00" & StepGenTag & StepGenDirPin,     -- I/O 04	J6      01	A Dir
		IOPortTag & x"00" & StepGenTag & StepGenStepPin,	-- I/O 05	J6      02	A Step
		IOPortTag & x"01" & StepGenTag & StepGenDirPin, 	-- I/O 06	J6      03	B Dir
		IOPortTag & x"01" & StepGenTag & StepGenStepPin,	-- I/O 07	J6      04	B Step
		IOPortTag & x"02" & StepGenTag & StepGenDirPin,		-- I/O 08	J6      05 	C Dir
		IOPortTag & x"02" & StepGenTag & StepGenStepPin,	-- I/O 09	J6      06	C Step
		IOPortTag & x"03" & StepGenTag & StepGenDirPin,		-- I/O 10	J6      07	D Dir
		IOPortTag & x"03" & StepGenTag & StepGenStepPin,	-- I/O 11	J6      08	D Step
		IOPortTag & x"00" & HM2DPLLTag & HM2DPLLRefOutPin,	-- I/O 12	J5      01	DPLL Ref Output
        IOPortTag & x"00" & QCountTag & QCountQAPin,  		-- I/O 13	J5      02	Input 1 (Quad A)
		IOPortTag & x"00" & QCountTag & QCountQBPin,  		-- I/O 14	J5      03	Input 2 (Quad B)
		IOPortTag & x"00" & QCountTag & QCountIdxPin,    	-- I/O 15	J5      04	Input 3 (Quad Idx)
		IOPortTag & x"00" & NullTag & NullPin,				-- I/O 16	J5      05  GPIO
		
    -- 	Base func  sec unit sec func 	 sec pin			-- hostmot2 Header Pin Func
		IOPortTag & x"00" & PWMTag & PWMAOutPin,			-- I/O 17	J5      06   PWM
		IOPortTag & x"01" & PWMTag & PWMAOutPin,          	-- I/O 18	J5      07   PWM
		IOPortTag & x"02" & PWMTag & PWMAOutPin,			-- I/O 19	J5      08   PWM
		IOPortTag & x"04" & StepGenTag & StepGenDirPin,     -- I/O 20	J3      05	E Dir
		IOPortTag & x"04" & StepGenTag & StepGenStepPin,	-- I/O 21	J3      06	E Step
		IOPortTag & x"05" & StepGenTag & StepGenDirPin,	    -- I/O 22	J3      07	F Dir
		IOPortTag & x"05" & StepGenTag & StepGenStepPin,	-- I/O 23	J3      08	F Step
		IOPortTag & x"06" & StepGenTag & StepGenDirPin,		-- I/O 24	J3      09 	G Dir
		IOPortTag & x"06" & StepGenTag & StepGenStepPin,	-- I/O 25	J3      10	G Step
		IOPortTag & x"07" & StepGenTag & StepGenDirPin,		-- I/O 26	J3      11	H Dir
		IOPortTag & x"07" & StepGenTag & StepGenStepPin,	-- I/O 27	J3      12	H Step
		IOPortTag & x"00" & NullTag & NullPin,	            -- I/O 28	J3      13	GPIO
        IOPortTag & x"01" & QCountTag & QCountQAPin,  		-- I/O 29	J3      14	Input 1 (Quad A)
		IOPortTag & x"01" & QCountTag & QCountQBPin,  		-- I/O 30	J3      15	Input 2 (Quad B)
		IOPortTag & x"01" & QCountTag & QCountIdxPin,    	-- I/O 31	J3      16	Input 3 (Quad Idx)
		IOPortTag & x"00" & NullTag & NullPin,  		    -- I/O 32	J3      17	GPIO
		IOPortTag & x"00" & NullTag & NullPin,   	        -- I/O 33	J3      18	GPIO
		
		-- Fill remaining 144 pins
        emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin, 
		emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,

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
		emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,
		emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin);

end package PIN_ZTIO_34;
