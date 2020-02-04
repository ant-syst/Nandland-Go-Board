library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Clocked_Logic is
    port (
        i_Clk        : in std_logic;
        i_Switch_1   : in std_logic;
        i_Switch_2   : in std_logic;
        o_Segment1_A : out std_logic;
        o_Segment1_B : out std_logic;
        o_Segment1_C : out std_logic;
        o_Segment1_D : out std_logic;
        o_Segment1_E : out std_logic;
        o_Segment1_F : out std_logic;
        o_Segment1_G : out std_logic;
        o_Segment2_A : out std_logic;
        o_Segment2_B : out std_logic;
        o_Segment2_C : out std_logic;
        o_Segment2_D : out std_logic;
        o_Segment2_E : out std_logic;
        o_Segment2_F : out std_logic;
        o_Segment2_G : out std_logic
    );
end entity Clocked_Logic;

architecture RTL of Clocked_Logic is
    signal r_Switch_1 : std_logic := '0';
    signal w_Switch_1 : std_logic := '0';
    signal r_Switch_2 : std_logic := '0';
    signal w_Switch_2 : std_logic := '0';
    signal r_Count_1 : integer range 0 to 9 := 0;
    signal r_Count_2 : integer range 0 to 9 := 0;

begin
    -- Instantiate a debounce filter
    Debounce_Inst1 : entity work.Debounce_Switch
    -- map the signal inside Debounce_Switch entity (left label)
    -- to the signal inside the Clocked_Logic entity (right label)
    port map (
        i_Clk    => i_Clk, 
        i_Switch => i_Switch_1,
        o_Switch => w_Switch_1
    );

    Debounce_Inst2 : entity work.Debounce_Switch
    port map (
        i_Clk    => i_Clk, 
        i_Switch => i_Switch_2,
        o_Switch => w_Switch_2
    );
    
    -- sequential process
    -- When the i_Clk changes (goes from 0 to 1 or from 1 to 0)
    -- the process is executed
    p_Register : process (i_Clk) is
    begin
        if rising_edge(i_Clk)
        then
            -- r_Switch_1 registers the old value of i_Switch_1
            r_Switch_1 <= w_Switch_1;
            r_Switch_2 <= w_Switch_2;
            
            -- if current value is low AND previous value is high
            -- the finger has relased the switch
            if w_Switch_1 = '0' and r_Switch_1 = '1'
            then
                -- increment the register value
                if r_Count_1 = 9
                then
                    r_Count_2 <= (r_Count_2 + 1) MOD 10;
                end if;
                
                r_Count_1 <= (r_Count_1 + 1) MOD 10;
            end if;
            
            if w_Switch_2 = '0' and r_Switch_2 = '1'
            then
                -- decrement the register value
                if r_Count_1 = 0
                then
                    r_Count_2 <= (r_Count_2 - 1) MOD 10;
                end if;
                
                r_Count_1 <= (r_Count_1 - 1) MOD 10;
            end if;
        end if;
    end process;
    
    -- on the next call 
    
    o_Segment2_A <= '1' when (r_Count_1 = 1 or r_Count_1 = 4) else '0';
    o_Segment2_B <= '1' when (r_Count_1 = 5 or r_Count_1 = 6) else '0';
    o_Segment2_C <= '1' when (r_Count_1 = 2) else '0';
    o_Segment2_D <= '1' when (r_Count_1 = 1 or r_Count_1 = 4 or r_Count_1 = 7) else '0';
    o_Segment2_E <= '0' when (r_Count_1 = 0 or r_Count_1 = 2 or r_Count_1 = 6 or r_Count_1 = 8) else '1';
    o_Segment2_F <= '1' when (r_Count_1 = 1 or r_Count_1 = 2 or r_Count_1 = 3 or r_Count_1 = 7) else '0';
    o_Segment2_G <= '1' when (r_Count_1 = 0 or r_Count_1 = 1 or r_Count_1 = 7) else '0';
    
    o_Segment1_A <= '1' when (r_Count_2 = 1 or r_Count_2 = 4) else '0';
    o_Segment1_B <= '1' when (r_Count_2 = 5 or r_Count_2 = 6) else '0';
    o_Segment1_C <= '1' when (r_Count_2 = 2) else '0';
    o_Segment1_D <= '1' when (r_Count_2 = 1 or r_Count_2 = 4 or r_Count_2 = 7) else '0';
    o_Segment1_E <= '0' when (r_Count_2 = 0 or r_Count_2 = 2 or r_Count_2 = 6 or r_Count_2 = 8) else '1';
    o_Segment1_F <= '1' when (r_Count_2 = 1 or r_Count_2 = 2 or r_Count_2 = 3 or r_Count_2 = 7) else '0';
    o_Segment1_G <= '1' when (r_Count_2 = 0 or r_Count_2 = 1 or r_Count_2 = 7) else '0';
end
architecture RTL;
