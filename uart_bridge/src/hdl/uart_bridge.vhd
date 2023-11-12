library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library unisim;
use unisim.vcomponents.all;

entity uart_bridge is
    generic(
        CLK_FREQUENCY_HZ : natural := 100e6;
        BAUDRATE_A : natural := 115200;
        BAUDRATE_B : natural := 115200
    );
    port(
        i_clk_p : in std_logic;
        i_clk_n : in std_logic;
        i_reset : in std_logic;
        i_rx_a : in std_logic;
        o_tx_a : out std_logic;
        i_rx_b : in std_logic;
        o_tx_b : out std_logic
    );
end entity uart_bridge;

architecture struct of uart_bridge is
    signal clk_no_buf : std_logic;
    signal clk : std_logic;
begin

    clk_buf_i : IBUFDS
        port map(
            I => i_clk_p,
            IB => i_clk_n,
            O => clk_no_buf
        );
        
    clk_bufg : BUFG
        port map(
            I => clk_no_buf,
            O => clk
        );

    bridge_ab : entity work.half_bridge
        generic map(
            CLK_FREQUENCY_HZ => CLK_FREQUENCY_HZ,
            BAUDRATE_RX => BAUDRATE_A,
            BAUDRATE_TX => BAUDRATE_B
        )
        port map(
            i_clk => clk,
            i_reset => i_reset,
            i_rx => i_rx_a,
            o_tx => o_tx_b
        );
        
    bridge_ba : entity work.half_bridge
        generic map(
            CLK_FREQUENCY_HZ => CLK_FREQUENCY_HZ,
            BAUDRATE_RX => BAUDRATE_B,
            BAUDRATE_TX => BAUDRATE_A
        )
        port map(
            i_clk => clk,
            i_reset => i_reset,
            i_rx => i_rx_b,
            o_tx => o_tx_a
        );
end struct;
