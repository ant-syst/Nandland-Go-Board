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


    signal r_VGA_HSync : std_logic := '0';
    signal r_VGA_VSync : std_logic := '0';

    signal r_VGA_HSync2 : std_logic := '0';
    signal r_VGA_VSync2 : std_logic := '0';

begin

    VGA_Sync_Pulses_Inst : entity work.VGA_Sync_Pulses
    generic map (
        g_ACTIVE_COLS => g_ACTIVE_COLS,
        g_TOTAL_COLS  => g_TOTAL_COLS,
        g_ACTIVE_ROWS => g_ACTIVE_ROWS,
        g_TOTAL_ROWS  => g_TOTAL_ROWS

    )
    port map (
        i_Clk       => i_Clk,
        o_VGA_HSync => r_VGA_HSync,
        o_VGA_VSync => r_VGA_VSync,
        o_col_cpt   => r_col_idx,
        o_row_cpt   => r_row_idx
    );

    VGA_Test_Pattern_Generator_Inst : entity work.VGA_Test_Pattern_Generator
    generic map (
        g_ACTIVE_COLS  => g_ACTIVE_COLS,
        g_ACTIVE_ROWS  => g_ACTIVE_ROWS

    )
    port map (
        i_Clk       => i_Clk,
        i_col_idx   => r_col_idx,
        i_row_idx   => r_row_idx,
        i_pattern   => 3,
        o_VGA_Red_0 => o_VGA_Red_0,
        o_VGA_Red_1 => o_VGA_Red_1,
        o_VGA_Red_2 => o_VGA_Red_2,
        o_VGA_Grn_0 => o_VGA_Grn_0,
        o_VGA_Grn_1 => o_VGA_Grn_1,
        o_VGA_Grn_2 => o_VGA_Grn_2,
        o_VGA_Blu_0 => o_VGA_Blu_0,
        o_VGA_Blu_1 => o_VGA_Blu_1,
        o_VGA_Blu_2 => o_VGA_Blu_2
    );

    VGA_Sync_Porch_Inst : entity work.VGA_Sync_Porch
    generic map (
        g_ACTIVE_COLS      => g_ACTIVE_COLS,
        g_TOTAL_COLS       => g_TOTAL_COLS,
        g_FRONT_PORCH_COLS => g_FRONT_PORCH_COLS,
        g_SYNC_PULSE_COLS  => g_SYNC_PULSE_COLS,
        g_BACK_PORCH_COLS  => g_BACK_PORCH_COLS,

        g_ACTIVE_ROWS      => g_ACTIVE_ROWS,
        g_TOTAL_ROWS       => g_TOTAL_ROWS,
        g_FRONT_PORCH_ROWS => g_FRONT_PORCH_ROWS,
        g_SYNC_PULSE_ROWS  => g_SYNC_PULSE_ROWS,
        g_BACK_PORCH_ROWS  => g_BACK_PORCH_ROWS
    )
    port map (
        i_Clk       => i_Clk,
        i_VGA_HSync => r_VGA_HSync,
        i_VGA_VSync => r_VGA_VSync,
        i_col_idx   => r_col_idx,
        i_row_idx   => r_row_idx,
        o_VGA_HSync => r_VGA_HSync2,
        o_VGA_VSync => r_VGA_VSync2
    );

    o_VGA_VSync <= r_VGA_VSync2;
    o_VGA_HSync <= r_VGA_HSync2;
end
architecture RTL;
