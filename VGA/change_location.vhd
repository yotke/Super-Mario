library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;
-- Alex Grinshpun March 24 2017 

entity change_location is
port 	(
		--////////////////////	Clock Input	 	////////////////////	 
		CLK				: in std_logic; --						//	27 MHz
		RESETn			: in std_logic; --			//	50 MHz
		ObjectStartX_in	:in integer;
		ObjectStartY_in	: in integer;
		ObjectStartX_out1	: out integer;
		ObjectStartY_out1	: out integer;
		ObjectStartX_out2	: out integer;
		ObjectStartY_out2	: out integer;
		ObjectStartX_out3	: out integer;
		ObjectStartY_out3	: out integer		
	);
end change_location;

architecture behav of change_location is 



begin
	ObjectStartX_out1 <= objectStartX_in;
	ObjectStartY_out1 <= ObjectStartY_in;
	ObjectStartX_out2 <= objectStartX_in+300;
	ObjectStartY_out2 <= ObjectStartY_in+50;
	ObjectStartX_out3 <= objectStartX_in+200;
	ObjectStartY_out3 <= ObjectStartY_in;
end behav;