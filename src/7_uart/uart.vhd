library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity UART is
    port (
      -- main clock 25 MHz
        i_Clk        : in std_logic;
        
        i_Switch_1   : in std_logic;
        
        i_UART_RX   : in std_logic;
        
        o_LED_1      : out std_logic;
        o_LED_2      : out std_logic;
        o_LED_3      : out std_logic;
        o_LED_4      : out std_logic;
        
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
end entity UART;

architecture RTL of UART is
    
    --25000000 clock / 1 seconde
    --115200   bauds / 1 seconde => 115200 bits en 1 seconde
    --durée d'un baud en cycle: 25000000/115200/8 : 217
    
    type T_STATE is (STARTED, STOPPED);
    
    signal r_LedCounter : integer range 0 to 4 := 0;
    signal r_TimeCount : integer range 0 to 10000 := 0;
    signal r_time      : integer range 0 to 1000 := 0;
                                                 -- 250000 10 ms
    signal r_LED_1     : std_logic := '0';
    signal r_LED_2     : std_logic := '0';
    signal r_LED_3     : std_logic := '0';
    signal r_LED_4     : std_logic := '0';
    
    signal r_counter   : integer range 0 to 10 := 0;
    signal r_num       : integer range 0 to 255 := 0;
    signal r_num2      : std_logic_vector(3 downto 0) := "0000";
    signal r_num3      : std_logic_vector(3 downto 0) := "0000";
    signal r_state     : T_STATE := STOPPED;
    
    signal r_Switch_1 : std_logic := '0';
    signal w_Switch_1 : std_logic := '0';
    
    signal w_Segment1_A : std_logic := '0';
	signal w_Segment1_B : std_logic := '0';
	signal w_Segment1_C : std_logic := '0';
	signal w_Segment1_D : std_logic := '0';
	signal w_Segment1_E : std_logic := '0';
	signal w_Segment1_F : std_logic := '0';
	signal w_Segment1_G : std_logic := '0';
	
	signal w_Segment2_A : std_logic := '0';
	signal w_Segment2_B : std_logic := '0';
	signal w_Segment2_C : std_logic := '0';
	signal w_Segment2_D : std_logic := '0';
	signal w_Segment2_E : std_logic := '0';
	signal w_Segment2_F : std_logic := '0';
	signal w_Segment2_G : std_logic := '0';

begin
    -- Instantiate a debounce filter
    Debounce_Inst1 : entity work.Debounce_Switch
    port map (
        i_Clk    => i_Clk, 
        i_Switch => i_Switch_1,
        o_Switch => w_Switch_1
    );

    r_num3(0) <= '0';
    r_num3(1) <= '1';
    r_num3(2) <= '0';
    r_num3(3) <= '0';
    
    p_Sampler : process (i_Clk) is
    begin
        if rising_edge(i_Clk)
        then
            r_Switch_1 <= w_Switch_1;
            if w_Switch_1 = '0' and r_Switch_1 = '1'
            then
                w_Segment2_A  <= '0';
                w_Segment2_B  <= '0';
                w_Segment2_C  <= '0';
                w_Segment2_D  <= '0';
                w_Segment2_E  <= '0';
                w_Segment2_F  <= '0';
                w_Segment2_G  <= '0';
                
                w_Segment1_A  <= '0';
                w_Segment1_B  <= '0';
                w_Segment1_C  <= '0';
                w_Segment1_D  <= '0';
                w_Segment1_E  <= '0';
                w_Segment1_F  <= '0';
                w_Segment1_G  <= '0';
                        
                r_LED_1 <= '0';
                r_LED_2 <= '0';
                r_LED_3 <= '0';
                r_LED_4 <= '0';
                r_time <= 0;
                r_counter <= 0;
                r_state <= STOPPED;
            else                
                if r_state = STOPPED
                then
                    if i_UART_RX = '0'
                    then
                        r_LED_1 <= '1';
                        --r_time <= 325;
                        r_time <= 217 + (217 / 2) + 80;
                        r_state <= STARTED;
                    end if;
                else
                    
                    if r_TimeCount < r_time
                    then
                        r_TimeCount <= r_TimeCount + 1;
                    else
                        r_TimeCount <= 0;
                        r_time <= 217;
                        
                        if i_UART_RX = '1'
                        then
                            if r_counter = 0
                            then
                                --r_LED_2 <= '1';
                                w_Segment2_A  <= '1';
                                r_counter <= r_counter + 1;
                            elsif r_counter = 1
                            then
                                w_Segment2_B  <= '1';
                                r_counter <= r_counter + 1;
                            elsif r_counter = 2
                            then
                                w_Segment2_C  <= '1';
                                r_counter <= r_counter + 1;
                            elsif r_counter = 3
                            then
                                w_Segment2_D  <= '1';
                                r_counter <= r_counter + 1;
                            elsif r_counter = 4
                            then
                                w_Segment2_E  <= '1';
                                r_counter <= r_counter + 1;
                            elsif r_counter = 5
                            then
                                w_Segment2_F  <= '1';
                                r_counter <= r_counter + 1;
                            elsif r_counter = 6
                            then
                                w_Segment2_G  <= '1';
                                r_counter <= r_counter + 1;
                            elsif r_counter = 7
                            then                        
                                w_Segment1_A  <= '1';
                                r_counter <= r_counter + 1;
                            elsif r_counter = 8
                            then
                                w_Segment1_B  <= '1';
                                r_counter <= r_counter + 1;
                            elsif r_counter = 9
                            then
                                w_Segment1_C  <= '1';
                                r_counter <= r_counter + 1;
                            else
                                w_Segment1_D  <= '1';
                                --r_counter <= r_counter + 1;
                            end if;
                            
                            --r_LED_2 <= '0';
                        else
                            --r_LED_1 <= '0';
                            --r_LED_2 <= '1';
                            r_counter <= r_counter + 1;
                        end if;
                    end if;
                end if;
            end if;
        end if;
    end process;

    o_LED_1 <= r_LED_1;
    o_LED_2 <= r_LED_2;
    o_LED_3 <= r_LED_3;
    o_LED_4 <= r_LED_4;
    
    --SevenSeg1_Inst : entity work.Binary_To_7Segment
    --port map (
    --    i_Clk    	 => i_Clk, 
    --    i_Binary_Num => r_num2,
    --    o_Segment_A  => w_Segment2_A,
    --    o_Segment_B  => w_Segment2_B,
    --    o_Segment_C  => w_Segment2_C,
    --    o_Segment_D  => w_Segment2_D,
    --    o_Segment_E  => w_Segment2_E,
    --    o_Segment_F  => w_Segment2_F,
    --    o_Segment_G  => w_Segment2_G
    --);
    
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