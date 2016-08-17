-- Debounces an input signal
library ieee;
use ieee.std_logic_1164.all;
use work.reduction_pkg.all;

entity inp_deb is
	generic (
		NUM_STAGES : integer := 3
	);
	port 
	(
        clk				             : in std_logic;
		input						 : in std_logic;
		output      				 : out std_logic
	);
end entity;

architecture beh of inp_deb is
	signal ff_pack : std_logic_vector(NUM_STAGES - 1 downto 0);
	signal filt_j, filt_k, filt_q : std_logic;
begin
	process (clk)
	begin
		if (rising_edge(clk)) then
				-- JKFF for the filtered output
				if(filt_j = '1' and filt_k = '0') then
					filt_q <= '1';
				elsif (filt_j = '0' and filt_k = '1') then
					filt_q <= '0';
				elsif(filt_j = '0' and filt_k = '0') then
					filt_q <= filt_q;
				end if;
				
				ff_pack(NUM_STAGES - 1 downto 1) <= ff_pack((NUM_STAGES - 2) downto 0);
				
				-- Load new data into the first stage
				ff_pack(0) <= input;				
		end if;
	end process;
					
	-- Make a big AND gate for the filter
	filt_j <= red_and(ff_pack);
	-- and a big BAND gate
	filt_k <= red_and(not ff_pack);
	
	-- Outputs 
	output <= filt_q;
end beh;
