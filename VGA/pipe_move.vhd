library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;
-- Alex Grinshpun March 24 2017 

entity pipe_move is
port 	(
		--////////////////////	Clock Input	 	////////////////////	 
		CLK				: in std_logic; --						//	27 MHz
		RESETn			: in std_logic; --			//	50 MHz
		right_move		: in std_logic; -- check if right is pressed.
		left_move		: in std_logic;	-- check if left is pressed.
		timer_done		: in std_logic;
		mario_middle	: in std_logic;
		random			: in std_logic;
		ObjectStartX	: out integer ;
		ObjectStartY	: out integer
		
	);
end pipe_move;

architecture behav of pipe_move is 


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
				ObjectStartX_t	<= 20;
				ObjectStartY_t	<= 300 ;
		elsif CLK'event  and CLK = '1' then
			if timer_done = '1' then
				if ObjectStartX_t <= 100 then
					ObjectStartX_t <= 580;
					ObjectStartY_t <= 300;
				elsif (left_move = '1')or(right_move = '1')or(pressed = '1') then
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
							ObjectStartX_t<=ObjectStartX_t-10;
							ObjectStartY_t<=ObjectStartY_t;
							next_state<=idle;
						when left_state =>
							ObjectStartX_t<=ObjectStartX_t+10;
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
			
		end if;
		present_state <= next_state;
end process;
--ObjectStartX	<= 100;			
--ObjectStartY	<= 100;		
end behav;