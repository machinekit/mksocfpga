--Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Tool Version: Vivado v.2019.1 (lin64) Build 2552052 Fri May 24 14:47:09 MDT 2019
--Date        : Tue Sep 24 16:24:52 2019
--Host        : kdeneon-ws running 64-bit Ubuntu 16.04.6 LTS
--Command     : generate_target soc_system_wrapper.bd
--Design      : soc_system_wrapper
--Purpose     : IP block netlist
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity soc_system_wrapper is
  port (
    FAN_PWM : out STD_LOGIC_VECTOR ( 0 to 0 );
    IOBits : inout STD_LOGIC_VECTOR ( 35 downto 0 );
    LED : out STD_LOGIC_VECTOR ( 0 to 0 );
    RATES : out STD_LOGIC_VECTOR ( 4 downto 0 );
    bt_ctsn : in STD_LOGIC;
    bt_rtsn : out STD_LOGIC
  );
end soc_system_wrapper;

architecture STRUCTURE of soc_system_wrapper is
  component soc_system is
  port (
    FAN_PWM : out STD_LOGIC_VECTOR ( 0 to 0 );
    IOBits : inout STD_LOGIC_VECTOR ( 35 downto 0 );
    LED : out STD_LOGIC_VECTOR ( 0 to 0 );
    RATES : out STD_LOGIC_VECTOR ( 4 downto 0 );
    bt_ctsn : in STD_LOGIC;
    bt_rtsn : out STD_LOGIC
  );
  end component soc_system;
begin
soc_system_i: component soc_system
     port map (
      FAN_PWM(0) => FAN_PWM(0),
      IOBits(35 downto 0) => IOBits(35 downto 0),
      LED(0) => LED(0),
      RATES(4 downto 0) => RATES(4 downto 0),
      bt_ctsn => bt_ctsn,
      bt_rtsn => bt_rtsn
    );
end STRUCTURE;
