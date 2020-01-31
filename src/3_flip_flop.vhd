library ieee;
use ieee.std_logic_1164.all;

entity And_Gate is
    port (
        i_Clk      : in std_logic;
        i_Switch_1 : in std_logic;
        o_LED_1    : out std_logic
    );
end entity And_Gate;

architecture RTL of And_Gate is

    signal r_Switch_1 : std_logic := '0';
    signal r_LED_1    : std_logic := '0';

begin

    p_Register : process (i_Clk) is
    begin
        if rising_edge(i_Clk) then
            -- r_Switch_1 registers the old value of i_Switch_1
            r_Switch_1 <= i_Switch_1;
            
            -- if current value is low AND previous value is high
            -- the finger has relased the switch
            if i_Switch_1 = '0' and r_Switch_1 = '1' then
                -- negate the register value
                r_LED_1 <= not r_LED_1; 
            end if;
        end if;
    end process;
    
    
    -- on the next call 
    o_LED_1 <= r_LED_1;
end
architecture RTL;
