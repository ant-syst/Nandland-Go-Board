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
        i_Col_Idx : in natural;
        i_Row_Idx : in natural;

        i_Red_0   : in std_logic;
        i_Red_1   : in std_logic;
        i_Red_2   : in std_logic;
        i_Grn_0   : in std_logic;
        i_Grn_1   : in std_logic;
        i_Grn_2   : in std_logic;
        i_Blu_0   : in std_logic;
        i_Blu_1   : in std_logic;
        i_Blu_2   : in std_logic;

        o_HSync   : out std_logic;
        o_VSync   : out std_logic;
        o_Col_Idx : out natural;
        o_Row_Idx : out natural;

        o_Red_0   : out std_logic;
        o_Red_1   : out std_logic;
        o_Red_2   : out std_logic;
        o_Grn_0   : out std_logic;
        o_Grn_1   : out std_logic;
        o_Grn_2   : out std_logic;
        o_Blu_0   : out std_logic;
        o_Blu_1   : out std_logic;
        o_Blu_2   : out std_logic
    );

end entity VGA_Sync_Porch;

architecture RTL of VGA_Sync_Porch is

    signal r_HSync   : std_logic := '0';
    signal r_VSync   : std_logic := '0';
    signal r_Col_Idx : natural;
    signal r_Row_Idx : natural;

    signal r_Red_0   : std_logic := '0';
    signal r_Red_1   : std_logic := '0';
    signal r_Red_2   : std_logic := '0';
    signal r_Grn_0   : std_logic := '0';
    signal r_Grn_1   : std_logic := '0';
    signal r_Grn_2   : std_logic := '0';
    signal r_Blu_0   : std_logic := '0';
    signal r_Blu_1   : std_logic := '0';
    signal r_Blu_2   : std_logic := '0';

begin

    process (i_Clk) is
    begin
        if rising_edge(i_Clk)
        then

            if i_Col_Idx < (g_ACTIVE_COLS + g_FRONT_PORCH_COLS) or
                i_Col_Idx >= (g_ACTIVE_COLS + g_FRONT_PORCH_COLS + g_SYNC_PULSE_COLS)
            then
                r_HSync <= '1';
            else
                r_HSync <= i_HSync;
            end if;

            if i_Row_Idx < (g_ACTIVE_ROWS + g_FRONT_PORCH_ROWS) or
                i_Row_Idx >= (g_ACTIVE_ROWS + g_FRONT_PORCH_ROWS + g_SYNC_PULSE_ROWS)
            then
                r_VSync <= '1';
            else
                r_VSync <= i_VSync;
            end if;
        end if;
    end process;

    process (i_Clk) is
    begin
        if rising_edge(i_Clk)
        then
            -- Add 1 cycle of latency to input signals in order to keep them
            -- synchronised with updated o_HSync/o_VSync signals
            r_Col_Idx <= i_Col_Idx;
            r_Row_Idx <= i_Row_Idx;

            r_Red_0 <= i_Red_0;
            r_Red_1 <= i_Red_1;
            r_Red_2 <= i_Red_2;
            r_Grn_0 <= i_Grn_0;
            r_Grn_1 <= i_Grn_1;
            r_Grn_2 <= i_Grn_2;
            r_Blu_0 <= i_Blu_0;
            r_Blu_1 <= i_Blu_1;
            r_Blu_2 <= i_Blu_2;
        end if;
    end process;

    o_VSync <= r_VSync;
    o_HSync <= r_HSync;

    o_Col_Idx <= r_Col_Idx;
    o_Row_Idx <= r_Row_Idx;

    o_Red_0 <= r_Red_0;
    o_Red_1 <= r_Red_1;
    o_Red_2 <= r_Red_2;
    o_Grn_0 <= r_Grn_0;
    o_Grn_1 <= r_Grn_1;
    o_Grn_2 <= r_Grn_2;
    o_Blu_0 <= r_Blu_0;
    o_Blu_1 <= r_Blu_1;
    o_Blu_2 <= r_Blu_2;
end
architecture RTL;

