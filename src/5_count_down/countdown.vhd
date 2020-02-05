library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Project_Countdown is
    port (
		-- main clock 25 MHz
        i_Clk        : in std_logic;
        
        i_Switch_1   : in std_logic;
        
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
end entity Project_Countdown;

architecture RTL of Project_Countdown is
    
    -- 1000 ms at 25 MHz
    constant COUNTDOWN_PERIOD : integer := 25000000;
    
    signal r_Switch_1 : std_logic := '0';
    signal w_Switch_1 : std_logic := '0';
    
    signal r_Counter : integer range 0 to 99 := 0;
    signal r_TimeCount : integer range 0 to COUNTDOWN_PERIOD := 0;
    
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
    Debounce_Inst : entity work.Debounce_Switch
    port map (
        i_Clk    => i_Clk, 
        i_Switch => i_Switch_1,
        o_Switch => w_Switch_1
    );
    
    p_Switch_Count : process (i_Clk) is
    begin
        if rising_edge(i_Clk)
        then
        
			if r_Counter /= 0
			then
				if r_TimeCount < COUNTDOWN_PERIOD
				then
					r_TimeCount <= r_TimeCount + 1;
				else
					r_TimeCount <= 0;
					r_Counter <= r_Counter - 1;
				end if;
			end if;
			
            -- r_Switch_1 registers the old value of i_Switch_1
            r_Switch_1 <= w_Switch_1;
            
            -- if current value is low AND previous value is high
            -- the finger has relased the switch
            if w_Switch_1 = '0' and r_Switch_1 = '1'
            then
                -- reset the register value
                r_Counter <= 99;
            end if;
        end if;
    end process;
    
    SevenSeg2_Inst : entity work.Binary_To_7Segment
    port map (
        i_Clk    	 => i_Clk, 
        i_Binary_Num => std_logic_vector(to_unsigned(r_Counter / 10, 4)),
        o_Segment_A  => w_Segment1_A,
        o_Segment_B  => w_Segment1_B,
        o_Segment_C  => w_Segment1_C,
        o_Segment_D  => w_Segment1_D,
        o_Segment_E  => w_Segment1_E,
        o_Segment_F  => w_Segment1_F,
        o_Segment_G  => w_Segment1_G
    );
    
    o_Segment1_A  <= not w_Segment1_A;
	o_Segment1_B  <= not w_Segment1_B;
	o_Segment1_C  <= not w_Segment1_C;
	o_Segment1_D  <= not w_Segment1_D;
	o_Segment1_E  <= not w_Segment1_E;
	o_Segment1_F  <= not w_Segment1_F;
	o_Segment1_G  <= not w_Segment1_G;
    
    SevenSeg1_Inst : entity work.Binary_To_7Segment
    port map (
        i_Clk    	 => i_Clk, 
        i_Binary_Num => std_logic_vector(to_unsigned(r_Counter MOD 10, 4)),
        o_Segment_A  => w_Segment2_A,
        o_Segment_B  => w_Segment2_B,
        o_Segment_C  => w_Segment2_C,
        o_Segment_D  => w_Segment2_D,
        o_Segment_E  => w_Segment2_E,
        o_Segment_F  => w_Segment2_F,
        o_Segment_G  => w_Segment2_G
    );
    
    o_Segment2_A  <= not w_Segment2_A;
	o_Segment2_B  <= not w_Segment2_B;
	o_Segment2_C  <= not w_Segment2_C;
	o_Segment2_D  <= not w_Segment2_D;
	o_Segment2_E  <= not w_Segment2_E;
	o_Segment2_F  <= not w_Segment2_F;
	o_Segment2_G  <= not w_Segment2_G;
    
end
architecture RTL;
