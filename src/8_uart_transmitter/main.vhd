library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- read an octet from UART
entity UART is
    port (
      -- main clock 25 MHz
        i_Clk        : in std_logic;

        i_Switch_1   : in std_logic;
        i_Switch_2   : in std_logic;

        o_UART_TX    : out std_logic;

        o_LED_1      : out std_logic;
        o_LED_2      : out std_logic;
        o_LED_3      : out std_logic;
        o_LED_4      : out std_logic
    );
end entity UART;

architecture RTL of UART is

    signal w_Switch_1     : std_logic := '0';
    signal w_Switch_2     : std_logic := '0';

    signal r_Switch_1  : std_logic := '0';
    signal r_Switch_2  : std_logic := '0';

    signal r_UART_TX   : std_logic := '0';

    signal r_LED_1     : std_logic := '0';
    signal r_LED_2     : std_logic := '0';
    signal r_LED_3     : std_logic := '0';
    signal r_LED_4     : std_logic := '0';

    signal r_Bits      : std_logic_vector(7 downto 0) := "00000000";
    signal r_Bits_DV   : std_logic := '0';

begin

    -- clock : 25000000 cycles / 1 second
    -- 115200 bauds / 1 second => 115200 bits / 1 second
    -- baud duration in cycles: 25000000/115200 : 217 cycles

    -- Instantiate a debounce filter
    Debounce_Inst1 : entity work.Debounce_Switch
    port map (
        i_Clk    => i_Clk,
        i_Switch => i_Switch_1,
        o_Switch => w_Switch_1
    );

    -- Instantiate a debounce filter
    Debounce_Inst2 : entity work.Debounce_Switch
    port map (
        i_Clk    => i_Clk,
        i_Switch => i_Switch_2,
        o_Switch => w_Switch_2
    );

    UART_Transmitter_Inst : entity work.UART_Transmitter
    generic map (
        g_PERIOD => 217
    )
    port map (
        i_Bits    => r_Bits,
        i_Bits_DV => r_Bits_DV,
        i_Clk     => i_Clk,
        o_UART_TX => r_UART_TX
    );


    p_Sampler : process (i_Clk) is
    begin
        if rising_edge(i_Clk)
        then
            r_Switch_1 <= i_Switch_1;
            r_Switch_2 <= i_Switch_2;

            if i_Switch_1 = '0' and r_Switch_1 = '1'
            then
                r_LED_1 <= '1';
                r_Bits_DV <= '1';
                r_Bits <= "00110101";

            elsif i_Switch_2 = '0' and r_Switch_2 = '1'
            then
                r_LED_1 <= '0';
                r_Bits_DV <= '1';
                r_Bits <= "00110111";
            else
                r_Bits_DV <= '0';
            end if;
        end if;
    end process;

    o_UART_TX <= r_UART_TX;
    o_LED_1 <= r_LED_1;
    o_LED_2 <= r_LED_2;
    o_LED_3 <= r_LED_3;
    o_LED_4 <= r_LED_4;

end
architecture RTL;
