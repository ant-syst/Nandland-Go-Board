library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity VGA_Test_Pattern_Generator is

    generic (
        g_ACTIVE_COLS : integer;
        g_ACTIVE_ROWS : integer
    );
    port (
        i_Clk     : in std_logic;
        i_Pattern : in integer;

        i_HSync   : in std_logic;
        i_VSync   : in std_logic;
        i_Col_Idx : in natural;
        i_Row_Idx : in natural;

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

end entity VGA_Test_Pattern_Generator;

architecture RTL of VGA_Test_Pattern_Generator is

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

    procedure Pattern0
    (
        signal o_Red_0 : out std_logic;
        signal o_Red_1 : out std_logic;
        signal o_Red_2 : out std_logic;
        signal o_Grn_0 : out std_logic;
        signal o_Grn_1 : out std_logic;
        signal o_Grn_2 : out std_logic;
        signal o_Blu_0 : out std_logic;
        signal o_Blu_1 : out std_logic;
        signal o_Blu_2 : out std_logic
    ) is
    begin
        o_Red_0 <= '1';
        o_Red_1 <= '1';
        o_Red_2 <= '1';

        o_Grn_0 <= '0';
        o_Grn_1 <= '0';
        o_Grn_2 <= '0';

        o_Blu_0 <= '0';
        o_Blu_1 <= '0';
        o_Blu_2 <= '0';

    end procedure;

    procedure Pattern1
    (
        signal o_Red_0 : out std_logic;
        signal o_Red_1 : out std_logic;
        signal o_Red_2 : out std_logic;
        signal o_Grn_0 : out std_logic;
        signal o_Grn_1 : out std_logic;
        signal o_Grn_2 : out std_logic;
        signal o_Blu_0 : out std_logic;
        signal o_Blu_1 : out std_logic;
        signal o_Blu_2 : out std_logic
    ) is
    begin
        o_Red_0 <= '0';
        o_Red_1 <= '0';
        o_Red_2 <= '0';

        o_Grn_0 <= '1';
        o_Grn_1 <= '1';
        o_Grn_2 <= '1';

        o_Blu_0 <= '0';
        o_Blu_1 <= '0';
        o_Blu_2 <= '0';

    end procedure;

    procedure Pattern2
    (
        signal o_Red_0 : out std_logic;
        signal o_Red_1 : out std_logic;
        signal o_Red_2 : out std_logic;
        signal o_Grn_0 : out std_logic;
        signal o_Grn_1 : out std_logic;
        signal o_Grn_2 : out std_logic;
        signal o_Blu_0 : out std_logic;
        signal o_Blu_1 : out std_logic;
        signal o_Blu_2 : out std_logic
    ) is
    begin
        o_Red_0 <= '0';
        o_Red_1 <= '0';
        o_Red_2 <= '0';

        o_Grn_0 <= '0';
        o_Grn_1 <= '0';
        o_Grn_2 <= '0';

        o_Blu_0 <= '1';
        o_Blu_1 <= '1';
        o_Blu_2 <= '1';

    end procedure;

    procedure Pattern3
    (
        signal o_Red_0 : out std_logic;
        signal o_Red_1 : out std_logic;
        signal o_Red_2 : out std_logic;
        signal o_Grn_0 : out std_logic;
        signal o_Grn_1 : out std_logic;
        signal o_Grn_2 : out std_logic;
        signal o_Blu_0 : out std_logic;
        signal o_Blu_1 : out std_logic;
        signal o_Blu_2 : out std_logic
    ) is
    begin
        o_Red_0 <= '1';
        o_Red_1 <= '1';
        o_Red_2 <= '1';

        o_Grn_0 <= '1';
        o_Grn_1 <= '1';
        o_Grn_2 <= '1';

        o_Blu_0 <= '1';
        o_Blu_1 <= '1';
        o_Blu_2 <= '1';
    end procedure;

    procedure PatternDefaults
    (
        signal o_Red_0 : out std_logic;
        signal o_Red_1 : out std_logic;
        signal o_Red_2 : out std_logic;
        signal o_Grn_0 : out std_logic;
        signal o_Grn_1 : out std_logic;
        signal o_Grn_2 : out std_logic;
        signal o_Blu_0 : out std_logic;
        signal o_Blu_1 : out std_logic;
        signal o_Blu_2 : out std_logic
    ) is
    begin
        o_Red_0 <= '0';
        o_Red_1 <= '0';
        o_Red_2 <= '0';

        o_Grn_0 <= '0';
        o_Grn_1 <= '0';
        o_Grn_2 <= '0';

        o_Blu_0 <= '0';
        o_Blu_1 <= '0';
        o_Blu_2 <= '0';
    end procedure;
begin

    process (i_Clk) is
    begin
        if rising_edge(i_Clk)
        then
            if i_Col_Idx >= g_ACTIVE_COLS or i_Row_Idx >= g_ACTIVE_ROWS
            then
                r_Red_0 <= '0';
                r_Red_1 <= '0';
                r_Red_2 <= '0';

                r_Grn_0 <= '0';
                r_Grn_1 <= '0';
                r_Grn_2 <= '0';

                r_Blu_0 <= '0';
                r_Blu_1 <= '0';
                r_Blu_2 <= '0';
            else
                case i_Pattern is
                    when 0 =>
                        Pattern0(
                            r_Red_0, r_Red_1, r_Red_2,
                            r_Grn_0, r_Grn_1, r_Grn_2,
                            r_Blu_0, r_Blu_1, r_Blu_2
                        );
                    when 1 =>
                        Pattern1(
                            r_Red_0, r_Red_1, r_Red_2,
                            r_Grn_0, r_Grn_1, r_Grn_2,
                            r_Blu_0, r_Blu_1, r_Blu_2
                        );
                    when 2 =>
                        Pattern2(
                            r_Red_0, r_Red_1, r_Red_2,
                            r_Grn_0, r_Grn_1, r_Grn_2,
                            r_Blu_0, r_Blu_1, r_Blu_2
                        );
                    when 3 =>
                        Pattern3(
                            r_Red_0, r_Red_1, r_Red_2,
                            r_Grn_0, r_Grn_1, r_Grn_2,
                            r_Blu_0, r_Blu_1, r_Blu_2
                        );
                    when others =>
                        PatternDefaults(
                            r_Red_0, r_Red_1, r_Red_2,
                            r_Grn_0, r_Grn_1, r_Grn_2,
                            r_Blu_0, r_Blu_1, r_Blu_2
                        );
                end case;

            end if;
        end if;
    end process;

    -- Keep synchronized input signals and RGB signals
    process (i_Clk) is
    begin
        if rising_edge(i_Clk)
        then
            r_Col_Idx <= i_Col_Idx;
            r_Row_Idx <= i_Row_Idx;

            r_HSync <= i_HSync;
            r_VSync <= i_VSync;
        end if;
    end process;

    o_HSync <= r_HSync;
    o_VSync <= r_VSync;

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
