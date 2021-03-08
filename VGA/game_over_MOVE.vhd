library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;
-- Alex Grinshpun March 24 2017 

entity game_over_MOVE is
port 	(
		--////////////////////	Clock Input	 	////////////////////	 
		CLK				: in std_logic; --						//	27 MHz
		RESETn			: in std_logic; --			//	50 MHz
		ObjectStartX	: out integer ;
		ObjectStartY	: out integer
		
	);
end game_over_MOVE;

architecture behav of game_over_MOVE is 



begin
	ObjectStartX <= 50;
	ObjectStartY <= 20;
end behav;