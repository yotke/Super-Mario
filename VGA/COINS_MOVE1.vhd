library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;
-- Alex Grinshpun March 24 2017 

entity COINS_MOVE1 is
port 	(
		--////////////////////	Clock Input	 	////////////////////	 
		CLK				: in std_logic; --						//	27 MHz
		RESETn			: in std_logic; --			//	50 MHz
		right_move		: in std_logic; -- check if right is pressed.
		left_move		: in std_logic;	-- check if left is pressed.
		coinC			: in std_logic;
		timer_done		: in std_logic;
		mario_middle	: in std_logic;
		random			: in integer;
		ObjectStartX	: out integer ;
		ObjectStartY	: out integer
		
	);
end COINS_MOVE1;

architecture behav of COINS_MOVE1 is 


   type state is ( idle, right_state, left_state) ;   -- sample out new extended-rel code
signal present_state , next_state : state;
signal pressed : std_logic;
signal ObjectStartX_t : integer range 0 to 680;
signal ObjectStartY_t : integer range 0 to 512;
begin





		process ( RESETn,CLK,present_state)
		begin
		  if RESETn = '0' then
				present_state <= idle;
				next_state <= idle;
				ObjectStartX_t	<= 400;
				ObjectStartY_t	<= 380;
		elsif CLK'event  and CLK = '1' then
			if coinC = '1' then
				ObjectStartX_t <= 580;
				ObjectStartY_t <= 200+random;
			end if;
			if timer_done = '1' then
				if (left_move = '1')or(right_move = '1')or(pressed = '1') then
					case present_state is
						when idle=>
							if right_move='1' and mario_middle='1' then
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
			if ObjectStartX_t<=0 then 
				ObjectStartX_t <= 580;
				ObjectStartY_t <= 200 + random;--random;
			end if;
			
		end if;
		present_state <= next_state;
		end process ;
ObjectStartX	<= ObjectStartX_t;			
ObjectStartY	<= ObjectStartY_t;	

--ObjectStartX	<= 100;			
--ObjectStartY	<= 100;		
end behav;