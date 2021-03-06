library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- read an octet from UART
entity UART is
    port (
      -- main clock 25 MHz
        i_Clk        : in std_logic;

        i_UART_RX    : in std_logic;

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
end entity UART;

architecture RTL of UART is

    signal r_Bits         : std_logic_vector(7 downto 0) := "00000000";
    signal r_Bits_DV      : std_logic := '0';
    signal r_Has_Failed   : std_logic := '0';

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

begin

    -- clock : 25000000 cycles / 1 second
    -- 115200 bauds / 1 second => 115200 bits / 1 second
    -- baud duration in cycles: 25000000/115200 : 217 cycles
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

    SevenSeg1_Inst : entity work.Binary_To_7Segment
    port map (
        i_Clk      => i_Clk,
        i_Binary_Num => r_Bits(3 downto 0),
        o_Segment_A  => w_Segment2_A,
        o_Segment_B  => w_Segment2_B,
        o_Segment_C  => w_Segment2_C,
        o_Segment_D  => w_Segment2_D,
        o_Segment_E  => w_Segment2_E,
        o_Segment_F  => w_Segment2_F,
        o_Segment_G  => w_Segment2_G
    );

    SevenSeg2_Inst : entity work.Binary_To_7Segment
    port map (
        i_Clk      => i_Clk,
        i_Binary_Num => r_Bits(7 downto 4),
        o_Segment_A  => w_Segment1_A,
        o_Segment_B  => w_Segment1_B,
        o_Segment_C  => w_Segment1_C,
        o_Segment_D  => w_Segment1_D,
        o_Segment_E  => w_Segment1_E,
        o_Segment_F  => w_Segment1_F,
        o_Segment_G  => w_Segment1_G
    );

    o_Segment2_A  <= not w_Segment2_A;
    o_Segment2_B  <= not w_Segment2_B;
    o_Segment2_C  <= not w_Segment2_C;
    o_Segment2_D  <= not w_Segment2_D;
    o_Segment2_E  <= not w_Segment2_E;
    o_Segment2_F  <= not w_Segment2_F;
    o_Segment2_G  <= not w_Segment2_G;

    o_Segment1_A  <= not w_Segment1_A;
    o_Segment1_B  <= not w_Segment1_B;
    o_Segment1_C  <= not w_Segment1_C;
    o_Segment1_D  <= not w_Segment1_D;
    o_Segment1_E  <= not w_Segment1_E;
    o_Segment1_F  <= not w_Segment1_F;
    o_Segment1_G  <= not w_Segment1_G;

end
architecture RTL;
