library IEEE;
use std.textio.all;
use IEEE.std_logic_1164.all;  -- defines std_logic types
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_TEXTIO.ALL;

use work.IDROMConst.all;

package idrom_tools is
function BoardVendor(
    name_low: std_logic_vector(31 downto 0)) return string;
function BoardName(
    name_low: std_logic_vector(31 downto 0);
    name_high: std_logic_vector(31 downto 0);
    width: integer) return string;
function Conn(vendor: std_logic_vector(31 downto 0);
	board: std_logic_vector(31 downto 0); idx: integer;
        portwidth: integer) return string;
function TagToName(tag : std_logic_vector(7 downto 0)) return string;
function MakePinRecord(pv : std_logic_vector(31 downto 0)) return PinDescRecord;
function Funct(tag: std_logic_vector(7 downto 0);
               pin: std_logic_vector(7 downto 0)) return string;
end package;

package body idrom_tools is

function BoardVendor(
    name_low: std_logic_vector(31 downto 0)) return string is
begin
    if(name_low = BoardNameMesa) then return "Mesa"; end if;
    return "unknown";
end function;

function BoardName(
    name_low: std_logic_vector(31 downto 0);
    name_high: std_logic_vector(31 downto 0);
    width: integer) return string is
begin
    if(name_low = BoardNameMesa) then
        if(name_high = BoardName4i65) then return "4i65"; end if;
        if(name_high = BoardName4i68) then return "4i68"; end if;
        if(name_high = BoardName4i74) then return "4i74"; end if;
        if(name_high = BoardName5i20) then return "5i20"; end if;
        if(name_high = BoardName5i22) then return "5i22"; end if;
        if(name_high = BoardName5i23) then return "5i23"; end if;
        if(name_high = BoardName5i24) then return "5i24"; end if;
        if(name_high = BoardName5i25) then return "5i25"; end if;
        if(name_high = BoardName6i25) then return "6i25"; end if;
        if(name_high = BoardName7i43) then return "7i43"; end if;
        if(name_high = BoardName7i60) then return "7i60"; end if;
        if(name_high = BoardName7i61) then return "7i61"; end if;
        if(name_high = BoardName7i62) then return "7i62"; end if;
        if(name_high = BoardName7i80HD and width = 24) then return "7i80HD"; end if;
        if(name_high = BoardName7i80DB and width = 17) then return "7i80DB"; end if;
        if(name_high = BoardName7i76E) then return "7i76E"; end if;
        -- if(name_high = BoardName7i77) then return "7i77"; end if;
        if(name_high = BoardName3x20) then return "3x20"; end if;
        if(name_high = BoardName3x21) then return "3x21"; end if;
        if(name_high = BoardName7i90) then return "7i90"; end if;
    end if;
    return "unknown";
end function;

-- XXX: this function must be kept in synch with the one in pinmaker
-- (someone should fix this)
function Conn(vendor: std_logic_vector(31 downto 0); board: std_logic_vector(31 downto 0); idx: integer; portwidth: integer)
return string is
    variable pp : integer;
begin
    pp := idx / portwidth;
    if(vendor = BoardNameMesa) then
	if(board = BoardName4i65) then
	    if(pp = 0) then return "P1"; end if;
	    if(pp = 1) then return "P3"; end if;
	    if(pp = 2) then return "P4"; end if;
	end if;
	if(board = BoardName4i68) then
	    if(pp = 0) then return "P1"; end if;
	    if(pp = 1) then return "P2"; end if;
	    if(pp = 2) then return "P4"; end if;
	end if;
	if(board = BoardName4i74) then
	    if(pp = 0) then return "P1"; end if;
	    if(pp = 1) then return "P3"; end if;
	    if(pp = 2) then return "P4"; end if;
	end if;
	if(board = BoardName5i20) then
	    if(pp = 0) then return "P2"; end if;
	    if(pp = 1) then return "P3"; end if;
	    if(pp = 2) then return "P4"; end if;
	end if;
	if(board = BoardName5i22) then
	    if(pp = 0) then return "P2"; end if;
	    if(pp = 1) then return "P3"; end if;
	    if(pp = 2) then return "P4"; end if;
	    if(pp = 3) then return "P5"; end if;
	end if;
	if(board = BoardName5i23) then
	    if(pp = 0) then return "P2"; end if;
	    if(pp = 1) then return "P3"; end if;
	    if(pp = 2) then return "P4"; end if;
	end if;
	if(board = BoardName5i24) then
	    if(pp = 0) then return "P2"; end if;
	    if(pp = 1) then return "P3"; end if;
	    if(pp = 2) then return "P4"; end if;
	end if;
	if(board = BoardName5i25) then
	    if(pp = 0) then return "P3"; end if;
	    if(pp = 1) then return "P2"; end if;
	end if;
	if(board = BoardName6i25) then
	    if(pp = 0) then return "P3"; end if;
	    if(pp = 1) then return "P2"; end if;
	end if;
	if(board = BoardName7i43) then
	    if(pp = 0) then return "P4"; end if;
	    if(pp = 1) then return "P3"; end if;
	end if;
	if(board = BoardName7i76E) then
	    if(pp = 0) then return "on-card"; end if;
	    if(pp = 1) then return "P1"; end if;
	    if(pp = 2) then return "P2"; end if;
	end if;
	if(board = BoardName7i80DB and portwidth = 17) then
	    if(pp = 0) then return "J2"; end if;
	    if(pp = 1) then return "J3"; end if;
	    if(pp = 2) then return "J4"; end if;
	    if(pp = 3) then return "J5"; end if;
	end if;
	if(board = BoardName7i80HD and portwidth = 24) then
	    if(pp = 0) then return "P1"; end if;
	    if(pp = 1) then return "P2"; end if;
	    if(pp = 2) then return "P3"; end if;
	end if;
	if(board = BoardName3X20) then
	    if(pp = 0) then return "P4"; end if;
	    if(pp = 1) then return "P5"; end if;
	    if(pp = 2) then return "P6"; end if;
	    if(pp = 3) then return "P9"; end if;
	    if(pp = 4) then return "P8"; end if;
	    if(pp = 5) then return "P7"; end if;
	end if;
    end if;
    return "???";
end function;
 
function TagToName(tag : std_logic_vector(7 downto 0)) return string is
begin
    if(tag = NullTag)	    then return "None"; end if;
    if(tag = IRQTag)	    then return "IRQ"; end if;
    if(tag = WatchDogTag)   then return "Watchdog"; end if;
    if(tag = IOPortTag)	    then return "IOPort"; end if;
    if(tag = QCountTag)	    then return "Encoder"; end if;
    if(tag = StepGenTag)    then return "StepGen"; end if;
    if(tag = PWMTag)	    then return "PWMGen"; end if;
    if(tag = SPITag)	    then return "SPI"; end if;
    if(tag = SSSITag)	    then return "SSSI"; end if;
    if(tag = UARTTTag)	    then return "UARTT"; end if;
    if(tag = AddrXTag)	    then return "AddrX"; end if;
    if(tag = MuxedQCountTag) then return "MuxedQCount"; end if;
    if(tag = MuxedQCountSelTag) then return "MuxedQCountSel"; end if;
    if(tag = BSPITag)	    then return "BSPI"; end if;
    if(tag = DBSPITag)	    then return "DBSPI"; end if;
    if(tag = DPLLTag)	    then return "DPLL"; end if;
    if(tag = MuxedQCountMIMTag) then return "MuxedQCountMIM"; end if;
    if(tag = TPPWMTag)	    then return "TPPWM"; end if;
    if(tag = LEDTag)	    then return "LED"; end if;
    if(tag = SSerialTag)    then return "SSerial"; end if;
    return "unknown";
end;

function MakePinRecord(pv : std_logic_vector(31 downto 0)) return PinDescRecord
is
    variable pr : PinDescRecord;
begin
    pr.SecPin := pv(7 downto 0);
    pr.SecFunc := pv(15 downto 8);
    pr.SecInst := pv(23 downto 16);
    pr.PriFunc := pv(31 downto 24);
    return pr;
end function;

-- XXX: this function must be kept in synch with the one in pinmaker
-- (someone should fix this)
function Funct(tag: std_logic_vector(7 downto 0);
               pin: std_logic_vector(7 downto 0)) return string is
begin
    if(tag = QCountTag) then
        if(pin = QCountQAPin)         then return "Phase A (in)";
        elsif(pin = QCountQBPin)      then return "Phase B (in)";
        elsif(pin = QCountIdxPin)     then return "Index (in)";
        elsif(pin = QCountIdxMaskPin) then return "IndexMask (in)";
        elsif(pin = QCountProbePin)   then return "Probe (in)"; end if;
    elsif(tag = StepGenTag) then
        if(pin = StepGenStepPin)      then return "Step (out)";
        elsif(pin = StepGenDirPin)    then return "Dir (out)";
        elsif(pin = StepGenTable2Pin) then return "StepTable 2 (out)";
        elsif(pin = StepGenTable3Pin) then return "StepTable 3 (out)";
        elsif(pin = StepGenTable4Pin) then return "StepTable 4 (out)";
        elsif(pin = StepGenTable5Pin) then return "StepTable 5 (out)";
        elsif(pin = StepGenTable6Pin) then return "StepTable 6 (out)";
        elsif(pin = StepGenTable7Pin) then return "StepTable 7 (out)"; end if;
    elsif(tag = PWMTag) then
        if(pin = PWMAOutPin)          then return "PWM/Up (out)";
        elsif(pin = PWMBDirPin)       then return "Dir/Down (out)";
        elsif(pin = PWMCEnaPin)       then return "Enable (out)"; end if;
    elsif(tag = TPPWMTag) then
        if(pin = TPPWMAOutPin)        then return "PWM A (out)";
        elsif(pin = TPPWMBOutPin)     then return "PWM B (out)";
        elsif(pin = TPPWMCOutPin)     then return "PWM C (out)";
        elsif(pin = NTPPWMAOutPin)    then return "PWM /A (out)";
        elsif(pin = NTPPWMBOutPin)    then return "PWM /B (out)";
        elsif(pin = NTPPWMCOutPin)    then return "PWM /C (out)";
        elsif(pin = TPPWMEnaPin)      then return "Enable (out)";
        elsif(pin = TPPWMFaultPin)    then return "Fault (in)"; end if;
    elsif(tag = MuxedQCountTag) then
        if(pin = MuxedQCountQAPin)    then return "Muxed Phase A (in)";
        elsif(pin = MuxedQCountQBPin) then return "Muxed Phase B (in)";
        elsif(pin = MuxedQCountIdxPin) then return "Muxed Index (in)";
        elsif(pin = MuxedQCountIdxMaskPin) then return "Muxed Index Mask (in)";
        elsif(pin = MuxedQCountProbePin) then return "Muxed Probe (in)"; end if;
    elsif(tag = MuxedQCountSelTag) then
        if(pin = MuxedQCountSel0Pin)   then return "Muxed Encoder Select 0 (out)";
        elsif(pin = MuxedQCountSel1Pin) then return "Muxed Encoder Select 1 (out)"; end if;
    elsif(tag = SSerialTag) then
        if(pin = SSerialTX0Pin)       then return "Serial Transmit 0 (out)";
        elsif(pin = SSerialTX1Pin)    then return "Serial Transmit 1 (out)";
        elsif(pin = SSerialTX2Pin)    then return "Serial Transmit 2 (out)";
        elsif(pin = SSerialTX3Pin)    then return "Serial Transmit 3 (out)";
        elsif(pin = SSerialTX4Pin)    then return "Serial Transmit 4 (out)";
        elsif(pin = SSerialTX5Pin)    then return "Serial Transmit 5 (out)";
        elsif(pin = SSerialTXEN0Pin)    then return "Serial Transmit Enable 0 (in)";
        elsif(pin = SSerialTXEN1Pin)    then return "Serial Transmit Enable 1 (in)";
        elsif(pin = SSerialTXEN2Pin)    then return "Serial Transmit Enable 2 (in)";
        elsif(pin = SSerialTXEN3Pin)    then return "Serial Transmit Enable 3 (in)";
        elsif(pin = SSerialTXEN4Pin)    then return "Serial Transmit Enable 4 (in)";
        elsif(pin = SSerialTXEN5Pin)    then return "Serial Transmit Enable 5 (in)";
        elsif(pin = SSerialRX0Pin)    then return "Serial Receive 0 (in)";
        elsif(pin = SSerialRX1Pin)    then return "Serial Receive 1 (in)";
        elsif(pin = SSerialRX2Pin)    then return "Serial Receive 2 (in)";
        elsif(pin = SSerialRX3Pin)    then return "Serial Receive 3 (in)";
        elsif(pin = SSerialRX4Pin)    then return "Serial Receive 4 (in)";
        elsif(pin = SSerialRX5Pin)    then return "Serial Receive 5 (in)";
        end if;
    end if;
    return "???";
end function;


end package body;
