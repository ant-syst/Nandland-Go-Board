-- Testbench for LED Blinker
library IEEE;
use IEEE.std_logic_1164.all;

entity UART_TB is
end entity UART_TB;

architecture behave of UART_TB is

    constant c_CLK_PERIOD : time := 1 ns;
    signal r_Clock : std_logic   := '0';
    signal r_UART : std_logic    := '1';
    signal r_Bits : std_logic_vector(7 downto 0);
    signal r_Period : std_logic    := '0';

begin

    r_Clock <= not r_Clock after c_CLK_PERIOD/2;
    r_Period <= not r_Period after c_CLK_PERIOD * 100;
    r_UART <= not r_UART after c_CLK_PERIOD * 10 when r_Period = '0';

    UART_Recv_Inst : entity work.UART_Receiver
    generic map (
        g_CLOCKS_PER_BIT => 10
    )
    port map (
        i_Clk         => r_Clock,
        i_UART_RX     => r_UART,
        o_Has_Failed  => open,
        o_Bits        => r_Bits,
        o_Bits_DV     => open
    );

    process is
    begin
        report "Starting Testbench...";

        wait for 0.15 us;

        if r_Bits = X"55" then
            report "Test Passed - Correct Byte Received" severity note;
        else
            report "Test Failed - Incorrect Byte Received" severity note;
        end if;

        assert false report "Test Complete" severity failure;
    end process;

end behave;
