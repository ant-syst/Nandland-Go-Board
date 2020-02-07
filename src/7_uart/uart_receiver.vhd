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
        i_Clk     : in std_logic;
        i_UART_RX : in std_logic;
        o_Byte    : out std_logic_vector(7 downto 0)
    );
end entity UART_Receiver;

architecture RTL of UART_Receiver is

    type T_STATE is (STOPPED, STARTING, STARTED, FAILED);

    signal r_TimeCount : integer range 0 to 10000 := 0;
    signal r_Counter   : integer range 0 to 10 := 0;
    signal r_Bits      : std_logic_vector(7 downto 0) := "00000000";
    signal r_State     : T_STATE := STOPPED;

begin
    p_Sampler : process (i_Clk) is
    begin
        if rising_edge(i_Clk)
        then
            if r_State = STOPPED
            then
                if i_UART_RX = '0'
                then
                    r_State <= STARTING;
                    r_Bits <= "00000000";
                    r_Counter <= 0;
                    r_TimeCount <= 0;
                end if;

            elsif r_State = STARTING
            then
                if r_TimeCount < (g_PERIOD / 2)
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
                r_State <= STOPPED;
            elsif r_State = STARTED
            then
                if r_TimeCount < g_PERIOD
                then
                    r_TimeCount <= r_TimeCount + 1;
                else
                    r_TimeCount <= 0;

                    if r_Counter = 8
                    then
                        if i_UART_RX = '1'
                        then
                            r_State <= STOPPED;
                        else
                            r_State <= FAILED;
                        end if;
                    else
                        if i_UART_RX = '1'
                        then
                            r_Bits(r_Counter) <= '1';
                            r_Counter <= r_Counter + 1;
                        else
                            r_Bits(r_Counter) <= '0';
                            r_Counter <= r_Counter + 1;
                        end if;
                    end if;
                end if;
            end if;
        end if;
    end process;

    o_Byte <= r_Bits;

end
architecture RTL;
