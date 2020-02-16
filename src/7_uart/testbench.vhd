-- Testbench for LED Blinker
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity UART_TB is
end entity UART_TB;

architecture behave of UART_TB is

    constant c_CLOCK_PERIOD : time := 1 ns;

    -- Clock per bits
    constant c_CLOCKS_PER_BIT : integer := 4;

    -- Time to send one bit : c_CLOCKS_PER_BIT * c_CLOCK_PERIOD
    constant c_BIT_PERIOD : time := 4 ns;

    signal r_Clock   : std_logic := '0';
    signal r_UART    : std_logic := '1';
    signal r_Bits    : std_logic_vector(7 downto 0);
    signal r_Bits_DV : std_logic := '1';

    procedure Send_Bits
    (
        i_Bits        : in  std_logic_vector(7 downto 0);
        signal o_UART : out std_logic
    )
    is
    begin
        -- Send Start Bit
        o_UART <= '0';
        wait for c_BIT_PERIOD;

        -- Send Data Byte
        for ii in 0 to (i_Bits'length-1) loop
            o_UART <= i_Bits(ii);
            wait for c_BIT_PERIOD;
        end loop;  -- ii

        -- Send Stop Bit
        o_UART <= '1';
        wait for c_BIT_PERIOD;

        if r_Bits_DV = '1' then
            report "Test Passed - Correct Byte Data Valid Received" severity note;
        else
            report "Test Failed - Incorrect Byte Data Valid Received" severity note;
        end if;

    end Send_Bits;

    procedure Run_Test
    (
        i_Send_Bits    : in std_logic_vector(7 downto 0);
        signal i_Clock : in std_logic;
        signal o_UART  : out std_logic
    )
    is
    begin
        -- Send a bits to the UART
        wait until rising_edge(i_Clock);
        Send_Bits(i_Send_Bits, o_UART);
        wait until rising_edge(i_Clock);

        -- Check that the correct bits was recorded
        if r_Bits = i_Send_Bits then
            report "Test Passed - Correct Byte Received" severity note;
        else
            report "Test Failed - Incorrect Byte Received" severity note;
        end if;

    end Run_Test;

begin
    -- Clock
    r_Clock <= not r_Clock after c_CLOCK_PERIOD/2;

    -- UART Receiver
    UART_Recv_Inst : entity work.UART_Receiver
    generic map (
        g_CLOCKS_PER_BIT => c_CLOCKS_PER_BIT
    )
    port map (
        i_Clk         => r_Clock,
        i_UART_RX     => r_UART,
        o_Has_Failed  => open,
        o_Bits        => r_Bits,
        o_Bits_DV     => r_Bits_DV
    );

    process is
    begin
        report "Starting Testbench...";

        Run_Test(X"55", r_Clock, r_UART);

        Run_Test(X"AA", r_Clock, r_UART);

        assert false report "Test Complete" severity failure;
    end process;

end behave;
