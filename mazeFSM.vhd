
package mazearray is
    type mazearray is array (0 to 20, 0 to 1) of integer range 0 to 64;
end mazearray;

library work;
use work.mazearray.all;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity maze_FSM is
    generic (  
        N : integer := 8
    );
    Port ( switch_button : in std_logic;
           switch_input : in std_logic_vector (7 downto 0);
           reset : in STD_LOGIC;
           clock : in STD_LOGIC;
           start : in STD_LOGIC;
           done : out STD_LOGIC;
           out_of_bounds : out STD_LOGIC;
           total : out integer;
           visited_array : out mazearray;
           start_x, start_y, end_x, end_y : out std_logic
           );        
end maze_FSM;

architecture Behavioral of maze_FSM is
    -- signals for starting location and target location
    signal x0, y0, xt, yt, dim : STD_LOGIC_VECTOR (7 downto 0) := (others =>'0');
    signal i, j, c : integer range 0 to 64;
    signal k : integer range 1 to 64;
    
    -- create 8 x 8 array for maze of max size
    type maze_8_8 is array (0 to N-1, 0 to N-1) of integer range 0 to 1;
    signal grid: maze_8_8;
 
    -- create 5 x 5 array for maze
    --type maze_5_5 is array (0 to N-1, 0 to N-1) of integer range 0 to 1;
    --signal grid : maze_5_5;

    -- create 3 x 3 array for maze
    --type maze_3_3 is array (0 to N-1, 0 to N-1) of integer range 0 to 1;
    --signal grid : maze_3_3;
    
    type states is (s1, s2, s2_wait, s3, s3_wait, s4, s4_wait, s5, s5_wait, s6, s7, s8, s9, s10, s11, s12);
    signal current_state : states;
    
    -- extra signals
    signal total_steps : integer range 0 to 20 := 0;
    signal x, y : integer;
    
begin
    
    process(clock)
    begin
        if rising_edge(clock) then
            if reset = '1' then
                current_state <= s1;
                done <= '0';
                out_of_bounds <= '0';
                i <= 0;
                j <= 0;
                k <= 1;
                x <= 0;
                y <= 0;
                c <= 0;
                start_x <= '0';
                start_y <= '0';
                end_x <= '0';
                end_y <= '0';
            else
                -- start collecting inputs when start
                case(current_state) is
                    when s1 =>
                        -- add obstacles
                        if switch_button = '1' then
                            -- for 8 x 8 maze:
                            grid(7,6) <= 1;
                            grid(6,6) <= 1;
                            
                            -- for 5 x 5 maze:
                            --grid(1, 1) <= 1;
                            --grid(2, 3) <= 1;
                            
                            -- for 3 x 3 maze:
                            --grid(2,1) <= 1;
                            --grid(1,2) <= 1;
                            
                            -- place initial x coordinate
                            x0 <= switch_input;
                            i <= to_integer(unsigned(switch_input));
                            visited_array(0,0) <= to_integer(unsigned(switch_input));
                            start_x <= '1';
                            current_state <= s2_wait;
                        else
                            current_state <= s1;
                        end if;
                    when s2_wait =>
                        if switch_button = '0' then
                            current_state <= s2;
                        else
                            current_state <= s2_wait;
                        end if;
                    -- place initial y coordinate
                    when s2 =>
                        if switch_button = '1' then
                            y0 <= switch_input;
                            j <= to_integer(unsigned(switch_input));
                            visited_array(0,1) <= to_integer(unsigned(switch_input));
                            start_y <= '1';
                            current_state <= s3_wait;
                        else
                            current_state <= s2;
                        end if;
                   when s3_wait =>
                        if switch_button = '0' then
                            current_state <= s3;
                        else 
                            current_state <= s3_wait;
                        end if;
                   when s3 =>
                        -- if initial coordinates are at an obstacle
                        if(grid(i, j) = 1) then
                            current_state <= s11;
                        -- place x target coordinate
                        elsif switch_button = '1' then
                            xt <= switch_input;
                            end_x <= '1';
                            current_state <= s4_wait;
                        else
                            current_state <= s3;
                        end if;
                    when s4_wait =>
                        if switch_button = '0' then
                            current_state <= s4;
                        else
                            current_state <= s4_wait;
                        end if;
                    when s4 =>
                        -- place y target coordinate
                        if switch_button = '1' then
                            yt <= switch_input;
                            end_y <= '1';
                            current_state <= s5_wait;
                        else
                            current_state <= s4;
                        end if;
                    when s5_wait =>
                        if switch_button <= '0' then
                            current_state <= s5;
                        else
                            current_state <= s5_wait;
                        end if;
                    when s5 =>
                        -- inputs are gathered for start and target location
                        -- can start traversal to get to target
                        -- go up and right priorities  
                        if start = '1' then
                            if(k > 20) then
                                current_state <= s11;
                            elsif(i = to_integer(unsigned(xt)) and (j = to_integer(unsigned(yt)))) then
                                current_state <= s9;
                            -- hit obstacle or wall    
                            elsif ((j >= (N-1)) or (j = to_integer(unsigned(yt)))) then
                                current_state <= s6;
                            -- go up
                            elsif((grid(i, j + 1) = 0) and (j < (N-1))) then
                                -- check if robot can go up
                                j <= j + 1;
                                k <= k + 1;
                                visited_array(k,0) <= i;
                                visited_array(k,1) <= j + 1;
                                current_state <= s5;
                            else
                                current_state <= s6;
                            end if;
                        end if;
                    when s6 =>
                            if(k > 20) then
                                current_state <= s11;
                            elsif(i = to_integer(unsigned(xt)) and (j = to_integer(unsigned(yt)))) then
                                current_state <= s9;
                            elsif((i >= (N-1)) or (i = to_integer(unsigned(xt)))) then
                                -- reached wall or reached column of target
                                current_state <= s7;
                            -- go right
                            elsif((grid(i + 1, j) = 0) and (i < (N-1))) then
                                -- right cell is not blocked, so can move in right direction
                                -- also check cell is not visited   
                                i <= i + 1;              
                                k <= k + 1;
                                visited_array(k,0) <= i + 1;
                                visited_array(k,1) <= j;
                                current_state <= s5;
                            else
                                current_state <= s7;
                            end if;
                    when s7 =>
                        if(k > 20) then
                            current_state <= s11;
                        elsif(i = to_integer(unsigned(xt)) and (j = to_integer(unsigned(yt)))) then
                            current_state <= s9;
                        elsif (i = 0) then
                            current_state <= s8;
                        -- go left
                        elsif ((grid(i - 1, j) = 0) and (i >= 0)) then
                            -- check if robot can go left
                            i <= i - 1;
                            k <= k + 1;
                            visited_array(k,0) <= i - 1;
                            visited_array(k,1) <= j;
                            current_state <= s5;
                        else    
                            current_state<= s8;
                        end if;
                    when s8 =>
                        if(k > 20) then
                            current_state <= s11;
                        elsif(i = to_integer(unsigned(xt)) and (j = to_integer(unsigned(yt)))) then
                            current_state <= s9;
                        elsif (j = 0) then
                            current_state <= s9;
                        -- go down
                        elsif ((grid(i, j - 1) = 0) and (j >= 0)) then
                            -- check if robot can go down
                            j <= j - 1;
                            k <= k + 1;
                            visited_array(k,0) <= i;
                            visited_array(k,1) <= j - 1;
                            current_state <= s5;
                        else 
                            current_state <= s9;
                        end if;
                    when s9 =>
                        -- state to check if robot is in target location
                        if(i = to_integer(unsigned(xt)) and (j = to_integer(unsigned(yt)))) then
                            -- target point is reached
                            done <= '1';
                            current_state <= s10;
                            total_steps <= k - 1;
                        else
                            current_state <= s5;
                        end if;
                    when s10 =>
                        -- state to output to LED for done, start placing coordinates to OLED
                        done <= '1';
                        current_state <= s12;   
                        total <= total_steps;                           
                    when s11 =>
                        -- error state, maze is impossible to solve
                        out_of_bounds <= '1';
                        done <= '1';
                        total <= 21;
                        current_state <= s12;
                    when s12 =>
                        current_state <= s12;                        
                end case;
            end if;
        end if;
    end process;

end Behavioral;

