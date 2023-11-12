library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity half_bridge is
    generic(
        CLK_FREQUENCY_HZ : natural := 100e6;
        BAUDRATE_RX : natural := 115200;
        BAUDRATE_TX : natural := 115200
    );
    port(
        i_clk : in std_logic;
        i_reset : in std_logic;
        i_rx : in std_logic;
        o_tx : out std_logic
    );
end entity half_bridge;

architecture struct of half_bridge is
    component fifo is
        port(
            s_aclk : in std_logic;
            s_aresetn : in std_logic;
            s_axis_tvalid : in std_logic;
            s_axis_tdata  : in std_logic_vector(7 downto 0);
            s_axis_tready : out std_logic;
            m_axis_tvalid : out std_logic;
            m_axis_tdata  : out std_logic_vector(7 downto 0);
            m_axis_tready : in std_logic
        );
    end component fifo;
    
    signal rx_tdata : std_logic_vector(7 downto 0);
    signal rx_tvalid : std_logic;
    signal tx_tdata : std_logic_vector(7 downto 0);
    signal tx_tvalid : std_logic;
    signal tx_tready : std_logic;
    signal resetn : std_logic;
    
begin

    receiver : entity work.uart_rx 
        generic map(
            CLK_FREQUENCY_HZ => CLK_FREQUENCY_HZ,
            BAUDRATE => BAUDRATE_RX
        )
        port map(
            i_clk => i_clk,
            i_reset => i_reset,
            m_tvalid => rx_tvalid,
            m_tdata => rx_tdata,
            i_rx => i_rx
        );
        
    resetn <= not i_reset;
        
    buf : fifo
        port map(
            s_aclk => i_clk,
            s_aresetn => resetn,
            s_axis_tvalid => rx_tvalid,
            s_axis_tdata => rx_tdata,
            s_axis_tready => open,
            m_axis_tvalid => tx_tvalid,
            m_axis_tdata => tx_tdata,
            m_axis_tready => tx_tready
        );
    
    transmitter : entity work.uart_tx
        generic map(
            CLK_FREQUENCY_HZ => CLK_FREQUENCY_HZ,
            BAUDRATE => BAUDRATE_TX
        )
        port map(
            i_clk => i_clk,
            i_reset => i_reset,
            s_tvalid => tx_tvalid,
            s_tdata => tx_tdata,
            s_tready => tx_tready,
            o_tx => o_tx
        );
end struct;
