library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Debounce_Switch is
    port (
        i_Clk       : in std_logic;
        i_Switch    : in std_logic;
        o_Switch    : out std_logic
    );
end entity Debounce_Switch;

-- Expected signal when the switch is pushed
--              _____
-- i_Switch ___|     
--
-- Actual signal when the switch is pushed
--              _   _   ______
-- i_Switch ___| |_| |_|
--
-- We must filter the signal : i.e wait a time period that the signal is 
-- stable to be taken in account

architecture RTL of Debounce_Switch is
    
    -- 10 ms at 25 MHz
    constant c_DEBOUNCE_LIMIT : integer := 250000;
    
    signal r_State : std_logic := '0';
    signal r_Count : integer range 0 to c_DEBOUNCE_LIMIT := 0;
    -- allocate a register with enough bits to hold c_DEBOUNCE_LIMIT
    
begin
    
    p_Debounce : process (i_Clk) is
    begin
        if rising_edge(i_Clk) then
            
            -- increment the counter when the i_Switch signal is different 
            -- from the current state during c_DEBOUNCE_LIMIT clock cycles
            
            -- the i_Switch signal is != from the r_State register
            if (i_Switch /= r_State and r_Count < c_DEBOUNCE_LIMIT) then
                r_Count <= r_Count + 1;
            -- the counter has been incremented c_DEBOUNCE_LIMIT times : 
            -- the signal should be stable
            elsif r_Count = c_DEBOUNCE_LIMIT then
                r_State <= i_Switch;
                r_Count <= 0;
            else
                -- the i_Switch signal equals the r_State register
                -- => reset the counter when signal variation occurs
                r_Count <= 0;
            end if;
        end if;
     end process p_Debounce;
	
	o_Switch <= r_State;
	
end architecture RTL;
    
