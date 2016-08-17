-- Debounces an input signal
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sig_delay is
	generic (
		CLOCK_RATE : natural := 100000000; -- The frequency of the input clock
		DELAY_TIME_INV : natural := 5; -- The frequency of a signal with period 
		                                -- delay. 5Hz = 200ms of delay
        NUM_TIMER_BITS : natural := 32
	);
	port 
	(
        clk				             : in std_logic;
		input						 : in std_logic;
		output      				 : out std_logic
	);
end entity;

architecture beh of sig_delay is
	type smtype is (idle, dly);
	signal current_state, next_state : smtype := idle;
	signal reg_out : std_logic := '0';
	signal tmr_cnt : unsigned(NUM_TIMER_BITS - 1 downto 0) := (others => '0');
	signal tmr_per : unsigned(NUM_TIMER_BITS - 1 downto 0) := to_unsigned(CLOCK_RATE / DELAY_TIME_INV, NUM_TIMER_BITS);
begin
    output <= reg_out;

    update_reg : process(clk, current_state, input)
    begin
        if(rising_edge(clk)) then
            if(current_state = dly)then 
                if(tmr_cnt = to_unsigned(0, NUM_TIMER_BITS)) then
                    reg_out <= input;
                end if;
            end if;
        end if;
    end process update_reg;

	update_timer : process (clk, current_state, input, reg_out, tmr_cnt)
	begin
	    if(rising_edge(clk)) then
	        if(current_state = idle AND input /= reg_out) then
	            tmr_cnt <= tmr_per;
	        elsif(current_state = dly) then
	            if(tmr_cnt >= to_unsigned(0, NUM_TIMER_BITS)) then
	                tmr_cnt <= tmr_cnt - 1;
	            end if;
	        end if;
	    end if;
    end process update_timer;
    
    update_state : process(clk, next_state)
    begin 
        if(rising_edge(clk)) then
            current_state <= next_state;
        end if;
    end process update_state;
    
    calc_state : process(current_state, input, reg_out, tmr_cnt)
    begin
        next_state <= current_state; -- hold by default
        if(current_state = idle) then
            if(input /= reg_out) then
                next_state <= dly;
            end if;
        else
            if(tmr_cnt <= to_unsigned(0, NUM_TIMER_BITS)) then
                next_state <= idle;
            end if;            
        end if;    
    end process calc_state;
end beh;

