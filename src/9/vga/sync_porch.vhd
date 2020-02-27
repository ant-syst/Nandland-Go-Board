library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity VGA_Sync_Porch is

    generic (
        g_ACTIVE_COLS      : integer;
        g_TOTAL_COLS       : integer;
        g_FRONT_PORCH_COLS : integer;
        g_SYNC_PULSE_COLS  : integer;
        g_BACK_PORCH_COLS  : integer;

        g_ACTIVE_ROWS      : integer;
        g_TOTAL_ROWS       : integer;
        g_FRONT_PORCH_ROWS : integer;
        g_SYNC_PULSE_ROWS  : integer;
        g_BACK_PORCH_ROWS  : integer
    );
    port (
        i_Clk     : in std_logic;
        i_HSync   : in std_logic;
        i_VSync   : in std_logic;
        i_Col_Idx : in integer;
        i_Row_Idx : in integer;

        o_HSync   : out std_logic;
        o_VSync   : out std_logic
    );

end entity VGA_Sync_Porch;

architecture RTL of VGA_Sync_Porch is

    signal r_HSync : std_logic := '0';
    signal r_VSync : std_logic := '0';

begin

    process (i_Clk) is
    begin
        if rising_edge(i_Clk)
        then
            if i_col_idx < (g_ACTIVE_COLS + g_FRONT_PORCH_COLS) or
                i_col_idx >= (g_ACTIVE_COLS + g_FRONT_PORCH_COLS + g_SYNC_PULSE_COLS)
            then
                r_HSync <= '1';
            else
                r_HSync <= i_HSync;
            end if;

            if i_row_idx < (g_ACTIVE_ROWS + g_FRONT_PORCH_ROWS) or
                i_row_idx >= (g_ACTIVE_ROWS + g_FRONT_PORCH_ROWS + g_SYNC_PULSE_ROWS)
            then
                r_VSync <= '1';
            else
                r_VSync <= i_VSync;
            end if;
        end if;
    end process;

    o_VSync <= r_VSync;
    o_HSync <= r_HSync;
end
architecture RTL;

