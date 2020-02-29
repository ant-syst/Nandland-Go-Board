library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity VGA is
    port (
        i_Clk       : in std_logic;

        i_UART_RX   : in std_logic;

        o_UART_TX   : out std_logic;

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
        o_VGA_Blu_2 : out std_logic;

        o_Segment1_A : out std_logic;
        o_Segment1_B : out std_logic;
        o_Segment1_C : out std_logic;
        o_Segment1_D : out std_logic;
        o_Segment1_E : out std_logic;
        o_Segment1_F : out std_logic;
        o_Segment1_G : out std_logic;
        o_Segment2_A : out std_logic;
        o_Segment2_B : out std_logic;
        o_Segment2_C : out std_logic;
        o_Segment2_D : out std_logic;
        o_Segment2_E : out std_logic;
        o_Segment2_F : out std_logic;
        o_Segment2_G : out std_logic
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

    constant c_ACTIVE_COLS      : integer := 640;
    constant c_FRONT_PORCH_COLS : integer := 18;
    constant c_SYNC_PULSE_COLS  : integer := 92;
    constant c_BACK_PORCH_COLS  : integer := 50;

    constant c_ACTIVE_ROWS      : integer := 480;
    constant c_FRONT_PORCH_ROWS : integer := 10;
    constant c_SYNC_PULSE_ROWS  : integer := 2;
    constant c_BACK_PORCH_ROWS  : integer := 33;
    constant c_TOTAL_COLS : integer := c_ACTIVE_COLS + c_FRONT_PORCH_COLS +
                                        c_SYNC_PULSE_COLS + c_BACK_PORCH_COLS;
    constant c_TOTAL_ROWS : integer := c_ACTIVE_ROWS + c_FRONT_PORCH_ROWS +
                                        c_SYNC_PULSE_ROWS + c_BACK_PORCH_ROWS;

    --signal r_Col_Idx : integer range 0 to g_TOTAL_COLS := 0;
    --signal r_Row_Idx : integer range 0 to g_TOTAL_ROWS := 0;

    signal r_UART_TX    : std_logic := '0';
    signal r_Bits       : std_logic_vector(7 downto 0) := "00110101";
    signal r_Bits_DV    : std_logic := '0';
    signal r_Has_Failed : std_logic := '0';

    signal w_Segment1_A : std_logic := '0';
    signal w_Segment1_B : std_logic := '0';
    signal w_Segment1_C : std_logic := '0';
    signal w_Segment1_D : std_logic := '0';
    signal w_Segment1_E : std_logic := '0';
    signal w_Segment1_F : std_logic := '0';
    signal w_Segment1_G : std_logic := '0';

    signal w_Segment2_A : std_logic := '0';
    signal w_Segment2_B : std_logic := '0';
    signal w_Segment2_C : std_logic := '0';
    signal w_Segment2_D : std_logic := '0';
    signal w_Segment2_E : std_logic := '0';
    signal w_Segment2_F : std_logic := '0';
    signal w_Segment2_G : std_logic := '0';

    signal r_Pulses_HSync   : std_logic := '0';
    signal r_Pulses_VSync   : std_logic := '0';
    signal r_Pulses_Col_Idx : natural := 0;
    signal r_Pulses_Row_Idx : natural := 0;

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

    signal r_Porch_HSync    : std_logic := '0';
    signal r_Porch_VSync    : std_logic := '0';
    signal r_Porch_Col_Idx  : natural := 0;
    signal r_Porch_Row_Idx  : natural := 0;
    signal r_Porch_Red_0    : std_logic := '0';
    signal r_Porch_Red_1    : std_logic := '0';
    signal r_Porch_Red_2    : std_logic := '0';
    signal r_Porch_Grn_0    : std_logic := '0';
    signal r_Porch_Grn_1    : std_logic := '0';
    signal r_Porch_Grn_2    : std_logic := '0';
    signal r_Porch_Blu_0    : std_logic := '0';
    signal r_Porch_Blu_1    : std_logic := '0';
    signal r_Porch_Blu_2    : std_logic := '0';

begin

    UART_Receiver_Inst : entity work.UART_Receiver
    generic map (
        g_CLOCKS_PER_BIT => 217
    )
    port map (
        i_Clk        => i_Clk,
        i_UART_RX    => i_UART_RX,
        o_Bits       => r_Bits,
        o_Bits_DV    => r_Bits_DV,
        o_Has_Failed => r_Has_Failed
    );

    UART_Transmitter_Inst : entity work.UART_Transmitter
    generic map (
        g_CLOCKS_PER_BIT => 217
    )
    port map (
        i_Bits    => r_Bits,
        i_Bits_DV => r_Bits_DV,
        i_Clk     => i_Clk,
        o_UART_TX => r_UART_TX
    );

    o_UART_TX   <= r_UART_TX;

    SevenSeg1_Inst : entity work.Binary_To_7Segment
    port map (
        i_Clk        => i_Clk,
        i_Binary_Num => r_Bits(3 downto 0),
        o_Segment_A  => w_Segment2_A,
        o_Segment_B  => w_Segment2_B,
        o_Segment_C  => w_Segment2_C,
        o_Segment_D  => w_Segment2_D,
        o_Segment_E  => w_Segment2_E,
        o_Segment_F  => w_Segment2_F,
        o_Segment_G  => w_Segment2_G
    );

    o_Segment2_A  <= not w_Segment2_A;
    o_Segment2_B  <= not w_Segment2_B;
    o_Segment2_C  <= not w_Segment2_C;
    o_Segment2_D  <= not w_Segment2_D;
    o_Segment2_E  <= not w_Segment2_E;
    o_Segment2_F  <= not w_Segment2_F;
    o_Segment2_G  <= not w_Segment2_G;

    SevenSeg2_Inst : entity work.Binary_To_7Segment
    port map (
        i_Clk        => i_Clk,
        i_Binary_Num => r_Bits(7 downto 4),
        o_Segment_A  => w_Segment1_A,
        o_Segment_B  => w_Segment1_B,
        o_Segment_C  => w_Segment1_C,
        o_Segment_D  => w_Segment1_D,
        o_Segment_E  => w_Segment1_E,
        o_Segment_F  => w_Segment1_F,
        o_Segment_G  => w_Segment1_G
    );

    o_Segment1_A  <= not w_Segment1_A;
    o_Segment1_B  <= not w_Segment1_B;
    o_Segment1_C  <= not w_Segment1_C;
    o_Segment1_D  <= not w_Segment1_D;
    o_Segment1_E  <= not w_Segment1_E;
    o_Segment1_F  <= not w_Segment1_F;
    o_Segment1_G  <= not w_Segment1_G;

    --                            pattern
    --                               |
    --                               v
    -- |--------|               |---------|               |---------|
    -- |        |               |         |               |         |
    -- |        |---- HSync ----|         |---- HSync ----|         |---- HSync ----
    -- |   Syn  |---- VSync ----|  Test   |---- VSync ----|   Syn   |---- VSync ----
    -- | Pulses |--- col_idx ---| Pattern |--- col_idx ---|  Porch  |--- col_idx ---
    -- |        |--- row_idx ---|         |--- row_idx ---|         |--- row_idx ---
    -- |        |               |         |----- RGB -----|         |----- RGB -----
    -- |--------|               |---------|               |---------|
    --
    --
    -- Each signal generated by an entity must be kept synchronized with other
    -- signals (RGB wirh HSync)
    --    ex: RGB signals generated by Test Pattern entity must be kept
    --    synchronized with HSync/Vsync
    --
    -- Each new signal is generated with one clock cycle latency:
    --    => Old signals must be slowed down by one cycle too to be sync :
    --    Old signals previously generated are forwarded to entity to be
    --    kept in sync (i.e slowed down) with new signals

    VGA_Sync_Pulses_Inst : entity work.VGA_Sync_Pulses
    generic map (
        g_ACTIVE_COLS => c_ACTIVE_COLS,
        g_TOTAL_COLS  => c_TOTAL_COLS,
        g_ACTIVE_ROWS => c_ACTIVE_ROWS,
        g_TOTAL_ROWS  => c_TOTAL_ROWS
    )
    port map (
        i_Clk     => i_Clk,
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
        i_Clk     => i_Clk,

        i_pattern => to_integer(unsigned(r_Bits)),

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
        i_Clk     => i_Clk,
        i_HSync   => r_Test_HSync,
        i_VSync   => r_Test_VSync,
        i_Col_Idx => r_Test_Col_Idx,
        i_Row_Idx => r_Test_Row_Idx,
        i_Red_0   => r_Test_Red_0,
        i_Red_1   => r_Test_Red_1,
        i_Red_2   => r_Test_Red_2,
        i_Grn_0   => r_Test_Grn_0,
        i_Grn_1   => r_Test_Grn_1,
        i_Grn_2   => r_Test_Grn_2,
        i_Blu_0   => r_Test_Blu_0,
        i_Blu_1   => r_Test_Blu_1,
        i_Blu_2   => r_Test_Blu_2,

        o_HSync   => r_Porch_HSync,
        o_VSync   => r_Porch_VSync,
        o_Col_Idx => r_Porch_Col_Idx,
        o_Row_Idx => r_Porch_Row_Idx,

        o_Red_0   => r_Porch_Red_0,
        o_Red_1   => r_Porch_Red_1,
        o_Red_2   => r_Porch_Red_2,
        o_Grn_0   => r_Porch_Grn_0,
        o_Grn_1   => r_Porch_Grn_1,
        o_Grn_2   => r_Porch_Grn_2,
        o_Blu_0   => r_Porch_Blu_0,
        o_Blu_1   => r_Porch_Blu_1,
        o_Blu_2   => r_Porch_Blu_2
    );

    o_VGA_VSync <= r_Porch_VSync;
    o_VGA_HSync <= r_Porch_HSync;

    o_VGA_Red_0 <= r_Porch_Red_0;
    o_VGA_Red_1 <= r_Porch_Red_1;
    o_VGA_Red_2 <= r_Porch_Red_2;
    o_VGA_Grn_0 <= r_Porch_Grn_0;
    o_VGA_Grn_1 <= r_Porch_Grn_1;
    o_VGA_Grn_2 <= r_Porch_Grn_2;
    o_VGA_Blu_0 <= r_Porch_Blu_0;
    o_VGA_Blu_1 <= r_Porch_Blu_1;
    o_VGA_Blu_2 <= r_Porch_Blu_2;
end
architecture RTL;
