-- Dual ram with independent read and write ports
-- used as a ping pong buffer.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ram_dualp is
    generic(
        PP_BUF_ADDR_WIDTH : natural := 6
    );
	port
	(
        clk     : in std_logic;
        rd_addr : in std_logic_vector(PP_BUF_ADDR_WIDTH - 1 downto 0);
        rd_data : out std_logic_vector(7 downto 0);
        we : in std_logic;
        wr_addr : in std_logic_vector(PP_BUF_ADDR_WIDTH - 1 downto 0);
        wr_data : in std_logic_vector(7 downto 0)
	);
end entity;

architecture beh of ram_dualp is
    type mem_type is array ( (2**PP_BUF_ADDR_WIDTH) - 1 downto 0 ) of std_logic_vector(7 downto 0);
    signal buf : mem_type;
begin
    update_buf : process(clk, wr_addr, we, wr_data)
    begin
        if(rising_edge(clk)) then
            if(we = '1') then
                buf(to_integer(unsigned(wr_addr))) <= wr_data;
            end if;
            rd_data <= buf(to_integer(unsigned(rd_addr)));
        end if;
    end process update_buf;
end beh;
