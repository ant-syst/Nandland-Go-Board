-- Testbench for LED Blinker
library IEEE;
use IEEE.std_logic_1164.all;

entity UART_TB is
end entity UART_TB;

architecture behave of UART_TB is

    constant c_CLK_PERIOD : time := 1 ns;
    signal r_Clock : std_logic := '0';
    signal r_Bits_DV : std_logic := '1';

begin
    r_Clock <= not r_Clock after c_CLK_PERIOD/2;
    r_Bits_DV <= '0' when r_Bits_DV = '1' and r_Clock = '1';

    UART_Inst : entity work.UART_Transmitter
    generic map (
        g_PERIOD      => 3
    )
    port map (
        i_Clk     => r_Clock,
        i_Bits    => "01010101",
        i_Bits_DV => r_Bits_DV,
        o_UART_TX => open
    );

    process is
    begin
        report "Starting Testbench...";

        wait for 0.1 us;

        assert false report "Test Complete" severity failure;
    end process;

end behave;
