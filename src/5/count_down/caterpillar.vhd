library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Caterpillar_Leds is
    port (
		i_Clk       : in std_logic;
    
		o_LED_1      : out std_logic;
        o_LED_2      : out std_logic;
        o_LED_3      : out std_logic;
        o_LED_4      : out std_logic
    );
end entity Caterpillar_Leds;

architecture RTL of Caterpillar_Leds is
    
    -- 1 ms at 25 MHz
    constant BLINKING_RATE : integer := 2500000;
    signal r_Count : integer range 0 to BLINKING_RATE := 0;
    signal r_Led : integer range 0 to 3 := 0;
    signal r_LED_1 : std_logic := '0';
    signal r_LED_2 : std_logic := '0';
    signal r_LED_3 : std_logic := '0';
    signal r_LED_4 : std_logic := '0';
	
begin
    p_Caterpillar : process (i_Clk) is
    begin

		r_LED_1 <= '0';
		r_LED_2 <= '0';
		r_LED_3 <= '0';
		r_LED_4 <= '0';	
    
        if rising_edge(i_Clk) then
            
			if r_Count = BLINKING_RATE
			then
				r_Led <= r_Led + 1 mod 4;
			end if;
			
			r_Count <= (r_Count + 1) mod (BLINKING_RATE + 1);

			case r_Led is
				when 0 => 
					r_LED_1 <= '1';
				when 1 => 
					r_LED_2 <= '1';
				when 2 => 
					r_LED_3 <= '1';
				when 3 => 
					r_LED_4 <= '1';
				when others => null;
			end case;

		end if;
	end process p_Caterpillar;
     
	o_LED_1 <= r_LED_1;
	o_LED_2 <= r_LED_2;
	o_LED_3 <= r_LED_3;
	o_LED_4 <= r_LED_4;

end architecture RTL;
