-- UART TX Implementation
-- Requires high speed clk
-- and clk running at 16 times the baud rate
-- Generates asynchronous 8n1 tx stream
-- BaudReg needs to be set according to:
-- BaudReg = Fclk / (16 * Baud Rate) - 1
-- Baud rate timer is duplicated in RX and TX side to allow reseting of timers
-- whenever each direction desires.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uart_rx is
    generic(
        TIMER_WIDTH : natural := 16
    );
	port
	(
	    rst_n   : in std_logic;
        clk     : in std_logic;
        uart_rx : in std_logic; -- The asynchronous rx input
        data_read : in std_logic; -- Assert when reading data from buffer
        baudreg : in unsigned(TIMER_WIDTH - 1 downto 0);
        data_ready : out std_logic; -- Asserted when new data ready to load
        data_out : out std_logic_vector(7 downto 0); -- The byte deserialized
        overflow_err : out std_logic; -- data arrived before old data read from buffer. new data discarded
        frame_err : out std_logic
	);
end entity;

architecture beh of uart_rx is
	type sm_type is (idle, start, shifting, stop);
	signal current_state, next_state : sm_type := idle;
	signal rx_shift_reg : std_logic_vector(7 downto 0) := (others => '1');
	signal rx_bit_cnt : unsigned(3 downto 0) := (others => '0');
	signal rx_bitclk_cnt : unsigned(3 downto 0) := (others => '0');
	signal rx_clk_reset : std_logic := '0';
	signal clk16_timer : unsigned(TIMER_WIDTH - 1 downto 0) := (others => '1');
  signal clk16 : std_logic;
  signal fr_err : std_logic := '0';
  signal of_err : std_logic := '0';
  signal data_rdy : std_logic := '0';
begin
    -- Module begin
    rx_clk_reset <= '1' when (current_state = idle and uart_rx = '1') else '0';
    overflow_err <= of_err;
    frame_err <= fr_err;
    data_ready <= data_rdy;

    update_rx_clk16 : process(rst_n, clk, rx_clk_reset, baudreg, clk16_timer)
    begin
        if(rst_n = '0') then
            clk16_timer <= baudreg;
            clk16 <= '0';
        elsif(rising_edge(clk)) then
            clk16 <= '0';
            if(rx_clk_reset = '1') then
              clk16_timer <= baudreg;
            elsif(clk16_timer = to_unsigned(0, TIMER_WIDTH)) then
                clk16_timer <= baudreg;
            else
                clk16_timer <= clk16_timer - 1;
            end if;
            if(clk16_timer = to_unsigned(1, TIMER_WIDTH)) then
              clk16 <= '1';
            end if;
        end if;
    end process update_rx_clk16;

    update_rx_bitclk : process(rst_n, clk, rx_clk_reset, rx_bitclk_cnt, clk16)
    begin
        if(rst_n = '0') then
            rx_bitclk_cnt <= (others => '0');  -- default the count to 0
        elsif(rising_edge(clk)) then
            if(rx_clk_reset = '1') then
                rx_bitclk_cnt <= to_unsigned(15,4);
            elsif(clk16 = '1') then
                if(rx_bitclk_cnt = to_unsigned(0, 4)) then
                    rx_bitclk_cnt <= to_unsigned(15,4);
                else
                    rx_bitclk_cnt <= rx_bitclk_cnt - 1;
                end if;
            end if;
        end if;
    end process update_rx_bitclk;

    update_bit_cnt : process(rst_n, clk, current_state, rx_bit_cnt, clk16)
    begin
        if(rst_n = '0') then
            rx_bit_cnt <= (others => '0');
        elsif(rising_edge(clk)) then
            if(current_state = idle) then
                rx_bit_cnt <= (others => '0');
            elsif(current_state = shifting) then
              if(clk16 = '1')then
                if(rx_bitclk_cnt = to_unsigned(0, 4)) then
                  rx_bit_cnt <= rx_bit_cnt + 1;
                end if;
              end if;
            end if;
        end if;
    end process update_bit_cnt;

    update_shift : process(rst_n, clk, clk16, current_state, rx_shift_reg, rx_bitclk_cnt, uart_rx)
    begin
        if(rst_n = '0') then
            rx_shift_reg <= (others => '0');
        elsif(rising_edge(clk)) then
          if(clk16 = '1')then
            if (current_state = shifting and rx_bitclk_cnt = to_unsigned(9, 4) and clk16 = '1') then
                rx_shift_reg <= uart_rx & rx_shift_reg(rx_shift_reg'high downto 1);
            end if;
          end if;
        end if;
    end process update_shift;

    update_outs : process(rst_n, clk, of_err, fr_err, rx_shift_reg, current_state, data_read, rx_bitclk_cnt, clk16, uart_rx)
    begin
        if(rst_n = '0') then
            of_err <= '0';
            fr_err <= '0';
            data_out <= (others => '0');
        elsif(rising_edge(clk)) then
            if(clk16 = '1') then
              if(current_state = stop and rx_bitclk_cnt = to_unsigned(9, 4)) then
                  -- Update overflow error
                  if(data_rdy = '1') then
                      of_err <= '1';
                  else -- latch the data
                      data_out <= rx_shift_reg;
                      data_rdy <= '1';
                  end if;
                 -- framing error when stop bit is read as '0'
                  if(uart_rx = '0') then
                      fr_err <= '1';
                  end if;
              end if;
            elsif(data_read = '1') then
                data_rdy <= '0';
                of_err <= '0';
                fr_err <= '0';
            end if;
        end if;
    end process update_outs;

    update_state : process(rst_n, clk, next_state)
    begin
        if(rst_n = '0') then
            current_state <= idle;
        elsif (rising_edge(clk)) then
            current_state <= next_state;
        end if;
    end process update_state;

    calc_state : process(current_state, rx_bit_cnt, uart_rx, clk16, rx_bitclk_cnt)
    begin
        case current_state is
            when idle =>
                next_state <= idle;
                if(uart_rx = '0') then
                    next_state <= start;
                end if;
            when start =>
                next_state <= start;
                if(clk16 = '1') then
                  if(rx_bitclk_cnt = to_unsigned(0, 4)) then
                      next_state <= shifting;
                  end if;
              end if;
            when shifting =>
                next_state <= shifting;
                if(clk16 = '1') then
                  if(rx_bit_cnt = to_unsigned(7, 3) and rx_bitclk_cnt = to_unsigned(0, 4)) then
                      next_state <= stop;
                  end if;
                end if;
            when stop =>
                next_state <= stop;
                if(clk16 = '1') then
                  if(rx_bitclk_cnt = to_unsigned(8, 4)) then
                    next_state <= idle;
                  end if;
                end if;
            when others => next_state <= idle;
        end case;
    end process calc_state;
end beh;
