-- Testbench for LED Blinker
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity VGA_TB is
end entity VGA_TB;

architecture behave of VGA_TB is

    constant c_CLOCK_PERIOD : time := 10 ns;

    constant c_ACTIVE_COLS      : integer := 3;
    constant c_FRONT_PORCH_COLS : integer := 1;
    constant c_SYNC_PULSE_COLS  : integer := 1;
    constant c_BACK_PORCH_COLS  : integer := 1;
    constant c_TOTAL_COLS       : integer := c_ACTIVE_COLS +
        c_FRONT_PORCH_COLS + c_SYNC_PULSE_COLS + c_BACK_PORCH_COLS;

    constant c_ACTIVE_ROWS      : integer := 2;
    constant c_FRONT_PORCH_ROWS : integer := 1;
    constant c_SYNC_PULSE_ROWS  : integer := 1;
    constant c_BACK_PORCH_ROWS  : integer := 1;
    constant c_TOTAL_ROWS       : integer := c_ACTIVE_ROWS +
        c_FRONT_PORCH_ROWS + c_SYNC_PULSE_ROWS + c_BACK_PORCH_ROWS;

    signal r_Clock          : std_logic := '0';

    signal r_Pattern        : integer := 0;

    signal r_Pulses_HSync   : std_logic := '0';
    signal r_Pulses_VSync   : std_logic := '0';
    signal r_Pulses_Col_Idx : natural := 0;
    signal r_Pulses_Row_Idx : natural := 0;

    signal r_Porch_HSync    : std_logic := '0';
    signal r_Porch_VSync    : std_logic := '0';
    signal r_Porch_Col_Idx  : integer := 0;
    signal r_Porch_Row_Idx  : integer := 0;

    signal r_Test_HSync     : std_logic := '0';
    signal r_Test_VSync     : std_logic := '0';
    signal r_Test_Col_Idx   : natural := 0;
    signal r_Test_Row_Idx   : natural := 0;
    signal r_Test_Red_0     : std_logic := '0';
    signal r_Test_Red_1     : std_logic := '0';
    signal r_Test_Red_2     : std_logic := '0';
    signal r_Test_Grn_0     : std_logic := '0';
    signal r_Test_Grn_1     : std_logic := '0';
    signal r_Test_Grn_2     : std_logic := '0';
    signal r_Test_Blu_0     : std_logic := '0';
    signal r_Test_Blu_1     : std_logic := '0';
    signal r_Test_Blu_2     : std_logic := '0';

    -- Test Synchronization between RGB signals and
    -- hsync/vsync signals
    procedure Test_RGB_Synchronization (
        i_Pattern : in natural;
        i_HSync   : in std_logic;
        i_VSync   : in std_logic;
        i_Red_0   : in std_logic;
        i_Red_1   : in std_logic;
        i_Red_2   : in std_logic;
        i_Grn_0   : in std_logic;
        i_Grn_1   : in std_logic;
        i_Grn_2   : in std_logic;
        i_Blu_0   : in std_logic;
        i_Blu_1   : in std_logic;
        i_Blu_2   : in std_logic
    )
    is
    begin
        if i_HSync = '1' and i_VSync = '1'
        then
            if i_Pattern = 0 or i_Pattern = 3
            then
                assert i_Red_0 = '1';
                assert i_Red_1 = '1';
                assert i_Red_2 = '1';
            else
                assert i_Red_0 = '0';
                assert i_Red_1 = '0';
                assert i_Red_2 = '0';
            end if;

            if i_Pattern = 1 or i_Pattern = 3
            then
                assert i_Grn_0 = '1';
                assert i_Grn_1 = '1';
                assert i_Grn_2 = '1';
            else
                assert i_Grn_0 = '0';
                assert i_Grn_1 = '0';
                assert i_Grn_2 = '0';
            end if;

            if i_Pattern = 2 or i_Pattern = 3
            then
                assert i_Blu_0 = '1';
                assert i_Blu_1 = '1';
                assert i_Blu_2 = '1';
            else
                assert i_Blu_0 = '0';
                assert i_Blu_1 = '0';
                assert i_Blu_2 = '0';
            end if;
        else
            assert i_Red_0 = '0';
            assert i_Red_1 = '0';
            assert i_Red_2 = '0';

            assert i_Grn_0 = '0';
            assert i_Grn_1 = '0';
            assert i_Grn_2 = '0';

            assert i_Blu_0 = '0';
            assert i_Blu_1 = '0';
            assert i_Blu_2 = '0';
        end if;
    end procedure;

    procedure Test_Sync_Pulses_Columns
    (
        i_Min_Col_Range    : in integer;
        i_Max_Col_Range    : in integer;
        i_Expected_HSync   : in std_logic;
        i_Expected_VSync   : in std_logic;
        i_Expected_Row_Idx : in integer
    )
    is
    begin
        -- iterate range c_CLOCK_PERIOD and check that VSync/Hsync/idx(s) are
        -- equals to expected values
        for Col_Idx in i_Min_Col_Range to i_Max_Col_Range
        loop
            assert r_Pulses_VSync = i_Expected_VSync report "VSync pulses failed" severity note;
            assert r_Pulses_Row_Idx = i_Expected_Row_Idx report "row_idx failed" severity note;

            assert r_Pulses_HSync = i_Expected_HSync report "HSync pulses failed" severity note;
            assert r_Pulses_Col_Idx = Col_Idx report "Col_Idx failed" severity note;

            wait for c_CLOCK_PERIOD;
        end loop;
    end Test_Sync_Pulses_Columns;

    procedure Test_Sync_Pulses_Row
    (
        i_Row_Idx        : in integer;
        i_Expected_VSync : in std_logic
    )
    is
    begin
        Test_Sync_Pulses_Columns(
            0,
            c_ACTIVE_COLS - 1,
            '1', i_Expected_VSync, i_Row_Idx
        );

        Test_Sync_Pulses_Columns(
            c_ACTIVE_COLS,
            c_TOTAL_COLS - 1,
            '0', i_Expected_VSync, i_Row_Idx
        );
    end Test_Sync_Pulses_Row;

    procedure Test_Sync_Porch_Columns
    (
        i_Min_Col_Range    : in integer;
        i_Max_Col_Range    : in integer;
        i_Expected_HSync   : in std_logic;
        i_Expected_VSync   : in std_logic;
        i_Expected_Row_Idx : in integer
    )
    is
    begin
        for Col_Idx in i_Min_Col_Range to i_Max_Col_Range
        loop
            assert r_Porch_VSync = i_Expected_VSync report "VSync pulses failed" severity note;
            assert r_Porch_Row_Idx = i_Expected_Row_Idx report "row_idx failed" severity note;

            assert r_Porch_HSync = i_Expected_HSync report "HSync pulses failed" severity note;
            assert r_Porch_Col_Idx = Col_Idx report "Col_Idx failed" severity note;

            wait for c_CLOCK_PERIOD;
        end loop;
    end Test_Sync_Porch_Columns;

    procedure Test_Sync_Porch_Row
    (
        i_Row_Idx        : in integer;
        i_Expected_VSync : in std_logic
    )
    is
    begin
        Test_Sync_Porch_Columns(
            0,
            c_ACTIVE_COLS - 1,
            '1', i_Expected_VSync, i_Row_Idx
        );

        Test_Sync_Porch_Columns(
            c_ACTIVE_COLS,
            c_ACTIVE_COLS + c_BACK_PORCH_COLS - 1,
            '1', i_Expected_VSync, i_Row_Idx
        );

        Test_Sync_Porch_Columns(
            c_ACTIVE_COLS + c_BACK_PORCH_COLS,
            c_ACTIVE_COLS + c_BACK_PORCH_COLS + c_SYNC_PULSE_COLS - 1,
            '0', i_Expected_VSync, i_Row_Idx
        );

        Test_Sync_Porch_Columns(
            c_ACTIVE_COLS + c_BACK_PORCH_COLS + c_SYNC_PULSE_COLS,
            c_TOTAL_COLS - 1,
            '1', i_Expected_VSync, i_Row_Idx
        );
    end Test_Sync_Porch_Row;

    procedure Test_Sync
    (
        i_Min_Col_Range    : in integer;
        i_Max_Col_Range    : in integer;
        i_HSync            : in std_logic;
        i_VSync            : in std_logic;
        i_Row_Idx          : in integer;
        i_Expected_HSync   : in std_logic;
        i_Expected_VSync   : in std_logic;
        i_Expected_Row_Idx : in integer
    )
    is
    begin
        for Col_Idx in i_Min_Col_Range to i_Max_Col_Range
        loop
            assert i_VSync = i_Expected_VSync report "VSync failed" severity note;
            assert i_Row_Idx = i_Expected_Row_Idx report "row_idx failed" severity note;

            assert i_HSync = i_Expected_HSync report "HSync pulses failed" severity note;
            assert Col_Idx = r_Porch_Col_Idx report "Col_Idx failed" severity note;

            wait for c_CLOCK_PERIOD;
        end loop;

    end Test_Sync;

begin
    r_Clock <= not r_Clock after c_CLOCK_PERIOD / 2;

    VGA_Sync_Pulses_Inst : entity work.VGA_Sync_Pulses
    generic map (
        g_ACTIVE_COLS => c_ACTIVE_COLS,
        g_TOTAL_COLS  => c_TOTAL_COLS,
        g_ACTIVE_ROWS => c_ACTIVE_ROWS,
        g_TOTAL_ROWS  => c_TOTAL_ROWS
    )
    port map (
        i_Clk     => r_Clock,
        o_HSync   => r_Pulses_HSync,
        o_VSync   => r_Pulses_VSync,
        o_Col_Idx => r_Pulses_Col_Idx,
        o_Row_Idx => r_Pulses_Row_Idx
    );

    VGA_Test_Pattern_Generator_Inst : entity work.VGA_Test_Pattern_Generator
    generic map (
        g_ACTIVE_COLS  => c_ACTIVE_COLS,
        g_ACTIVE_ROWS  => c_ACTIVE_ROWS
    )
    port map (
        i_Clk     => r_Clock,

        i_pattern => r_Pattern,

        i_HSync   => r_Pulses_HSync,
        i_VSync   => r_Pulses_VSync,
        i_Col_Idx => r_Pulses_Col_Idx,
        i_Row_Idx => r_Pulses_Row_Idx,

        o_HSync   => r_Test_HSync,
        o_VSync   => r_Test_VSync,
        o_Col_Idx => r_Test_Col_Idx,
        o_Row_Idx => r_Test_Row_Idx,

        o_Red_0   => r_Test_Red_0,
        o_Red_1   => r_Test_Red_1,
        o_Red_2   => r_Test_Red_2,
        o_Grn_0   => r_Test_Grn_0,
        o_Grn_1   => r_Test_Grn_1,
        o_Grn_2   => r_Test_Grn_2,
        o_Blu_0   => r_Test_Blu_0,
        o_Blu_1   => r_Test_Blu_1,
        o_Blu_2   => r_Test_Blu_2
    );

    VGA_Sync_Porch_Inst : entity work.VGA_Sync_Porch
    generic map (
        g_ACTIVE_COLS      => c_ACTIVE_COLS,
        g_TOTAL_COLS       => c_TOTAL_COLS,
        g_FRONT_PORCH_COLS => c_FRONT_PORCH_COLS,
        g_SYNC_PULSE_COLS  => c_SYNC_PULSE_COLS,
        g_BACK_PORCH_COLS  => c_BACK_PORCH_COLS,

        g_ACTIVE_ROWS      => c_ACTIVE_ROWS,
        g_TOTAL_ROWS       => c_TOTAL_ROWS,
        g_FRONT_PORCH_ROWS => c_FRONT_PORCH_ROWS,
        g_SYNC_PULSE_ROWS  => c_SYNC_PULSE_ROWS,
        g_BACK_PORCH_ROWS  => c_BACK_PORCH_ROWS
    )
    port map (
        i_Clk     => r_Clock,
        i_HSync   => r_Test_HSync,
        i_VSync   => r_Test_VSync,
        i_Col_Idx => r_Test_Col_Idx,
        i_Row_Idx => r_Test_Row_Idx,
        o_HSync   => r_Porch_HSync,
        o_VSync   => r_Porch_VSync,
        o_Col_Idx => r_Porch_Col_Idx,
        o_row_idx => r_Porch_Row_Idx
    );

    p_Test_Sync_Pulses : process is
    begin
        report "Sync Pulses) Starting Testbench ...";

        wait for c_CLOCK_PERIOD;
        assert r_Pulses_HSync = '1';

        for Test_Run in 0 to 2
        loop
            report "Sync Pulses) Run";

            for row_idx in 0 to (c_ACTIVE_ROWS - 1)
            loop
                Test_Sync_Pulses_Row(row_idx, '1');
            end loop;

            for row_idx in c_ACTIVE_ROWS to (c_TOTAL_ROWS - 1)
            loop
                Test_Sync_Pulses_Row(row_idx, '0');
            end loop;
        end loop;

        report "Sync Pulses) Before Complete";
        wait for 10 ms;
        assert false report "Sync Pulses) Test Complete" severity failure;

    end process p_Test_Sync_Pulses;

    p_Test_Pattern_Generation : process is
    begin
        report "Pattern Generation) Starting Testbench ...";

        wait for c_CLOCK_PERIOD;
        wait for c_CLOCK_PERIOD;
        assert r_Pulses_HSync = '1';

        for Test_Run in 0 to 2
        loop
            report "Pattern Generation) Run";

            for Row_Idx in 0 to (c_TOTAL_ROWS - 1)
            loop
                for Col_Idx in 0 to (c_TOTAL_COLS - 1)
                loop
                    Test_RGB_Synchronization(
                        r_Pattern, r_Test_HSync, r_Test_VSync,
                        r_Test_Red_0, r_Test_Red_1, r_Test_Red_2,
                        r_Test_Grn_0, r_Test_Grn_1, r_Test_Grn_2,
                        r_Test_Blu_0, r_Test_Blu_1, r_Test_Blu_2
                    );
                end loop;
            end loop;
        end loop;

        report "Pattern Generation) Before Complete";
        wait for 10 ms;
        assert false report "Pattern Generation) Test Complete" severity failure;

    end process p_Test_Pattern_Generation;

    p_Test_Sync_Porch : process is
    begin
        report "Sync Porch) Starting Testbench ...";

        wait for c_CLOCK_PERIOD;
        wait for c_CLOCK_PERIOD;
        wait for c_CLOCK_PERIOD;
        assert r_Porch_HSync = '1';

        for Test_Run in 0 to 2
        loop
            report "Sync Porch) Run";

            for Row_Idx in 0 to (c_ACTIVE_ROWS - 1)
            loop
                Test_Sync_Porch_Row(Row_Idx, '1');
            end loop;

            for Row_Idx in
                c_ACTIVE_ROWS to
                (c_ACTIVE_ROWS + c_FRONT_PORCH_ROWS - 1)
            loop
                Test_Sync_Porch_Row(Row_Idx, '1');
            end loop;

            for Row_Idx in
                (c_ACTIVE_ROWS + c_FRONT_PORCH_ROWS) to
                (c_ACTIVE_ROWS + c_FRONT_PORCH_ROWS + c_SYNC_PULSE_ROWS - 1)
            loop
                Test_Sync_Porch_Row(Row_Idx, '0');
            end loop;

            for Row_Idx in
                (c_ACTIVE_ROWS + c_FRONT_PORCH_ROWS + c_SYNC_PULSE_ROWS) to
                (c_TOTAL_ROWS - 1)
            loop
                Test_Sync_Porch_Row(Row_Idx, '1');
            end loop;

        end loop;

        report "Sync Porch) Before Complete";
        wait for 10 ms;
        assert false report "Sync Porch) Test Complete" severity failure;

    end process p_Test_Sync_Porch;

end behave;
