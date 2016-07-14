-- Ins and Outs overlap at the moment, i.e., there
-- are only 32 total io, and the ins will reflect
-- the state of the outs as well as inputs.
-- Expects 100MHz clock

-- Control reg bit 16 is component ready signal
-- Control reg bit 0 is software reset
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity btint_controller is
    generic(
        PP_BUF_ADDR_WIDTH : natural := 6
    );
	port
	(
	    rst_n   : in std_logic;
        clk     : in std_logic;
        pp_buf_lock : in std_logic; -- Identifies which buffer is being written to by rx component
        pp_buf_sel : out std_logic; -- The buffer we are reading from
        pp_addr : out std_logic_vector(PP_BUF_ADDR_WIDTH - 1 downto 0); -- PP Buffer address bus
        pp_data : in std_logic_vector(7 downto 0); -- PP Buffer data bus
        pkt_tx_data : out std_logic_vector(31 downto 0);
        pkt_tx_we : out std_logic;
        pkt_tx_busy : in std_logic;
        addr_wr : in std_logic_vector(15 downto 0);
        idata : in std_logic_vector(31 downto 0);
        wr : in std_logic;
        wr_strobe : in std_logic_vector(3 downto 0);
        addr_rd : in std_logic_vector(15 downto 0);
        odata : out std_logic_vector(31 downto 0);
        sync : in std_logic
	);
end entity;

architecture beh of btint_controller is
	type sm_type is (start, send_qry_g10, send_qry_g20, send_qry_g300, send_qry_data, wait_for_resp, parse_resp_cmd, parse_cal1, parse_data1, parse_32_1, parse_32_2, parse_32_3, parse_32_4, latch_reg, wait_for_sync);
	signal current_state, next_state, prev_state, new_prev_state : sm_type := start;
    signal pp_buf_lock_s : std_logic := '0';
    signal int_rst_n : std_logic := '1';
    signal timed_out : std_logic := '0';
    signal timeout_cnt : unsigned(2 downto 0) := (others => '0');
    signal timeout_tmr : unsigned(31 downto 0) := (others => '0');
    signal reg_add : std_logic_vector(2 downto 0) := (others => '0');
    signal reg_32_tmp : std_logic_vector(31 downto 0) := (others => '0');
    signal pkt_tx_we_s : std_logic;
    signal sync_prev, sync_pulse, clear_sync : std_logic;

    -- Registers
    signal reg_control_upper : std_logic_vector(15 downto 0) := (others => '0');
    signal reg_control_lower : std_logic_vector(15 downto 0) := (others => '0');
    signal reg_gain_10 : std_logic_vector(31 downto 0) := (others => '0');
    signal reg_gain_20 : std_logic_vector(31 downto 0) := (others => '0');
    signal reg_gain_300 : std_logic_vector(31 downto 0) := (others => '0');
    signal reg_outs : std_logic_vector(31 downto 0) := (others => '0');
    signal reg_ins : std_logic_vector(31 downto 0) := (others => '0');
    signal reg_adc_value : std_logic_vector(31 downto 0) := (others => '0');
    signal reg_err_cnt : std_logic_vector(31 downto 0) := (others => '0');
    signal byte_index : integer;

    -- Constants
    constant TIMEOUT_RETRIES : unsigned(2 downto 0) := to_unsigned(2,3);
    constant TIMEOUT_COUNT_VAL_DATA : unsigned(31 downto 0) := to_unsigned(400000, 32);
    constant TIMEOUT_COUNT_VAL_ST : unsigned (31 downto 0) := to_unsigned(200000000, 32);
    constant PKT_QRY_CAL_G10 : std_logic_vector(31 downto 0) := x"08010000";
    constant PKT_QRY_CAL_G20 : std_logic_vector(31 downto 0) := x"08020000";
    constant PKT_QRY_CAL_G300 : std_logic_vector(31 downto 0) := x"08030000";
    constant PKT_SETQRY_DATA : std_logic_vector(31 downto 0) := x"03000000";
    constant PKT_QRY_DATA_CMD : std_logic_vector(7 downto 0) := x"02";
    constant MAGIC_NUM_VAL : std_logic_vector(31 downto 0) := x"12345678";

    -- addresses
    constant REG_MAGIC_ADD : std_logic_vector(15 downto 0) := x"0000";
    constant REG_CONTROL_ADD : std_logic_vector(15 downto 0) := x"0010";
    constant REG_GAIN10_ADD : std_logic_vector(15 downto 0) := x"0100";
    constant REG_GAIN20_ADD : std_logic_vector(15 downto 0) := x"0104";
    constant REG_GAIN300_ADD : std_logic_vector(15 downto 0) := x"0108";
    constant REG_OUTS_ADD : std_logic_vector(15 downto 0) := x"0200";
    constant REG_INS_ADD : std_logic_vector(15 downto 0) := x"0300";
    constant REG_ADCVAL_ADD : std_logic_vector(15 downto 0) := x"0400";
    constant REG_ERRCNT_ADD : std_logic_vector(15 downto 0) := x"0500";

begin
    int_rst_n <= '0' when (rst_n = '0' or current_state = start) else '1';
    pkt_tx_we <= pkt_tx_we_s;
    pkt_tx_we_s <= '1' when (((current_state = send_qry_g10) or
                           (current_state = send_qry_g20) or
                           (current_state = send_qry_g300) or
                           (current_state = send_qry_data)) and (pkt_tx_busy = '0')) else '0';
    clear_sync <= '1' when (current_state = wait_for_sync and sync_pulse = '1') else '0';

    -- Update sync edge detect
    sync_edge_det : process(int_rst_n, clk, sync, sync_prev)
    begin
        if(int_rst_n = '0') then
            sync_pulse <= '0';
        elsif(rising_edge(clk)) then
            sync_prev <= sync;
            if(sync_prev = '0' and sync = '1') then
                sync_pulse <= '1';
            elsif(clear_sync = '1') then
                sync_pulse <= '0';
            end if;
        end if;
    end process sync_edge_det;

    -- Reading registers mux
    reg_read : process(addr_rd, reg_control_lower, reg_control_upper, reg_gain_10, reg_gain_20, reg_gain_300, reg_outs, reg_ins, reg_adc_value, reg_err_cnt)
    begin
        case addr_rd is
            when REG_MAGIC_ADD =>
              odata <= MAGIC_NUM_VAL;
            when REG_CONTROL_ADD =>
                odata <= reg_control_upper & reg_control_lower;
            when REG_GAIN10_ADD =>
                odata <= reg_gain_10;
            when REG_GAIN20_ADD =>
                odata <= reg_gain_20;
            when REG_GAIN300_ADD =>
                odata <= reg_gain_300;
            when REG_OUTS_ADD =>
                odata <= reg_outs;
            when REG_INS_ADD =>
                odata <= reg_ins;
            when REG_ADCVAL_ADD =>
                odata <= reg_adc_value;
            when REG_ERRCNT_ADD =>
                odata <= reg_err_cnt;
            when others =>
                odata <= (others => '0');
        end case;
    end process reg_read;

    -- Writing registers process
    reg_write : process(int_rst_n, clk, addr_wr, wr, idata)
    begin
        if(int_rst_n = '0') then
            reg_control_lower <= (others => '0');
            reg_outs <= (others => '0');
        elsif(rising_edge(clk)) then
            if(wr = '1') then
                case addr_wr is
                    when REG_CONTROL_ADD =>
                        for byte_index in 0 to 1 loop
                          if (wr_strobe(byte_index) = '1') then
                            -- Respective byte enables are asserted as per write strobes
                            -- slave registor 0
                            reg_control_lower(byte_index*8+7 downto byte_index*8) <= idata(byte_index*8+7 downto byte_index*8);
                          end if;
                        end loop;
                    when REG_OUTS_ADD =>
                        for byte_index in 0 to 3 loop
                            if ( wr_strobe(byte_index) = '1' ) then
                                -- Respective byte enables are asserted as per write strobes
                                -- slave registor 0
                                reg_outs(byte_index*8+7 downto byte_index*8) <= idata(byte_index*8+7 downto byte_index*8);
                            end if;
                        end loop;
                    when others =>
                        -- nope, don't write to readonly addresses
                end case;
            else
                reg_control_lower <= reg_control_lower;
                reg_outs <= reg_outs;
            end if;
        end if;
    end process reg_write;

    -- TX Packet muxing
    tx_pack_sel : process(current_state, reg_outs)
    begin
        case current_state is
            when send_qry_g10 =>
                pkt_tx_data <= PKT_QRY_CAL_G10;
            when send_qry_g20 =>
                pkt_tx_data <= PKT_QRY_CAL_G20;
            when send_qry_g300 =>
                pkt_tx_data <= PKT_QRY_CAL_G300;
            when send_qry_data =>
                pkt_tx_data <= PKT_SETQRY_DATA or (x"00" & reg_outs(7 downto 0) & x"0000");
            when others =>
                pkt_tx_data <= (others => '0');
        end case;
    end process tx_pack_sel;

    -- Temp data latching
    latch_32 : process(int_rst_n, clk, current_state, pp_data)
    begin
        if(int_rst_n = '0') then
            reg_32_tmp <= (others => '0');
        elsif(rising_edge(clk))then
            case current_state is
                when parse_32_1 =>
                    reg_32_tmp(7 downto 0) <= pp_data;
                when parse_32_2 =>
                    reg_32_tmp(15 downto 8) <= pp_data;
                when parse_32_3 =>
                    reg_32_tmp(23 downto 16) <= pp_data;
                when parse_32_4 =>
                    reg_32_tmp(31 downto 24) <= pp_data;
                when others =>
                    reg_32_tmp <= reg_32_tmp;
            end case;
        end if;
    end process latch_32;

    -- Internal register writing from packet parsing, etc.
    upd_int_reg : process(int_rst_n, clk, current_state, reg_add, pp_data, timed_out, prev_state, reg_32_tmp, reg_err_cnt, reg_control_upper)
    begin
        if(int_rst_n = '0') then
            reg_gain_10 <= (others => '0');
            reg_gain_20 <= (others => '0');
            reg_gain_300 <= (others => '0');
            reg_ins <= (others => '0');
            reg_adc_value <= (others => '0');
            reg_control_upper <= (others => '0');
            reg_err_cnt <= (others => '0');
            reg_add <= (others => '0');
        elsif (rising_edge(clk)) then
            reg_control_upper <= reg_control_upper; -- Hold by default
            reg_gain_10 <= reg_gain_10;
            reg_gain_20 <= reg_gain_20;
            reg_gain_300 <= reg_gain_300;
            reg_adc_value <= reg_adc_value;
            reg_err_cnt <= reg_err_cnt;
            reg_ins <= reg_ins;
            reg_add <= reg_add;

            case current_state is
                when wait_for_resp =>
                    if(timed_out = '1') then
                        reg_err_cnt <= std_logic_vector(unsigned(reg_err_cnt) + 1);
                    end if;
                when parse_resp_cmd =>
                    if(pp_data /= PKT_QRY_CAL_G10(31 downto 24) and pp_data /= PKT_QRY_DATA_CMD) then
                        reg_err_cnt <= std_logic_vector(unsigned(reg_err_cnt) + 1);
                    end if;
                when parse_data1 =>
                    reg_ins <= x"000000" & pp_data;
                    reg_add <= b"110";
                when parse_cal1 =>
                    if(pp_data = PKT_QRY_CAL_G10(23 downto 16)) then
                        reg_add <= b"001";
                    elsif(pp_data = PKT_QRY_CAL_G20(23 downto 16)) then
                        reg_add <= b"010";
                    elsif(pp_data = PKT_QRY_CAL_G300(23 downto 16)) then
                        reg_add <= b"011";
                    else
                        reg_add <= (others => '0'); -- Shouldn't ever happen
                    end if;
                when latch_reg =>
                    case reg_add is
                        when b"001" =>
                            reg_gain_10 <= reg_32_tmp;
                        when b"010" =>
                            reg_gain_20 <= reg_32_tmp;
                        when b"011" =>
                            reg_gain_300 <= reg_32_tmp;
                        when b"110" =>
                            reg_adc_value <= reg_32_tmp;
                        when others =>
                            -- nope, don't save to invalid address
                    end case;
                when send_qry_data =>
                    -- After we get done reading the cal values we are in a run state
                    reg_control_upper(0) <= '1';
                when others =>

            end case;
        end if;
    end process upd_int_reg;

    calc_pp_addr : process(current_state)
    begin
        case current_state is
            when parse_resp_cmd =>
                pp_addr <= (others => '0');
            when parse_data1 | parse_cal1 =>
                pp_addr <= b"000001";
            when parse_32_1 =>
                pp_addr <= b"000010";
            when parse_32_2 =>
                pp_addr <= b"000011";
            when parse_32_3 =>
                pp_addr <= b"000100";
            when parse_32_4 =>
                pp_addr <= b"000101";
            when others =>
                pp_addr <= (others => '0');
        end case;
    end process calc_pp_addr;

    upd_timeout : process(int_rst_n, clk, current_state, timeout_cnt, timeout_tmr, timed_out)
    begin
        if(int_rst_n = '0') then
            timeout_tmr <= TIMEOUT_COUNT_VAL_ST;
            timed_out <= '0';
            timeout_cnt <= (others => '0');
        elsif (rising_edge(clk)) then
            case current_state is
                when send_qry_g10 | send_qry_g20 | send_qry_g300 =>
                    timeout_tmr <= TIMEOUT_COUNT_VAL_ST;
                    timed_out <= '0';
                when send_qry_data =>
                    timeout_tmr <= TIMEOUT_COUNT_VAL_DATA;
                    timed_out <= '0';
                when wait_for_resp =>
                    if(timeout_tmr > to_unsigned(0,24)) then
                        timeout_tmr <= timeout_tmr - 1;
                    else -- we timed out
                        if(timed_out = '0') then
                            timed_out <= '1';
                            timeout_cnt <= timeout_cnt + 1;
                        end if;
                    end if;
                when others =>
                    timeout_tmr <= TIMEOUT_COUNT_VAL_ST;
                    timed_out <= '0';
            end case;
        end if;
    end process upd_timeout;

    update_pp_buf_sig : process(int_rst_n, clk, pp_buf_lock, pp_buf_lock_s)
    begin
        if(int_rst_n = '0') then
            pp_buf_lock_s <= pp_buf_lock;
            pp_buf_sel <= pp_buf_lock;
        elsif(rising_edge(clk)) then
            pp_buf_lock_s <= pp_buf_lock;
            if(current_state = wait_for_resp) then
                pp_buf_sel <= not pp_buf_lock;
            end if;
        end if;
    end process update_pp_buf_sig;

    update_state : process(rst_n, clk, next_state, new_prev_state)
    begin
        if(rst_n = '0') then
            current_state <= start;
            prev_state <= start;
        elsif(rising_edge(clk)) then
            current_state <= next_state;
            prev_state <= new_prev_state;
        end if;
    end process update_state;

    calc_state : process(current_state, prev_state, pp_buf_lock_s, pp_buf_lock, timed_out, timeout_cnt, reg_control_lower, pkt_tx_we_s, pp_data, sync_pulse)
    begin
        next_state <= current_state; -- Hold state by default
        new_prev_state <= prev_state;

        if(reg_control_lower(0) = '1') then
            next_state <= start;
        else
            case current_state is
                when start =>
                    next_state <= send_qry_g10;
                when send_qry_g10 =>
                    if(pkt_tx_we_s = '1') then
                        next_state <= wait_for_resp;
                        new_prev_state <= send_qry_g10;
                    end if;
                when send_qry_g20 =>
                    if(pkt_tx_we_s = '1') then
                        next_state <= wait_for_resp;
                        new_prev_state <= send_qry_g20;
                    end if;
                when send_qry_g300 =>
                    if(pkt_tx_we_s = '1') then
                        next_state <= wait_for_resp;
                        new_prev_state <= send_qry_g300;
                    end if;
                when send_qry_data =>
                    if(pkt_tx_we_s = '1') then
                        next_state <= wait_for_resp;
                        new_prev_state <= send_qry_data;
                    end if;
                when wait_for_resp =>
                    if(pp_buf_lock_s /= pp_buf_lock) then
                        next_state <= parse_resp_cmd;
                    elsif(timed_out = '1') then
                      --  if(timeout_cnt >= TIMEOUT_RETRIES) then   -- Completely lost coms
                      --      next_state <= start;
                      --  else                        -- Missed a packet
                            next_state <= prev_state;
                      --  end if;
                    end if;
                when parse_resp_cmd =>
                    if(pp_data = PKT_QRY_CAL_G10(31 downto 24)) then
                        next_state <= parse_cal1;
                    elsif(pp_data = PKT_QRY_DATA_CMD) then
                        next_state <= parse_data1;
                    else
                        next_state <= prev_state;
                    end if;
                when parse_cal1 =>
                    next_state <= parse_32_1;
                when parse_data1 =>
                    next_state <= parse_32_1;
                when parse_32_1 =>
                    next_state <= parse_32_2;
                when parse_32_2 =>
                    next_state <= parse_32_3;
                when parse_32_3 =>
                    next_state <= parse_32_4;
                when parse_32_4 =>
                    next_state <= latch_reg;
                when latch_reg =>
                    case prev_state is
                        when send_qry_g10 =>
                            next_state <= send_qry_g20;
                        when send_qry_g20 =>
                            next_state <= send_qry_g300;
                        when send_qry_g300 =>
                            next_state <= send_qry_data;
                        when others =>
                            next_state <= wait_for_sync;
                    end case;
                when wait_for_sync =>
                    if(sync_pulse = '1') then
                        next_state <= send_qry_data;
                    end if;
                when others =>
                    next_state <= start;
            end case;
        end if;
    end process calc_state;
end beh;
