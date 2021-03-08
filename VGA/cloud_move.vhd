library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;
-- Alex Grinshpun March 24 2017 

entity cloud_move is
port 	(
		--////////////////////	Clock Input	 	////////////////////	 
		CLK				: in std_logic; --						//	27 MHz
		RESETn			: in std_logic; --			//	50 MHz
		right_move		: in std_logic; -- check if right is pressed.
		left_move		: in std_logic;	-- check if left is pressed.
		timer_done		: in std_logic;
		ObjectStartX	: out integer ;
		ObjectStartY	: out integer
		
	);
end cloud_move;

architecture behav of cloud_move is 


signal ObjectStartX_t : integer range 0 to 680;
signal ObjectStartY_t : integer range 0 to 512;
begin





		process ( RESETn,CLK)
		begin
		  if RESETn = '0' then
				ObjectStartX_t	<= 100;
				ObjectStartY_t	<= 50;
		elsif CLK'event  and CLK = '1' then
			if timer_done = '1' then
				if ObjectStartX_t <= -50 then
					ObjectStartX_t <= 670;
					ObjectStartY_t <= 50;
				else
					ObjectStartX_t<=ObjectStartX_t-2;
				end if;
			end if;			
		end if;
		end process ;
ObjectStartX	<= ObjectStartX_t;			
ObjectStartY	<= ObjectStartY_t;	

--ObjectStartX	<= 100;			
--ObjectStartY	<= 100;		
end behav;