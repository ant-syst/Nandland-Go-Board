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
        i_Clk       : in std_logic;
        i_VGA_HSync : in std_logic;
        i_VGA_VSync : in std_logic;
        o_VGA_HSync : out std_logic;
        o_VGA_VSync : out std_logic
    );

end entity VGA_Sync_Porch;

architecture RTL of VGA_Sync_Porch is

    signal r_VGA_HSync : std_logic := '0';
    signal r_VGA_VSync : std_logic := '0';

    signal r_col_idx : integer range 0 to g_TOTAL_COLS := 0;
    signal r_row_idx : integer range 0 to g_TOTAL_ROWS := 0;

begin

    VGA_Sync_Count_Inst : entity work.VGA_Sync_Count
    generic map (
        g_TOTAL_COLS  => g_TOTAL_COLS,
        g_TOTAL_ROWS  => g_TOTAL_ROWS
    )
    port map (
        i_Clk     => i_Clk,
        o_col_idx => r_col_idx,
        o_row_idx => r_row_idx
    );

    process (i_Clk) is
    begin
        if rising_edge(i_Clk)
        then
            if r_col_idx < (g_ACTIVE_COLS + g_FRONT_PORCH_COLS) or
                r_col_idx >= (g_ACTIVE_COLS + g_FRONT_PORCH_COLS + g_SYNC_PULSE_COLS)
            then
                r_VGA_HSync <= '1';
            else
                r_VGA_HSync <= i_VGA_HSync;
            end if;

            if r_row_idx < (g_ACTIVE_ROWS + g_FRONT_PORCH_ROWS) or
                r_row_idx >= (g_ACTIVE_ROWS + g_FRONT_PORCH_ROWS + g_SYNC_PULSE_ROWS)
            then
                r_VGA_VSync <= '1';
            else
                r_VGA_VSync <= i_VGA_VSync;
            end if;
        end if;
    end process;

    o_VGA_VSync <= r_VGA_VSync;
    o_VGA_HSync <= r_VGA_HSync;
end
architecture RTL;

