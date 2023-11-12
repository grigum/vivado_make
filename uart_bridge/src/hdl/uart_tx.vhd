library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uart_tx is
    generic(
        CLK_FREQUENCY_HZ : natural := 100e6;
        BAUDRATE : natural := 115200
    );
    port(
        i_clk : in std_logic;
        i_reset : in std_logic;
        s_tvalid : in std_logic;
        s_tdata : in std_logic_vector(7 downto 0);
        s_tready : out std_logic;
        o_tx : out std_logic
    );
end entity uart_tx;

architecture rtl of uart_tx is
    constant BAUD_PERIOD : natural := CLK_FREQUENCY_HZ/BAUDRATE;
    type states is (Idle, StartBit, DataBit, StopBit);
    signal state : states;
    signal data_reg : std_logic_vector(7 downto 0);
    signal bit_cnt : natural range 0 to 7;
    signal baud_cnt : natural range 0 to BAUD_PERIOD - 1;
    
begin

    main : process(i_clk) is
    begin
        if rising_edge(i_clk) then
            if i_reset = '1' then
                state <= Idle;
            else
                case state is
                    when Idle =>
                        if s_tvalid = '1' then
                            data_reg <= s_tdata;
                            state <= StartBit;
                        end if;
                        bit_cnt <= 7;
                        baud_cnt <= BAUD_PERIOD - 1;
                    when StartBit | StopBit =>
                        if baud_cnt = 0 then
                            if state = StartBit then
                                state <= DataBit;
                            else
                                state <= Idle;
                            end if;
                            baud_cnt <= BAUD_PERIOD - 1;
                        else
                            baud_cnt <= baud_cnt - 1;
                        end if;
                    when DataBit =>
                        if baud_cnt = 0 then
                            if bit_cnt = 0 then
                                state <= StopBit;
                            else
                                data_reg <= '0' & data_reg(7 downto 1);
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
    
    s_tready <= '1' when state = Idle else '0';
    tx_assign : with state select
        o_tx <= '0' when StartBit,
                data_reg(0) when DataBit,
                '1' when others;
                
    
end rtl;
