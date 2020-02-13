-- Testbench for LED Blinker
library IEEE;
use IEEE.std_logic_1164.all;

entity UART_TB is
end entity UART_TB;

architecture behave of UART_TB is

    constant c_CLK_PERIOD : time  := 1 ns;
    signal r_Clock : std_logic    := '0';
    signal r_Switch_1 : std_logic := '0';
    signal r_Switch_2 : std_logic := '0';

begin
    r_Clock <= not r_Clock after c_CLK_PERIOD/2;
    r_Switch_1 <= not r_Switch_1 after c_CLK_PERIOD * 25;

    UART_Inst : entity work.UART_Transmitter
    generic map (
        g_PERIOD      => 3
    )
    port map (
        i_Clk         => r_Clock,

        i_Switch_1    => r_Switch_1,
        i_Switch_2    => r_Switch_2,

        o_UART_TX     => open,

        o_LED_1       => open,
        o_LED_2       => open,
        o_LED_3       => open,
        o_LED_4       => open
    );

    process is
    begin
        report "Starting Testbench...";

        wait for 0.1 us;

        assert false report "Test Complete" severity failure;
    end process;

end behave;
