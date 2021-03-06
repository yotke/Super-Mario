library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;
use work.consts_pck.all;

-- Alex Grinshpun March 24 2017 

entity BOMB_MOVE_3 is
port 	(
		--////////////////////	Clock Input	 	////////////////////	 
		CLK				: in std_logic; --						//	27 MHz
		RESETn			: in std_logic; --			//	50 MHz
		right_move		: in std_logic; -- check if right is pressed.
		left_move		: in std_logic;	-- check if left is pressed.
		timer_done		: in std_logic; -- add by yotam
		drawM			: in std_logic;
		drawB			: in std_logic;
		bombC			: in std_logic;
		random			: in integer ;
		mario_middle	: in std_logic;
		ObjectStartX	: out integer ;
		ObjectStartY	: out integer
		
	);
end BOMB_MOVE_3;

architecture behav of BOMB_MOVE_3 is 


   type state is ( idle, right_state, left_state) ;   -- sample out new extended-rel code
   type automatic is (auto_up, auto_down);
signal present_state , next_state : state;
signal pressed : std_logic;
signal ObjectStartX_t : integer range 0 to 680;
signal ObjectStartY_t : integer range 0 to 512;
signal count	: integer;
signal auto_present_state : automatic;
signal auto_next_state : automatic;
signal auto_offset: integer;
begin





		process ( RESETn,CLK,present_state)
		constant auto_move_speed: integer := 4;  --must be even
		begin
		  if RESETn = '0' then
				present_state <= idle;
				next_state <= idle;
				ObjectStartX_t	<= 580;
				ObjectStartY_t	<= 350;--random ;
				count<=0;
				auto_present_state<=auto_up;
				auto_offset<= (bomb_range*auto_move_speed)/2;
		elsif CLK'event  and CLK = '1' then
			if timer_done = '1' then
				if bombC = '1' or ObjectStartX_t<0 then
						ObjectStartX_t <= 580;
						ObjectStartY_t <= 200+random;--random;
						
						
				else--if (left_move = '1')or(right_move = '1')or(pressed = '1') then
					count<=count+1;
					if auto_present_state=auto_up then
						if count<bomb_range then
							auto_offset<=auto_offset-auto_move_speed;
							auto_next_state<=auto_up;
						else 
							count<=0;
							auto_next_state<=auto_down;
							auto_offset<=(-(bomb_range*auto_move_speed))/2;
						end if;
					else
						if count<bomb_range then
							if auto_offset+ObjectStartY_t+auto_move_speed<mario_location then
								auto_offset<=auto_offset+auto_move_speed;
								auto_next_state<=auto_down;
							else
								auto_offset<=mario_location-ObjectStartY_t;
								auto_next_state<=auto_up;
								count<=0;
							end if;
						else 
							count<=0;
							auto_offset<= (bomb_range*auto_move_speed)/2;
							auto_next_state<=auto_up;
						end if;
					end if;
					case present_state is
						when idle=>
							if right_move='1' and (mario_middle='1') then
								ObjectStartX_t<=ObjectStartX_t;
								ObjectStartY_t<=ObjectStartY_t;
								pressed <= '1';
								next_state<=right_state;
								
							--elsif left_move ='1' then
								--ObjectStartX_t<=ObjectStartX_t;
								--ObjectStartY_t<=ObjectStartY_t;
								--pressed <= '1';
								--next_state<=left_state;
							end if;
							
							pressed <= '0';
						when right_state =>
							ObjectStartX_t<=ObjectStartX_t-20;
							ObjectStartY_t<=ObjectStartY_t;
							next_state<=idle;
								
						when left_state =>
							ObjectStartX_t<=ObjectStartX_t+20;
							ObjectStartY_t<=ObjectStartY_t;
							next_state<=idle;
								
						when others=>
							ObjectStartX_t<=ObjectStartX_t;
							ObjectStartY_t<=ObjectStartY_t;
							next_state<=idle;
						end case;
				end if;
			end if;
			present_state <= next_state;
			auto_present_state<= auto_next_state;
			if ObjectStartX_t<=0 then 
				ObjectStartX_t <= 680;--580;
				ObjectStartY_t <= 200+random;--random;
			end if;
		end if;
		present_state <= next_state;
		
		end process ;
ObjectStartX	<= ObjectStartX_t;			
ObjectStartY	<= ObjectStartY_t+auto_offset;	

--ObjectStartX	<= 100;			
--ObjectStartY	<= 100;		
end behav;