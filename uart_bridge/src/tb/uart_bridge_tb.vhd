library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all
use std.textio.all;

entity uart_bridge_tb is
    generic(
        CLK_FREQUENCY_HZ : natural := 100e6;
        BAUDRATE_A : natural := 115200;
        BAUDRATE_B : natural := 115200;
        TEST_SIZE  : natural := 32768
    );
end entity uart_bridge_tb;

architecture test of uart_bridge_tb is
    constant CLK_PERIOD : time := 1.0e9/real(CLK_FREQUENCY_HZ) * 1.0 ns;
    constant BIT_PERIOD : time := 1.0e9/real(BAUDRATE_A) * 1.0 ns;
    signal i_clk : std_logic := '0';
    signal i_reset : std_logic := '0';
    signal i_rx_a : std_logic := '1';
    signal o_tx_a : std_logic;
    signal line_b : std_logic;
begin

    i_clk <= not i_clk after CLK_PERIOD/2;
    i_reset <= '1' after CLK_PERIOD, '0' after CLK_PERIOD * 2;
    
    transmit : process
        variable seed1 : natural := 23;
        variable seed2 : natural := 32;
        variable rnd : real;
        variable data : unsigned(7 downto 0);
    begin
        wait for CLK_PERIOD*10;
        for i in 0 to TEST_SIZE - 1 loop
            uniform(seed1, seed2, rnd);
            data := to_unsigned(integer(rnd*255.0), 8);
            i_rx_a <= '0';
            wait for BIT_PERIOD;
            for b in 0 to 7 loop
                i_rx_a := data(b);
                wait for BIT_PERIOD;
            end loop;
            i_rx_a := '1';
            wait for BIT_PERIOD;
            --
        end loop;
        wait;
    end process;
    

    uut : entity work.uart_bridge
        generic map(
            CLK_FREQUENCY_HZ => CLK_FREQUENCY_HZ,
            BAUDRATE_A => BAUDRATE_A,
            BAUDRATE_B => BAUDRATE_B
        )
        port map(
            i_clk => i_clk,
            i_reset => i_reset,
            i_rx_a => i_rx_a,
            o_tx_a => o_tx_a,
            i_rx_b => line_b,
            o_tx_b => line_b
        );
        
    
end rtl;
