library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity VGA_Test_Pattern_Generator is

    generic (
        g_ACTIVE_COLS : integer;
        g_ACTIVE_ROWS : integer
    );
    port (
        i_Clk       : in std_logic;
        i_col_idx   : in integer;
        i_row_idx   : in integer;
        i_pattern   : in positive range 0 to 4;

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

end entity VGA_Test_Pattern_Generator;

architecture RTL of VGA_Test_Pattern_Generator is

    signal r_VGA_Red_0 : std_logic := '0';
    signal r_VGA_Red_1 : std_logic := '0';
    signal r_VGA_Red_2 : std_logic := '0';
    signal r_VGA_Grn_0 : std_logic := '0';
    signal r_VGA_Grn_1 : std_logic := '0';
    signal r_VGA_Grn_2 : std_logic := '0';
    signal r_VGA_Blu_0 : std_logic := '0';
    signal r_VGA_Blu_1 : std_logic := '0';
    signal r_VGA_Blu_2 : std_logic := '0';

    procedure Pattern0 is
    begin
        r_VGA_Blu_0 <= '1';
        r_VGA_Blu_1 <= '1';
        r_VGA_Blu_2 <= '1';

        r_VGA_Red_0 <= '0';
        r_VGA_Red_1 <= '0';
        r_VGA_Red_2 <= '0';

        r_VGA_Grn_0 <= '0';
        r_VGA_Grn_1 <= '0';
        r_VGA_Grn_2 <= '0';
    end procedure;

    procedure Pattern1 is
    begin
        r_VGA_Blu_0 <= '0';
        r_VGA_Blu_1 <= '0';
        r_VGA_Blu_2 <= '0';

        r_VGA_Red_0 <= '1';
        r_VGA_Red_1 <= '1';
        r_VGA_Red_2 <= '1';

        r_VGA_Grn_0 <= '0';
        r_VGA_Grn_1 <= '0';
        r_VGA_Grn_2 <= '0';
    end procedure;

    procedure Pattern2 is
    begin
        r_VGA_Blu_0 <= '1';
        r_VGA_Blu_1 <= '1';
        r_VGA_Blu_2 <= '1';

        r_VGA_Red_0 <= '0';
        r_VGA_Red_1 <= '0';
        r_VGA_Red_2 <= '0';

        r_VGA_Grn_0 <= '0';
        r_VGA_Grn_1 <= '0';
        r_VGA_Grn_2 <= '0';
    end procedure;

    procedure Pattern3 is
    begin
        r_VGA_Blu_0 <= '0';
        r_VGA_Blu_1 <= '0';
        r_VGA_Blu_2 <= '0';

        r_VGA_Red_0 <= '0';
        r_VGA_Red_1 <= '0';
        r_VGA_Red_2 <= '0';

        r_VGA_Grn_0 <= '1';
        r_VGA_Grn_1 <= '1';
        r_VGA_Grn_2 <= '1';
    end procedure;

    procedure PatternDefaults is
    begin
        r_VGA_Blu_0 <= '0';
        r_VGA_Blu_1 <= '0';
        r_VGA_Blu_2 <= '0';
        r_VGA_Red_0 <= '0';
        r_VGA_Red_1 <= '0';
        r_VGA_Red_2 <= '0';
        r_VGA_Grn_0 <= '0';
        r_VGA_Grn_1 <= '0';
        r_VGA_Grn_2 <= '0';
    end procedure;
begin

    process (i_Clk) is
    begin
        if rising_edge(i_Clk)
        then
            if i_col_idx >= g_ACTIVE_COLS or i_row_idx >= g_ACTIVE_ROWS
            then
                r_VGA_Red_0 <= '0';
                r_VGA_Red_1 <= '0';
                r_VGA_Red_2 <= '0';

                r_VGA_Grn_0 <= '0';
                r_VGA_Grn_1 <= '0';
                r_VGA_Grn_2 <= '0';

                r_VGA_Blu_0 <= '0';
                r_VGA_Blu_1 <= '0';
                r_VGA_Blu_2 <= '0';
            else
                case i_pattern is
                    when 0 =>
                        Pattern0;
                    when 1 =>
                        Pattern1;
                    when 2 =>
                        Pattern2;
                    when 3 =>
                        Pattern3;
                    when others =>
                        PatternDefaults;
                end case;

            end if;
        end if;
    end process;

    o_VGA_Red_0 <= r_VGA_Red_0;
    o_VGA_Red_1 <= r_VGA_Red_1;
    o_VGA_Red_2 <= r_VGA_Red_2;
    o_VGA_Grn_0 <= r_VGA_Grn_0;
    o_VGA_Grn_1 <= r_VGA_Grn_1;
    o_VGA_Grn_2 <= r_VGA_Grn_2;
    o_VGA_Blu_0 <= r_VGA_Blu_0;
    o_VGA_Blu_1 <= r_VGA_Blu_1;
    o_VGA_Blu_2 <= r_VGA_Blu_2;

end
architecture RTL;

