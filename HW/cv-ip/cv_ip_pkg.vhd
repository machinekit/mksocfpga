library ieee;
use ieee.std_logic_1164.all;

package cv_ip_pkg is

	component debounce is
	generic (
		WIDTH : integer := 32;
		POLARITY : string := "HIGH";
		TIMEOUT : integer := 50000;
		TIMEOUT_WIDTH : integer := 16 );
	port (
		clk : in std_logic;
		reset_n : in std_logic;
		data_in : in std_logic_vector(WIDTH-1 downto 0);
		data_out : out std_logic_vector(WIDTH-1 downto 0) );
	end component;

	component altera_edge_detector is
	generic (
		PULSE_EXT : integer := 0;
		EDGE_TYPE : integer := 0;
		IGNORE_RST_WHILE_BUSY : integer := 0 );
	port (
		clk : in std_logic;
		rst_n : in std_logic;
		signal_in : in std_logic;
		pulse_out : out std_logic );
	end component;

	component hps_reset is
	port (
		probe : in std_logic;
		source_clk : in std_logic;
		source : out std_logic_vector(2 downto 0) );
	end component;

	component I2C_HDMI_Config is
	generic (
		CLK_Freq : integer := 50000000;
		I2C_Freq : integer := 20000;
		LUT_SIZE : integer := 31 );
	port (
		iCLK : in std_logic;
		iRST_N : in std_logic;
		I2C_SCLK : out std_logic;
		I2C_SDAT : inout std_logic;
		HDMI_TX_INT : in std_logic;
		READY : out std_logic );
	end component;

end cv_ip_pkg;

