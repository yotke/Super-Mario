library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;
-- Alex Grinshpun March 24 2017 

entity back_ground_move is
port 	(
		--////////////////////	Clock Input	 	////////////////////	 
		CLK				: in std_logic; --						//	27 MHz
		RESETn			: in std_logic; --			//	50 MHz
		jump			: in std_logic; -- check if space is pressed.
		move_right			: in std_logic;
		move_left			: in std_logic;
		timer_done		: in std_logic;
		ObjectStartX	: out integer ;
		ObjectStartY	: out integer
		
	);
end back_ground_move;

architecture behav of back_ground_move is 
type states is (idle, right_state, left_state);
signal ObjectStartX_t : integer range 0 to 680;
signal ObjectStartY_t : integer range 0 to 512;
signal present_state,next_state : states;
begin

    process ( RESETn,CLK)

	begin
		
		if RESETn = '0' then
			ObjectStartX_t	<= 0;
			ObjectStartY_t	<= 0 ;
		elsif CLK'event  and CLK = '1' then
			

		
			if move_right='1' then
			ObjectStartX_t<= ObjectStartX_t-1;
			end if;
			if move_left='1' then
				ObjectStartX_t<= ObjectStartX_t+1;
			end if;
		end if;
		if ObjectStartX_t>480 then
			ObjectStartX_t<=0;
		end if;
		
		--present_state<=next_state;
	end process ;
ObjectStartX	<= ObjectStartX_t;			
ObjectStartY	<= ObjectStartY_t;	

--ObjectStartX	<= 100;			
--ObjectStartY	<= 100;		
end behav;