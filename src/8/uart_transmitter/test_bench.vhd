-- Testbench for LED Blinker
library IEEE;
use IEEE.std_logic_1164.all;

entity UART_TB is
end entity UART_TB;

architecture behave of UART_TB is

    constant c_CLK_PERIOD : time := 1 ns;
    constant c_CLOCKS_PER_BIT : integer := 2;
    constant c_BIT_PERIOD : time := c_CLOCKS_PER_BIT * c_CLK_PERIOD;

    signal r_UART_TX  : std_logic := '0';
    signal r_Clock    : std_logic := '0';
    signal r_Bits_DV  : std_logic := '0';
    signal r_Bits     : std_logic_vector(7 downto 0) := "00000000";
begin
    r_Clock <= not r_Clock after c_CLK_PERIOD/2;

    UART_Inst : entity work.UART_Transmitter
    generic map (
        g_CLOCKS_PER_BIT      => 2
    )
    port map (
        i_Clk     => r_Clock,
        i_Bits    => r_Bits,
        i_Bits_DV => r_Bits_DV,
        o_UART_TX => r_UART_TX
    );

    process is
    begin
        report "Starting Testbench...";

        wait for c_BIT_PERIOD;

        r_Bits <= "01010101";
        r_Bits_DV <= '1';
        assert '1' = r_UART_TX;
        wait for c_BIT_PERIOD;

        -- start bit
        assert '0' = r_UART_TX;
        wait for c_BIT_PERIOD;

        -- transfered bits
        for idx in 0 to 7
        loop
            assert r_Bits(idx) = r_UART_TX;
            wait for c_BIT_PERIOD;
            r_Bits_DV <= '0';
        end loop;

        -- stop bit
        wait for c_BIT_PERIOD;
        assert r_UART_TX = '1';

        r_Bits <= "10101010";
        r_Bits_DV <= '1';
        assert '1' = r_UART_TX;
        wait for c_BIT_PERIOD;

        -- start bit
        assert '0' = r_UART_TX;
        wait for c_BIT_PERIOD;

        -- transfered bits
        for idx in 0 to 7
        loop
            assert r_Bits(idx) = r_UART_TX;
            wait for c_BIT_PERIOD;
            r_Bits_DV <= '0';
        end loop;

        -- stop bit
        wait for c_BIT_PERIOD;
        assert r_UART_TX = '1';

        assert false report "Test Complete" severity failure;
    end process;

end behave;
