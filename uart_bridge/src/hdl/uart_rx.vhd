library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uart_rx is
    generic(
        CLK_FREQUENCY_HZ : natural := 100e6;
        BAUDRATE : natural := 115200
    );
    port(
        i_clk : in std_logic;
        i_reset : in std_logic;
        m_tvalid : out std_logic;
        m_tdata : out std_logic_vector(7 downto 0);
        i_rx : in std_logic
    );
end entity uart_rx;

architecture rtl of uart_rx is
    constant BAUD_PERIOD : natural := CLK_FREQUENCY_HZ/BAUDRATE;
    type states is (Idle, StartBit, DataBit);
    signal state : states;
    signal data_reg : std_logic_vector(7 downto 0);
    signal bit_cnt : natural range 0 to 7;
    signal baud_cnt : natural range 0 to BAUD_PERIOD - 1;
    signal rx : std_logic;
    signal valid : std_logic;
    
begin

    main : process(i_clk) is
    begin
        if rising_edge(i_clk) then
            if i_reset = '1' then
                state <= Idle;
                rx <= '1';
                valid <= '0';
            else
                rx <= i_rx;
                case state is
                    when Idle =>
                        if i_rx = '0' then
                            state <= StartBit;
                        end if;
                        bit_cnt <= 7;
                        baud_cnt <= BAUD_PERIOD/2 - 1;
                        valid <= '0';
                    when StartBit =>
                        if baud_cnt = 0 then
                            if rx = '0' then
                                state <= DataBit;
                                baud_cnt <= BAUD_PERIOD - 1;
                            else
                                state <= Idle;
                            end if;
                        else
                            baud_cnt <= baud_cnt - 1;
                        end if;
                    when DataBit =>
                        if baud_cnt = 0 then
                            data_reg <= rx & data_reg(7 downto 1);
                            if bit_cnt = 0 then
                                state <= Idle;
                                valid <= '1';
                            else
                                bit_cnt <= bit_cnt - 1;
                                baud_cnt <= BAUD_PERIOD - 1;
                            end if;
                        else
                            baud_cnt <= baud_cnt - 1;
                        end if;
                end case;
            end if;
        end if;
    end process;
    
    m_tvalid <= valid;
    m_tdata  <= data_reg;
    
end rtl;
