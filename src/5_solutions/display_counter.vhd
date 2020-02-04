library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Project_7_segment is
    port (
		-- main clock 25 MHz
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
end entity Project_7_segment;

architecture RTL of Project_7_segment is
    
    signal r_Switch_1 : std_logic := '0';
    signal w_Switch_1 : std_logic := '0';
    
    signal r_Switch_2 : std_logic := '0';
    signal w_Switch_2 : std_logic := '0';
    
    signal r_Count_1 : integer range 0 to 9 := 0;
    signal r_Count_2 : integer range 0 to 9 := 0;
    
    signal w_Segment1_A : std_logic;
	signal w_Segment1_B : std_logic;
	signal w_Segment1_C : std_logic;
	signal w_Segment1_D : std_logic;
	signal w_Segment1_E : std_logic;
	signal w_Segment1_F : std_logic;
	signal w_Segment1_G : std_logic;
	
	signal w_Segment2_A : std_logic;
	signal w_Segment2_B : std_logic;
	signal w_Segment2_C : std_logic;
	signal w_Segment2_D : std_logic;
	signal w_Segment2_E : std_logic;
	signal w_Segment2_F : std_logic;
	signal w_Segment2_G : std_logic;
    
begin
    -- Instantiate a debounce filter
    Debounce_Inst1 : entity work.Debounce_Switch
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
    p_Switch_Count : process (i_Clk) is
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
    
    SevenSeg1_Inst : entity work.Binary_To_7Segment
    port map (
        i_Clk    	 => i_Clk, 
        i_Binary_Num => std_logic_vector(to_unsigned(r_Count_1, 4)),
        o_Segment_A  => w_Segment2_A,
        o_Segment_B  => w_Segment2_B,
        o_Segment_C  => w_Segment2_C,
        o_Segment_D  => w_Segment2_D,
        o_Segment_E  => w_Segment2_E,
        o_Segment_F  => w_Segment2_F,
        o_Segment_G  => w_Segment2_G
    );
    
    SevenSeg2_Inst : entity work.Binary_To_7Segment
    port map (
        i_Clk    	 => i_Clk, 
        i_Binary_Num => std_logic_vector(to_unsigned(r_Count_2, 4)),
        o_Segment_A  => w_Segment1_A,
        o_Segment_B  => w_Segment1_B,
        o_Segment_C  => w_Segment1_C,
        o_Segment_D  => w_Segment1_D,
        o_Segment_E  => w_Segment1_E,
        o_Segment_F  => w_Segment1_F,
        o_Segment_G  => w_Segment1_G
    );
    
    o_Segment2_A  <= not w_Segment2_A;
	o_Segment2_B  <= not w_Segment2_B;
	o_Segment2_C  <= not w_Segment2_C;
	o_Segment2_D  <= not w_Segment2_D;
	o_Segment2_E  <= not w_Segment2_E;
	o_Segment2_F  <= not w_Segment2_F;
	o_Segment2_G  <= not w_Segment2_G;
    
    o_Segment1_A  <= not w_Segment1_A;
	o_Segment1_B  <= not w_Segment1_B;
	o_Segment1_C  <= not w_Segment1_C;
	o_Segment1_D  <= not w_Segment1_D;
	o_Segment1_E  <= not w_Segment1_E;
	o_Segment1_F  <= not w_Segment1_F;
	o_Segment1_G  <= not w_Segment1_G;
    
end
architecture RTL;
