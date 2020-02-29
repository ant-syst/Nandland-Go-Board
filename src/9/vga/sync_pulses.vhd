library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity VGA_Sync_Pulses is

    generic (
        g_ACTIVE_COLS : integer;
        g_TOTAL_COLS  : integer;
        g_ACTIVE_ROWS : integer;
        g_TOTAL_ROWS  : integer
    );
    port (
        i_Clk     : in std_logic;
        o_HSync   : out std_logic;
        o_VSync   : out std_logic;
        o_Col_Idx : out integer range 0 to g_TOTAL_COLS := 0;
        o_Row_Idx : out integer range 0 to g_TOTAL_COLS := 0
    );

end entity VGA_Sync_Pulses;

architecture RTL of VGA_Sync_Pulses is

    signal r_HSync   : std_logic := '1';
    signal r_VSync   : std_logic := '1';
    signal r_Col_Idx : integer range 0 to g_TOTAL_COLS := 0;
    signal r_Row_Idx : integer range 0 to g_TOTAL_ROWS := 0;

begin
    process (i_Clk) is
    begin
        if rising_edge(i_Clk)
        then
            if r_Col_Idx < g_ACTIVE_COLS
            then
                r_HSync <= '1';
            else
                r_HSync <= '0';
            end if;

            if r_Row_Idx < g_ACTIVE_ROWS
            then
                r_VSync <= '1';
            else
                r_VSync <= '0';
            end if;

            if r_Col_Idx < (g_TOTAL_COLS - 1)
            then
                r_Col_Idx <= r_Col_Idx + 1;
            else
                r_Col_Idx <= 0;
                r_Row_Idx <= (r_Row_Idx + 1) MOD g_TOTAL_ROWS;
            end if;

        end if;
    end process;

    -- The affectation to r_VGA_HSync/r_VGA_VSync signal takes one clock cycle
    -- to be visible. So we slowdown our counters from one cycle to keep them
    -- synchronized with the r_VGA_HSync/r_VGA_VSync signals.
    process (i_Clk) is
    begin
        if rising_edge(i_Clk)
        then
            o_Row_Idx <= r_Row_Idx;
            o_Col_Idx <= r_Col_Idx;
        end if;
    end process;

    o_VSync <= r_VSync;
    o_HSync <= r_HSync;
end
architecture RTL;
