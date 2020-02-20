-- Testbench for LED Blinker
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity VGA_TB is
end entity VGA_TB;

architecture behave of VGA_TB is

    constant c_CLOCK_PERIOD : time := 40 ns;

    signal r_Clock   : std_logic := '0';

begin
    -- Clock
    r_Clock <= not r_Clock after c_CLOCK_PERIOD/2;

    VGA_Inst : entity work.VGA
    port map (
        i_Clk       => r_Clock,
        o_VGA_HSync => open,
        o_VGA_VSync => open,
        o_VGA_Red_0 => open,
        o_VGA_Red_1 => open,
        o_VGA_Red_2 => open,
        o_VGA_Grn_0 => open,
        o_VGA_Grn_1 => open,
        o_VGA_Grn_2 => open,
        o_VGA_Blu_0 => open,
        o_VGA_Blu_1 => open,
        o_VGA_Blu_2 => open
    );

    process is
    begin
        report "Starting Testbench...";

        wait for 18 ms;

        assert false report "Test Complete" severity failure;
    end process;

end behave;
