library work;
use work.mazearray.all;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mazeFSM_tb is
--  Port ( );
end mazeFSM_tb;

architecture Behavioral of mazeFSM_tb is
    signal sw_button, oled_button : std_logic;
    signal sw_input : std_logic_vector (7 downto 0);
    signal rst, reset, clk : STD_LOGIC;
    signal start1 : STD_LOGIC;
    signal done1 : STD_LOGIC := '0';
    signal oob : STD_LOGIC := '0';
    signal v_array : mazearray;
    signal fsm_total : integer;
    signal x0, y0, xt, yt : std_logic;
begin
	maze : entity work.maze_FSM(Behavioral)
		port map(
		  switch_button => sw_button,
           switch_input => sw_input,
           reset => rst,
           clock => clk,
           start => start1,
           done => done1,
           out_of_bounds => oob,
           total => fsm_total,
           visited_array => v_array,
           start_x => x0, 
           start_y => y0, 
           end_x => xt,
           end_y => yt
        );
	
    -- clock generator
	process
	begin
		clk <= '1';
		wait for 20 ns;
		clk <= '0';
		wait for 20 ns;
	end process;
	
	
	-- reset generator
	process
	begin
		rst <= '1';
		wait for 20 ns;
		rst <= '0';
		wait;
	end process;
	
	-- test for FSM
	-- inputs for x0, y0, xt, yt might need to be changed depending on maze
	process begin
	    start1 <= '1';
	    
		-- this one stays for timing purposes
	    sw_input <= "00000000";
	    sw_button <= '1';
	    
	    wait for 40 ns;
	    
	    sw_button <= '0';
	    
	    wait for 40 ns;
	    
	    -- 3x3 maze has start(0,1) and target(2,2) (need to uncomment depending on size)
	    -- 5x5 maze has start(0,1) and target(3,4)
	    -- 8x8 maze has start(0,1) and target(7,7)
		-- start with x0
        sw_input <= "00000000";
        sw_button <= '1';
        
        wait for 30 ns;
    
        sw_button <= '0';
        
        wait for 40 ns;
        
		-- y0
        sw_button <= '1';
        sw_input <= "00000001";
        
        wait for 40 ns;
        
        sw_button <= '0';
        
        wait for 40 ns;
        
		-- xt
        -- 3x3 target
        --sw_input <= "00000010";   
        
        -- 5x5 target
        --sw_input <= "00000011";
		
		-- 8x8 target
        sw_input <= "00000111";
        sw_button <= '1';
        
        wait for 40 ns;
    
        sw_button <= '0';
        
        wait for 40 ns;
        
		-- yt
        sw_button <= '1';
        
        -- 3x3 target
        --sw_input <= "00000010";   
        
        -- 5x5 target 
        --sw_input <= "00000100"; 
           
        -- 8x8 target
        sw_input <= "00000111";
        
        wait for 40 ns;
        
        sw_button <= '0';
        
        
        wait;
    end process;   
    
end Behavioral;