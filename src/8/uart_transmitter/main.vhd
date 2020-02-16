library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity UART is
    port (
        i_Clk     : in std_logic;
        i_UART_RX : in std_logic;
        o_UART_TX : out std_logic
    );
end entity UART;

architecture RTL of UART is

    signal r_UART_TX    : std_logic := '0';
    signal r_Bits       : std_logic_vector(7 downto 0) := "00110101";
    signal r_Bits_DV    : std_logic := '0';
    signal r_Has_Failed : std_logic := '0';

begin

    -- clock : 25000000 cycles / 1 second
    -- 115200 bauds / 1 second => 115200 bits / 1 second
    -- baud duration in cycles: 25000000/115200 : 217 cycles

    UART_Receiver_Inst : entity work.UART_Receiver
    generic map (
        g_CLOCKS_PER_BIT => 217
    )
    port map (
        i_Clk        => i_Clk,
        i_UART_RX    => i_UART_RX,
        o_Bits       => r_Bits,
        o_Bits_DV    => r_Bits_DV,
        o_Has_Failed => r_Has_Failed
    );

    UART_Transmitter_Inst : entity work.UART_Transmitter
    generic map (
        g_CLOCKS_PER_BIT => 217
    )
    port map (
        i_Bits    => r_Bits,
        i_Bits_DV => r_Bits_DV,
        i_Clk     => i_Clk,
        o_UART_TX => r_UART_TX
    );

    o_UART_TX <= r_UART_TX;

end
architecture RTL;
