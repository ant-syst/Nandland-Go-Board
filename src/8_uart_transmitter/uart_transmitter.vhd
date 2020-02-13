library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- write a byte of data from UART
entity UART_Transmitter is
    generic (
        -- sampling period to write a bit
        g_PERIOD : integer
    );
    port (
        i_Switch_1: in std_logic;
        i_Switch_2: in std_logic;

        i_Clk     : in std_logic;

        o_LED_1   : out std_logic;
        o_LED_2   : out std_logic;
        o_LED_3   : out std_logic;
        o_LED_4   : out std_logic;

        o_UART_TX : out std_logic
    );
end entity UART_Transmitter;

architecture RTL of UART_Transmitter is

    signal r_UART_TX   : std_logic := '1';
    signal r_Switch_1  : std_logic := '0';
    signal r_Switch_2  : std_logic := '0';

    signal r_TimeCount : integer range 0 to 100000 := 0;

    signal r_LED_1   : std_logic := '0';
    signal r_LED_2   : std_logic := '0';
    signal r_LED_3   : std_logic := '0';
    signal r_LED_4   : std_logic := '0';

begin

    -- UART Serial Data Stream
    --
    -- 1 ____             _________  _________  _________  _________  _________
    --       \           /         \/         \/         \/         \/
    --        \  start  /\ Bit 0   /\ Bit 1   /\ Bit n   /\ Bit 7   / Stop
    -- 0       \_______/  \_______/  \_______/  \_______/  \_______/

    -- switch 1: send the character '*' (0b 0010 1010)
    -- switch 2: reset leds

    p_Sampler : process (i_Clk) is
    begin
        if rising_edge(i_Clk)
        then

            r_Switch_1 <= i_Switch_1;
            r_Switch_2 <= i_Switch_2;

            if i_Switch_1 = '0' and r_Switch_1 = '1'
            then
                r_LED_1 <= '1';
                r_UART_TX <= '1';
            elsif i_Switch_2 = '0' and r_Switch_2 = '1'
            then
                r_LED_1 <= '0';
                r_LED_2 <= '0';
                r_UART_TX <= '1';
            else
                -- start
                if r_LED_1 = '1'
                then
                    -- start bit
                    if r_TimeCount < (g_PERIOD * 1)
                    then
                        r_TimeCount <= r_TimeCount + 1;
                        r_UART_TX <= '0';

                    -- 0
                    elsif r_TimeCount < (g_PERIOD * 2)
                    then
                        r_TimeCount <= r_TimeCount + 1;
                        r_UART_TX <= '0';
                    -- 1
                    elsif r_TimeCount < (g_PERIOD * 3)
                    then
                        r_TimeCount <= r_TimeCount + 1;
                        r_UART_TX <= '1';
                    -- 0
                    elsif r_TimeCount < (g_PERIOD * 4)
                    then
                        r_TimeCount <= r_TimeCount + 1;
                        r_UART_TX <= '0';
                    -- 1
                    elsif r_TimeCount < (g_PERIOD * 5)
                    then
                        r_TimeCount <= r_TimeCount + 1;
                        r_UART_TX <= '1';
                    -- 0
                    elsif r_TimeCount < (g_PERIOD * 6)
                    then
                        r_TimeCount <= r_TimeCount + 1;
                        r_UART_TX <= '0';
                    -- 1
                    elsif r_TimeCount < (g_PERIOD * 7)
                    then
                        r_TimeCount <= r_TimeCount + 1;
                        r_UART_TX <= '1';
                    -- 0
                    elsif r_TimeCount < (g_PERIOD * 8)
                    then
                        r_TimeCount <= r_TimeCount + 1;
                        r_UART_TX <= '0';
                    -- 0
                    elsif r_TimeCount < (((g_PERIOD) * 9))
                    then
                        r_TimeCount <= r_TimeCount + 1;
                        r_UART_TX <= '0';
                    -- stop bit
                    elsif r_TimeCount < (((g_PERIOD) * 10))
                    then
                        r_TimeCount <= r_TimeCount + 1;
                        r_UART_TX <= '1';
                    else
                        r_UART_TX <= '1';
                        r_TimeCount <= 0;
                        r_LED_1 <= '0';
                        r_LED_2 <= '1';
                    end if;
                else
                    r_TimeCount <= 0;
                end if;
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
