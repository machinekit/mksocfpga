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

package Pintypes is
    constant ModuleID : ModuleIDType :=(
    -- GTag             Version Clock           NumInst BaseAddr                    NumRegisters        Strides MultiRegs
        (HM2DPLLTag,    x"00",  ClockLowTag,    x"01",  HM2DPLLBaseRateAddr&PadT,   HM2DPLLNumRegs,     x"00",  HM2DPLLMPBitMask),
        (WatchDogTag,   x"00",  ClockLowTag,    x"01",  WatchDogTimeAddr&PadT,      WatchDogNumRegs,    x"00",  WatchDogMPBitMask),
        (IOPortTag,     x"00",  ClockLowTag,    x"03",  PortAddr&PadT,              IOPortNumRegs,      x"00",  IOPortMPBitMask),
        (QcountTag,     x"02",  ClockLowTag,    x"02",  QcounterAddr&PadT,          QCounterNumRegs,    x"00",  QCounterMPBitMask),
        (StepGenTag,    x"02",  ClockLowTag,    x"0A",  StepGenRateAddr&PadT,       StepGenNumRegs,     x"00",  StepGenMPBitMask),
        (PWMTag,        x"00",  ClockHighTag,   x"06",  PWMValAddr&PadT,            PWMNumRegs,         x"00",  PWMMPBitMask),
        (LEDTag,        x"00",  ClockLowTag,    x"01",  LEDAddr&PadT,               LEDNumRegs,         x"00",  LEDMPBitMask),
        (NANOADCTag,    x"00",  ClockLowTag,    x"08",  NANOADCAddr&PadT,           NANOADCNumRegs,     x"00",  NANOADCBitMask),
        (CAPSENSETag,   x"00",  ClockLowTag,    x"04",  CAPSENSEAddr&PadT,          CAPSENSENumRegs,    x"00",  CAPSENSEBitMask),
        (BSPITag,       x"00",  ClockLowTag,    x"02",  BSPIDataAddr&PadT,          BSPINumRegs,        x"11",  BSPIMPBitMask),
        (FWIDTag,       x"00",  ClockLowTag,    x"01",  FWIDAddr&PadT,              FWIDNumRegs,        x"00",  FWIDMPBitMask),
        (NullTag,       x"00",  NullTag,        x"00",  NullAddr&PadT,              x"00",              x"00",  x"00000000"),
        (NullTag,       x"00",  NullTag,        x"00",  NullAddr&PadT,              x"00",              x"00",  x"00000000"),
        (NullTag,       x"00",  NullTag,        x"00",  NullAddr&PadT,              x"00",              x"00",  x"00000000"),
        (NullTag,       x"00",  NullTag,        x"00",  NullAddr&PadT,              x"00",              x"00",  x"00000000"),
        (NullTag,       x"00",  NullTag,        x"00",  NullAddr&PadT,              x"00",              x"00",  x"00000000"),
        (NullTag,       x"00",  NullTag,        x"00",  NullAddr&PadT,              x"00",              x"00",  x"00000000"),
        (NullTag,       x"00",  NullTag,        x"00",  NullAddr&PadT,              x"00",              x"00",  x"00000000"),
        (NullTag,       x"00",  NullTag,        x"00",  NullAddr&PadT,              x"00",              x"00",  x"00000000"),
        (NullTag,       x"00",  NullTag,        x"00",  NullAddr&PadT,              x"00",              x"00",  x"00000000"),
        (NullTag,       x"00",  NullTag,        x"00",  NullAddr&PadT,              x"00",              x"00",  x"00000000"),
        (NullTag,       x"00",  NullTag,        x"00",  NullAddr&PadT,              x"00",              x"00",  x"00000000"),
        (NullTag,       x"00",  NullTag,        x"00",  NullAddr&PadT,              x"00",              x"00",  x"00000000"),
        (NullTag,       x"00",  NullTag,        x"00",  NullAddr&PadT,              x"00",              x"00",  x"00000000"),
        (NullTag,       x"00",  NullTag,        x"00",  NullAddr&PadT,              x"00",              x"00",  x"00000000"),
        (NullTag,       x"00",  NullTag,        x"00",  NullAddr&PadT,              x"00",              x"00",  x"00000000"),
        (NullTag,       x"00",  NullTag,        x"00",  NullAddr&PadT,              x"00",              x"00",  x"00000000"),
        (NullTag,       x"00",  NullTag,        x"00",  NullAddr&PadT,              x"00",              x"00",  x"00000000"),
        (NullTag,       x"00",  NullTag,        x"00",  NullAddr&PadT,              x"00",              x"00",  x"00000000"),
        (NullTag,       x"00",  NullTag,        x"00",  NullAddr&PadT,              x"00",              x"00",  x"00000000"),
        (NullTag,       x"00",  NullTag,        x"00",  NullAddr&PadT,              x"00",              x"00",  x"00000000"),
        (NullTag,       x"00",  NullTag,        x"00",  NullAddr&PadT,              x"00",              x"00",  x"00000000")
        );


    constant PinDesc : PinDescType :=(
--      Base       Sec      Sec       Sec
--      func       unit     func      pin                   -- hostmot2 DE0-Nano        pin    Function
        IOPortTag & x"00" & StepGenTag & StepGenStepPin,    -- I/O 00   GPIO_0 00    01        X Step
        IOPortTag & x"00" & StepGenTag & StepGenDirPin,     -- I/O 01   GPIO_0 01    02        X Dir
        IOPortTag & x"01" & StepGenTag & StepGenStepPin,    -- I/O 02   GPIO_0 02    03        Y Step
        IOPortTag & x"01" & StepGenTag & StepGenDirPin,     -- I/O 03   GPIO_0 03    04         Y Dir
        IOPortTag & x"02" & StepGenTag & StepGenStepPin,    -- I/O 04   GPIO_0 04    05        Z Step
        IOPortTag & x"02" & StepGenTag & StepGenDirPin,     -- I/O 05   GPIO_0 05    06        Z Dir
        IOPortTag & x"03" & StepGenTag & StepGenStepPin,    -- I/O 06   GPIO_0 06    07        E0 Step
        IOPortTag & x"03" & StepGenTag & StepGenDirPin,     -- I/O 07   GPIO_0 07    08        E0 Dir
        IOPortTag & x"04" & StepGenTag & StepGenStepPin,    -- I/O 08   GPIO_0 08    09        E1 Step
        IOPortTag & x"04" & StepGenTag & StepGenDirPin,     -- I/O 09   GPIO_0 08    10        E1 Dir
        IOPortTag & x"05" & StepGenTag & StepGenStepPin,    -- I/O 10   GPIO_0 10    13        E2 Step
        IOPortTag & x"05" & StepGenTag & StepGenDirPin,     -- I/O 11   GPIO_0 11    14        E2 Dir
        IOPortTag & x"06" & StepGenTag & StepGenStepPin,    -- I/O 12   GPIO_0 12    15        U Step
        IOPortTag & x"06" & StepGenTag & StepGenDirPin,     -- I/O 13   GPIO_0 13    16        U Dir
        IOPortTag & x"07" & StepGenTag & StepGenStepPin,    -- I/O 14   GPIO_0 14    17        V Step
        IOPortTag & x"07" & StepGenTag & StepGenDirPin,     -- I/O 15   GPIO_0 15    18        V Dir
        IOPortTag & x"08" & StepGenTag & StepGenStepPin,    -- I/O 16   GPIO_0 16    19        W Step
        IOPortTag & x"08" & StepGenTag & StepGenDirPin,     -- I/O 17   GPIO_0 17    20        W Dir
        IOPortTag & x"00" & PWMTag & PWMAOutPin,            -- I/O 18   GPIO_0 18    21        Spindle DAC PWM
        IOPortTag & x"01" & PWMTag & PWMAOutPin,            -- I/O 19   GPIO_0 19    22        Spindle DAC PWM
        IOPortTag & x"02" & PWMTag & PWMAOutPin,            -- I/O 20   GPIO_0 20    23        Spindle DAC PWM
        IOPortTag & x"03" & PWMTag & PWMAOutPin,            -- I/O 21   GPIO_0 21    24        Spindle DAC PWM
        IOPortTag & x"04" & PWMTag & PWMAOutPin,            -- I/O 22   GPIO_0 22    25        Spindle DAC PWM
        IOPortTag & x"05" & PWMTag & PWMAOutPin,            -- I/O 23   GPIO_0 23    26        Spindle DAC PWM
        IOPortTag & x"00" & NullTag & NullPin,              -- I/O 24   GPIO_0 24    27        Limit X-Min
        IOPortTag & x"00" & NullTag & NullPin,              -- I/O 25   GPIO_0 25    28        Limit X-Max
        IOPortTag & x"00" & NullTag & NullPin,              -- I/O 26   GPIO_0 26    31        Limit Y-Min
        IOPortTag & x"00" & NullTag & NullPin,              -- I/O 27   GPIO_0 27    32        Limit Y-Max
        IOPortTag & x"00" & NullTag & NullPin,              -- I/O 28   GPIO_0 28    33        Limit Z-Min
        IOPortTag & x"00" & NullTag & NullPin,              -- I/O 29   GPIO_0 29    34        Limit Z-Max
        IOPortTag & x"00" & NullTag & NullPin,              -- I/O 30   GPIO_0 30    35        just GPIO
        IOPortTag & x"00" & NullTag & NullPin,              -- I/O 31   GPIO_0 31    36        Led
        IOPortTag & x"00" & NullTag & NullPin,              -- I/O 32   GPIO_0 32    37        Axis_ENA_n
        IOPortTag & x"00" & NullTag & NullPin,              -- I/O 33   GPIO_0 33    38        Machine_Pwr
        IOPortTag & x"00" & NullTag & NullPin,              -- I/O 34   GPIO_0 34    39        Estop (In)
        IOPortTag & x"00" & NullTag & NullPin,              -- I/O 35   GPIO_0 35    40        Estop_Sw

--      Base       Sec      Sec       Sec
--      func       unit     func      pin                   -- hostmot2    DE0-Nano     pin    Function
        IOPortTag & x"00" & CAPSENSETag & CapChargePin,     --    I/O 36    GPIO_1 00   01      CapSense charge
        IOPortTag & x"00" & CAPSENSETag & CapSensePin0,     --    I/O 37    GPIO_1 01   02      CapSense sense 0
        IOPortTag & x"00" & CAPSENSETag & CapSensePin1,     --    I/O 38    GPIO_1 02   03      CapSense sense 1
        IOPortTag & x"00" & CAPSENSETag & CapSensePin2,     --    I/O 39    GPIO_1 03   04      CapSense sense 2
        IOPortTag & x"00" & CAPSENSETag & CapSensePin3,     --    I/O 40    GPIO_1 04   05      CapSense sense 3
        IOPortTag & x"00" & QCountTag & QCountIdxPin,       --    I/O 41    GPIO_1 05   06      Encoder Z
        IOPortTag & x"00" & QCountTag & QCountQBPin,        --    I/O 42    GPIO_1 06   07      Encoder B
        IOPortTag & x"00" & QCountTag & QCountQAPin,        --    I/O 43    GPIO_1 07   08      Encoder A
        IOPortTag & x"01" & QCountTag & QCountIdxPin,       --    I/O 44    GPIO_1 08   09      Encoder Z
        IOPortTag & x"01" & QCountTag & QCountQBPin,        --    I/O 45    GPIO_1 09   10      Encoder B
        IOPortTag & x"01" & QCountTag & QCountQAPin,        --    I/O 46    GPIO_1 10   13      Encoder A
        IOPortTag & x"00" & NullTag & NullPin,              --    I/O 47    GPIO_1 11   14      just GPIO
        IOPortTag & x"00" & BSPITag & BSPIFramePin,         --    I/O 48    GPIO_1 12   15      SPI Frame
        IOPortTag & x"00" & BSPITag & BSPIOutPin,           --    I/O 49    GPIO_1 13   16      SPI Out
        IOPortTag & x"00" & BSPITag & BSPIClkPin,           --    I/O 50    GPIO_1 14   17      SPI Clk
        IOPortTag & x"00" & BSPITag & BSPIInPin,            --    I/O 51    GPIO_1 15   18      SPI In
        IOPortTag & x"00" & BSPITag & BSPICS2Pin,           --    I/O 52    GPIO_1 16   19      SPI Cs
        IOPortTag & x"00" & BSPITag & BSPICS1Pin,           --    I/O 53    GPIO_1 17   20      SPI Cs
        IOPortTag & x"00" & BSPITag & BSPICS0Pin,           --    I/O 54    GPIO_1 18   21      SPI Cs
        IOPortTag & x"01" & BSPITag & BSPIFramePin,         --    I/O 55    GPIO_1 19   22      SPI Frame
        IOPortTag & x"01" & BSPITag & BSPIOutPin,           --    I/O 56    GPIO_1 20   23      SPI Out
        IOPortTag & x"01" & BSPITag & BSPIClkPin,           --    I/O 57    GPIO_1 21   24      SPI Clk
        IOPortTag & x"01" & BSPITag & BSPIInPin,            --    I/O 58    GPIO_1 22   25      SPI In
        IOPortTag & x"01" & BSPITag & BSPICS2Pin,           --    I/O 59    GPIO_1 23   26      SPI Cs
        IOPortTag & x"01" & BSPITag & BSPICS1Pin,           --    I/O 60    GPIO_1 24   27      SPI Cs
        IOPortTag & x"01" & BSPITag & BSPICS0Pin,           --    I/O 61    GPIO_1 25   28      SPI Cs
        IOPortTag & x"00" & NullTag & NullPin,              --    I/O 62    GPIO_1 26   31      just GPIO
        IOPortTag & x"00" & NullTag & NullPin,              --    I/O 63    GPIO_1 27   32      just GPIO
        IOPortTag & x"00" & NullTag & NullPin,              --    I/O 64    GPIO_1 28   33      just GPIO
        IOPortTag & x"00" & NullTag & NullPin,              --    I/O 65    GPIO_1 29   34      just GPIO
        IOPortTag & x"00" & NullTag & NullPin,              --    I/O 66    GPIO_1 30   35      just GPIO
        IOPortTag & x"00" & NullTag & NullPin,              --    I/O 67    GPIO_1 31   36      just GPIO
        IOPortTag & x"00" & NullTag & NullPin,              --    I/O 68    GPIO_1 32   37      just GPIO
        IOPortTag & x"00" & NullTag & NullPin,              --    I/O 69    GPIO_1 33   38      just GPIO
        IOPortTag & x"00" & NullTag & NullPin,              --    I/O 70    GPIO_1 34   39      just GPIO
        IOPortTag & x"00" & NullTag & NullPin,              --    I/O 71    GPIO_1 35   40      just GPIO

                -- Remainder of 144 pin descriptors are unused
        emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,
        emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,
        emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,
        emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,
        emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,
        emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,
    	emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,
		emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,
		emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin,emptypin);

end package Pintypes; --PIN_Cramps_3x24_dpll_irq
