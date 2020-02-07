library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- read a byte of data from UART
entity UART_Receiver is
    generic (
        -- sampling period to read a bit
        g_PERIOD : integer
    );
    port (
        -- main clock 25 MHz
        i_Clk        : in std_logic;
        i_UART_RX    : in std_logic;
        o_Byte       : out std_logic_vector(7 downto 0);
        o_Has_Failed : out std_logic
    );
end entity UART_Receiver;

architecture RTL of UART_Receiver is

    type T_STATE is (STOPPED, STARTING, STARTED, FAILED);

    signal r_TimeCount : integer range 0 to 10000 := 0;
    signal r_Counter   : integer range 0 to 10 := 0;
    signal r_Bits      : std_logic_vector(7 downto 0) := "00000000";
    signal r_State     : T_STATE := STOPPED;

begin

    -- UART Serial Data Stream
    --
    -- 1 ____             _________  _________  _________  _________  _________
    --       \           /         \/         \/         \/         \/
    --        \  start  /\ Bit 0   /\ Bit 1   /\ Bit n   /\ Bit 7   / Stop
    -- 0       \_______/  \_______/  \_______/  \_______/  \_______/
    --       ^     ^          ^          ^
    --       |     |          |          |
    -- detection  wait       sampling
    -- of the     (g_PERIOD  each
    -- falling    / 2)       g_PERIOD
    -- edge

    -- State machine
    --
    --                                  ---------
    --     |-------------------------->| STOPPED |<-------------------|
    --     |                            ---------                     |
    --     |                                |                         |
    --     |                                |                         |
    --     |                            UART_RX == 0                  |
    --     |                                |                         |
    --     |                                v     |---------|         |
    --  --------                        ----------|   r_TimeCount <   |
    -- | FAILED |<-- UART_RX == 1 && --| STARTING |   (g_PERIOD / 2)  |
    --  --------     r_TimeCount ==     ----------|         |         |
    --     ^         (g_PERIOD / 2)         |     <---------|         |
    --     |                                |                         |
    --     |                                |                         |
    --     |                          UART_RX == 0 &&                 |
    --     |                          r_TimeCount ==                  |
    --     |                          (g_PERIOD / 2)                  |
    --     |                                |                         |
    --     |                                v    |---------|          |
    --     |                            ---------|         |          |
    --     |-- r_Counter == 8 && ------| STARTED |   r_Counter != 8   |
    --           UART_RX == 0           ---------|         |          |
    --                                      |    <---------|          |
    --                                      |                         |
    --                                      |-- r_Counter == 8 && -----
    --                                          UART_RX == 1

    p_Sampler : process (i_Clk) is
    begin
        if rising_edge(i_Clk)
        then
            if r_State = STOPPED
            then
                -- reception of the falling edge of th start bit
                if i_UART_RX = '0'
                then
                    r_State <= STARTING;
                    -- reset internal variables
                    r_Bits <= "00000000";
                    r_Counter <= 0;
                    r_TimeCount <= 0;
                    o_Has_Failed <= '0';
                end if;

            elsif r_State = STARTING
            then
                -- wait one half of a bit period in order to align
                -- sampling each g_PERIOD to sample in the middle of
                -- data bit
                if r_TimeCount < ((g_PERIOD / 2) -1)
                then
                    r_TimeCount <= r_TimeCount + 1;
                else
                    r_TimeCount <= 0;

                    if i_UART_RX = '0'
                    then
                        r_State <= STARTED;
                    else
                        r_State <= FAILED;
                    end if;
                end if;
            elsif r_State = FAILED
            then
                o_Has_Failed <= '1';
                r_State <= STOPPED;
            elsif r_State = STARTED
            then
                -- wait g_PERIOD to sample in the middle of the data
                if r_TimeCount < (g_PERIOD -1)
                then
                    r_TimeCount <= r_TimeCount + 1;
                else

                    r_TimeCount <= 0;

                    -- not all bits have been registered
                    if r_Counter < 8
                    then
                        -- make a sample
                        r_Bits(r_Counter) <= i_UART_RX;
                        r_Counter <= r_Counter + 1;

                    -- all bits have been registered
                    else
                        if i_UART_RX = '1'
                        then
                            -- if we observe the stop bit
                            r_State <= STOPPED;
                        else
                            -- if we don't observe the stop bit
                            r_State <= FAILED;
                        end if;
                    end if;
                end if;
            end if;
        end if;
    end process;

    o_Byte <= r_Bits;

end
architecture RTL;
