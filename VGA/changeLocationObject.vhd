library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;
-- Alex Grinshpun March 24 2017 

entity changeLocationObject is
port 	(
		--////////////////////	Clock Input	 	////////////////////	 
		CLK					: in std_logic; --						//	27 MHz
		RESETn				: in std_logic; --			//	50 MHz
		ObjectStartX_in		:in integer;
		ObjectStartY_in		: in integer;
		timer_done		: in std_logic; -- add by yotam
		enable			: in std_logic;
		move_right		: in std_logic;
		random				: in integer;
		ObjectStartX_out1	: out integer;
		ObjectStartY_out1	: out integer;
		ObjectStartX_out2	: out integer;
		ObjectStartY_out2	: out integer;
		ObjectStartX_out3	: out integer;
		ObjectStartY_out3	: out integer		
	);
end changeLocationObject;

architecture behav of changeLocationObject is
 
type states is (idle, right_state);
signal present_state,next_state   : states;
signal counter : integer;
signal counter1 : integer;
signal outX1_S : integer;
signal outY1_S : integer;
signal outX2_S : integer;
signal outY2_S : integer;
signal outX3_S : integer;
signal outY3_S : integer;


begin
	process(CLK, RESETn)
	begin
		if RESETn = '0' then
			counter <= 1;
			counter <= 100000;
			ObjectStartX_out1 <= ObjectStartY_in;
			ObjectStartY_out1 <= ObjectStartY_in;
			ObjectStartX_out2 <= objectStartX_in+50;
			ObjectStartY_out2 <= ObjectStartY_in;
			ObjectStartX_out3 <= objectStartX_in+100;
			ObjectStartY_out3 <= ObjectStartY_in;
		elsif CLK'event  and CLK = '1' then
				if timer_done = '1' then
					ObjectStartX_out1 <= ObjectStartX_in;
					ObjectStartY_out1 <= ObjectStartY_in;
					ObjectStartX_out2 <= objectStartX_in+50;
					ObjectStartY_out2 <= ObjectStartY_in-50;
					ObjectStartX_out3 <= objectStartX_in+100;
					ObjectStartY_out3 <= ObjectStartY_in;

				else
					ObjectStartX_out1 <= ObjectStartX_in;
					ObjectStartY_out1 <= ObjectStartY_in;
					ObjectStartX_out2 <= objectStartX_in+50;
					ObjectStartY_out2 <= ObjectStartY_in-50;
					ObjectStartX_out3 <= objectStartX_in+100;
					ObjectStartY_out3 <= ObjectStartY_in;
			end if;
			present_state <= next_state;
		end if;
		end process;
end behav;