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
        i_Clk       : in std_logic;
        o_VGA_HSync : out std_logic;
        o_VGA_VSync : out std_logic;
        o_col_cpt   : out integer range 0 to g_TOTAL_COLS := 0;
        o_row_cpt   : out integer range 0 to g_TOTAL_ROWS := 0
    );

end entity VGA_Sync_Pulses;

architecture RTL of VGA_Sync_Pulses is

    signal r_VGA_HSync : std_logic := '1';
    signal r_VGA_VSync : std_logic := '1';
    signal r_col_cpt   : integer range 0 to g_TOTAL_COLS := 0;
    signal r_row_cpt   : integer range 0 to g_TOTAL_ROWS := 0;

begin

    process (i_Clk) is
    begin
        if rising_edge(i_Clk)
        then
            if r_col_cpt < g_ACTIVE_COLS
            then
                r_VGA_HSync <= '1';
            else
                r_VGA_HSync <= '0';
            end if;

            if r_row_cpt < g_ACTIVE_ROWS
            then
                r_VGA_VSync <= '1';
            else
                r_VGA_VSync <= '0';
            end if;

            if r_col_cpt < (g_TOTAL_COLS - 1)
            then
                r_col_cpt <= r_col_cpt + 1;
            else
                r_col_cpt <= 0;
                r_row_cpt <= (r_row_cpt + 1) MOD g_TOTAL_ROWS;
            end if;

        end if;
    end process;

    -- The affectation to r_VGA_HSync/r_VGA_VSync signal takes one clock cycle
    -- to be visible. So we slow down our counters from one cycle to keep them
    -- synchronized with the r_VGA_HSync/r_VGA_VSync signals.
    process (i_Clk) is
    begin
        if rising_edge(i_Clk) then
            o_row_cpt <= r_row_cpt;
            o_col_cpt <= r_col_cpt;
        end if;
    end process;

    o_VGA_VSync <= r_VGA_VSync;
    o_VGA_HSync <= r_VGA_HSync;
end
architecture RTL;
