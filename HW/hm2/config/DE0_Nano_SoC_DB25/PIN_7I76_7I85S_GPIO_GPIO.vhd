library IEEE;
use IEEE.std_logic_1164.all;  -- defines std_logic types
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Copyright (C) 2007, Peter C. Wallace, Mesa Electronics
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

package PIN_7I76_7I85S_GPIO_GPIO is
    constant ModuleID : ModuleIDType :=(
        -- GTag             Version Clock           NumInst BaseAddr                    NumRegisters            Strides MultiRegs
        (HM2DPLLTag,        x"00",  ClockLowTag,    x"01",  HM2DPLLBaseRateAddr&PadT,   HM2DPLLNumRegs,         x"00",  HM2DPLLMPBitMask),
        (WatchDogTag,       x"00",  ClockLowTag,    x"01",  WatchDogTimeAddr&PadT,      WatchDogNumRegs,        x"00",  WatchDogMPBitMask),
        (IOPortTag,         x"00",  ClockLowTag,    x"04",  PortAddr&PadT,              IOPortNumRegs,          x"00",  IOPortMPBitMask),
        (QcountTag,         x"02",  ClockLowTag,    x"01",  QcounterAddr&PadT,          QCounterNumRegs,        x"00",  QCounterMPBitMask),
        (MuxedQcountTag,    MQCRev, ClockLowTag,    x"08",  MuxedQcounterAddr&PadT,     MuxedQCounterNumRegs,   x"00", MuxedQCounterMPBitMask),
        (MuxedQCountSelTag, x"00",  ClockLowTag,    x"01",  NullAddr&PadT,              x"00",                  x"00",  x"00000000"),
        (SSerialTag,        x"00",  ClockLowTag,    x"03",  SSerialCommandAddr&PadT,    SSerialNumRegs,         x"10",  SSerialMPBitMask),
        (StepGenTag,        x"02",  ClockLowTag,    x"0D",  StepGenRateAddr&PadT,       StepGenNumRegs,         x"00",  StepGenMPBitMask),
        (LEDTag,            x"00",  ClockLowTag,    x"01",  LEDAddr&PadT,               LEDNumRegs,             x"00",  LEDMPBitMask),
        (FWIDTag,           x"00",  ClockLowTag,    x"01",  FWIDAddr&PadT,              FWIDNumRegs,            x"00",  FWIDMPBitMask),
        (NullTag,           x"00",  NullTag,        x"00",  NullAddr&PadT,              x"00",                  x"00",  x"00000000"),
        (NullTag,           x"00",  NullTag,        x"00",  NullAddr&PadT,              x"00",                  x"00",  x"00000000"),
        (NullTag,           x"00",  NullTag,        x"00",  NullAddr&PadT,              x"00",                  x"00",  x"00000000"),
        (NullTag,           x"00",  NullTag,        x"00",  NullAddr&PadT,              x"00",                  x"00",  x"00000000"),
        (NullTag,           x"00",  NullTag,        x"00",  NullAddr&PadT,              x"00",                  x"00",  x"00000000"),
        (NullTag,           x"00",  NullTag,        x"00",  NullAddr&PadT,              x"00",                  x"00",  x"00000000"),
        (NullTag,           x"00",  NullTag,        x"00",  NullAddr&PadT,              x"00",                  x"00",  x"00000000"),
        (NullTag,           x"00",  NullTag,        x"00",  NullAddr&PadT,              x"00",                  x"00",  x"00000000"),
        (NullTag,           x"00",  NullTag,        x"00",  NullAddr&PadT,              x"00",                  x"00",  x"00000000"),
        (NullTag,           x"00",  NullTag,        x"00",  NullAddr&PadT,              x"00",                  x"00",  x"00000000"),
        (NullTag,           x"00",  NullTag,        x"00",  NullAddr&PadT,              x"00",                  x"00",  x"00000000"),
        (NullTag,           x"00",  NullTag,        x"00",  NullAddr&PadT,              x"00",                  x"00",  x"00000000"),
        (NullTag,           x"00",  NullTag,        x"00",  NullAddr&PadT,              x"00",                  x"00",  x"00000000"),
        (NullTag,           x"00",  NullTag,        x"00",  NullAddr&PadT,              x"00",                  x"00",  x"00000000"),
        (NullTag,           x"00",  NullTag,        x"00",  NullAddr&PadT,              x"00",                  x"00",  x"00000000"),
        (NullTag,           x"00",  NullTag,        x"00",  NullAddr&PadT,              x"00",                  x"00",  x"00000000"),
        (NullTag,           x"00",  NullTag,        x"00",  NullAddr&PadT,              x"00",                  x"00",  x"00000000"),
        (NullTag,           x"00",  NullTag,        x"00",  NullAddr&PadT,              x"00",                  x"00",  x"00000000"),
        (NullTag,           x"00",  NullTag,        x"00",  NullAddr&PadT,              x"00",                  x"00",  x"00000000"),
        (NullTag,           x"00",  NullTag,        x"00",  NullAddr&PadT,              x"00",                  x"00",  x"00000000"),
        (NullTag,           x"00",  NullTag,        x"00",  NullAddr&PadT,              x"00",                  x"00",  x"00000000"),
        (NullTag,           x"00",  NullTag,        x"00",  NullAddr&PadT,              x"00",                  x"00",  x"00000000")
        );


    constant PinDesc : PinDescType :=(
--      Base       Sec      Sec       Sec
--      func       unit     func      pin                           -- hostmot2 DE0-Nano    DB25-P2
        IOPortTag & x"00" & StepGenTag & StepGenDirPin,             -- I/O 00   GPIO_0 16   PIN 1
        IOPortTag & x"00" & StepGenTag & StepGenStepPin,            -- I/O 01   GPIO_0 17   PIN 14
        IOPortTag & x"01" & StepGenTag & StepGenDirPin,             -- I/O 02   GPIO_0 14   PIN 2
        IOPortTag & x"01" & StepGenTag & StepGenStepPin,            -- I/O 03   GPIO_0 15   PIN 15
        IOPortTag & x"02" & StepGenTag & StepGenDirPin,             -- I/O 04   GPIO_0 12   PIN 3
        IOPortTag & x"02" & StepGenTag & StepGenStepPin,            -- I/O 05   GPIO_0 13   PIN 16
        IOPortTag & x"03" & StepGenTag & StepGenDirPin,             -- I/O 06   GPIO_0 10   PIN 4
        IOPortTag & x"03" & StepGenTag & StepGenStepPin,            -- I/O 07   GPIO_0 11   PIN 17
        IOPortTag & x"04" & StepGenTag & StepGenDirPin,             -- I/O 08   GPIO_0 08   PIN 5
        IOPortTag & x"04" & StepGenTag & StepGenStepPin,            -- I/O 09   GPIO_0 09   PIN 6
        IOPortTag & x"00" & SSerialTag & SSerialTX0Pin,             -- I/O 10   GPIO_0 06   PIN 7
        IOPortTag & x"00" & SSerialTag & SSerialRX0Pin,             -- I/O 11   GPIO_0 07   PIN 8
        IOPortTag & x"00" & SSerialTag & SSerialTX1Pin,             -- I/O 12   GPIO_0 04   PIN 9
        IOPortTag & x"00" & SSerialTag & SSerialRX1Pin,             -- I/O 13   GPIO_0 05   PIN 10
        IOPortTag & x"00" & QCountTag & x"03",                      -- I/O 14   GPIO_0 02   PIN 11
        IOPortTag & x"00" & QCountTag & x"02",                      -- I/O 15   GPIO_0 03   PIN 12
        IOPortTag & x"00" & QCountTag & x"01",                      -- I/O 16   GPIO_0 00   PIN 13
                                                                    --          GPIO_0 01           LED0

--      Base       Sec      Sec       Sec
--      func       unit     func      pin                           -- I/O 17   GPIO_0 34   PIN 1
        IOPortTag & x"00" & SSerialTag & SSerialRX2Pin,             -- I/O 18   GPIO_0 35   PIN 14
        IOPortTag & x"00" & SSerialTag & SSerialTX2Pin,             -- I/O 19   GPIO_0 32   PIN 2
        IOPortTag & x"08" & StepGenTag & StepGenStepPin,            -- I/O 20   GPIO_0 33   PIN 15
        IOPortTag & x"08" & StepGenTag & StepGenDirPin,             -- I/O 21   GPIO_0 30   PIN 3
        IOPortTag & x"07" & StepGenTag & StepGenStepPin,            -- I/O 22   GPIO_0 31   PIN 16
        IOPortTag & x"07" & StepGenTag & StepGenDirPin,             -- I/O 23   GPIO_0 28   PIN 4
        IOPortTag & x"06" & StepGenTag & StepGenStepPin,            -- I/O 24   GPIO_0 29   PIN 17
        IOPortTag & x"06" & StepGenTag & StepGenDirPin,             -- I/O 25   GPIO_0 26   PIN 5
        IOPortTag & x"05" & StepGenTag & StepGenStepPin,            -- I/O 26   GPIO_0 27   PIN 6
        IOPortTag & x"05" & StepGenTag & StepGenDirPin,             -- I/O 27   GPIO_0 24   PIN 7
        IOPortTag & x"00" & MuxedQCountSelTag & MuxedQCountSel0Pin, -- I/O 28   GPIO_0 25   PIN 8
        IOPortTag & x"00" & MuxedQCountTag & MuxedQCountQAPin,      -- I/O 29   GPIO_0 22   PIN 9
        IOPortTag & x"00" & MuxedQCountTag & MuxedQCountQBPin,      -- I/O 30   GPIO_0 23   PIN 10
        IOPortTag & x"00" & MuxedQCountTag & MuxedQCountIDXPin,     -- I/O 31   GPIO_0 20   PIN 11
        IOPortTag & x"01" & MuxedQCountTag & MuxedQCountQAPin,      -- I/O 32   GPIO_0 21   PIN 12
        IOPortTag & x"01" & MuxedQCountTag & MuxedQCountQBPin,      -- I/O 33   GPIO_0 18   PIN 13
        IOPortTag & x"01" & MuxedQCountTag & MuxedQCountIDXPin,     --          GPIO_0 19           LED1

--      Base       Sec      Sec       Sec
--      func       unit     func      pin                           -- hostmot2 DE0-Nano    DB25-P2
        IOPortTag & x"00" & NullTag & x"00",                        -- I/O 34   GPIO_1 16   PIN 1
        IOPortTag & x"00" & NullTag & x"00",                        -- I/O 35   GPIO_1 17   PIN 14
        IOPortTag & x"00" & NullTag & x"00",                        -- I/O 36   GPIO_1 14   PIN 2
        IOPortTag & x"00" & NullTag & x"00",                        -- I/O 37   GPIO_1 15   PIN 15
        IOPortTag & x"00" & NullTag & x"00",                        -- I/O 38   GPIO_1 12   PIN 3
        IOPortTag & x"00" & NullTag & x"00",                        -- I/O 39   GPIO_1 13   PIN 16
        IOPortTag & x"00" & NullTag & x"00",                        -- I/O 40   GPIO_1 10   PIN 4
        IOPortTag & x"00" & NullTag & x"00",                        -- I/O 41   GPIO_1 11   PIN 17
        IOPortTag & x"00" & NullTag & x"00",                        -- I/O 42   GPIO_1 08   PIN 5
        IOPortTag & x"00" & NullTag & x"00",                        -- I/O 43   GPIO_1 09   PIN 6
        IOPortTag & x"00" & NullTag & x"00",                        -- I/O 44   GPIO_1 06   PIN 7
        IOPortTag & x"00" & NullTag & x"00",                        -- I/O 45   GPIO_1 07   PIN 8
        IOPortTag & x"00" & NullTag & x"00",                        -- I/O 46   GPIO_1 04   PIN 9
        IOPortTag & x"00" & NullTag & x"00",                        -- I/O 47   GPIO_1 05   PIN 10
        IOPortTag & x"00" & NullTag & x"00",                        -- I/O 48   GPIO_1 02   PIN 11
        IOPortTag & x"00" & NullTag & x"00",                        -- I/O 49   GPIO_1 03   PIN 12
        IOPortTag & x"00" & NullTag & x"00",                        -- I/O 50   GPIO_1 00   PIN 13
                                                                    --          GPIO_1 01           LED2

--      Base       Sec      Sec       Sec
--      func       unit     func      pin                           -- hostmot2 DE0-Nano    DB25-P3
        IOPortTag & x"00" & NullTag & x"00",                        -- I/O 51   GPIO_1 34   PIN 1
        IOPortTag & x"00" & NullTag & x"00",                        -- I/O 52   GPIO_1 35   PIN 14
        IOPortTag & x"00" & NullTag & x"00",                        -- I/O 53   GPIO_1 32   PIN 2
        IOPortTag & x"00" & NullTag & x"00",                        -- I/O 54   GPIO_1 33   PIN 15
        IOPortTag & x"00" & NullTag & x"00",                        -- I/O 55   GPIO_1 30   PIN 3
        IOPortTag & x"00" & NullTag & x"00",                        -- I/O 56   GPIO_1 31   PIN 16
        IOPortTag & x"00" & NullTag & x"00",                        -- I/O 57   GPIO_1 28   PIN 4
        IOPortTag & x"00" & NullTag & x"00",                        -- I/O 58   GPIO_1 29   PIN 17
        IOPortTag & x"00" & NullTag & x"00",                        -- I/O 59   GPIO_1 26   PIN 5
        IOPortTag & x"00" & NullTag & x"00",                        -- I/O 60   GPIO_1 27   PIN 6
        IOPortTag & x"00" & NullTag & x"00",                        -- I/O 61   GPIO_1 24   PIN 7
        IOPortTag & x"00" & NullTag & x"00",                        -- I/O 62   GPIO_1 25   PIN 8
        IOPortTag & x"00" & NullTag & x"00",                        -- I/O 63   GPIO_1 22   PIN 9
        IOPortTag & x"00" & NullTag & x"00",                        -- I/O 64   GPIO_1 23   PIN 10
        IOPortTag & x"00" & NullTag & x"00",                        -- I/O 65   GPIO_1 20   PIN 11
        IOPortTag & x"00" & NullTag & x"00",                        -- I/O 66   GPIO_1 21   PIN 12
        IOPortTag & x"00" & NullTag & x"00",                        -- I/O 67   GPIO_1 18   PIN 13
                                                                    --          GPIO_1 19           LED3

        -- Remainder of 144 pin descriptors are unused
        emptypin,emptypin,emptypin,emptypin,
        emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,
        emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,
        emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,
        emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,
        emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,
        emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,
        emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,
        emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,
        emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin);

end package PIN_7I76_7I85S_GPIO_GPIO;
