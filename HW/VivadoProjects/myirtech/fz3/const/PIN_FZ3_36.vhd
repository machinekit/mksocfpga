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

package PIN_FZ3_36 is
    constant ModuleID : ModuleIDType :=(
        (HM2DPLLTag,    x"00",  ClockLowTag,        x"04",  HM2DPLLBaseRateAddr&PadT,       HM2DPLLNumRegs,         x"00",  HM2DPLLMPBitMask),
        (IOPortTag,     x"00",  ClockLowTag,        x"02",  PortAddr&PadT,                  IOPortNumRegs,          x"00",  IOPortMPBitMask),
        (QcountTag,     x"02",  ClockLowTag,        x"02",  QcounterAddr&PadT,              QCounterNumRegs,        x"00",  QCounterMPBitMask),
        (StepGenTag,    x"02",  ClockLowTag,        x"08",  StepGenRateAddr&PadT,           StepGenNumRegs,         x"00",  StepGenMPBitMask),
        (FWIDTag,       x"00",  ClockLowTag,        x"01",  FWIDAddr&PadT,                  FWIDNumRegs,            x"00",  FWIDMPBitMask),
        (PWMTag,        x"00",  ClockHighTag,       x"03",  PWMValAddr&PadT,                PWMNumRegs,             x"00",  PWMMPBitMask),
        (LEDTag,        x"00",  ClockLowTag,        x"01",  LEDAddr&PadT,                   LEDNumRegs,             x"00",  LEDMPBitMask),
        (NullTag,       x"00",  NullTag,            x"00",  NullAddr&PadT,                  x"00",                  x"00",  x"00000000"),
        (NullTag,       x"00",  NullTag,            x"00",  NullAddr&PadT,                  x"00",                  x"00",  x"00000000"),
        (NullTag,       x"00",  NullTag,            x"00",  NullAddr&PadT,                  x"00",                  x"00",  x"00000000"),
        (NullTag,       x"00",  NullTag,            x"00",  NullAddr&PadT,                  x"00",                  x"00",  x"00000000"),
        (NullTag,       x"00",  NullTag,            x"00",  NullAddr&PadT,                  x"00",                  x"00",  x"00000000"),
        (NullTag,       x"00",  NullTag,            x"00",  NullAddr&PadT,                  x"00",                  x"00",  x"00000000"),
        (NullTag,       x"00",  NullTag,            x"00",  NullAddr&PadT,                  x"00",                  x"00",  x"00000000"),
        (NullTag,       x"00",  NullTag,            x"00",  NullAddr&PadT,                  x"00",                  x"00",  x"00000000"),
        (NullTag,       x"00",  NullTag,            x"00",  NullAddr&PadT,                  x"00",                  x"00",  x"00000000"),
        (NullTag,       x"00",  NullTag,            x"00",  NullAddr&PadT,                  x"00",                  x"00",  x"00000000"),
        (NullTag,       x"00",  NullTag,            x"00",  NullAddr&PadT,                  x"00",                  x"00",  x"00000000"),
        (NullTag,       x"00",  NullTag,            x"00",  NullAddr&PadT,                  x"00",                  x"00",  x"00000000"),
        (NullTag,       x"00",  NullTag,            x"00",  NullAddr&PadT,                  x"00",                  x"00",  x"00000000"),
        (NullTag,       x"00",  NullTag,            x"00",  NullAddr&PadT,                  x"00",                  x"00",  x"00000000"),
        (NullTag,       x"00",  NullTag,            x"00",  NullAddr&PadT,                  x"00",                  x"00",  x"00000000"),
        (NullTag,       x"00",  NullTag,            x"00",  NullAddr&PadT,                  x"00",                  x"00",  x"00000000"),
        (NullTag,       x"00",  NullTag,            x"00",  NullAddr&PadT,                  x"00",                  x"00",  x"00000000"),
        (NullTag,       x"00",  NullTag,            x"00",  NullAddr&PadT,                  x"00",                  x"00",  x"00000000"),
        (NullTag,       x"00",  NullTag,            x"00",  NullAddr&PadT,                  x"00",                  x"00",  x"00000000"),
        (NullTag,       x"00",  NullTag,            x"00",  NullAddr&PadT,                  x"00",                  x"00",  x"00000000"),
        (NullTag,       x"00",  NullTag,            x"00",  NullAddr&PadT,                  x"00",                  x"00",  x"00000000"),
        (NullTag,       x"00",  NullTag,            x"00",  NullAddr&PadT,                  x"00",                  x"00",  x"00000000"),
        (NullTag,       x"00",  NullTag,            x"00",  NullAddr&PadT,                  x"00",                  x"00",  x"00000000"),
        (NullTag,       x"00",  NullTag,            x"00",  NullAddr&PadT,                  x"00",                  x"00",  x"00000000"),
        (NullTag,       x"00",  NullTag,            x"00",  NullAddr&PadT,                  x"00",                  x"00",  x"00000000")
        );


    constant PinDesc : PinDescType :=(
    --     Base func  sec unit sec func      sec pin            -- hostmot2 Header       Pin     Func   HD = 3V3, SD = 1V8
        IOPortTag & x"00" & NullTag & NullPin,                  -- I/O 00    HD_GPIO0_0  J15_11  GPIO
        IOPortTag & x"00" & NullTag & NullPin,                  -- I/O 01    HD_GPIO0_1  J15_12  GPIO
        IOPortTag & x"00" & NullTag & NullPin,                  -- I/O 02    HD_GPIO0_2  J15_13  GPIO
        IOPortTag & x"00" & NullTag & NullPin,                  -- I/O 03    HD_GPIO0_3  J15_14  GPIO
        IOPortTag & x"00" & StepGenTag & StepGenDirPin,         -- I/O 04    HD_GPIO0_4  J15_15  A Dir
        IOPortTag & x"00" & StepGenTag & StepGenStepPin,        -- I/O 05    HD_GPIO0_5  J15_16  A Step
        IOPortTag & x"01" & StepGenTag & StepGenDirPin,         -- I/O 06    HD_GPIO0_6  J15_17  B Dir
        IOPortTag & x"01" & StepGenTag & StepGenStepPin,        -- I/O 07    HD_GPIO0_7  J15_18  B Step
        IOPortTag & x"02" & StepGenTag & StepGenDirPin,         -- I/O 08    HD_GPIO0_8  J16_21  C Dir
        IOPortTag & x"02" & StepGenTag & StepGenStepPin,        -- I/O 09    HD_GPIO0_9  J16_22  C Step
        IOPortTag & x"03" & StepGenTag & StepGenDirPin,         -- I/O 10    HD_GPIO0_10 J16_23  D Dir
        IOPortTag & x"03" & StepGenTag & StepGenStepPin,        -- I/O 11    HD_GPIO0_11 J16_24  D Step
        IOPortTag & x"00" & HM2DPLLTag & HM2DPLLRefOutPin,      -- I/O 12    HD_GPIO0_12 J16_25  DPLL Ref Output
        IOPortTag & x"00" & QCountTag & QCountQAPin,            -- I/O 13    HD_GPIO0_14 J16_26  Input 1 (Quad A)
        IOPortTag & x"00" & QCountTag & QCountQBPin,            -- I/O 14    HD_GPIO0_14 J16_27  Input 2 (Quad B)
        IOPortTag & x"00" & QCountTag & QCountIdxPin,           -- I/O 15    HD_GPIO0_15 J16_28  Input 3 (Quad Idx)

    --     Base func  sec unit sec func      sec pin            -- hostmot2 Header        Pin    Func
        IOPortTag & x"00" & NullTag & NullPin,                  -- I/O 16    HD_GPIO0_16 J16_31  GPIO        
        IOPortTag & x"00" & PWMTag & PWMAOutPin,                -- I/O 17    HD_GPIO0_17 J16_32  PWM
        IOPortTag & x"01" & PWMTag & PWMAOutPin,                -- I/O 18    HD_GPIO0_18 J16_33  PWM
        IOPortTag & x"02" & PWMTag & PWMAOutPin,                -- I/O 19    HD_GPIO0_19 J16_34  PWM
        IOPortTag & x"04" & StepGenTag & StepGenDirPin,         -- I/O 20    HD_GPIO0_20 J16_35  E Dir
        IOPortTag & x"04" & StepGenTag & StepGenStepPin,        -- I/O 21    HD_GPIO0_21 J16_36  E Step
        IOPortTag & x"05" & StepGenTag & StepGenDirPin,         -- I/O 22    HD_GPIO0_22 J16_37  F Dir
        IOPortTag & x"05" & StepGenTag & StepGenStepPin,        -- I/O 23    HD_GPIO0_23 J16_38  F Step
        IOPortTag & x"06" & StepGenTag & StepGenDirPin,         -- I/O 24    SD_GPIO0_24 J15_21  G Dir
        IOPortTag & x"06" & StepGenTag & StepGenStepPin,        -- I/O 25    SD_GPIO0_25 J15_22  G Step
        IOPortTag & x"07" & StepGenTag & StepGenDirPin,         -- I/O 26    SD_GPIO0_26 J15_23  H Dir
        IOPortTag & x"07" & StepGenTag & StepGenStepPin,        -- I/O 27    SD_GPIO0_27 J15_24  H Step
        IOPortTag & x"00" & NullTag & NullPin,                  -- I/O 28    SD_GPIO0_28 J15_25  GPIO
        IOPortTag & x"00" & NullTag & NullPin,                  -- I/O 29    SD_GPIO0_29 J15_26  GPIO
        IOPortTag & x"00" & NullTag & NullPin,                  -- I/O 30    SD_GPIO0_30 J15_27  GPIO
        IOPortTag & x"00" & NullTag & NullPin,                  -- I/O 31    SD_GPIO0_31 J15_28  GPIO
        IOPortTag & x"00" & NullTag & NullPin,                  -- I/O 32    SD_GPIO0_32 J15_31  GPIO
        IOPortTag & x"01" & QCountTag & QCountQAPin,            -- I/O 33    SD_GPIO0_33 J15_32  Input 1 (Quad A)
        IOPortTag & x"01" & QCountTag & QCountQBPin,            -- I/O 34    SD_GPIO0_34 J15_33  Input 2 (Quad B)
        IOPortTag & x"01" & QCountTag & QCountIdxPin,           -- I/O 35    SD_GPIO0_35 J15_34  Input 3 (Quad Idx)
        
        -- Fill remaining 144 pins
        emptypin,emptypin,emptypin,emptypin,
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
        emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,
        emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin);

end package PIN_FZ3_36;
