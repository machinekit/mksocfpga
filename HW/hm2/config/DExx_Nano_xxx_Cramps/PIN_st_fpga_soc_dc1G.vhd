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
        (QcountTag,     x"02",  ClockLowTag,    x"06",  QcounterAddr&PadT,          QCounterNumRegs,    x"00",  QCounterMPBitMask),
        (StepGenTag,    x"02",  ClockLowTag,    x"06",  StepGenRateAddr&PadT,       StepGenNumRegs,     x"00",  StepGenMPBitMask),
        (SSerialTag,    x"00",  ClockLowTag,    x"01",  SSerialCommandAddr&PadT,    SSerialNumRegs,     x"10",  SSerialMPBitMask),
        (PWMTag,        x"00",  ClockHighTag,   x"00",  PWMValAddr&PadT,            PWMNumRegs,         x"00",  PWMMPBitMask),
        (LEDTag,        x"00",  ClockLowTag,    x"01",  LEDAddr&PadT,               LEDNumRegs,         x"00",  LEDMPBitMask),
        (NANOADCTag,    x"00",  ClockLowTag,    x"08",  NANOADCAddr&PadT,           NANOADCNumRegs,     x"00",  NANOADCBitMask),
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
        (NullTag,       x"00",  NullTag,        x"00",  NullAddr&PadT,              x"00",              x"00",  x"00000000"),
        (NullTag,       x"00",  NullTag,        x"00",  NullAddr&PadT,              x"00",              x"00",  x"00000000")
        );


    constant PinDesc : PinDescType :=(
--      Base       Sec      Sec       Sec
--      func       unit     func      pin                   -- hostmot2 DE0-Nano     pin      Function
        IOPortTag & x"00" & NullTag & NullPin,              -- I/O 00   GPIO_0 20    01        GP_Input_10 
        IOPortTag & x"00" & NullTag & NullPin,              -- I/O 01   GPIO_0 20    02        GP_Input_04
        IOPortTag & x"00" & NullTag & NullPin,              -- I/O 02   GPIO_0 21    03        GP_Input_05
        IOPortTag & x"00" & NullTag & NullPin,              -- I/O 03   GPIO_0 22    04        GP_Input_00
        IOPortTag & x"00" & NullTag & NullPin,              -- I/O 04   GPIO_0 23    05        GP_Input_06
        IOPortTag & x"00" & NullTag & NullPin,              -- I/O 05   GPIO_0 24    06        GP_Input_01
        IOPortTag & x"00" & NullTag & NullPin,              -- I/O 06   GPIO_0 25    07        GP_Input_11
        IOPortTag & x"00" & NullTag & NullPin,              -- I/O 07   GPIO_0 26    08        GP_Input_12
        IOPortTag & x"00" & NullTag & NullPin,              -- I/O 08   GPIO_0 27    09        GP_Input_13
        IOPortTag & x"00" & NullTag & NullPin,              -- I/O 09   GPIO_0 28    10        GP_Input_14
        IOPortTag & x"00" & NullTag & NullPin,              -- I/O 10   GPIO_0 29    13        GP_Input_07
        IOPortTag & x"00" & NullTag & NullPin,              -- I/O 11   GPIO_0 30    14        GP_Input_15
        IOPortTag & x"00" & NullTag & NullPin,              -- I/O 12   GPIO_0 31    15        GP_Input_09
        IOPortTag & x"00" & NullTag & NullPin,              -- I/O 13   GPIO_0 32    16        GP_Input_08
        IOPortTag & x"00" & NullTag & NullPin,              -- I/O 14   GPIO_0 33    17        GP_Input_03
        IOPortTag & x"00" & NullTag & NullPin,              -- I/O 15   GPIO_0 34    18        GP_Input_02
        IOPortTag & x"00" & QCountTag & QCountQBPin,        -- I/O 16   GPIO_0 01    19        Enc0 B
        IOPortTag & x"00" & QCountTag & QCountQAPin,        -- I/O 17   GPIO_0 02    20        Enc0 A
        IOPortTag & x"01" & QCountTag & QCountQAPin,        -- I/O 18   GPIO_0 03    21        Enc1 A
        IOPortTag & x"00" & QCountTag & QCountIdxPin,       -- I/O 19   GPIO_0 04    22        Enc0 Z
        IOPortTag & x"01" & QCountTag & QCountIdxPin,       -- I/O 20   GPIO_0 05    23        Enc1 Z
        IOPortTag & x"01" & QCountTag & QCountQBPin,        -- I/O 21   GPIO_0 06    24        Enc1 B
        IOPortTag & x"02" & QCountTag & QCountQBPin,        -- I/O 22   GPIO_0 07    25        Enc2 B
        IOPortTag & x"02" & QCountTag & QCountQAPin,        -- I/O 23   GPIO_0 08    26        Enc2 A
        IOPortTag & x"03" & QCountTag & QCountQAPin,        -- I/O 24   GPIO_0 09    27        Enc3 A
        IOPortTag & x"02" & QCountTag & QCountIdxPin,       -- I/O 25   GPIO_0 10    28        Enc2 Z
        IOPortTag & x"03" & QCountTag & QCountIdxPin,       -- I/O 26   GPIO_0 11    31        Enc3 Z
        IOPortTag & x"03" & QCountTag & QCountQBPin,        -- I/O 27   GPIO_0 12    32        Enc3 B
        IOPortTag & x"04" & QCountTag & QCountQBPin,        -- I/O 28   GPIO_0 13    33        Enc4 B
        IOPortTag & x"04" & QCountTag & QCountQAPin,        -- I/O 29   GPIO_0 14    34        Enc4 A
        IOPortTag & x"05" & QCountTag & QCountQAPin,        -- I/O 30   GPIO_0 15    35        Enc5 A
        IOPortTag & x"04" & QCountTag & QCountIdxPin,       -- I/O 31   GPIO_0 16    36        Enc4 Z
        IOPortTag & x"05" & QCountTag & QCountIdxPin,       -- I/O 32   GPIO_0 17    37        Enc5 Z
        IOPortTag & x"05" & QCountTag & QCountQBPin,        -- I/O 33   GPIO_0 18    38        Enc5 B
        IOPortTag & x"00" & NullTag & NullPin,              -- I/O 34   GPIO_0 35    39        GP_Output_HC_17
        IOPortTag & x"00" & NullTag & NullPin,              -- I/O 35   GPIO_0 36    40        GP_Output_HC_16

--      Base       Sec      Sec       Sec
--      func       unit     func      pin                   -- hostmot2  DE0-Nano    pin    Function
        IOPortTag & x"00" & SSerialTag & SSerialTX0Pin,     -- I/O 36    GPIO_1 01   01      rs_422_Tx_0 
        IOPortTag & x"00" & SSerialTag & SSerialRX0Pin,     -- I/O 37    GPIO_1 02   02      rs_422_Rx_0        
        IOPortTag & x"05" & StepGenTag & StepGenStepPin,    -- I/O 38    GPIO_1 03   03      Step_5
        IOPortTag & x"05" & StepGenTag & StepGenDirPin,     -- I/O 39    GPIO_1 04   04      Dir_5
        IOPortTag & x"04" & StepGenTag & StepGenStepPin,    -- I/O 40    GPIO_1 05   05      Step_4
        IOPortTag & x"04" & StepGenTag & StepGenDirPin,     -- I/O 41    GPIO_1 06   06      Dir_4
        IOPortTag & x"03" & StepGenTag & StepGenStepPin,    -- I/O 42    GPIO_1 07   07      Step_3
        IOPortTag & x"03" & StepGenTag & StepGenDirPin,     -- I/O 43    GPIO_1 08   08      Dir_3
        IOPortTag & x"02" & StepGenTag & StepGenStepPin,    -- I/O 44    GPIO_1 09   09      Step_2
        IOPortTag & x"02" & StepGenTag & StepGenDirPin,     -- I/O 45    GPIO_1 10   10      Dir_2
        IOPortTag & x"01" & StepGenTag & StepGenStepPin,    -- I/O 46    GPIO_1 11   13      Step_1
        IOPortTag & x"01" & StepGenTag & StepGenDirPin,     -- I/O 47    GPIO_1 12   14      Dir_1
        IOPortTag & x"00" & StepGenTag & StepGenStepPin,    -- I/O 48    GPIO_1 13   15      Step_0
        IOPortTag & x"00" & StepGenTag & StepGenDirPin,     -- I/O 49    GPIO_1 14   16      Dir_0
        IOPortTag & x"00" & NullTag & NullPin,              -- I/O 50    GPIO_1 15   17      Step4_Enable
        IOPortTag & x"00" & NullTag & NullPin,              -- I/O 51    GPIO_1 16   18      Step5_Enable
        IOPortTag & x"00" & NullTag & NullPin,              -- I/O 52    GPIO_1 17   19      Step2_Enable
        IOPortTag & x"00" & NullTag & NullPin,              -- I/O 53    GPIO_1 18   20      Step3_Enable
        IOPortTag & x"00" & NullTag & NullPin,              -- I/O 54    GPIO_1 19   21      Step0_Enable
        IOPortTag & x"00" & NullTag & NullPin,              -- I/O 55    GPIO_1 20   22      Step1_Enable
        IOPortTag & x"00" & NullTag & NullPin,              -- I/O 56    GPIO_1 21   23      GP_Output_00
        IOPortTag & x"00" & NullTag & NullPin,              -- I/O 57    GPIO_1 22   24      GP_Output_08
        IOPortTag & x"00" & NullTag & NullPin,              -- I/O 58    GPIO_1 23   25      GP_Output_01
        IOPortTag & x"00" & NullTag & NullPin,              -- I/O 59    GPIO_1 24   26      GP_Output_09
        IOPortTag & x"00" & NullTag & NullPin,              -- I/O 60    GPIO_1 25   27      GP_Output_02
        IOPortTag & x"00" & NullTag & NullPin,              -- I/O 61    GPIO_1 26   28      GP_Output_10
        IOPortTag & x"00" & NullTag & NullPin,              -- I/O 62    GPIO_1 27   31      GP_Output_03
        IOPortTag & x"00" & NullTag & NullPin,              -- I/O 63    GPIO_1 28   32      GP_Output_11
        IOPortTag & x"00" & NullTag & NullPin,              -- I/O 64    GPIO_1 29   33      GP_Output_04
        IOPortTag & x"00" & NullTag & NullPin,              -- I/O 65    GPIO_1 30   34      GP_Output_12
        IOPortTag & x"00" & NullTag & NullPin,              -- I/O 66    GPIO_1 31   35      GP_Output_05
        IOPortTag & x"00" & NullTag & NullPin,              -- I/O 67    GPIO_1 32   36      GP_Output_13
        IOPortTag & x"00" & NullTag & NullPin,              -- I/O 68    GPIO_1 33   37      GP_Output_06
        IOPortTag & x"00" & NullTag & NullPin,              -- I/O 69    GPIO_1 34   38      GP_Output_14
        IOPortTag & x"00" & NullTag & NullPin,              -- I/O 70    GPIO_1 35   39      GP_Output_07
        IOPortTag & x"00" & NullTag & NullPin,              -- I/O 71    GPIO_1 36   40      GP_Output_15
      
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
