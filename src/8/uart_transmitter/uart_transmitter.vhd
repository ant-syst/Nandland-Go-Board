library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- write a byte of data from UART
entity UART_Transmitter is
    generic (
        g_CLOCKS_PER_BIT : integer
    );
    port (
        i_Clk     : in std_logic;
        i_Bits    : std_logic_vector(7 downto 0);
        -- 1 when the i_Bits vector contains data that must be sent
        i_Bits_DV : in std_logic;
        o_UART_TX : out std_logic
    );
end entity UART_Transmitter;

architecture RTL of UART_Transmitter is

    type T_STATE is (STOPPING, STOPPED, STARTING, STARTED);

    signal r_State       : T_STATE := STOPPED;
    signal r_UART_TX     : std_logic := '1';
    signal r_Clock_Count : integer range 0 to 1000 := 0;
    signal r_Bits_Index  : integer range 0 to 8 := 0;
    signal r_Bits        : std_logic_vector(7 downto 0) := "00000000";

begin

    -- UART Serial Data Stream
    --
    -- 1 ____             _________  _________  _________  _________  _________
    --       \           /         \/         \/         \/         \/
    --        \  start  /\ Bit 0   /\ Bit 1   /\ Bit ... /\ Bit 7   / Stop
    -- 0       \_______/  \_______/  \_______/  \_______/  \_______/

    p_UART_TX : process (i_Clk) is
    begin
        if rising_edge(i_Clk)
        then

            case r_State is

                when STOPPED =>
                    if i_Bits_DV = '1'
                    then
                        -- Make a copy of input bits in case of i_Bits change
                        -- in caller module
                        r_Bits <= i_Bits;
                        r_State <= STARTING;
                    end if;

                -- Send the start bit (0) during g_CLOCKS_PER_BIT - 1 clock cycles
                when STARTING =>
                    r_UART_TX <= '0';

                    if r_Clock_Count < (g_CLOCKS_PER_BIT - 1)
                    then
                        r_Clock_Count <= r_Clock_Count + 1;
                    else
                        r_Clock_Count <= 0;
                        r_State <= STARTED;
                    end if;

                -- Send the data bits
                when STARTED =>

                    -- A data bit is send during g_CLOCKS_PER_BIT - 1 clock cycles
                    if r_Clock_Count < (g_CLOCKS_PER_BIT - 1)
                    then
                        r_Clock_Count <= r_Clock_Count + 1;
                        r_UART_TX <= r_Bits(r_Bits_Index);
                    else
                        r_Clock_Count <= 0;
                        r_UART_TX <= r_Bits(r_Bits_Index);

                        if r_Bits_Index < 7
                        then
                            r_Bits_Index <= r_Bits_Index + 1;
                        else
                            -- All bits have been sent
                            r_State <= STOPPING;
                            r_Bits_Index <= 0;
                        end if;
                    end if;

                -- Send the stop bit
                when STOPPING =>

                    r_UART_TX <= '1';

                    if r_Clock_Count < (g_CLOCKS_PER_BIT - 1)
                    then
                        r_Clock_Count <= r_Clock_Count + 1;
                    else
                        r_Clock_Count <= 0;
                        r_State <= STOPPED;
                    end if;
            end case;
        end if;
    end process;

    o_UART_TX <= r_UART_TX;

end
architecture RTL;
