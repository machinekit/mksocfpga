-- Dual ram with independent read and write ports
-- used as a ping pong buffer. Async read.
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
        lock : in std_logic;
        rd_sel : in std_logic;
        rd_addr : in std_logic_vector(PP_BUF_ADDR_WIDTH - 1 downto 0);
        rd_data : out std_logic_vector(7 downto 0);
        wr : in std_logic;
        wr_addr : in std_logic_vector(PP_BUF_ADDR_WIDTH - 1 downto 0);
        wr_data : in std_logic_vector(7 downto 0)
	);
end entity;

architecture beh of ram_dualp is
    type mem_type is array ( (2**PP_BUF_ADDR_WIDTH) - 1 downto 0 ) of std_logic_vector(7 downto 0);
    signal buf0, buf1 : mem_type;
    signal buf0_rd_data : std_logic_vector(7 downto 0);
    signal buf1_rd_data : std_logic_vector(7 downto 0);
begin

    mux_rd : process(rd_sel, rd_addr, buf0_rd_data, buf1_rd_data)
    begin
        if(rd_sel = '1') then
            rd_data <= buf1_rd_data;
        else
            rd_data <= buf0_rd_data;
        end if;
    end process mux_rd;
   
    update_buf0 : process(clk, wr_data, wr_addr, wr, rd_addr, lock)
    begin
        if(rising_edge(clk)) then
            if(lock = '0' and wr = '1') then
                buf0(to_integer(unsigned(wr_addr))) <= wr_data;
            end if;         
        end if;
        buf0_rd_data <= buf0(to_integer(unsigned(rd_addr)));  
    end process update_buf0;
    
    update_buf1 : process(clk, wr_data, wr_addr, wr, rd_addr, lock)
    begin
        if(rising_edge(clk)) then
            if(lock = '1' and wr = '1') then
                buf1(to_integer(unsigned(wr_addr))) <= wr_data;
            end if;          
        end if;
        buf1_rd_data <= buf1(to_integer(unsigned(rd_addr)));
    end process update_buf1;
end beh;
    