
library work;
use work.mazearray.all;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_arith.all;


-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity oled_test is
port (  clk         : in std_logic;
        rst         : in std_logic;
--        switch_button : in std_logic;
        switches : in std_logic_vector(7 downto 0);
--        fsm_start : in std_logic;
--        oled_button : in std_logic;
        fsm_done : out std_logic;
        out_of_bounds : out std_logic;
--        total : out integer;
        
        LD4 : out std_logic;
        LD5 : out std_logic;
        LD6 : out std_logic;
        LD7 : out std_logic;
            -- The following ports go to on-board OLED display
            oled_sdin   : out std_logic;
            oled_sclk   : out std_logic;
            oled_dc     : out std_logic;
            oled_res    : out std_logic;
            oled_vbat   : out std_logic;
            oled_vdd    : out std_logic;
            
            -- On-board LED
--            led0     : out std_logic;
--            led1     : out std_logic;
--            led2     : out std_logic;
--            led3     : out std_logic;
--            led4     : out std_logic;
--            led5     : out std_logic;
--            led6     : out std_logic;
--            led7     : out std_logic;

            -- On-Board push buttons
            BTND     : in std_logic;        
            BTNU     : in std_logic;        
            BTNL     : in std_logic;        
            BTNR     : in std_logic
            
            -- On-Board user switches
--            sw0     : in std_logic;        
--            sw1     : in std_logic;        
--            sw2     : in std_logic;        
--            sw3     : in std_logic;        
--            sw4     : in std_logic;        
--            sw5     : in std_logic;        
--            sw6     : in std_logic;        
--            sw7     : in std_logic        
            );
end oled_test;

architecture Behavioral of oled_test is
   signal start, ready, valid, refresh : std_logic;
   signal din : std_logic_vector(7 downto 0);
   
   type state_t is (Idle, dxfer, disp, Done);
   signal State  : state_t;
   
    type oled_row is array(0 to 15) of std_logic_vector(7 downto 0);
     type oled_page is array (0 to 3) of oled_row;
        
     signal oled_screen : oled_page := ( 
                                         (x"40", x"41", x"42",  x"43", x"44", x"45", x"46",x"47", x"48", x"49", x"4A", x"4B", x"4C", x"4D", x"4E", x"4F"),
                                         (x"40", x"41", x"42",  x"43", x"44", x"45", x"46",x"47", x"48", x"49", x"4A", x"4B", x"4C", x"4D", x"4E", x"4F"),
                                         (x"40", x"41", x"42",  x"43", x"44", x"45", x"46",x"47", x"48", x"49", x"4A", x"4B", x"4C", x"4D", x"4E", x"4F"),
                                         (x"40", x"41", x"42",  x"43", x"44", x"45", x"46",x"47", x"48", x"49", x"4A", x"4B", x"4C", x"4D", x"4E", x"4F")
                                         );
   signal screen_change : std_logic;
   --signal count : unsigned(25 downto 0);
   signal led_ctrl : std_logic_vector(7 downto 0);
   signal new_input_disp : oled_row;
   signal new_input_ready : std_logic;
   signal new_input_done : std_logic;
   
   signal btnd_db : std_logic;
   
--   signal btnu_db, btnd_db, btnl_db, btnr_db : std_logic;
--   signal sw0_db, sw1_db, sw2_db, sw3_db, sw4_db, sw5_db, sw6_db, sw7_db : std_logic;
--   signal sw0_r, sw1_r, sw2_r, sw3_r, sw4_r, sw5_r, sw6_r, sw7_r : std_logic;
--   signal sw0_f, sw1_f, sw2_f, sw3_f, sw4_f, sw5_f, sw6_f, sw7_f : std_logic;
   
   -- new signals for maze fsm
    signal v_array : mazearray;
--    signal fsm_done, out_of_bounds : std_logic;
    signal total_out : integer;
   
begin
   -- PB debouncing
--   db_btnu : entity work.debouncer(arch)
--      port map(clk => clk, reset => rst, sw => BTNU, db => btnu_db);

   db_btnd : entity work.debouncer(arch)
      port map(clk => clk, reset => rst, sw => BTND, db => btnd_db);

--   db_btnl : entity work.debouncer(arch)
--      port map(clk => clk, reset => rst, sw => BTNL, db => btnl_db);

--   db_btnr : entity work.debouncer(arch)
--      port map(clk => clk, reset => rst, sw => BTNR, db => btnr_db);

   -- User SW debouncing
--   db_sw0 : entity work.debouncer(arch)
--      port map(clk => clk, reset => rst, sw => sw0, db => sw0_db);
      
--   db_sw1 : entity work.debouncer(arch)
--      port map(clk => clk, reset => rst, sw => sw1, db => sw1_db);
         
--   db_sw2 : entity work.debouncer(arch)
--      port map(clk => clk, reset => rst, sw => sw2, db => sw2_db);
         
--   db_sw3 : entity work.debouncer(arch)
--      port map(clk => clk, reset => rst, sw => sw3, db => sw3_db);
         
--   db_sw4 : entity work.debouncer(arch)
--       port map(clk => clk, reset => rst, sw => sw4, db => sw4_db);
         
--    db_sw5 : entity work.debouncer(arch)
--       port map(clk => clk, reset => rst, sw => sw5, db => sw5_db);
            
--    db_sw6 : entity work.debouncer(arch)
--       port map(clk => clk, reset => rst, sw => sw6, db => sw6_db);
            
--    db_sw7 : entity work.debouncer(arch)
--       port map(clk => clk, reset => rst, sw => sw7, db => sw7_db);
         
   -- Edge detection on the debounced SW 
--   edge_sw0 : entity work.edge_detector(arch)
--      port map(clk => clk, rst => rst, i => sw0_db, rising => sw0_r, falling => sw0_f);
      
--   edge_sw1 : entity work.edge_detector(arch)
--      port map(clk => clk, rst => rst, i => sw1_db, rising => sw1_r, falling => sw1_f);
         
--   edge_sw2 : entity work.edge_detector(arch)
--      port map(clk => clk, rst => rst, i => sw2_db, rising => sw2_r, falling => sw2_f);
            
--   edge_sw3 : entity work.edge_detector(arch)
--      port map(clk => clk, rst => rst, i => sw3_db, rising => sw3_r, falling => sw3_f);
             
--   edge_sw4 : entity work.edge_detector(arch)
--      port map(clk => clk, rst => rst, i => sw4_db, rising => sw4_r, falling => sw4_f);
         
--   edge_sw5 : entity work.edge_detector(arch)
--      port map(clk => clk, rst => rst, i => sw5_db, rising => sw5_r, falling => sw5_f);
            
--   edge_sw6 : entity work.edge_detector(arch)
--      port map(clk => clk, rst => rst, i => sw6_db, rising => sw6_r, falling => sw6_f);
               
--   edge_sw7 : entity work.edge_detector(arch)
--      port map(clk => clk, rst => rst, i => sw7_db, rising => sw7_r, falling => sw7_f);
         
   
   -- OLED controller
   oled : entity work.oled_ctrl(behavioral) 
       port map (  clk => clk, rst => rst, 
               oled_sdin => oled_sdin,
               oled_sclk =>                oled_sclk,  
               oled_dc =>                oled_dc,
               oled_res =>                oled_res,
               oled_vbat =>                oled_vbat,
               oled_vdd =>                oled_vdd,
               start => start,
               ready=> ready,
               din => din, 
               valid => valid,
               refresh => refresh );
               
   -- Test process for oled_ctrl
   process(clk)
      variable screen_row : integer range 0 to 3;
      variable screen_col : integer range 0 to 15;
      variable cur_row : integer range 0 to 4;
   begin
      if rising_edge(clk) then
         if rst = '1' then
            State <= Idle;
            start <= '0';
            refresh <= '0';
            valid <= '0';
            oled_screen <= ( 
                                    (x"40", x"41", x"42",  x"43", x"44", x"45", x"46",x"47", x"48", x"49", x"4A", x"4B", x"4C", x"4D", x"4E", x"4F"),
                                    (x"40", x"41", x"42",  x"43", x"44", x"45", x"46",x"47", x"48", x"49", x"4A", x"4B", x"4C", x"4D", x"4E", x"4F"),
                                    (x"40", x"41", x"42",  x"43", x"44", x"45", x"46",x"47", x"48", x"49", x"4A", x"4B", x"4C", x"4D", x"4E", x"4F"),
                                    (x"40", x"41", x"42",  x"43", x"44", x"45", x"46",x"47", x"48", x"49", x"4A", x"4B", x"4C", x"4D", x"4E", x"4F")
                            );
         else
            case State is
               when Idle =>
                  start <= '1';
                  if ready = '1' then
                     screen_row := 0;
                     screen_col := 0;
                     State <= dxfer;
                  end if;
               when dxfer =>
                  if ready = '1' then
                     din <= oled_screen(screen_row)(screen_col);
                     valid <= '1';
                  end if;
                  if screen_row = 3 and screen_col = 15 then
                     State <= Disp;
                  else
                     if screen_col /= 15 then
                        screen_col := screen_col + 1;
                     else
                        screen_col := 0;
                        screen_row := screen_row + 1;
                     end if;
                  end if;
               when Disp =>
                  refresh <= '1';
                  valid <= '0';
                  State <= Done;
               when Done => 
                  --start <= '0';
                  refresh <= '0';
                  if new_input_ready = '1' then
                     if cur_row = 4 then
                        oled_screen(0) <= oled_screen(1);
                        oled_screen(1) <= oled_screen(2);
                        oled_screen(2) <= oled_screen(3);
                        oled_screen(3) <= new_input_disp;
                     else
                        oled_screen(cur_row) <= new_input_disp;
                        cur_row := cur_row + 1;
                     end if;
                     State <= Idle;
                  end if;
            end case;              
         end if;
      end if;
   end process;
   
   new_input_done <= '1' when State = Done else
                     '0';
                     
   -- mazeFSM instantiation
   maze_design : entity work.maze_FSM(Behavioral)
      port map(switch_button => BTNU,
         switch_input => switches,
         reset => BTNL,
         clock => clk,
         start => BTNR,
--         oled_button => BTND,
         done => fsm_done,
         out_of_bounds => out_of_bounds,
         total => total_out,
         visited_array => v_array,
         start_x => LD4, 
         start_y => LD5, 
         end_x => LD6,
         end_y => LD7
         );

   
   -- User SW and PB sampler
   process(clk)
      variable State : state_t;
      variable input_change : std_logic;
      variable v_count : integer := 0;
      variable x_decimal, y_decimal, total_10, total_1 : integer;
      variable x, y, total10, total1 : std_logic_vector (7 downto 0);
   begin
      if rising_edge(clk) then
         if rst = '1' then
            new_input_disp <= (others => x"20");
            new_input_ready <= '0';
            State := Idle;
            v_count := 0;
         else
            case State is
            when Idle => 
               input_change := '1';
               if btnd_db = '1' then                
                    --new_input_disp <= ((std_logic_vector(unsigned(switches((7 downto 0))) + 48)), x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20");
                 if (total_out = 21) then
                     -- impossible state
                     new_input_disp <= (x"49", x"4D", x"50", x"4F", x"53", x"53", x"49", x"42", x"4C", x"45", x"20", x"20", x"20", x"20", x"20", x"20"); 
                 elsif(v_count <= total_out) then
                      -- convert to ASCII
                      x_decimal := v_array(v_count, 0) + 48;
                      y_decimal := v_array(v_count, 1) + 48;
                      -- make them 8 bits
                      x := CONV_STD_LOGIC_VECTOR(x_decimal, 8);
                      y := CONV_STD_LOGIC_VECTOR(y_decimal, 8);
                      new_input_disp <= (x"5B", x, x"2C",  y, x"5D", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20");
                      v_count := v_count + 1;                     
                 else
                      -- get each digit of 2 digit number 
                      total_10 := (total_out / 10) + 48;
                      total_1 := (total_out mod 10) + 48;
                      -- convert to ASCII
                      total10 := CONV_STD_LOGIC_VECTOR(total_10, 8);
                      total1 := CONV_STD_LOGIC_VECTOR(total_1, 8);
                      new_input_disp <= (total10, total1, x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20");
                 end if;
--               elsif btnd_db = '1' then
--                  new_input_disp <= (x"42", x"54", x"4e",  x"44", x"20", x"70", x"72", x"65", x"73", x"73", x"65", x"64", x"2e", x"20", x"20", x"20");
--               elsif btnl_db = '1' then
--                  new_input_disp <= (x"42", x"54", x"4e",  x"4c", x"20", x"70", x"72", x"65", x"73", x"73", x"65", x"64", x"2e", x"20", x"20", x"20");
--               elsif btnr_db = '1' then
--                  new_input_disp <= (x"42", x"54", x"4e",  x"52", x"20", x"70", x"72", x"65", x"73", x"73", x"65", x"64", x"2e", x"20", x"20", x"20");
--               elsif sw0_r = '1' then
--                  new_input_disp <= (x"73", x"77", x"30",  x"20", x"2d", x"2d", x"3e", x"20", x"27", x"31", x"27", x"20", x"20", x"20", x"20", x"20");
--               elsif sw0_f = '1' then
--                     new_input_disp <= (x"73", x"77", x"30",  x"20", x"2d", x"2d", x"3e", x"20", x"27", x"30", x"27", x"20", x"20", x"20", x"20", x"20");
--               elsif sw1_r = '1'  then
--                  new_input_disp <= (x"73", x"77", x"31",  x"20", x"2d", x"2d", x"3e", x"20", x"27", x"31", x"27", x"20", x"20", x"20", x"20", x"20");
--               elsif sw1_f = '1'  then
--                     new_input_disp <= (x"73", x"77", x"31",  x"20", x"2d", x"2d", x"3e", x"20", x"27", x"30", x"27", x"20", x"20", x"20", x"20", x"20");
--               elsif sw2_r = '1'  then
--                     new_input_disp <= (x"73", x"77", x"32",  x"20", x"2d", x"2d", x"3e", x"20", x"27", x"31", x"27", x"20", x"20", x"20", x"20", x"20");
--               elsif sw2_f = '1'  then
--                     new_input_disp <= (x"73", x"77", x"32",  x"20", x"2d", x"2d", x"3e", x"20", x"27", x"30", x"27", x"20", x"20", x"20", x"20", x"20");
--               elsif sw3_r = '1'  then
--                     new_input_disp <= (x"73", x"77", x"33",  x"20", x"2d", x"2d", x"3e", x"20", x"27", x"31", x"27", x"20", x"20", x"20", x"20", x"20");
--               elsif sw3_f = '1'  then
--                     new_input_disp <= (x"73", x"77", x"33",  x"20", x"2d", x"2d", x"3e", x"20", x"27", x"30", x"27", x"20", x"20", x"20", x"20", x"20");
--               elsif sw4_r = '1'  then
--                      new_input_disp <= (x"73", x"77", x"34",  x"20", x"2d", x"2d", x"3e", x"20", x"27", x"31", x"27", x"20", x"20", x"20", x"20", x"20");
--               elsif sw4_f = '1'  then
--					new_input_disp <= (x"73", x"77", x"34",  x"20", x"2d", x"2d", x"3e", x"20", x"27", x"30", x"27", x"20", x"20", x"20", x"20", x"20");
--               elsif sw5_r = '1'  then
--                      new_input_disp <= (x"73", x"77", x"35",  x"20", x"2d", x"2d", x"3e", x"20", x"27", x"31", x"27", x"20", x"20", x"20", x"20", x"20");
--               elsif sw5_f = '1'  then
--					new_input_disp <= (x"73", x"77", x"35",  x"20", x"2d", x"2d", x"3e", x"20", x"27", x"30", x"27", x"20", x"20", x"20", x"20", x"20");
--               elsif sw6_r = '1'  then
--                      new_input_disp <= (x"73", x"77", x"36",  x"20", x"2d", x"2d", x"3e", x"20", x"27", x"31", x"27", x"20", x"20", x"20", x"20", x"20");
--               elsif sw6_f = '1'  then
--					new_input_disp <= (x"73", x"77", x"36",  x"20", x"2d", x"2d", x"3e", x"20", x"27", x"30", x"27", x"20", x"20", x"20", x"20", x"20");
--               elsif sw7_r = '1'  then
--                      new_input_disp <= (x"73", x"77", x"37",  x"20", x"2d", x"2d", x"3e", x"20", x"27", x"31", x"27", x"20", x"20", x"20", x"20", x"20");
--               elsif sw7_f = '1'  then
--					new_input_disp <= (x"73", x"77", x"37",  x"20", x"2d", x"2d", x"3e", x"20", x"27", x"30", x"27", x"20", x"20", x"20", x"20", x"20");

               else
                  input_change := '0';
               end if;
               if input_change = '1' then
                  new_input_ready <= '1';
                  State := Done;
               end if;
            when Done =>
               if new_input_done = '1' then
                  new_input_ready <= '0';
                  State := Disp;
               end if;
            when Disp =>
               if btnd_db = '0' then
                  State := Idle;
               end if;
            when others =>
               State := State;
            end case; 
         end if;
      end if;
   end process;
   
   -- LED tester
--   process(clk)
--   begin
--      if rising_edge(clk) then
--         if rst = '1' then 
--            count <= (others => '0');
--         else 
--            count <= count + 1;
--         end if;
--      end if;
--   end process;
   
--   led_ctrl(0) <= '1' when (count(25 downto 23)="000" or BTNU = '1') else
--                  '0';
--   led_ctrl(1) <= '1' when (count(25 downto 23)="001" or BTNU = '1') else
--                     '0';
--   led_ctrl(2) <= '1' when (count(25 downto 23)="010" or BTND = '1') else
--                              '0';
--   led_ctrl(3) <= '1' when count(25 downto 23)="011" or BTND = '1' else
--                                       '0';    
--   led_ctrl(4) <= '1' when count(25 downto 23)="100" or BTNL = '1' else
--            '0';
--   led_ctrl(5) <= '1' when count(25 downto 23)="101" or BTNL = '1' else
--         '0';
--   led_ctrl(6) <= '1' when count(25 downto 23)="110" or BTNR = '1' else
--            '0';
--   led_ctrl(7) <= '1' when count(25 downto 23)="111" or BTNR = '1' else
--         '0';       
         
--   led0 <= led_ctrl(0) and sw0;
--   led1 <= led_ctrl(1) and sw1;
--   led2 <= led_ctrl(2) and sw2;
--   led3 <= led_ctrl(3) and sw3;
--   led4 <= led_ctrl(4) and sw4;
--   led5 <= led_ctrl(5) and sw5;
--   led6 <= led_ctrl(6) and sw6;
--   led7 <= led_ctrl(7) and sw7;  
 
end Behavioral;
