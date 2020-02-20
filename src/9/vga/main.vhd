library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity VGA is
    generic (
        g_ACTIVE_COLS      : integer := 640;
        g_FRONT_PORCH_COLS : integer := 18;
        g_SYNC_PULSE_COLS  : integer := 92;
        g_BACK_PORCH_COLS  : integer := 50;

        g_ACTIVE_ROWS      : integer := 480;
        g_FRONT_PORCH_ROWS : integer := 10;
        g_SYNC_PULSE_ROWS  : integer := 2;
        g_BACK_PORCH_ROWS  : integer := 33
    );
    port (
        i_Clk       : in std_logic;
        o_VGA_HSync : out std_logic;
        o_VGA_VSync : out std_logic;
        o_VGA_Red_0 : out std_logic;
        o_VGA_Red_1 : out std_logic;
        o_VGA_Red_2 : out std_logic;
        o_VGA_Grn_0 : out std_logic;
        o_VGA_Grn_1 : out std_logic;
        o_VGA_Grn_2 : out std_logic;
        o_VGA_Blu_0 : out std_logic;
        o_VGA_Blu_1 : out std_logic;
        o_VGA_Blu_2 : out std_logic
    );
end entity VGA;

-- HSync
--
--   ACTIVE_COLS                         | FRONT | SYNC  | BACK
--                                       | PORCH | PULSE | PORCH
-- 1 ____________________________________________         _______
--                                       :       |       |
-- 0                                     :       |_______|
--                                       :                           Vsync
--  |------------------------------------------------------------|
--  |                                    |                       |     |
--  |                                    |                       |     |
--  |                                    |                       |     | ACTIVE
--  |                                    |                       |     | ROWS
--  |         Active Video               |                       |     |
--  |                                    |                       |     |
--  |                                    |                       |     |
--  |                                    |                       |     |
--  |------------------------------------|.......................|     |_______
--  |                                                            |     | FRONT
--  |                                                            |     | PORCH
--  |                                                            |     |
--  |                                                            |   __|_______
--  |                                                            |  |    SYNC
--  |                                                            |  |    PULSE
--  |                                                            |  |__ _______
--  |                                                            |     | BACK
--  --------------------------------------------------------------     | PORCH


architecture RTL of VGA is
    constant g_TOTAL_COLS : integer := g_ACTIVE_COLS + g_FRONT_PORCH_COLS +
                                        g_SYNC_PULSE_COLS + g_BACK_PORCH_COLS;
    constant g_TOTAL_ROWS : integer := g_ACTIVE_ROWS + g_FRONT_PORCH_ROWS +
                                        g_SYNC_PULSE_ROWS + g_BACK_PORCH_ROWS;

    signal r_col_idx : integer range 0 to g_TOTAL_COLS := 0;
    signal r_row_idx : integer range 0 to g_TOTAL_ROWS := 0;

    signal col_cpt : integer range 0 to g_TOTAL_COLS := 0;
    signal row_cpt : integer range 0 to g_TOTAL_ROWS := 0;

    signal r_VGA_HSync : std_logic := '0';
    signal r_VGA_VSync : std_logic := '0';
    signal r_VGA_Red_0 : std_logic := '0';
    signal r_VGA_Red_1 : std_logic := '0';
    signal r_VGA_Red_2 : std_logic := '0';
    signal r_VGA_Grn_0 : std_logic := '0';
    signal r_VGA_Grn_1 : std_logic := '0';
    signal r_VGA_Grn_2 : std_logic := '0';
    signal r_VGA_Blu_0 : std_logic := '0';
    signal r_VGA_Blu_1 : std_logic := '0';
    signal r_VGA_Blu_2 : std_logic := '0';
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
            if col_cpt < (g_ACTIVE_COLS + g_FRONT_PORCH_COLS) or col_cpt >= (g_ACTIVE_COLS + g_FRONT_PORCH_COLS + g_SYNC_PULSE_COLS)
            then
                r_VGA_HSync <= '1';
            else
                r_VGA_HSync <= '0';
            end if;

            if row_cpt < (g_ACTIVE_ROWS + g_FRONT_PORCH_ROWS) or row_cpt >= (g_ACTIVE_ROWS + g_FRONT_PORCH_ROWS + g_SYNC_PULSE_ROWS)
            then
                r_VGA_VSync <= '1';
            else
                r_VGA_VSync <= '0';
            end if;

            if col_cpt < g_ACTIVE_COLS and row_cpt < g_ACTIVE_ROWS
            then
                if r_col_idx >= 1 and r_col_idx <= 2
                then
                    r_VGA_Red_0 <= '1';
                    r_VGA_Red_1 <= '1';
                    r_VGA_Red_2 <= '1';

                    r_VGA_Grn_0 <= '0';
                    r_VGA_Grn_1 <= '0';
                    r_VGA_Grn_2 <= '0';
                else
                    r_VGA_Red_0 <= '0';
                    r_VGA_Red_1 <= '0';
                    r_VGA_Red_2 <= '0';

                    r_VGA_Grn_0 <= '1';
                    r_VGA_Grn_1 <= '1';
                    r_VGA_Grn_2 <= '1';
                end if;

            else
                r_VGA_Red_0 <= '0';
                r_VGA_Red_1 <= '0';
                r_VGA_Red_2 <= '0';

                r_VGA_Grn_0 <= '0';
                r_VGA_Grn_1 <= '0';
                r_VGA_Grn_2 <= '0';
            end if;

            if col_cpt < (g_TOTAL_COLS - 1)
            then
                col_cpt <= col_cpt + 1;
            else
                col_cpt <= 0;
                row_cpt <= (row_cpt + 1) MOD g_TOTAL_ROWS;
            end if;

        end if;
    end process;

    o_VGA_VSync <= r_VGA_VSync;
    o_VGA_HSync <= r_VGA_HSync;
    o_VGA_Red_0 <= r_VGA_Red_0;
    o_VGA_Red_1 <= r_VGA_Red_1;
    o_VGA_Red_2 <= r_VGA_Red_2;
    o_VGA_Grn_0 <= r_VGA_Grn_0;
    o_VGA_Grn_1 <= r_VGA_Grn_1;
    o_VGA_Grn_2 <= r_VGA_Grn_2;
    o_VGA_Blu_0 <= r_VGA_Grn_0;
    o_VGA_Blu_1 <= r_VGA_Grn_1;
    o_VGA_Blu_2 <= r_VGA_Grn_2;
end
architecture RTL;
