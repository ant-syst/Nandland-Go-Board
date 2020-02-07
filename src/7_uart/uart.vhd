library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity UART is
    port (
      -- main clock 25 MHz
        i_Clk        : in std_logic;

        i_UART_RX   : in std_logic;

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

    --25000000 clock / 1 seconde
    --115200   bauds / 1 seconde => 115200 bits en 1 seconde
    --durée d'un baud en cycle: 25000000/115200/8 : 217

    type T_STATE is (STOPPED, STARTING, STARTED, FAILED);

    signal right_digit : integer := 0;
    signal left_digit : integer := 0;
    signal r_TimeCount : integer range 0 to 10000 := 0;
    signal r_time      : integer range 0 to 1000 := 0;
                                                 -- 250000 10 ms

    signal r_counter   : integer range 0 to 10 := 0;
    signal r_num2      : std_logic_vector(7 downto 0) := "00000000";
    signal r_state     : T_STATE := STOPPED;

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
    p_Sampler : process (i_Clk) is
    begin
        if rising_edge(i_Clk)
        then
            if r_state = STOPPED
            then
                if i_UART_RX = '0'
                then
                    r_time <= 217 / 2;
                    r_state <= STARTING;

                    r_num2(0) <= '0';
                    r_num2(1) <= '0';
                    r_num2(2) <= '0';
                    r_num2(3) <= '0';
                    r_num2(4) <= '0';
                    r_num2(5) <= '0';
                    r_num2(6) <= '0';
                    r_num2(7) <= '0';
                    r_counter <= 0;
                end if;

            elsif r_state = STARTING
            then
                if r_TimeCount < r_time
                then
                    r_TimeCount <= r_TimeCount + 1;
                else
                    if i_UART_RX = '0'
                    then
                        r_state <= STARTED;
                        r_time <= 217;
                    else
                        r_state <= FAILED;
                    end if;

                    r_TimeCount <= 0;
                end if;
            elsif r_state = FAILED
            then
                r_state <= STOPPED;
            elsif r_state = STARTED
            then
                if r_TimeCount < r_time
                then
                    r_TimeCount <= r_TimeCount + 1;
                else
                    r_TimeCount <= 0;
                    r_time <= 217;

                    if r_counter = 8
                    then
                        if i_UART_RX = '1'
                        then
                            r_state <= STOPPED;
                        else
                            r_state <= FAILED;
                        end if;
                    else
                        if i_UART_RX = '1'
                        then
                            r_num2(r_counter) <= '1';
                            r_counter <= r_counter + 1;
                        else
                            r_num2(r_counter) <= '0';
                            r_counter <= r_counter + 1;
                        end if;
                    end if;
                end if;
            end if;

        end if;
    end process;

    left_digit <= to_integer(unsigned(r_num2)) / 16;
    right_digit <= to_integer(unsigned(r_num2)) mod 16;

    SevenSeg1_Inst : entity work.Binary_To_7Segment
    port map (
        i_Clk      => i_Clk,
        i_Binary_Num => std_logic_vector(to_unsigned(right_digit, 4)),
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
        i_Binary_Num => std_logic_vector(to_unsigned(left_digit, 4)),
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
