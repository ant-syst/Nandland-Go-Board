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
        i_Clk     : in std_logic;
        i_Bits    : std_logic_vector(7 downto 0);
        i_Bits_DV : in std_logic;
        o_UART_TX : out std_logic
    );
end entity UART_Transmitter;

architecture RTL of UART_Transmitter is

    type T_STATE is (STOPPING, STOPPED, STARTING, STARTED);

    signal r_State     : T_STATE := STOPPED;
    signal r_UART_TX   : std_logic := '1';

    signal r_TimeCount : integer range 0 to 100000 := 0;
    signal r_Counter   : integer range 0 to 10 := 0;

begin

    -- UART Serial Data Stream
    --
    -- 1 ____             _________  _________  _________  _________  _________
    --       \           /         \/         \/         \/         \/
    --        \  start  /\ Bit 0   /\ Bit 1   /\ Bit n   /\ Bit 7   / Stop
    -- 0       \_______/  \_______/  \_______/  \_______/  \_______/

    p_Sampler : process (i_Clk) is
    begin
        if rising_edge(i_Clk)
        then
            if r_State = STOPPED
            then
                if i_Bits_DV = '1'
                then
                    r_State <= STARTING;
                end if;
            elsif r_State = STARTING
            then
                r_UART_TX <= '0';

                if r_TimeCount < (g_PERIOD - 1)
                then
                    r_TimeCount <= r_TimeCount + 1;
                else
                    r_TimeCount <= 0;
                    r_State <= STARTED;
                end if;

            elsif r_State = STARTED
            then
                if r_TimeCount < (g_PERIOD - 1)
                then
                    r_TimeCount <= r_TimeCount + 1;
                    r_UART_TX <= i_Bits(r_Counter);
                else
                    r_TimeCount <= 0;
                    r_UART_TX <= i_Bits(r_Counter);

                    if r_Counter < 7
                    then
                        r_Counter <= r_Counter + 1;
                    else
                        r_State <= STOPPING;
                        r_Counter <= 0;
                    end if;
                end if;
            elsif r_State = STOPPING
            then
                r_UART_TX <= '1';

                if r_TimeCount < (g_PERIOD - 1)
                then
                    r_TimeCount <= r_TimeCount + 1;
                else
                    r_TimeCount <= 0;
                    r_State <= STOPPED;
                end if;
            end if;
        end if;
    end process;

    o_UART_TX <= r_UART_TX;

end
architecture RTL;
