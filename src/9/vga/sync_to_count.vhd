library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity VGA_Sync_Count is

    generic (
        g_TOTAL_COLS : integer;
        g_TOTAL_ROWS : integer
    );
    port (
        i_Clk       : in std_logic;
        o_col_idx   : out integer;
        o_row_idx   : out integer
    );

end entity VGA_Sync_Count;

architecture RTL of VGA_Sync_Count is

    signal r_col_cpt : integer range 0 to g_TOTAL_COLS := 0;
    signal r_row_cpt : integer range 0 to g_TOTAL_ROWS := 0;

begin

    process (i_Clk) is
    begin
        if rising_edge(i_Clk)
        then
            if r_col_cpt < (g_TOTAL_COLS - 1)
            then
                r_col_cpt <= r_col_cpt + 1;
            else
                r_col_cpt <= 0;
                r_row_cpt <= (r_row_cpt + 1) MOD g_TOTAL_ROWS;
            end if;
        end if;
    end process;

    o_col_idx <= r_col_cpt;
    o_row_idx <= r_row_cpt;
end
architecture RTL;

