library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- read a byte of data from UART
entity UART_Receiver is
    generic (
        -- sampling period to read a bit
        g_CLOCKS_PER_BIT : integer
    );
    port (
        -- main clock 25 MHz
        i_Clk        : in std_logic;
        i_UART_RX    : in std_logic;
        o_Bits       : out std_logic_vector(7 downto 0);
        o_Bits_DV    : out std_logic;
        o_Has_Failed : out std_logic
    );
end entity UART_Receiver;

architecture RTL of UART_Receiver is

    type T_STATE is (STOPPED, STOPPING, STARTING, STARTED, FAILED);

    signal r_Clock_Count : integer range 0 to 10000 := 0;
    signal r_Bits_Index  : integer range 0 to 10 := 0;
    signal r_Bits        : std_logic_vector(7 downto 0) := "00000000";
    signal r_State       : T_STATE := STOPPED;

begin

    -- UART Serial Data Stream
    --
    -- 1 ____             _________  _________  _________  _________  _________
    --       \           /         \/         \/         \/         \/
    --        \  start  /\ Bit 0   /\ Bit 1   /\ Bit n   /\ Bit 7   / Stop
    -- 0       \_______/  \_______/  \_______/  \_______/  \_______/
    --       ^     ^          ^          ^
    --       |     |          |          |
    -- detection wait       sampling
    -- of the    (g_CLOCKS\ each g_CLOCKS_PER_BIT
    -- falling   _PER_BIT
    -- edge      / 2)

    -- State machine
    --
    --                                  ---------
    --     |-------------------------->| STOPPED |<-------------------------|
    --     |                            ---------                           |
    --     |                                |                               |
    --     |                                |                               |
    --     |                            UART_RX == 0                        |
    --     |                                |                               |
    --     |                                v     |---------|               |
    --  --------                        ----------|   r_Clock_Count <       |
    -- | FAILED |<-- UART_RX == 1 && --| STARTING | (g_CLOCKS_PER_BIT / 2)  |
    --  --------     r_Clock_Count ==   ----------|         |               |
    --     ^         (g_CLOCKS_PER_BIT / 2) |     <---------|               |
    --     |                                |                               |
    --     |                                |                               |
    --     |                          UART_RX == 0 &&                       |
    --     |                          r_Clock_Count ==                      |
    --     |                          (g_CLOCKS_PER_BIT / 2)                |
    --     |                                |                               |
    --     |                                v    |---------|                |
    --     |                            ---------|         |                |
    --     |                           | STARTED |   r_Bits_Index != 7      |
    --     |                            ---------|         |                |
    --     |                                |    <---------|                |
    --     |                                |                               |
    --     |                           r_Bits_Index == 7                    |
    --     |                                |                               |
    --     |                                v                               |
    --     |                            ----------                          |
    --     |<------ UART_RX == 0 ------| STOPPING |-- UART_RX == 1 ---------|
    --                                  ----------

    -- bits a receivrd in lsb

    p_Sampler : process (i_Clk) is
    begin
        if rising_edge(i_Clk)
        then

            case r_State is

                when STOPPED =>

                    o_Bits_DV <= '0';
                    -- reception of the falling edge of th start bit
                    if i_UART_RX = '0'
                    then
                        r_State <= STARTING;
                        -- reset internal variables
                        r_Bits <= "00000000";
                        r_Clock_Count <= 0;
                        o_Has_Failed <= '0';
                    end if;

                when STARTING =>

                    -- wait one half of a bit period in order to align
                    -- sampling each g_CLOCKS_PER_BIT to sample in the middle of
                    -- data bit
                    if r_Clock_Count < ((g_CLOCKS_PER_BIT / 2) -1)
                    then
                        r_Clock_Count <= r_Clock_Count + 1;
                    else
                        r_Clock_Count <= 0;

                        if i_UART_RX = '0'
                        then
                            r_State <= STARTED;
                        else
                            r_State <= FAILED;
                        end if;
                    end if;

                when FAILED =>

                    o_Has_Failed <= '1';
                    r_State <= STOPPED;

                when STARTED =>

                    -- wait g_CLOCKS_PER_BIT to sample in the middle of the data
                    if r_Clock_Count < (g_CLOCKS_PER_BIT -1)
                    then
                        r_Clock_Count <= r_Clock_Count + 1;
                    else
                        r_Clock_Count <= 0;

                        -- make a sample
                        r_Bits(r_Bits_Index) <= i_UART_RX;
                        r_Bits_Index <= r_Bits_Index + 1;

                        -- all bits have been registered
                        if r_Bits_Index = 7
                        then
                            r_State <= STOPPING;
                            r_Bits_Index <= 0;
                        end if;
                    end if;

                when STOPPING =>

                    -- wait g_CLOCKS_PER_BIT to sample in the middle of the data
                    if r_Clock_Count < (g_CLOCKS_PER_BIT -1)
                    then
                        r_Clock_Count <= r_Clock_Count + 1;
                    else
                        r_Clock_Count <= 0;

                        if i_UART_RX = '1'
                        then
                            -- if we observe the stop bit
                            r_State <= STOPPED;
                            o_Bits_DV <= '1';
                        else
                            -- if we don't observe the stop bit
                            r_State <= FAILED;
                        end if;
                    end if;
            end case;
        end if;
    end process;

    o_Bits <= r_Bits;

end
architecture RTL;
